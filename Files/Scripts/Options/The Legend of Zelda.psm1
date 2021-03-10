function PatchOptions() {
    
    if (IsChecked $Redux.Graphics.LinksAwakeningGFX)   { ApplyPatch -Patch "\Compressed\links_awakening_gfx.ips" }
    if (IsChecked $Redux.Graphics.RecoloredDungeons)   { ApplyPatch -Patch "\Compressed\recoloured_dungeons.ips" }

    if (IsChecked $Redux.Sound.NoLowHPBeep)            { ApplyPatch -Patch "\Compressed\no_low_hp_beep.ips" }

    if (IsChecked $Redux.Gameplay.BombUpgrades)        { ApplyPatch -Patch "\Compressed\bomb_upgrades.ips" }
    if (IsChecked $Redux.Gameplay.RearrangedBosses)    { ApplyPatch -Patch "\Compressed\rearranged_bosses.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    if (IsChecked $Redux.Revert.NESGFX)                { ApplyPatch -Patch "\Compressed\Original\nes_gfx.ips" }
    if (IsChecked $Redux.Revert.HiddenSecrets)         { ApplyPatch -Patch "\Compressed\Original\hidden_secrets.ips" }
    
}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Width 390 -Height 340

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GRAPHICS #
    CreateReduxGroup    -Tag "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "LinksAwakeningGFX" -Text "Link's Awakening GFX" -Info "Restyle the graphics to look like Link's Awakening from the GameBoy`nNot compatible with the Original NES GFX option" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RecoloredDungeons" -Text "Recolored Dungeons"   -Info "Make each dungeon have its own unique colour palette (like in Modern Classic Edition)"                                -Credits "ShadowOne333"

    # SOUND #
    CreateReduxGroup    -Tag "Sound" -Text "Sound"
    CreateReduxCheckBox -Name "NoLowHPBeep"       -Text "No Low HP Beep"       -Info "Remove the low health beep" -Credits "ShadowOne333"

     # GAMEPLAY #
    CreateReduxGroup    -Tag "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "BombUpgrades"      -Text "Bomb Upgrades"        -Info "Bomb upgrades increases the amount of bombs by 5 instead of 10" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RearrangedBosses"  -Text "Rearranged Bosses"    -Info "Unique bosses in each Dungeon/Level"                            -Credits "ShadowOne333"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # ORIGINAL #
    CreateReduxGroup    -Tag "Revert" -Text "Original (Revert)"
    CreateReduxCheckBox -Name "NESGFX"            -Text "NES GFX"              -Info "Revert back any GFX graphics changes that Redux adjusted, for the original experience`nNot compatible with the Link's Awakening GFX option" -Credits "ShadowOne333" -Link $Redux.Graphics.LinksAwakeningGFX
    CreateReduxCheckBox -Name "HiddenSecrets"     -Text "Hidden Secrets"       -Info "Revert back all hiden secrets like that Redux adjusted, for the orginal experience"                                                         -Credits "ShadowOne333"

}