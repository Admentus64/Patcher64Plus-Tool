function PatchOptions() {
    
    # MODELS #

    if (IsChecked $Redux.Graphics.MMChildLink)   { ApplyPatch -Patch "Decompressed\Optional\The Sealed Palace\tsp_mm_child_link.ppf" }
    if (IsChecked $Redux.Graphics.MMAdultLink)   { ApplyPatch -Patch "Decompressed\Optional\The Sealed Palace\tsp_mm_adult_link.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {

    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.ResumeLastArea) { ChangeBytes -Offset "B1F7AC" -Values "0000"; ChangeBytes -Offset "B1F7A0" -Values "0000" }



    # HERO MODE #

    if (IsChecked $Redux.HeroMode.NoHeartDrops) { ChangeBytes -Offset "A966C7"  -Values "2E" } 

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 2 -Height 300
    


    # GAMEPLAY #

    CreateReduxGroup    -All -Tag  "Gameplay"       -Text "Gameplay"
    CreateReduxCheckBox -All -Name "ResumeLastArea" -Text "Resume From Last Area" -Info "Resume playing from the area you last saved in" -Warning "Don't save in Grottos" -Credits "Aegiker"



    # HERO MODE #

    CreateReduxGroup    -All -Tag  "Hero"         -Text "Hero Mode"
    CreateReduxCheckBox -All -Name "NoHeartDrops" -Text "No Heart Drops" -Info "Remove Recovery Heart drops from the game" -Credits "Admentus"



    # GRAPHICS #

    CreateReduxGroup    -All -Tag  "Graphics"    -Text "Graphics" 
    CreateReduxCheckBox -All -Name "MMChildLink" -Text "MM Child Link" -Info "Replaces the Child Link model with the one from Majora's Mask"         -Credits "Nintendo"
    CreateReduxCheckBox -All -Name "MMAdultLink" -Text "MM Adult Link" -Info "Replaces the Child Link model with the one styled after Majora's Mask" -Credits "Skilar"

}