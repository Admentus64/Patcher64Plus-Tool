function PatchOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen) { ApplyPatch -Patch "Compressed\widescreen.ppf" }

}



#==============================================================================================================================================================================================
function CreateOptions() {

    CreateOptionsDialog -Columns 1 -Height 190

    CreateReduxGroup    -Tag  "Graphics"   -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen" -Text "16:9 Widescreen" -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen" -Credits "gamemasterplc"

}