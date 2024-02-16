function CreateVCRemapPanel() {
    
    # VC Remap Settings
    $panel = CreatePanel -Width $RightPanel.RemapControls.Width -Height $RightPanel.RemapControls.Height -Name "RemapVCControlsPanel" -AddTo $RightPanel.RemapControls
    CreateReduxGroup -All -Tag "Controls" -Y (DPISize 0) -Text "Virtual Console Remap Presets" -AddTo $panel
    $items = @()
    if (IsSet $Files.json.controls) { foreach ($item in $Files.json.controls.presets) { $items += $item.title } }
    CreateReduxComboBox -All -Name "Preset" -Text "Preset" -Length 200 -Items $items -PostItems @("Custom") -Info "Select a preset for the VC Remap controls"

    CreateReduxGroup -All -Tag "Controls" -Y ($Last.Group.bottom + (DPISize 10) ) -Height 10 -Text "Virtual Console Remap Settings" -AddTo $panel
    if     ($GameConsole.mode -eq "N64")    { $items = @("Disabled", "A", "B", "Start", "L", "R", "Z", "C-Up", "C-Right", "C-Down", "C-Left", "D-Pad Up", "D-Pad Right", "D-Pad Down", "D-Pad Left") }
    elseif ($GameConsole.mode -eq "SNES")   { $items = @("Disabled", "A", "B", "X", "Y", "Start", "Select", "L", "R") }
    elseif ($GameConsole.mode -eq "NES")    { $items = @("Disabled", "A", "B", "Start", "Select") }

    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "A"         -Column 1    -Row 1 -Text "A"           -Info "Remap the A button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "B"         -Column 2.3  -Row 1 -Text "B"           -Info "Remap the B button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "Start"     -Column 3.6  -Row 1 -Text "Start"       -Info "Remap the Start button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "L"         -Column 1    -Row 2 -Text "L"           -Info "Remap the L button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "R"         -Column 2.3  -Row 2 -Text "R"           -Info "Remap the R button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "Z"         -Column 3.6  -Row 2 -Text "Z / ZL / ZR" -Info "Remap the Z button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "X"         -Column 1    -Row 3 -Text "X"           -Info "Remap the R button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-40) -Length 70 -Name "Y"         -Column 2.3  -Row 3 -Text "Y"           -Info "Remap the R button"

    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "CUp"       -Column 1.625 -Row 5                    -Info "Remap the C Up button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "CRight"    -Column 2.25  -Row 7.5                  -Info "Remap the C Right button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "CDown"     -Column 1.625 -Row 10                   -Info "Remap the C Down button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "CLeft"     -Column 1     -Row 7.5                  -Info "Remap the C Left button"

    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "DPadUp"    -Column 3.625 -Row 5                    -Info "Remap the D-Pad Up button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "DPadRight" -Column 4.25  -Row 7.5                  -Info "Remap the D-Pad Right button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "DPadDown"  -Column 3.625 -Row 10                   -Info "Remap the D-Pad Down button"
    CreateReduxComboBox -All -Items $items -NoDefault -Shift (-60) -Length 40 -Name "DPadLeft"  -Column 3     -Row 7.5                  -Info "Remap the D-Pad Left button"

    # Images #
    $PictureBox = CreateImageBox -x 115 -y 155 -w 128 -h 128 -All
    SetBitmap -Path ($Paths.Main + "\C.png") -Box $PictureBox

    $PictureBox = CreateImageBox -x 485 -y 160 -w 128 -h 128 -All
    SetBitmap -Path ($Paths.Main + "\D-Pad.png") -Box $PictureBox

    $Redux.Controls.Preset.Add_SelectedIndexChanged({ SetPreset -ComboBox $Redux.Controls.Preset -Text $Redux.Controls.Preset.Text })
    SetPreset -ComboBox $Redux.Controls.Preset -Text $Redux.Controls.Preset.Text

    foreach ($item in $Last.Group.controls) {
        if ($item.GetType() -eq [System.Windows.Forms.ComboBox]) {
            $item.Add_SelectedIndexChanged( {
                if (!$PauseRemapping) { $Redux.Controls.Preset.SelectedIndex = $Redux.Controls.Preset.items.count - 1 }
            } )
        }
    }

}



#==============================================================================================================================================================================================
function CheckVCGameID() {
    
    if ($GameType.checksum -eq 0 -or $Settings.Debug.IgnoreChecksum -eq $True) { return $True } # Return if freely patching, injecting or extracting

    UpdateStatusLabel "Checking GameID in .tmd..."     # Set the status label
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.tmd) # Get the ".tmd" file as a byte array# Get the ".tmd" file as a byte array
    $CompareArray = ($GameType.vc_gameID.ToCharArray() | % { [uint32][char]$_ })
    $CompareAgainst = $ByteArray[400..(403)]

    for ($i=0; $i-le 4; $i++) {                          # Check each value of the array
        if ($CompareArray[$i] -ne $CompareAgainst[$i]) { # The current values do not match, so this is not a vanilla entry
            if ($CompareAgainst[3] -eq 80)   { UpdateStatusLabel ("Failed! PAL VC WAD file for " + $GameType.mode + " is not supported.") } # 80 = P
            if ($CompareAgainst[3] -eq 74)   { UpdateStatusLabel ("Failed! JPN VC WAD file for " + $GameType.mode + " is not supported.") } # 74 = J
            else                             { UpdateStatusLabel ("Failed! This is not an vanilla " + $GameType.mode + " US VC WAD file.") }
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function PatchVCROM([string]$Command) {

    # Set the status label.
    UpdateStatusLabel ("Patching " + $GameType.mode + " VC ROM...")
    
    # Stuck, since ROM does not exist
    if (!(TestFile $GetROM.run)) {
        if     (StrLike -str $Command -val "Extract")   { UpdateStatusLabel ("Could not extract "    + $GameType.mode + " ROM.") }
        elseif (StrLike -str $Command -val "Inject")    { UpdateStatusLabel ("Could not inject "     + $GameType.mode + " ROM.") }
        else                                            { UpdateStatusLabel ("Could not decompress " + $GameType.mode + " ROM.") }
        return $False
    }

    # Determine if ROM is ROMC and what kind of ROMC
    $romFile  = [System.IO.File]::ReadAllBytes($GetROM.run)
    $romData  = $romFile[0..3]
    $romCheck = @(128, 55, 18, 64)
    $global:romcType = 0;
    if ($GameConsole.has_romc -eq 1) {
        foreach ($i in 0..($romData.length-1)) {
            if ($romData[$i] -ne $romCheck[$i]) { $global:romcType = $romData[3] }
        }
    }

    # Extract ROM if required
    if (StrLike -str $Command -val "Extract") {
        if ($romcType -eq 1 -or $romcType -eq 2) {
            if     ($romcType -eq 1)   { $tool = $Files.tool.romc   }
            elseif ($romcType -eq 2)   { $tool = $Files.tool.romchu }
            $script = { Param([string]$Tool, [string]$File, [string]$Compressed)
                & $Tool $File $Compressed | Out-Null
            }
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($tool, $GetROM.run, $GetROM.romc)
            StartJobLoop -Name "Script"
        }

        if ($romcType -ge 1)   { Move-Item -LiteralPath $GetROM.romc -Destination $WADFile.Extracted -Force }
        else                   { Move-Item -LiteralPath $GetROM.run  -Destination $WADFile.Extracted -Force }

        UpdateStatusLabel ("Successfully extracted " + $GameType.mode + " ROM with " + (Get-Item -LiteralPath $Files.tool.romc).BaseName + ".")
        return $False
    }

    # Replace ROM if needed
    elseif (StrLike -str $Command -val "Inject") {
        if (TestFile $InjectPath) { Copy-Item -LiteralPath $InjectPath -Destination $GetROM.run -Force }
        else {
            UpdateStatusLabel ("Could not inject " + $GameType.mode + " ROM. Did you move or rename the ROM file?")
            return $False
        }
    }

    # Decompress romc if needed
    elseif ($PatchInfo.run -and $romcType -ge 1) {
        RemoveFile $GetROM.romc
        if ($romcType -eq 1 -or $romcType -eq 2) {
            if     ($romcType -eq 1)   { $tool = $Files.tool.romc   }
            elseif ($romcType -eq 2)   { $tool = $Files.tool.romchu }
            $script = { Param([string]$Tool, [string]$File, [string]$Compressed)
                & $Tool $File $Compressed | Out-Null
            }
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($tool, $GetROM.run, $GetROM.romc)
            StartJobLoop -Name "Script"
        }
        Move-Item -LiteralPath $GetROM.romc -Destination $GetROM.run -Force
        UpdateStatusLabel ("Successfully decompressed " + $GameType.mode + " ROMC with " + (Get-Item -LiteralPath $Files.tool.romc).BaseName + ".")
    }

    # $ByteArray = [IO.File]::ReadAllBytes($GetROM.run)                       # Get the file as a byte array so the size can be analyzed
    # $NewByteArray = New-Object Byte[] $ByteArray.Length                     # Create an empty byte array that matches the size of the ROM byte array
    # for ($i=0; $i-lt $ByteArray.Length; $i++) { $NewByteArray[$i] = 255 }   # Fill the entire array with junk data as the patched ROM is slightly smaller

    return $True

}



#==============================================================================================================================================================================================
function PatchVCEmulator([string]$Command) {
    
    if (StrLike -Str $Command -Val "Extract") { return }

    # Set the status label.
    UpdateStatusLabel ("Patching " + $GameType.mode + " VC Emulator...")

    # Applying LZSS decompression
    $array = [IO.File]::ReadAllBytes($WADFile.AppFile01)
    if ($array[0] -eq (GetDecimal "10") -and (Get-Item $WADFile.AppFile01).length/1MB -lt 1) {
        if ( (StrLike -Str $Command -Val "Patch Boot DOL") -or (IsChecked $VC.ExpandMemory) -or (IsChecked $VC.RemoveFilter) -or (IsChecked $VC.RemapControls) ) {
            $script = { Param([string]$Tool, [string]$File)
                & $Tool -d $File | Out-Null
            }
            Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.lzss, $WADFile.AppFile01)
            StartJobLoop -Name "Script"

            $DecompressedApp = $True
            WriteToConsole ("Decompressed LZSS File: " + $WADFile.AppFile01)
        }
    }

    # Patching Boot DOL
    if ( (StrLike -Str $Command -Val "Patch Boot DOL") -and (IsSet $GamePatch.patch) ) {
        $Patch = "\AppFile01\" + [System.IO.Path]::GetFileNameWithoutExtension($GamePatch.patch)
        $Patch = CheckPatchExtension -File ($GameFiles.base + $Patch)
        ApplyPatch -File $WADFile.AppFile01 -Patch $Patch -FullPath
    }

    # Games
    if ($GameType.mode -eq "Ocarina of Time" -and $VC.ExpandMemory.Checked) {
        ChangeBytes -File $WadFile.AppFile01 -Offset "5BF44" -Values "3C 80 72 00"
        ChangeBytes -File $WadFile.AppFile01 -Offset "5BFD7" -Values "00"
    }
   <# elseif ($GameType.mode -eq "Majora's Mask" -and $VC.ExpandMemory.Checked) {
        ChangeBytes -File $WadFile.AppFile01 -Offset "10B58" -Values "3C 80 00 C0"
        ChangeBytes -File $WadFile.AppFile01 -Offset "4BD20" -Values "67 E4 70 00"
        ChangeBytes -File $WadFile.AppFile01 -Offset "4BC80" -Values "3C A0 01 00"
    } #>

    # Controls
    if ($VC.RemapControls.Checked -and $VC.RemapControls.Visible -and $Redux.Controls.Preset.SelectedIndex -ne 0) {
        if ( (StrLike -Str $Command -Val "Patch Boot DOL") -and (IsSet $GamePatch.patch) )   { $controls = $Files.json.controls.$("offsets_" + [System.IO.Path]::GetFileNameWithoutExtension($GamePatch.patch)); }
        else                                                                                 { $controls = $Files.json.controls.offsets; }

        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.a         -Values (GetControlsValue $Redux.Controls.A)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.b         -Values (GetControlsValue $Redux.Controls.B)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.x         -Values (GetControlsValue $Redux.Controls.X)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.y         -Values (GetControlsValue $Redux.Controls.Y)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.l         -Values (GetControlsValue $Redux.Controls.L)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.r         -Values (GetControlsValue $Redux.Controls.R)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.z         -Values (GetControlsValue $Redux.Controls.Z)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.start     -Values (GetControlsValue $Redux.Controls.Start)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.dpadup    -Values (GetControlsValue $Redux.Controls.DPadUp)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.dpaddown  -Values (GetControlsValue $Redux.Controls.DPadDown)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.dpadleft  -Values (GetControlsValue $Redux.Controls.DPadLeft)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.dpadright -Values (GetControlsValue $Redux.Controls.DPadRight)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.cup       -Values (GetControlsValue $Redux.Controls.CUp)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.cdown     -Values (GetControlsValue $Redux.Controls.CDown)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.cleft     -Values (GetControlsValue $Redux.Controls.CLeft)
        ChangeBytes -File $WadFile.AppFile01 -Offset $controls.cright    -Values (GetControlsValue $Redux.Controls.CRight)
        WriteToConsole "Remapped Controls"
    }

    # Expand Memory
    if ($VC.ExpandMemory.Checked -and $VC.ExpandMemory.Visible -and $GameType.mode -ne "Majora's Mask") {
        $offset = SearchBytes -File $WadFile.AppFile01 -Start "2000" -End "9999" -Values "41 82 00 08 3C 80 00 80"
        if ($offset -gt 0) {
            ChangeBytes -File $WadFile.AppFile01 -Offset $offset -Values "60 00 00 00"
            WriteToConsole "Expanded Game Memory"
        }
        else {
            UpdateStatusLabel "Failed! Game Memory could not be expanded."
            return $False
        }
        # SM64: 5AD4 / MK64: 5C28 / SF: 2EF4 / PM: 2EE4 / OoT: 2EB0 / MM: ?? / Smash: 3094 / Sin: 3028
    }

    if ($VC.RemoveFilter.Checked -and $VC.RemapControls.Visible) {
        $offset = SearchBytes -File $WadFile.AppFile01 -Start "40000" -End "60000" -Values "38 21 00 xx 4E 80 00 20 94 21 FF E0 7C 08 02 A6 3C 80 80 xx 90 01 00 24"
        if ($offset -gt 0) {
            ChangeBytes -File $WadFile.AppFile01 -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "08") ) )  -Values "4E 80 00 20"
            WriteToConsole "Removed Dark Filter Overlay"
        }
        else {
            WriteToConsole "Failed! Dark Filter Overlay could not be removed."
            return $False
        }
        # SM64: 46210 / MK64: 46DB8 / SF: 451C8 / PM: 44A54 / OoT: 455FC / MM: 4A248 / Smash: 46DC4 / Sin: 53124 or 45B94
    }

    # Applying LZSS compression
    if ($DecompressedApp) {
        $script = { Param([string]$Tool, [string]$File)
            & $Tool -evn $File | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.lzss, $WADFile.AppFile01)
        StartJobLoop -Name "Script"

        WriteToConsole ("Compressed LZSS File: " + $WADFile.AppFile01)
    }

    return $True

}



#==============================================================================================================================================================================================
function GetControlsValue([object]$Control) {
    
    $Text = $Control.Text.replace(" (default)", "")
    
    if     ($Text -eq "A")             { return "80 00" }
    elseif ($Text -eq "B")             { return "40 00" }
    elseif ($Text -eq "Z")             { return "20 00" }
    elseif ($Text -eq "Start")         { return "10 00" }

    elseif ($Text -eq "L")             { return "00 20" }
    elseif ($Text -eq "R")             { return "00 10" }

    elseif ($Text -eq "D-Pad Up")      { return "08 00" }
    elseif ($Text -eq "D-Pad Down")    { return "04 00" }
    elseif ($Text -eq "D-Pad Left")    { return "02 00" }
    elseif ($Text -eq "D-Pad Right")   { return "01 00" }

    elseif ($Text -eq "C-Up")          { return "00 08" }
    elseif ($Text -eq "C-Down")        { return "00 04" }
    elseif ($Text -eq "C-Left")        { return "00 02" }
    elseif ($Text -eq "C-Right")       { return "00 01" }

    return "00 00"

}



#==============================================================================================================================================================================================
function CompressROMC() {
    
    if ($romcType -ne 1) { return }
    UpdateStatusLabel ("Compressing " + $GameType.mode + " VC ROM...")
    RemoveFile $GetROM.romc

    $script = { Param([string]$Tool, [string]$File, $Compressed)
        & $Tool e $File $Compressed | Out-Null
    }
    Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.romc, $GetROM.run, $GetROM.romc)
    StartJobLoop -Name "Script"

    Move-Item -LiteralPath $GetROM.romc -Destination $GetROM.run -Force

}



#==============================================================================================================================================================================================
function ExtendROM() {
    
    if ($romcType -ne 2) { return }
    $Bytes = @(08, 00, 00, 00)
    $ByteArray = [IO.File]::ReadAllBytes($GetROM.run)
    [io.file]::WriteAllBytes($GetROM.run, $Bytes + $ByteArray)

}



#==============================================================================================================================================================================================
function HackOpeningBNRTitle($Title) {
    
    if ($Settings.Debug.NoChannelTitleChange -eq $True)   { return }
    if ($Title -eq $null)                                 { return }

    # Set the status label.
    UpdateStatusLabel "Hacking in Opening.bnr custom title..."

    # Get the "00000000.app" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile00)

    # Initially assume the two chunks of data are identical.
    $Identical = $True
    $Start = 0
    $CompareArray = $ByteArray[241..(241 + $VCTitleLength)]
    WriteToConsole $CompareArray

    # Scan only the contents of the IMET header within the file.
    for ($i=128; $i-lt 1584; $i++) {
        $CompareAgainst = $ByteArray[$i..($i + $VCTitleLength)]

        $Matches = $True
        for ($j=0; $j -lt $CompareAgainst.Length; $j++) {
            if ($CompareAgainst[$j] -notcontains $CompareArray[$j]) { $Matches = $False }
        }

        if ($Matches -eq $True) {
            for ($j=0; $j-lt $VCTitleLength*2; $j++)   { $ByteArray[$i + $j] = 0 }
            for ($j=0; $j-lt $Title.Length;    $j++)   { $ByteArray[$i + ($j*2)] = [uint32][char]$Title.Substring($j, 1) }
            $i += $VCTitleLength
        }        
    }

    # Overwrite the patch file with the extended file.
    [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)

}



#==============================================================================================================================================================================================
function SetWADParameters([string]$Path, [string]$FolderName, [string]$PatchedFileName) {
    
    # Create a hash table
    $WADFile = @{}

    # Get the WAD as an item object
    $WADItem = Get-Item -LiteralPath $Path
    
    # Store some stuff about the WAD to reference
    $WADFile.Name         = $WADItem.BaseName
    $WADFile.Folder       = $Paths.Temp + "\" + $FolderName
    $WADFile.FolderName   = $FolderName

    $WADFile.AppFile00    = $WADFile.Folder + "\00000000.app"
    $WADFile.AppPath00    = $WADFile.Folder + "\00000000"
    $WADFile.AppFile01    = $WADFile.Folder + "\00000001.app"
    $WADFile.AppPath01    = $WADFile.Folder + "\00000001"
    $WADFile.AppFile05    = $WADFile.Folder + "\00000005.app"
    $WADFile.AppPath05    = $WADFile.Folder + "\00000005"

    $WADFile.cert         = $WADFile.Folder + "\" + $FolderName + ".cert"
    $WADFile.tik          = $WADFile.Folder + "\" + $FolderName + ".tik"
    $WADFile.tmd          = $WADFile.Folder + "\" + $FolderName + ".tmd"
    $WADFile.trailer      = $WADFile.Folder + "\" + $FolderName + ".trailer"
    
    $WADFile.Extension = $GameConsole.extension

    $WADFile.Patched      = $WADItem.DirectoryName + "\" + $WADFile.Name + $PatchedFileName + ".wad"
    $WADFile.Extracted    = $WADItem.DirectoryName + "\" + $WADFile.Name + "_extracted"     + $WADFile.Extension
    $WADFile.Convert      = $WADItem.DirectoryName + "\" + $WADFile.Name + "_converted"     + $WADFile.Extension
    $WADFile.Downgrade    = $WADItem.DirectoryName + "\" + $WADFile.Name + "_downgraded"    + $WADFile.Extension
    $WADFile.Decomp       = $WADItem.DirectoryName + "\" + $WADFile.Name + "_decompressed"  + $WADFile.Extension

    $WADFile.Offset = $WadFile.Length = "0"

    # Set it to a global value
    return $WADFile

}



#==============================================================================================================================================================================================
function ExtractWADFile([string]$PatchedFileName) {
    
    # Set the status label
    UpdateStatusLabel "Extracting WAD file..."

    # Check if an extracted folder existed previously
    foreach ($item in Get-ChildItem -LiteralPath $Paths.Temp -Force) {
        if ($item.PSIsContainer) { RemovePath $item }
    }
    
    [IO.File]::WriteAllBytes($Files.ckey, @(235, 228, 42, 34, 94, 133, 147, 228, 72, 217, 197, 69, 115, 129, 170, 247))
    
    # Run the program to extract the wad file
    $ErrorActionPreference = $WarningPreference = 'SilentlyContinue'
    try  {
        $script = { Param([string]$Tool, [string]$Path, [string]$Temp)
            Push-Location $Temp
            & $Tool $Path | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.wadunpacker, $GamePath, $Paths.Temp)
        StartJobLoop -Name "Script"
    }
    catch { WriteToConsole "Could not unpack Wii VC WAD" -Error }
    $ErrorActionPreference = $WarningPreference = 'Continue'

    # Find the extracted folder by looping through all files in the folder.
    $FolderExists = $False
    foreach ($item in Get-ChildItem -LiteralPath $Paths.Temp -Force) {
        # There will only be one folder, the one we want.
        if ($item.PSIsContainer) {
            $FolderExists = $True
            # Remember the path to this folder
            $global:WADFile = SetWADParameters -Path $GamePath -FolderName $item.Name -PatchedFileName $PatchedFileName
        }
    }

    if (!$FolderExists) {
        UpdateStatusLabel "Failed! Could not extract Wii VC WAD. Try using a different filename."
        return $False
    }
    return $True

}



#==============================================================================================================================================================================================
function RepackWADFile($GameID) {
    
    # Set the status label.
    UpdateStatusLabel "Repacking patched WAD file..."
    
    # Loop through all files in the extracted WAD folder.
    foreach ($item in Get-ChildItem -LiteralPath $WadFile.Folder -Force) {
        # Move the file to the same folder as the unpacker tool.
        RemoveFile ($Paths.Temp + "\" + $item.Name)
        Move-Item -LiteralPath $item.FullName -Destination $Paths.Temp
        
        # Create an entry for the database.
        $ListEntry = $RepackPath + '\' + $item.Name
        
        # Some files need to be fed into the tool so keep track of them.
        switch ($item.Extension) {
            '.tik'  { $tik  = $Paths.Temp + "\" + $item.Name }
            '.tmd'  { $tmd  = $Paths.Temp + "\" + $item.Name }
            '.cert' { $cert = $Paths.Temp + "\" + $item.Name }
        }
    }

    # Repack the WAD using the new files
    if ($GameID -ne $null -and $Settings.Debug.NoChannelIDChange -ne $True) {
        $script = { Param([string]$Tool, [string]$Tik, [string]$Tmd, [string]$Cert, [string]$Out, [string]$ID, [string]$Path)
            Push-Location -LiteralPath $Path
            & $Tool $Tik $Tmd $Cert $Out '-sign' '-i' $ID | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.wadpacker, $tik, $tmd, $cert, $WadFile.Patched, $GameID, $Paths.Temp)
        StartJobLoop -Name "Script"
    }
    else {
        $script = { Param([string]$Tool, [string]$Tik, [string]$Tmd, [string]$Cert, [string]$Out, [string]$Path)
            Push-Location -LiteralPath $Path
            & $Tool $Tik $Tmd $Cert $Out '-sign' | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.wadpacker, $tik, $tmd, $cert, $WadFile.Patched, $Paths.Temp)
        StartJobLoop -Name "Script"
    }
    
    # If the patched file was created or could not be created.
    if (TestFile $WadFile.Patched)   { UpdateStatusLabel "Complete! Patched Wii VC WAD was successfully patched." } # Set the status label.
    else                             { UpdateStatusLabel "Failed! Patched Wii VC WAD was not created." }

    # Remove the folder the extracted files were in, and delete files
    RemovePath $WadFile.Folder

}



#==============================================================================================================================================================================================
function ExtractU8AppFile([string]$Command) {
    
    # ROM is within the "0000005.app" file
    if ($GameConsole.appfile -eq "00000005.app") {
        UpdateStatusLabel 'Extracting "00000005.app" file...'                                                 # Set the status label

        $script = { Param([string]$Tool, [string]$File, [string]$Path)
            & $Tool 'X' $File '-d' $Path | Out-Null                                                           # Unpack the file using wszst
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.wszst, $WADFile.AppFile05, $WADFile.AppPath05)
        StartJobLoop -Name "Script"

        if ($VC.RemoveT64.Checked) { Get-ChildItem $WADFile.AppPath05 -Include *.T64 -Recurse | Remove-Item } # Remove all .T64 files when selected
        foreach ($item in Get-ChildItem $WADFile.AppPath05) {                                                 # Reference ROM in unpacked AppFile
            if ($item -match "rom") {
                $WADFile.ROM = $item.FullName
                SetGetROM
            }
        }
    }

    # ROM is within "00000001.app" VC emulator file, but extract it only
    elseif ($GameConsole.appfile -eq "00000001.app") {
        UpdateStatusLabel 'Extracting ROM from "00000001.app" file...'                  # Set the status label
        RemoveFile ($Paths.Temp  + "\rom.nes")
        $WADFile.Offset = SearchBytes -File $WADFile.AppFile01 -Values "4E45531A" -Start "100000" -Silent
        
        if ($WADFile.Offset -ne -1) {
            $nes = $Paths.Temp + "\rom.nes"
            $arr = [IO.File]::ReadAllBytes($WADFile.AppFile01)
            $WADFile.Length = Get24Bit (16 + ($arr[(GetDecimal $WADFile.Offset) + 4] * 16384) + ($arr[(GetDecimal $WADFile.Offset) + 5] * 8192))
            ExportBytes -File $WADFile.AppFile01 -Offset $WADFile.Offset -Length $WADFile.Length -Output $nes -Silent
            $global:ROMHashSum = (Get-FileHash -Algorithm MD5 -LiteralPath $nes).Hash
            SetGetROM
        }
    }

    if (!(TestFile $GetROM.run)) {
        UpdateStatusLabel ('ROM could not be extracted. Is this a wrong or broken ' + $GameConsole.mode + ' ROM?')
        return $False
    }
    return $True

}



#==============================================================================================================================================================================================
function RepackU8AppFile() {
    
    # The ROM is located witin the "00000005.app" file
    if ($GameConsole.appFile -eq "00000005.app") {
        UpdateStatusLabel 'Repacking "00000005.app" file...'                          # Set the status label
        RemoveFile $WadFile.AppFile05                                                 # Remove the original app file as its going to be replaced

        $script = { Param([string]$Tool, [string]$Path, [string]$File)
            & $Tool 'C' $Path '-d' $File | Out-Null                                   # Repack the file using wszst
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.wszst, $WADFile.AppPath05, $WADFile.AppFile05)
        StartJobLoop -Name "Script"

        $AppByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile05)                   # Get the file as a byte array
        for ($i=16; $i -le 31; $i++) { $AppByteArray[$i] = 0 }                        # Overwrite the values in 0x10 with zeroes. I don't know why, I'm just matching the output from another program
        [IO.File]::WriteAllBytes($WadFile.AppFile05, $AppByteArray)                   # Overwrite the patch file with the extended file
        RemoveFile $WadFile.AppPath05                                                 # Remove the extracted WAD folder
    }

    # The ROM is located witin the "00000001.app" VC emulator file
    elseif ($GameConsole.appFile -eq "00000001.app") {
        UpdateStatusLabel 'Re-injecting ROM into "00000001.app" file...'     # Set the status label
        $ByteArrayROM = [IO.File]::ReadAllBytes($GetROM.run)
        $ByteArrayApp = [IO.File]::ReadAllBytes($WADFile.AppFile01)
        for ($i=0; $i -lt (GetDecimal -Hex $WADFile.Length); $i++) { $ByteArrayApp[$i + (GetDecimal -Hex $WADFile.Offset)] = $ByteArrayROM[($i)] }
        [io.file]::WriteAllBytes($WADFile.AppFile01, $ByteArrayApp)
    }

}



#==============================================================================================================================================================================================
function SetPreset([object]$ComboBox, [string]$Text) {
    
    $global:PauseRemapping = $True

    $Text = $Text.replace(" (default)", "")
    if ($Text -eq "Custom") { return }

    foreach ($item in $Files.json.controls.presets) {
        if ($item.title -eq $Text) {
            $preset = $item
            break
        }
    }

    if ($preset -eq $null) {
        WriteToConsole ("Controls preset: " +$Text + " was not found")
        return
    }

    SetItem -ComboBox $Redux.controls.A      -Text $preset.a;        SetItem -ComboBox $Redux.controls.B         -Text $preset.b;           SetItem -ComboBox $Redux.controls.Start    -Text $preset.start
    SetItem -ComboBox $Redux.controls.L      -Text $preset.l;        SetItem -ComboBox $Redux.controls.R         -Text $preset.r;           SetItem -ComboBox $Redux.controls.Z        -Text $preset.z
    SetItem -ComboBox $Redux.controls.X      -Text $preset.x;        SetItem -ComboBox $Redux.controls.Y         -Text $preset.y
    SetItem -ComboBox $Redux.controls.CUp    -Text $preset.cup;      SetItem -ComboBox $Redux.controls.CRight    -Text $preset.cright;      SetItem -ComboBox $Redux.controls.CDown    -Text $preset.cdown;      SetItem -ComboBox $Redux.controls.CLeft    -Text $preset.cleft
    SetItem -ComboBox $Redux.controls.DPadUp -Text $preset.dpadup;   SetItem -ComboBox $Redux.controls.DPadRight -Text $preset.dpadright;   SetItem -ComboBox $Redux.controls.DPadDown -Text $preset.dpaddown;   SetItem -ComboBox $Redux.controls.DPadLeft -Text $preset.dpadleft

    $global:PauseRemapping = $False

}



#==============================================================================================================================================================================================
function SetItem([object]$ComboBox, [string]$Text) {
    
    foreach ($i in 0..($ComboBox.items.Count-1)) {
        if ($ComboBox.items[$i] -eq $Text) {
            $Combobox.SelectedIndex = $i
            break
        }
    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateVCRemapPanel

Export-ModuleMember -Function CheckVCGameID
Export-ModuleMember -Function PatchVCROM
Export-ModuleMember -Function PatchVCEmulator
Export-ModuleMember -Function CompressROMC
Export-ModuleMember -Function ExtendROM

Export-ModuleMember -Function HackOpeningBNRTitle
Export-ModuleMember -Function SetWADParameters

Export-ModuleMember -Function ExtractWADFile
Export-ModuleMember -Function RepackWADFile
Export-ModuleMember -Function ExtractU8AppFile
Export-ModuleMember -Function RepackU8AppFile
