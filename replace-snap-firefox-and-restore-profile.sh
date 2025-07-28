#!/bin/bash
set -e

echo "===> 1. Zálohovanie Snap profilu Firefoxa..."

SNAP_PROFILE_ROOT="$HOME/snap/firefox/common/.mozilla/firefox"
BACKUP_DIR="$HOME/firefox_profile_backup"
MOZILLA_PROFILE_DIR="$HOME/.mozilla/firefox"

if [ -d "$SNAP_PROFILE_ROOT" ]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$SNAP_PROFILE_ROOT"/* "$BACKUP_DIR/"
    echo "✅ Profil zálohovaný do: $BACKUP_DIR"
else
    echo "⚠️  Snap profil nebol nájdený v: $SNAP_PROFILE_ROOT"
    exit 1
fi

echo "===> 2. Odpojenie hunspell mountu (ak existuje)..."
sudo systemctl stop var-snap-firefox-common-host\x2dhunspell.mount || true
sudo systemctl disable var-snap-firefox-common-host\x2dhunspell.mount || true
sudo umount /var/snap/firefox/common/host-hunspell 2>/dev/null || true

echo "===> 3. Odstraňovanie Snap verzie Firefoxa..."
sudo snap disable firefox || true
sudo snap remove --purge firefox || true

echo "===> 4. Odstraňovanie AppArmor profilov pre Snap Firefox..."
sudo rm -f /etc/apparmor.d/usr.bin.firefox
sudo rm -f /etc/apparmor.d/local/usr.bin.firefox

echo "===> 5. Pridanie Mozilla PPA..."
sudo add-apt-repository -y ppa:mozillateam/ppa

echo "===> 6. Nastavenie APT pinovania proti Snap verzii..."
sudo tee /etc/apt/preferences.d/mozilla-firefox <<EOF
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1

Package: firefox
Pin: version 1:1snap*
Pin-Priority: -1
EOF

echo "===> 7. Povolenie automatických aktualizácií z PPA..."
sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox <<EOF
Unattended-Upgrade::Allowed-Origins:: \"LP-PPA-mozillateam:\${distro_codename}\";
EOF

echo "===> 8. Aktualizácia a inštalácia Firefoxu z APT..."
sudo apt update
#sudo apt install -y firefox
sudo apt install -y firefox --allow-downgrades
# Nasledujúci riadok odblokuj ak chces podporu slovenčiny:
#sudo apt install firefox-locale-sk

# Oprava spúšťača na ploche:
# rm ~/Plocha/firefox_firefox.desktop
# alebo
# rm ~/Desktop/firefox_firefox.desktop
#cp /usr/share/applications/firefox.desktop ~/Plocha/
# alebo
# cp /usr/share/applications/firefox.desktop ~/Desktop/

echo "===> 9. Obnovenie profilu zo zálohy..."
mkdir -p "$MOZILLA_PROFILE_DIR"
cp -rn "$BACKUP_DIR"/* "$MOZILLA_PROFILE_DIR/"
echo "✅ Profil obnovený do: $MOZILLA_PROFILE_DIR"

echo "🎉 HOTOVO! Firefox bol nainštalovaný ako .deb a tvoj profil bol úspešne presunutý zo Snap verzie."


echo "Pozor ak sa Firefox spustí bez pôvodných nastavení (doplnky, záložky a pod.) skopíruj zálohovaný profil ručne do /home/[user]/.mozilla/firefox/myprofile.default a oprav súbor /home/[user]/.mozilla/firefox/profiles.ini aby vyzeral nasledovne:"
echo "[Install4F96D1932A9F858E]"
echo "Default=myprofile.default"
echo ""
echo "[Profile0]"
echo "Name=myprofile"
echo "IsRelative=1"
echo "Path=myprofile.default"
echo "Default=1"
echo ""
echo "[General]"
echo "StartWithLastProfile=1"
echo "Version=2"
echo ""
echo "🎉🎉 HOTOVO!"