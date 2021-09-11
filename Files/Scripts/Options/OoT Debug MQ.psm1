function ByteOptions() {

    # DEBUG #

    if (IsChecked $Redux.Debug.TranslateMapSelect) {
        ExportAndPatch -Path "debug_map_select_1"  -Offset "BD1538" -Length "CC9"
        ExportAndPatch -Path "debug_map_select_2"  -Offset "BD2384" -Length "CC"
    }
    
    if (IsChecked $Redux.Debug.Speed2x)                 { ChangeBytes -Offset "B80AAB"  -Values "02" }
    if (IsChecked $Redux.Debug.DefaultZTargeting)       { ChangeBytes -Offset "BA168D"  -Values "01" }
    if (IsChecked $Redux.Debug.ForceHiresModel)         { ChangeBytes -Offset "C194D3"  -Values "00" }
    if (IsChecked $Redux.Debug.CowNoseRing)             { ChangeBytes -Offset "EF3E68"  -Values "00 00" }
    if (IsChecked $Redux.Debug.TranslateItemSelect)     { ExportAndPatch -Path "debug_item_select" -Offset "BFE3D4" -Length "C8" }



    # REMOVE #

    if (IsChecked $Redux.DebugRemove.HUDColorsReversal) {
        ChangeBytes -Offset "7D5B55" -Values "64 FF" # Pause menu "Press A to ..."
        ChangeBytes -Offset "B7DBBB" -Values "96";          ChangeBytes -Offset "B7DBEF" -Values "FF";          ChangeBytes -Offset "B7DC15" -Values "38"; ChangeBytes -Offset "B7DC1D" -Values "38" # Ocarina Staff (Playing)
        ChangeBytes -Offset "BCAB6B" -Values "50 00 C8";    ChangeBytes -Offset "BCAB71" -Values "82 00 FF";    ChangeBytes -Offset "BCAB7D" -Values "82 00 FF" # Text Box Cursor
        ChangeBytes -Offset "BCAB85" -Values "50 00 00 00 C8" # Learned Ocarina Song Highlight
        ChangeBytes -Offset "BCAE4B" -Values "96 00 FF";    ChangeBytes -Offset "BCAE51" -Values "C8 00 FF";    ChangeBytes -Offset "BCAE5D" -Values "32 00 FF"
        ChangeBytes -Offset "BE3F9B" -Values "96 35 6B FF"; ChangeBytes -Offset "BE427B" -Values "96 35 4A FF"; ChangeBytes -Offset "BE456B" -Values "96 00 09 4C 03 35 6B FF" # Pause Menu Ocarina Notes
        ChangeBytes -Offset "BF0763" -Values "64 34 21 FF"; ChangeBytes -Offset "BF0933" -Values "64 34 21 FF" # Save / Game Over Selection
        ChangeBytes -Offset "BF9BC3" -Values "32 00 FF";    ChangeBytes -Offset "BF9C37" -Values "32 00 FF";    ChangeBytes -Offset "BF9C49" -Values "32 00 FF" # Pause Menu Select (A)
        ChangeBytes -Offset "E7C80C" -Values "30 6F";       ChangeBytes -Offset "E7C81C" -Values "01 AA" # Shop Selection Cursor
        ChangeBytes -Offset "B00322" -Values "C8 00";       ChangeBytes -Offset "B00326" -Values "00" # Start Button in HUD
        ChangeBytes -Offset "B8808B" -Values "96";          ChangeBytes -Offset "B8809D" -Values "E0";          ChangeBytes -Offset "B880AB" -Values "5A"; ChangeBytes -Offset "B880AD" -Values "0E" # A & B Buttons in HUD
        ChangeBytes -Offset "B880B5" -Values "20";          ChangeBytes -Offset "B880BF" -Values "FF";          ChangeBytes -Offset "B880E1" -Values "CF"
    }

    if (IsChecked $Redux.DebugRemove.RestoreBlood)         { ChangeBytes -Offset "CB3A30" -Values "00 78 00 FF 00 78 00 FF"; ChangeBytes -Offset "CD21A4" -Values "00 78 00 FF 00 78 00 FF" }
    if (IsChecked $Redux.DebugRemove.NormalFile1)          { ChangeBytes -Offset "B20434" -Values "00 00 00 00"; ChangeBytes -Offset "BDF648" -Values "10 00"; ChangeBytes -Offset "B20488" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.MapSelect)            { ChangeBytes -Offset "B3D954" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.ItemSelect)           { ChangeBytes -Offset "BEEC23" -Values "00" }
    if (IsChecked $Redux.DebugRemove.FreeMovement)         { ChangeBytes -Offset "C1EC04" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.DebugCamera)          { ChangeBytes -Offset "AD0AA0" -Values "00 00 70 21"; ChangeBytes -Offset "AD0AEC" -Values "10 00" }
    if (IsChecked $Redux.DebugRemove.RemoveWrongEquip)     { ChangeBytes -Offset "B1F9CC" -Values "00 00 00 00"; ChangeBytes -Offset "B1F9D0" -Values "00 00 00 00"; ChangeBytes -Offset "B1F9E0" -Values "00 00 00 00" }
    if (IsChecked $Redux.DebugRemove.RemoveWrongDisplay)   { ChangeBytes -Offset "B073DC" -Values "00 00 00 00" }
    if (IsChecked $Redux.DebugRemove.RemoveWrongIcon)      { ChangeBytes -Offset "BE8318" -Values "00 00 00 00" }



    # FIXES #

    if (IsChecked $Redux.DebugFix.SubscreenDelay)          { ChangeBytes -Offset "B36B6B"  -Values "03"; ChangeBytes -Offset "B3A994" -Values "00 00 00 00" }
    if (IsChecked $Redux.DebugFix.BoomerangFix)            { ChangeBytes -Offset "F6A718"  -Values "FC 41 C7 FF FF FF FE 38" }
    if (IsChecked $Redux.DebugFix.QuiverIcon)              { ChangeBytes -Offset "8C8EF2"  -Values "4C"; ChangeBytes -Offset "901C4E" -Values "4C"; ChangeBytes -Offset "93DD56" -Values "4C" }
    if (IsChecked $Redux.DebugFix.CreditsCrash)            { ChangeBytes -Offset "B33FF8"  -Values "10 00" }
    if (IsChecked $Redux.DebugFix.CenterNaviPrompt)        { ChangeBytes -Offset "B884E3"  -Values "F6" }
    if (IsChecked $Redux.DebugFix.HyruleGardenCrash)       { ChangeBytes -Offset "BA141D"  -Values "01"; ChangeBytes -Offset "3296D8C" -Values "08"; ChangeBytes -Offset "329771C"  -Values "08"; ChangeBytes -Offset "32977A4" -Values "09" }
    if (IsChecked $Redux.DebugFix.ZoraFountainCrash)       { ChangeBytes -Offset "2940A51" -Values "21"; ChangeBytes -Offset "2940A54" -Values "FF 39"; ChangeBytes -Offset "2940B81"  -Values "21" }
    if (IsChecked $Redux.DebugFix.KokiriForest)            { ChangeBytes -Offset "2898286" -Values "01 00"; ChangeBytes -Offset "2898806" -Values "01 50" }



    # GLITCH FIXES #

    if (IsChecked $Redux.DebugGlitch.WaterTempleKeyFlag)   { ChangeBytes -Offset "230B1E7" -Values "8D" }
    if (IsChecked $Redux.DebugGlitch.BottleDupe)           { ChangeBytes -Offset "B05A8F"  -Values "82"; ChangeBytes -Offset "C04EC8" -Values "A0 E0 06 9D" }
    if (IsChecked $Redux.DebugGlitch.SwordlessEpona)       { ChangeBytes -Offset "AFA364"  -Values "00 00 00 00"; ChangeBytes -Offset "AFA384" -Values "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" }
    if (IsChecked $Redux.DebugGlitch.InfiniteSword)        { ChangeBytes -Offset "C147B4"  -Values "A2 00 08 43"; ChangeBytes -Offset "C1A524" -Values "A2 00 08 43" }



    # ADDONS #

    if (IsChecked $Redux.Debug.ExpansionPak) {
        ChangeBytes -Offset "2CF0" -Values "03 E0 00 08"; ChangeBytes -Offset "2CF8" -Values "00 00"; ChangeBytes -Offset "2CFB" -Values "00"
        ChangeBytes -Offset "5DFC" -Values "AF A1 00 08 00 00 00 00"
        ChangeBytes -Offset "B0EF9F" -Values "20"; ChangeBytes -Offset "B0EFBF" -Values "20"; ChangeBytes -Offset "B0EFE7" -Values "20"; ChangeBytes -Offset "B0F00F" -Values "20"; ChangeBytes -Offset "B0F013" -Values "20"
        ChangeBytes -Offset "B33C5F" -Values "4D"; ChangeBytes -Offset "B415B3" -Values "74"
    }

    if (IsChecked $Redux.Debug.Speedup) {
        ChangeBytes -Offset "B74FE0" -Values "00 00 00 00"; ChangeBytes -Offset "B75094" -Values "00 00 00 00"; ChangeBytes -Offset "ACEE2C" -Values "00 00 00 00" # Stop Writing AB To Empty RAM Slots
        ChangeBytes -Offset "2CF0"   -Values "03 E0 00 08 00 00 00 00" # Remove printf Debug Function
        ChangeBytes -Offset "C09D78" -Values "10 00"                   # Remove Exception Handler on osStartThread
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Width 1050 -Height 470
    
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
    CreateReduxCheckBox -Name "NormalFile1"           -Text "Normal File 1"                      -Info "Remove the Debug Save Data from File 1`nAllowing to start a fresh game again"                                   -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "MapSelect"             -Text "Map Select"                         -Info "Remove the debug Map Select feature"                                                                            -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "ItemSelect"            -Text "Item Select"                        -Info "Remove the debug Item Select feature"                                                                           -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "FreeMovement"          -Text "Free Movement"                      -Info "Remove the debug Free Movement feature"                                                                         -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "DebugCamera"           -Text "Debug Camera"                       -Info "Remove the debug Camera feature"                                                                                -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "RemoveWrongEquip"      -Text "Master Sword Equip"                 -Info "Remove the debug Wrong Master Sword Equip feature"                                                              -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "RemoveWrongDisplay"    -Text "Master Sword Display"               -Info "Remove the debug Wrong Master Sword Display feature"                                                            -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "RemoveWrongIcon"       -Text "Hover Boots Icon"                   -Info "Remove the debug Wrong Hover Boots Icon feature"                                                                -Credits "ChriisTiian"



    CreateReduxGroup    -Tag  "DebugFix" -Text "Fixes"
    CreateReduxCheckBox -Name "SubscreenDelay"        -Text "Subscreen Delay "          -Checked -Info "Removes the delay when opening the Pause Screen, which fixes crash issues on emulator when ROM is decompressed" -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "BoomerangFix"          -Text "Boomerang Fix"                      -Info "Fix the gem color on the thrown boomerang"                                                                      -Credits "Aria"
    CreateReduxCheckBox -Name "QuiverIcon"            -Text "Quiver Icon"                        -Info "Properly display the Largest Quiver icon in dialogue when obtaining it"                                         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CreditsCrash"          -Text "Credits Crash"             -Checked -Info "Use the ingame scene for playing the credits rather than the prerendered credits video"                         -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "CenterNaviPrompt"      -Text "Center Navi Prompt"                 -Info 'Centers the "Navi" prompt shown in the C-Up button'                                                             -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "HyruleGardenCrash"     -Text "Hyrule Garden Crash"       -Checked -Info "Fix all GPU Errors and crashes when accessing the Early Hyrule Garden Game debug map"                           -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "ZoraFountainCrash"     -Text "Zora's Fountain Crash"     -Checked -Info "Fixes the crashes when loading cutscenes 01 and 02 through the Debug Map Select"                                -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "KokiriForest"          -Text "Kokiri Forest"                      -Info "Reduces the time when loading cutscenes 04 and 05 through the Debug Map Select"                                 -Credits "ChriisTiian"



    CreateReduxGroup    -Tag  "DebugGlitch" -Text "Glitch Fixes"
    CreateReduxCheckBox -Name "WaterTempleKeyFlag"    -Text "Water Temple Key Flag"              -Info "Fix the small key bug during the Water Temple"                                                                  -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "BottleDupe"            -Text "Bottle Dupe and Ocarina"            -Info "Fixes the Bottle Dupe Glitch and Ocarina Glitch"                                                                -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "SwordlessEpona"        -Text "Swordless Epona"                    -Info "Fixes the Swordless Epona Glitch"                                                                               -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "InfiniteSword"         -Text "Infnite Sword"                      -Info "Fixes the Infinite Sword Glitch"                                                                                -Credits "ChriisTiian"



    CreateReduxGroup    -Tag  "Debug" -Text "Addons"
    CreateReduxCheckBox -Name "ExpansionPak"          -Text "Expansion Pak"                      -Info "Allow Ocarina of Time to utilize the Expansion Pak for 8MB Memory"                                              -Credits "ChriisTiian"
    CreateReduxCheckBox -Name "Speedup"               -Text "Speedup"                            -Info "Speedup the game by removing certain debug commands for calculation"                                            -Credits "ChriisTiian"

}