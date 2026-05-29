# 🔱 EXODIA OS — Concept Security Spin for Parrot OS

> *"Tant que les cinq membres sont réunis, l'attaquant est invincible."*  
> **— Hommage à Exodia Necross & msfvenom**

---

## 📌 À propos

**Exodia OS** est un **ensemble de scripts, aliases et thèmes** pour **Parrot OS** (Debian Testing).  
Il ne s'agit PAS d'une distribution séparée, mais d'une **surcharge stylistique et fonctionnelle** légère.

⚠️ **Ce projet est éducatif et conceptuel.** Aucune fonctionnalité d'évasion antivirale, d'invulnérabilité ou de persistance furtive n'est incluse.

---

## 🧩 Modules conceptuels

| Membre | Fonction | Outils associés |
|--------|----------|------------------|
| 👁️ Membre Gauche | Recon / OSINT | `nmap`, `theHarvester`, `maltego` |
| ⚡ Membre Droit | Exploit | `metasploit-framework`, `searchsploit` |
| 🔄 Membre Gauche II | Persistence | `cron`, `systemd` (usage légitime) |
| 📈 Membre Droit II | Privilege Esc. | `linpeas`, `winpeas`, `sudo -l` |
| 🧠 Tête | C2 | `msfvenom`, `venom` (génération légale) |

---

## ⚙️ Installation

```bash
git clone https://github.com/ralphwdamis-hub/exodia-os.git
cd exodia-os
chmod +x install.sh
sudo ./install.sh
