Patcher64+ Tool

Patches the USA Virtual Console Ocarina of Time, Majora's Mask, Super Mario 64 or Paper Mario with the following:

- Custom injection (OoT, MM, SM64 & PP)
- Redux romhack (OoT & MM)
- Dawn & Dusk romhack (OoT)
- The Fate of the Bombiwa romhack (OoT)
- Masked Quest romhack (MM)
- Spanish Translation patch (OoT)
- Polish Translation patch (OoT & MM)
- Chinese Translation patch (OoT)
- Russian Translation patch (OoT & MM)
- Master Quest injection (OoT)
- 60 FPS romhack (SM64)
- Analog Camera romhack (SM64)
- Multiplayer romhack (SM64)
- Hard Mode romhack (PP)
- Hard Mode+ romhack (PP)
- Insane Mode romhack (PP)

It is also possible to:

- Inject a custom ROM into the VC WAD
- Patch the ROM contained within the VC WAD with a custom BPS/IPS patch file
- Only patch the VC WAD with the chosen selected modifications
- Extract the ROM contained within the VC WAD only
- Change to Free Mode so that any of the four options listed above can applied to any VC WAD titles

The Patch64+ Tool can switch to either Wii VC or Nintendo 64 mode. Wii VC mode handles VC WAD titles while Nintendo 64 mode handles .N64, .Z64 and .V64 roms directly. The output will be in .Z64. Nintendo 64 mode basically skips most of the code used in Wii VC mode therefore. Wii VC mode only handles N64 titles on the Wii VC currently.

Keep in mind that:

a) Patching Majora's Mask or Paper Mario requires their respective modes and not Free Mode, since both VC WAD titles have applied specific compression to their rom and boot dol.

b) Free Mode likely will not work on anything other than Nintendo 64 titles for the Virtual Console



====================
=== INSTRUCTIONS ===
====================

- To run this patcher, right click and select "Run with PowerShell".

- Select the current mode in the "Game Option" tab. Select Free to freely inject a ROM or freely patch a BPS or IPS patch file for any VC WAD file you have.

- Drag and Drop your WAD file or select it with the [...] button.

- Select checkboxes in the "Virtual Console - Patch Options" tab to apply specific patches to your VC WAD game. Certain patch buttons will force specific checkboxes from the "Virtual Console - Patch Options" tab

- The Channel Title and GameID can be overwritten be checking the checkbox. If unchecked, the Channel Title and GameID will follow default values as determined by the game patch buttons.

- The "Patch VC Emulator Only" options will only apply the chosen fixes from the "Virtual Console - Patch Options" tab. Custom Channel Title and GameID is also supported with this button.

- A custom ROM injection requires a .Z64 ROM to be set, either by Drag and Drop it or by selecting it with the [...] button.

- Free BPS or IPS patching requires a .BPS or .IPS Patch File to be set, either by Drag and Drop it or by selecting it with the [...] button.


- Press one of the game patch buttons for included premade patches. Alternatively press the Inject ROM button or Patch BPS button. Then wait for the patcher tool to finish.

- The patched WAD file is created in the same path as the original and the original is preserved.



====================================
=== VC PATCH OPTIONS DESCRIPTION ===
====================================

- Remove All T64		Remove all injected custom textures by the Virtual Console in the .T64 format
- Expand Memory			Expand the available RAM memory, but invalidates existing AR/Gecko codes
- Remap D-Pad			Remap the D-Pad to their four D-Pad button directions instead of toggling the minimap
- Downgrade			Downgrade Ocarina of Time from US 1.2 (default in VC WAD) to US 1.0
- Remap C-Down			Remap C-Down to toggle the minimap button
- Remap Z			Remap Z, ZL and ZR to toggle the minimap
- Leave D-Pad Up		Keep D-Pad for toggling the minimap



=======================================
=== OCARINA OF TIME / MAJORA'S MASK ===
=======================================

- The original GameID for OoT USA is NACE and the original GameID for MM is NARE, the patcher changes the GameID to a different value. This is so all versions of the game (patched and unpatched) can have their own settings and cheats.

- Patched games do not work with existing AR/Gecko codes, except for Dawn & Dusk.

- Enable optional checkboxes to remap the D-Pad to their actual D-Pad button instead of the minimap, expand the memory by 4MB for Ocarina of Time and Majora's Mask. Both Redux patches automaticially force the Remap D-Pad (OoT and MM) and Expand Memory (OoT) checkboxes. Masked Quest also forces the Remap D-Pad checkbox.



======================
=== SUPER MARIO 64 ===
======================

- The original GameID for SM64 USA is NAAE, this patch changes it to NAAX, NAAY or NAAM. This is so all versions of the game (patched and unpatched) can have their own settings and cheats.

- Mario camera does not work in 60 FPS. The game will not even allow you to switch to it.

- The demo intro is broke in in 60 FPS. Just skip it.

- Enabled the second emulated controller for the Analog Camera and Multiplayer patches.

- Bind the Control Stick of the second emulator controller to the secondary analog stick on your primary physical controller for the Analog Camera patch.

- Patched games can work with existing AR/Gecko codes. The Multiplayer v1.4.2 patch requires different AR/Gecko codes.

- To fix flickering textures:
	* Enable the CPU Clock Override and set it to 150% or higher.
	* Prefetch the texture pack.
	* Set Texture Cache to Safe



===================
=== PAPER MARIO ===
===================

- The original GameID for Paper Mario USA is NAEE, this patch changes it to NAA0, NAA1 or NAA2. This is so all versions of the game (patched and unpatched) can have their own settings and cheats.

- Hard Mode increases damage dealt by enemies by 1.5x
- Hard Mode+ increases damage dealt by enemies by 1.5x and increases their HP
- Insane Mode increases damage dealt by enemies by 2x

- Patched games can likely work with existing AR/Gecko codes.



===============
=== CREDITS ===
===============

--- Tools ---
Admentus (Mods Assemblage, Coding & Testing for Patcher64+)
Bighead (Custom Texture Tool & Initial Super Mario 64 - 60 FPS V2 Patcher)
GhostlyDark (Testing & Assistance)

--- Ocarina of Time REDUX (ROM Hack) ---
Maroc
ShadowOne
MattKimura
Roman971
TestRunnerSRL
AmazingAmpharos
Krimtonz
Fig
rlbond86
KevilPal
junglechief

--- Majora's Mask REDUX (ROM Hack) ---
Maroc
Saneki

--- MM Young Link Model for Ocarina of Time (ROM Patch) ---
slash004, The3Dude

--- MM Adult Link Model for Ocarina of Time (ROM Patch) ---
Skilar (https://youtu.be/x6MIeEZIsPw)

--- 16:9 Backgrounds for Ocarina of Time (ROM Patch) ---
GhostlyDark (Patch)
Admentus (Scripting and Assistance)

--- Dawn & Dusk (ROM Hack) ---
Captain Seedy-Eye (Lead Development, Music & Testing)
LuigiBlood (64DD Porting & Testing)
PK-LOVE
BWXIX
HylianModding (Discord Channel)
Hard4Games (Testing)
ZFG (Testing)
Dry4Haz (Testing)
Fig (Testing)

--- The Fate of the Bombiwa (ROM Hack) ---
DezZiBao

--- Majora's Mask: Masked Quest (ROM Hack) ---
Garo-Mastah
Aroenai
CloudMax
fkualol
VictorHale
Ideka
Saneki

--- Translations: Ocarina of Time ---
eduardo_a2j (Spanish v2.2)
RPG (Polish v1.3)
Zelda64rus (Russian v2.32)
madcell (Chinese Simplified 2009)

--- Translations: Majora's mask ---
RPG (Polish v1.1)
Zelda64rus (Russian v2.0 Beta)

--- Super Mario 64: 60 FPS v2 / Analog Camera (ROM Hack) ---
Kaze Emanuar

--- Super Mario 64: Multiplayer (ROM Hack) ---
Skelux

--- Paper Mario: Hard Mode / Insane Mode (ROM Hack) ---
Skelux (Extra Damage)
Knux5577 (Enemy HP)