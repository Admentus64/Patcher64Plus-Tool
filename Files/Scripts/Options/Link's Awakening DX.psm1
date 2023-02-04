function PatchOptions() {
    
    if (IsChecked $Redux.Gameplay.RemovePrinterPhotoOverlay)   { ApplyPatch -Patch "Compressed\Optional\remove_printer_photo_overlays.ips" }
    if (IsChecked $Redux.Gameplay.RemoveThiefPhotoDownsides)   { ApplyPatch -Patch "Compressed\Optional\remove_thief_photo_downsides.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxOptions() {
    
    if (IsChecked $Redux.Revert.RestoreLowHealthBeep)     { ApplyPatch -Patch "Compressed\Original\restore_low_health_beep.ips" }
    if (IsChecked $Redux.Revert.RestorePowerupMessages)   { ApplyPatch -Patch "Compressed\Original\restore_powerup_messages.ips" }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if     (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "Start + Select")   { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "C0" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "A + Start")        { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "90" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "A + Select")       { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "50" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "B + Start")        { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "A0" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "B + Select")       { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "60" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "Up + Start")       { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "84" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "Up + Select")      { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "44" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "Down + Start")     { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "88" }
    elseif (IsIndex -Elem $Redux.Gameplay.SaveButtonCombo -Text "Down + Select")    { $offset = SearchBytes -Start "E00" -End "F00" -Values "24 F0 CB FE"; $offset = AddToOffset -Hex $offset -Add "4"; ChangeBytes -Offset $offset -Values "48" }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 2 -Height 260

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GRAPHICS #

    CreateReduxGroup    -Tag  "Gameplay"                  -Base -Text "Gameplay"
    CreateReduxCheckBox -Name "RemovePrinterPhotoOverlay" -Base -Text "Remove Printer-Photo Overlay"    -Info "Remove the Photo Album overlays, to have a clean image of each photograph"                                                                                                                                  -Credits "vince94"
    CreateReduxCheckBox -Name "RemoveThiefPhotoDownsides" -Base -Text "Remove THIEF Downsides"          -Info "Remove the THIEF photo punishment, meaning that you won't get your character named THIEF for obtaining the thief photo`nThe Death counter won’t go up when the shopkeeper kills you for that pic as well" -Credits "IcePenguin"
    $items = @("Original", "Start + Select", "A + Start", "A + Select", "B + Start", "B + Select", "Up + Start", "Up + Select", "Down + Start", "Down + Select")
    CreateReduxComboBox -Name "SaveButtonCombo"           -Base -Text "Save Button Combo" -Items $Items -Info "Change the button input combination to access the Save Menu"                                                                                                                                                -Credits "ShadowOne333"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # ORIGINAL #

    CreateReduxGroup    -Tag  "Revert"                 -Base -Text "Original (Revert)"
    CreateReduxCheckBox -Name "RestoreLowHealthBeep"   -Base -Text "Restore Low Health Beep"  -Info "Restores the Low Health Beep sound effect like in the original version"                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RestorePowerupMessages" -Base -Text "Restore Powerup Messages" -Info "Restores the textboxes that display when you pick up a Guardian Acorn or Piece of Power" -Credits "IcePenguin"

}