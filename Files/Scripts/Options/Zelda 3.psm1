function PatchOptionsALinkToThePast() {
    
    if (IsChecked -Elem $Redux.PinkHairGFX)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\pink_hair.ips" }
    if (IsChecked -Elem $Redux.MenuGFX)       { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\menu.ips" }

}



#==============================================================================================================================================================================================
function CreateOptionsALinkToThePast() {
    
    CreateOptionsDialog -Width 390 -Height 200

    # GRAPHICS #
    CreateReduxGroup -Text "Original (Revert)"
    CreateReduxCheckBox -Name "PinkHairGFX" -Column 1 -Text "Pink Hair GFX" -Info "Restores the Pink Hair for Link to that of the original game"
    CreateReduxCheckBox -Name "MenuGFX"     -Column 2 -Text "Menu GFX"      -Info "Restores the menu to that of the original game"

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsALinkToThePast

Export-ModuleMember -Function CreateOptionsALinkToThePast