function PatchOptions() {
    
    # GRAPHICS #

    if     (IsChecked $Redux.Graphics.LinksAwakeningGFX)   { ApplyPatch -Patch "Compressed\Optional\links_awakening_gfx.ips" }
    if     (IsChecked $Redux.Graphics.RecoloredDungeons)   { ApplyPatch -Patch "Compressed\Optional\recoloured_dungeons.ips" }
    if     (IsChecked $Redux.Graphics.BluerTunic)          { ApplyPatch -Patch "Compressed\Optional\bluer_tunic.ips"         }
    if     (IsChecked $Redux.Graphics.BetterFont)          { ApplyPatch -Patch "Compressed\Optional\better_font.ips"         }
    elseif (IsChecked $Redux.Graphics.FDSFont)             { ApplyPatch -Patch "Compressed\Optional\fds_font.ips"            }



    # TITLE SCREEN #

    if     (IsChecked $Redux.Title.ReworkedTitleScreen)    { ApplyPatch -Patch "Compressed\Optional\reworked_title_screen.ips"                   }
    elseif (IsChecked $Redux.Title.ReworkedTitleWithout)   { ApplyPatch -Patch "Compressed\Optional\reworked_title_screen_without_subtitles.ips" }
    elseif (IsChecked $Redux.Title.RemoveSubtitle)         { ApplyPatch -Patch "Compressed\Optional\remove_subtitle.ips"                         }



    # AUDIO #

    if     (IsChecked $Redux.Audio.DungeonMusic)   { ApplyPatch -Patch "Compressed\Optional\dungeon_music.ips"  }
    if     (IsChecked $Redux.Audio.NoLowHPBeep)    { ApplyPatch -Patch "Compressed\Optional\no_low_hp_beep.ips" }
    elseif (IsChecked $Redux.Audio.LowHPBeep)      { ApplyPatch -Patch "Compressed\Optional\low_hp_beep.ips"    }



    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.RearrangedBosses)   { ApplyPatch -Patch "Compressed\Optional\rearranged_bosses.ips" }
    if (IsChecked $Redux.Gameplay.FullHealthStart)    { ApplyPatch -Patch "Compressed\Optional\full_health_start.ips" }
    if (IsChecked $Redux.Gameplay.FullHealthDeath)    { ApplyPatch -Patch "Compressed\Optional\full_health_death.ips" }
    if (IsChecked $Redux.Gameplay.LikeLikeRupees)     { ApplyPatch -Patch "Compressed\Optional\like_like_rupees.ips"  }
    if (IsChecked $Redux.Gameplay.NotLost)            { ApplyPatch -Patch "Compressed\Optional\not_lost.ips"          }
    if (IsChecked $Redux.Gameplay.ALttPSwordSwing)    { ApplyPatch -Patch "Compressed\Optional\alttp_sword_swing.ips" }
    if (IsChecked $Redux.Gameplay.No2ndQuest)         { ApplyPatch -Patch "Compressed\Optional\no_2nd_quest.ips"      }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.AnimatedTiles)          { ApplyPatch -Patch "Compressed\Optional\animated_tiles.bps" }



    # ORIGINAL #

    if (IsChecked $Redux.Revert.HiddenSecrets)            { ApplyPatch -Patch "Compressed\Optional\Original\hidden_secrets.ips"         }
    if (IsChecked $Redux.Revert.DisableDiagionalSword)    { ApplyPatch -Patch "Compressed\Optional\Original\disable_diagonal_sword.ips" }
    if (IsChecked $Redux.Revert.OverworldColumns)         { ApplyPatch -Patch "Compressed\Optional\Original\overworld_columns.ips"      }
    if (IsChecked $Redux.Revert.BombAmounts)              { ApplyPatch -Patch "Compressed\Optional\Original\bomb_amounts.ips"           }
    if (IsChecked $Redux.Revert.DoorGlitch)               { ApplyPatch -Patch "Compressed\Optional\Original\door_glitch.ips"            }



    # ORIGINAL GFX #

    if (IsChecked $Redux.Revert.NESGFX)                   { ApplyPatch -Patch "Compressed\Optional\Original\nes_gfx.ips"        }
    if (IsChecked $Redux.Revert.FastWaterfall)            { ApplyPatch -Patch "Compressed\Optional\Original\fast_waterfall.ips" }
    if (IsChecked $Redux.Revert.TunicRing)                { ApplyPatch -Patch "Compressed\Optional\Original\tunic_ring.ips"     }
    if (IsChecked $Redux.Revert.TunicNESRing)             { ApplyPatch -Patch "Compressed\Optional\Original\tunic_nes_ring.ips" }



    # ORIGINAL HUD #

    if (IsChecked $Redux.UI.OriginalHUD)                  { ApplyPatch -Patch "Compressed\Optional\Original\hud.ips"                   }
    if (IsChecked $Redux.UI.GreyAutomap)                  { ApplyPatch -Patch "Compressed\Optional\Original\grey_automap.ips"          }
    if (IsChecked $Redux.UI.GreyAutomapOriginal)          { ApplyPatch -Patch "Compressed\Optional\Original\grey_automap_original.ips" }
    
}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    $Redux.Graphics.LinksAwakeningGFX.Add_CheckStateChanged({
        $Redux.Graphics.AnimatedTiles.Enabled = $Redux.Revert.NESGFX.Enabled = !$this.checked
        if ($this.checked) { $Redux.Graphics.AnimatedTiles.Checked = $Redux.Revert.NESGFX.Checked  = $False }
    })

    $Redux.Graphics.AnimatedTiles.Add_CheckStateChanged({
        $Redux.Graphics.LinksAwakeningGFX.Enabled = $Redux.Revert.NESGFX.Enabled = !$this.checked
        if ($this.checked) { $Redux.Graphics.LinksAwakeningGFX.Checked = $Redux.Revert.NESGFX.Checked  = $False }
    })

    $Redux.Revert.NESGFX.Add_CheckStateChanged({
        $Redux.Graphics.LinksAwakeningGFX.Enabled = $Redux.Graphics.AnimatedTiles.Enabled = !$this.checked
        if ($this.checked) { $Redux.Graphics.LinksAwakeningGFX.Checked = $Redux.Graphics.AnimatedTiles.Checked  = $False }
    })

    if (IsChecked $Redux.Graphics.LinksAwakeningGFX) {
        $Redux.Graphics.AnimatedTiles.Enabled     = $Redux.Graphics.AnimatedTiles.Checked     = $False
        $Redux.Revert.NESGFX.Enabled              = $Redux.Revert.NESGFX.Checked              = $False
    }

    if (IsChecked $Redux.Graphics.AnimatedTiles) {
        $Redux.Graphics.LinksAwakeningGFX.Enabled = $Redux.Graphics.LinksAwakeningGFX.Checked = $False
        $Redux.Revert.NESGFX.Enabled              = $Redux.Revert.NESGFX.Checked              = $False
    }

    if (IsChecked $Redux.Revert.NESGFX) {
        $Redux.Graphics.LinksAwakeningGFX.Enabled = $Redux.Graphics.LinksAwakeningGFX.Checked = $False
        $Redux.Graphics.AnimatedTiles.Enabled     = $Redux.Graphics.AnimatedTiles.Checked     = $False
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 5 -Height 420

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"           -Text "Graphics"
    CreateReduxCheckBox -Name "LinksAwakeningGFX"  -Text "Link's Awakening GFX"     -Info "Restyle the graphics to look like Link's Awakening from the GameBoy`nNot compatible with the Animated Tiles or NES GFX options" -Credits "Redux Project"
    CreateReduxCheckBox -Name "RecolouredDungeons" -Text "Recoloured Dungeons"      -Info "Make each dungeon have its own unique colour palette similar to Modern Classic Edition"                                         -Credits "Redux Project"
    CreateReduxCheckBox -Name "BluerTunic"         -Text "Bluer Tunic"              -Info "Make the Blue Tunic more blue"                                                                                                  -Credits "Asaki"
    CreateReduxCheckBox -Name "BetterFont"         -Text "Better Font"              -Info "Use the Better Font graphics"                                                                                                   -Credits "gzip"
    CreateReduxCheckBox -Name "FDSFont"            -Text "Famicon Disk System Font" -Info "Use the font from the Famicom Disk System"                                                                                      -Credits "Redux Project" -Link $Redux.Graphics.BetterFont



    # TITLE SCREEN #

    CreateReduxGroup       -Tag   "Title" -Text "Title Screen"
    CreateReduxPanel       -Columns 3.9
    CreateReduxRadioButton -Name "Subtitle"             -SaveTo "TitleScreen" -Checked -Text "Keep Title Screen"               -Info "Keep the title screen as it is"
    CreateReduxRadioButton -Name "ReworkedTitleScreen"  -SaveTo "TitleScreen"          -Text "Reworked Title Screen"           -Info "Reworked title screen to match the more recent Zelda title screen"                                -Credits "Redux Project"
    CreateReduxRadioButton -Name "ReworkedTitleWithout" -SaveTo "TitleScreen"          -Text "Reworked Title Without Subtitle" -Info "Reworked title screen to match the more recent Zelda title screen but removed the added subtitle" -Credits "Redux Project"
    CreateReduxRadioButton -Name "RemoveSubtitle"       -SaveTo "TitleScreen"          -Text "Remove Subtitle"                 -Info "Remove the added subtitle from the title screen"                                                  -Credits "Redux Project"
    
    

    # AUDIO #

    CreateReduxGroup    -Tag  "Audio"        -Text "Audio"
    CreateReduxCheckBox -Name "DungeonMusic" -Text "Dungeon Music"  -Info "Change the Dungeon music to that of Zelda: A New Light"        -Credits "gzip"
    CreateReduxCheckBox -Name "NoLowHPBeep"  -Text "No Low HP Beep" -Info "Remove the low health beep"                                    -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "LowHPBeep"    -Text "Low HP Beep"    -Info "Change the Low Hearts beeping sound to a heartbeat-like sound" -Credits "gzip" -Link $Redux.Audio.NoLowHPBeep



     # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"         -Text "Gameplay"
    CreateReduxCheckBox -Name "RearrangedBosses" -Text "Rearranged Bosses"       -Info "Unique bosses in each Dungeon/Level"                                                                                                                -Credits "LexLuthermiester"
    CreateReduxCheckBox -Name "FullHealthStart"  -Text "Full Health at Start"    -Info "Fill the amount of hearts you have upon starting a save file, so you don't always start with 3 hearts only"                                         -Credits "Redux Project"
    CreateReduxCheckBox -Name "FullHealthDeath"  -Text "Full Health After Death" -Info "Fill the amount of hearts you have after a death or a Game Over"                                                                                    -Credits "Redux Project"
    CreateReduxCheckBox -Name "LikeLikeRupees"   -Text "Like Like Zelda"         -Info "Like Likes now consume rupees instead of the shield"                                                                                                -Credits "gzip"
    CreateReduxCheckBox -Name "NotLost"          -Text "Not Lost"                -Info "Make both the Lost Woods and Lost Hills into normal screens instead of having to always walk the correct path to go through"                        -Credits "Redux Project"
    CreateReduxCheckBox -Name "ALttPSwordSwing"  -Text "ALttP Sword Swing"       -Info "Makes the sword swing similar to that of ALttP, where it's a full arc instead of stopping when reaching the center like in the default sword swing" -Credits "Redux Project"
    CreateReduxCheckBox -Name "No2ndQuest"       -Text "No 2nd Quest"            -Info ("Naming your save slot " + '"ZELDA"' + " won't activate 2nd Quest anymore")                                                                         -Credits "Redux Project"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"      -Text "Graphics"
    CreateReduxCheckBox -Name "AnimatedTiles" -Text "Animated Tiles" -Info "Animate the tile`nNot compatible with the Link's Awakening GFX or NES GFX options" -Credits "Redux Project" -Warning "Does not work on the Wii Virtual Console or less accurate NES emulators"



    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert"                -Text "Original (Revert)"
    CreateReduxCheckBox -Name "HiddenSecrets"         -Text "Hidden Secrets"         -Info "Revert back all hidden secrets like that Redux adjusted, for the orginal experience" -Credits "Nintendo"
    CreateReduxCheckBox -Name "DisableDiagionalSword" -Text "Disable Diagonal Sword" -Info "Remove the ability to swing the sword diagonal as the original version"              -Credits "Nintendo"
    CreateReduxCheckBox -Name "OverworldColumns"      -Text "Overworld Columns"      -Info "Revert back the blocky overworld screen/column definition from the original version" -Credits "Nintendo"
    CreateReduxCheckBox -Name "BombUpgrades"          -Text "Bomb Upgrades"          -Info "Revert back bomb upgrades to increase the amount of bombs by 5 instead of 10"        -Credits "Nintendo"
    CreateReduxCheckBox -Name "DoorGlitch"            -Text "Door Glitch"            -Info "Restores the glitching door that opens on it's own if you enter-leave the dungeon"   -Credits "Nintendo"



    # ORIGINAL GFX #

    CreateReduxGroup    -Tag  "Revert"                -Text "Original GFX (Revert)"
    CreateReduxCheckBox -Name "NESGFX"                -Text "NES GFX"          -Info "Revert back any GFX graphics changes that Redux adjusted, for the original experience`nNot compatible with the Link's Awakening GFX or Animated Tiles options" -Credits "Nintendo"
    CreateReduxCheckBox -Name "FastWaterfall"         -Text "Fast Waterfall"   -Info "Revert back the fast waterfall from the original version"                                                                                                      -Credits "Nintendo"
    CreateReduxCheckBox -Name "TunicRing"             -Text "Tunic 2 Ring"     -Info "Change the Tunics back to Rings with the revamped sprite"                                                                                                      -Credits "Nintendo"
    CreateReduxCheckBox -Name "TunicNESRing"          -Text "Tunic 2 NES Ring" -Info "Change the Tunics back to Rings from the original version"                                                                                                     -Credits "Nintendo" -Link $Redux.Revert.TunicRing



    # ORIGINAL HUD #

    CreateReduxGroup       -Tag  "UI" -Text "Original HUD (Revert)"
    CreateReduxPanel       -Columns 3.9
    CreateReduxRadioButton -Name "Automap"             -SaveTo "HUD" -Checked -Text "Keep Automap"                -Info "Keep the new Automap Plus feature as it is"                                     -Credits "snarfblam"
    CreateReduxRadioButton -Name "OriginalHUD"         -SaveTo "HUD"          -Text "Original HUD"                -Info "Revert back to the HUD from the original version"                               -Credits "snarfblam"
    CreateReduxRadioButton -Name "GreyAutomap"         -SaveTo "HUD"          -Text "Grey Automap"                -Info "Grayscale the new automap"                                                      -Credits "snarfblam"
    CreateReduxRadioButton -Name "GreyAutomapOriginal" -SaveTo "HUD"          -Text "Grey Automap (Original HUD)" -Info "Grayscale the new automap and revert back to the HUD from the original version" -Credits "snarfblam"



    EnableElem $Redux.Graphics.AnimatedTiles -Active (!$ISwiiVC)

}