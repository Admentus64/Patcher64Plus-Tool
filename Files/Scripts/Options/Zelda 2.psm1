function PatchOptionsTheAdventureOfLink() {
    
    if (IsChecked $Redux.Graphics.NewGFX)                   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\new_gfx.ips" }
    if (IsChecked $Redux.Graphics.RevilityEditionSprites)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\revility_edition_sprites.ips" }
    
    if (IsChecked $Redux.Sound.NoLowHPBeep)                 { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\no_low_hp_beep.ips" }
    if (IsChecked $Redux.Sound.ReduceTextSound)             { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\reduce_text_sound.ips" }
    elseif (IsChecked $Redux.Sound.NoTextSound)             { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\no_text_sound.ips" }
    
    if (IsChecked $Redux.Gameplay.RestartSameScreen)        { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\restart_same_screen.ips" }
    if (IsChecked $Redux.Gameplay.FDSKingsTomb)             { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\fds_kings_tomb.ips" }
    if (IsChecked $Redux.Gameplay.Secret)                   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\secret.ips" }

    if (IsChecked $Redux.Experience.NewExp)                 { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\new_exp.ips" }
    if ( (IsChecked $Redux.Experience.KeepExpGameOver ) -and !(IsChecked $Redux.Gameplay.RestartSameScreen) ) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\keep_exp_game_over.ips" }
    if (IsChecked $Redux.Experience.StaticExpPalaceCrystal) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\static_exp_palace_crystal.ips" }

    if (IsChecked $Redux.Other.ReduceLag)                   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\reduce_lag.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxTheAdventureOfLink() {
    
    if (IsChecked $Redux.Revert.EnemyAttributes)            { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\enemy_attributes.ips" }
    if (IsChecked $Redux.Revert.LinkDolls)                  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\link_dolls.ips" }
    if (IsChecked $Redux.Revert.SpellMagicConsumption)      { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\spell_magic_consumption.ips" }
    if (IsChecked $Redux.Music.RandomBattleTheme)           { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\random_battle_theme.ips" }

    if ( (IsChecked $Redux.Revert.TitleScreenPalette) -and (IsChecked $Redux.Revert.TitleScreenSword) ) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\title_screen.ips" }
    elseif (IsChecked $Redux.Revert.TitleScreenPalette)     { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\title_screen_palette.ips" }
    elseif (IsChecked $Redux.Revert.TitleScreenSword)       { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\title_screen_sword.ips" }

    if ( (IsChecked $Redux.Revert.RestartGameOver) -and !(IsChecked $Redux.Gameplay.RestartSameScreen) ) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\restart_game_over.ips" }

}



#==============================================================================================================================================================================================
function CreateOptionsTheAdventureOfLink() {
    
    CreateOptionsDialog -Width 560 -Height 450

    $Redux.Graphics.NewGFX.Add_CheckStateChanged({ $Redux.Graphics.RevilityEditionSprites.Enabled = !$this.Checked })
    $Redux.Graphics.RevilityEditionSprites.Add_CheckStateChanged({ $Redux.Graphics.NewGFX.Enabled = !$this.Checked })
    $Redux.Graphics.NewGFX.Enabled = !$Redux.Graphics.RevilityEditionSprites.Checked
    $Redux.Graphics.RevilityEditionSprites.Enabled = !$Redux.Graphics.NewGFX.Checked

    $Redux.Sound.ReduceTextSound.Add_CheckStateChanged({ $Redux.Sound.NoTextSound.Enabled = !$this.Checked })
    $Redux.Sound.NoTextSound.Add_CheckStateChanged({ $Redux.Sound.ReduceTextSound.Enabled = !$this.Checked })
    $Redux.Sound.ReduceTextSound.Enabled = !$Redux.Sound.NoTextSound.Checked
    $Redux.Sound.NoTextSound.Enabled     = !$Redux.Sound.ReduceTextSound.Checked

    $Redux.Gameplay.RestartSameScreen.Add_CheckStateChanged({
        $Redux.Experience.KeepExpGameOver.Enabled = !$this.Checked
        $Redux.Revert.RestartGameOver.Enabled     = !$this.Checked
     })
    $Redux.Revert.RestartGameOver.Add_CheckStateChanged({ $Redux.Gameplay.RestartSameScreen.Enabled = !$this.Checked })
    $Redux.Experience.KeepExpGameOver.Enabled = !$Redux.Gameplay.RestartSameScreen.Checked
    $Redux.Gameplay.RestartSameScreen.Enabled = !$Redux.Revert.RestartGameOver.Checked
    $Redux.Revert.RestartGameOver.Enabled     = !$Redux.Gameplay.RestartSameScreen.Checked

}



#==============================================================================================================================================================================================
function CreateTabMainTheAdventureOfLink() {

    # GRAPHICS #
    CreateReduxGroup    -Tag "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "NewGFX"                 -Column 1 -Row 1 -Text "New GFX"                   -Info "Completely revamped graphics based on the graphics used in the 'Rev Edition' and 'New Link Sprites' hacks`nNot compatible with the Revility Edition Sprites option"
    CreateReduxCheckBox -Name "RevilityEditionSprites" -Column 2 -Row 1 -Text "Revility Edition Sprites"  -Info "New GFX optional patch, which combines assets from both the 'Rev Edition`nNot compatible with the NEW GFX option' and 'New Link Sprite' hacks"

    # SOUND #
    CreateReduxGroup    -Tag "Sound" -Text "Sound"
    CreateReduxCheckBox -Name "NoLowHPBeep"            -Column 1 -Row 1 -Text "No Low HP Beep"            -Info "Remove the low health beep"
    CreateReduxCheckBox -Name "ReduceTextSound"        -Column 2 -Row 1 -Text "Reduce Text Sound"         -Info "Replace the sound effect that plays during text boxe so that isn’t as intrusive"
    CreateReduxCheckBox -Name "NoTextSound"            -Column 3 -Row 1 -Text "No Text Sound"             -Info "Remove the sound effect that plays during text boxes"

    # GAMEPLAY #
    CreateReduxGroup    -Tag "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "FDSKingsTomb"           -Column 1 -Row 1 -Text "FDS King's Tomb"           -Info "Restores the layout of the King’s Tomb screen to resemble that of the Famicom release of Zelda II"
    CreateReduxCheckBox -Name "RestartSameScreen"      -Column 2 -Row 1 -Text "Restart Same Screen"       -Info "When you die you start at the same screen you died on rather than being brought back to the beginning of the palace or Zelda's palace`nIncludes the Keep Exp At Game Over option`nNot compatible with the Restart Game Over option"
    CreateReduxCheckBox -Name "Secret"                 -Column 3 -Row 1 -Text "Secret"                    -Info "It's a secret"

    # EXPERIENCE #
    CreateReduxGroup    -Tag "Experience" -Text "Experience"
    CreateReduxCheckBox -Name "NewExp"                 -Column 1 -Row 1 -Text "New Exp"                   -Info "A completely revamped Exp system which removes the Level Up window prompt once you reach the required Exp for a new level`nInstead, Experience points will now accumulate, and once you want to Level Up a certain ability,`npressing Up+Start will automatically bring up the Level Up menu, even if you don’t have enough Exp for a level up`nIn that case, the only available option will be 'Cancel'"
    CreateReduxCheckBox -Name "KeepExpGameOver"        -Column 2 -Row 1 -Text "Keep Exp At Game Over"     -Info "You keep all your Exp when you die, but ONLY if you choose Continue (since the Exp is not saved on reboot/restart)"
    CreateReduxCheckBox -Name "StaticExpPalaceCrystal" -Column 3 -Row 1 -Text "Static Exp Palace Crystal" -Info "At the end of each palace, where you put the crystal in, you now get a determined amount of Exp that increases with each palace"
    
    # OTHER #
    CreateReduxGroup    -Tag "Other" -Text "Other"
    CreateReduxCheckBox -Name "ReduceLag"              -Column 1 -Row 1 -Text "Reduce Lag"                -Info "Reduces the amount of enemies that the spawner can put on-screen from 5 to 2, so that the lag caused by the number of sprites is greatly reduced"

}



#==============================================================================================================================================================================================
function CreateTabReduxTheAdventureOfLink() {
    
    # ORIGINAL #
    CreateReduxGroup    -Tag "Revert" -Text "Original (Revert)" -Height 2
    CreateReduxCheckBox -Name "EnemyAttributes"        -Column 1 -Row 1 -Text "Enemy Attributes"        -Info "Restores the original enemy attributes, meaning the enemies will drain Exp from Link, and they will have the same HP and give the same Exp in the original Zelda II"
    CreateReduxCheckBox -Name "LinkDolls"              -Column 2 -Row 1 -Text "Link Dolls"              -Info "Restores the functionality of the Link dolls to be the same as in the original Zelda II, meaning they will not be permanent lives anymore"
    CreateReduxCheckBox -Name "RestartGameOver"        -Column 3 -Row 1 -Text "Restart Game Over"       -Info "Restores the original behaviour of Link getting a Game Over and starting all the way back at Zelda’s Palace`nNot compatible with the Restart Same Screen option"
    CreateReduxCheckBox -Name "SpellMagicConsumption"  -Column 1 -Row 2 -Text "Spell Magic Consumption" -Info "Restores the original magic consumption that each spell takes to that of the original Zelda II"
    CreateReduxCheckBox -Name "TitleScreenPalette"     -Column 2 -Row 2 -Text "Title Screen Palette"    -Info "Restores only the palette of the original Title Screen from Zelda II"
    CreateReduxCheckBox -Name "TitleScreenSword"       -Column 3 -Row 2 -Text "Title Screen Sword"      -Info "Restores only the sword of the original Title Screen from Zelda II"

    # SOUND #
    CreateReduxGroup    -Tag "Music" -Text "Music"
    CreateReduxCheckBox -Name "RandomBattleTheme"      -Column 1 -Row 1 -Text "Random Battle Theme"     -Info "Modifies the way in which the Battle Themes are used from the standard Zelda 2 Redux. With this patch, instead of having the FDS Battle Theme play on East Hyrule, now the game will load either the Battle Themes at random in all encounters."

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsTheAdventureOfLink
Export-ModuleMember -Function PatchReduxTheAdventureOfLink

Export-ModuleMember -Function CreateOptionsTheAdventureOfLink
Export-ModuleMember -Function CreateTabMainTheAdventureOfLink
Export-ModuleMember -Function CreateTabReduxTheAdventureOfLink