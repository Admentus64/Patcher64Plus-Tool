Patcher64+ Tool



===============
=== GENERAL ===
===============

Patches N64 ROM or Virtual Console WAD files with patches.
The Patch64+ Tool can switch to either Wii VC or Nintendo 64 mode.
Wii VC mode handles VC WAD titles while Nintendo 64 mode handles .N64, .Z64 and .V64 roms directly.
The output will be in .Z64. Nintendo 64 mode basically skips most of the code used in Wii VC mode therefore.
Wii VC mode only handles N64 titles on the Wii VC currently.

Keep in mind that:

a) Patching Majora's Mask or Paper Mario requires their respective modes and not Free Mode, since both VC WAD titles have applied specific compression to their rom and boot dol.

b) Free Mode likely will not work on anything other than Nintendo 64 titles for the Virtual Console



===============
=== OPTIONS ===
===============

Options included:
- Change Console Mode to N64 (uses .Z64, .N64 or .V64 ROM files) or Wii VC (uses .WAD files)
- Change Game Mode for a different set of included patches
- Patch a ROM or Wii VC WAD file with one of the included patches in their respective game mode
- Patch a ROM or Wii VC WAD file with a custom BPS/IPS patch file

Wii VC Mode exclusive options incude:
- Inject a custom ROM into a Wii VC WAD
- Only patch the Wii VC WAD with the chosen selected modifications
- Extract the ROM contained within the Wii VC WAD only

The following games have included patches:
- The Legend of Zelda: Ocarina of Time (OoT)
- The Legend of Zelda: Majora's Mask (MM)
- Super Mario 64 (SM64)
- Paper Mario (PP)
- Super Smash Bros. (Smash - N64 Mode Only)

The following patches are included:
- Redux (OoT & MM)
- Dawn & Dusk (OoT)
- The Fate of the Bombiwa (OoT)
- Nimpize Adventure (OoT)
- Ocarina of Time Puzzling (OoT)
- Masked Quest (MM)
- Spanish Translation (OoT)
- Polish Translation (OoT & MM)
- Chinese Translation (OoT)
- Russian Translation (OoT & MM)
- Master Quest injection (OoT)
- Single-Screen / Split-Screen Multiplayer (SM64)
- Star Road / Star Road Single-Screen Multiplayer (SM64)
- SM64: Last Impact (SM64)
- Super Mario 64 Land (SM64)
- Super Mario Odyssey 64 (SM64)
- SM64: Ocarina of Time (SM64)
- Hard Mode romhack (PP)
- Hard Mode+ romhack (PP)
- Insane Mode romhack (PP)
- Super Smash Bros. Remix romhack (Smash)

Redux patches can be applied on Translation patches as well and offer an additional set of additional customization options.
These additional customization options can be applied to some of the patches for OoT, MM and SM64.



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



=====================================
=== VC PATCH OPTIONS DESCRIPTIONS ===
=====================================

- Remove All T64		Remove all injected custom textures by the Virtual Console in the .T64 format
- Expand Memory			Expand the available RAM memory, but invalidates existing AR/Gecko codes
- Remap D-Pad			Remap the D-Pad to their four D-Pad button directions instead of toggling the minimap
- Downgrade			Downgrade Ocarina of Time from US 1.2 (default in the Wii VC WAD) to US 1.0
- Remap C-Down			Remap C-Down to toggle the minimap button
- Remap Z			Remap Z, ZL and ZR to toggle the minimap
- Leave D-Pad Up		Keep D-Pad for toggling the minimap