function PatchOptionsTheAdventureOfLink() {
    
    # BPS Patching

    if (IsChecked -Elem $Redux.EnemyAttributes)           { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\enemy_attributes.ips" }
    if (IsChecked -Elem $Redux.LinkDolls)                 { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\link_dolls.ips" }
    if (IsChecked -Elem $Options.RestartSameScreen)       { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\restart_same_screen.ips" }
    elseif (IsChecked -Elem $Redux.RestartGameOver)       { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\restart_game_over.ips" }
    if (IsChecked -Elem $Redux.SpellMagicConsumption)     { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\spell_magic_consumption.ips" }

    if ( (IsChecked -Elem $Redux.TitleScreenPalette) -and (IsChecked -Elem $Options.TitleScreenSword) ) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\title_screen.ips" }
    elseif (IsChecked -Elem $Redux.TitleScreenPalette)    { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\title_screen_palette.ips" }
    elseif (IsChecked -Elem $Redux.TitleScreenSword)      { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\title_screen_sword.ips" }

    if (IsChecked -Elem $Options.NewGFX)                  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\new_gfx.ips" }
    if (IsChecked -Elem $Options.RevilityEditionSprites)  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\revility_edition_sprites.ips" }

    if (IsChecked -Elem $Options.NoLowHPBeep)             { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\no_low_hp_beep.ips" }
    if (IsChecked -Elem $Options.ReduceTextSound)         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\reduce_text_sound.ips" }
    elseif (IsChecked -Elem $Options.NoTextSound)         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\no_text_sound.ips" }
    if (IsChecked -Elem $Redux.RandomBattleTheme)         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\random_battle_theme.ips" }

    if (IsChecked -Elem $Options.FDSKingsTomb)            { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\fds_kings_tomb.ips" }
    if (IsChecked -Elem $Options.Secret)                  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\secret.ips" }

    if (IsChecked -Elem $Options.NewExp)                  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\new_exp.ips" }
    if ( (IsChecked -Elem $Options.KeepExpGameOver ) -and !(IsChecked -Elem $Options.RestartSameScreen) ) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\keep_exp_game_over.ips" }
    if (IsChecked -Elem $Options.StaticExpPalaceCrystal)  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\static_exp_palace_crystal.ips" }

    if (IsChecked -Elem $Options.ReduceLag)               { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\reduce_lag.ips" }

}



#==============================================================================================================================================================================================
function CreateTheAdventureOfLinkOptionsContent() {
    
    CreateOptionsDialog -Width 560 -Height 420
    $ToolTip = CreateTooltip



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.NewGFX                    = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "New GFX"                     -ToolTip $ToolTip -Info "Completely revamped graphics based on the graphics used in the 'Rev Edition' and 'New Link Sprites' hacks`nNot compatible with the Revility Edition Sprites option" -Name "NewGFX"
    $Options.RevilityEditionSprites    = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "Revility Edition Sprites"    -ToolTip $ToolTip -Info "New GFX optional patch, which combines assets from both the 'Rev Edition`nNot compatible with the NEW GFX option' and 'New Link Sprite' hacks" -Name "RevilityEditionSprites"



    # SOUND #
    $SoundBox                          = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Sound"
    
    $Options.NoLowHPBeep               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $SoundBox -Text "No Low HP Beep"                 -ToolTip $ToolTip -Info "Remove the low health beep" -Name "NoLowHPBeep"
    $Options.ReduceTextSound           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $SoundBox -Text "Reduce Text Sound"              -ToolTip $ToolTip -Info "Replace the sound effect that plays during text boxe so that isn’t as intrusive" -Name "ReduceTextSound"
    $Options.NoTextSound               = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $SoundBox -Text "No Text Sound"                  -ToolTip $ToolTip -Info "Remove the sound effect that plays during text boxes" -Name "NoTextSound"


     # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($SoundBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"
    
    $Options.FDSKingsTomb              = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "FDS King's Tomb"             -ToolTip $ToolTip -Info "Restores the layout of the King’s Tomb screen to resemble that of the Famicom release of Zelda II" -Name "FDSKingsTomb"
    $Options.RestartSameScreen         = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Restart Same Screen"         -ToolTip $ToolTip -Info "When you die you start at the same screen you died on rather than being brought back to the beginning of the palace or Zelda's palace`nIncludes the Keep Exp At Game Over option`nNot compatible with the Restart Game Over option" -Name "RestartSameScreen"
    $Options.Secret                    = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Secret"                      -ToolTip $ToolTip -Info "It's a secret" -Name "Secret"



    # EXPERIENCE #
    $ExperienceBox                     = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Experience"

    $Options.NewExp                    = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ExperienceBox -Text "New Exp"                   -ToolTip $ToolTip -Info "A completely revamped Exp system which removes the Level Up window prompt once you reach the required Exp for a new level`nInstead, Experience points will now accumulate, and once you want to Level Up a certain ability,`npressing Up+Start will automatically bring up the Level Up menu, even if you don’t have enough Exp for a level up`nIn that case, the only available option will be 'Cancel'" -Name "NewExp"
    $Options.KeepExpGameOver           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $ExperienceBox -Text "Keep Exp At Game Over"     -ToolTip $ToolTip -Info "You keep all your Exp when you die, but ONLY if you choose Continue (since the Exp is not saved on reboot/restart)" -Name "KeepExpGameOver"
    $Options.StaticExpPalaceCrystal    = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $ExperienceBox -Text "Static Exp Palace Crystal" -ToolTip $ToolTip -Info "At the end of each palace, where you put the crystal in, you now get a determined amount of Exp that increases with each palace" -Name "StaticExpPalaceCrystal"
    


    # OTHER #
    $OtherBox                          = CreateReduxGroup -Y ($ExperienceBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Other"

    $Options.ReduceLag                 = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OtherBox -Text "Reduce Lag"                     -ToolTip $ToolTip -Info "Reduces the amount of enemies that the spawner can put on-screen from 5 to 2, so that the lag caused by the number of sprites is greatly reduced" -Name "ReduceLag"



    $Options.NewGFX.Add_CheckStateChanged({ $Options.RevilityEditionSprites.Enabled = !$this.Checked })
    $Options.RevilityEditionSprites.Add_CheckStateChanged({ $Options.NewGFX.Enabled = !$this.Checked })
    $Options.NewGFX.Enabled = !$Options.RevilityEditionSprites.Checked
    $Options.RevilityEditionSprites.Enabled = !$Options.NewGFX.Checked

    $Options.ReduceTextSound.Add_CheckStateChanged({ $Options.NoTextSound.Enabled = !$this.Checked })
    $Options.NoTextSound.Add_CheckStateChanged({ $Options.ReduceTextSound.Enabled = !$this.Checked })
    $Options.ReduceTextSound.Enabled = !$Options.NoTextSound.Checked
    $Options.NoTextSound.Enabled = !$Options.ReduceTextSound.Checked

    $Options.RestartSameScreen.Add_CheckStateChanged({ $Options.KeepExpGameOver.Enabled = !$this.Checked })
    $Options.KeepExpGameOver.Enabled = !$Options.RestartSameScreen.Checked

}



#==============================================================================================================================================================================================
function CreateTheAdventureOfLinkReduxContent() {
    
    CreateReduxDialog -Width 560 -Height 290
    $ToolTip = CreateTooltip



    # ORIGINAL #
    $OriginalBox                       = CreateReduxGroup -Y 50 -Height 2 -AddTo $Redux.Panel -Text "Original (Revert)"

    $Redux.EnemyAttributes             = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OriginalBox -Text "Enemy Attributes"            -ToolTip $ToolTip -Info "Restores the original enemy attributes, meaning the enemies will drain Exp from Link, and they will have the same HP and give the same Exp in the original Zelda II" -Name "EnemyAttributes"
    $Redux.LinkDolls                   = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OriginalBox -Text "Link Dolls"                  -ToolTip $ToolTip -Info "Restores the functionality of the Link dolls to be the same as in the original Zelda II, meaning they will not be permanent lives anymore" -Name "LinkDolls"
    $Redux.RestartGameOver             = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $OriginalBox -Text "Restart Game Over"           -ToolTip $ToolTip -Info "Restores the original behaviour of Link getting a Game Over and starting all the way back at Zelda’s Palace`nNot compatible with the Restart Same Screen option" -Name "RestartGameOver"
    $Redux.SpellMagicConsumption       = CreateReduxCheckBox -Column 0 -Row 2 -AddTo $OriginalBox -Text "Spell Magic Consumption"     -ToolTip $ToolTip -Info "Restores the original magic consumption that each spell takes to that of the original Zelda II" -Name "SpellMagicConsumption"
    $Redux.TitleScreenPalette          = CreateReduxCheckBox -Column 1 -Row 2 -AddTo $OriginalBox -Text "Title Screen Palette"        -ToolTip $ToolTip -Info "Restores only the palette of the original Title Screen from Zelda II" -Name "TitleScreenPalette"
    $Redux.TitleScreenSword            = CreateReduxCheckBox -Column 2 -Row 2 -AddTo $OriginalBox -Text "Title Screen Sword"          -ToolTip $ToolTip -Info "Restores only the sword of the original Title Screen from Zelda II" -Name "TitleScreenSword"

    # SOUND #
    $SoundBox                          = CreateReduxGroup -Y ($OriginalBox.Bottom + 5) -Height 1 -AddTo $Redux.Panel -Text "Sound"

    $Redux.RandomBattleTheme           = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $SoundBox -Text "Random Battle Theme"            -ToolTip $ToolTip -Info "Modifies the way in which the Battle Themes are used from the standard Zelda 2 Redux. With this patch, instead of having the FDS Battle Theme play on East Hyrule, now the game will load either the Battle Themes at random in all encounters." -Name "RandomBattleTheme"



    $Options.RestartSameScreen.Add_CheckStateChanged({ $Redux.RestartGameOver.Enabled = !$this.Checked })
    $Redux.RestartGameOver.Add_CheckStateChanged({ $Options.RestartSameScreen.Enabled = !$this.Checked })
    $Options.RestartSameScreen.Enabled = !$Redux.RestartGameOver.Checked
    $Redux.RestartGameOver.Enabled = !$Options.RestartSameScreen.Checked

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsTheAdventureOfLink
Export-ModuleMember -Function CreateTheAdventureOfLinkOptionsContent
Export-ModuleMember -Function CreateTheAdventureOfLinkReduxContent