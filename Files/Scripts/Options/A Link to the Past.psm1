function PatchOptions() {
    
    if       (IsChecked $Redux.Main.ReWizardized)                                     { ApplyPatch -Patch "Compressed\Optional\rewizardized.ips"   }
    if     ( (IsChecked $Redux.Main.KakarikoShortcut) -and !$Patches.Redux.Checked)   { ApplyPatch -Patch "Compressed\Optional\shortcut.ips" }
    elseif ( (IsChecked $Redux.Main.KakarikoShortcut) -and  $Patches.Redux.Checked)   { ApplyPatch -Patch "Compressed\Optional\shortcut_redux.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {

    $gfx = ""
    if (IsChecked $Redux.Gameplay.AltRedux) { $gfx = "_new_gfx" }

    if     (IsChecked $Redux.Main.OptionalVideo)                                                { ApplyPatch -Patch "Compressed\Optional\optional_video.ips" }

    if   ( (IsChecked $Redux.GFX.GreenAgahnim) -and (IsChecked $Redux.GFX.TriforceSubtitle) )   { ApplyPatch -Patch ("Compressed\Optional\green_agahnim_triforce_subtitle" + $gfx + ".ips") }
    elseif (IsChecked $Redux.GFX.GreenAgahnim)                                                  { ApplyPatch -Patch ("Compressed\Optional\green_agahnim" + $gfx + ".ips")                   }
    elseif (IsChecked $Redux.GFX.TriforceSubtitle)                                              { ApplyPatch -Patch ("Compressed\Optional\triforce_subtitle" + $gfx + ".ips")               }

    if     (IsChecked $Redux.Revert.PinkHair)                                                   { ApplyPatch -Patch "Compressed\Original\pink_hair.ips" }
    if     (IsChecked $Redux.Revert.DisableDashTurning)                                         { ApplyPatch -Patch "Compressed\Original\disable_dash_turning.ips"      }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 2 -Height 320

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # MAIN #

    CreateReduxGroup    -Tag "Main"              -Text "Main"
    CreateReduxCheckBox -Name "ReWizardized"     -Text "Re-Wizardized Script" -Info "Addresses some script changes, such as addressing Agahnim's role as 'Wizard' instead of 'Priest'" -Credits "Kyler Ashton" -Warning "Does not work with Redux"
    CreateReduxCheckBox -Name "KakarikoShortcut" -Text "Kakariko Shortcut"    -Info "Adds a shortcut to Kakariko Village for the Light and Dark World"                                 -Credits "PowerPanda"



    $Patches.Redux.Add_CheckStateChanged( { EnableForm -Form $Redux.Main.ReWizardized -Enable (!$Patches.Redux.Checked) } )
    EnableForm -Form $Redux.Main.ReWizardized -Enable (!$Patches.Redux.Checked)

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # GFX #

    CreateReduxGroup    -Tag "GFX"                 -Text "GFX"
    CreateReduxCheckBox -Name "AltRedux"           -Text "GFX Redux"                     -Info "Uses a different version of Redux that changes the GFX for the Inventory Menu"    -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "OptionalVideo"      -Text "Enable FMV for MSU"            -Info "Enable FMV video sequences for the MSU-1 SNES chip"                               -Credits "ShadowOne333 and his team" -Warning "Has no effect when using on the Wii VC"
    CreateReduxCheckBox -Name "GreenAgahnim"       -Text "Green Agahnim"                 -Info "Restore the color of Agahnim for Red and Blue to this original green robe"        -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "TriforceSubtitle"   -Text "Triforce of the Gods Subtitle" -Info "Replace the subtitle in the title screen to match the original Japanese subtitle" -Credits "ShadowOne333 and his team"



    # REVERT #

    CreateReduxGroup    -Tag "Revert"              -Text "Original (Revert)"
    CreateReduxCheckBox -Name "PinkHair"           -Text "Pink Hair"                     -Info "Restores the Pink Hair for Link to that of the original game"                     -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "DisableDashTurning" -Text "Disable Dash Turning"          -Info "Restore the Pegasus Boots dash mechanics to that of the original game "           -Credits "ShadowOne333 and his team"



    $Redux.Gameplay = @{}
    $Redux.Gameplay.AltRedux = $Redux.GFX.AltRedux

}