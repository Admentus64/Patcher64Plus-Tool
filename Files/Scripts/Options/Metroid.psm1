function PatchOptionsSuperMetroid() {
    
    if (IsChecked $Redux.Graphics.Widescreen)           { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\widescreen.ips" }
    if (IsChecked $Redux.Graphics.RedesignedSamus)      { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\redesigned_samus.ips" }

    if (IsChecked $Redux.Gameplay.FixedUnlockedDoors)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\fixed_tourian_unlocked_doors.ips" }
    if (IsChecked $Redux.Gameplay.HeavyPhysics)         { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\heavy_physics.ips" }
    if (IsChecked $Redux.Gameplay.SaveStationsRefill)   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\save_stations_refill_everything.ips" }
    if (IsChecked $Redux.Gameplay.SkipCeres)            { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\skip_ceres.ips" }

}



#==============================================================================================================================================================================================
function PatchReduxSuperMetroid() {

    if (IsChecked $Redux.Revert.Xray)                   { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\x_ray.ips" }
    if (IsChecked $Redux.Revert.ElevatorSpeed)          { ApplyPatch -File $GetROM.decomp -Patch "\Compressed\Original\elevator_speed.ips" }

}



#==============================================================================================================================================================================================
function CreateOptionsSuperMetroid() {
    
    CreateOptionsDialog -Width 390 -Height 320

    $Redux.Graphics.Widescreen.enabled = !$IsWiiVC

}


#==============================================================================================================================================================================================
function CreateTabMainSuperMetroid() {
    
    # GRAPHICS #
    CreateReduxGroup    -Tag "Graphics" -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen"                -Column 1 -Row 1 -Text "16:9 Widescreen [!]"  -Info "16:9 Widescreen display`n[!] Only works with the BSNES / Higan Widescreen feature, and will thus not cause a change in Dolphin"  -Credits "ocesse"
    CreateReduxCheckBox -Name "RedesignedSamus"           -Column 2 -Row 1 -Text "Redesigned Samus"     -Info "Change the appearence of Samus"                                                                                                  -Credits "Dmit Ryaz"

    # GAMEPLAY #
    CreateReduxGroup    -Tag "Gameplay" -Text "Gameplay" -Height 2
    CreateReduxCheckBox -Name "FixedTourianUnlockedDoors" -Column 1 -Row 1 -Text "Fixed Unlocked Doors" -Info "Makes it so that the Tourian doors now let you go back to Crateria normally`nThis patch is already implemented into Redux"  -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "HeavyPhysics"              -Column 2 -Row 1 -Text "Heavy Physics [!]"    -Info "This will make it so that Samus now lands faster and with more gravity to her, similar to that of the GBA Metroids`n[!]This breaks the Demo sequences`n[!]In-game cutscenes and main gameplay still play out normally" -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "SaveStationsRefill"        -Column 1 -Row 2 -Text "Save Stations Refill" -Info "Save Stations will now refill both Energy and all Weapons"                                                                   -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "SkipCeres"                 -Column 2 -Row 2 -Text "Skip Ceres"           -Info "Skip the Ceres Station sequence at the beginning, and start off directly on Planet Zebes' Landing Site on New Game"          -Credits "ShadowOne333 and this team"

}


#==============================================================================================================================================================================================
function CreateTabReduxSuperMetroid() {
    
    # ORIGINAL #
    CreateReduxGroup    -Tag "Revert" -Text "Original (Revert)"
    CreateReduxCheckBox -Name "Xray"                      -Column 1 -Row 1 -Text "X-Ray"              -Info "Restores the original Super Metroid X-Ray Visor width"  -Credits "ShadowOne333 and this team"
    CreateReduxCheckBox -Name "ElevatorSpeed"             -Column 2 -Row 1 -Text "Elevator Speed"     -Info "Restores the original Super Metroid elevator speeds"    -Credits "ShadowOne333 and this team"

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsSuperMetroid
Export-ModuleMember -Function PatchReduxSuperMetroid

Export-ModuleMember -Function CreateOptionsSuperMetroid
Export-ModuleMember -Function CreateTabMainSuperMetroid
Export-ModuleMember -Function CreateTabReduxSuperMetroid