`I originally wrote this code in Notepad and haven’t been very active on Git. I’m uploading it here mainly to keep things transparent. Feel free to inspect the code.`
`Happy debugging`
<details>
<summary><strong>Why I Built This Module</strong></summary>


*I noticed a lot of people either selling leaked keyboxes or paying for modules that claim to pass strong Play Integrity but only offer leaked keyboxes. I created this module to give you **real**, **working keyboxes** completely **free**, no hidden charges, no scams, just **legit access** along with several useful features. 🚫🔑*
</details>


<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" alt="Catppuccin Footer" />
</p>

<div align="center">
  <a href="https://github.com/MeowDump/Integrity-Box/releases" target="_blank">
    <img src="DUMP/download.png" alt="Download Button" width="600" />
  </a>
</div>

## Module Features

> **This module offers the following features:**  

-  Updates valid `keybox.xml`  
-  Updates `target.txt` as per your TEE status
-  Hides debug fingerprint detection
-  Hides debug build detection
-  Re-freshes target list on every reboot for seamless exprience
-  Switch Shamiko & Nohello modes (via module toggle)
-  Guides users if their module setup is incorrect to pass play integrity
-  Adds all custom ROM detection packages in the **SusFS path**  
-  Disables EU injector by default  
-  Disables GMS ROM spoofing for  various cROMs 
-  Spoofs encryption status   
-  Spoofs ROM release key  
-  Spoofs SE Linux status
-  Updates PIF Fingerprint
-  Spoofs PIF Injection Values
-  Spoofs Tricky Store's Security Patch
-  Switches between AOSP & Valid keybox
-  FIXES Device not certified error
-  Shows banned keybox list
-  Set's verified boot hash via SusFs
-  Detects abnormal activity to help debug issues
-  Detects flagged & spoofed apps
-  More feature are there, check [WebUI](https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/webui.gif)

## Pre-Requirements

> Please make sure you have the following **modules installed** before using Integrity Box:

- [**Play Integrity Fork**](https://github.com/osm0sis/PlayIntegrityFork/releases) _or cROM's inbuilt gms spoofing_
- [**Tricky Store**](https://github.com/5ec1cff/TrickyStore/releases)
> Make sure to properly hide root & zygisk traces, otherwise you won't be able to pass play integrity verdicts

## Support
<table align="center" cellspacing="20" style="border: none;">
  <tr align="center">
    <td style="border: none;">
      <a href="https://t.me/MeowDump" target="_blank" style="border: none;">
        <img src="https://upload.wikimedia.org/wikipedia/commons/8/82/Telegram_logo.svg" alt="Join our Telegram Group" width="150" style="border: none;"><br>
        <code>Join help group</code>
      </a>
    </td>
    <td style="border: none;">
      <a href="https://github.com/MeowDump/Integrity-Box/blob/main/support.md" target="_blank" style="border: none;">
        <img src="https://www.svgrepo.com/show/194198/donate-donation.svg" alt="Support Developer" width="150" style="border: none;"><br>
        <code>Donate to Developer</code>
      </a>
    </td>
  </tr>
</table>

## Preview
<p align="center">
  <img 
    src="https://m3-markdown-badges.vercel.app/stars/7/1/MeowDump/Integrity-Box" 
    alt="GitHub Stars" 
  />
</p>

<table align="center">
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/installation.gif" alt="1" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/webui.gif" alt="2" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/webui2.gif" alt="3" style="max-width: 100%; height: auto;" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/5.gif" alt="4" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/action.png" alt="5" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/prop.png" alt="6" style="max-width: 100%; height: auto;" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/8.png" alt="7" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/2.png" alt="8" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/3.png" alt="9" style="max-width: 100%; height: auto;" /></td>
  </tr>
  <tr>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/4.png" alt="10" style="max-width: 100%; height: auto;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/pif.png" alt="11" style="max-width: 100%; height: 2400;" /></td>
    <td><img src="https://github.com/MeowDump/Integrity-Box/raw/main/DUMP/1.png" alt="12" style="max-width: 100%; height: auto;" /></td>
  </tr>
</table>

# Configuration
> You can control certain module features by configuring control center from WEBUI menu
![Flag](https://raw.githubusercontent.com/MeowDump/Integrity-Box/refs/heads/main/DUMP/flag.png)

# Emoji Results Meaning in module's description
> The main purpose of adding these was to centralize all Play Integrity-related info in one place, so users can spot issues in their setup and fix them on their own, without feeling lost or relying on others. I even saw people on Telegram charging money for this... LOL.

- **SELinux**
  - `🟢` — Enforcing  
  - `🔴` — Permissive
- **Kernel**
  - `🟢` — Can pass play integrity
  - `🔴` — [Banned Kernel](https://xdaforums.com/t/module-play-integrity-fix.4607985/page-518#post-89308909) Detected, Can't pass play integrity

- **TEE (Trusted Execution Environment)**
  - `🟢` — Intact  
  - `🔴` — Broken
  - `🟡` — Unknown

- **ROM Sign**
  - `🟢` — Release Key
  - `🔴` — Test Key
  - `🟡` — Unknown

- **Risky**
  - `This represents the number of risky/flagged apps installed in your device`
 
- **All**
  - `This represents the number of modules installed in your device`

- **Patch**
  - `This represents your Android Security Patch`
    
- **Pstore**
  - `This represents your Play Store Version`
 
- **Android**
  - `This represents your Android Version`

![Description](https://raw.githubusercontent.com/MeowDump/Integrity-Box/refs/heads/main/DUMP/description.png)

<details>
<summary><strong>Notes</strong></summary>

<br>
> Use Report a bug/issue button in WebUI to report bugs/issues

- Hide root properly if play integrity isn't passing for you. If you are using a custom rom, make sure you have disabled inbuilt gms spoofing. How to disable it? Well it depends on what rom you're using. Join your rom help group & ask `how to disable it` there.  
- Avoid conflicting or unnecessary modules that expose your root environment

</details>
