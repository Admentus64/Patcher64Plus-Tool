function PatchOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen) { ApplyPatch -Patch "Compressed\widescreen.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {

    if (IsChecked $Redux.Graphics.SingleBufferedMode) {
        ChangeBytes -Offset "1708" -Values "2400"
        ChangeBytes -Offset "1710" -Values "2400"
        ChangeBytes -Offset "1720" -Values "2400"
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {

    CreateOptionsPanel

    CreateReduxGroup    -Tag  "Graphics"           -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen"         -Text "16:9 Widescreen"      -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen" -Credits "gamemasterplc"
    CreateReduxCheckBox -Name "SingleBufferedMode" -Text "Single Buffered Mode" -Info "Makes the game run smoother with less input lag"     -Credits "Admentus (ROM) & TheBoy181 (GS)"

}