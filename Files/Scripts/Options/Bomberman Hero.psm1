function ByteOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen) { ChangeBytes -Offset "37A94" -Values "3C 07 3F E3" }

}



#==============================================================================================================================================================================================
function CreateOptions() {

    CreateOptionsPanel

    CreateReduxGroup    -Tag  "Graphics"   -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen" -Text "16:9 Widescreen" -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen" -Credits "gamemasterplc"

}