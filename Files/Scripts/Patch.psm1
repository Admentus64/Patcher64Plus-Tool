function MainFunction([string]$Command, [string]$PatchedFileName) {
    
    # Refresh
    RefreshScripts

    # Close windows & tasks
    StopJobs
    CloseTextEditor
    CloseSceneEditor

    # Save settings
    if (IsSet $GameSettings) { Out-IniFile -FilePath (GetGameSettingsFile) -InputObject $GameSettings }
    
    # Reset variables
    $global:WarningError                                   = $global:ModelPatchingError = $global:OverwriteError = $global:MissingError = $False
    $global:PatchInfo                                      = @{}
    $PatchInfo.decompress                                  = $False
    $PatchInfo.downgrade                                   = $False
    $PatchInfo.finalize                                    = $True
    $PatchInfo.run                                         = $True
    $global:RunOverwriteChecks                             = $False
    $global:OverwritechecksROM                             = $null
    [System.Collections.ArrayList]$global:OptionsPatchList = @()

    # Header
    $Header = @($null) * 5
    $Header = SetHeader -Header $Header -ROMTitle $GamePatch.rom_title -ROMGameID $GamePatch.rom_gameID -VCTitle $GamePatch.vc_title -VCGameID $GamePatch.vc_gameID -Region $GamePatch.rom_region

    # Output
    if (!(IsSet $PatchedFileName))   { $PatchedFileName = "_patched" }
    else                             { $PatchedFileName = "_" + $PatchedFileName + "_patched" }
    
    # Expand Memory, Remap Controls
    if     ($VC.ExpandMemory.Active  -and $GamePatch.expand_memory  -eq  1)    { $VC.ExpandMemory.Checked  = $True  }
    elseif ($VC.ExpandMemory.Active  -and $GamePatch.expand_memory  -eq -1)    { $VC.ExpandMemory.Checked  = $False }
    if     ($VC.RemapControls.Active -and $GamePatch.remap_controls -eq  1)    { $VC.RemapControls.Checked = $True  }
    elseif ($VC.RemapControls.Active -and $GamePatch.remap_controls -eq -1)    { $VC.RemapControls.Checked = $False }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") ) {
        # Redux
        if ( ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) -and (IsSet $GamePatch.redux)) {
            $PatchedFileName = $PatchedFileName.replace("_patched", "_redux_patched")
            $Header = SetHeader -Header $Header -ROMTitle $GamePatch.redux.rom_title -ROMGameID $GamePatch.redux.rom_gameID -VCTitle $GamePatch.redux.vc_title -VCGameID $GamePatch.redux.vc_gameID -Region $GamePatch.rom_region
            if     ($VC.RemapControls.Active -and $GamePatch.redux.remap_controls -eq  1)   { $VC.RemapControls.Checked = $True  }
            elseif ($VC.RemapControls.Active -and $GamePatch.redux.remap_controls -eq -1)   { $VC.RemapControls.Checked = $False }
            if     ($VC.ExpandMemory.Active  -and $GamePatch.redux.expand_memory  -eq  1)   { $VC.ExpandMemory.Checked  = $True  }
            elseif ($VC.ExpandMemory.Active  -and $GamePatch.redux.expand_memory  -eq -1)   { $VC.ExpandMemory.Checked  = $False }
        }

        # Language Patch
        $global:LanguagePatch = $global:LanguagePatchFile = $null
        if (IsSet $Files.json.languages) {
            $global:LanguagePatch = $Files.json.languages[0]
            if ($Redux.Text.Language -ne $null -and (IsChecked $Patches.Options) ) {
                $global:LanguagePatch = $Files.json.languages[$Redux.Text.Language.SelectedIndex]
                if (TestFile (CheckPatchExtension ($GameFiles.languages + "\" + $LanguagePatch.code) ) ) {
                    $Ext                      = (Get-Item (CheckPatchExtension ($GameFiles.languages + "\" + $LanguagePatch.code) ) ).Extension
                    $global:LanguagePatchFile = "Languages\" + $LanguagePatch.code + $Ext
                    $PatchedFileName          = $PatchedFileName.replace("_patched", "_" + $LanguagePatch.code + "_patched")
                }
                $Header = SetHeader -Header $Header -ROMTitle $LanguagePatch.rom_title -ROMGameID $LanguagePatch.rom_gameID -VCTitle $LanguagePatch.vc_title -VCGameID $LanguagePatch.vc_gameID -Region $LanguagePatch.rom_region
            
                if (IsSet $LanguagePatch.region)     {
                    if (!(IsSet $Header[1])) { $Header[1] = $GameType.rom_gameID }
                    $Header[1] = $Header[1].substring(0, 3) + $LanguagePatch.region
                }
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
    if ($GameType.checksum -ne 0) { $global:CheckHashSum = $GameRev.hash }
    if ( (IsSet -Elem $InjectFile -MinLength 4) -and $IsWiiVC) { $global:ROMFile = SetROMParameters -Path $InjectPath -PatchedFileName $PatchedFileName }
    if (!$IsWiiVC) {
        $global:ROMFile = SetROMParameters -Path $GamePath -PatchedFileName $PatchedFileName
        SetGetROM
    }

    # Decompress
    if ($GameType.decompress -gt 0) {
        if     ( (StrStarts -Str $GamePatch.patch -Val "Decompressed\") -or (IsSet $GamePatch.function) ) { $PatchInfo.decompress = $True }
        elseif ($GameType.decompress -eq 1 -and !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Extract") ) {
            if ( (IsChecked $Patches.Options) -or (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) -or (IsSet $GamePatch.function) )                                            { $PatchInfo.decompress = $True }
        }
        elseif ($GameType.decompress -eq 2 -and (IsChecked $Patches.Extend))                                                                                                            { $PatchInfo.decompress = $True }
        elseif ($GameType.decompress -eq 3 -and (IsChecked $Patches.Extend))                                                                                                            { $PatchInfo.decompress = $True }
        if     ($Settings.Debug.ExtractCleanScript -eq $True -and (IsSet $LanguagePatch.script_dma) -and (IsSet $LanguagePatch.table_start) -and (IsSet $LanguagePatch.table_length))   { $PatchInfo.decompress = $True }
    }

    # Check if ROM is getting patched
    if ( (IsChecked $Patches.Options) -or (IsChecked $Patches.Redux) -or (IsSet $GamePatch.patch) -or (StrLike -str $Command -val "Apply Patch") -or (IsSet $GamePatch.preset) -or (IsSet $GamePatch.function) ) { $PatchInfo.run = $True } else { $PatchInfo.run = $False }

    # Refresh game options script
    RefreshGameScript

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
    if ($Settings.Debug.IgnoreChecksum -eq $False -and (IsSet $CheckHashSum))   { $PatchInfo.downgrade  = ($ROMHashSum -ne $CheckHashSum) }
    if ($PatchInfo.downgrade -and $GameType.decompress -eq 1)                   { $PatchInfo.decompress = $True }

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
        if (!(PatchDecompressedROM)) { return }         # Step A: Patch the decompressed ROM file with the patch through Floating IPS
        ExtractMQData                                   # Step B: Extract MQ dungeon data for OoT
        PrePatchingAdditionalOptions                    # Step C: Apply additional options before Redux
        PatchRedux                                      # Step D: Apply the Redux patch
        PatchingAdditionalOptions                       # Step F: Apply additional options
        CompressROM                                     # Step G: Compress the decompressed ROM if required          
        if (!(PatchCompressedROM)) { return }           # Step H: Patch the compressed ROM file with the patch through Floating IPS
    }
    elseif (StrLike -str $Command -val "Apply Patch") { # Step I: Compress if needed and apply provided BPS Patch
        CompressROM
        if (!(ApplyPatchROM)) { return }
    }
    PatchDMA
    
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
    if ($IsWiiVC) { $text = "WAD" } else { $text = "ROM" }
    if (DoAssertSceneFiles) { UpdateStatusLabel ("Done asserting " + $GameType.mode + " " + $text + "."); return }
    if     (!$PatchInfo.run)                { UpdateStatusLabel ("There was nothing to patch for the " + $GameType.mode + " " + $text + ".")                                                      }
    elseif ($WarningError)                  { UpdateStatusLabel ("Done patching " + $GameType.mode + " " + $text + ", but encountered issues. Please check the log.")                      -Error }
    elseif ( ($IsWiiVC -and !(TestFile $WADFile.patched) ) -or (!$IsWiiVC -and !(TestFile $GetROM.patched) ) ) {
        UpdateStatusLabel ("Done patching " + $GameType.mode + " " + $text + ", but couldn't write to changed " + $text + ". Please check the log.") -Error
        WriteToConsole -Text "Are folder permission enabled for file writing?" -Error
    }
    elseif ($OverwriteError)                { UpdateStatusLabel ("Done patching " + $GameType.mode + " " + $text + ", but some options got overwritten. Please check the log.")            -Error }
    elseif ($MissingError)                  { UpdateStatusLabel ("Done patching " + $GameType.mode + " " + $text + ", but some options are missing. Please check the log.")                -Error }
    elseif ($ModelPatchingError)            { UpdateStatusLabel ("Done patching " + $GameType.mode + " " + $text + ", but couldn't apply custom model. Please check the log.")             -Error }
    else                                    { UpdateStatusLabel ("Done patching " + $GameType.mode + " " + $text + ".") }

    if ($OptionsPatchList.Count -gt 0) {
        foreach ($option in $OptionsPatchlist) { WriteToConsole ("Missing option: " + $option) -Error }
    }

}



#==============================================================================================================================================================================================
function WriteDebug([string]$Command, [string[]]$Header, [string]$PatchedFileName) {
    
    if ($Settings.Debug.ClearLog -eq $True) { Clear-Host }

    WriteToConsole
    WriteToConsole "--- Start Patch Info ---"
    WriteToConsole ("Game Mode:     " + $GameType.mode)
    WriteToConsole ("Console Mode:  " + $GameConsole.Mode)
    WriteToConsole ("Revision:      " + $GameRev.Name)
    WriteToConsole ("Patch Options: " + $GamePatch.title)
    WriteToConsole ("Custom Header: " + $Header)
    WriteToConsole ("Patch File:    " + $GamePatch.patch)
    WriteToConsole ("Use Options:   " + (UseOptions))
    WriteToConsole ("Use Redux:     " + ( ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) -and (IsSet $GamePatch.redux) ) )
    WriteToConsole ("Language File: " + $LanguagePatchFile + " (" + $LanguagePatch.code + ")")
    WriteToConsole ("Output Name:   " + $PatchedFileName)
    WriteToConsole ("Command:       " + $Command)
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
    WriteToConsole ("Ignore Input Checksum: " + $Settings.Debug.IgnoreChecksum)
    WriteToConsole ("Safe Options:          " + $Settings.Core.SafeOptions)
    WriteToConsole ("Use Local Temp Folder: " + $Settings.Core.LocalTempFolder)
    WriteToConsole "--- End Misc Settings Info ---"

    if (!(UseOptions)) { return }

    WriteToConsole
    WriteToConsole
    WriteToConsole
    WriteToConsole "--- Start Additional Options Info ---"

    foreach ($panel in $Redux.Panels) {
        if (!$panel.Enabled) { continue }
        foreach ($group in $panel.Controls) {
            if (!$group.Enabled) { continue }
            foreach ($form in $group.Controls) {
                if     ($form.GetType().Name -eq "CheckBox")      { if   (IsChecked $form)                                                        { if ($Settings.Debug.MissingChecks -eq $True) { $global:OptionsPatchList += $form.section + "." + $form.name }; WriteToConsole ($group.text.replace("&&", "&") + ". " + $form.name) } }
                elseif ($form.GetType().Name -eq "RadioButton")   { if ( (IsChecked $form) -and (IsDefault $form -Not) )                          { if ($Settings.Debug.MissingChecks -eq $True) { $global:OptionsPatchList += $form.section + "." + $form.name }; WriteToConsole ($group.text.replace("&&", "&") + ". " + $form.name) } }
                elseif ($form.GetType().Name -eq "ComboBox")      { if   (IsDefault $form -Not)                                                   { if ($Settings.Debug.MissingChecks -eq $True) { $global:OptionsPatchList += $form.section + "." + $form.name }; WriteToConsole ($group.text.replace("&&", "&") + ". " + $form.name + " -> " + $form.text.replace(" (default)", "") ) } }
                elseif ($form.GetType().Name -eq "TrackBar")      { if   (IsDefault $form -Not)                                                   { if ($Settings.Debug.MissingChecks -eq $True) { $global:OptionsPatchList += $form.section + "." + $form.name }; WriteToConsole ($group.text.replace("&&", "&") + ". " + $form.name + " -> " + $form.value                          ) } }
                elseif ($form.GetType().Name -eq "TextBox")       { if   (IsDefault $form -Not)                                                   { if ($Settings.Debug.MissingChecks -eq $True) { $global:OptionsPatchList += $form.section + "." + $form.name }; WriteToConsole ($group.text.replace("&&", "&") + ". " + $form.name + " -> " + $form.text                           ) } }
                elseif ($form.GetType().Name -eq "ListBox")       { if   ($form.SelectedItems -ne $null -and $form.SelectedItems -ne "Default")   { if ($Settings.Debug.MissingChecks -eq $True) { $global:OptionsPatchList += $form.section + "." + $form.name }; WriteToConsole ($group.text.replace("&&", "&") + ". " + $form.name + " -> " + $form.SelectedItems                  ) } }
            }
        }
    }

    WriteToConsole "--- End Additional Options Info ---"
    WriteToConsole

}



#==============================================================================================================================================================================================
function Cleanup([switch]$skipLanguageReset) {
    
    $global:ByteArrayGame = $global:ROMFile = $global:WADFile = $global:CheckHashSum = $global:ROMHashSum = $global:OverwritechecksROM = $null
    if (!$skipLanguageReset) { $global:LanguagePatch = $null }
    [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()

    if ($Settings.debug.NoCleanup -eq $True) { return }
    
    WriteToConsole "Cleaning up files..."
    RemovePath $Paths.cygdrive
    RemoveFile $Files.flipscfg
    RemoveFile $Files.stackdump
    Get-ChildItem -Path $Paths.Temp -File | ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force }
    (New-Item -Path $Paths.Temp -Force -ItemType Directory).Delete($True)

}



#==============================================================================================================================================================================================
function Unpack() {
    
    if (!(IsZipFile (Get-Item $GamePath).Extension) ) { return $True }

    UpdateStatusLabel "Unpacking ROM Archive..."
    
    $path = $paths.Temp + "\archive"
    RemovePath $path
    
    try {
        $script = { Param([string]$Tool, [string]$In, [string]$Out)
            & $Tool e $In ("-o" + $Out) | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.zip, $GamePath, $path)
        StartJobLoop -Name "Script"

        $file = $null
        Get-ChildItem -Path $path -File | ForEach-Object {
            if (IsROMFile $_.Extension) { $file = $_.FullName }
        }
        if ($file -eq $null) {
            UpdateStatusLabel "Failed! Could not find a ROM in the archive." -Error
            return $False
        }
        $ROMFile.ROM = $file
        SetGetROM
        return $True
    }
    catch {
        UpdateStatusLabel "Failed! Something went wrong with unpacking." -Error
        return $False
    }

    UpdateStatusLabel "Failed! Could not find a ROM to use." -Error
    return $False

}



#==============================================================================================================================================================================================
function UseOptions() {
    
    if (IsSet $GamePatch.script) {
        if ( (IsSet $GamePatch.preset) -or ($Patches.Options.Checked -and $Patches.Options.Visible) -or (IsSet $GamePatch.function) ) { return $True }
    }
    return $False

}



#==============================================================================================================================================================================================
function PrePatchingAdditionalOptions() {

    if (!(UseOptions))                                             { return }
    if (!$PatchInfo.decompress -and !(TestFile $GetROM.decomp) )   { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
    $GetROM.run = $GetROM.decomp

    # BPS - Pre-Redux Options
    if (HasCommand "PrePatchOptions") {
        UpdateStatusLabel ("Pre-Patching " + $GameType.mode + " Additional Patches...")
        PrePatchOptions
    }
    if ( (HasCommand "PrePatchReduxOptions") -and ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) -and (IsSet $GamePatch.redux) ) {
        UpdateStatusLabel ("Pre-Patching " + $GameType.mode + " Additional Redux Patches...")
        PrePatchReduxOptions
    }

}



#==============================================================================================================================================================================================
function CheckCommands() {
    
    if (   (CheckCommand "ByteOptions") -or (CheckCommand "ByteReduxOptions") )                                                     { return $True  }
    if (   (HasCommand ($GamePatch.function + "ByteTextOptions") ) -or (HasCommand ($GamePatch.function + "ByteSceneOptions") ) )   { return $True  }
    if ( ( (HasCommand "WholeTextOptions") -or (HasCommand "ByteTextOptions") ) -and $Settings.Debug.NoTextPatching -ne $True)      { return $True  }
    if (   (HasCommand "ByteSceneOptions")                                      -and $Settings.Debug.NoScenePatching -ne $True)     { return $True  }
    return $False

}



#==============================================================================================================================================================================================
function CheckCommand([string]$Command, [boolean]$Check=$True) {
    
    if ( (HasCommand $Command) -and $Check)              { return $True }
    if   (HasCommand ($GamePatch.function + $Command))   { return $True }
    return $False

}



#==============================================================================================================================================================================================
function RunCommand([string]$Command="", [string]$Message="", [boolean]$Check=$True) {
    
    if (DoAssertSceneFiles) { return }

    if ( (IsSet $GamePatch.preset) -or ($Patches.Options.Checked -and $Patches.Options.Visible) ) {
        if ( (HasCommand $Command) -and $Check) {
            UpdateStatusLabel ("Patching " + $GameType.mode + " Additional " + $Message + " Options...")
            iex $Command
        }
    }
    if ($Gamepatch.function -ne $null) {
        if (HasCommand ($GamePatch.function + $Command) ) {
            UpdateStatusLabel ("Patching " + $GameType.mode + " ROM Hack " + $Message + " Options...")
            iex ($GamePatch.function + $Command)
        }
    }

}



#==============================================================================================================================================================================================
function PatchingAdditionalOptions() {
    
    if (!(IsSet $GamePatch.script))                                { return }
    if (!$PatchInfo.decompress -and !(TestFile $GetROM.decomp) )   { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
    $GetROM.run = $GetROM.decomp
    
    # Language patches
    if ($Settings.Debug.ExtractCleanScript -eq $True -and (IsSet $LanguagePatch.script_dma) -and (IsSet $LanguagePatch.table_start) -and (IsSet $LanguagePatch.table_length) -and !(DoAssertSceneFiles) ) {
        $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)
        CreateSubPath $GameFiles.editor
        $start  = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
        $end    = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
        $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )
        ExportBytes -Offset $start                     -Length $length                     -Output ($GameFiles.editor + "\message_data_static." + $LanguagePatch.code + ".bin") -Force
        ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($GameFiles.editor + "\message_data."        + $LanguagePatch.code + ".tbl") -Force
    }

    if (!(UseOptions)) { return }
    
    if ($Settings.Debug.OverwriteChecks -eq $True) {
        $global:RunOverwriteChecks = $True
        $global:OverwritechecksROM = [System.IO.File]::ReadAllBytes($GetROM.decomp)
    }

    # BPS - Additional Options (before languages)
    RunCommand -Command "PrePatchTextOptions" -Message "Text File"

    if ( (IsSet -Elem $LanguagePatchFile) -and $Settings.Debug.NoTextPatching -ne $True -and !(DoAssertSceneFiles) ) {
        UpdateStatusLabel ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $GetROM.decomp -Patch $LanguagePatchFile
        $global:LanguagePatchFile = $null
    }

    # BPS - Additional Options
    RunCommand -Command "PatchOptions" -Message "File"
    if (DoAssertSceneFiles) { ApplyTestSceneFiles }

    # BPS - Redux Options
    if ( (HasCommand "PatchReduxOptions") -and ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) -and (IsSet $GamePatch.redux) ) { RunCommand -Command "PatchReduxOptions" -Message "Redux File" }

    if (CheckCommands) { $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp) }

    # Additional Options
    RunCommand -Command "ByteOptions" -Message "Byte"

    # Redux Options
    if ( (CheckCommand "ByteReduxOptions") -and ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) -and (IsSet $GamePatch.redux) -and !(DoAssertSceneFiles) ) {
        $global:Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
        RunCommand -Command "ByteReduxOptions" -Message "Redux"
        $global:Symbols = $null
    }

    # Scene Options
    if (CheckCommand -Command "ByteSceneOptions" -Check ($Settings.Debug.NoScenePatching -ne $True) ) {
        $global:RunOverwriteChecks = $False
        $global:SceneEditor        = @{}
        $Files.json.sceneEditor    = SetJSONFile $GameFiles.sceneEditor
        RunCommand -Command "ByteSceneOptions" -Message "Scene" -Check ($Settings.Debug.NoScenePatching -ne $True)
        if (DoAssertSceneFiles) { TestScenesFiles }
        $global:SceneEditor = $Files.json.sceneEditor = $null
        $global:RunOverwriteChecks = $True
    }
    
    # Language Options
    if ($Settings.Debug.NoTextPatching -ne $True -or (HasCommand ($GamePatch.function + "ByteTextOptions") ) -and !(DoAssertSceneFiles) ) {
        $Files.json.textEditor = $null
        if ($LanguagePatch.script_dma -ne $null -and $LanguagePatch.region -ne "J") {
            RemoveFile ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin")
            RemoveFile ($GameFiles.extracted + "\message_data."        + $LanguagePatch.code + ".tbl")

            if (HasCommand "WholeTextOptions") {
                WholeTextOptions
                if ( (TestFile ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") ) -and (TestFile ($GameFiles.extracted + "\message_data." + $LanguagePatch.code + ".tbl") ) ) {
                    $start = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
                    PatchBytes -Offset $start                     -Patch ("message_data_static." + $LanguagePatch.code + ".bin") -Extracted
                    PatchBytes -Offset $LanguagePatch.table_start -Patch ("message_data."        + $LanguagePatch.code + ".tbl") -Extracted
                }
            }
            
            RunCommand -Command "ByteTextOptions" -Message "Text"
        }
        
        if ($Files.json.textEditor -ne $null) {
            RunAllStoredMessages
            $start = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
            $end   = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
            
            SaveScript -Script ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") -Table ($GameFiles.extracted + "\message_data." + $LanguagePatch.code + ".tbl")
            PatchBytes -Offset $start                     -Patch ("message_data_static." + $LanguagePatch.code + ".bin") -Extracted
            PatchBytes -Offset $LanguagePatch.table_start -Patch ("message_data."        + $LanguagePatch.code + ".tbl") -Extracted
            
            $lengthDifference = (Get-Item ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin")).length - ( (GetDecimal $end) - (GetDecimal $start) )
            while ($lengthDifference % 16 -ne 0) { $lengthDifference++ }
            if ($lengthDifference -lt 0) { $lengthDifference = 0 }
            if ($lengthDifference -ne 0) { ChangeBytes -Offset (AddToOffset -Hex $LanguagePatch.script_dma -Add "04") -Values (AddToOffset -Hex $end -Add (Get32Bit $lengthDifference)) }
            
            if ($Settings.Debug.ExtractFullScript -eq $True) {
                CreateSubPath $GameFiles.editor
                Copy-Item -LiteralPath ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") -Destination ($GameFiles.editor + "\message_data_static." + $LanguagePatch.code + ".bin") -Force
                Copy-Item -LiteralPath ($GameFiles.extracted + "\message_data."        + $LanguagePatch.code + ".tbl") -Destination ($GameFiles.editor + "\message_data."        + $LanguagePatch.code + ".tbl") -Force
            }

            $global:LastScript = $global:DialogueList = $global:ByteScriptArray = $global:ByteTableArray = $Files.json.textEditor = $null
        }
    }

    if (CheckCommands) {
        [System.IO.File]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)
        $global:ByteArrayGame = $global:LanguagePatch = $null
    }

    if (!$PatchInfo.decompress) { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force; $GetROM.run = $GetROM.patched }

    $global:RunOverwriteChecks = $False

}



#==============================================================================================================================================================================================
function ApplyText([string]$Script, [string]$Table) {
    
    $start  = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
    $end    = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
    $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )

    ExportBytes -Offset $start                     -Length $length                     -Output ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") -Force
    ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($GameFiles.extracted + "\message_data."        + $LanguagePatch.code + ".tbl") -Force

    ApplyPatch -File ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") -Patch ("Export\Message\" + $Script)
    ApplyPatch -File ($GameFiles.extracted + "\message_data."        + $LanguagePatch.code + ".tbl") -Patch ("Export\Message\" + $Table)

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {
    
    if ($Settings.Debug.NoCRCChange -eq $True -or $GameConsole.mode -ne "N64") { return }

    if (!(TestFile $GetROM.patched)) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.patched; $GetROM.run = $GetROM.patched }
    & $Files.tool.rn64crc $GetROM.patched -update | Out-Null
    WriteToConsole ("Updated CRC hash for ROM: " + $GetROM.patched)

    if ($Settings.Debug.KeepConverted    -eq $True -and (TestFile $GetROM.keepConvert)   )   { ApplyUpdateROMCRC $GetROM.keepConvert   }
    if ($Settings.Debug.KeepDowngraded   -eq $True -and (TestFile $GetROM.keepDowngrade) )   { ApplyUpdateROMCRC $GetROM.keepDowngrade }
    if ($Settings.Debug.KeepDecompressed -eq $True -and (TestFile $GetROM.keepDecomp)    )   { ApplyUpdateROMCRC $GetROM.keepDecomp    }

}


#==============================================================================================================================================================================================
function ApplyUpdateROMCRC([string]$File) {
    
    $script = { Param([string]$Tool, [string]$File)
        & $Tool $File | Out-Null
    }
    Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.rn64crc, $File)
    StartJobLoop -Name "Script"

    WriteToConsole ("Updated CRC hash for ROM: " + $File)

}



#==============================================================================================================================================================================================
function CreateDebugPatches() {
    
    if ($Settings.Debug.CreateDecompressedBPS -eq $True -or $Settings.Debug.CreateCompressedBPS -eq $True) {
        $script = { Param([string]$Tool, [string]$Original, [string]$Compare, [string]$Out)
            & $Tool --create --bps $Original $Compare $Out | Out-Null
        }
    }

    if ($Settings.Debug.CreateDecompressedBPS -eq $True -and (TestFile $GetROM.cleanDecomp) -and (TestFile $GetROM.decomp) ) {
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.flips, $GetROM.cleanDecomp, $GetROM.decomp, $Files.decompBPS)
        StartJobLoop -Name "Script"
        WriteToConsole ("Created decompressed BPS patch: " + $Files.decompBPS)
    }

    if ($Settings.Debug.CreateCompressedBPS -eq $True -and (TestFile $GetROM.clean) -and (TestFile $GetROM.patched) ) {
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.flips, $GetROM.clean, $GetROM.patched, $Files.compBPS)
        StartJobLoop -Name "Script"
        WriteToConsole ("Created compressed BPS patch: " + $Files.compBPS)
    }

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
        WriteToConsole "ROM is already downgraded" -Error
        return $null
    }

    if ($PatchInfo.decompress) {
        if (!(TestFile $GetROM.decomp)) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
        $GetROM.run = $GetROM.decomp
    }
    else {
        Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.downgrade -Force
        $GetROM.run = $GetROM.downgrade
    }
    
    $romHash = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash
    if ($PatchInfo.decompress -and (IsSet $GameRev.hash_decomp)) { $revHash = $GameRev.hash_decomp } else { $revHash = $GameRev.hash }

    :outer while ($romHash -ne $revHash) {
        $downgradeFile = $null
        :inner for ($i=0; $i -lt $GameType.version.Count; $i++) {
            if ($PatchInfo.decompress -and (IsSet $GameType.version[$i].hash_decomp)) { $hash = $GameType.version[$i].hash_decomp } else { $hash = $GameType.version[$i].hash }
            if ($romHash -eq $hash -and (IsSet $GameType.version[$i].downgrade)) {
                $downgradeFile = "Downgrade\" + $GameType.version[$i].downgrade
                break inner
            }
        }

        if ($downgradeFile -ne $null) {
            if (!(ApplyPatch -File $GetROM.run -Patch $downgradeFile)) {
                WriteToConsole "Could not apply downgrade patch" -Error
                return $null
            }
            $romHash = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash
        }
        else { break outer }
    }

    if ($romHash -ne $revHash) {
        foreach ($item in $GameType.version) {
            if ($PatchInfo.decompress -and (IsSet $item.hash_decomp)) { $hash = $item.hash_decomp } else { $hash = $item.hash }
            if ($romHash -eq $hash -and (IsSet $item.upgrade)) {
                if (!(ApplyPatch -File $GetROM.run -Patch ("Downgrade\" + $item.upgrade))) {
                    WriteToConsole "Could not apply upgrade patch" -Error
                    return
                }
                $romHash = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash
                break
            }
        }
    }

    if ($romHash -eq $revHash) {
        if ($Settings.Debug.KeepDowngraded -eq $True) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.keepDowngrade -Force }
        if ($Settings.Core.UseCache -eq $True -and $TextEditor.Dialog -eq $null -and $SceneEditor.Dialog -eq $null) {
            CreatePath $Paths.Cache
            Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.cache -Force
        }
        $global:ROMHashSum = $CheckHashSum
        return $item
    }

    WriteToConsole "Unknown version for downgrading" -Error
    return $null
    
}



#==============================================================================================================================================================================================
function GetMaxSize([string]$Command) {

    if ($Settings.Debug.IgnoreChecksum -eq $True)   { return $True }
    if (StrLike -str $Command -val "Inject")        { return $True }

    $maxSize = ($GameConsole.max_size) + "MB"
    if ((Get-Item -LiteralPath $GetROM.run).length/$maxSize -gt 1) {
        UpdateStatusLabel ("The ROM is too large! The max allowed size is " + $maxSize) + "!" -Error
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
    
    if ($Settings.Debug.CreateCompressedBPS -eq $True -or $Settings.Debug.CreateDecompressedBPS -eq $True)   { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.clean -Force }
    if ($Settings.Debug.IgnoreChecksum -eq $True)                                                            { return $True }
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Apply Patch") )              { return $True }

    $item = GetROMVersion
    if ($item -eq $null) {
        UpdateStatusLabel "Failed! The ROM is an incorrect version or is broken." -Error
        WriteToConsole ("ROM hash is:  " + $ROMHashSum + ". The correct ROM should be: " + $CheckHashSum) -Error
        return $False
    }

    if ($item.supported -eq 0) {
        if ($item.region -like "*US*" -or $item.region -like "*NTSC-U*") {
            UpdateStatusLabel "North American / NTSC-U versions are not supported." -Error
            return $False
        }
        if ($item.region -like "*EU*" -or $item.region -like "*PAL*") {
            UpdateStatusLabel "Europese / PAL versions are not supported." -Error
            return $False
        }
        if ($item.region -like "*JPN*" -or $item.region -like "*NTSC-J*") {
            UpdateStatusLabel "Japanese / NTSC-J versions are not supported." -Error
            return $False
        }
        if ($item.region -like "*CHN*") {
            UpdateStatusLabel "Chinese / CHN versions are not supported." -Error
            return $False
        }
        if ($item.region -like "*TWN*") {
            UpdateStatusLabel "Taiwanese / TWN versions are not supported." -Error
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function PatchDecompressedROM() {
    
    if (!(StrStarts -Str $GamePatch.patch -Val "Decompressed\")) { return $True }
    
    # Set the status label.
    UpdateStatusLabel ("Patching " + $GameType.mode + " ROM with patch file...")
    
    # Apply the selected patch to the ROM, if it is provided
    if (!(ApplyPatch -File $GetROM.decomp -Patch $GamePatch.patch)) { return $False }
    
    return $True

}



#==============================================================================================================================================================================================
function PatchCompressedROM() {
    
    if (!(StrStarts -Str $GamePatch.patch -Val "Compressed\")) { return $True }
    
    # Set the status label.
    UpdateStatusLabel ("Patching " + $GameType.mode + " ROM with patch file...")

    # Apply the selected patch to the ROM, if it is provided
    if     ( $IsWiiVC)   { if (!(ApplyPatch -File $GetROM.patched -Patch $GamePatch.patch))                        { return $False } }
    elseif (!$IsWiiVC)   { if (!(ApplyPatch -File $GetROM.run     -Patch $GamePatch.patch -New $GetROM.patched))   { return $False } }

    return $True

}



#==============================================================================================================================================================================================
function PatchDMA() {

    if ( (IsSet $GamePatch.custom_offset) -and (IsSet $GamePatch.custom_value) ) {
        $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.run)
        ChangeBytes -Offset $GamePatch.custom_offset -Values $GamePatch.custom_value
        [System.IO.File]::WriteAllBytes($GetROM.run, $ByteArrayGame)
        $global:ByteArrayGame = $null
    }
    if ( (HasCommand "ByteDMAOptions") -and (UseOptions) ) {
        $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.run)
        ByteDMAOptions
        [System.IO.File]::WriteAllBytes($GetROM.run, $ByteArrayGame)
        $global:ByteArrayGame = $null
    }

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
        if ($IsWiiVC -and $GameType.downgrade -and !$PatchInfo.downgrade -and ($Patches.Options.Checked -or $Patches.Options.Visible -or (IsSet $GamePatch.preset) -or (IsSet $GamePatch.function) ) )   { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?"  -Error }
        elseif ($IsWiiVC -and $GameType.downgrade -and $Downgrade)                                                                                                                                       { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" -Error }
        else                                                                                                                                                                                             { UpdateStatusLabel "Failed! Patch file does not match source. ROM has left unchanged."                    -Error }
        return $False
    }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatch([string]$File=$GetROM.decomp, [string]$Patch, [string]$New, [switch]$FilesPath, [switch]$FullPath, [switch]$Silent) {
    
    # File Parameter Check
    if ( !(IsSet $File) -or !(IsSet $Patch) ) {
        WriteToConsole "No file or patch file is provided" -Error
        return $True
    }

    # File Exists
    if (!(TestFile $File)) {
        UpdateStatusLabel "Failed! Could not find file." -Error
        WriteToConsole ("Missing file: " + $File) -Error
        return $False
    }

    # Patch File
    if     ($FullPath)     {  }
    elseif ($FilesPath)    { $Patch = $Paths.Master   + "\" + $Patch }
    else                   { $Patch = $GameFiles.base + "\" + $Patch }

    if (TestFile ($Patch + ".bps"))      { $Patch + ".bps"    }
    if (TestFile ($Patch + ".ips"))      { $Patch + ".ips"    }
    if (TestFile ($Patch + ".ups"))      { $Patch + ".ups"    }
    if (TestFile ($Patch + ".xdelta"))   { $Patch + ".xdelta" }
    if (TestFile ($Patch + ".vcdiff"))   { $Patch + ".vcdiff" }
    if (TestFile ($Patch + ".ppf"))      { $Patch + ".ppf"    }

    if (TestFile $Patch) { $Patch = Get-Item -LiteralPath $Patch }
    else { # Patch File does not exist
        UpdateStatusLabel "Failed! Could not find patch file." -Error
        WriteToConsole ("Missing patch file: " + $Patch) -Error
        return $False
    }
    
    # Patching
    if ($Patch -like "*.bps*" -or $Patch -like "*.ips*") {
        if ($New.Length -gt 0) {
            $script = { Param([string]$Tool, [string]$Patch, [string]$File, [string]$New)
                & $Tool --ignore-checksum --apply $Patch $File $New | Out-Null
            }
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.flips, $Patch, $File, $New)
        }
        else {
            $script = { Param([string]$Tool, [string]$Patch, [string]$File)
                & $Tool --ignore-checksum --apply $Patch $File | Out-Null
            }
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.flips, $Patch, $File)
        }
        StartJobLoop -Name "Script"
    }
    elseif ($Patch -like "*.ups*") {
        $script = { Param([string]$Tool, [string]$File, [string]$Patch, [String]$Out)
            & $Tool apply -b $File -p $Patch -o $Out | Out-Null
        }
        if ($New.Length -gt 0)   { Start-Job -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.ups, $File, $Patch, $New) }
        else                     { Start-Job -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.ups, $File, $Patch, $File) }
        StartJobLoop -Name "Script"
    }
    elseif ($Patch -like "*.xdelta*" -or $Patch -like "*.vcdiff*") {
        if     ($Patch -like "*.xdelta*")   { $Tool = $Files.tool.xdelta  }
        elseif ($Patch -like "*.vcdiff*")   { $Tool = $Files.tool.xdelta3 }

        $script = { Param([string]$Tool, [string]$File, [string]$Patch, [string]$New)
            & $Tool -d -s $File $Patch $New | Out-Null
        }
        if ($New.Length -gt 0) {
            RemoveFile $New
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Tool, $File, $Patch, $New)
            StartJobLoop -Name "Script"
        }
        else {
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Tool, $File, $Patch, ($File + ".ext"))
            StartJobLoop -Name "Script"
            Move-Item -LiteralPath ($File + ".ext") -Destination $File -Force
        }
    }
    elseif ($Patch -like "*.ppf*") {
        $script = { Param([string]$Tool, [string]$File, [string]$Patch)
            & $Tool a $File $Patch | Out-Null
        }
        if ($New.Length -gt 0) {
            Copy-Item -LiteralPath $File -Destination $New -Force
            Start-Job -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.applyPPF3, $New, $Patch)
        }
        else { Start-Job -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.applyPPF3, $File, $Patch) }
        StartJobLoop -Name "Script"
    }
    else { return $False }

    if (!$Silent) {
        if (IsSet $New)   { WriteToConsole ("Applied patch: " + $Patch + " from " + $File + " to " + $New) }
        else              { WriteToConsole ("Applied patch: " + $Patch + " to " + $File)                   }
    }
    return $True

}



#==============================================================================================================================================================================================
function DecompressROM() {
    
    if (!$PatchInfo.decompress) { return $True }
    
    # ROM is already decompressed, but is still recognized as decompressed for patching
    if (((Get-Item -LiteralPath $GetROM.run).length)/1MB -ge $GameConsole.max_size) {
        Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force
        RemoveFile $Files.dmaTable
        if     ( (IsSet $GamePatch.redux.dmaTable) -and ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) )   { Add-Content $Files.dmaTable $GamePatch.redux.dmaTable }
        elseif (IsSet $GamePatch.dmaTable)                                                                               { Add-Content $Files.dmaTable $GamePatch.dmaTable       }
        elseif (IsSet $LanguagePatch.dmaTable)                                                                           { Add-Content $Files.dmaTable $LanguagePatch.dmaTable   }
        else                                                                                                             { Add-Content $Files.dmaTable $GameRev.dmaTable         }
        if ($IsWiiVC) { RemoveFile $GetROM.run }
        return $True
    }

    if ($GameType.decompress -eq 1) {
        UpdateStatusLabel ("Decompressing " + $GameType.mode + " ROM...")

        # Get the correct DMA table for the ROM
        if     ( (IsSet $GamePatch.redux.dmaTable) -and ( (IsChecked $Patches.Redux) -or (IsSet $GamePatch.preset) ) )   { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GamePatch.redux.dmaTable }
        elseif (IsSet $GamePatch.dmaTable)                                                                               { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GamePatch.dmaTable       }
        elseif (IsSet $LanguagePatch.dmaTable)                                                                           { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $LanguagePatch.dmaTable   }
        elseif ( (IsSet $GameType.dmaTable) -and $ROMHashSum -ne $CheckHashSum -and $PatchInfo.downgrade)                { RemoveFile $Files.dmaTable; Add-Content $Files.dmaTable $GameType.dmaTable        }
        else {
            $script = { Param([string]$Tool, [string]$File, [String]$Path)
                Push-Location $Path
                & $Tool $File | Out-Null
            }
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.TabExt, $GetROM.run, $Paths.Temp)
            StartJobLoop -Name "Script"

        }

        # Reuse cache
        if ($Settings.Core.UseCache -eq $True -and $TextEditor.Dialog -eq $null -and $SceneEditor.Dialog -eq $null) {
            if (TestFile $GetROM.cache) {
                if (IsSet $GameRev.hash_decomp) { $hash = $GameRev.hash_decomp } else { $hash = $GameRev.hash } 
                if ($hash -eq (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.cache).Hash) {
                    WriteToConsole "Reused ROM from cache"
                    Copy-Item -LiteralPath $GetROM.cache -Destination $GetROM.decomp -Force
                    if ($Settings.Debug.CreateDecompressedBPS -eq $True -or (IsSet $ActorEditor) ) { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force }
                    if ($IsWiiVC) { RemoveFile $GetROM.run }
                    return $True
                }
            }
        
        }

        # Decompress
        WriteToConsole ("Generated DMA Table from: " + $GetROM.run)

        $script = { Param([string]$Tool, [string]$File, [string]$Out, [String]$Path)
            Push-Location $Path
            & $Tool $File $Out | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.ndec, $GetROM.run, $GetROM.decomp, $Paths.Temp)
        StartJobLoop -Name "Script"

        WriteToConsole ("Decompressed ROM: " + $GetROM.decomp)

        if ($Settings.Core.UseCache -eq $True -and $TextEditor.Dialog -eq $null -and $SceneEditor.Dialog -eq $null) {
            CreatePath $Paths.Cache
            Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cache -Force
        }
        if ($Settings.Debug.CreateDecompressedBPS -eq $True -or (IsSet $ActorEditor) ) { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force }
    }
    elseif ($GameType.decompress -eq 2) {
        UpdateStatusLabel ("Extending " + $GameType.mode + " ROM...")

        if (!(IsSet -Elem $GamePatch.extend -Min 18 -Max 64)) {
            UpdateStatusLabel 'Failed. Could not extend SM64 ROM. Make sure the "extend" value is between 18 and 64.' -Error
            return $False
        }

        $script = { Param([string]$Tool, [string]$File, [string]$Extend, [string]$Out)
            & $Tool $File -s $Extend $Out | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.sm64extend, $GetROM.run, $GamePatch.extend, $GetROM.decomp)
        StartJobLoop -Name "Script"
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
        
        $reader = New-Object System.IO.StreamReader($Files.dmaTable)
        WriteToConsole ("Used DMA Table: " + $reader.ReadToEnd())
        $reader.Close()
        $reader.Dispose()
        
        $script = { Param([string]$Tool, [string]$File, [string]$Out, [string]$Path)
            Push-Location -LiteralPath $Path
            & $Tool $File $Out | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.Compress, $GetROM.decomp, $GetROM.patched, $Paths.Temp)
        StartJobLoop -Name "Script"

        WriteToConsole ("Compressed ROM: " + $GetROM.patched)

        if (IsSet $GamePatch.finalize) {
            if (TestFile (CheckPatchExtension ($GameFiles.downgrade + "\" + $GamePatch.finalize) ) ) { ApplyPatch -File $GetROM.patched -Patch (CheckPatchExtension ($GameFiles.downgrade + "\" + $GamePatch.finalize)) -FullPath }
        }

        if (IsSet $GamePatch.size) {
            if (($GamePatch.size -as [int]) -ne $null) {
                if ($GamePatch.size -ge 1 -and $GamePatch.size -le $GameConsole.max_size) {
                    if (((Get-Item -LiteralPath $GetROM.patched).length)/1MB -gt $GamePatch.size) {
                        $file = [System.IO.File]::ReadAllBytes($GetROM.patched)
                        $new  = $file[0..($GamePatch.size * 1024 * 1024)]
                        [System.IO.File]::WriteAllBytes($GetROM.patched, $new)
                        WriteToConsole ("Reduced ROM size to: " + $GamePatch.size + "MB")
                    }
                }
            }
        }
    }
    else {
        Copy-Item   -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force
        Remove-Item -LiteralPath $GetROM.decomp
    }

    $GetROM.run = $GetROM.patched
}



#==============================================================================================================================================================================================
function PatchRedux() {
    
    # BPS PATCHING REDUX #
    if (!$Patches.Redux.Checked -or $GamePatch.redux -eq $null -or (DoAssertSceneFiles) -or !(TestFile (CheckPatchExtension ($GameFiles.base + "\redux")))) { return }

    if (!(TestFile $GetROM.decomp)) { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.decomp -Force }
    $GetROM.run = $GetROM.decomp
    UpdateStatusLabel ("Patching " + $GameType.mode + " REDUX...")

    # Redux patch
    ApplyPatch -File $GetROM.decomp -Patch (CheckPatchExtension ($GameFiles.base + "\redux")) -FullPath

    # Revert Redux options not selected
    if ( (HasCommand "RevertReduxOptions") -and ($Patches.Options.Checked -or (IsSet $GamePatch.function) ) ) {
        $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)
        UpdateStatusLabel ("Reverting " + $GameType.mode + " Redux content...")
        RevertReduxOptions
        [System.IO.File]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)
        $ByteArrayGame = $null
    }

}



#==============================================================================================================================================================================================
function HackROMGameTitle($Title, $GameID, $Region) {

    if ($Title -eq $null -and $GameID -eq $null -and $Region -eq $null)                          { return }
    if ($Settings.Debug.NoTitleChange -eq $True -and $Settings.Debug.NoGameIDChange -eq $True)   { return }
    if (!(TestFile $GetROM.patched))                                                             { Copy-Item -LiteralPath $GetROM.run -Destination $GetROM.patched -Force }

    UpdateStatusLabel "Hacking in Custom Title and GameID..."

    # Hi-ROM check and load in Game Array
    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.patched)
    if ($GameConsole.mode -eq "SNES" -and (IsSet -Elem $GameConsole.rom_title_offset_hi) ) { $hiROM = (IsHiROM -Offset (GetDecimal -Hex $GameConsole.rom_title_offset_hi) -ROM $ByteArray) }

    # Internal ROM Title
    if ($Settings.Debug.NoTitleChange -ne $True) {
        if ($Title -ne $null -and (IsSet $GameConsole.rom_title_offset) -and (IsSet -Elem $GameConsole.rom_title_length -Min 1) -and ($GameConsole.rom_title -gt 0) ) {
            if ($hiROM) { $offset = $GameConsole.rom_title_offset_hi } else { $offset = $GameConsole.rom_title_offset }
            $emptyTitle = foreach ($i in 1..$GameConsole.rom_title_length) { 32 }
            if ($GameConsole.rom_title_uppercase -gt 0) { $Title = $Title.ToUpper() }
            ChangeBytes -Offset $Offset -Values $emptyTitle
            ChangeBytes -Offset $offset -Values ($Title.ToCharArray() | % { [uint32][char]$_ }) -IsDec

            if ($GameConsole.mode -eq "SNES" -and (Get-Item -LiteralPath $GetROM.patched).length/4MB -gt 1) {
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $offset) + 0x400000) ) -Values $emptyTitle
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $offset) + 0x400000) ) -Values ($Title.ToCharArray() | % { [uint32][char]$_ }) -IsDec
            }
        }
    }

    # GameID
    if ($Settings.Debug.NoGameIDChange -ne $True) {
        if ($GameID -ne $null -and (IsSet -Elem $GameConsole.rom_gameID_offset) -and ($GameConsole.rom_gameID -eq 1)) { ChangeBytes -Offset $GameConsole.rom_gameID_offset -Values ($GameID.ToCharArray() | % { [uint32][char]$_ }) -IsDec }
        elseif ($Region -ne $null -and $GameConsole.rom_gameID -eq 2) {
            if ($hiROM) { $offset = $GameConsole.rom_title_offset_hi } else { $offset = $GameConsole.rom_title_offset }
            $offset = ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "19") ) )
            if ($ByteArrayGame[(GetDecimal $offset)] -ne $Region) {
                $ByteArrayGame[(GetDecimal $offset)] = $Region
                if ((Get-Item -LiteralPath $GetROM.patched).length/4MB -gt 1) { $ByteArrayGame[(GetDecimal $offset) + 0x400000] = $Region }
                WriteToConsole ("Changed region code: " + (Get8Bit $Region))
                RemoveRegionProtection
            }
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
    
    if ( ($Patches.Redux.Checked -or (IsSet $GamePatch.preset) ) -and !(IsWidescreen -Patched)) { return $True }
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
Export-ModuleMember -Function ApplyText

Export-ModuleMember -Function SetROMParameters
Export-ModuleMember -Function Unpack
Export-ModuleMember -Function ConvertROM
Export-ModuleMember -Function CompareHashSums
Export-ModuleMember -Function DecompressROM
Export-ModuleMember -Function DowngradeROM