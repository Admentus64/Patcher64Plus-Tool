function PatchOptions() {

    if (IsChecked $Redux.Main.DualEyes)   { ApplyPatch -Patch "Compressed\Optional\dual_eyes.bps" } # Dual Eyes Cooperative
    if (IsChecked $Redux.Main.Mouse)      { ApplyPatch -Patch "Compressed\Optional\n64_mouse.ips" } # N64 Mouse

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # MAIN #
    
    if (IsChecked $Redux.Main.Mouse) { # N64 Mouse
        $offset = SearchBytes -Values "00 10 03 E0 00 08 01 65 10 24 AD 20 AD C8 3C 09"
        ChangeBytes -Offset $offset -Values "40 00"
    }

    if (IsChecked $Redux.Main.Levels) { ChangeBytes -Offset "C5B44" -Values "34 02 00 01" } # Unlock Levels
    


    # HUD #

    if (IsIndex $Redux.HUD.Cursor -Not) { # Cursor
        $offset = SearchBytes -Start "B4EF00" -End "B69000" -Values "00 02 02 04 B6 00 10 7C 03 F4 65 BF FF F8 07 FF 00 FF E0 1F C4 09 95 FE 00 91 0C A7 9B ED F8 F7 6D 23 00 DF CA 0D DC FF 7F B4 9A 6F F6 53 FD FE"
        PatchBytes -Offset $offset -Patch ("Cursors\" + $Redux.HUD.Cursors.Text.replace(" (default)", "") + ".bin") -Texture
    }

    if (IsChecked $Redux.HUD.ShowCrosshair) { ChangeBytes -Offset "9F128" -Values "20 0E 00 00" } # Always Show Crosshair

    if (IsChecked $Redux.HUD.MissionTimer) { # Mission Timer
        ChangeBytes -Offset "8AD44" -Values "00 00 70 25"; ChangeBytes -Offset "8AD60" -Values "C6 02 F9 70 46 80 10 A0"; ChangeBytes -Offset "BF2DC" -Values "10 00"
    }

    if (IsChecked $Redux.HUD.BriefingTime) { # Briefing Time
        ChangeBytes -Offset "4B7D4"  -Values "24 0A 00 00 0B C3 4C 63 00 18 C0 80";
        ChangeBytes -Offset "4B7E2"  -Values "00 00";
        ChangeBytes -Offset "4B80A"  -Values "00 00";
        ChangeBytes -Offset "4B80E"  -Values "00 00";
        ChangeBytes -Offset "107CBC" -Values "3C 06"
        ChangeBytes -Offset "107CBF" -Values "00 35 4A 80 00 00 0A 30 21 01 E6 30 2B 50 C0";
        ChangeBytes -Offset "107CCF" -Values "01 24 0F 7F FF 00 0F 7C 00 00 0F 7C 03 44 8F A0 00 46 80 A5 21 00 08 7C"
        ChangeBytes -Offset "107CE9" -Values "0F 7C 03 44 88 B0 00 46 80 B5 A1 46 36 A6 03 44 06 C8 00 3C 0F 25 2E 25 EF 33 66 AC AF 18 0C";
        ChangeBytes -Offset "107D09" -Values "0F 20 53 25 EF 65 63 AC AF 18 10";
        ChangeBytes -Offset "107D15" -Values "0F 73 00 AC AF 18 14 0B C0 5B 2C 02 18 C8 21"
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 3 -Height 460

    $Redux.Main.DualEyes.Add_CheckedChanged( { LockOptions })
    LockOptions

}



#==============================================================================================================================================================================================
function CreateTabMain() {
    
    CreateReduxGroup    -Tag  "Main" -Text "Main"
    CreateReduxCheckBox -Name "DualEyes" -Text "Dual Eyes Cooperative" -Info "Adds cooperative support to GoldenEye`nVersion 2.0"                                                                    -Credits "Rucksack Gamer, pavarini, SubDrag & Zoinkity"
    CreateReduxCheckBox -Name "Mouse"    -Text "N64 Mouse"             -Info "Enable N64 mouse for port 2`nIn-game controls are hardcoded to 1.2 scheme`nUse Controller in port 1 to navigate menus" -Credits "Carnivorous"
    CreateReduxCheckBox -Name "Levels"   -Text "Unlock Levels"         -Info "Unlock all singleplayer and multiplayer levels"                                                                        -Credits "Elfor & Carnivorous"

    CreateReduxGroup    -Tag  "HUD" -Text "HUD"
    CreateReduxComboBox -Name "Cursor"        -Text "Cursor" -Items @("GoldenEye") -FilePath ($GameFiles.textures + "\Cursors") -Ext "bin" -Default "GoldenEye" -Info "Set the style for the cursor" -Credits "GhostlyDark (injects) & Intermission (HD assets)"
    CreateReduxCheckBox -Name "ShowCrosshair" -Text "Always Show Crosshair" -Info "Always show crosshair"                            -Credits "Coockie1173"
    CreateReduxCheckBox -Name "MissionTimer"  -Text "Mission Timer"         -Info "Display in-game mission timer"                    -Credits "Carnivorous"
    CreateReduxCheckBox -Name "BriefingTime"  -Text "Briefing Time"         -Info "Add milliseconds to the end results of a mission" -Credits "Carnivorous"

    CreateReduxGroup -Tag "HUD" -Text "Cursor Previews"    $Last.Group.Height = (DPISize 140)
    CreateImageBox -x 40 -y 30 -w 90 -h 90 -Name "CursorPreview"

    $Redux.HUD.Cursor.Add_SelectedIndexChanged( {
        $path = ($GameFiles.textures + "\Cursors\" + $Redux.HUD.Cursor.Text.replace(" (default)", "") + ".png")
        if (TestFile $path)   { SetBitMap -Path $path -Box $Redux.HUD.CursorPreview -Width 90 -Height 90 }
        else                  { $Redux.HUD.CursorPreview.Image = $null }
    } )
    $path = ($GameFiles.textures + "\Cursors\" + $Redux.HUD.Cursor.Text.replace(" (default)", "") + ".png")
    if (TestFile $path)   { SetBitMap -Path $path -Box $Redux.HUD.CursorPreview -Width 90 -Height 90 }
    else                  { $Redux.HUD.CursorPreview.Image = $null }

}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    CreateLanguageContent

}


#==============================================================================================================================================================================================
function LockOptions() {
    
    EnableForm -Form $Redux.Main.Mouse   -Enable (!$Redux.Main.DualEyes.Checked)
    for ($i=0; $i -lt $Redux.Language.Count/2; $i++) { EnableForm -Form $Redux.Language[$i] -Enable (!$Redux.Main.DualEyes.Checked) }

}