function PatchOptions() {
    
    # MAIN #

    if (IsChecked $Redux.Main.MaxBombArrow)             { ApplyPatch -Patch "Compressed\Optional\max_bomb_arrow.ips"           }
    if (IsChecked $Redux.Main.MirrorWorksBothWorlds)    { ApplyPatch -Patch "Compressed\Optional\mirror_works_both_worlds.ips" }
    if (IsChecked $Redux.Main.MoveBlocksIndefinitely)   { ApplyPatch -Patch "Compressed\Optional\move_blocks_indefinitely.ips" }
    if (IsChecked $Redux.Main.RemoveLowHealthBeep)      { ApplyPatch -Patch "Compressed\Optional\remove_low_health_beep.ips"   }
    if (IsChecked $Redux.Main.StartFullHearts)          { ApplyPatch -Patch "Compressed\Optional\start_full_hearts.ips"        }
    if (IsChecked $Redux.Main.DeathCounterFix)          { ApplyPatch -Patch "Compressed\Optional\death_counter_fix.ips"        }
    if (IsChecked $Redux.Main.FastROM)                  { ApplyPatch -Patch "Compressed\Optional\fastrom.ips"                  }


    # GRAPHICS

    if (IsDefault $Redux.Graphics.LinkModel -Not) { ApplyPatch -Patch ("Compressed\Custom Models\" + $Redux.Graphics.LinkModel.Text + ".ips") }


    # TEXT #

    if  (IsChecked $Redux.Main.ReWizardized) { ApplyPatch -Patch "Compressed\Optional\rewizardized.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {

    # GFX #

    $gfx = "" # if (IsChecked $Redux.GFX.AltRedux) { $gfx = "_new_gfx" } else { $gfx = "" }

    if     (IsChecked $Redux.GFX.OptionalVideo)                                                 { ApplyPatch -Patch  "Compressed\Optional\optional_video.ips"                               }
    if   ( (IsChecked $Redux.GFX.GreenAgahnim) -and (IsChecked $Redux.GFX.TriforceSubtitle) )   { ApplyPatch -Patch ("Compressed\Optional\green_agahnim_triforce_subtitle" + $gfx + ".ips") }
    elseif (IsChecked $Redux.GFX.GreenAgahnim)                                                  { ApplyPatch -Patch ("Compressed\Optional\green_agahnim"                   + $gfx + ".ips") }
    elseif (IsChecked $Redux.GFX.TriforceSubtitle)                                              { ApplyPatch -Patch ("Compressed\Optional\triforce_subtitle"               + $gfx + ".ips") }



    # TEXT #

    if     (IsChecked $Redux.Text.Retranslated)           { ApplyPatch -Patch "Compressed\Optional\retranslated.ips"         }



    # REVERT #

    if     (IsChecked $Redux.Revert.DisableDashTurning)   { ApplyPatch -Patch "Compressed\Original\disable_dash_turning.ips" }
    if     (IsChecked $Redux.Revert.MaxBombArrow)         { ApplyPatch -Patch "Compressed\Optional\low_bomb_arrow.ips"       }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel @("Main")

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # MAIN #
    
    CreateReduxGroup    -Tag  "Main"                   -Text "Main"
    CreateReduxCheckBox -Name "MaxBombArrow"           -Text "Max Bombs & Arrows"          -Info "Increases maximum ammo amounts:`nBombs:20 up to 99`nArrows: 30 up to 99"     -Credits "Kazuto"
    CreateReduxCheckBox -Name "MirrorWorksBothWorlds"  -Text "Mirror Works in Both Worlds" -Info "The Mirror can be used in both the Light and Dark Worlds"                    -Credits "Redux Project"
    CreateReduxCheckBox -Name "MoveBlocksIndefinitely" -Text "Move Blocks Indefinitely"    -Info "Blocks which can be pushed can now be pushed several times"                  -Credits "Redux Project"
    CreateReduxCheckBox -Name "RemoveLowHealthBeep"    -Text "Remove Low Health Beep"      -Info "Completely remove the constant beeping that plays when you're low on hearts" -Credits "Redux Project"
    CreateReduxCheckBox -Name "StartFullHearts"        -Text "Start at Full Hearts"        -Info "Makes Link spawn with a full set of hearts upon save load"                   -Credits "Redux Project"
    CreateReduxCheckBox -Name "DeathCounterFix"        -Text "Death Counter Fix"           -Info 'Do not increment the death counter when using "Save and Quit"'               -Credits "Conn"
    CreateReduxCheckBox -Name "FastROM"                -Text "FastROM"                     -Info "Prevent slowdowns when too many sprites are on screen"                       -Credits "Wiiqwertyuiop" -Warning "Not compatible with Redux"


    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"  -Text "Graphics"
    CreateReduxComboBox -Name "LinkModel" -Text "Link Model" -Items @("Pink Hair", "Pink Hair (fixed)", "Blond Hair") -FilePath ($GameFiles.compressed + "\Custom Models") -Ext "ips" -Info ("Replace the model used for Link`n" + '"Pink Hair (fixed)"' + " fixes the gloves on Link's sprites") -Credits "Third M & ShadowOne333"



    # TEXT #

    CreateReduxGroup    -Tag  "Text"         -Text "Text"
    CreateReduxCheckBox -Name "ReWizardized" -Text "Re-Wizardized Script" -Info "Addresses some script changes, such as addressing Agahnim's role as 'Wizard' instead of 'Priest'" -Credits "Kyler Ashton" -Warning "Not compatible with Redux"



    $Patches.Redux.Add_CheckStateChanged( { EnableElem -Elem @($Redux.Main.FastROM, $Redux.Text.ReWizardized) -Active (!$Patches.Redux.Checked) } )
    EnableElem -Elem @($Redux.Main.FastROM, $Redux.Text.ReWizardized) -Active (!$Patches.Redux.Checked)

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # GFX #

    CreateReduxGroup    -Tag  "GFX"              -Text "GFX"
    CreateReduxCheckBox -Name "OptionalVideo"    -Text "Enable FMV for MSU-1"          -Info "Enable custom full motion video support for the MSU-1 chip`nCustom music support for the MSU-1 chip is already baked in with Redux itself" -Credits "Redux Project" -Warning "Wii VC does not support the MSU-1 chip"
    CreateReduxCheckBox -Name "GreenAgahnim"     -Text "Green Agahnim"                 -Info "Restore the color of Agahnim for Red and Blue to this original green robe"                                                                 -Credits "Redux Project"
    CreateReduxCheckBox -Name "TriforceSubtitle" -Text "Triforce of the Gods Subtitle" -Info "Replace the subtitle in the title screen to match the original Japanese subtitle"                                                          -Credits "Redux Project"



    # TEXT #

    CreateReduxGroup    -Tag "Text"          -Text "Text"
    CreateReduxCheckBox -Name "Retranslated" -Text "Retranslated Script" -Info "Provides a completely new and unique retranslation of the game's script provided by the Translation Quest team that is primarily faithful to the Japanese text" -Credits "ChickenKnife, Dattebayo & nejimakipiyo"



    # REVERT #

    CreateReduxGroup    -Tag  "Revert"             -Text "Original (Revert)"
    CreateReduxCheckBox -Name "DisableDashTurning" -Text "Disable Dash Turning"    -Info "Restore the Pegasus Boots dash mechanics to that of the original game"   -Credits "Nintendo"
    CreateReduxCheckBox -Name "LowBombArrow"       -Text "Original Bombs & Arrows" -Info "Restores maximum ammo amounts:`nBombs: 10 up to 50`nArrows: 30 up to 70" -Credits "Nintendo"

}