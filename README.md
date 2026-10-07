<p align="center">
  <picture>
    <img alt="bcl" src="./branding/bcl-logo-512.png" style="max-width:192px;width:100%">
  </picture>
</p>

<h1 align="center">BigCityLegacy Installer</h1>

<p>Standalone online installer/updater for <a href="https://github.com/LxgacyTeam/BigCityLegacy">BigCityLegacy</a> mod, powered by Inno Setup 7.x</p>

---
**Features:**
- Automatic installation and initial setup of BepInEx
- Automatic download and installation/update of the latest BigCityLegacy version
- Validation of BepInEx installation and game version check
- Custom configs in BigCityLegacy\config are not overwritten during updates
- Silent mode with self-deletion
---

**Custom startup flags:**
```
/GAME="path\to\game" - specify path to game folder
/SKIPEULA - skip 'Terms of use and legal provisions' page
/RUNGAME - launch game after successful installation. Works only with /SILENT or /VERYSILENT
/DISPOSABLE - automatic self-deletion of the installer after installation completes
```
In silent modes, all instances of the game terminate automatically without warning.

Silent update example:
```
BigCityLegacyInstaller.exe /GAME="game.exe" /VERYSILENT /SKIPEULA /RUNGAME /DISPOSABLE 
```
