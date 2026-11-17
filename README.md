# Riftbound Showdown Calc — Android

Showdown calculator for Riftbound (two players facing each other, Might / damage assignment, EN / VI,
Legacy and Modern themes). This folder wraps the web app in a small Android WebView app.

- **Use it in the browser / install as a web app:** https://bntienhuy96-png.github.io/riftbound-showdown/
  (Chrome → ⋮ → *Install app* / *Add to Home screen*; works offline after the first visit)
- **Android APK:** every push builds one — open the *Actions* tab → latest *Build APK* run → artifact `RiftboundShowdown-apk`
- Web source: `web/showdown-calc.html` · Web app build: `docs/` (GitHub Pages) · Android app: `app/`

## Features
- Two players facing each other on one phone: the top half is rotated 180°
- Pick sides, add units, set Might, apply Buff / Gear / Reaction / Spell / Assault / Shield
- Tank, B-line (Backline), Stun, damage taken before combat
- Damage assignment with rule checks (Tank first, B-line last, lethal before moving on)
- Showdown resolve animation: CONQUERED / DEFENDED
- English / Tiếng Việt · Legacy and Modern (light / dark) themes

## Build (Windows, PowerShell)
Uses the portable tools on drive E (`E:\android-build-tools`, `E:\gradle-cache`), same as FloatUndo.
```powershell
.\build.ps1
```
Output: `RiftboundShowdown.apk` in this folder, plus the GitHub Pages site in `docs/`. Bump `versionCode` in `app/build.gradle` for every new release.
Reinstalling over an older version needs the same debug key: `%USERPROFILE%\.android\debug.keystore`.

## Install on phone / tablet
Copy the APK to the device and open it; allow installing from that source if asked.
