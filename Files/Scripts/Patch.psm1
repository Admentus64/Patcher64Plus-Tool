function MainFunction([string]$Command, [string]$PatchedFileName) {
    
    # Reset variables
    $global:WarningError  = $False
    $global:PatchInfo     = @{}
    $PatchInfo.decompress = $False
    $PatchInfo.downgrade  = $False
    $PatchInfo.finalize   = $True
    $PatchInfo.run        = $True

    # Header
    $Header = @($null) * 5
    $Header = SetHeader -Header $Header -ROMTitle $GamePatch.rom_title -ROMGameID $GamePatch.rom_gameID -VCTitle $GamePatch.vc_title -VCGameID $GamePatch.vc_gameID -Region $GamePatch.rom_region

    # Output
    if (!(IsSet $PatchedFileName)) { $PatchedFileName = "_patched" }
    
    # Expand Memory, Remap Controls
    if     ($VC.ExpandMemory.Active  -and $GamePatch.expand_memory  -eq  1)    { $VC.ExpandMemory.Checked  = $True }
    elseif ($VC.ExpandMemory.Active  -and $GamePatch.expand_memory  -eq -1)    { $VC.ExpandMemory.Checked  = $False }
    if     ($VC.RemapControls.Active -and $GamePatch.remap_controls -eq  1)    { $VC.RemapControls.Checked = $True }
    elseif ($VC.RemapControls.Active -and $GamePatch.remap_controls -eq -1)    { $VC.RemapControls.Checked = $False }

    # Finalize
    if     (IsChecked $Patches.Options)          { $PatchInfo.finalize = $False }
    if     ($GamePatch.finalize -eq 0)           { $PatchInfo.finalize = $False }
    elseif ($GamePatch.finalize -eq 1)           { $PatchInfo.finalize = $True }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") ) {
        # Redux
        if ( (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file)) {
            $Header = SetHeader -Header $Header -ROMTitle $GamePatch.redux.rom_title -ROMGameID $GamePatch.redux.rom_gameID -VCTitle $GamePatch.redux.vc_title -VCGameID $GamePatch.redux.vc_gameID -Region $GamePatch.rom_region
            if     ($VC.RemapControls.Active -and $GamePatch.redux.remap_controls -eq  1)   { $VC.RemapControls.Checked = $True }
            elseif ($VC.RemapControls.Active -and $GamePatch.redux.remap_controls -eq -1)   { $VC.RemapControls.Checked = $False }
            if     ($VC.ExpandMemory.Active  -and $GamePatch.redux.expand_memory  -eq  1)   { $VC.ExpandMemory.Checked  = $True }
            elseif ($VC.ExpandMemory.Active  -and $GamePatch.redux.expand_memory  -eq -1)   { $VC.ExpandMemory.Checked  = $False }
            if     (IsSet -Elem $GamePatch.redux.output)   { $PatchedFileName = $GamePatch.redux.output }
            $PatchInfo.finalize = $False
        }

        # Language Patch
        $global:LanguagePatch = $global:LanguagePatchFile = $null
        if ( (IsSet $Files.json.languages) -and (IsChecked $Patches.Options) -and (IsSet $Redux.Language) ) {
            for ($i=0; $i -lt $Files.json.languages.Length; $i++) {
                if (IsChecked $Redux.Language[$i]) {
                    $global:LanguagePatch = $Files.json.languages[$i]
                    break
                }
            }

            if (TestFile (CheckPatchExtension ($GameFiles.languages + "\" + $LanguagePatch.code) ) ) {
                $Ext = (Get-Item (CheckPatchExtension ($GameFiles.languages + "\" + $LanguagePatch.code) ) ).Extension
                $global:LanguagePatchFile = "Languages\" + $LanguagePatch.code + $Ext
            }
            $Header = SetHeader -Header $Header -ROMTitle $LanguagePatch.rom_title -ROMGameID $LanguagePatch.rom_gameID -VCTitle $LanguagePatch.vc_title -VCGameID $LanguagePatch.vc_gameID -Region $LanguagePatch.rom_region
            if     (IsSet $LanguagePatch.output)     { $PatchedFileName = $LanguagePatch.output }
            if     ($LanguagePatch.finalize -eq 0)   { $PatchInfo.finalize  = $False }
            elseif ($LanguagePatch.finalize -eq 1)   { $PatchInfo.finalize  = $True }
            
            if (IsSet $LanguagePatch.region)     {
                if (!(IsSet $Header[1])) { $Header[1] = $GameType.rom_gameID }
                $Header[1] = $Header[1].substring(0, 3) + $LanguagePatch.region
            }
        }
    }

    #  Title / GameID
    if ($CustomHeader.EnableHeader.Checked) {
        if (!$IsWiiVC) {
            if ($CustomHeader.ROMTitle.TextLength  -gt 0)   { $Header[0] = [string]$CustomHeader.ROMTitle.Text  }
            if ($CustomHeader.ROMGameID.TextLength -eq 4)   { $Header[1] = [string]$CustomHeader.ROMGameID.Text }
        }
        else {
            if ($CustomHeader.VCTitle.TextLength  -gt 0)    { $Header[2] = [string]$CustomHeader.VCTitle.Text  }
            if ($CustomHeader.VCGameID.TextLength -eq 4)    { $Header[3] = [string]$CustomHeader.VCGameID.Text }
        }
    }

    # Region
    if ($CustomHeader.EnableRegion.Checked -and $GameConsole.rom_gameID -eq 2) { $Header[4] = [Byte]$CustomHeader.Region.SelectedIndex }
    
    # Set ROM
    if ($GameType.checksum -ne 0) {
        foreach ($rev in $GameType.version) {
            if ($rev.list -eq $CurrentGame.Rev.Text) {
                $global:CheckHashSum = $rev.hash
                break
            }
        }
    }
    if ( (IsSet -Elem $InjectFile -MinLength 4) -and $IsWiiVC) { $global:ROMFile = SetROMParameters -Path $InjectPath -PatchedFileName $PatchedFileName }
    if (!$IsWiiVC) {
        $global:ROMFile = SetROMParameters -Path $GamePath -PatchedFileName $PatchedFileName
        SetGetROM
    }

    # Decompress
    if ($GameType.decompress -gt 0) {
        if     (StrStarts -Str (GetPatchFile) -Val "Decompressed\")   { $PatchInfo.decompress = $True }
        elseif ($PatchInfo.downgrade)                                 { $PatchInfo.decompress = $True }
        elseif ($GameType.decompress -eq 1 -and !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") ) {
            if ( (IsChecked $Patches.Options) -or (IsChecked $Patches.Redux) )   { $PatchInfo.decompress = $True }
        }
        elseif ($GameType.decompress -eq 2 -and (IsChecked $Patches.Extend))     { $PatchInfo.decompress = $True }
        elseif ($GameType.decompress -eq 3 -and (IsChecked $Patches.Extend))     { $PatchInfo.decompress = $True }
    }

    # Check if ROM is getting patched
    if ( (IsChecked $Patches.Options) -or (IsChecked $Patches.Redux) -or $PatchInfo.downgrade -or (IsSet $GamePatch.patch) -or (StrLike -str $Command -val "Apply Patch") ) { $PatchInfo.run = $True } else { $PatchInfo.run = $False }

    # GO!
    if ($Settings.NoCleanup.Checked -ne $True -and $IsWiiVC) { RemovePath $Paths.Temp } # Remove the temp folder first to avoid issues
    MainFunctionPatch -Command $Command -Header $Header -PatchedFileName $PatchedFileName
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
function MainFunctionPatch([string]$Command, [Array]$Header, [string]$PatchedFileName) {
    
    # Step 01: Prepare for patching
    WriteDebug -Command $Command -Header $Header -PatchedFileName $PatchedFileName
    if ($Settings.Debug.Stop -eq $True) { return $False }
    WriteToConsole "START PATCHING PROCESS OF SELECTED GAME"
    WriteToConsole

    # Step 02: Disable the main dialog, allow patching and delete files if they still exist and redirect to the neccesary folders
    EnableGUI $False
    if ($Settings.Core.LocalTempFolder -eq $True) { $GameFiles.extracted = $GameFiles.base + "\Extracted" }
    else {
        CreatePath $Paths.AppData
        $GameFiles.extracted = $Paths.AppData + "\" + $GameType.mode + "\Extracted"
    }
    CreatePath $Paths.Temp

    # Step 03: Unpack archive
    if (!(Unpack $PatchedFileName)) { return }

    # Step 04: Only continue with these steps in VC WAD mode, otherwise ignore these steps
    if ($IsWiiVC) {
        if (!(ExtractWADFile $PatchedFileName))   { return }   # Step A: Extract the contents of the WAD file
        if (!(CheckVCGameID))                     { return }   # Step B: Check the GameID to be vanilla
        if (!(ExtractU8AppFile $Command))         { return }   # Step C: Extract "00000005.app" file to get the ROM
        if (!(PatchVCROM -Command $Command))      { return }   # Step D: Do some initial patching stuff for the ROM for VC WAD files
        if (!(PatchVCEmulator $Command))          { return }   # Step E: Replace the Virtual Console emulator within the WAD file
    }

    # Step 05: Set checksum to determine downgrading & decompressing
    if (TestFile $GetROM.run)                                                   { $global:ROMHashSum    = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash }
    if ($Settings.Debug.IgnoreChecksum -eq $False -and (IsSet $CheckHashsum))   { $PatchInfo.downgrade  = ($ROMHashSum -ne $CheckHashSum) }
    if ($PatchInfo.downgrade)                                                   { $PatchInfo.decompress = $True }

    # Step 06: Convert, compare the hashsum of the ROM and check if the maximum size is allowed
    if (!(GetMaxSize $Command)) { return }
    if ($PatchInfo.run) {
        ConvertROM $Command
        if (!(CompareHashSums $Command)) { return }
    }

    # Step 07: Downgrade and decompress the ROM if required
    if ( (StrLike -str $Command -val "Inject" -Not) -and $PatchInfo.run) {
        if (!(DecompressROM)) { return }
        $item = DowngradeROM
        if ( (IsSet $item.rom_gameID) -and !(IsSet $header[1]) ) { $header = SetHeader -Header $Header -ROMGameID $item.rom_gameID }
    }

    # Step 08: Patch the ROM
    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") -and $PatchInfo.run) {
        ExtractMQData                               # Step A: Extract MQ dungeon data for OoT
        PrePatchingAdditionalOptions                # Step B: Apply additional options before Redux
        PatchRedux                                  # Step C: Apply the Redux patch
        if (!(PatchDecompressedROM))   { return }   # Step D: Patch and extend the ROM file with the patch through Floating IPS
        PatchingAdditionalOptions                   # Step E: Apply additional options
        CompressROM                                 # Step F: Compress the decompressed ROM if required
        if (!(PatchCompressedROM))     { return }   # Step G: Patch and extend the ROM file with the patch through Floating IPS
    }
    elseif (StrLike -str $Command -val "Apply Patch") { # Step H: Compress if needed and apply provided BPS Patch
        CompressROM
        if (!(ApplyPatchROM)) { return }
    }
    
    # Step 09: Misc tasks
    if ($PatchInfo.run) { UpdateROMCRC }                                       # Step A: Update the .Z64 ROM CRC
    HackROMGameTitle -Title $Header[0] -GameID $Header[1] -Region $Header[4]   # Step B: Hack the Game Title and GameID of a N64 ROM, remove the US region protection as well if applicable and neccesary
    CreateDebugPatches                                                         # Step C: Debug

    # Step 10: Only continue with these steps in VC WAD mode, otherwise ignore these steps
    if ($IsWiiVC) {
        if ($PatchInfo.run) { ExtendROM }      # Step A: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        if ($PatchInfo.run) { CompressROMC }   # Step B: Compress the ROMC again if possible
        HackOpeningBNRTitle $Header[2]         # Step C: Hack the Channel Title.
        RepackU8AppFile                        # Step D: Repack the "00000005.app" with the updated ROM file 
        RepackWADFile $Header[3]               # Step E: Repack the WAD file with the updated APP file
    }

    # Step 11: Final message
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
function WriteDebug([string]$Command, [string[]]$Header, [string]$PatchedFileName) {
    
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
    WriteToConsole ("Language File: " + $LanguagePatchFile + " (" + $LanguagePatch.code + ")")
    WriteToConsole ("Output Name:   " + $PatchedFileName)
    WriteToConsole ("Command:       " + $Command)
    WriteToConsole ("Downgrade:     " + $PatchInfo.downgrade)
    WriteToConsole ("Finalize:      " + $PatchInfo.finalize)
    WriteToConsole ("Decompress:    " + $PatchInfo.decompress)
    WriteToConsole ("ROM Hash:      " + $ROMHashSum)
    WriteToConsole ("No-Intro Hash: " + $CheckHashSum)
    WriteToConsole ("Wii VC Mode:   " + $IsWiiVC)
    WriteToConsole ("ROM Path:      " + $GamePath)
    WriteToConsole ("Inject Path:   " + $InjectPath)
    WriteToConsole ("Patch Path:    " + $PatchPath)
    WriteToConsole ("Patch ROM:     " + $PatchInfo.run)
    WriteToConsole ("ROM Size:      " + (((Get-Item -LiteralPath $GamePath).length)/1MB).tostring("#.#") + "MB")
    WriteToConsole "--- End Patch Info ---"
    WriteToConsole
    WriteToConsole
    WriteToConsole
    WriteToConsole "--- Start Misc Settings Info ---"
    WriteToConsole ("Ignore Input Checksum: " + $GeneralSettings.IgnoreChecksum.Checked)
    WriteToConsole ("Interace GUI Mode:     " + $Settings.Core.Interface)
    WriteToConsole ("Force Show Options:    " + $GeneralSettings.ForceOptions.Checked)
    WriteToConsole ("Use Local Temp Folder: " + $GeneralSettings.LocalTempFolder.Checked)
    WriteToConsole "--- End Misc Settings Info ---"

    if (!$Patches.Options.Checked) { return }

    WriteToConsole
    WriteToConsole
    WriteToConsole
    WriteToConsole "--- Start Additional Options Info ---"
    
    foreach ($item in $Redux.Groups) {
        foreach ($form in $item.controls) {
            if     ($form.GetType().Name -eq "CheckBox"    -and $form.enabled)   { if (IsChecked $form)                                                 { WriteToConsole ($item.text + ". " + $form.name) } }
            elseif ($form.GetType().Name -eq "RadioButton" -and $form.enabled)   { if ( (IsDefault $form -Not $form.checked) -and (IsChecked $form) )   { WriteToConsole ($item.text + ". " + $form.name) } }
            elseif ($form.GetType().Name -eq "ComboBox"    -and $form.enabled)   { if (IsDefault $form -Not $form.text)                                 { WriteToConsole ($item.text + ". " + $form.name + " -> " + $form.text)  } }
            elseif ($form.GetType().Name -eq "TrackBar"    -and $form.enabled)   { if (IsDefault $form -Not $form.value)                                { WriteToConsole ($item.text + ". " + $form.name + " -> " + $form.value) } }

            elseif ($form.GetType() -eq [System.Windows.Forms.Panel]) {
                foreach ($subform in $form.controls) {
                    if     ($subform.GetType().Name -eq "CheckBox"    -and $form.enabled)   { if (IsChecked $subform)                                                       { WriteToConsole ($item.text + ". " + $subform.name) } }
                    elseif ($subform.GetType().Name -eq "RadioButton" -and $form.enabled)   { if ( (IsDefault $subform -Not $subform.checked) -and (IsChecked $subform) )   { WriteToConsole ($item.text + ". " + $subform.name) } }
                    elseif ($subform.GetType().Name -eq "ComboBox"    -and $form.enabled)   { if (IsDefault $subform -Not $subform.text)                                    { WriteToConsole ($item.text + ". " + $subform.name + " -> " + $subform.text)  } }
                    elseif ($subform.GetType().Name -eq "TrackBar"    -and $form.enabled)   { if (IsDefault $subform -Not $subform.value)                                   { WriteToConsole ($item.text + ". " + $subform.name + " -> " + $subform.value) } }
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
function Unpack() {
    
    $Ext = (Get-Item $GamePath).Extension

    if ($Ext -ne ".zip" -and $Ext -ne ".rar" -and $Ext -ne ".7z") { return $True }

    $path = $paths.Temp + "\archive"
    RemovePath $path
    UpdateStatusLabel "Unpacking ROM Archive..."
    try {
        & $Files.tool.zip e $GamePath ("-o" + $path)
        $file = $null
        Get-ChildItem -Path $path -File -Name | ForEach-Object {
            $Ext = [System.IO.Path]::GetExtension($_)
            if ($Ext -eq '.z64' -or $Ext -eq '.n64' -or $Ext -eq '.v64' -or $Ext -eq '.sfc' -or $Ext -eq '.smc' -or $Ext -eq '.nes' -or $Ext -eq '.gbc') { $file = ($path + "\" + [System.IO.Path]::GetFileName($_)) }
        }
        if ($file -eq $null) { return $False }
        $ROMFile.ROM = $file
        SetGetROM
    }
    catch { return $False }

    return $True

}



#==============================================================================================================================================================================================
function GetPatchFile() {
    
    if ($GamePatch.patch -is [System.Array]) {
        foreach ($item in $GamePatch.patch) {
            if ($item.hash -eq $ROMHashSum -and ( ($item.console -eq "Native" -and !$IsWiiVC) -or ($item.console -eq "Wii VC" -and $IsWiiVC) -or !(IsSet $item.console) ) ) { return $item.file }
        }
        return $GamePatch.patch[0].file
    }
    return $GamePatch.patch

}



#==============================================================================================================================================================================================
function PrePatchingAdditionalOptions() {

    if (!(IsSet $GamePatch.options) -or !$Patches.Options.Checked -or !$Patches.Options.Visible)   { return }
    if (!$PatchInfo.decompress -and !(TestFile $GetROM.decomp) )                                   { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }

    # BPS - Pre-Redux Options
    if ( (GetCommand "PrePatchReduxOptions") -and (IsChecked $Patches.Redux) -and (IsSet $GamePatch.redux.file) ) {
        UpdateStatusLabel ("Pre-Patching " + $GameType.mode + " Additional Redux Patches...")
        iex "PrePatchReduxOptions"
    }

}



#==============================================================================================================================================================================================
function PatchingAdditionalOptions() {
    
    if (!(IsSet $GamePatch.options) -or !$Patches.Options.Checked -or !$Patches.Options.Visible)   { return }
    if (!$PatchInfo.decompress -and !(TestFile $GetROM.decomp) )                                   { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
    
    # BPS - Additional Options (before languages)
    if (GetCommand "PrePatchLanguageOptions") {
        UpdateStatusLabel ("Pre-Patching " + $GameType.mode + " Additional Options Patches...")
        iex "PrePatchLanguageOptions"
    }

    # Language patches
    if ($Settings.Debug.ExtractCleanScript -eq $True -and (IsSet $LanguagePatch.script_dma) -and (IsSet $LanguagePatch.table_start) -and (IsSet $LanguagePatch.table_length)) {
        $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)
        CreateSubPath $GameFiles.editor
        $start  = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
        $end    = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
        $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )
        ExportBytes -Offset $start                     -Length $length                     -Output ($GameFiles.editor + "\message_data_static.bin") -Force
        ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($GameFiles.editor + "\message_data.tbl")        -Force
    }

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
    if ( (GetCommand "CheckLanguageOptions") -and (GetCommand "ByteLanguageOptions") ) {
        if ( (iex "CheckLanguageOptions") -and (IsSet $LanguagePatch.script_dma) ) {
            UpdateStatusLabel ("Patching " + $GameType.mode + " Additional Language Options...")

            $start  = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
            $end    = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
            $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )
            ExportBytes -Offset $start                     -Length $length                     -Output ($GameFiles.extracted + "\message_data_static.bin") -Force
            ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($GameFiles.extracted + "\message_data.tbl")        -Force

            if (GetCommand "WholeLanguageOptions") { iex "WholeLanguageOptions" }
            LoadScript -Script ($GameFiles.extracted + "\message_data_static.bin") -Table ($GameFiles.extracted + "\message_data.tbl")

            $global:ScriptLastID    = "0000"
            $global:ScriptLastIndex = 0
            $Files.json.textEditor  = SetJSONFile $GameFiles.textEditor
            iex "ByteLanguageOptions"

            SaveScript -Script ($GameFiles.extracted + "\message_data_static.bin") -Table ($GameFiles.extracted + "\message_data.tbl")
            PatchBytes -Offset $start                     -Patch "message_data_static.bin" -Extracted
            PatchBytes -Offset $LanguagePatch.table_start -Patch "message_data.tbl"        -Extracted

            $lengthDifference = (Get-Item ($GameFiles.extracted + "\message_data_static.bin")).length - ( (GetDecimal $end) - (GetDecimal $start) )
            while ($lengthDifference % 16 -ne 0) { $lengthDifference++ }
            if ($lengthDifference -ne 0) { ChangeBytes -Offset (AddToOffset -Hex $LanguagePatch.script_dma -Add "04") -Values (AddToOffset -Hex $end -Add (Get32Bit $lengthDifference)) }

            if ($Settings.Debug.ExtractFullScript -eq $True) {
                CreateSubPath $GameFiles.editor
                ExportBytes -Offset $start                     -Length $length                     -Output ($GameFiles.editor + "\message_data_static.bin") -Force
                ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($GameFiles.editor + "\message_data.tbl")        -Force
            }
        }
    }

    if ( (GetCommand "ByteOptions") -or (GetCommand "ByteReduxOptions") -or (GetCommand "ByteLanguageOptions") ) {
        [System.IO.File]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)
        $ByteArrayGame = $null
    }

    if (!$PatchInfo.decompress) { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force }

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {
    
    if ($Settings.Debug.NoCRCChange -eq $True -or $GameConsole.mode -ne "N64") { return }

    if (!(TestFile $GetROM.patched)) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.patched }
    & $Files.tool.rn64crc $GetROM.patched -update | Out-Null
    WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.patched)

    if ($Settings.Debug.KeepConverted    -eq $True -and (TestFile $GetROM.keepConvert)   )   { & $Files.tool.rn64crc $GetROM.keepConvert   -update | Out-Null; WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.keepConvert)   }
    if ($Settings.Debug.KeepDowngraded   -eq $True -and (TestFile $GetROM.keepDowngrade) )   { & $Files.tool.rn64crc $GetROM.keepDowngrade -update | Out-Null; WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.keepDowngrade) }
    if ($Settings.Debug.KeepDecompressed -eq $True -and (TestFile $GetROM.keepDecomp)    )   { & $Files.tool.rn64crc $GetROM.keepDecomp   -update  | Out-Null; WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.keepDecomp)    }

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
function DowngradeROM() {
    
    if (!$PatchInfo.downgrade) { return }

    # Downgrade a ROM if it is required first
    UpdateStatusLabel "Downgrading ROM..."

    if ($ROMHashSum -eq $CheckHashSum) {
        WriteToConsole "ROM is already downgraded"
        return $null
    }

    if (!(TestFile $GetROM.decomp))   { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
    if ($PatchInfo.decompress)        { $GetROM.run = $GetROM.decomp }
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
    return $null
    
}



#==============================================================================================================================================================================================
function GetMaxSize([string]$Command) {

    if ($Settings.Debug.IgnoreChecksum -eq $True)   { return $True }
    if (StrLike -str $Command -val "Inject")        { return $True }

    $maxSize = ($GameConsole.max_size) + "MB"
    if ((Get-Item -LiteralPath $GetROM.run).length/$maxSize -gt 1) {
        UpdateStatusLabel ("The ROM is too large! The max allowed size is " + $maxSize) + "!"
        return $False
    }

    return $True

}



#==============================================================================================================================================================================================
function ConvertROM([string]$Command) {
    
    if ($Settings.Debug.NoConversion -eq $True)    { return }
    if ( (StrLike -str $Command -val "Inject") )   { return }

    $array = [IO.File]::ReadAllBytes($GetROM.run)

    # Convert ROM if needed
    if ($GameConsole.mode -eq "NES") {
        if (IsSet $GameType.header) {
            $header = $GameType.header
            if     ($header -Like "* *")   { $header = $header -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
            else                           { $header = $header -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
        }
        else { $header = $null }

        if ((Get-Item -LiteralPath $GetROM.run).length/1KB % 2 -eq 0) {
            UpdateStatusLabel "Adding header to ROM..."
            $array = @(78, 69, 83, 26) + $header + $array
        }
        elseif ($header -ne $null -and $array[4..15] -ne $header) {
            UpdateStatusLabel "Updating header to iNES 2.0..."
            for ($i=0; $i -lt 12; $i++) { $array[4+$i] = $header[$i] }
        }
        else { return }
    }

    elseif ($GameConsole.mode -eq "SNES") {
        if ((Get-Item -LiteralPath $GetROM.run).length/1KB % 2 -ne 0) {
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
    $global:ROMHashSum = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash
    if ($Settings.Debug.KeepConverted -eq $True) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.keepConvert -Force }

}



#==============================================================================================================================================================================================
function CompareHashSums([string]$Command) {
    
    if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.clean -Force }
    if ($Settings.Debug.IgnoreChecksum -eq $True) { return $True }
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }

    $item = GetROMVersion
    if ($item -eq $null) {
        UpdateStatusLabel "Failed! The ROM is an incorrect version or is broken."
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
function ApplyPatchROM() {
    
    $HashSum1 = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash
    if ($PatchInfo.decompress)   { $File = $GetROM.patched }
    else                         { $File = $GetROM.run }

    if ($IsWiiVC)   { if (!(ApplyPatch -File $File -Patch $PatchPath                      -FullPath))   { return $False } }
    else            { if (!(ApplyPatch -File $File -Patch $PatchPath -New $GetROM.patched -FullPath))   { return $False } }
    $HashSum2 = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.patched).Hash

    if ($HashSum1 -eq $HashSum2) {
        if ($IsWiiVC -and $GameType.downgrade -and !$PatchInfo.downgrade -and $Patches.Options.Checked -or $Patches.Options.Visible )   { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?" }
        elseif ($IsWiiVC -and $GameType.downgrade -and $Downgrade)                                                                      { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" }
        else                                                                                                                            { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged." }
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
    elseif ($FilesPath)    { $Patch = $Paths.Master + "\" + $Patch   }
    else                   { $Patch = $GameFiles.base + "\" + $Patch }

    if (TestFile ($Patch + ".bps"))      { $Patch + ".bps"    }
    if (TestFile ($Patch + ".ips"))      { $Patch + ".ips"    }
    if (TestFile ($Patch + ".ups"))      { $Patch + ".ups"    }
    if (TestFile ($Patch + ".xdelta"))   { $Patch + ".xdelta" }
    if (TestFile ($Patch + ".vcdiff"))   { $Patch + ".vcdiff" }
    if (TestFile ($Patch + ".ppf"))      { $Patch + ".ppf"    }

    if (TestFile $Patch) { $Patch = Get-Item -LiteralPath $Patch }
    else { # Patch File does not exist
        UpdateStatusLabel "Failed! Could not find patch file."
        WriteToConsole ("Missing patch file: " + $Patch)
        return $False
    }

    # Patching
    if ($Patch -like "*.bps*" -or $Patch -like "*.ips*") {
        if ($New.Length -gt 0)   { & $Files.tool.flips --ignore-checksum --apply $Patch $File $New | Out-Null }
        else                     { & $Files.tool.flips --ignore-checksum $Patch $File | Out-Null              }
    }
    elseif ($Patch -like "*.ups*") {
        if ($New.Length -gt 0)   { & $Files.tool.ups apply -b $File -p $Patch -o $New | Out-Null  }
        else                     { & $Files.tool.ups apply -b $File -p $Patch -o $File | Out-Null }
    }
    elseif ($Patch -like "*.xdelta*" -or $Patch -like "*.vcdiff*") {
        if     ($Patch -like "*.xdelta*")   { $Tool = $Files.tool.xdelta  }
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
    else              { WriteToConsole ("Applied patch: " + $Patch + " to " + $File)                   }
    return $True

}



#==============================================================================================================================================================================================
function DecompressROM() {
    
    if (!$PatchInfo.decompress) { return $True }
    
    # ROM is already decompressed, but is still recognized as decompressed for patching
    if (((Get-Item -LiteralPath $GetROM.run).length)/1MB -ge $GameConsole.max_size) {
        Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force
        RemoveFile $Files.dmaTable
        Add-Content $Files.dmaTable $GameRev.dmaTable
        if ($IsWiiVC) { RemoveFile $GetROM.run }
        return $True
    }

    if ($GameType.decompress -eq 1) {
        UpdateStatusLabel ("Decompressing " + $GameType.mode + " ROM...")

        Push-Location $Paths.Temp

        # Get the correct DMA table for the ROM
        if     ( (IsSet $GamePatch.redux.dmaTable) -and (IsChecked $Patches.Redux) )                        { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GamePatch.redux.dmaTable }
        elseif (IsSet $GamePatch.dmaTable)                                                                  { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GamePatch.dmaTable       }
        elseif (IsSet $LanguagePatch.dmaTable)                                                              { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $LanguagePatch.dmaTable   }
        elseif ( (IsSet $GameType.dmaTable) -and $ROMHashSum -ne $CheckHashSum -and $PatchInfo.downgrade)   { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GameType.dmaTable        }
        else                                                                                                { & $Files.tool.TabExt $GetROM.run | Out-Null }

        WriteToConsole ("Generated DMA Table from: " + $GetROM.run)
        & $Files.tool.ndec $GetROM.run $GetROM.decomp | Out-Null
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
    elseif ($GameType.decompress -eq 3) {
        UpdateStatusLabel ("Extending " + $GameType.mode + " ROM...")
        ApplyPatch -Patch "extender.bps" -File $GetROM.run -New $GetROM.decomp
    }

    if ($IsWiiVC) { RemoveFile $GetROM.run }
    return $True

}



#==============================================================================================================================================================================================
function CompressROM() {
    
    if (!$PatchInfo.decompress -or !(TestFile $GetROM.decomp) -or $GamePatch.compress -eq 0) { return }

    if ($GameType.decompress -eq 1 -and $Settings.Debug.NoCompression -eq $False) {
        UpdateStatusLabel ("Compressing " + $GameType.mode + " ROM...")

        if ($Settings.Debug.KeepDecompressed -eq $True) { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.keepDecomp -Force }
        RemoveFile $Files.archive
        
        Push-Location -LiteralPath $Paths.Temp
        WriteToConsole ("Used DMA Table: " + (Get-Content $Files.dmaTable))
        & $Files.tool.Compress $GetROM.decomp $GetROM.patched | Out-Null
        WriteToConsole ("Compressed ROM: " + $GetROM.patched)
        Pop-Location

        if ($PatchInfo.finalize -and (TestFile ($GameFiles.downgrade + "\finalize_rev0.bps"))) { ApplyPatch -File $GetROM.patched -Patch "Downgrade\finalize_rev0.bps" }
    }
    else { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force }

    $GetROM.run = $GetROM.patched

}



#==============================================================================================================================================================================================
function PatchRedux() {
    
    # BPS PATCHING REDUX #
    if ( (IsChecked $Patches.Redux) -and (IsSet -Elem $GamePatch.redux.file) ) {

        if ( !$PatchInfo.decompress -and !(TestFile $GetROM.decomp) ) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }

        UpdateStatusLabel ("Patching " + $GameType.mode + " REDUX...")

        # Redux patch
        if     ( (IsChecked $Redux.Graphics.Widescreen) -and (IsChecked $Redux.Gameplay.AltRedux) -and (IsSet -Elem $GamePatch.redux.file_widescreen_v2) )   { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file_widescreen_v2 }
        elseif ( (IsChecked $Redux.Gameplay.AltRedux)   -and (IsSet -Elem $GamePatch.redux.file_v2) )                                                        { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file_v2 }
        elseif ( (IsChecked $Redux.Graphics.Widescreen) -and (IsSet -Elem $GamePatch.redux.file_widescreen) )                                                { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file_widescreen }
        elseif (IsSet -Elem $GamePatch.redux.file)                                                                                                           { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file }
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
function IsReduxOnly() {
    
    if ($Patches.Redux.Checked -and !(IsWidescreen -Patched)) { return $True }
    return $False

}



#==============================================================================================================================================================================================
function GetROMVersion() {
    
    foreach ($item in $GameType.version) {
        if ($ROMHashSum -eq $item.hash) {
            if     ( (IsSet $item.file) -and $CurrentGame.Rev.SelectedIndex -eq 0)   { return $GameRev }
            elseif ($item.list -eq $GameRev.list)                                    { return $item }
        }
    }

    return $null

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function MainFunction
Export-ModuleMember -Function ApplyPatch
Export-ModuleMember -Function Cleanup
Export-ModuleMember -Function GetPatchFile
Export-ModuleMember -Function FinishLanguagePatching

Export-ModuleMember -Function SetROMParameters
Export-ModuleMember -Function Unpack
Export-ModuleMember -Function ConvertROM
Export-ModuleMember -Function CompareHashSums
Export-ModuleMember -Function DecompressROM
Export-ModuleMember -Function DowngradeROM