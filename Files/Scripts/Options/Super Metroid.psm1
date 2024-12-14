function PatchOptions() {
    
    # GRAPHICS #

  # if (IsChecked $Redux.Graphics.Widescreen)        { ApplyPatch -Patch "Compressed\Optional\widescreen.ips"; Copy-Item -LiteralPath ($GameFiles.compressed + "\widescreen.bso") -Destination ($ROMFile.Patched.replace($ROMFile.Extension, ".bso")) -Force }
    if (IsChecked $Redux.Graphics.RedesignedSamus)   { ApplyPatch -Patch "Compressed\Optional\redesigned_samus.ips" }
    if (IsChecked $Redux.Graphics.DeathCensor)       { ApplyPatch -Patch "Compressed\Optional\death_censor.ips"     }

    if ( (IsChecked $Redux.Gameplay.NewControlsScheme -Not) -and (IsChecked $Redux.Revert.ControlsScheme -Not) ) { # Postpone until later when doing controls patching
        if (IsChecked $Redux.Graphics.DualSuit) {
            if (IsChecked $Redux.Graphics.RedesignedSamus)   { ApplyPatch -Patch "Compressed\Optional\redesigned_dual_suit.ips" }
            else                                             { ApplyPatch -Patch "Compressed\Optional\dual_suit.ips"            }
        }
    }



    # AUDIO #

    if (IsChecked $Redux.Audio.NoMusic) { ApplyPatch -Patch "Compressed\Optional\no_music.ips" }
    
    

    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.FixedUnlockedDoors)   { ApplyPatch -Patch "Compressed\Optional\fixed_tourian_unlocked_doors.ips"    }
    if (IsChecked $Redux.Gameplay.SaveStationsRefill)   { ApplyPatch -Patch "Compressed\Optional\save_stations_refill_everything.ips" }
    if (IsChecked $Redux.Gameplay.SpazerPlasmaMix)      { ApplyPatch -Patch "Compressed\Optional\spazer_plasma_mix.ips"               }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.SkipCeres) { ChangeBytes -Offset "16EB7" -Values "9C9F079C8B078002EAEA80" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.HeavyPhysics) { ApplyPatch -Patch "Compressed\Optional\heavy_physics.ips" }
    


    # ORIGINAL #

    if (IsChecked $Redux.Revert.Demos) {
        if (IsChecked $Redux.Revert.HeavyPhysics)   { ApplyPatch -Patch "Compressed\Original\demos_heave_physics.ips" }
        else                                        { ApplyPatch -Patch "Compressed\Original\demos.ips"               }
    }

    if ( (IsChecked $Redux.Revert.ColoredDoorsMap) -and (IsChecked $Redux.Revert.ControlsScheme) ) { ApplyPatch -Patch "Compressed\Original\reduced_map_info.ips" }
    else {
        if (IsChecked $Redux.Revert.ColoredDoorsMap)   { ApplyPatch -Patch "Compressed\Original\colored_doors_map.ips" }
        if (IsChecked $Redux.Revert.BossTilesMap)      { ApplyPatch -Patch "Compressed\Original\boss_tiles_map.ips"    }
    }



    # CONTROLS (APPLY LAST)
    
    if (IsChecked $Redux.Gameplay.NewControlsScheme)   { ApplyPatch -Patch "Compressed\Optional\new_controls_scheme.ips" }
    if (IsChecked $Redux.Revert.ControlsScheme)        { ApplyPatch -Patch "Compressed\Optional\controls_scheme.ips"     }

    if ( (IsChecked $Redux.Gameplay.NewControlsScheme) -or (IsChecked $Redux.Revert.ControlsScheme) ) { # Dual Suit must come last if controls are patched
        if (IsChecked $Redux.Graphics.DualSuit) {
            if (IsChecked $Redux.Graphics.RedesignedSamus)   { ApplyPatch -Patch "Compressed\Optional\redesigned_dual_suit.ips" }
            else                                             { ApplyPatch -Patch "Compressed\Optional\dual_suit.ips"            }
        }
    }
    
}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    if (IsChecked $Redux.Revert.Xray)                 { ChangeBytes -Offset "4079A"  -Values "0A" }
    if (IsChecked $Redux.Revert.ElevatorSpeed)        { ChangeBytes -Offset "119581" -Values "A900008D9907BD800F186900809D800FBD7E0F6901009D7E0F"; ChangeBytes -Offset @("1195B0", "1195D2", "1195EC") -Values "01"                       }
    if (IsChecked $Redux.Revert.ClassicBooster)       { ChangeBytes -Offset "80594" -Values "01"; ChangeBytes -Offset "8F66F" -Values "2253DE91";  ChangeBytes -Offset @("850CE",  "850FD",  "85129")  -Values "CE"                       }
    if (IsChecked $Redux.Revert.BeamCooldowns)        { ChangeBytes -Offset "84254"  -Values "0F0F0F0F0F0F0F0F0F0F0C0F";                           ChangeBytes -Offset   "84283"                       -Values "191919191919191919191919" }
    if (IsChecked $Redux.Revert.SandPhysics)          { ChangeBytes -Offset "234B8"  -Values "C0";                                                 ChangeBytes -Offset   "234BD"                       -Values "01"                       }
    if (IsChecked $Redux.Revert.UnderwaterWalljump)   { ChangeBytes -Offset "81EDF"  -Values "00"                                                                                                                                         }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel

}


#==============================================================================================================================================================================================
function CreateTabMain() {
    
    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"        -Text "Graphics"
  # CreateReduxCheckBox -Name "Widescreen"      -Text "16:9 Widescreen [!]" -Info "16:9 Widescreen display" -Warning "Only works with the BSNES / Higan Widescreen feature, and does not work on Dolphin"                           -Credits "ocesse" -Native
    CreateReduxCheckBox -Name "RedesignedSamus" -Text "Redesigned Samus"    -Info "Modifies Samus' sprite slightly to have a better arm cannon and some slight suit touchups"                                                       -Credits "Dmit Ryaz"
    CreateReduxComboBox -Name "DualSuit"        -Text "Dual Suit"           -Info "Gives Samus' an entirely different set of graphics for her Power Suit form, to match the Power Suit design and form seen in other Metroid games" -Credits "Crashtour99, Starry_Melody, ShadowOne333"
    CreateReduxCheckBox -Name "DeathCensor"     -Text "Death Censor"        -Info "Censors the deatrh animations of Samus upon game over"                                                                                           -Credits "Dmit Ryaz"



    # AUDIO #

    CreateReduxGroup    -Tag  "Audio"   -Text "Audio"
    CreateReduxCheckBox -Name "NoMusic" -Text "No Music" -Info "Removes the background music in the game" -Credits "Kejardon"



    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"                  -Text "Gameplay"
    CreateReduxCheckBox -Name "FixedTourianUnlockedDoors" -Text "Fixed Unlocked Doors" -Info "Makes it so that the Tourian doors now let you go back to Crateria normally`nThis patch is already implemented into Redux"     -Credits "Smiley"
    CreateReduxCheckBox -Name "SaveStationsRefill"        -Text "Save Stations Refill" -Info "Save Stations will now refill both Energy and all Weapons"                                                                     -Credits "Redux Project"
    CreateReduxCheckBox -Name "SkipCeres"                 -Text "Skip Ceres"           -Info "Skip the Ceres Station sequence at the beginning, and start off directly on Planet Zebes' Landing Site on New Game"            -Credits "Redux Project"
    CreateReduxCheckBox -Name "SpazerPlasaMix"            -Text "Spazer Plasa Mix"     -Info "Be able to combine both the Spazer Beam alongside the Plasma Beam" -Warning "There are graphical issues when using this patch" -Credits "Redux Project"

}


#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"          -Text "Gameplay"
    CreateReduxCheckBox -Name "HeavyPhysics"      -Text "Heavy Physics"       -Info "Make Samus land faster and with more gravity, similar to Metroid Fusion" -Credits "Project Base"
    CreateReduxCheckBox -Name "NewControlsScheme" -Text "New Controls Scheme" -Info "Changes the controls to the new scheme"                                  -Credits "Redux Project"



    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert"             -Text "Original (Revert)"
    CreateReduxCheckBox -Name "Xray"               -Text "X-Ray"               -Info "Restores the original Super Metroid X-Ray Visor width"                                                        -Credits "Redux Project"
    CreateReduxCheckBox -Name "ElevatorSpeed"      -Text "Elevator Speed"      -Info "Restores the original Super Metroid elevator speeds"                                                          -Credits "Redux Project"
    CreateReduxCheckBox -Name "ClassicBooster"     -Text "Classic Booster"     -Info "Restores the original Super Metroid speed at which the Shinespark is activated"                               -Credits "Redux Project"
    CreateReduxCheckBox -Name "Demos"              -Text "Demos"               -Info "Restores the original Super Metroid demo title screens"                                                       -Credits "Redux Project"
    CreateReduxCheckBox -Name "BeamCooldowns"      -Text "Beam Cooldowns"      -Info "Restores the original Super Metroid speed at which Samus can fire her beam, and the speed of the projectiles" -Credits "Redux Project"
    CreateReduxCheckBox -Name "SandPhysics"        -Text "Sand Physics"        -Info "Restores the original Super Metroid sand physics"                                                             -Credits "wittyphoenix"
    CreateReduxCheckBox -Name "UnderwaterWalljump" -Text "Underwater Walljump" -Info "Restores the original Super Metroid underwater walljump physics"                                              -Credits "wittyphoenix"
    CreateReduxCheckBox -Name "BossTilesMap"       -Text "Boss Tiles Map"      -Info "Restores the map screen to no longer show the boss tiles"                                                     -Credits "wittyphoenix & GoodLuckTrying"
    CreateReduxCheckBox -Name "ColoredDoorsMap"    -Text "Colored Doors Map"   -Info "Restores the map screen to no longer show colored doors"                                                      -Credits "wittyphoenix & GoodLuckTrying"
    CreateReduxCheckBox -Name "ControlsScheme"     -Text "Controls Scheme"     -Info "Restores the original Super Metroid controls instead of the Metroid Fusion controls"                          -Credits "Redux Project" -Link $Redux.Gameplay.NewControlsScheme
    
}