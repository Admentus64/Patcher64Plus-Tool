function PatchOptionsTheLegendOfZelda() {
    
    if (IsChecked -Elem $Redux.Graphics.LinksAwakeningGFX)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\links_awakening_gfx.ips" }
    if (IsChecked -Elem $Redux.Graphics.RecoloredDungeons)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\recoloured_dungeons.ips" }

    if (IsChecked -Elem $Redux.Sound.NoLowHPBeep)            { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\no_low_hp_beep.ips" }

    if (IsChecked -Elem $Redux.Gameplay.BombUpgrades)        { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\bomb_upgrades.ips" }
    if (IsChecked -Elem $Redux.Gameplay.RearrangedBosses)    { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\rearranged_bosses.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxTheLegendOfZelda() {
    
    if (IsChecked -Elem $Redux.Revert.NESGFX)                { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\nes_gfx.ips" }
    if (IsChecked -Elem $Redux.Revert.HiddenSecrets)         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\hidden_secrets.ips" }
    
}



#==============================================================================================================================================================================================
function CreateOptionsTheLegendOfZelda() {
    
    CreateOptionsDialog -Width 390 -Height 340

    $Redux.Graphics.LinksAwakeningGFX.Add_CheckStateChanged({ $Redux.Revert.NESGFX.Enabled = !$this.Checked })
    $Redux.Revert.NESGFX.Add_CheckStateChanged({ $Redux.Graphics.LinksAwakeningGFX.Enabled = !$this.Checked })
    $Redux.Graphics.LinksAwakeningGFX.Enabled = !$Redux.Revert.NESGFX.Checked
    $Redux.Revert.NESGFX.Enabled = !$Redux.Graphics.LinksAwakeningGFX.Checked

}



#==============================================================================================================================================================================================
function CreateTabMainTheLegendOfZelda() {

    # GRAPHICS #
    CreateReduxGroup    -Tag "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "LinksAwakeningGFX" -Column 1 -Text "Link's Awakening GFX" -Info "Restyle the graphics to look like Link's Awakening from the GameBoy`nNot compatible with the Original NES GFX option"
    CreateReduxCheckBox -Name "RecoloredDungeons" -Column 2 -Text "Recolored Dungeons"   -Info "Make each dungeon have its own unique colour palette (like in Modern Classic Edition)"

    # SOUND #
    CreateReduxGroup    -Tag "Sound" -Text "Sound"
    CreateReduxCheckBox -Name "NoLowHPBeep"       -Column 1 -Text "No Low HP Beep"       -Info "Remove the low health beep"

     # GAMEPLAY #
    CreateReduxGroup    -Tag "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "BombUpgrades"      -Column 1 -Text "Bomb Upgrades"        -Info "Bomb upgrades increases the amount of bombs by 5 instead of 10"
    CreateReduxCheckBox -Name "RearrangedBosses"  -Column 2 -Text "Rearranged Bosses"    -Info "Unique bosses in each Dungeon/Level"

}



#==============================================================================================================================================================================================
function CreateTabReduxTheLegendOfZelda() {
    
    # ORIGINAL #
    CreateReduxGroup    -Tag "Revert" -Text "Original (Revert)"
    CreateReduxCheckBox -Name "NESGFX"             -Column 1 -Text "NES GFX"              -Info "Revert back any GFX graphics changes that Redux adjusted, for the original experience`nNot compatible with the Link's Awakening GFX option"
    CreateReduxCheckBox -Name "HiddenSecrets"      -Column 2 -Text "Hidden Secrets"       -Info "Revert back all hiden secrets like that Redux adjusted, for the orginal experience"

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsTheLegendOfZelda
Export-ModuleMember -Function PatchReduxTheLegendOfZelda

Export-ModuleMember -Function CreateOptionsTheLegendOfZelda
Export-ModuleMember -Function CreateTabMainTheLegendOfZelda
Export-ModuleMember -Function CreateTabReduxTheLegendOfZelda