function PatchOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.RearrangedBosses)   { ApplyPatch -Patch "Compressed\Optional\rearranged_bosses.ips" }
    if (IsChecked $Redux.Gameplay.FullHealthStart)    { ApplyPatch -Patch "Compressed\Optional\full_health_start.ips" }
    if (IsChecked $Redux.Gameplay.FullHealthDeath)    { ApplyPatch -Patch "Compressed\Optional\full_health_death.ips" }
    if (IsChecked $Redux.Gameplay.LikeLikeRupees)     { ApplyPatch -Patch "Compressed\Optional\like_like_rupees.ips"  }
    if (IsChecked $Redux.Gameplay.NotLost)            { ApplyPatch -Patch "Compressed\Optional\not_lost.ips"          }
    if (IsChecked $Redux.Gameplay.ALttPSwordSwing)    { ApplyPatch -Patch "Compressed\Optional\alttp_sword_swing.ips" }
    if (IsChecked $Redux.Gameplay.No2ndQuest)         { ApplyPatch -Patch "Compressed\Optional\no_2nd_quest.ips"      }



    # GRAPHICS #

    if     (IsChecked $Redux.Graphics.LinksAwakeningGFX)   { ApplyPatch -Patch "Compressed\Optional\links_awakening_gfx.ips" }
    if     (IsChecked $Redux.Graphics.RecoloredDungeons)   { ApplyPatch -Patch "Compressed\Optional\recoloured_dungeons.ips" }
    if     (IsChecked $Redux.Graphics.BluerTunic)          { ApplyPatch -Patch "Compressed\Optional\bluer_tunic.ips"         }
    if     (IsChecked $Redux.Graphics.BetterFont)          { ApplyPatch -Patch "Compressed\Optional\better_font.ips"         }
    elseif (IsChecked $Redux.Graphics.FDSFont)             { ApplyPatch -Patch "Compressed\Optional\fds_font.ips"            }



    # AUDIO #

    if     (IsChecked $Redux.Audio.MixedDungeonThemes)   { ApplyPatch -Patch "Compressed\Optional\mixed_dungeon_themes.ips"  }
    elseif (IsChecked $Redux.Audio.NoMusic)              { ApplyPatch -Patch "Compressed\Optional\no_music.ips"              }
    if     (IsChecked $Redux.Audio.NoLowHPBeep)          { ApplyPatch -Patch "Compressed\Optional\no_low_hp_beep.ips"        }
    elseif (IsChecked $Redux.Audio.LowHPBeep)            { ApplyPatch -Patch "Compressed\Optional\low_hp_beep.ips"           }



    # TITLE SCREEN #

    if     (IsChecked $Redux.Title.ReworkedTitleScreen)    { ApplyPatch -Patch "Compressed\Optional\reworked_title_screen.ips"                   }
    elseif (IsChecked $Redux.Title.ReworkedTitleWithout)   { ApplyPatch -Patch "Compressed\Optional\reworked_title_screen_without_subtitles.ips" }
    elseif (IsChecked $Redux.Title.RemoveSubtitle)         { ApplyPatch -Patch "Compressed\Optional\remove_subtitle.ips"                         }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {

    # ORIGINAL #

    if (IsChecked $Redux.Revert.HiddenSecrets)           { ApplyPatch -Patch "Compressed\Original\hidden_secrets.ips"         }
    if (IsChecked $Redux.Revert.DisableDiagionalSword)   { ApplyPatch -Patch "Compressed\Original\disable_diagonal_sword.ips" }
    if (IsChecked $Redux.Revert.OverworldColumns)        { ApplyPatch -Patch "Compressed\Original\overworld_columns.ips"      }
    if (IsChecked $Redux.Revert.BombAmounts)             { ApplyPatch -Patch "Compressed\Original\bomb_amounts.ips"           }
    if (IsChecked $Redux.Revert.DoorGlitch)              { ApplyPatch -Patch "Compressed\Original\door_glitch.ips"            }



    # ORIGINAL GFX #

    if (IsChecked $Redux.Revert.NESGFX)          { ApplyPatch -Patch "Compressed\Original\nes_gfx.ips"        }
    if (IsChecked $Redux.Revert.FastWaterfall)   { ApplyPatch -Patch "Compressed\Original\fast_waterfall.ips" }
    if (IsChecked $Redux.Revert.TunicRing)       { ApplyPatch -Patch "Compressed\Original\tunic_ring.ips"     }
    if (IsChecked $Redux.Revert.TunicNESRing)    { ApplyPatch -Patch "Compressed\Original\tunic_nes_ring.ips" }



    # ORIGINAL AUDIO #

    if (IsChecked $Redux.Revert.DungeonTheme)   { ApplyPatch -Patch "Compressed\Original\dungeon_theme.ips" }




    # ORIGINAL HUD #

    if (IsChecked $Redux.UI.OriginalHUD)           { ApplyPatch -Patch "Compressed\Original\hud.ips"                   }
    if (IsChecked $Redux.UI.GreyAutomap)           { ApplyPatch -Patch "Compressed\Original\grey_automap.ips"          }
    if (IsChecked $Redux.UI.GreyAutomapOriginal)   { ApplyPatch -Patch "Compressed\Original\grey_automap_original.ips" }
    
}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    if ($Patches.Redux.Checked) {
        EnableElem -Elem @($Redux.Audio.MixedDungeonThemes, $Redux.Audio.NoMusic)       -Active (!$Redux.Revert.DungeonTheme.Checked)
        EnableElem -Elem @($Redux.Revert.DungeonTheme,      $Redux.Audio.NoMusic)       -Active (!$Redux.Audio.MixedDungeonThemes.Checked)
        EnableElem -Elem @($Redux.Audio.MixedDungeonThemes, $Redux.Revert.DungeonTheme) -Active (!$Redux.Audio.NoMusic.Checked)
        if ($Redux.Audio.MixedDungeonThemes.Checked -and $Redux.Audio.NoMusic.Checked -and $Redux.Revert.DungeonTheme.Checked) { $Redux.Audio.MixedDungeonThemes.Checked = $Redux.Audio.NoMusic.Checked = $Redux.Revert.DungeonTheme.Checked = $False }
    }
    else {
        EnableElem -Elem $Redux.Audio.MixedDungeonThemes -Active (!$Redux.Audio.NoMusic.Checked)
        EnableElem -Elem $Redux.Audio.NoMusic            -Active (!$Redux.Audio.MixedDungeonThemes.Checked)
        if ($Redux.Audio.MixedDungeonThemes.Checked -and $Redux.Audio.NoMusic.Checked) { $Redux.Audio.MixedDungeonThemes.Checked = $Redux.Audio.NoMusic.Checked = $False }
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel

    $Redux.Audio.MixedDungeonThemes.Add_CheckStateChanged( { EnableElem -Elem @($Redux.Audio.NoMusic,            $Redux.Revert.DungeonTheme) -Active (!$this.checked) } )
    $Redux.Audio.NoMusic.Add_CheckStateChanged(            { EnableElem -Elem @($Redux.Audio.MixedDungeonThemes, $Redux.Revert.DungeonTheme) -Active (!$this.checked) } )
    $Redux.Revert.DungeonTheme.Add_CheckStateChanged(      { EnableElem -Elem @($Redux.Audio.MixedDungeonThemes, $Redux.Audio.NoMusic)       -Active (!$this.checked) } )

}



#==============================================================================================================================================================================================
function CreateTabMain() {
    
    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"         -Text "Gameplay"
    CreateReduxCheckBox -Name "RearrangedBosses" -Text "Rearranged Bosses"       -Info "Unique bosses in each Dungeon/Level"                                                                                                                -Credits "LexLuthermeister"
    CreateReduxCheckBox -Name "FullHealthStart"  -Text "Full Health at Start"    -Info "Fill the amount of hearts you have upon starting a save file, so you don't always start with 3 hearts only"                                         -Credits "Redux Project"
    CreateReduxCheckBox -Name "FullHealthDeath"  -Text "Full Health After Death" -Info "Fill the amount of hearts you have after a death or a Game Over"                                                                                    -Credits "kalita-kan"
    CreateReduxCheckBox -Name "LikeLikeRupees"   -Text "Like Like Zelda"         -Info "Like Likes now consume rupees instead of the shield"                                                                                                -Credits "gzip"
    CreateReduxCheckBox -Name "NotLost"          -Text "Not Lost"                -Info "Make both the Lost Woods and Lost Hills into normal screens instead of having to always walk the correct path to go through"                        -Credits "Redux Project"
    CreateReduxCheckBox -Name "ALttPSwordSwing"  -Text "ALttP Sword Swing"       -Info "Makes the sword swing similar to that of ALttP, where it's a full arc instead of stopping when reaching the center like in the default sword swing" -Credits "Redux Project"
    CreateReduxCheckBox -Name "No2ndQuest"       -Text "No 2nd Quest"            -Info ("Naming your save slot " + '"ZELDA"' + " won't activate 2nd Quest anymore")                                                                         -Credits "kalita-kan"


    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"           -Text "Graphics"
    CreateReduxCheckBox -Name "LinksAwakeningGFX"  -Text "Link's Awakening GFX"     -Info "Restyle the graphics to look like Link's Awakening from the GameBoy"                    -Credits "Redux Project"
    CreateReduxCheckBox -Name "RecolouredDungeons" -Text "Recoloured Dungeons"      -Info "Make each dungeon have its own unique colour palette similar to Modern Classic Edition" -Credits "Redux Project"
    CreateReduxCheckBox -Name "BluerTunic"         -Text "Bluer Tunic"              -Info "Make the Blue Tunic more blue"                                                          -Credits "Asaki"
    CreateReduxCheckBox -Name "BetterFont"         -Text "Better Font"              -Info "Use the Better Font graphics"                                                           -Credits "gzip"
    CreateReduxCheckBox -Name "FDSFont"            -Text "Famicon Disk System Font" -Info "Use the font from the Famicom Disk System"                                              -Credits "Redux Project" -Link $Redux.Graphics.BetterFont



    # AUDIO #

    CreateReduxGroup    -Tag  "Audio"              -Text "Audio"
    CreateReduxCheckBox -Name "MixedDungeonThemes" -Text "Mixed Dungeon Themes" -Info "Changes the Dungeon music to interchange between the original Zelda 1 Dungeon Theme and A New Light's Dungeon Theme" -Credits "tacoschip & gzip"
    CreateReduxCheckBox -Name "NoMusic"            -Text "No Music"             -Info "Removes the background music in the game"                                                                            -Credits "Fiskbit"
    CreateReduxCheckBox -Name "NoLowHPBeep"        -Text "No Low HP Beep"       -Info "Remove the low health beep"                                                                                          -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "LowHPBeep"          -Text "Low HP Beep"          -Info "Change the Low Hearts beeping sound to a heartbeat-like sound"                                                       -Credits "gzip" -Link $Redux.Audio.NoLowHPBeep



    # TITLE SCREEN #

    CreateReduxGroup       -Tag  "Title"                -Text "Title Screen"
    CreateReduxRadioButton -Name "Subtitle"             -Text "Keep Title Screen"               -SaveTo "TitleScreen" -Info "Keep the title screen as it is"                                                                   -Checked
    CreateReduxRadioButton -Name "ReworkedTitleScreen"  -Text "Reworked Title Screen"           -SaveTo "TitleScreen" -Info "Reworked title screen to match the more recent Zelda title screen"                                -Credits "Redux Project"
    CreateReduxRadioButton -Name "ReworkedTitleWithout" -Text "Reworked Title Without Subtitle" -SaveTo "TitleScreen" -Info "Reworked title screen to match the more recent Zelda title screen but removed the added subtitle" -Credits "Redux Project"
    CreateReduxRadioButton -Name "RemoveSubtitle"       -Text "Remove Subtitle"                 -SaveTo "TitleScreen" -Info "Remove the added subtitle from the title screen"                                                  -Credits "Redux Project"
     
}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert"                -Text "Original (Revert)"
    CreateReduxCheckBox -Name "HiddenSecrets"         -Text "Hidden Secrets"         -Info "Revert back all hidden secrets like that Redux adjusted, for the orginal experience" -Credits "Nintendo"
    CreateReduxCheckBox -Name "DisableDiagionalSword" -Text "Disable Diagonal Sword" -Info "Remove the ability to swing the sword diagonal as the original version"              -Credits "Nintendo"
    CreateReduxCheckBox -Name "OverworldColumns"      -Text "Overworld Columns"      -Info "Revert back the blocky overworld screen/column definition from the original version" -Credits "Nintendo"
    CreateReduxCheckBox -Name "BombUpgrades"          -Text "Bomb Upgrades"          -Info "Revert back bomb upgrades to increase the amount of bombs by 5 instead of 10"        -Credits "Nintendo"
    CreateReduxCheckBox -Name "DoorGlitch"            -Text "Door Glitch"            -Info "Restores the glitching door that opens on it's own if you enter-leave the dungeon"   -Credits "Nintendo"



    # ORIGINAL GFX #

    CreateReduxGroup    -Tag  "Revert"        -Text "Original GFX (Revert)"
    CreateReduxCheckBox -Name "NESGFX"        -Text "NES GFX"          -Info "Revert back any GFX graphics changes that Redux adjusted, for the original experience" -Credits "Nintendo" -Link $Redux.Graphics.LinksAwakeningGFX
    CreateReduxCheckBox -Name "FastWaterfall" -Text "Fast Waterfall"   -Info "Revert back the fast waterfall from the original version"                              -Credits "Nintendo"
    CreateReduxCheckBox -Name "TunicRing"     -Text "Tunic 2 Ring"     -Info "Change the Tunics back to Rings with the revamped sprite"                              -Credits "Nintendo"
    CreateReduxCheckBox -Name "TunicNESRing"  -Text "Tunic 2 NES Ring" -Info "Change the Tunics back to Rings from the original version"                             -Credits "Nintendo" -Link $Redux.Revert.TunicRing



    # ORIGINAL AUDIO #

    CreateReduxGroup    -Tag  "Revert"       -Text "Original Audio (Revert)"
    CreateReduxCheckBox -Name "DungeonTheme" -Text "Dungeon Theme" -Info "Changes the Dungeon music to only play the original Zelda 1 Dungeon Theme" -Credits "Nintendo"



    # ORIGINAL HUD #

    CreateReduxGroup       -Tag  "UI" -Text "Original HUD (Revert)"
    CreateReduxRadioButton -Name "Automap"             -SaveTo "HUD" -Text "Keep Automap"       -Checked -Info "Keep the new Automap Plus feature as it is"                                     -Credits "snarfblam"
    CreateReduxRadioButton -Name "OriginalHUD"         -SaveTo "HUD" -Text "Original HUD"                -Info "Revert back to the HUD from the original version"                               -Credits "snarfblam"
    CreateReduxRadioButton -Name "GreyAutomap"         -SaveTo "HUD" -Text "Grey Automap"                -Info "Grayscale the new automap"                                                      -Credits "snarfblam"
    CreateReduxRadioButton -Name "GreyAutomapOriginal" -SaveTo "HUD" -Text "Grey Automap (Original HUD)" -Info "Grayscale the new automap and revert back to the HUD from the original version" -Credits "snarfblam"

}