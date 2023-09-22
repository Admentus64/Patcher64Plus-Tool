function PatchOptions() {
    
    # GRAPHICS #

  # if (IsChecked $Redux.Graphics.Widescreen)        { ApplyPatch -Patch "Compressed\Optional\widescreen.ips"; Copy-Item -LiteralPath ($GameFiles.compressed + "\widescreen.bso") -Destination ($ROMFile.Patched.replace($ROMFile.Extension, ".bso")) -Force }
    if (IsChecked $Redux.Graphics.RedesignedSamus)   { ApplyPatch -Patch "Compressed\Optional\redesigned_samus.ips" }
    if (IsChecked $Redux.Graphics.DeathCensor)       { ApplyPatch -Patch "Compressed\Optional\death_censor.ips"     }

    if (IsChecked $Redux.Graphics.DualSuit) {
        if (IsChecked $Redux.Graphics.RedesignedSamus)   { ApplyPatch -Patch "Compressed\Optional\redesigned_dual_suit.ips" }
        else                                             { ApplyPatch -Patch "Compressed\Optional\dual_suit.ips"            }
    }



    # AUDIO #

    if (IsChecked $Redux.Audio.NoMusic) { ApplyPatch -Patch "Compressed\Optional\no_music.ips" }
    
    

    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.FixedUnlockedDoors)   { ApplyPatch -Patch "Compressed\Optional\fixed_tourian_unlocked_doors.ips"    }
    if (IsChecked $Redux.Gameplay.SaveStationsRefill)   { ApplyPatch -Patch "Compressed\Optional\save_stations_refill_everything.ips" }
    if (IsChecked $Redux.Gameplay.SkipCeres)            { ApplyPatch -Patch "Compressed\Optional\skip_ceres.ips"                      }
    if (IsChecked $Redux.Gameplay.SpazerPlasmaMix)      { ApplyPatch -Patch "Compressed\Optional\spazer_plasma_mix.ips"               }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.HeavyPhysics) { ApplyPatch -Patch "Compressed\Optional\heavy_physics.ips" }



    # ORIGINAL #

    if (IsChecked $Redux.Revert.OriginalDemos) {
        if (IsChecked $Redux.Revert.HeavyPhysics)   { ApplyPatch -Patch "Compressed\Original\original_demos_heave_physics.ips" }
        else                                        { ApplyPatch -Patch "Compressed\Original\original_demos.ips"               }
    }

    if (IsChecked $Redux.Revert.Xray)             { ApplyPatch -Patch "Compressed\Original\x_ray.ips"           }
    if (IsChecked $Redux.Revert.ElevatorSpeed)    { ApplyPatch -Patch "Compressed\Original\elevator_speed.ips"  }
    if (IsChecked $Redux.Revert.ClassicBooster)   { ApplyPatch -Patch "Compressed\Original\classic_booster.ips" }
    if (IsChecked $Redux.Revert.BeamCooldowns)    { ApplyPatch -Patch "Compressed\Original\beam_cooldowns.ips"  }
    
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
    CreateReduxCheckBox -Name "DualSuit"        -Text "Dual Suit"           -Info "Gives Samus' an entirely different set of graphics for her Power Suit form, to match the Power Suit design and form seen in other Metroid games" -Credits "Crashtour99, Starry_Melody & ShadowOne333"
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

    CreateReduxGroup    -Tag  "Gameplay"     -Text "Gameplay"
    CreateReduxCheckBox -Name "HeavyPhysics" -Text "Heavy Physics" -Info "This will make it so that Samus now lands faster and with more gravity to her, similar to that of the GBA Metroids" -Credits "Redux Project"



    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert"         -Text "Original (Revert)"
    CreateReduxCheckBox -Name "Xray"           -Text "X-Ray"           -Info "Restores the original Super Metroid X-Ray Visor width"                                                        -Credits "Nintendo"
    CreateReduxCheckBox -Name "ElevatorSpeed"  -Text "Elevator Speed"  -Info "Restores the original Super Metroid elevator speeds"                                                          -Credits "Nintendo"
    CreateReduxCheckBox -Name "ClassicBooster" -Text "Classic Booster" -Info "Restores the original Super Metroid speed at which the shinepark is activated"                                -Credits "Nintendo"
    CreateReduxCheckBox -Name "OriginalDemos"  -Text "Original Demos"  -Info "Restores the original Super Metroid demo title screens"                                                       -Credits "Nintendo"
    CreateReduxCheckBox -Name "BeamCooldowns"  -Text "Beam Cooldowns"  -Info "Restores the original Super Metroid speed at which Samus can fire her beam, and the speed of the projectiles" -Credits "Nintendo"
    
}