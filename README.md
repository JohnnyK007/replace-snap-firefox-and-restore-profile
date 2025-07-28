# 🦊 replace-snap-firefox-and-restore-profile.sh

Tento skript automatizuje odstránenie Snap verzie Firefoxu v Ubuntu Linux a jej nahradenie `.deb` verziou z oficiálneho Mozilla PPA repozitára. Zároveň zachová tvoj pôvodný profil používateľa (záložky, doplnky, heslá atď.).

This script automates the removal of the Snap version of Firefox on Ubuntu Linux and replacing it with the `.deb` version from the official Mozilla PPA repository. It will also preserve your original user profile (bookmarks, add-ons, passwords, etc.).

---

## 🛠️ Čo skript robí

1. **Zálohuje Snap profil Firefoxu** do priečinka `~/firefox_profile_backup`.
2. **Odpojí hunspell mount**, ktorý môže byť pripojený Snapom.
3. **Odstráni Snap verziu Firefoxu**, vrátane AppArmor profilov.
4. **Pridá Mozilla Team PPA** do systému.
5. **Nastaví APT pinovanie** na preferovanie `.deb` verzie Firefoxu.
6. **Povolí automatické aktualizácie** z PPA repozitára.
7. **Nainštaluje Firefox ako `.deb` balík** z repozitára.
8. **Obnoví profil používateľa** zo zálohy do `~/.mozilla/firefox/`.

---

## 📦 Požiadavky

- Distribúcia založená na **Ubuntu 22.04+ alebo 24.04** s predinštalovaným Snap Firefoxom
- Internetové pripojenie
- Administrátorské práva (`sudo`)

---

## 🔧 Inštalácia

```bash
git clone https://github.com/tvoje-meno/firefox-replace-script.git

cd firefox-replace-script

chmod +x replace-snap-firefox-and-restore-profile.sh
./replace-snap-firefox-and-restore-profile.sh
```
🔁 Obnovenie profilu

Ak sa Firefox po spustení javí ako "čistá inštalácia", môžeš ručne nastaviť pôvodný profil takto:

1. Skopíruj zálohovaný profil napr. do:

   `cp -r ~/firefox_profile_backup/<nazov_profilu> ~/.mozilla/firefox/myprofile.default`

2. Uprav súbor ~/.mozilla/firefox/profiles.ini, aby vyzeral takto:

```
[Install4F96D1932A9F858E]
Default=myprofile.default

[Profile0]
Name=myprofile
IsRelative=1
Path=myprofile.default
Default=1

[General]
StartWithLastProfile=1
Version=2
```

🌍 Slovenský jazyk

Ak chceš doinštalovať slovenčinu:

`sudo apt install firefox-locale-sk`

🖥️ Oprava spúšťača na ploche

Ak pôvodný `.desktop` súbor od Snapu na ploche nefunguje, môžeš ho nahradiť:

`rm ~/Plocha/firefox_firefox.desktop`    # alebo `~/Desktop/`

`cp /usr/share/applications/firefox.desktop ~/Plocha/`   # alebo `~/Desktop/`

✅ Overené na

   Ubuntu 24.04 LTS (Noble Numbat)

   Firefox Snap verzia 1:1snap1-*

   Firefox `.deb` verzia 141.0+build2 z MozillaTeam PPA

📄 Licencia

MIT License – Používaj slobodne a vylepšuj podľa potrieb.

🤝 Podpora

Ak skript pomohol, daj ⭐️ na GitHub a pokojne vytvor issue alebo pull request na vylepšenia.

