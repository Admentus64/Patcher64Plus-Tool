Patcher64+ Tool
Join our Discord and feel free to contact us there.
List of credits are accessible within the Patcher64+ Tool.
Documentation and sources for Zelda 64 options can be found at:
- https://github.com/ShadowOne333/Zelda64-Redux-Documentation (General)
- https://docs.google.com/document/d/1_1f2GzzGdtVqykNaKJrupoz5nBW386EwNQIPbMo042I (Feminine Pronouns Script)
- www.youtube.com/user/skilarbabcock (Model Replacements)

--- Support or visit me ---
Discord:	https://discord.gg/P22GGzz
GitHub:		https://github.com/Admentus64
Patreon:	https://www.patreon.com/Admentus
PayPal:		https://www.paypal.com/paypalme/Admentus/

--- WARNING ---
If you're upgrading from a previous version and are using the settings.txt file from the previous version, you may encounter some issues. Removing or deleting the file from the folder and restarting fixes the issue.



===============
=== GENERAL ===
===============

Patches ROM or Virtual Console WAD files with patches.
The Patcher64+ Tool can switch to either Wii VC or Native mode.
Wii VC mode handles VC WAD titles while Native mode handles ROM files directly.
Native mode skips most of the code used in Wii VC mode, which results in a faster patching.
Supported ROM files can be found in .NES, .SFC, .SFM, .N64, .Z64 and .V64
The Patcher64+ Tool only supports the N64, NES and SNES consoles currently.

Keep in mind that:

a) Patching Majora's Mask, Super Smash Bros., Paper Mario requires their respective modes and not Free Mode, since both VC WAD titles have applied specific compression to their ROM and Boot DOL.

b) Free Mode and Inject ROM will not work with ROMs not meant for their console mode for the Wii's Virtual Console

c) NES titles requires the console mode to be set to NES mode due to their ROM file being stored differently



===============
=== OPTIONS ===
===============

Options included:
- Change between Native Mode (uses regular ROM files) or Wii VC mode (uses .WAD files)
- Change between Consoles
- Change Game Mode for a different set of included patches
- Patch a ROM or Wii VC WAD file with one of the included patches in their respective game mode
- Patch a ROM or Wii VC WAD file with a custom BPS/IPS/Xdelta/VCDiff/PPF3 patch file

Wii VC Mode exclusive options incude:
- Inject a custom ROM into a Wii VC WAD
- Only patch the Wii VC WAD with the chosen selected modifications
- Extract the ROM contained within the Wii VC WAD only

The following games have included patches:
- The Legend of Zelda: Ocarina of Time (OoT)
- The Legend of Zelda: Majora's Mask (MM)
- Super Mario 64 (SM64)
- Paper Mario (PP)
- Super Smash Bros. (Smash)
- Mario Kart 64 (MK64)
- The Legend of Zelda: A Link to the Past (ALttP)
- Super Mario World (SMW)
- Super Metroid (SM)
- The Legend of Zelda (TLoZ)
- Zelda II: The Adventure of Link (TAoL)



===============
=== PATCHES ===
===============

The following patches are included:
- The Legend of Zelda: Dawn & Dusk (OoT)
- The Legend of Zelda: The Missing Link (OoT)
- The Legend of Zelda: Master of Time (OoT)
- The Fate of the Bombiwa (OoT)
- The Legend of Zelda: Nimpize Adventure (OoT)
- Ocarina of Time Puzzling (OoT)
- Majora's Mask: Masked Quest (MM)
- Majora's Mask: Master Quest (MM)
- SM64: Single-Screen / SM64: Split-Screen Multiplayer (SM64)
- SM64: Star Road / SM64: Star Road Single-Screen Multiplayer (SM64)
- SM64: Arguably Better Edition (SM64)
- SM64: Last Impact (SM64)
- Super Mario 64 Land (SM64)
- Super Mario Odyssey 64 (SM64)
- SM64: Ocarina of Time (SM64)
- Paper Mario: Hard Mode (PP)
- Paper Mario: Hard Mode+ (PP)
- Paper Mario: Insane Mode (PP)
- Super Smash Bros. Remix (Smash)
- CPUs use human items including shells (MK64)
- Parallel Worlds / Parallel Remodel (ALttP)
- Super Kaizo World 1/2/3 (SMW)



=============
=== EXTRA ===
=============

The following games have support for Redux:
- The Legend of Zelda: Ocarina of Time (OoT)
- The Legend of Zelda: Majora's Mask (MM)
- The Legend of Zelda: A Link to the Past (ALttP)
- Super Metroid (SM)
- The Legend of Zelda (TLoZ)
- Zelda II: The Adventure of Link (TAoL)

The Redux patch for The Legend of Zelda: A Link to the Past is shown as a patch option instead and thus always forced.

The following games have support for Additional Options:
- The Legend of Zelda: Ocarina of Time (OoT)
- The Legend of Zelda: Majora's Mask (MM)
- Super Mario 64 (SM64)
- The Legend of Zelda: A Link to the Past (ALttP)
- Super Metroid (SM)
- The Legend of Zelda (TLoZ)
- Zelda II: The Adventure of Link (TAoL)

Some other patches for Super Mario 64 also support Additional Options.

Ocarina of Time and Majora's Mask also have support for language selection.

Supported languages for Ocarina of Time include:
- English
- Japanese
- Spanish
- Polish
- Russian
- Chinese

Supported languages for Majora's Mask include:
- English
- Polish
- Russian

Redux patches aim to enhance the base experience of the game, such improved game mechanics and some other quality of life changes
For example having items on dedicated buttons (D-Pad) for Ocarina of Time and Majora's Mask.
Options offers smaller individual changes that can be applied individually from each other, such as Widescreen support.



====================
=== INSTRUCTIONS ===
====================

- To run this patcher, right click and select "Run with PowerShell".

- Select the current console and game in the "Current Game Mode" tab. Select "Free Game Selection" to freely inject a ROM or freely patch it with a patch file for any Wii VC WAD file you have.

- Drag and Drop your WAD file or select it with the [...] button.

- Select checkboxes in the "Virtual Console - Patch Options" tab to apply specific patches to your Wii VC WAD game. Certain patch buttons will force specific checkboxes from the "Virtual Console - Patch Options" tab

- Apply and customize Redux, Additional Options of Language if it is present for the current selected game and patch.

- The Game/Channel Title and GameID can be overwritten be checking the checkbox. If unchecked, the Game/Channel Title and GameID will follow default values as determined by the game patch buttons.

- The "Patch VC Emulator Only" options will only apply the chosen fixes from the "Virtual Console - Patch Options" tab. Custom Channel Title and GameID is also supported with this button.

- A custom ROM injection requires a ROM (.NES, .SFC, .SFM, .Z64, .N64 or .V64) to be set, either by Drag and Drop it or by selecting it with the [...] button.

- Free patching requires a patch file (.BPS, .IPS, .Xdelta, .VCDiff or .PPF3) to be set, either by Drag and Drop it or by selecting it with the [...] button.

- Press one of the game patch buttons for included premade patches. Alternatively press the Inject ROM button or Patch BPS button. Then wait for the patcher tool to finish.

- The patched ROM or WAD file is created in the same path as the original and the original is preserved.



==================================
=== PATCH OPTIONS DESCRIPTIONS ===
==================================

--- Checkboxes ---
- Enable Redux			Include the Redux patch into the selected patch. This checkbox is only shown if it is supported.
- Enable Options		Allow for the customization of the ROM. This checkbox is only shown if it is supported.
- Downgrade			Downgrade a ROM to the first revision, but only works with No-Intro US ROMs. This checkbox is only shown if it is supported.

--- Buttons ---
- Redux				Additional Options that are require the Redux patch can be customized in here
- Language			Different languages can be customized in here, as well as specific options that are language-dependant.
- Select Options		Additional Options in general can be fully customized in here
- Patch Selected Option		Run the patching process



=====================================
=== VC PATCH OPTIONS DESCRIPTIONS ===
=====================================

--- Checkboxes ---
- Remove All T64		Remove all injected custom textures by the Virtual Console in the .T64 format
- Remove Filter			Remove the dark filter injected by the Virtual Console to display the original N64 gamma
- Expand Memory			Expand the available RAM memory, but invalidates existing AR/Gecko codes
- Remap D-Pad			Remap the D-Pad to their four D-Pad button directions instead of toggling the minimap
- Remap L Button		Remap L to it's actual L button (ex. for showing the interface in SM64)
- Remap C-Down			Remap C-Down to toggle the minimap button
- Remap Z Button		Remap Z, ZL and ZR to toggle the minimap
- Leave D-Pad Up		Keep D-Pad for toggling the minimap

--- Buttons ---
- Patch VC Emulator Only	Only apply the VC Patch Options to the ROM, and nothing else.
- Extract ROM Only		Only extract the ROM from the WAD, and nothing else. Appears in the same folder as the WAD itself.