function PatchOptionsSuperMario64() {
    
    # BPS Patching

    if (IsChecked -Elem $Options.FPS)                         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\fps.ppf" }
    if (IsChecked -Elem $Options.FreeCam)                     { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\cam.ppf" }

    if ( (IsText -Elem $Options.Model -Text "Improved Lowres Mario") -and ($GamePatch.title -eq "Super Mario 64") ) {
        ApplyPatch -File $GetROM.decomp -Patch "\Compressed\improved_lowres_mario.ppf"
    }
    if ( (IsText -Elem $Options.Model -Text "Luigi with Improved Lowres Model") -and ($GamePatch.title -eq "Super Mario 64") ) {
        ApplyPatch -File $GetROM.decomp -Patch "\Compressed\improved_lowres_luigi.ppf"
    }



    # Byte Patching

    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.decomp)


    # HERO MODE

    if (IsText -Elem $Options.Damage -Text "2x Damage")       { ChangeBytes -Offset "F207" -Values @("80") }
    elseif (IsText -Elem $Options.Damage -Text "3x Damage")   { ChangeBytes -Offset "F207" -Values @("40") }



    # GRAPHICS #
    if (IsChecked -Elem $Options.WideScreen) {
        ChangeBytes -Offset "3855E" -Values @("47", "40")
        ChangeBytes -Offset "35456" -Values @("46", "C0")
    }

    if (IsChecked -Elem $Options.BlackBars) {
        ChangeBytes -Offset "23A7" -Values @("BC", "00") -Interval 12
        ChangeBytes -Offset "248E" -Values @("00")
        ChangeBytes -Offset "2966" -Values @("00", "00") -Interval 48
        ChangeBytes -Offset "3646A" -Values @("00")
        ChangeBytes -Offset "364AA" -Values @("00")
        ChangeBytes -Offset "364F6" -Values @("00")
        ChangeBytes -Offset "36582" -Values @("00")
        ChangeBytes -Offset "3799F" -Values @("BC", "00") -Interval 12
    }

    if (IsChecked -Elem $Options.ExtendedDraw) {
        ChangeBytes -Offset "1007F0" -Values @("00", "00", "00", "00") # Solid objects
        ChangeBytes -Offset "1008B8" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "1008D0" -Values @("00", "00", "00", "00")

        ChangeBytes -Offset "66FE6" -Values @("46", "9C", "44", "81", "50", "00") # Coin formations
        ChangeBytes -Offset "66F56" -Values @("46", "9C")
    }

    if (IsChecked -Elem $Options.ForceHiresModel)             { ChangeBytes -Offset "32184" -Values @("10", "00") }

    

    # GAMEPLAY #
    if (IsChecked -Elem $Options.LagFix)                      { ChangeBytes -Offset "F0022" -Values @("0D") }
    if (IsChecked -Elem $Options.ExitLevelAnytime)            { ChangeBytes -Offset "97B74" -Values @("00", "00", "00", "00") }



    # INTERFACE #
    if (IsChecked -Elem $Options.HideHUD) {
        ChangeBytes -Offset "9EB69" -Values @("11", "80", "34", "82", "31", "AF", "A1", "24", "12", "00", "20", "16", "51", "00", "68", "00", "00", "00", "00")
        PatchBytes  -Offset "9EDA0" -Patch "Hide HUD.bin"
    }



    # SKIP #

    if (IsChecked -Elem $Options.SkipOpening) {
        ChangeBytes -Offset "6BD4" -Values @("24", "00"); ChangeBytes -Offset "6D90" -Values @("24", "10", "00", "00")
        ChangeBytes -Offset "4B7C" -Values @("24", "00"); ChangeBytes -Offset "4924" -Values @("10", "00")
    }

    if (IsChecked -Elem $Options.SkipMarioScreen) {
        ChangeBytes -Offset "269F4C" -Values @("34", "04", "00", "00", "01", "10", "00", "14", "00", "26", "9E", "A0", "00", "26", "A3", "A0", "14", "00", "02", "0C")
        ChangeBytes -Offset "269FD8" -Values @("34", "04", "00", "00", "01", "10", "00", "14", "00", "26", "9E", "A0", "00", "26", "A3", "A0", "14", "00", "02", "0C")
    }

    if (IsChecked -Elem $Options.RemoveBoosDialogue) {
        ChangeBytes -Offset "3F330" -Values @("A7", "20", "00", "74") # Boo
        ChangeBytes -Offset "7F774" -Values @("A7", "20", "00", "74") # Big Boo
    }

    if (IsChecked -Elem $Options.SkipStarMessages)                                                   { ChangeBytes -Offset "123F8" -Values @("10", "00") }
    if ( (IsChecked -Elem $Options.SkipTitleScreen) -and ($GamePatch.title -eq "Super Mario 64") )   { ChangeBytes -Offset "269ECC" -Values @("34", "04", "00", "00", "01", "10", "00", "14", "00", "26", "9E", "A0", "00", "26", "A3", "A0", "14", "00", "00", "78") }



    [io.file]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)

}



#==============================================================================================================================================================================================
function CreateSuperMario64OptionsContent() {
    
    CreateOptionsDialog -Width 740 -Height 480
    $ToolTip = CreateTooltip



     # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"
    
    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "3x Damage") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive" -Name "Damage"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen [!]"     -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support`n[!] Requires Dolphin's or GlideN64's internal Widescreen Hack" -Name "Widescreen"
    $Options.BlackBars                 = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance"  -ToolTip $ToolTip -Info "Increases the game's draw distance for solid objects with collision`nIncludes coin formations as well" -Name "ExtendedDraw"
    $Options.ForceHiresModel           = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Force Hires Mario Model" -ToolTip $ToolTip -Info "Always use Mario's High Resolution Model when Mario is too far away" -Name "ForceHiresModel"

    $Options.Model                     = CreateReduxComboBox -Column 0 -Row 2 -AddTo $GraphicsBox -Items @("Vanilla", "Improved Lowres Mario", "Luigi with Improved Lowres Model") -Text "Model:" -ToolTip $ToolTip -Info "Change the player character model`nThis option only works when modifying the vanilla Super Mario 64 game" -Length 200 -Name "Model" 


    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.FPS                       = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "60 FPS"                  -ToolTip $ToolTip -Info "Increases the FPS from 30 to 60`nWitness Super Mario 64 in glorious 60 FPS" -Name "FPS"
    $Options.FreeCam                   = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Analog Camera"           -ToolTip $ToolTip -Info "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Left / Right for the Analog stick" -Name "FreeCam"
    $Options.LagFix                    = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Lag Fix"                 -ToolTip $ToolTip -Info "Smoothens gameplay by reducing lag" -Name "LagFix"
    $Options.ExitLevelAnytime          = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GameplayBox -Text "Exit Level Anytime"      -ToolTip $ToolTip -Info "Exit the level at any time without the need for standing still" -Name "ExitLevelAnytime"



    # GAMEPLAY #
    $InterfaceBox                      = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.HideHUD                   = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $InterfaceBox -Text "Hide HUD"               -ToolTip $ToolTip -Info "Hide the HUD by default and press L to make it appear`nEnable the 'Remap L Button' VC option when patching a WAD" -Name "HideHUD"



    # SKIP #
    $SkipBox                           = CreateReduxGroup -Y ($InterfaceBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Skip"

    $Options.SkipOpening               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $SkipBox -Text "Skip Opening"                -ToolTip $ToolTip -Info "Skip the introduction cutscene sequence when starting a new save file" -Name "SkipOpening"
    $Options.SkipStarMessages          = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $SkipBox -Text "Skip Star Messages"          -ToolTip $ToolTip -Info "Skip the messages displayed after collecting specific numbers of stars" -Name "SkipStarMessages"
    $Options.SkipTitleScreen           = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $SkipBox -Text "Skip Title Screen"           -ToolTip $ToolTip -Info "Skip the title screen shown when booting the game`nThis option only works when modifying the vanilla Super Mario 64 game" -Name "SkipTitleScreen"
    $Options.SkipMarioScreen           = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $SkipBox -Text "Skip Mario Screen"           -ToolTip $ToolTip -Info "Skip the screen which displays Mario's face and the title in the background`nAlso applies to the screen displayed after losing all lives" -Name "SkipMarioScreen"
    $Options.RemoveBoosDialogue        = CreateReduxCheckBox -Column 0 -Row 2 -AddTo $SkipBox -Text "Remove Boos Dialogue"        -ToolTip $ToolTip -Info "Removes the dialogue for defeating Boos or when the Big Boo appears" -Name "RemoveBoosDialogue"



    $Options.FPS.Add_CheckStateChanged({ $Options.FreeCam.Enabled = !$this.Checked })
    $Options.FreeCam.Add_CheckStateChanged({ $Options.FPS.Enabled = !$this.Checked })
    $Options.FPS.Enabled = !$Options.FreeCam.Checked
    $Options.FreeCam.Enabled = !$Options.FPS.Checked

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsSuperMario64
Export-ModuleMember -Function CreateSuperMario64OptionsContent