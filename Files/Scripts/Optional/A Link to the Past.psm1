function PatchOptionsALinkToThePast() {
    
    # BPS Patching
    
    if (IsChecked -Elem $Options.PinkHairGFX) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\pink_hair.ips" }
    if (IsChecked -Elem $MenuGFX.MenuGFX)     { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\menu.ips" }

}



#==============================================================================================================================================================================================
function CreateALinkToThePastOptionsContent() {
    
    CreateOptionsDialog -Width 390 -Height 200
    $ToolTip = CreateTooltip



    # GRAPHICS #
    $OriginalBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Original (Revert)"
    
    $Options.PinkHairGFX               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OriginalBox -Text "Pink Hair GFX" -ToolTip $ToolTip -Info "Restores the Pink Hair for Link to that of the original game" -Name "PinkHairGFX"
    $Options.MenuGFX                   = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OriginalBox -Text "Menu GFX"      -ToolTip $ToolTip -Info "Restores the menu to that of the original game" -Name "MenuGFX"

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsALinkToThePast
Export-ModuleMember -Function CreateALinkToThePastOptionsContent