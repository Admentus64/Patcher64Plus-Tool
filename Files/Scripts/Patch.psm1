function MainFunction([string]$Command, [string]$PatchedFileName) {
    
    # Reset warning level
    $global:WarningError = $False

    # Header
    $Header = @($null) * 5
    $Header = SetHeader -Header $Header -ROMTitle $GamePatch.rom_title -ROMGameID $GamePatch.rom_gameID -VCTitle $GamePatch.vc_title -VCGameID $GamePatch.vc_gameID -Region $GamePatch.rom_region

    # Hash
    $global:ROMHashSum = (Get-FileHash -Algorithm MD5 $GamePath).Hash
    $global:CheckHashSum = $GameType.version[0].hash

    # Output
    if (!(IsSet $PatchedFileName)) { $PatchedFileName = "_patched" }
    
    # Expand Memory, Remap Controls, Downgrade
    if     ($VC.ExpandMemory.Active  -and $GamePatch.expand_memory  -eq  1)    { $VC.ExpandMemory.Checked  = $True }
    elseif ($VC.ExpandMemory.Active  -and $GamePatch.expand_memory  -eq -1)    { $VC.ExpandMemory.Checked  = $False }
    if     ($VC.RemapControls.Active -and $GamePatch.remap_controls -eq  1)    { $VC.RemapControls.Checked = $True }
    elseif ($VC.RemapControls.Active -and $GamePatch.remap_controls -eq -1)    { $VC.RemapControls.Checked = $False }
    if ($Patches.Downgrade.Active -and $Settings.Debug.IgnoreChecksum -eq $False) {
        if     (!$IsWiiVC -and $ROMHashSum -eq $CheckHashSum)                  { $Patches.Downgrade.Checked = $False }
        elseif (StrLike -str $Command -val "Force Downgrade")                  { $Patches.Downgrade.Checked = $True }
        elseif (StrLike -str $Command -val "No Downgrade")                     { $Patches.Downgrade.Checked = $False }
        elseif ((IsChecked $Patches.Options) -or (IsChecked $Patches.Redux))   { $Patches.Downgrade.Checked = $True }
    }

    # Finalize
    $Finalize = $True
    if     (IsChecked $Patches.Options)          { $Finalize = $False }
    if     (IsChecked $Patches.Downgrade -Not)   { $Finalize = $False }
    if     ($GamePatch.finalize -eq 0)           { $Finalize = $False }
    elseif ($GamePatch.finalize -eq 1)           { $Finalize = $True }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") ) {
        # Redux
        if ( (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file)) {
            $Header = SetHeader -Header $Header -ROMTitle $GamePatch.redux.rom_title -ROMGameID $GamePatch.redux.rom_gameID -VCTitle $GamePatch.redux.vc_title -VCGameID $GamePatch.redux.vc_gameID -Region $GamePatch.rom_region
            if     ($VC.RemapControls.Active -and $GamePatch.redux.remap_controls -eq  1)   { $VC.RemapControls.Checked = $True }
            elseif ($VC.RemapControls.Active -and $GamePatch.redux.remap_controls -eq -1)   { $VC.RemapControls.Checked = $False }
            if     ($VC.ExpandMemory.Active  -and $GamePatch.redux.expand_memory  -eq  1)   { $VC.ExpandMemory.Checked  = $True }
            elseif ($VC.ExpandMemory.Active  -and $GamePatch.redux.expand_memory  -eq -1)   { $VC.ExpandMemory.Checked  = $False }
            if     (IsSet -Elem $GamePatch.redux.output)   { $PatchedFileName = $GamePatch.redux.output }
            if     ($GamePatch.redux.finalize -eq 0)       { $Finalize = $False }
            elseif ($GamePatch.redux.finalize -eq 1)       { $Finalize = $True }
            $Finalize = $False
        }

        # Language Patch
        $global:LanguagePatch = $global:LanguagePatchFile = $null
        if ( (IsSet $Files.json.languages) -and $Settings.Debug.LiteGUI -eq $False -and (IsChecked $Patches.Options) ) {
            for ($i=0; $i -lt $Files.json.languages.Length; $i++) {
                if ($Redux.Language[$i].checked) {
                    $global:LanguagePatch = $Files.json.languages[$i]
                    break
                }
            }

            if (TestFile ($GameFiles.languages + "\" + $LanguagePatch.code + ".ppf") ) { $global:LanguagePatchFile = "Languages\" + $LanguagePatch.code + ".ppf" }
            $Header = SetHeader -Header $Header -ROMTitle $LanguagePatch.rom_title -ROMGameID $LanguagePatch.rom_gameID -VCTitle $LanguagePatch.vc_title -VCGameID $LanguagePatch.vc_gameID -Region $LanguagePatch.rom_region
            if     (IsSet $LanguagePatch.output)     { $PatchedFileName = $LanguagePatch.output }
            if     ($LanguagePatch.finalize -eq 0)   { $Finalize  = $False }
            elseif ($LanguagePatch.finalize -eq 1)   { $Finalize  = $True }
            
            if (IsSet $LanguagePatch.region)     {
                if (!(IsSet $Header[1])) { $Header[1] = $GameType.rom_gameID }
                $Header[1] = $Header[1].substring(0, 3) + $LanguagePatch.region
            }
        }
    }

    #  Title / GameID
    if ($CustomHeader.EnableHeader.Checked) {
        if (!$IsWiiVC) {
            if ($CustomHeader.ROMTitle.TextLength  -gt 0)   { $Header[0] = [string]$CustomHeader.ROMTitle.Text }
            if ($CustomHeader.ROMGameID.TextLength -eq 4)   { $Header[1] = [string]$CustomHeader.ROMGameID.Text }
        }
        else {
            if ($CustomHeader.VCTitle.TextLength  -gt 0)    { $Header[2] = [string]$CustomHeader.VCTitle.Text }
            if ($CustomHeader.VCGameID.TextLength -eq 4)    { $Header[3] = [string]$CustomHeader.VCGameID.Text }
        }
    }

    # Region
    if ($CustomHeader.EnableRegion.Checked -and $GameConsole.rom_gameID -eq 2) { $Header[4] = [Byte]$CustomHeader.Region.SelectedIndex }
    
    # Decompress
    $Decompress = $False
    if ($GameType.decompress -gt 0) {
        if     (StrStarts -Str (GetPatchFile) -Val "Decompressed\")   { $Decompress = $True }
        elseif (IsChecked $Patches.Downgrade)                         { $Decompress = $True }
        elseif ($GameType.decompress -eq 1 -and !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") ) {
            if ( (IsChecked $Patches.Options) -or (IsChecked $Patches.Redux) )   { $Decompress = $True }
        }
        elseif ($GameType.decompress -eq 2 -and (IsChecked $Patches.Extend)) { $Decompress = $True }
    }

    # Set ROM
    if ( (IsSet -Elem $InjectFile -MinLength 4) -and $IsWiiVC) { $global:ROMFile = SetROMParameters -Path $InjectPath -PatchedFileName $PatchedFileName }
    if (!$IsWiiVC) {
        $global:ROMFile = SetROMParameters -Path $GamePath -PatchedFileName $PatchedFileName
        SetGetROM
    }

    # Check if ROM is getting patched
    if ( (IsChecked $Patches.Options) -or (IsChecked $Patches.Redux) -or (IsChecked $Patches.Downgrade) -or (IsSet $GamePatch.file) ) { $PatchROM = $True } else { $PatchROM = $False }

    # GO!
    if ($Settings.NoCleanup.Checked -ne $True -and $IsWiiVC) { RemovePath $Paths.Temp } # Remove the temp folder first to avoid issues
    MainFunctionPatch -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress -Finalize $Finalize -PatchROM $PatchROM
    EnableGUI $True
    Cleanup
    PlaySound $Sounds.done # Play a sound when it is finished

}



#==============================================================================================================================================================================================
function SetHeader([Array]$Header, [string]$ROMTitle, [string]$ROMGameID, [string]$VCTitle, [string]$VCGameID, [Byte]$Region) {
    
    if (IsSet $ROMTitle)                                       { $Header[0] = $ROMTitle }
    if (IsSet $ROMGameID)                                      { $Header[1] = $ROMGameID }
    if ($IsWiiVC -and (IsSet $VCTitle) )                       { $Header[2] = $VCTitle }
    if ($IsWiiVC -and (IsSet $VCGameID) )                      { $Header[3] = $VCGameID }
    if ($GameConsole.rom_gameID -eq 2 -and (IsSet $Region) )   { $Header[4] = $Region }
    return $Header

}



#==============================================================================================================================================================================================
function MainFunctionPatch([string]$Command, [Array]$Header, [string]$PatchedFileName, [boolean]$Decompress, [boolean]$Finalize, [boolean]$PatchROM) {
    
    # Step 00: Prepare for patching
    WriteDebug -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress -Finalize $Finalize -PatchROM $PatchROM
    if ($Settings.Debug.Stop -eq $True) { return $False }
    WriteToConsole "START PATCHING PROCESS OF SELECTED GAME"
    WriteToConsole

    # Step 01: Disable the main dialog, allow patching and delete files if they still exist and redirect to the neccesary folders
    EnableGUI $False
    if ($Settings.Core.LocalTempFolder -eq $True) { $GameFiles.extracted = $GameFiles.base + "\Extracted" }
    else {
        CreatePath $Paths.AppData
        $GameFiles.extracted = $Paths.AppData + "\" + $GameType.mode + "\Extracted"
    }
    CreatePath $Paths.Temp

    # Only continue with these steps in VC WAD mode, otherwise ignore these steps
    if ($IsWiiVC) {
        # Step 02: Extract the contents of the WAD file
        if (!(ExtractWADFile $PatchedFileName)) { return }

        # Step 03: Check the GameID to be vanilla
        if (!(CheckVCGameID)) { return }

        # Step 04: Extract "00000005.app" file to get the ROM
        if (!(ExtractU8AppFile $Command)) { return }

        # Step 05: Do some initial patching stuff for the ROM for VC WAD files
        if (!(PatchVCROM -Command $Command -PatchROM $PatchROM)) { return }
        
        # Step 06: Replace the Virtual Console emulator within the WAD file
        if (!(PatchVCEmulator $Command)) { return }
    }

    # Step 07: Convert, compare the hashsum of the ROM and check if the maximum size is allowed
    if (!(GetMaxSize $Command)) { return }
    if ($PatchROM) {
        ConvertROM $Command
        if (!(CompareHashSums $Command)) { return }
    }

    # Step 08: Downgrade and decompress the ROM if required
    if (StrLike -str $Command -val "Inject" -Not) {
        if (!(DecompressROM $Decompress)) { return }
        $item = DowngradeROM $Decompress
        if ( (IsSet $item.rom_gameID) -and !(IsSet $header[1]) ) { $header = SetHeader -Header $Header -ROMGameID $item.rom_gameID }
    }
    
    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") -and $PatchROM) {
        # Step 09: Extract MQ dungeon data for OoT
        ExtractMQData $Decompress
        
        # Step 10: Apply additional options before Redux
        PrePatchingAdditionalOptions

        # Step 11: Apply the Redux patch
        PatchRedux $Decompress

        # Step 12: Apply additional options
        PatchingAdditionalOptions

        # Step 13: Patch and extend the ROM file with the patch through Floating IPS
        if (!(PatchDecompressedROM)) { return }

        # Step 14: Compress the decompressed ROM if required
        CompressROM -Decompress $Decompress -Finalize $Finalize

        # Step 15: Patch and extend the ROM file with the patch through Floating IPS
        if (!(PatchCompressedROM)) { return }
    }
    elseif (StrLike -str $Command -val "Apply Patch") {
        # Step 16: Compress if needed and apply provided BPS Patch
        CompressROM -Decompress $Decompress -Finalize $Finalize
        if (!(ApplyPatchROM $Decompress)) { return }
    }
    
    # Step 17: Update the .Z64 ROM CRC
    if ($PatchROM) { UpdateROMCRC }

    # Step 18: Hack the Game Title and GameID of a N64 ROM, remove the US region protection as well if applicable and neccesary
    HackROMGameTitle -Title $Header[0] -GameID $Header[1] -Region $Header[4]

    # Step 19: Debug
    CreateDebugPatches

    # Only continue with these steps in VC WAD mode, otherwise ignore these steps
    if ($IsWiiVC) {
        # Step 20: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        if ($PatchROM) { ExtendROM }

        # Step 21: Compress the ROMC again if possible
        if ($PatchROM) { CompressROMC }

        # Step 22: Hack the Channel Title.
        HackOpeningBNRTitle $Header[2]

        # Step 23: Repack the "00000005.app" with the updated ROM file 
        RepackU8AppFile
        
        # Step 24: Repack the WAD file with the updated APP file
        RepackWADFile $Header[3]
    }

    # Step 25: Final message
    if (!$WarningError) {
        if ($IsWiiVC)   { UpdateStatusLabel ('Finished patching the ' + $GameType.mode + ' VC WAD file.') }
        else            { UpdateStatusLabel ('Finished patching the ' + $GameType.mode + ' ROM file.') }
    }
    else {
        if ($IsWiiVC)   { UpdateStatusLabel ('Finished patching the ' + $GameType.mode + ' VC WAD file, but encountered issues. Please enable and check the log.') }
        else            { UpdateStatusLabel ('Finished patching the ' + $GameType.mode + ' ROM file, but encountered issues. Please enable and check the log.') }
    }

}



#==============================================================================================================================================================================================
function WriteDebug([string]$Command, [String[]]$Header, [string]$PatchedFileName, [boolean]$Decompress, [boolean]$Finalize, [boolean]$PatchROM) {
    
    WriteToConsole
    WriteToConsole "--- Start Patch Info ---"
    WriteToConsole ("Game Mode:     " + $GameType.mode)
    WriteToConsole ("Console Mode:  " + $GameConsole.Mode)
    WriteToConsole ("Patch Options: " + $GamePatch.title)
    WriteToConsole ("Custom Header: " + $Header)
    WriteToConsole ("Patch File:    " + (GetPatchFile))
    WriteToConsole ("Use Options:   " + ( (IsSet $GamePatch.options) -and $Patches.Options.Checked -and $Patches.Options.Visible) )
    WriteToConsole ("Use Redux:     " + ( (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file) ) )
    WriteToConsole ("Redux File:    " + $GamePatch.redux.file)
    WriteToConsole ("Language File: " + $LanguagePatchFile)
    WriteToConsole ("Output Name:   " + $PatchedFileName)
    WriteToConsole ("Command:       " + $Command)
    WriteToConsole ("Downgrade:     " + $Patches.Downgrade.Checked)
    WriteToConsole ("Finalize:      " + $Finalize)
    WriteToConsole ("Decompress:    " + $Decompress)
    WriteToConsole ("ROM Hash:      " + $ROMHashSum)
    WriteToConsole ("No-Intro Hash: " + $CheckHashSum)
    WriteToConsole ("Wii VC Mode:   " + $IsWiiVC)
    WriteToConsole ("ROM Path:      " + $GamePath)
    WriteToConsole ("Inject Path:   " + $InjectPath)
    WriteToConsole ("Patch Path:    " + $PatchPath)
    WriteToConsole ("Patch ROM:     " + $PatchROM)
    WriteToConsole "--- End Patch Info ---"
    WriteToConsole
    WriteToConsole
    WriteToConsole
    WriteToConsole "--- Start Misc Settings Info ---"
    WriteToConsole ("Ignore Input Checksum: " + $GeneralSettings.IgnoreChecksum)
    WriteToConsole ("Lite Options GUI:      " + $GeneralSettings.LiteGUI)
    WriteToConsole ("Force Show Options:    " + $GeneralSettings.ForceOptions)
    WriteToConsole ("Use Local Temp Folder: " + $GeneralSettings.LocalTempFolder)
    WriteToConsole ("Change Widescreen:     " + $GeneralSettings.ChangeWidescreen)
    WriteToConsole ("Switch Decompressor:   " + $GeneralSettings.AltDecompress)
    WriteToConsole "--- End Misc Settings Info ---"
    WriteToConsole
    WriteToConsole
    WriteToConsole
    WriteToConsole "--- Start Additional Options Info ---"
    
    foreach ($item in $Redux.Groups) {
        foreach ($form in $item.controls) {
            if     ($form.GetType() -eq [System.Windows.Forms.CheckBox])      { if (IsDefault $form -Not $form.checked)                              { WriteToConsole ($item.text + ". " + $form.name) } }
            elseif ($form.GetType() -eq [System.Windows.Forms.RadioButton])   { if ( (IsDefault $form -Not $form.checked) -and (IsChecked $form) )   { WriteToConsole ($item.text + ". " + $form.name) } }
            elseif ($form.GetType() -eq [System.Windows.Forms.ComboBox])      { if (IsDefault $form -Not $form.selectedIndex)                        { WriteToConsole ($item.text + ". " + $form.name + " -> " + $form.text) } }
            elseif ($form.GetType() -eq [System.Windows.Forms.TrackBar])      { if (IsDefault $form -Not $form.value)                                { WriteToConsole ($item.text + ". " + $form.name + " -> " + $form.value) } }

            elseif ($form.GetType() -eq [System.Windows.Forms.Panel]) {
                foreach ($subform in $form.controls) {
                    if     ($subform.GetType() -eq [System.Windows.Forms.CheckBox])      { if (IsDefault $subform -Not $subform.checked)                                 { WriteToConsole ($item.text + ". " + $subform.name) } }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.RadioButton])   { if ( (IsDefault $subform -Not $subform.checked) -and (IsChecked $subform) )   { WriteToConsole ($item.text + ". " + $subform.name) } }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.ComboBox])      { if (IsDefault $subform -Not $subform.selectedIndex)                           { WriteToConsole ($item.text + ". " + $subform.name + " -> " + $subform.text) } }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.TrackBar])      { if (IsDefault $subform -Not $subform.value)                                   { WriteToConsole ($item.text + ". " + $subform.name + " -> " + $subform.value) } }
                }
            }
        }
    }

    WriteToConsole "--- End Additional Options Info ---"
    WriteToConsole

}



#==============================================================================================================================================================================================
function Cleanup() {
    
    if ($Settings.debug.NoCleanup -eq $True) { return }
    WriteToConsole "Cleaning up files..."
    
    $global:ByteArrayGame = $global:ROMFile = $global:WADFile = $global:CheckHashSum = $global:ROMHashSum = $global:LanguagePatch = $null

    RemovePath $WADFile.Folder
    RemovePath $Paths.cygdrive
    RemovePath $Paths.Temp
    RemoveFile $Files.flipscfg
    RemoveFile $Files.stackdump

    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function GetPatchFile() {
    
    if ($GamePatch.patch -is [System.Array]) {
        foreach ($item in $GamePatch.patch) {
            if ($item.hash -eq $ROMHashSum) { return $item.file }
        }
        return $GamePatch.patch[0].file
    }
    return $GamePatch.patch

}



#==============================================================================================================================================================================================
function PrePatchingAdditionalOptions() {

    if (!(IsSet $GamePatch.options) -or !$Patches.Options.Checked -or !$Patches.Options.Visible)   { return }
    if (!$Decompress -and !(TestFile $GetROM.decomp) )                                             { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }

    # BPS - Pre-Redux Options
    if ( (GetCommand "PrePatchReduxOptions") -and (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file) ) {
        UpdateStatusLabel ("Pre-Patching " + $GameType.mode + " Additional Redux Patches...")
        iex "PrePatchReduxOptions"
    }

}



#==============================================================================================================================================================================================
function PatchingAdditionalOptions() {
    
    if (!(IsSet $GamePatch.options) -or !$Patches.Options.Checked -or !$Patches.Options.Visible)   { return }
    if (!$Decompress -and !(TestFile $GetROM.decomp) )                                             { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
    
    # Language patches
    if (IsSet -Elem $LanguagePatchFile) {
        UpdateStatusLabel ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $GetROM.decomp -Patch $LanguagePatchFile
    }

    # BPS - Additional Options
    if (GetCommand "PatchOptions") {
        UpdateStatusLabel ("Patching " + $GameType.mode + " Additional Options Patches...")
        iex "PatchOptions"
    }

    # BPS - Redux Options
    if ( (GetCommand "PatchReduxOptions") -and (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file) ) {
        UpdateStatusLabel ("Patching " + $GameType.mode + " Additional Redux Patches...")
        iex "PatchReduxOptions"
    }

    if ( (GetCommand "ByteOptions") -or (GetCommand "ByteReduxOptions") -or (GetCommand "ByteLanguageOptions") ) { $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp) }

    # Additional Options
    if (GetCommand "ByteOptions") {
        UpdateStatusLabel ("Patching " + $GameType.mode + " Additional Options...")
        iex "ByteOptions"
    }

    # Redux Options
    if ( (GetCommand "ByteReduxOptions") -and (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file) ) {
        UpdateStatusLabel ("Patching " + $GameType.mode + " Additional Redux Options...")
        iex "ByteReduxOptions"
    }

    # Language Options
    if (GetCommand "ByteLanguageOptions") {
        #UpdateStatusLabel ("Patching " + $GameType.mode + " Additional Language Options...")
        iex "ByteLanguageOptions"
    }

    if ( (GetCommand "ByteOptions") -or (GetCommand "ByteReduxOptions") -or (GetCommand "ByteLanguageOptions") ) {
        [System.IO.File]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)
        $ByteArrayGame = $null
    }

    if (!$Decompress) { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force }

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {
    
    if ($Settings.Debug.NoCRCChange -eq $True -or $GameConsole.mode -ne "N64") { return }

    if (!(TestFile $GetROM.patched)) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.patched }
    & $Files.tool.rn64crc $GetROM.patched -update | Out-Null
    WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.patched)

    if ($Settings.Debug.KeepConverted -eq $True -and (TestFile $GetROM.keepConvert) )      { & $Files.tool.rn64crc $GetROM.keepConvert -update | Out-Null;   WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.keepConvert) }
    if ($Settings.Debug.KeepDowngraded -eq $True -and (TestFile $GetROM.keepDowngrade) )   { & $Files.tool.rn64crc $GetROM.keepDowngrade -update | Out-Null; WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.keepDowngrade) }
    if ($Settings.Debug.KeepDecompressed -eq $True -and (TestFile $GetROM.keepDecomp) )    { & $Files.tool.rn64crc $GetROM.keepDecomp -update | Out-Null;    WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.keepDecomp) }


}



#==============================================================================================================================================================================================
function CreateDebugPatches() {
    
    if ($Settings.Debug.CreateBPS -ne $True) { return }
    if ( (TestFile $GetROM.cleanDecomp) -and (TestFile $GetROM.decomp) ) {
        & $Files.tool.flips --create --bps $GetROM.cleanDecomp $GetROM.decomp $Files.decompBPS | Out-Null 
        WriteToConsole ("Created BPS Patch: " + $Files.decompBPS)
    }
    & $Files.tool.flips --create --bps $GetROM.clean $GetROM.patched $Files.compBPS | Out-Null
    WriteToConsole ("Created BPS Patch: " + $Files.compBPS)

}



#==============================================================================================================================================================================================
function SetROMParameters([string]$Path, [string]$PatchedFileName) {
    
    # Create a hash table
    $ROMFile = @{}

    # Get the ROM as an item object
    $ROMItem = Get-Item -LiteralPath $Path
    
    # Store some stuff about the ROM to reference
    $ROMFile.Name      = $ROMItem.BaseName
    $ROMFile.Path      = $ROMItem.DirectoryName
    
    $ROMFile.Extension = $GameConsole.extension

    $ROMFile.ROM       = $Path
    $ROMFile.Patched   = $ROMFile.Path + "\" + $ROMFile.Name + $PatchedFileName + $ROMFile.Extension
    $ROMFile.Convert   = $ROMFile.Path + "\" + $ROMFile.Name + "_converted"     + $ROMFile.Extension
    $ROMFile.Downgrade = $ROMFile.Path + "\" + $ROMFile.Name + "_downgraded"    + $ROMFile.Extension
    $ROMFile.Decomp    = $ROMFile.Path + "\" + $ROMFile.Name + "_decompressed"  + $ROMFile.Extension
    

    # Set it to a global value
    return $ROMFile

}



#==============================================================================================================================================================================================
function DowngradeROM([boolean]$Decompress) {
    
    if (!(IsChecked $Patches.Downgrade)) { return }

    # Downgrade a ROM if it is required first
    UpdateStatusLabel "Downgrading ROM..."

    if ($ROMHashSum -eq $CheckHashSum) {
        WriteToConsole "ROM is already downgraded"
        return $null
    }

    if ($Decompress) { $GetROM.run = $GetROM.decomp }
    else {
        Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.downgrade -Force
        $GetROM.run = $GetROM.downgrade
    }
    
    foreach ($item in $GameType.version) {
        if ($ROMHashSum -eq $item.hash -and (IsSet $item.file)) {
            if (!(ApplyPatch -File $GetROM.run -Patch ("Downgrade\" + $item.file))) {
                WriteToConsole "Could not apply downgrade patch"
                return
            }
            if ($Settings.Debug.KeepDowngraded -eq $True) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.keepDowngrade -Force }
            $global:ROMHashSum = $CheckHashSum
            return $item
        }
        elseif ($ROMHashSum -eq $item.hash) { return $item }
    }

    WriteToConsole "Unknown version for downgrading"
    return $nu
    
}



#==============================================================================================================================================================================================
function GetMaxSize([String]$Command) {

    if ($Settings.Debug.IgnoreChecksum -eq $True) { return $True }
    if ( (StrLike -str $Command -val "Inject") ) { return $True }

    $maxSize = ($GameConsole.max_size) + "MB"
    if ((Get-Item -LiteralPath $GetROM.run).length/$maxSize -gt 1) {
        UpdateStatusLabel ("The ROM is too large! The max allowed size is " + $maxSize) + "!"
        return $False
    }

    return $True

}



#==============================================================================================================================================================================================
function ConvertROM([string]$Command) {
    
    if ($Settings.Debug.NoConversion -eq $True) { return }
    if ( (StrLike -str $Command -val "Inject") ) { return }

    $array = [IO.File]::ReadAllBytes($GetROM.run)

    # Convert ROM if needed
    if ($GameConsole.mode -eq "SNES") {
        if ((Get-Item -LiteralPath $GamePath).length/1KB % 2 -ne 0) {
            UpdateStatusLabel "Removing header from ROM..."
            $array = $array[512..$array.length]
        }
        else { return }
    }
    elseif ($GameConsole.mode -eq "N64") {
        if (CompareArray -Elem $array[0..7] -Compare @(128, 55, 18, 64, 0, 0, 0, 15)) { return }
        elseif (CompareArray -Elem $array[0..7] -Compare @(55, 128, 64, 18, 0, 0, 15, 0)) {
            UpdateStatusLabel "Converting ROM from Byteswapped to Big Endian..."
            for ($i=0; $i -lt $array.length; $i+=2) {
                $temp = @($array[$i], $array[$i + 1])
                $array[$i]     = $temp[1]
                $array[$i + 1] = $temp[0]
            }
        }
        elseif (CompareArray -Elem $array[0..7] -Compare @(64, 18, 55, 128, 15, 0, 0, 0)) {
            UpdateStatusLabel "Converting ROM from Little Endian to Big Endian..."
            for ($i=0; $i -lt $array.length; $i+=4) {
                $temp = @($array[$i], $array[$i + 1], $array[$i + 2], $array[$i + 3])
                $array[$i]     = $temp[3]
                $array[$i + 1] = $temp[2]
                $array[$i + 2] = $temp[1]
                $array[$i + 3] = $temp[0]
            }
        }
    }
    else { return }

    [IO.File]::WriteAllBytes($Paths.Temp + "\converted", $array)
    $GetROM.run =  $Paths.Temp + "\converted"
    $global:ROMHashSum = (Get-FileHash -Algorithm MD5 $GetROM.run).Hash
    if ($Settings.Debug.KeepConverted -eq $True) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.keepConvert -Force }

}



#==============================================================================================================================================================================================
function CompareHashSums([string]$Command) {
    
    if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.clean -Force }
    if ($Settings.Debug.IgnoreChecksum -eq $True) { return $True }
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }

    $item = GetROMVersion
    if ($item -eq $null) {
        UpdateStatusLabel "Failed! The ROM has an incorrect version or is broken."
        WriteToConsole ("ROM hash is:  " + $ROMHashSum + ". The correct ROM should be: " + $CheckHashSum)
        return $False
    }

    if ($item.supported -eq 0) {
        if ($item.region -like "*US*" -or $item.region -like "*NTSC-U*") {
            UpdateStatusLabel "North American / NTSC-U versions are not supported."
            return $False
        }
        if ($item.region -like "*EU*" -or $item.region -like "*PAL*") {
            UpdateStatusLabel "Europese / PAL versions are not supported."
            return $False
        }
        if ($item.region -like "*JPN*" -or $item.region -like "*NTSC-J*") {
            UpdateStatusLabel "Japanese / NTSC-J versions are not supported."
            return $False
        }
        if ($item.region -like "*CHN*") {
            UpdateStatusLabel "Chinese / CHN versions are not supported."
            return $False
        }
        if ($item.region -like "*TWN*") {
            UpdateStatusLabel "Taiwanese / TWN versions are not supported."
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function PatchDecompressedROM() {
    
    if (!(StrStarts -Str (GetPatchFile) -Val "Decompressed\")) { return $True }
    
    # Set the status label.
    UpdateStatusLabel ("Patching " + $GameType.mode + " ROM with patch file...")
    
    # Apply the selected patch to the ROM, if it is provided
    if (!(ApplyPatch -File $GetROM.decomp -Patch (GetPatchFile))) { return $False }
    
    return $True

}



#==============================================================================================================================================================================================
function PatchCompressedROM() {
    
    if (!(StrStarts -Str (GetPatchFile) -Val "Compressed\")) { return $True }
    
    # Set the status label.
    UpdateStatusLabel ("Patching " + $GameType.mode + " ROM with patch file...")

    # Apply the selected patch to the ROM, if it is provided
    if     ( $IsWiiVC)   { if (!(ApplyPatch -File $GetROM.patched -Patch (GetPatchFile)))                    { return $False } }
    elseif (!$IsWiiVC)   { if (!(ApplyPatch -File $GetROM.run -Patch (GetPatchFile) -New $GetROM.patched))   { return $False } }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatchROM([boolean]$Decompress) {

    $HashSum1 = (Get-FileHash -Algorithm MD5 $GetROM.run).Hash
    if ($Decompress)   { $File = $GetROM.patched }
    else               { $File = $GetROM.run }

    if (!(ApplyPatch -File $File -Patch $PatchPath -New $GetROM.patched -FullPath)) { return $False }
    $HashSum2 = (Get-FileHash -Algorithm MD5 $GetROM.patched).Hash
    if ($HashSum1 -eq $HashSum2) {
        if ($IsWiiVC -and $GameType.downgrade -and !(IsChecked $Patches.Downgrade) )      { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?" }
        elseif ($IsWiiVC -and $GameType.downgrade -and (IsChecked $Patches.Downgrade) )   { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" }
        else                                                                              { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged." }
        return $False
    }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatch([string]$File=$GetROM.decomp, [string]$Patch, [string]$New, [switch]$FilesPath, [switch]$FullPath) {
    
    # File Parameter Check
    if ( !(IsSet -Elem $File) -or !(IsSet -Elem $Patch) ) {
        WriteToConsole "No file or patch file is provided"
        return $True
    }

    # File Exists
    if (!(TestFile $File)) {
        UpdateStatusLabel "Failed! Could not find file."
        WriteToConsole ("Missing file: " + $File)
        return $False
    }

    # Patch File
    if ($FullPath)         {  }
    elseif ($FilesPath)    { $Patch = $Paths.Master + "\" + $Patch }
    else                   { $Patch = $GameFiles.base + "\" + $Patch }

    if (TestFile ($Patch + ".bps"))      { $Patch + ".bps" }
    if (TestFile ($Patch + ".ips"))      { $Patch + ".ips" }
    if (TestFile ($Patch + ".ups"))      { $Patch + ".ups" }
    if (TestFile ($Patch + ".xdelta"))   { $Patch + ".xdelta" }
    if (TestFile ($Patch + ".vcdiff"))   { $Patch + ".vcdiff" }
    if (TestFile ($Patch + ".ppf"))      { $Patch + ".ppf" }

    if (TestFile $Patch) { $Patch = Get-Item -LiteralPath $Patch }
    else { # Patch File does not exist
        UpdateStatusLabel "Failed! Could not find patch file."
        WriteToConsole ("Missing patch file: " + $Patch)
        return $False
    }

    # Patching
    if ($Patch -like "*.bps*" -or $Patch -like "*.ips*") {
        if ($New.Length -gt 0) { & $Files.tool.flips --ignore-checksum --apply $Patch $File $New | Out-Null }
        else { & $Files.tool.flips --ignore-checksum $Patch $File | Out-Null }
    }
    elseif ($Patch -like "*.ups*") {
        if ($New.Length -gt 0) { & $Files.tool.ups apply -b $File -p $Patch -o $New | Out-Null }
        else { & $Files.tool.ups apply -b $File -p $Patch -o $File | Out-Null }
    }
    elseif ($Patch -like "*.xdelta*" -or $Patch -like "*.vcdiff*") {
        if ($Patch -like "*.xdelta*")       { $Tool = $Files.tool.xdelta }
        elseif ($Patch -like "*.vcdiff*")   { $Tool = $Files.tool.xdelta3 }

        if ($New.Length -gt 0) {
            RemoveFile $New
            & $Tool -d -s $File $Patch $New | Out-Null
        }
        else {
            & $Tool -d -s $File $Patch ($File + ".ext") | Out-Null
            Move-Item -LiteralPath ($File + ".ext") -Destination $File -Force
        }
    }
    elseif ($Patch -like "*.ppf*") {
        if ($New.Length -gt 0) {
            Copy-Item -LiteralPath $File -Destination $New -Force
            & $Files.tool.applyPPF3 a $New $Patch | Out-Null
        }
        else { & $Files.tool.applyPPF3 a $File $Patch | Out-Null }
    }

    else { return $False }

    if (IsSet $New)   { WriteToConsole ("Applied patch: " + $Patch + " from " + $File + " to " + $New) }
    else              { WriteToConsole ("Applied patch: " + $Patch + " to " + $File) }
    return $True

}



#==============================================================================================================================================================================================
function DecompressROM([boolean]$Decompress) {
    
    if (!$Decompress) { return $True }
    
    if ($GameType.decompress -eq 1) {
        UpdateStatusLabel ("Decompressing " + $GameType.mode + " ROM...")

        Push-Location $Paths.Temp

        # Get the correct DMA table for the ROM
        if     ( (IsSet $GamePatch.redux.dmaTable) -and (IsChecked $Patches.Redux) )                                   { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GamePatch.redux.dmaTable }
        elseif (IsSet $GamePatch.dmaTable)                                                                             { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GamePatch.dmaTable }
        elseif ( (IsSet $GameType.dmaTable) -and $ROMHashSum -ne $CheckHashSum -and (IsChecked $Patches.Downgrade) )   { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GameType.dmaTable }
        elseif ($Settings.Core.Bit64 -eq $True)                                                                        { & $Files.tool.TabExt64 $GetROM.run | Out-Null }
        else                                                                                                           { & $Files.tool.TabExt32 $GetROM.run | Out-Null }

        WriteToConsole ("Generated DMA Table from: " + $GetROM.run)
        if ($Settings.Debug.AltDecompress -eq $True) {
            Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force
            & $Files.tool.Decompress $GetROM.decomp | Out-Null
            Move-Item -LiteralPath ($GetROM.decomp + "-decomp.z64") -Destination $GetROM.decomp -Force
        }
        else { & $Files.tool.ndec $GetROM.run $GetROM.decomp | Out-Null }
        WriteToConsole ("Decompressed ROM: " + $GetROM.decomp)
        Pop-Location

        if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force }
    }
    elseif ($GameType.decompress -eq 2) {
        UpdateStatusLabel ("Extending " + $GameType.mode + " ROM...")

        if (!(IsSet -Elem $GamePatch.extend -Min 18 -Max 64)) {
            UpdateStatusLabel 'Failed. Could not extend SM64 ROM. Make sure the "extend" value is between 18 and 64.'
            return $False
        }

        & $Files.tool.sm64extend $GetROM.run -s $GamePatch.extend $GetROM.decomp | Out-Null
    }

    if ($IsWiiVC) { RemoveFile $GetROM.run }
    return $True

}



#==============================================================================================================================================================================================
function CompressROM([boolean]$Decompress, [boolean]$Finalize) {
    
    if (!$Decompress -or !(TestFile $GetROM.decomp)) { return }

    if ($GameType.decompress -eq 1 -and $Settings.Debug.NoCompression -eq $False) {
        UpdateStatusLabel ("Compressing " + $GameType.mode + " ROM...")

        if ($Settings.Debug.KeepDecompressed -eq $True) { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.keepDecomp -Force }
        RemoveFile $Files.archive
        
        Push-Location -LiteralPath $Paths.Temp
        if ($Settings.Core.Bit64 -eq $True)   { & $Files.tool.Compress64 $GetROM.decomp $GetROM.patched | Out-Null }
        else                                  { & $Files.tool.Compress32 $GetROM.decomp $GetROM.patched | Out-Null }
        WriteToConsole ("Compressed ROM: " + $GetROM.patched)
        Pop-Location

        if ($Finalize -and (TestFile ($GameFiles.downgrade + "\finalize_rev0.bps"))) { ApplyPatch -File $GetROM.patched -Patch "Downgrade\finalize_rev0.bps" }
    }
    else { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force }

    $GetROM.run = $GetROM.patched

}



#==============================================================================================================================================================================================
function PatchRedux([boolean]$Decompress) {
    
    # BPS PATCHING REDUX #
    if ( (IsChecked $Patches.Redux) -and (IsSet -Elem $GamePatch.redux.file) ) {

        if ( !$Decompress -and !(TestFile $GetROM.decomp) ) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }

        UpdateStatusLabel ("Patching " + $GameType.mode + " REDUX...")

        # Redux patch
        if ($Patches.Options.Checked -and (IsWidescreen -Patched) ) {
            if (IsSet -Elem $GamePatch.redux.file_widescreen) { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file_widescreen }
        }
        elseif (IsSet -Elem $GamePatch.redux.file)   { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file }
    }

}



#==============================================================================================================================================================================================
function HackROMGameTitle($Title, $GameID, $Region) {

    if ($Title -eq $null -and $GameID -eq $null -and $Region -eq $null)   { return }
    if ($Settings.Debug.NoHeaderChange -eq $True)                         { return }
    if (!(TestFile $GetROM.patched))                                      { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.patched -Force }

    UpdateStatusLabel "Hacking in Custom Title and GameID..."

    # Hi-ROM check and load in Game Array
    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.patched)
    if ($GameConsole.mode -eq "SNES" -and (IsSet -Elem $GameConsole.rom_title_offset_hi) ) { $hiROM = (IsHiROM -Offset (GetDecimal -Hex $GameConsole.rom_title_offset_hi) -ROM $ByteArray) }

    # Internal ROM Title
    if ($Title -ne $null -and (IsSet $GameConsole.rom_title_offset) -and (IsSet -Elem $GameConsole.rom_title_length -Min 1) -and ($GameConsole.rom_title -gt 0) ) {
        if ($hiROM) { $offset = $GameConsole.rom_title_offset_hi } else { $offset = $GameConsole.rom_title_offset }
        $emptyTitle = foreach ($i in 1..$GameConsole.rom_title_length) { 20 }
        if ($GameConsole.rom_title_uppercase -gt 0) { $Title = $Title.ToUpper() }
        ChangeBytes -Offset $Offset -Values $emptyTitle
        ChangeBytes -Offset $offset -Values ($Title.ToCharArray() | % { [uint32][char]$_ }) -IsDec

        if ($GameConsole.mode -eq "SNES" -and (Get-Item -LiteralPath $GamePath).length/4MB -gt 1) {
            ChangeBytes -Offset (Get32Bit ( (GetDecimal $offset) + (GetDecimal "400000") ) ) -Values $emptyTitle
            ChangeBytes -Offset (Get32Bit ( (GetDecimal $offset) + (GetDecimal "400000") ) ) -Values ($Title.ToCharArray() | % { [uint32][char]$_ }) -IsDec
        }

        $emptyTitle = $null
    }

    # GameID
    if ($GameID -ne $null -and (IsSet -Elem $GameConsole.rom_gameID_offset) -and ($GameConsole.rom_gameID -eq 1)) { ChangeBytes -Offset $GameConsole.rom_gameID_offset -Values ($GameID.ToCharArray() | % { [uint32][char]$_ }) -IsDec }
    elseif ($Region -ne $null -and $GameConsole.rom_gameID -eq 2) {
        if ($hiROM) { $offset = $GameConsole.rom_title_offset_hi } else { $offset = $GameConsole.rom_title_offset }
        $offset = ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "19") ) )
        if ($ByteArrayGame[(GetDecimal $offset)] -ne $Region) {
            $ByteArrayGame[(GetDecimal $offset)] = $Region
            if ((Get-Item -LiteralPath $GamePath).length/4MB -gt 1) { $ByteArrayGame[(GetDecimal $offset) + (GetDecimal "400000")] = $Region }
            WriteToConsole ("Changed region code: " + (Get8Bit $Region))
            RemoveRegionProtection
        }

    }

    # Write to file and clear variables
    [io.file]::WriteAllBytes($GetROM.patched, $ByteArrayGame)

}



#==============================================================================================================================================================================================
function RemoveRegionProtection() {
    
    # Return conditions
    if ($GameConsole.remove_region_protection -ne 1)   { return }
    if (!(IsChecked $CustomHeader.EnableRegion))       { return }
    if (!$CustomHeader.Region.Visible)                 { return }

    # Load in region protection database
    $regions = SetJSONFile $Files.json.regions

    # Remove region protection for game if applicable
    for ($i=0; $i -lt $regions.Length; $i++) {
        for ($j=0; $j -lt $regions.hash.Length; $j++) {
            if ($regions[$i].hash[$j] -eq $ROMHashSum) {
                $entry = $regions[$i]
                break
            }
        }
    }

    if (IsSet $entry) {
        for ($i=0; $i -lt $entry.offset.Length; $i++) {
            $values = $entry.value[$i] -split '(.{2})' | ? {$_}
            ChangeBytes -Offset $entry.offset[$i] -Values $values
        }
    }

}



#==============================================================================================================================================================================================
function IsHiROM([uint32]$Offset) {
    
    for ($i=$Offset; $i -lt ($Offset + $GameConsole.rom_title_length); $i++) {
        if ( ($ByteArrayGame[$i] -lt 32) -or ($ByteArrayGame[$i] -gt 122) ) { return $False }
    }

    if (!(IsSet -Elem $ByteArrayGame[$Offset + $GameConsole.rom_title_length] -Min 32 -Max 64))   { return $False }
    if ($ByteArrayGame[$Offset + $GameConsole.rom_title_length + 3] -gt 10)                       { return $False }
    if ($ByteArrayGame[$Offset + $GameConsole.rom_title_length + 4] -gt 10)                       { return $False }

    return $True

}



#==============================================================================================================================================================================================
function IsWidescreen([switch]$Patched, [switch]$Experimental) {
    
    if (IsChecked $Redux.Graphics.Widescreen -Not)                         { return $False }
    if ($IsWiiVC)                                                          { return $False }
    if ($Patched -and !(IsSet -Elem $GamePatch.redux.file_widescreen) )    { return $False }
    if ($Settings.Debug.LiteGUI -eq $True)                                 { return $False }

    if     (!$Patched -and !$Experimental)   { return ( !$Patches.Redux.Checked -and $Settings.Debug.ChangeWidescreen -eq $False) }
    elseif ( $Patched -and !$Experimental)   { return (  $Patches.Redux.Checked -and $Settings.Debug.ChangeWidescreen -eq $False) }
    elseif (!$Patched -and  $Experimental)   { return ( !$Patches.Redux.Checked -and $Settings.Debug.ChangeWidescreen -eq $True)  }
    elseif ( $Patched -and  $Experimental)   { return (  $Patches.Redux.Checked -and $Settings.Debug.ChangeWidescreen -eq $True)  }

}



#==============================================================================================================================================================================================
function IsReduxOnly() {
    
    if ($Patches.Redux.Checked -and !(IsWidescreen -Patched)) { return $True }
    return $False

}



#==============================================================================================================================================================================================
function GetROMVersion() {

    foreach ($item in $GameType.version) { if ($ROMHashSum -eq $item.hash) { return $item } }
    return $null

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function MainFunction
Export-ModuleMember -Function ApplyPatch
Export-ModuleMember -Function Cleanup
Export-ModuleMember -Function IsWidescreen