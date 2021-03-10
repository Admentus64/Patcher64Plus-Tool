function PatchOptions() {
    
    if (IsChecked $Redux.Graphics.NewGFX)                   { ApplyPatch -Patch "\Compressed\new_gfx.ips" }
    if (IsChecked $Redux.Graphics.RevilityEditionSprites)   { ApplyPatch -Patch "\Compressed\revility_edition_sprites.ips" }
    
    if (IsChecked $Redux.Sound.NoLowHPBeep)                 { ApplyPatch -Patch "\Compressed\no_low_hp_beep.ips" }
    if (IsChecked $Redux.Sound.ReduceTextSound)             { ApplyPatch -Patch "\Compressed\reduce_text_sound.ips" }
    elseif (IsChecked $Redux.Sound.NoTextSound)             { ApplyPatch -Patch "\Compressed\no_text_sound.ips" }
    
    if (IsChecked $Redux.Gameplay.RestartSameScreen)        { ApplyPatch -Patch "\Compressed\restart_same_screen.ips" }
    if (IsChecked $Redux.Gameplay.FDSKingsTomb)             { ApplyPatch -Patch "\Compressed\fds_kings_tomb.ips" }
    if (IsChecked $Redux.Gameplay.Secret)                   { ApplyPatch -Patch "\Compressed\secret.ips" }

    if (IsChecked $Redux.Experience.NewExp)                 { ApplyPatch -Patch "\Compressed\new_exp.ips" }
    if ( (IsChecked $Redux.Experience.KeepExpGameOver ) -and !(IsChecked $Redux.Gameplay.RestartSameScreen) ) { ApplyPatch -Patch "\Compressed\keep_exp_game_over.ips" }
    if (IsChecked $Redux.Experience.StaticExpPalaceCrystal) { ApplyPatch -Patch "\Compressed\static_exp_palace_crystal.ips" }

    if (IsChecked $Redux.Other.ReduceLag)                   { ApplyPatch -Patch "\Compressed\reduce_lag.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    if (IsChecked $Redux.Revert.EnemyAttributes)            { ApplyPatch -Patch "\Compressed\Original\enemy_attributes.ips" }
    if (IsChecked $Redux.Revert.LinkDolls)                  { ApplyPatch -Patch "\Compressed\Original\link_dolls.ips" }
    if (IsChecked $Redux.Revert.SpellMagicConsumption)      { ApplyPatch -Patch "\Compressed\Original\spell_magic_consumption.ips" }
    if (IsChecked $Redux.Music.RandomBattleTheme)           { ApplyPatch -Patch "\Compressed\random_battle_theme.ips" }

    if ( (IsChecked $Redux.Revert.TitleScreenPalette) -and (IsChecked $Redux.Revert.TitleScreenSword) ) { ApplyPatch -Patch "\Compressed\Original\title_screen.ips" }
    elseif (IsChecked $Redux.Revert.TitleScreenPalette)     { ApplyPatch -Patch "\Compressed\Original\title_screen_palette.ips" }
    elseif (IsChecked $Redux.Revert.TitleScreenSword)       { ApplyPatch -Patch "\Compressed\Original\title_screen_sword.ips" }

    if ( (IsChecked $Redux.Revert.RestartGameOver) -and !(IsChecked $Redux.Gameplay.RestartSameScreen) ) { ApplyPatch -Patch "\Compressed\Original\restart_game_over.ips" }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Width 560 -Height 450

    $Redux.Gameplay.RestartSameScreen.Add_CheckStateChanged({ EnableElem -Elem $Redux.Experience.KeepExpGameOver -Active (!$this.Checked) })
    EnableElem -Elem $Redux.Experience.KeepExpGameOver -Active (!$Redux.Gameplay.RestartSameScreen.Checked)

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GRAPHICS #
    CreateReduxGroup    -Tag "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "NewGFX"                 -Text "New GFX"                   -Info "Completely revamped graphics based on the graphics used in the 'Rev Edition' and 'New Link Sprites' hacks`nNot compatible with the Revility Edition Sprites option" -Credits "darthvaderx"
    CreateReduxCheckBox -Name "RevilityEditionSprites" -Text "Revility Edition Sprites"  -Info "New GFX optional patch, which combines assets from both the 'Rev Edition`nNot compatible with the NEW GFX option' and 'New Link Sprite' hacks"                      -Credits "Trax" -Link $Redux.Graphics.NewGFX

    # SOUND #
    CreateReduxGroup    -Tag "Sound" -Text "Sound"
    CreateReduxCheckBox -Name "NoLowHPBeep"            -Text "No Low HP Beep"            -Info "Remove the low health beep"                                                      -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "ReduceTextSound"        -Text "Reduce Text Sound"         -Info "Replace the sound effect that plays during text boxe so that isn’t as intrusive" -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "NoTextSound"            -Text "No Text Sound"             -Info "Remove the sound effect that plays during text boxes"                            -Credits "ShadowOne333 and this team" -Link $Redux.Sound.ReduceTextSound

    # GAMEPLAY #
    CreateReduxGroup    -Tag "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "FDSKingsTomb"           -Text "FDS King's Tomb"           -Info "Restores the layout of the King’s Tomb screen to resemble that of the Famicom release of Zelda II" -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "RestartSameScreen"      -Text "Restart Same Screen"       -Info "When you die you start at the same screen you died on rather than being brought back to the beginning of the palace or Zelda's palace`nIncludes the Keep Exp At Game Over option`nNot compatible with the Restart Game Over option" -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "Secret"                 -Text "Secret"                    -Info "It's a secret" -Credits "ShadowOne333 and this team"

    # EXPERIENCE #
    CreateReduxGroup    -Tag "Experience" -Text "Experience"
    CreateReduxCheckBox -Name "NewExp"                 -Text "New Exp"                   -Info "A completely revamped Exp system which removes the Level Up window prompt once you reach the required Exp for a new level`nInstead, Experience points will now accumulate, and once you want to Level Up a certain ability,`npressing Up+Start will automatically bring up the Level Up menu, even if you don’t have enough Exp for a level up`nIn that case, the only available option will be 'Cancel'" -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "KeepExpGameOver"        -Text "Keep Exp At Game Over"     -Info "You keep all your Exp when you die, but ONLY if you choose Continue (since the Exp is not saved on reboot/restart)"              -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "StaticExpPalaceCrystal" -Text "Static Exp Palace Crystal" -Info "At the end of each palace, where you put the crystal in, you now get a determined amount of Exp that increases with each palace" -Credits "ShadowOne333 and this team"
    
    # OTHER #
    CreateReduxGroup    -Tag "Other" -Text "Other"
    CreateReduxCheckBox -Name "ReduceLag"              -Text "Reduce Lag"                -Info "Reduces the amount of enemies that the spawner can put on-screen from 5 to 2, so that the lag caused by the number of sprites is greatly reduced" -Credits "ShadowOne333 and this team"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # ORIGINAL #
    CreateReduxGroup    -Tag "Revert" -Text "Original (Revert)"
    CreateReduxCheckBox -Name "EnemyAttributes"        -Text "Enemy Attributes"        -Info "Restores the original enemy attributes, meaning the enemies will drain Exp from Link, and they will have the same HP and give the same Exp in the original Zelda II" -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "LinkDolls"              -Text "Link Dolls"              -Info "Restores the functionality of the Link dolls to be the same as in the original Zelda II, meaning they will not be permanent lives anymore"                           -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "RestartGameOver"        -Text "Restart Game Over"       -Info "Restores the original behaviour of Link getting a Game Over and starting all the way back at Zelda’s Palace`nNot compatible with the Restart Same Screen option"     -Credits "ShadowOne333 and this team" -Link $Redux.Gameplay.RestartSameScreen
    CreateReduxCheckBox -Name "SpellMagicConsumption"  -Text "Spell Magic Consumption" -Info "Restores the original magic consumption that each spell takes to that of the original Zelda II"                                                                      -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "TitleScreenPalette"     -Text "Title Screen Palette"    -Info "Restores only the palette of the original Title Screen from Zelda II"                                                                                                -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "TitleScreenSword"       -Text "Title Screen Sword"      -Info "Restores only the sword of the original Title Screen from Zelda II"                                                                                                  -Credits "ShadowOne333 and this team"

    # SOUND #
    CreateReduxGroup    -Tag "Music" -Text "Music"
    CreateReduxCheckBox -Name "RandomBattleTheme"      -Text "Random Battle Theme"     -Info "Modifies the way in which the Battle Themes are used from the standard Zelda 2 Redux. With this patch, instead of having the FDS Battle Theme play on East Hyrule, now the game will load either the Battle Themes at random in all encounters." -Credits "ShadowOne333 and this team"

}