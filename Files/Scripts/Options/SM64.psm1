function PatchOptionsSuperMario64() {
    
    if (IsChecked $Redux.Gameplay.FPS)       { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\fps.ppf" }
    if (IsChecked $Redux.Gameplay.FreeCam)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\cam.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptionsSuperMario64() {
    
    # HERO MODE

    if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "F207" -Values "80" }
    elseif (IsText -Elem $Redux.Hero.Damage -Compare "3x Damage")   { ChangeBytes -Offset "F207" -Values "40" }



    # GRAPHICS #
    if (IsChecked $Redux.Graphics.WideScreen) {
        ChangeBytes -Offset "3855E" -Values @("47", "40")
        ChangeBytes -Offset "35456" -Values @("46", "C0")
    }

    if (IsChecked $Redux.Graphics.BlackBars) {
        ChangeBytes -Offset "23A7" -Values @("BC", "00") -Interval 12
        ChangeBytes -Offset "248E" -Values "00"
        ChangeBytes -Offset "2966" -Values @("00", "00") -Interval 48
        ChangeBytes -Offset "3646A" -Values "00"
        ChangeBytes -Offset "364AA" -Values "00"
        ChangeBytes -Offset "364F6" -Values "00"
        ChangeBytes -Offset "36582" -Values "00"
        ChangeBytes -Offset "3799F" -Values @("BC", "00") -Interval 12
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw) {
        ChangeBytes -Offset "1007F0" -Values @("00", "00", "00", "00") # Solid objects
        ChangeBytes -Offset "1008B8" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "1008D0" -Values @("00", "00", "00", "00")

        ChangeBytes -Offset "66FE6" -Values @("46", "9C", "44", "81", "50", "00") # Coin formations
        ChangeBytes -Offset "66F56" -Values @("46", "9C")
    }

    if (IsChecked $Redux.Graphics.ForceHiresModel)         { ChangeBytes -Offset "32184" -Values @("10", "00") }

    

    # GAMEPLAY #
    if (IsChecked $Redux.Gameplay.LagFix)                  { ChangeBytes -Offset "F0022" -Values "0D" }
    if (IsChecked $Redux.ExitLevelAnytime)                 { ChangeBytes -Offset "97B74" -Values @("00", "00", "00", "00") }



    # INTERFACE #
    if (IsChecked $Redux.UI.HideHUD) {
        ChangeBytes -Offset "9EB69" -Values @("11", "80", "34", "82", "31", "AF", "A1", "24", "12", "00", "20", "16", "51", "00", "68", "00", "00", "00", "00")
        PatchBytes  -Offset "9EDA0" -Patch "Hide HUD.bin"
    }



    # SKIP #

    if (IsChecked $Redux.Skip.Opening) {
        ChangeBytes -Offset "6BD4" -Values @("24", "00"); ChangeBytes -Offset "6D90" -Values @("24", "10", "00", "00")
        ChangeBytes -Offset "4B7C" -Values @("24", "00"); ChangeBytes -Offset "4924" -Values @("10", "00")
    }

    if (IsChecked $Redux.Skip.MarioScreen) {
        ChangeBytes -Offset "269F4C" -Values @("34", "04", "00", "00", "01", "10", "00", "14", "00", "26", "9E", "A0", "00", "26", "A3", "A0", "14", "00", "02", "0C")
        ChangeBytes -Offset "269FD8" -Values @("34", "04", "00", "00", "01", "10", "00", "14", "00", "26", "9E", "A0", "00", "26", "A3", "A0", "14", "00", "02", "0C")
    }

    if (IsChecked $Redux.Skip.BoosDialogue) {
        ChangeBytes -Offset "3F330" -Values @("A7", "20", "00", "74") # Boo
        ChangeBytes -Offset "7F774" -Values @("A7", "20", "00", "74") # Big Boo
    }

    if (IsChecked $Redux.Skip.StarMessages)                { ChangeBytes -Offset "123F8" -Values @("10", "00") }
    if (IsChecked $Redux.Skip.TitleScreen)                 { ChangeBytes -Offset "269ECC" -Values @("34", "04", "00", "00", "01", "10", "00", "14", "00", "26", "9E", "A0", "00", "26", "A3", "A0", "14", "00", "00", "78") }

}



#==============================================================================================================================================================================================
function CreateOptionsSuperMario64() {
    
    CreateOptionsDialog -Width 740 -Height 440

    # HERO MODE #
    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"           -Column 1 -Row 1 -Items @("1x Damage", "2x Damage", "3x Damage") -Text "Damage:" -Info "Set the amount of damage you receive"

    # GRAPHICS #
    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen"       -Column 1 -Row 1 -Text "16:9 Widescreen [!]"     -Info "Native 16:9 Widescreen Display support`n[!] Requires Dolphin's or GlideN64's internal Widescreen Hack"                                    -Credits "Theboy181 (RAM) & Admentus (ROM)"
    CreateReduxCheckBox -Name "BlackBars"        -Column 2 -Row 1 -Text "No Black Bars"           -Info "Removes the black bars shown on the top and bottom of the screen"                                                                         -Credits "Theboy181 (RAM) & Admentus (ROM)"
    CreateReduxCheckBox -Name "ExtendedDraw"     -Column 3 -Row 1 -Text "Extended Draw Distance"  -Info "Increases the game's draw distance for solid objects with collision`nIncludes coin formations as well"                                    -Credits "Theboy181 (RAM) & Admentus (ROM)"
    CreateReduxCheckBox -Name "ForceHiresModel"  -Column 4 -Row 1 -Text "Force Hires Mario Model" -Info "Always use Mario's High Resolution Model when Mario is too far away"                                                                      -Credits "Theboy181 (RAM) & Admentus (ROM)"

    # GAMEPLAY #
    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "FPS"              -Column 1 -Row 1 -Text "60 FPS"                  -Info "Increases the FPS from 30 to 60`nWitness Super Mario 64 in glorious 60 FPS"                                                               -Credits "Kaze Emanuar"
    CreateReduxCheckBox -Name "FreeCam"          -Column 2 -Row 1 -Text "Analog Camera"           -Info "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Left / Right for the Analog stick"       -Credits "Kaze Emanuar"
    CreateReduxCheckBox -Name "LagFix"           -Column 3 -Row 1 -Text "Lag Fix"                 -Info "Smoothens gameplay by reducing lag"                                                                                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "ExitLevelAnytime" -Column 4 -Row 1 -Text "Exit Level Anytime"      -Info "Exit the level at any time without the need for standing still"                                                                           -Credits "Ported from SM64 ROM Manager"

    # INTERFACE #
    CreateReduxGroup    -Tag  "UI"-Text "Interface"
    CreateReduxCheckBox -Name "HideHUD"           -Column 1 -Row 1 -Text "Hide HUD"               -Info "Hide the HUD by default and press L to make it appear`nEnable the 'Remap L Button' VC option when patching a WAD"                         -Credits "Ported from SM64 ROM Manager"

    # SKIP #
    CreateReduxGroup    -Tag  "Skip" -Text "Skip" -Height 2
    CreateReduxCheckBox -Name "Opening"          -Column 1 -Row 1 -Text "Skip Opening"            -Info "Skip the introduction cutscene sequence when starting a new save file"                                                                    -Credits "Ported from SM64 ROM Manager"
    CreateReduxCheckBox -Name "StarMessages"     -Column 2 -Row 1 -Text "Skip Star Messages"      -Info "Skip the messages displayed after collecting specific numbers of stars"                                                                   -Credits "Ported from SM64 ROM Manager"
    CreateReduxCheckBox -Name "TitleScreen"      -Column 3 -Row 1 -Text "Skip Title Screen"       -Info "Skip the title screen shown when booting the game`nThis option only works when modifying the vanilla Super Mario 64 game"                 -Credits "Ported from SM64 ROM Manager"
    CreateReduxCheckBox -Name "MarioScreen"      -Column 4 -Row 1 -Text "Skip Mario Screen"       -Info "Skip the screen which displays Mario's face and the title in the background`nAlso applies to the screen displayed after losing all lives" -Credits "Ported from SM64 ROM Manager"
    CreateReduxCheckBox -Name "BoosDialogue"     -Column 1 -Row 2 -Text "Remove Boos Dialogue"    -Info "Removes the dialogue for defeating Boos or when the Big Boo appears"                                                                      -Credits "Ported from SM64 ROM Manager"



    $Redux.Gameplay.FPS.Add_CheckStateChanged({ $Redux.Gameplay.FreeCam.Enabled = !$this.Checked })
    $Redux.Gameplay.FreeCam.Add_CheckStateChanged({ $Redux.Gameplay.FPS.Enabled = !$this.Checked })
    $Redux.Gameplay.FPS.Enabled = !$Redux.FreeCam.Checked
    $Redux.Gameplay.FreeCam.Enabled = !$Redux.Gameplay.FPS.Checked

    $Redux.Skip.TitleScreen.Enabled = $GamePatch.title -eq "Super Mario 64"

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsSuperMario64
Export-ModuleMember -Function ByteOptionsSuperMario64

Export-ModuleMember -Function CreateOptionsSuperMario64