function ByteOptions() {

    # DEBUG #

    if (IsChecked $Redux.Debug.Speed2x)                 { ChangeBytes -Offset "B80ACB"  -Values "02" }
    if (IsChecked $Redux.Debug.DefaultZTargeting)       { ChangeBytes -Offset "BA16AD"  -Values "01" }
    if (IsChecked $Redux.Debug.ForceHiresModel)         { ChangeBytes -Offset "C194F3"  -Values "00" }
    if (IsChecked $Redux.Debug.CowNoseRing)             { ChangeBytes -Offset "D96C58"  -Values "00 00" }
    if (IsChecked $Redux.Debug.TranslateItemSelect)     { ExportAndPatch -Path "inventory_editor" -Offset "BFE3F4" -Length "C8" }
    if (IsChecked $Redux.Debug.TranslateMapSelect)      { ExportAndPatch -Path "debug_map_select" -Offset "BD1558" -Length "F16" }



    # REMOVE #

    if (IsChecked $Redux.DebugRemove.HUDColorsReversal) {
        ChangeBytes -Offset "7D5B55" -Values "64 FF" # Pause menu "Press A to ..."
        ChangeBytes -Offset "B7DBDB" -Values "96";          ChangeBytes -Offset "B7DC0F" -Values "FF";          ChangeBytes -Offset "B7DC35" -Values "38"; ChangeBytes -Offset "B7DC3D" -Values "38" # Ocarina Staff (Playing)
        ChangeBytes -Offset "BCAB8B" -Values "50 00 C8";    ChangeBytes -Offset "BCAB91" -Values "82 00 FF";    ChangeBytes -Offset "BCAB9D" -Values "82 00 FF" # Text Box Cursor
        ChangeBytes -Offset "BCABA5" -Values "50 00 00 00 C8" # Learned Ocarina Song Highlight
        ChangeBytes -Offset "BCAE6B" -Values "96 00 FF";    ChangeBytes -Offset "BCAE71" -Values "C8 00 FF";    ChangeBytes -Offset "BCAE7D" -Values "32 00 FF"
        ChangeBytes -Offset "BE3FBB" -Values "96 35 6B FF"; ChangeBytes -Offset "BE429B" -Values "96 35 4A FF"; ChangeBytes -Offset "BE458B" -Values "96 00 09 4C 03 35 6B FF" # Pause Menu Ocarina Notes
        ChangeBytes -Offset "BF0783" -Values "64 34 21 FF"; ChangeBytes -Offset "BF0953" -Values "64 34 21 FF" # Save / Game Over Selection
        ChangeBytes -Offset "BF9BE3" -Values "32 00 FF";    ChangeBytes -Offset "BF9C57" -Values "32 00 FF";    ChangeBytes -Offset "BF9C69" -Values "32 00 FF" # Pause Menu Select (A)
        ChangeBytes -Offset "E7C82C" -Values "30 6F";       ChangeBytes -Offset "E7C83C" -Values "01 AA" # Shop Selection Cursor
        ChangeBytes -Offset "B00322" -Values "C8 00";       ChangeBytes -Offset "B00326" -Values "00" # Start Button in HUD
        ChangeBytes -Offset "B880AB" -Values "96";          ChangeBytes -Offset "B880BD" -Values "E0";          ChangeBytes -Offset "B880CB" -Values "5A"; ChangeBytes -Offset "B880CD" -Values "0E" # A & B Buttons in HUD
        ChangeBytes -Offset "B880D5" -Values "20";          ChangeBytes -Offset "B880DF" -Values "FF";          ChangeBytes -Offset "B88101" -Values "CF"
    }

    if (IsChecked $Redux.DebugRemove.RestoreBlood)         { ChangeBytes -Offset "CB3AD0" -Values "00 78 00 FF 00 78 00 FF"; ChangeBytes -Offset "CD2244" -Values "00 78 00 FF 00 78 00 FF" }
    if (IsChecked $Redux.DebugRemove.NormalFile1)          { ChangeBytes -Offset "B20454" -Values "00 00 00 00"; ChangeBytes -Offset "BDF668" -Values "10 00"; ChangeBytes -Offset "B204A8" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.MapSelect)            { ChangeBytes -Offset "B3D974" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.ItemSelect)           { ChangeBytes -Offset "BEEC43" -Values "00" }
    if (IsChecked $Redux.DebugRemove.FreeMovement)         { ChangeBytes -Offset "C1EC24" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.DebugCamera)          { ChangeBytes -Offset "AD0AA0" -Values "00 00 70 21"; ChangeBytes -Offset "AD0AEC" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.RemoveWrongEquip)     { ChangeBytes -Offset "B1F9EC" -Values "00 00 00 00"; ChangeBytes -Offset "B1F9F0" -Values "00 00 00 00"; ChangeBytes -Offset "B1FA00" -Values "00 00 00 00" }
    if (IsChecked $Redux.DebugRemove.RemoveWrongDisplay)   { ChangeBytes -Offset "B073DC" -Values "00 00 00 00" }
    if (IsChecked $Redux.DebugRemove.RemoveWrongIcon)      { ChangeBytes -Offset "BE8338" -Values "00 00 00 00" }



    # FIXES #

    if (IsChecked $Redux.DebugFix.SubscreenDelay)          { ChangeBytes -Offset "B36B8B"  -Values "03"; ChangeBytes -Offset "B3A9B4" -Values "00 00 00 00" }
    if (IsChecked $Redux.DebugFix.QuiverIcon)              { ChangeBytes -Offset "8C8EF2"  -Values "4C"; ChangeBytes -Offset "901C4E" -Values "4C"; ChangeBytes -Offset "93DCFA" -Values "4C" }
    if (IsChecked $Redux.DebugFix.CreditsCrash)            { ChangeBytes -Offset "B34018"  -Values "10 00" }
    if (IsChecked $Redux.DebugFix.CenterNaviPrompt)        { ChangeBytes -Offset "B88503"  -Values "F6" }
    if (IsChecked $Redux.DebugFix.HyruleGardenCrash)       { ChangeBytes -Offset "BA143D"  -Values "01"; ChangeBytes -Offset "328AD8C" -Values "08"; ChangeBytes -Offset "328B71C"  -Values "08"; ChangeBytes -Offset "328B7A4" -Values "09" }
    if (IsChecked $Redux.DebugFix.ZoraFountainCrash)       { ChangeBytes -Offset "2934A51" -Values "00 00 00 00 00 00 00" }
    if (IsChecked $Redux.DebugFix.KokiriForest)            { ChangeBytes -Offset "288C286" -Values "01 00"; ChangeBytes -Offset "288C806" -Values "01 50" }



    # GLITCH FIXES #

    if (IsChecked $Redux.DebugGlitch.BottleDupe)           { ChangeBytes -Offset "B05A8F" -Values "82"; ChangeBytes -Offset "C04EE8" -Values "A0 E0 06 9D" }
    if (IsChecked $Redux.DebugGlitch.SwordlessEpona)       { ChangeBytes -Offset "AFA364" -Values "00 00 00 00"; ChangeBytes -Offset "AFA384" -Values "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" }
    if (IsChecked $Redux.DebugGlitch.InfiniteSword)        { ChangeBytes -Offset "C147D4" -Values "A2 00 08 43"; ChangeBytes -Offset "C1A544" -Values "A2 00 08 43" }



    # ADDONS #

    if (IsChecked $Redux.Debug.ExpansionPak) {
        ChangeBytes -Offset "2CF0" -Values "03 E0 00 08"; ChangeBytes -Offset "2CF8" -Values "00 00"; ChangeBytes -Offset "2CFB" -Values "00"
        ChangeBytes -Offset "5DFC" -Values "AF A1 00 08 00 00 00 00"
    }

    if (IsChecked $Redux.Debug.Speedup) {
        ChangeBytes -Offset "2CF0"   -Values "03 E0 00 08 00 00 00 00" # Remove printf Debug Function
        ChangeBytes -Offset "C09D98" -Values "10 00"                   # Remove Exception Handler on osStartThread
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 6 -Height 470
    
    # OTHER #
    CreateReduxGroup    -Tag  "Debug" -Text "Misc" 
    CreateReduxCheckBox -Name "Speed2x"               -Text "2x Text Speed"                      -Info "Set the dialogue text speed to be twice as fast"                                                                -Credits "Redux"
    CreateReduxCheckBox -Name "DefaultZTargeting"     -Text "Default Hold Z-Targeting"           -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                                -Credits "Redux"
    CreateReduxCheckBox -Name "ForceHiresModel"       -Text "Force Hires Link Model"    -Checked -Info "Always use Link's High Resolution Model when Link is too far away"                                              -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"           -Text "Restore Cow Nose Ring"              -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                        -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "TranslateMapSelect"    -Text "Translate Map Select"               -Info "Translates the Debug Map Select menu into English"                                                              -Credits "Jared Johnson (translated by Zelda Edit)"
    CreateReduxCheckBox -Name "TranslateItemSelect"   -Text "Translate Item Select"              -Info "Translates the Debug Inventory Select menu into English"                                                        -Credits "GhostlyDark"
    


    CreateReduxGroup    -Tag  "DebugRemove" -Text "Remove"
    CreateReduxCheckBox -Name "HUDColorsReversal"     -Text "HUD Colors Reversal"                -Info "Restore the HUD colors as used on the Nintendo 64 versions"                                                     -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "RestoreBlood"          -Text "Restore Blood"                      -Info "Restore the red blood for Ganondorf and Ganon as used in the Rev 0 & Rev 1 ROM"                                 -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "NormalFile1"           -Text "Normal File 1"                      -Info "Remove the Debug Save Data from File 1`nAllowing to start a fresh game again"                                   -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "MapSelect"             -Text "Map Select"                         -Info "Remove the debug Map Select feature"                                                                            -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ItemSelect"            -Text "Item Select"                        -Info "Remove the debug Item Select feature"                                                                           -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "FreeMovement"          -Text "Free Movement"                      -Info "Remove the debug Free Movement feature"                                                                         -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DebugCamera"           -Text "Debug Camera"                       -Info "Remove the debug Camera feature"                                                                                -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "RemoveWrongEquip"      -Text "Master Sword Equip"                 -Info "Remove the debug Wrong Master Sword Equip feature"                                                              -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "RemoveWrongDisplay"    -Text "Master Sword Display"               -Info "Remove the debug Wrong Master Sword Display feature"                                                            -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "RemoveWrongIcon"       -Text "Hover Boots Icon"                   -Info "Remove the debug Wrong Hover Boots Icon feature"                                                                -Credits "ChriisTiian & Ported by GhostlyDark"



    CreateReduxGroup    -Tag  "DebugFix" -Text "Fixes"
    CreateReduxCheckBox -Name "SubscreenDelay"        -Text "Subscreen Delay"           -Checked -Info "Removes the delay when opening the Pause Screen, which fixes crash issues on emulator when ROM is decompressed" -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "QuiverIcon"            -Text "Quiver Icon"                        -Info "Properly display the Largest Quiver icon in dialogue when obtaining it"                                         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CreditsCrash"          -Text "Credits Crash"             -Checked -Info "Use the ingame scene for playing the credits rather than the prerendered credits video"                         -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "CenterNaviPrompt"      -Text "Center Navi Prompt"                 -Info 'Centers the "Navi" prompt shown in the C-Up button'                                                             -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "HyruleGardenCrash"     -Text "Hyrule Garden Crash"       -Checked -Info "Fix all GPU Errors and crashes when accessing the Early Hyrule Garden Game debug map"                           -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ZoraFountainCrash"     -Text "Zora's Fountain Crash"     -Checked -Info "Fixes the crash that occurs when loading cutscene 01 through the Debug Map Select"                              -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "KokiriForest"          -Text "Kokiri Forest"                      -Info "Reduces the time when loading cutscenes 04 and 05 through the Debug Map Select"                                 -Credits "ChriisTiian & Ported by GhostlyDark"



    CreateReduxGroup    -Tag  "DebugGlitch" -Text "Glitch Fixes"
    CreateReduxCheckBox -Name "BottleDupe"            -Text "Bottle Dupe and Ocarina"            -Info "Fixes the Bottle Dupe Glitch and Ocarina Glitch"                                                                -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "SwordlessEpona"        -Text "Swordless Epona"                    -Info "Fixes the Swordless Epona Glitch"                                                                               -Credits "ChriisTiian & Ported by GhostlyDark"
    CreateReduxCheckBox -Name "InfiniteSword"         -Text "Infnite Sword"                      -Info "Fixes the Infinite Sword Glitch"                                                                                -Credits "ChriisTiian & Ported by GhostlyDark"



    CreateReduxGroup    -Tag  "Debug" -Text "Addons"
    CreateReduxCheckBox -Name "ExpansionPak"          -Text "Expansion Pak"                      -Info "Allow Ocarina of Time to utilize the Expansion Pak for 8MB Memory"                                              -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "Speedup"               -Text "Speedup"                            -Info "Speedup the game by removing certain debug commands for calculation"                                            -Credits "ChriisTiian"

}