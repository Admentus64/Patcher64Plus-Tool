function PatchOptions() {
    
    if (IsChecked $Redux.Graphics.NewGFX)                   { ApplyPatch -Patch "Compressed\Optional\new_gfx.ips" }
    if (IsChecked $Redux.Graphics.RevilityEditionSprites)   { ApplyPatch -Patch "Compressed\Optional\revility_edition_sprites.ips" }
    if (IsChecked $Redux.Graphics.ReworkedTitle)            { ApplyPatch -Patch "Compressed\Optional\reworked_title.ips" }
    
    if (IsChecked $Redux.Sound.NoLowHPBeep)                 { ApplyPatch -Patch "Compressed\Optional\no_low_hp_beep.ips" }
    if (IsChecked $Redux.Sound.ChangeMinorItemSFX)          { ApplyPatch -Patch "Compressed\Optional\change_minor_item_sfx.ips" }
    if (IsChecked $Redux.Sound.ReduceTextSound)             { ApplyPatch -Patch "Compressed\Optional\reduce_text_sound.ips" }
    elseif (IsChecked $Redux.Sound.NoTextSound)             { ApplyPatch -Patch "Compressed\Optional\no_text_sound.ips" }
    
    if (IsChecked $Redux.Gameplay.RestartSameScreen)        { ApplyPatch -Patch "Compressed\Optional\restart_same_screen.ips" }
    if (IsChecked $Redux.Gameplay.FDSKingsTomb)             { ApplyPatch -Patch "Compressed\Optional\fds_kings_tomb.ips" }
    if (IsChecked $Redux.Gameplay.TunicChange)              { ApplyPatch -Patch "Compressed\Optional\tunic_change.ips" }
    if (IsChecked $Redux.Gameplay.FairyPreventDoors)        { ApplyPatch -Patch "Compressed\Optional\fairy_not_go_through_doors.ips" }
    if (IsChecked $Redux.Gameplay.Secret)                   { ApplyPatch -Patch "Compressed\Optional\secret.ips" }

    if (IsChecked $Redux.Experience.NewExp)                 { ApplyPatch -Patch "Compressed\Optional\new_exp.ips" }
    if ( (IsChecked $Redux.Experience.KeepExpGameOver ) -and !(IsChecked $Redux.Gameplay.RestartSameScreen) ) { ApplyPatch -Patch "Compressed\Optional\keep_exp_game_over.ips" }
    if (IsChecked $Redux.Experience.StaticExpPalaceCrystal) { ApplyPatch -Patch "Compressed\Optional\static_exp_palace_crystal.ips" }

    if (IsChecked $Redux.Other.ReduceLag)                   { ApplyPatch -Patch "Compressed\Optional\reduce_lag.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    if (IsChecked $Redux.Revert.EnemyAttributes)            { ApplyPatch -Patch "Compressed\Original\enemy_attributes.ips" }
    if (IsChecked $Redux.Revert.EnemyDrops)                 { ApplyPatch -Patch "Compressed\Original\enemy_drops.ips" }
    if (IsChecked $Redux.Revert.LinkDolls)                  { ApplyPatch -Patch "Compressed\Original\link_dolls.ips" }
    if (IsChecked $Redux.Revert.SpellMagicConsumption)      { ApplyPatch -Patch "Compressed\Original\spell_magic_consumption.ips" }
    if (IsChecked $Redux.Revert.NESGFX)                     { ApplyPatch -Patch "Compressed\Original\nes_gfx.ips" }

    if (IsChecked $Redux.Music.RandomBattleTheme)           { ApplyPatch -Patch "Compressed\Optional\random_battle_theme.ips" }

    if   ( (IsChecked $Redux.Revert.TitleScreenPalette) -and (IsChecked $Redux.Revert.TitleScreenSword) ) { ApplyPatch -Patch "Compressed\Original\title_screen.ips" }
    elseif (IsChecked $Redux.Revert.TitleScreenPalette)     { ApplyPatch -Patch "Compressed\Original\title_screen_palette.ips" }
    elseif (IsChecked $Redux.Revert.TitleScreenSword)       { ApplyPatch -Patch "Compressed\Original\title_screen_sword.ips" }

    if ( (IsChecked $Redux.Revert.RestartGameOver) -and !(IsChecked $Redux.Gameplay.RestartSameScreen) ) { ApplyPatch -Patch "Compressed\Original\restart_game_over.ips" }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 4 -Height 470

    $Redux.Gameplay.RestartSameScreen.Add_CheckStateChanged({ EnableElem -Elem $Redux.Experience.KeepExpGameOver -Active (!$this.Checked) })
    EnableElem -Elem $Redux.Experience.KeepExpGameOver -Active (!$Redux.Gameplay.RestartSameScreen.Checked)

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "NewGFX"                 -Text "New GFX"                  -Info "Completely revamped graphics based on the graphics used in the 'Rev Edition' and 'New Link Sprites' hacks`nNot compatible with the Revility Edition Sprites option" -Credits "darthvaderx"
    CreateReduxCheckBox -Name "RevilityEditionSprites" -Text "Revility Edition Sprites" -Info "New GFX optional patch, which combines assets from both the 'Rev Edition`nNot compatible with the NEW GFX option' and 'New Link Sprite' hacks"                      -Credits "Trax" -Link $Redux.Graphics.NewGFX
    CreateReduxCheckBox -Name "ReworkedTitleScreen"    -Text "Reworked Title Screen"    -Info "The Sword is the same as in the original US boxart cover, and the scrolling text fits the canon story"                                                              -Credits "ShadowOne333 and his team"




    # SOUND #

    CreateReduxGroup    -Tag  "Sound" -Text "Sound"
    CreateReduxCheckBox -Name "NoLowHPBeep"            -Text "No Low HP Beep"        -Info "Remove the low health beep"                                                                -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "ChangeMinorItemSFX"     -Text "Change Minor Item SFX" -Info "Replace the sound effect when grabbing a item, so it is different from the Sword Beam SFX" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "ReduceTextSound"        -Text "Reduce Text Sound"     -Info "Replace the sound effect that plays during text boxes so that isn’t as intrusive"          -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "NoTextSound"            -Text "No Text Sound"         -Info "Remove the sound effect that plays during text boxes"                                      -Credits "ShadowOne333 and his team" -Link $Redux.Sound.ReduceTextSound



    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "FDSKingsTomb"           -Text "FDS King's Tomb"       -Info "Restores the layout of the King’s Tomb screen to resemble that of the Famicom release of Zelda II" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "RestartSameScreen"      -Text "Restart Same Screen"   -Info "When you die you start at the same screen you died on rather than being brought back to the beginning of the palace or Zelda's palace`nIncludes the Keep Exp At Game Over option`nNot compatible with the Restart Game Over option" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "TunicChange"            -Text "Tunic Change at Lvl 7" -Info "The tunic changes from Blue to Red when defense reaches lvl 7"                                     -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "FairyPreventDoors"      -Text "Fairy Prevent Doors"   -Info "When using the Fairy Spell you cannot go though any doors anymore"                                 -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "Secret"                 -Text "Secret"                -Info "It's a secret"                                                                                     -Credits "ShadowOne333 and his team"



    # EXPERIENCE #

    CreateReduxGroup    -Tag  "Experience" -Text "Experience"
    CreateReduxCheckBox -Name "NewExp"                 -Text "New Exp"                   -Info "A completely revamped Exp system which removes the Level Up window prompt once you reach the required Exp for a new level`nInstead, Experience points will now accumulate, and once you want to Level Up a certain ability,`npressing Up+Start will automatically bring up the Level Up menu, even if you don’t have enough Exp for a level up`nIn that case, the only available option will be 'Cancel'" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "KeepExpGameOver"        -Text "Keep Exp At Game Over"     -Info "You keep all your Exp when you die, but ONLY if you choose Continue (since the Exp is not saved on reboot/restart)"              -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "StaticExpPalaceCrystal" -Text "Static Exp Palace Crystal" -Info "At the end of each palace, where you put the crystal in, you now get a determined amount of Exp that increases with each palace" -Credits "ShadowOne333 and his team"
    


    # OTHER #

    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "ReduceLag"              -Text "Reduce Lag" -Info "Reduces the amount of enemies that the spawner can put on-screen from 5 to 2, so that the lag caused by the number of sprites is greatly reduced" -Credits "ShadowOne333 and his team"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert" -Text "Original (Revert)"
    CreateReduxCheckBox -Name "EnemyAttributes"        -Text "Enemy Attributes"        -Info "Restores the original enemy attributes, meaning the enemies will drain Exp from Link, and they will have the same HP and give the same Exp in the original Zelda II" -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "EnemyDrops"             -Text "Enemy Drops"             -Info "Restores the original enemy item drop rules, meaning the enemies will drop items every 6th kill like in the original Zelda II"                                       -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "LinkDolls"              -Text "Link Dolls"              -Info "Restores the functionality of the Link dolls to be the same as in the original Zelda II, meaning they will not be permanent lives anymore"                           -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "RestartGameOver"        -Text "Restart Game Over"       -Info "Restores the original behaviour of Link getting a Game Over and starting all the way back at Zelda’s Palace`nNot compatible with the Restart Same Screen option"     -Credits "ShadowOne333 and his team" -Link $Redux.Gameplay.RestartSameScreen
    CreateReduxCheckBox -Name "SpellMagicConsumption"  -Text "Spell Magic Consumption" -Info "Restores the original magic consumption that each spell takes to that of the original Zelda II"                                                                      -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "NESGFX"                 -Text "NES GFX"                 -Info "Restores the graphics as used in the original Zelda II"                                                                                                              -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "TitleScreenPalette"     -Text "Title Screen Palette"    -Info "Restores only the palette of the original Title Screen from Zelda II"                                                                                                -Credits "ShadowOne333 and his team"
    CreateReduxCheckBox -Name "TitleScreenSword"       -Text "Title Screen Sword"      -Info "Restores only the sword of the original Title Screen from Zelda II"                                                                                                  -Credits "ShadowOne333 and his team"



    # SOUND #

    CreateReduxGroup    -Tag  "Music" -Text "Music"
    CreateReduxCheckBox -Name "RandomBattleTheme"      -Text "Random Battle Theme" -Info "Modifies the way in which the Battle Themes are used from the standard Zelda 2 Redux`nWith this patch, instead of having the FDS Battle Theme play on East Hyrule, now the game will load either the Battle Themes at random in all encounters" -Credits "ShadowOne333 and his team"

}