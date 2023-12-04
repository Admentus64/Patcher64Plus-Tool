function ByteOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen) {
        ChangeBytes -Offset "1034" -Values "3C 05 43 34 3C 01 80 27 AC 25 7A 0C AC 25 7A 10 3C 05 3F E6 03 20 F8 09 AC 25 5D 24"
        ChangeBytes -Offset "112C" -Values "08 00 01 0D"
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {

    CreateOptionsPanel

    CreateReduxGroup    -Tag  "Graphics"   -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen" -Text "16:9 Widescreen" -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen" -Credits "gamemasterplc"

}