function PatchOptionsTheLegendOfZelda() {
    
    # BPS Patching

    if (IsChecked -Elem $Options.NESGFX)                  { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\nes_gfx.ips" }
    if (IsChecked -Elem $Options.HiddenSecrets)           { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\hidden_secrets.ips" }

    if (IsChecked -Elem $Options.LinksAwakening)          { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\links_awakening_gfx.ips" }
    if (IsChecked -Elem $Options.RecoloredDungeons)       { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\recoloured_dungeons.ips" }

    if (IsChecked -Elem $Options.NoLowHPBeep)             { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\no_low_hp_beep.ips" }

    if (IsChecked -Elem $Options.BombUpgrades)            { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\bomb_upgrades.ips" }
    if (IsChecked -Elem $Options.RearrangedBosses)        { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\rearranged_bosses.ips" }

}



#==============================================================================================================================================================================================
function CreateTheLegendOfZeldaOptionsContent() {
    
    CreateOptionsDialog -Width 390 -Height 310
    $ToolTip = CreateTooltip



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.LinksAwakeningGFX         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "Link's Awakening GFX" -ToolTip $ToolTip -Info "Restyle the graphics to look like Link's Awakening from the GameBoy`nNot compatible with the Original NES GFX option" -Name "LinksAwakeningGFX"
    $Options.RecoloredDungeons         = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "Recolored Dungeons"   -ToolTip $ToolTip -Info "Make each dungeon have its own unique colour palette (like in Modern Classic Edition)" -Name "RecoloredDungeons"



    # SOUND #
    $SoundBox                          = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Sound"
    
    $Options.NoLowHPBeep               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $SoundBox -Text "No Low HP Beep"          -ToolTip $ToolTip -Info "Remove the low health beep" -Name "NoLowHPBeep"



     # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($SoundBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"
    
    $Options.BombUpgrades              = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Bomb Upgrades"        -ToolTip $ToolTip -Info "Bomb upgrades increases the amount of bombs by 5 instead of 10" -Name "BombUpgrades"
    $Options.RearrangedBosses          = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Rearranged Bosses"    -ToolTip $ToolTip -Info "Unique bosses in each Dungeon/Level" -Name "RearrangedBosses"

}



#==============================================================================================================================================================================================
function CreateTheLegendOfZeldaReduxContent() {
    
    CreateReduxDialog -Width 400 -Height 200
    $ToolTip = CreateTooltip



    # ORIGINAL #
    $OriginalBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Redux.Panel -Text "Original (Revert)"

    $Options.NESGFX                    = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OriginalBox -Text "NES GFX"              -ToolTip $ToolTip -Info "Revert back any GFX graphics changes that Redux adjusted, for the original experience`nNot compatible with the Link's Awakening GFX option" -Name "NESGFX"
    $Options.HiddenSecrets             = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OriginalBox -Text "Hidden Secrets"       -ToolTip $ToolTip -Info "Revert back all hiden secrets like that Redux adjusted, for the orginal experience" -Name "HiddenSecrets"



    $Options.LinksAwakeningGFX.Add_CheckStateChanged({ $Options.NESGFX.Enabled = !$this.Checked })
    $Options.NESGFX.Add_CheckStateChanged({ $Options.LinksAwakeningGFX.Enabled = !$this.Checked })
    $Options.LinksAwakeningGFX.Enabled = !$Options.NESGFX.Checked
    $Options.NESGFX.Enabled = !$Options.LinksAwakeningGFX.Checked

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsTheLegendOfZelda
Export-ModuleMember -Function CreateTheLegendOfZeldaOptionsContent
Export-ModuleMember -Function CreateTheLegendOfZeldaReduxContent