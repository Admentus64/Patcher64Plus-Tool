function PatchOptionsSuperMetroid() {
    
    # BPS Patching

    if (IsChecked -Elem $Options.Xray)                    { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\x_ray.ips" }
    if (IsChecked -Elem $Options.ElevatorSpeed)           { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\elevator_speed.ips" }

    if (IsChecked -Elem $Options.Widescreen)              { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\widescreen.ips" }
    if (IsChecked -Elem $Options.RedesignedSamus)         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\redesigned_samus.ips" }

    if ( (IsChecked -Elem $Options.FixedUnlockedDoors) -and !(IsChecked $Patches.Redux -Active) ) { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\fixed_tourian_unlocked_doors.ips" }
    if (IsChecked -Elem $Options.HeavyPhysics)            { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\heavy_physics.ips" }
    if (IsChecked -Elem $Options.SaveStationsRefill)      { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\save_stations_refill_everything.ips" }
    if (IsChecked -Elem $Options.SkipCeres)               { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\skip_ceres.ips" }

}



#==============================================================================================================================================================================================
function CreateSuperMetroidOptionsContent() {
    
    CreateOptionsDialog -Width 390 -Height 290
    $ToolTip = CreateTooltip



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreenn [!]" -ToolTip $ToolTip -Info "16:9 Widescreen display`n[!] Only works with the BSNES / Higan Widescreen feature, and will thus not cause a change in Dolphin" -Name "Widescreen"
    $Options.RedesignedSamus           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "Redesigned Samus"     -ToolTip $ToolTip -Info "Change the appearence of Samus" -Name "RedesignedSamus"



     # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Gameplay"
    
    $Options.FixedUnlockedDoors        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Fixed Unlocked Doors" -ToolTip $ToolTip -Info "Makes it so that the Tourian doors now let you go back to Crateria normally`nThis patch is already implemented into Redux" -Name "FixedTourianUnlockedDoors"
    $Options.HeavyPhysics              = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Heavy Physics [!]"    -ToolTip $ToolTip -Info "This will make it so that Samus now lands faster and with more gravity to her, similar to that of the GBA Metroids`n[!]This breaks the Demo sequences`n[!]In-game cutscenes and main gameplay still play out normally" -Name "HeavyPhysics"
    $Options.SaveStationsRefill        = CreateReduxCheckBox -Column 0 -Row 2 -AddTo $GameplayBox -Text "Save Stations Refill" -ToolTip $ToolTip -Info "Save Stations will now refill both Energy and all Weapons" -Name "SaveStationsRefill"
    $Options.SkipCeres                 = CreateReduxCheckBox -Column 1 -Row 2 -AddTo $GameplayBox -Text "Skip Ceres"           -ToolTip $ToolTip -Info "Skip the Ceres Station sequence at the beginning, and start off directly on Planet Zebes' Landing Site on New Game" -Name "SkipCeres"



    $Options.Widescreen.enabled = !$IsWiiVC

}



#==============================================================================================================================================================================================
function CreateSuperMetroidReduxContent() {
    
    CreateReduxDialog -Width 390 -Height 200
    $ToolTip = CreateTooltip



    # ORIGINAL #
    $OriginalBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Redux.Panel -Text "Original (Revert)"

    $Options.Xray                      = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OriginalBox -Text "X-Ray"                -ToolTip $ToolTip -Info "Restores the original Super Metroid X-Ray Visor width" -Name "Xray"
    $Options.ElevatorSpeed             = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OriginalBox -Text "Elevator Speed"       -ToolTip $ToolTip -Info "Restores the original Super Metroid elevator speeds" -Name "ElevatorSpeed"

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsSuperMetroid
Export-ModuleMember -Function CreateSuperMetroidOptionsContent
Export-ModuleMember -Function CreateSuperMetroidReduxContent