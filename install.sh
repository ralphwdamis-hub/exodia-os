#!/bin/bash

# EXODIA OS - Installer for Parrot OS
# Concept security spin - No malicious features

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════╗
║          E X O D I A   O S            ║
║     Concept Security Spin for Parrot  ║
╚═══════════════════════════════════════╝
EOF
echo -e "${NC}"

# Vérification root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Ce script doit être exécuté en root (sudo).${NC}"
   exit 1
fi

# Détection Parrot OS
if ! grep -q "Parrot" /etc/os-release 2>/dev/null; then
    echo -e "${YELLOW}[⚠] Système non identifié comme Parrot OS. Continuons quand même...${NC}"
fi

echo -e "${GREEN}[+] Installation des paquets requis...${NC}"
apt update
apt install -y \
    metasploit-framework \
    nmap \
    wireshark \
    exploitdb \
    figlet \
    toilet \
    neofetch

# Création des dossiers
echo -e "${GREEN}[+] Création des répertoires Exodia...${NC}"
mkdir -p /opt/exodia/{modules,configs}
mkdir -p /usr/local/share/exodia

# Copie des fichiers de config
echo -e "${GREEN}[+] Installation des configurations...${NC}"
cp configs/necrovenom_alias.sh /opt/exodia/configs/ 2>/dev/null || echo -e "${YELLOW}[⚠] Fichier configs/necrovenom_alias.sh manquant, ignoré${NC}"
cp configs/banner.txt /usr/local/share/exodia/ 2>/dev/null || echo -e "${YELLOW}[⚠] Fichier configs/banner.txt manquant, ignoré${NC}"

# Création du script exodia-status
echo -e "${GREEN}[+] Création de exodia-status...${NC}"
cat > /usr/local/bin/exodia-status << 'EOF'
#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${YELLOW}🔱 EXODIA OS — État des modules${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_tool() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

echo ""
echo "👁️  Membre Gauche (Recon)"
check_tool "nmap" "  - Nmap"
check_tool "theharvester" "  - theHarvester (optionnel)"

echo ""
echo "⚡ Membre Droit (Exploit)"
check_tool "msfconsole" "  - Metasploit"
check_tool "searchsploit" "  - Searchsploit"

echo ""
echo "🔄 Membre Gauche II (Persistence)"
echo "  - systemd : $(systemctl --version &>/dev/null && echo '✅' || echo '❌')"
echo "  - cron    : $(command -v cron &>/dev/null && echo '✅' || echo '❌')"

echo ""
echo "📈 Membre Droit II (PrivEsc)"
check_tool "sudo" "  - sudo"

echo ""
echo "🧠 Tête (C2)"
check_tool "msfvenom" "  - msfvenom"
echo ""
EOF
chmod +x /usr/local/bin/exodia-status

# Création de l'alias necrovenom
echo -e "${GREEN}[+] Création de necrovenom...${NC}"
cat > /usr/local/bin/necrovenom << 'EOF'
#!/bin/bash
# necrovenom - Wrapper stylisé pour msfvenom
# Aucune fonctionnalité malveillante ajoutée

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_banner() {
    echo -e "${BLUE}"
    figlet -f small "NecroVenom" 2>/dev/null || echo "=== NecroVenom ==="
    echo -e "${NC}"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ $# -eq 0 ]; then
    show_banner
    echo -e "${YELLOW}Exodia OS — Concept Wrapper for msfvenom${NC}"
    echo ""
    echo "Usage: necrovenom [msfvenom options]"
    echo ""
    echo "🔱 Mode Necross : Si les 5 modules sont installés, affiche un message stylisé."
    echo ""
    echo "Exemples :"
    echo "  necrovenom -l payloads"
    echo "  necrovenom -p windows/meterpreter/reverse_tcp LHOST=127.0.0.1 LPORT=4444 -f exe"
    echo ""
    echo -e "${RED}⚠️  Avertissement : Ce wrapper n'ajoute AUCUNE capacité d'évasion.${NC}"
    echo -e "${RED}   L'utilisateur est seul responsable de l'usage de msfvenom.${NC}"
    exit 0
fi

if ! command -v msfvenom &> /dev/null; then
    echo -e "${RED}[!] msfvenom non trouvé. Installez metasploit-framework.${NC}"
    exit 1
fi

echo -e "${GREEN}🔱 [Exodia OS] NecroVenom — Génération payload${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

msfvenom "$@"

EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Payload généré avec succès.${NC}"
    echo -e "${YELLOW}📌 Rappel : Utilisez ce fichier UNIQUEMENT sur des systèmes dont vous avez l'autorisation.${NC}"
fi
exit $EXIT_CODE
EOF
chmod +x /usr/local/bin/necrovenom

# Création du script exodia-banner
echo -e "${GREEN}[+] Création de exodia-banner...${NC}"
cat > /usr/local/bin/exodia-banner << 'EOF'
#!/bin/bash
if [ -f /usr/local/share/exodia/banner.txt ]; then
    cat /usr/local/share/exodia/banner.txt
else
    echo "🔱 EXODIA OS — Concept Security Spin"
fi
echo ""
echo "   Commandes : exodia-status, necrovenom -h"
EOF
chmod +x /usr/local/bin/exodia-banner

# Ajout des alias dans .bashrc global
echo -e "${GREEN}[+] Ajout des alias dans /etc/bash.bashrc...${NC}"
if ! grep -q "EXODIA OS ALIASES" /etc/bash.bashrc; then
    cat >> /etc/bash.bashrc << 'EOF'

# === EXODIA OS ALIASES ===
alias exodia='exodia-banner'
alias necro='necrovenom'
alias exo-status='exodia-status'
EOF
fi

echo ""
echo -e "${GREEN}✅ Installation terminée !${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Commandes disponibles :"
echo -e "  ${YELLOW}exodia-status${NC}  → État des modules"
echo -e "  ${YELLOW}necrovenom -h${NC}   → Wrapper msfvenom"
echo -e "  ${YELLOW}exodia-banner${NC}   → Afficher le logo"
echo ""
echo -e "${RED}⚠️  RAPPEL LÉGAL : Exodia OS n'ajoute AUCUNE capacité d'évasion.${NC}"
echo ""
echo "Redémarrez votre terminal ou exécutez : source /etc/bash.bashrc"
