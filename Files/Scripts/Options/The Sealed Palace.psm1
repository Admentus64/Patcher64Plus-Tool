function PatchOptions() {
    
    # MODELS #

    if (IsChecked $Redux.Graphics.MMChildLink)   { ApplyPatch -Patch "Decompressed\Optional\The Sealed Palace\tsp_mm_child_link.ppf" }
    if (IsChecked $Redux.Graphics.MMAdultLink)   { ApplyPatch -Patch "Decompressed\Optional\The Sealed Palace\tsp_mm_adult_link.ppf" }
    
}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 2 -Height 200
    
    # OTHER #
    CreateReduxGroup    -All -Tag  "Graphics" -Text "Graphics" 
    CreateReduxCheckBox -All -Name "MMChildLink" -Text "MM Child Link" -Info "Replaces the Child Link model with the one from Majora's Mask"         -Credits "Nintendo"
    CreateReduxCheckBox -All -Name "MMAdultLink" -Text "MM Adult Link" -Info "Replaces the Child Link model with the one styled after Majora's Mask" -Credits "Skilar"

}