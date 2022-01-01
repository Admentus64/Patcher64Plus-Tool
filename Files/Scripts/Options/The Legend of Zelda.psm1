function PatchOptions() {
    
    if (IsChecked $Redux.Graphics.LinksAwakeningGFX)          { ApplyPatch -Patch "Compressed\Optional\links_awakening_gfx.ips" }
    if (IsChecked $Redux.Graphics.RecoloredDungeons)          { ApplyPatch -Patch "Compressed\Optional\recoloured_dungeons.ips" }
    if (IsChecked $Redux.Graphics.BluerTunic)                 { ApplyPatch -Patch "Compressed\Optional\bluer_tunic.ips" }
    if (IsChecked $Redux.Graphics.FDSFont)                    { ApplyPatch -Patch "Compressed\Optional\fds_font.ips" }

    if     (IsChecked $Redux.Title.ReworkedTitleScreen)       { ApplyPatch -Patch "Compressed\Optional\reworked_title_screen.ips" }
    elseif (IsChecked $Redux.Title.ReworkedTitleWithout)      { ApplyPatch -Patch "Compressed\Optional\reworked_title_screen_without_subtitles.ips" }
    elseif (IsChecked $Redux.Title.RemoveSubtitle)            { ApplyPatch -Patch "Compressed\Optional\remove_subtitle.ips" }

    if (IsChecked $Redux.Sound.NoLowHPBeep)                   { ApplyPatch -Patch "Compressed\Optional\no_low_hp_beep.ips" }

    if (IsChecked $Redux.Gameplay.RearrangedBosses)           { ApplyPatch -Patch "Compressed\Optional\rearranged_bosses.ips" }
    if (IsChecked $Redux.Gameplay.FullHealthStart)            { ApplyPatch -Patch "Compressed\Optional\full_health_start.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    if (IsChecked $Redux.Graphics.AnimatedTiles)          { ApplyPatch -Patch "Compressed\Optional\animated_tiles.ips" }

    if (IsChecked $Redux.Revert.HiddenSecrets)            { ApplyPatch -Patch "Compressed\Original\hidden_secrets.ips" }
    if (IsChecked $Redux.Revert.DisableDiagionalSword)    { ApplyPatch -Patch "Compressed\Original\disable_diagonal_sword.ips" }
    if (IsChecked $Redux.Revert.OverworldColumns)         { ApplyPatch -Patch "Compressed\Original\overworld_columns.ips" }
    if (IsChecked $Redux.Revert.BombAmounts)              { ApplyPatch -Patch "Compressed\Original\bomb_amounts.ips" }

    if (IsChecked $Redux.Revert.NESGFX)                   { ApplyPatch -Patch "Compressed\Original\nes_gfx.ips" }
    if (IsChecked $Redux.Revert.FastWaterfall)            { ApplyPatch -Patch "Compressed\Original\fast_waterfall.ips" }
    if (IsChecked $Redux.Revert.TunicRing)                { ApplyPatch -Patch "Compressed\Original\tunic_ring.ips" }
    if (IsChecked $Redux.Revert.TunicNESRing)             { ApplyPatch -Patch "Compressed\Original\tunic_nes_ring.ips" }

    if (IsChecked $Redux.UI.OriginalHUD)                  { ApplyPatch -Patch "Compressed\Original\original_hud.ips" }
    if (IsChecked $Redux.UI.GreyAutomap)                  { ApplyPatch -Patch "Compressed\Original\grey_automap.ips" }
    if (IsChecked $Redux.UI.GreyAutomapOriginal)          { ApplyPatch -Patch "Compressed\Original\grey_automap_original.ips" }
    
}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 4 -Height 390

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"          -Text "Graphics"
    CreateReduxCheckBox -Name "LinksAwakeningGFX" -Text "Link's Awakening GFX"     -Info "Restyle the graphics to look like Link's Awakening from the GameBoy`nNot compatible with the Original NES GFX option" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "RecoloredDungeons" -Text "Recolored Dungeons"       -Info "Make each dungeon have its own unique colour palette (like in Modern Classic Edition)"                                -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "BluerTunic"        -Text "Bluer Tunic"              -Info "Make the Blue Tunic more blue"                                                                                        -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "FDSFont"           -Text "Famicon Disk System Font" -Info "Use the font from the Famicom Disk System"                                                                            -Credits "ShadowOne333 and his team"



    # TITLE SCREEN #

    CreateReduxGroup       -Tag   "Title" -Text "Title Screen"
    CreateReduxPanel       -Columns 3.9
    CreateReduxRadioButton -Name "Subtitle"             -SaveTo "TitleScreen" -Checked -Text "Keep Title Screen"               -Info "Keep the title screen as it is"
    CreateReduxRadioButton -Name "ReworkedTitleScreen"  -SaveTo "TitleScreen"          -Text "Reworked Title Screen"           -Info "Reworked title screen to match the more recent Zelda title screen"                                -Credits "ShadowOne333 and his team"
    CreateReduxRadioButton -Name "ReworkedTitleWithout" -SaveTo "TitleScreen"          -Text "Reworked Title Without Subtitle" -Info "Reworked title screen to match the more recent Zelda title screen but removed the added subtitle" -Credits "ShadowOne333 and his team"
    CreateReduxRadioButton -Name "RemoveSubtitle"       -SaveTo "TitleScreen"          -Text "Remove Subtitle"                 -Info "Remove the added subtitle from the title screen"                                                  -Credits "ShadowOne333 and his team"
    
    

    # SOUND #

    CreateReduxGroup    -Tag  "Sound"       -Text "Sound"
    CreateReduxCheckBox -Name "NoLowHPBeep" -Text "No Low HP Beep" -Info "Remove the low health beep" -Credits "ShadowOne333"



     # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"         -Text "Gameplay"
    CreateReduxCheckBox -Name "RearrangedBosses" -Text "Rearranged Bosses"    -Info "Unique bosses in each Dungeon/Level"                            -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "FullHealthStart"  -Text "Full Health at Start" -Info "Start with all hearts restored when opening your save file"     -Credits "ShadowOne333 and his team"

    

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "AnimatedTiles"         -Text "Animated Tiles"         -Info "Animate the tiles"  -Credits "ShadowOne333 and his team" -Warning "Does not work on the Wii Virtual Console or less accurate NES emulators"




    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert" -Text "Original (Revert)"
    CreateReduxCheckBox -Name "HiddenSecrets"         -Text "Hidden Secrets"         -Info "Revert back all hiden secrets like that Redux adjusted, for the orginal experience"  -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "DisableDiagionalSword" -Text "Disable Diagonal Sword" -Info "Remove the ability to swing the sword diagonal as the original version"              -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "OverworldColumns"      -Text "Overworld Columns"      -Info "Revert back the blocky overworld screen/column definition from the original version" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "BombUpgrades"          -Text "Bomb Upgrades"          -Info "Revert back bomb upgrades to increase the amount of bombs by 5 instead of 10"        -Credits "ShadowOne333 and his team"
    


    # ORIGINAL GFX #

    CreateReduxGroup    -Tag  "Revert" -Text "Original GFX (Revert)"
    CreateReduxCheckBox -Name "NESGFX"                -Text "NES GFX"          -Info "Revert back any GFX graphics changes that Redux adjusted, for the original experience`nNot compatible with the Link's Awakening GFX option" -Credits "ShadowOne333 and his team" -Link $Redux.Graphics.LinksAwakeningGFX
    CreateReduxCheckBox -Name "FastWaterfall"         -Text "Fast Waterfall"   -Info "Revert back the fast waterfall from the original version"                                                                                   -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "TunicRing"             -Text "Tunic 2 Ring"     -Info "Change the Tunics back to Rings with the revamped sprite"                                                                                   -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "TunicNESRing"          -Text "Tunic 2 NES Ring" -Info "Change the Tunics back to Rings from the original version"                                                                                  -Credits "ShadowOne333 and his team" -Link $Redux.Revert.TunicRing



    # ORIGINAL HUD #

    CreateReduxGroup       -Tag  "UI" -Text "Original HUD (Revert)"
    CreateReduxPanel       -Columns 3.9
    CreateReduxRadioButton -Name "Automap"             -SaveTo "HUD" -Checked  -Text "Keep Automap"                -Info "Keep the new Automap Plus feature as it is"                                     -Credits "ShadowOne333 and his team"
    CreateReduxRadioButton -Name "OriginalHUD"         -SaveTo "HUD"           -Text "Original HUD"                -Info "Revert back to the HUD from the original version"                               -Credits "ShadowOne333 and his team"
    CreateReduxRadioButton -Name "GreyAutomap"         -SaveTo "HUD"           -Text "Grey Automap"                -Info "Grayscale the new automap"                                                      -Credits "ShadowOne333 and his team"
    CreateReduxRadioButton -Name "GreyAutomapOriginal" -SaveTo "HUD"           -Text "Grey Automap (Original HUD)" -Info "Grayscale the new automap and revert back to the HUD from the original version" -Credits "ShadowOne333 and his team"



    EnableElem $Redux.Graphics.AnimatedTiles -Active (!$ISwiiVC)

}