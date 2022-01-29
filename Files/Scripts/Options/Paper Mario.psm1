function PatchOptions() {
    
    if     (IsChecked $Redux.Difficulty.Hard)       { ApplyPatch -Patch "Compressed\hard_mode.ppf" }
    elseif (IsChecked $Redux.Difficulty.HardPlus)   { ApplyPatch -Patch "Compressed\hard_mode_plus.ppf" }
    elseif (IsChecked $Redux.Difficulty.Insane)     { ApplyPatch -Patch "Compressed\insane_mode.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen) { ChangeBytes -Offset "8974" -Values "24 07 01 8A" }

}



#==============================================================================================================================================================================================
function CreateOptions() {

    CreateOptionsDialog -Columns 4 -Height 240

    CreateReduxGroup    -Tag  "Graphics"   -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen" -Text "16:9 Widescreen" -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen" -Credits "gamemasterplc"

    CreateReduxGroup    -Tag  "Difficulty"   -Text "Hard Mode"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Normal"   -Max 4 -SaveTo "Mode" -Text "Normal Mode"    -Info "Keep the vanilla game difficulty"  -Checked
    CreateReduxRadioButton -Name "Hard"     -Max 4 -SaveTo "Mode" -Text "Hard Mode"      -Info "Increases the damage dealt by enemies by 1.5x"                                   -Credits "Skelux"
    CreateReduxRadioButton -Name "HardPlus" -Max 4 -SaveTo "Mode" -Text "Hard Mode Plus" -Info "Increases the damage dealt by enemies by 1.5x`nAlso increases the HP of enemies" -Credits "Skelux"
    CreateReduxRadioButton -Name "Insane"   -Max 4 -SaveTo "Mode" -Text "Insane Mode"    -Info "Increases the damage dealt by enemies by 2x"                                     -Credits "Skelux"

}