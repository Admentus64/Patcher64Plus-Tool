function MainFunction([String]$Command, [String]$PatchedFileName) {
    
    # Header
    $Header = @($GameType.rom_title, $GameType.rom_gameID, $GameType.vc_title, $GameType.vc_gameID)
    $Header = SetHeader -Header $Header -ROMTitle $GamePatch.rom_title -ROMGameID $GamePatch.rom_gameID -VCTitle $GamePatch.vc_title -VCGameID $GamePatch.vc_gameID

    # Hash
    if (IsSet -Elem $GamePatch.Hash)   { $global:CheckHashSum = $GamePatch.Hash }
    else                               { $global:CheckHashSum = $GameType.Hash }

    # Output
    if (!(IsSet -Elem $PatchedFileName)) { $PatchedFileName = "_patched" }
    
    # Downgrade, 
    if ($Patches.Downgrade.Visible -and (StrLike -str $Command -val "Force Downgrade") )              { $Patches.Downgrade.Checked = $True }
    elseif ($Patches.Downgrade.Visible -and (StrLike -str $Command -val "No Downgrade") )             { $Patches.Downgrade.Checked = $False }

    # Expand Memory, Remap D-Pad
    if ($IsWiiVC) {
        if ($GameType.patches_vc -ge 3) {
            if ($VC.ExpandMemory.Visible -and (StrLike -str $Command -val "Force Expand Memory") )    { $VC.ExpandMemory.Checked = $True }
            elseif ($VC.ExpandMemory.Visible -and (StrLike -str $Command -val "No Expand Memory") )   { $VC.ExpandMemory.Checked = $False }
    
            if ($VC.RemapDPad.Visible -and (StrLike -str $Command -val "Force Remap D-Pad") )         { $VC.RemapDPad.Checked = $True }
            elseif ($VC.RemapDPad.Visible -and (StrLike -str $Command -val "No Remap D-Pad") )        { $VC.RemapDPad.Checked = $False }
        }
    }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Patch Header") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Patch VC") -and !(StrLike -str $Command -val "Extract") ) {
        # Redux
        if ( (IsChecked -Elem $Patches.Redux) -and (IsSet -Elem $GamePatch.redux.file)) {
            $VC.RemapDPad.Checked = $True
            if ($GameType.patches_vc -eq 4) { $VC.ExpandMemory.Checked = $True }
            $Header = SetHeader -Header $Header -ROMTitle $GamePatch.redux.rom_title -ROMGameID $GamePatch.redux.rom_gameID -VCTitle $GamePatch.redux.vc_title -VCGameID $GamePatch.redux.vc_gameID
            if (IsSet -Elem $GamePatch.redux.output) { $PatchedFileName = $GamePatch.redux.output }
            if (StrLike -str $Command -val "Inject") { $PatchedFileName += "_injected" }
        }

        # Language Patch
        $LanguagePatch = $null
        if (IsSet -Elem $GamePatch.languages -MinLength 1) {
            for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
                if ($Languages[$i].checked) { $Item = $i }
            }
            $Header = SetHeader -Header $Header -ROMTitle $GamePatch.languages[$Item].rom_title -ROMGameID $GamePatch.languages[$Item].rom_gameID -VCTitle $GamePatch.languages[$Item].vc_title -VCGameID $GamePatch.languages[$Item].vc_gameID
            if (IsSet -Elem $GamePatch.languages[$Item].output) { $PatchedFileName = $GamePatch.languages[$Item].output }
            $LanguagePatch = $GamePatch.languages[$Item].file
        }
    }

    # GameID / Title
    if ($CustomHeaderCheckbox.Checked) {
        if ($CustomTitleTextBox.TextLength -gt 0)    { $Header[0 + [int]$IsWiiVC * 2] = $CustomTitleTextBox.Text }
        if ($CustomGameIDTextbox.TextLength -eq 4)   { $Header[1 + [int]$IsWiiVC * 2] = $CustomGameIDTextBox.Text }

        if ( (IsSet -Elem $GamePatch.languages) -and (IsSet -Elem $Item) -and $IsWiiVC) {
            if (IsSet -Elem $GamePatch.languages[$Item].rom_gameID) {
                $Header[1] = $Header[1].substring(0, 3)
                $Header[1] += $GamePatch.languages[$Item].rom_gameID.substring(3, 1)
            }
        }
    }
    
    # Decompress
    $Decompress = $False
    if ($GamePatch.file -like "*\Decompressed\*")   { $Decompress = $True }
    if ($LanguagePatch -like "*\Decompressed\*")    { $Decompress = $True }
    if ($GameType.decompress -eq 1) {
        if ( (IsChecked -Elem $Patches.Redux -Active) -or (IsChecked -Elem $Patches.Options -Active) ) { $Decompress = $True }
    }
    
    # Set ROM
    if (IsSet -Elem $Files.ROM -MinLength 4) { $global:ROMFile = SetROMParameters -ROMPath $global:GameROM -PatchedFileName $PatchedFileName }
    if (!$IsWiiVC) { SetGetROM }

    # GO!
    MainFunctionPatch -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress
    EnableGUI -Enable $True
    if (!($GeneralSettings.NoCleanup.Checked)) { Cleanup }

}



#==============================================================================================================================================================================================
function SetHeader([String[]]$Header, [String]$ROMTitle, [String]$ROMGameID, [String]$VCTitle, [String]$VCGameID) {
    
    if (IsSet -Elem $ROMTitle)    { $Header[0] = $ROMTitle }
    if (IsSet -Elem $ROMGameID)   { $Header[1] = $ROMGameID }
    if (IsSet -Elem $VCTitle)     { $Header[2] = $VCTitle }
    if (IsSet -Elem $VCGameID)    { $Header[3] = $VCGameID }
    return $Header

}



#==============================================================================================================================================================================================
function MainFunctionPatch([String]$Command, [String[]]$Header, [String]$PatchedFileName, [Boolean]$Decompress) {
    
    if ($Settings.Debug.Console -eq $True) { if ( (WriteDebug -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress) -eq $True) { return } }

    # Step 01: Disable the main dialog, allow patching and delete files if they still exist.
    EnableGUI -Enable $False

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 02: Extract the contents of the WAD file.
        if (!(ExtractWADFile -PatchedFileName $PatchedFileName)) { return }

        # Step 03: Check the GameID to be vanilla.
        if (!(CheckGameID)) { return }

        # Step 04: Replace the Virtual Console emulator within the WAD file.
        PatchVCEmulator -Command $Command

        # Step 05: Extract "00000005.app" file to get the ROM.
        ExtractU8AppFile -Command $Command

        # Step 06: Do some initial patching stuff for the ROM for VC WAD files.
        if (!(PatchVCROM -Command $Command)) { return }
    }

    # Step 07: Compare HashSums for untouched ROM Files
    if (!(CompareHashSums -Command $Command)) { return }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Patch Header") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Patch VC") -and !(StrLike -str $Command -val "Extract") ) {
        # Step 08: Downgrade and decompress the ROM if required
        if ($GameType.decompress -ne 1 -and !$Decompress) {
            if (!(DowngradeROM -Decompress $Decompress -Has (Get-FileHash -Algorithm MD5 $GetROM.in).Hash)) { return }
        }
        if (!(DecompressROM -Decompress $Decompress)) { return }

        # Step 09: Extract MQ dungeon data for OoT
        ExtractMQData -Decompress $Decompress
        
        # Step 10: Apply the Redux patch
        PatchRedux -Decompress $Decompress

        # Step 11: Apply additional options
        if ( ($GamePatch.options -gt 0) -and (IsChecked -Elem $Patches.Options -Active) )   {

            if ( !$Decompress -and !(Test-Path -LiteralPath $GetROM.decomp) ) { Copy-Item -LiteralPath $GetROM.in -Destination $GetROM.decomp -Force }
            $FunctionTitle = $GameType.mode
            $FunctionTitle = $FunctionTitle -replace " ", ""
            $FunctionTitle = $FunctionTitle -replace ",", ""
            $FunctionTitle = $FunctionTitle -replace "'", ""
            if (Get-Command ("PatchOptions" + $FunctionTitle) -errorAction SilentlyContinue) {
                UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")
                &("PatchOptions" + $FunctionTitle)
                if (!$Decompress) { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force }
            }
        }

        # Step 12: Patch and extend the ROM file with the patch through Floating IPS
        if (!(PatchDecompressedROM)) { return }

        # Step 13: Compress the decompressed ROM if required
        CompressROM -Decompress $Decompress

        # Step 14: Patch and extend the ROM file with the patch through Floating IPS
        if (!(PatchCompressedROM)) { return }
    }
    elseif (StrLike -str $Command -val "Apply Patch") {
        # Step 15: Apply provided BPS Patch
        if (!(ApplyPatchROM)) { return }
    }

    # Step 16: Update the .Z64 ROM CRC
    UpdateROMCRC

    # Step 17: Hack the Game Title and GameID of a N64 ROM
    HackROMGameTitle -Title $Header[0] -GameID $Header[1]

    # Step 18: Debug
    CreateDebugPatches

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 19: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        ExtendROM

        # Step 20: Compress the ROMC again if possible.
        CompressROMC

        # Step 21: Hack the Channel Title.
        HackOpeningBNRTitle -Title $Header[2]

        # Step 22: Repack the "00000005.app" with the updated ROM file 
        RepackU8AppFile
        
        # Step 23: Repack the WAD file with the updated APP file.
        RepackWADFile -GameID $Header[3]
    }

    # Step 24: Final message.
    if ($IsWiiVC)   { UpdateStatusLabel -Text ('Finished patching the ' + $GameType.mode + ' VC WAD file.') }
    else            { UpdateStatusLabel -Text ('Finished patching the ' + $GameType.mode + ' ROM file.') }    

}



#==============================================================================================================================================================================================
function WriteDebug([String]$Command, [String[]]$Header, [String]$PatchedFileName, [Boolean]$Decompress) {

    Write-Host ""
    Write-Host "--- Patch Info ---"
    Write-Host "Header:" $Header
    Write-Host "Patches:" $GamePatch.file   $GamePatch.redux.file   $LanguagePatch
    Write-Host "Patched File Name:" $PatchedFileName
    Write-Host "Command:" $Command
    Write-Host "Downgrade:" (IsChecked $Patches.Downgrade -Active)
    Write-Host "Decompress:" $Decompress
    Write-Host "Hash:" $CheckHashSum
    Write-Host "Wii VC:" $IsWiiVC
    Write-Host "Console:" $GameConsole.Mode
    Write-Host "WAD File Path:" $Files.WAD
    Write-Host "ROM File Path:" $Files.ROM
    Write-Host "BPS File Path:" $Files.BPS

    return $Settings.Debug.Stop

}



#==============================================================================================================================================================================================
function Cleanup() {
    
    SetGetROM

    if ($Settings.Debug.Console -eq $True) { Write-Host "Cleaning up files..." }

    if ($IsWiiVC) {
        RemovePath -LiteralPath ($Paths.Master + '\cygdrive')
        RemovePath -LiteralPath $WADFile.Folder
        RemoveFile -LiteralPath $Files.ckey
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000000.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000001.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000002.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000003.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000004.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000005.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000006.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\00000007.app")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\" + $WADFile.FolderName + ".cert")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\" + $WADFile.FolderName + ".tik")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\" + $WADFile.FolderName + ".tmd")
        RemoveFile -LiteralPath ($Paths.WiiVC + "\" + $WADFile.FolderName + ".trailer")
        
        foreach($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }
    }

    $GetROM.GetEnumerator() | ForEach-Object {
        if ($_.value -ne $GetROM.in -and $_.value -ne $GetROM.patched -and $_.value -ne $GetROM.debug) {
            RemoveFile -LiteralPath $_.value
        }
    }
    RemoveFile -LiteralPath $GetROM.nes

    RemoveFile -LiteralPath $Files.flipscfg
    RemoveFile -LiteralPath $Files.stackdump
    RemoveFile -LiteralPath $Files.dmaTable
    RemoveFile -LiteralPath $Files.archive

    $global:ByteArrayGame = $null
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {
    
    if ($Settings.Debug.NoCRCChange -eq $True -or $GameConsole.mode -ne "N64") { return }
    if (!(Test-Path -LiteralPath $GetROM.patched -PathType Leaf)) { Copy-Item -LiteralPath $GetROM.in -Destination $GetROM.patched }
    & $Files.tool.rn64crc $GetROM.patched -update | Out-Host
    if ($Settings.Debug.KeepDecompressed -eq $True) { & $Files.tool.rn64crc $GetROM.debug -update | Out-Host }

}



#==============================================================================================================================================================================================
function CreateDebugPatches() {
    
    if ($Settings.Debug.CreateBPS -ne $True) { return }
    if ( (Test-Path -LiteralPath $GetROM.cleanDecomp -PathType Leaf) -and (Test-Path -LiteralPath $GetROM.decomp -PathType Leaf) ) { & $Files.tool.flips --create --bps $GetROM.cleanDecomp $GetROM.decomp $Files.decompBPS | Out-Host }
    & $Files.tool.flips --create --bps $GetROM.clean $GetROM.patched $Files.compBPS | Out-Host

}



#==============================================================================================================================================================================================
function SetWADParameters([String]$WADPath, [String]$FolderName, [String]$PatchedFileName) {
    
    # Create a hash table
    $WADFile = @{}

    # Get the WAD as an item object
    $WADItem = Get-Item -LiteralPath $WADPath
    
    # Store some stuff about the WAD to reference
    $WADFile.Name         = $WADItem.BaseName
    $WADFile.Folder       = $Paths.WiiVC + "\" + $FolderName
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
    
    $WADFile.Extension = GetROMExtension

    $WADFile.Patched      = $WADItem.DirectoryName + "\" + $WADFile.Name + $PatchedFileName + ".wad"
    $WADFile.Extracted    = $WADItem.DirectoryName + "\" + $WADFile.Name + "_extracted_rom" + $WADFile.Extension
    $WADFile.Debug        = $WADItem.DirectoryName + "\" + $WADFile.Name + "_decompressed" + $WADFile.Extension

    $WADFile.Offset = $WadFile.Length = "0"

    # Set it to a global value
    return $WADFile

}



#==============================================================================================================================================================================================
function SetROMParameters([String]$ROMPath, [String]$PatchedFileName) {
    
    # Create a hash table
    $ROMFile = @{}

    # Get the ROM as an item object
    $ROMItem = Get-Item -LiteralPath $ROMPath
    
    # Store some stuff about the ROM to reference
    $ROMFile.Name    = $ROMItem.BaseName
    $ROMFile.Path    = $ROMItem.DirectoryName
    
    $ROMFile.Extension = GetROMExtension

    $ROMFile.ROM     = $ROMPath
    $ROMFile.Patched = $ROMFile.Path + "\" + $ROMFile.Name + $PatchedFileName + $ROMFile.Extension
    $ROMFile.Debug   = $ROMFile.Path + "\" + $ROMFile.Name + "_decompressed" + $ROMFile.Extension

    # Set it to a global value
    return $ROMFile

}



#==============================================================================================================================================================================================
function GetROMExtension() {
    
    if ($GameConsole.mode -eq "N64")        { return ".z64" }
    elseif ($GameConsole.mode -eq "SNES")   { return ".sfc" }
    elseif ($GameConsole.mode -eq "NES")    { return ".nes" }

}



#==============================================================================================================================================================================================
function ExtractWADFile([String]$PatchedFileName) {
    
    # Set the status label.
    UpdateStatusLabel -Text "Extracting WAD file..."

    # We need to be in the same path as some files so just jump there.
    Push-Location $Paths.WiiVC

    # Check if an extracted folder existed previously
    foreach($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }
    
    $ByteArray = $null
    if (!(Test-Path $Files.ckey -PathType Leaf)) {
        $ByteArray = @(235, 228, 42, 34, 94, 133, 147, 228, 72, 217, 197, 69, 115, 129, 170, 247)
        [io.file]::WriteAllBytes($Files.ckey, $ByteArray) | Out-Null
    }
    $ByteArray = $null
    
    # Run the program to extract the wad file.
    $ErrorActionPreference = 'SilentlyContinue'
    try   { & $Files.tool.wadunpacker $GameWAD | Out-Null }
    catch { }
    $ErrorActionPreference = 'Continue'

    # Find the extracted folder by looping through all files in the folder.
    $FolderExists = $False
    foreach ($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) {
        # There will only be one folder, the one we want.
        if ($Folder.PSIsContainer) {
            $FolderExists = $True
            # Remember the path to this folder.
            $global:WADFile = SetWADParameters -WADPath $GameWAD -FolderName $Folder.Name -PatchedFileName $PatchedFileName
        }
    }

    # Doesn't matter, but return to where we were.
    Pop-Location

    if (!$FolderExists) {
        UpdateStatusLabel -Text "Failed! Could not extract Wii VC WAD. Try using a different filename."
        return $False
    }
    return $True

}



#==============================================================================================================================================================================================
function ExtractU8AppFile([String]$Command) {
    
    # ROM is within the "0000005.app" file
    if ($GameConsole.appfile -eq "00000005.app") {
        UpdateStatusLabel -Text 'Extracting "00000005.app" file...'                      # Set the status label
        & $Files.tool.wszst 'X' $WADFile.AppFile05 '-d' $WADFile.AppPath05 | Out-Null    # Unpack the file using wszst

        # Remove all .T64 files when selected
        if ($VC.RemoveT64.Checked) {
            Get-ChildItem $WADFile.AppPath05 -Include *.T64 -Recurse | Remove-Item
        }

        # Reference ROM in unpacked AppFile
        Get-ChildItem $WADFile.AppPath05 | Foreach-Object {
            if ($_ -match "rom") {
                $WADFile.ROM = $_.FullName
                SetGetROM
            }
        }
    }
    
    # ROM is within "00000001.app" VC emulator file, but extract it only
    elseif ($GameConsole.appfile -eq "00000001.app") {
        UpdateStatusLabel -Text 'Extracting ROM from "00000001.app" file...'             # Set the status label
        SetGetROM
        RemoveFile -LiteralPath $GetROM.nes
        $WADFile.Offset = SearchBytes -File $WADFile.AppFile01 -Values @("4E", "45", "53", "1A") -Start "100000"
        
        if ($WADFile.Offset -ne -1) {
            $arr = [IO.File]::ReadAllBytes($WADFile.AppFile01)
            $WADFile.Length = Get24Bit -Value (16 + ($arr[(GetDecimal -Hex $WADFile.Offset) + 4] * 16384) + ($arr[(GetDecimal -Hex $WADFile.Offset) + 5] * 8192))
            ExportBytes -File $WADFile.AppFile01 -Offset $WADFile.Offset -Length $WADFile.Length -Output $WADFile.ROM
        }
    }

}



#==============================================================================================================================================================================================
function PatchVCEmulator([String]$Command) {
    
    if (StrLike -str $Command -val "Extract") { return }

    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " VC Emulator...")

    if (StrLike -str $Command -val "Patch Boot DOL") {
        $Patch = "\AppFile01" + $GamePatch.file
        $Patch = $Patch -replace "\\Decompressed"
        $Patch = $Patch -replace "\\Compressed"
        ApplyPatch -File $WADFile.AppFile01 -Patch $Patch
    }

    elseif ($GameType.mode -eq "Ocarina of Time") {
        
        if ($VC.ExpandMemory.Checked) {
        ChangeBytes -File $WadFile.AppFile01 -Offset "2EB0" -Values @("60", "00", "00", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "5BF44" -Values @("3C", "80", "72", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "5BFD7" -Values @("00")
        }

        if ($VC.RemapDPad.Checked) {
            if (!$VC.LeaveDPadUp.Checked) { ChangeBytes -File $WadFile.AppFile01 -Offset "16BAF0" -Values @("08", "00") }
            ChangeBytes -File $WadFile.AppFile01 -Offset "16BAF4" -Values @("04", "00")
            ChangeBytes -File $WadFile.AppFile01 -Offset "16BAF8" -Values @("02", "00")
            ChangeBytes -File $WadFile.AppFile01 -Offset "16BAFC" -Values @("01", "00")
        }

        if ($VC.RemapCDown.Checked)         { ChangeBytes -File $WadFile.AppFile01 -Offset "16BB04" -Values @("00", "20") }
        if ($VC.RemapZ.Checked)             { ChangeBytes -File $WadFile.AppFile01 -Offset "16BAD8" -Values @("00", "20") }

    }

    elseif ($GameType.mode -eq "Majora's Mask") {
        
        if ($VC.ExpandMemory.Checked -or $VC.RemapDPad.Checked -or $VC.RemapCDown.Checked -or $VC.RemapZ.Checked) { & $Files.tool.lzss -d $WADFile.AppFile01 | Out-Host }

        if ($VC.ExpandMemory.Checked) {
            ChangeBytes -File $WadFile.AppFile01 -Offset "10B58" -Values @("3C", "80", "00", "C0")
            ChangeBytes -File $WadFile.AppFile01 -Offset "4BD20" -Values @("67", "E4", "70", "00")
            ChangeBytes -File $WadFile.AppFile01 -Offset "4BC80" -Values @("3C", "A0", "01", "00")
        }

        if ($VC.RemapDPad.Checked) {
            ChangeBytes -File $WadFile.AppFile01 -Offset "148514" -Values @("08", "00")
            ChangeBytes -File $WadFile.AppFile01 -Offset "148518" -Values @("04", "00")
            ChangeBytes -File $WadFile.AppFile01 -Offset "14851C" -Values @("02", "00")
            ChangeBytes -File $WadFile.AppFile01 -Offset "148520" -Values @("01", "00")
        }

        if ($VC.RemapCDown.Checked)         { ChangeBytes -File $WadFile.AppFile01 -Offset "148528" -Values @("00", "20") }
        if ($VC.RemapZ.Checked)             { ChangeBytes -File $WadFile.AppFile01 -Offset "1484F8" -Values @("00", "20") }

        if ($VC.ExpandMemory.Checked -or $VC.RemapDPad.Checked -or $VC.RemapCDown.Checked -or $VC.RemapZ.Checked) { & $Files.tool.lzss -evn $WADFile.AppFile01 | Out-Host }

    }

    elseif ($GameType.mode -eq "Super Mario 64") {
        
        if ($VC.RemapL.Checked)                                                          { ChangeBytes -File $WadFile.AppFile01 -Offset "168628" -Values @("00", "20") } # L -> 0x168628, D-Pad -> 0x168648, 0x16864C, 0x168650, 0x168654
        if ($VC.RemoveFilter.Checked -and (StrLike -str $Command -val "Multiplayer") )   { ChangeBytes -File $WadFile.AppFile01 -Offset "53124" -Values @("60", "00", "00", "00") }
        elseif ($VC.RemoveFilter.Checked)                                                { ChangeBytes -File $WadFile.AppFile01 -Offset "46210" -Values @("4E", "80", "00", "20") }

    }

}



#==============================================================================================================================================================================================
function PatchVCROM([String]$Command) {

    if (StrLike -str $Command -val "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabel -Text ("Initial patching of " + $GameType.mode + " ROM...")
    
    # Extract ROM if required
    if (StrLike -str $Command -val "Extract") {
        if (Test-Path -LiteralPath $GetROM.in -PathType Leaf) {
            Move-Item -LiteralPath $GetROM.in -Destination $WADFile.Extracted -Force
            UpdateStatusLabel -Text ("Successfully extracted " + $GameType.mode + " ROM.")
        }
        else { UpdateStatusLabel -Text ("Could not extract " + $GameType.mode + " ROM. Is it a VC compressed ROM?") }

        return $False
    }

    # Replace ROM if needed
    if (StrLike -str $Command -val "Inject") {
        if (Test-Path -LiteralPath $GetROM.in -PathType Leaf) {
            Remove-Item -LiteralPath $GetROM.in
            if ((Test-Path -LiteralPath $Files.ROM -PathType Leaf)) { Copy-Item -LiteralPath $Files.ROM -Destination $GetROM.in }
            else {
                UpdateStatusLabel -Text ("Could not inject " + $GameType.mode + " ROM. Did you move or rename the ROM file?")
                return $False
            }
        }
        else {
            UpdateStatusLabel -Text ("Could not inject " + $GameType.mode + " ROM. Is it a VC compressed ROM?")
            return $False
        }
    }

    # Decompress romc if needed
    if ($GameType.romc -ge 1 -and !(StrLike -str $Command -val "Inject") ) {  

        if (Test-Path -LiteralPath $GetROM.in -PathType Leaf) {
            RemoveFile -LiteralPath $GetROM.romc
            if ($GameType.romc -eq 1)       { & $Files.tool.romchu $GetROM.in $GetROM.romc | Out-Null }
            elseif ($GameType.romc -eq 2)   { & $Files.tool.romc d $GetROM.in $GetROM.romc | Out-Null }
            Move-Item -LiteralPath $GetROM.romc -Destination $GetROM.in -Force
        }
        else {
            UpdateStatusLabel -Text ("Could not decompress " + $GameType.mode + " ROM. Is it a VC compressed ROM?")
            return $False
        }

    }

    # Get the file as a byte array so the size can be analyzed.
    $ByteArray = [IO.File]::ReadAllBytes($GetROM.in)
    
    # Create an empty byte array that matches the size of the ROM byte array.
    $NewByteArray = New-Object Byte[] $ByteArray.Length
    
    # Fill the entire array with junk data. The patched ROM is slightly smaller than 8MB but we need an 8MB ROM.
    for ($i=0; $i-lt $ByteArray.Length; $i++) { $NewByteArray[$i] = 255 }

    $ByteArray = $null

    return $True

}



#==============================================================================================================================================================================================
function DowngradeROM([Boolean]$Decompress, [String]$Hash) {
    
    # Downgrade a ROM if it is required first
    if (IsChecked $Patches.Downgrade -Active) {
        UpdateStatusLabel -Text "Downgrading ROM..."

        if ($Decompress)   { $File = $GetROM.decomp }
        else               { $File = $GetROM.in }

        if ($Hash -eq $CheckHashSum) { return $True }

        Foreach ($Item in $GameType.downgrade) {
            if ($Hash -eq $Item.hash) {
                if (!(ApplyPatch -File $File -Patch $Item.file -New $GetROM.downgrade)) {
                    UpdateStatusLabel -Text "Failed! Could not apply downgrade Patches."
                    return $False
                }
                if ($Decompress)   { $GetROM.decomp = $GetROM.downgrade }
                else               { $GetROM.in = $GetROM.downgrade }
                return $True
            }
        }

        if ($Settings.Debug.IgnoreChecksum -ne $True) {
            UpdateStatusLabel -Text "Failed! Unknown revision."
            return $False
        }
        
    }

    return $True
    
}



#==============================================================================================================================================================================================
function CompareHashSums([String]$Command) {
    
    if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $GetROM.in -Destination $GetROM.clean -Force }
    if ($Settings.Debug.IgnoreChecksum -eq $True) { return $True }
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Patch Header") -or (StrLike -str $Command -val "Patch VC") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }

    $HashSum = (Get-FileHash -Algorithm MD5 $GetROM.in).Hash
    if ($CheckHashSum -eq "Dawn & Dusk") {
        if ($HashSum -eq "5BD1FE107BF8106B2AB6650ABECD54D6")     { $GamePatch.file = "\Compressed\dawn_rev0.bps"; return $True }
        elseif ($HashSum -eq "721FDCC6F5F34BE55C43A807F2A16AF4") { $GamePatch.file = "\Compressed\dawn_rev1.bps"; return $True }
        elseif ($HashSum -eq "57A9719AD547C516342E1A15D5C28C3D") { $GamePatch.file = "\Compressed\dawn_rev2.bps"; return $True }
    }
    elseif ($HashSum -eq $CheckHashSum) { return $True }
    elseif (IsSet -Elem $GameType.downgrade) {
        Foreach ($Item in $GameType.downgrade) {
            if ($HashSum -eq $Item.hash) { return $True }
        }
    }
    
    Write-Host $GetROM.in
    UpdateStatusLabel -Text "Failed! ROM does not match the patching button target. ROM has left unchanged."
    return $False

}



#==============================================================================================================================================================================================
function PatchDecompressedROM() {

    if (!(IsSet $GamePatch.file))                                                { return $True }
    if (!$Decompress -or !(StrLike -str $GamePatch.file -val "\Decompressed"))   { return $True }
    
    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " ROM with patch file...")

    # Apply the selected patch to the ROM, if it is provided
    if (!(ApplyPatch -File $GetROM.decomp -Patch $GamePatch.file)) { return $False }

    return $True

}



#==============================================================================================================================================================================================
function PatchCompressedROM() {

    if (!(IsSet $GamePatch.file))                                             { return $True }
    if ($Decompress -or !(StrLike -str $GamePatch.file -val "\Compressed"))   { return $True }
    
    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " ROM with patch file...")

    # Apply the selected patch to the ROM, if it is provided
    if ($IsWiiVC)        { if (!(ApplyPatch -File $GetROM.patched -Patch $GamePatch.file))                   { return $False } }
    elseif (!$IsWiiVC)   { if (!(ApplyPatch -File $GetROM.in -Patch $GamePatch.file -New $GetROM.patched))   { return $False } }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatchROM() {

    $HashSum1 = (Get-FileHash -Algorithm MD5 $GetROM.in).Hash
    if (!(ApplyPatch -File $GetROM.in -Patch $Files.BPS -New $GetROM.patched -FullPath)) { return $False }
    $HashSum2 = (Get-FileHash -Algorithm MD5 $GetROM.patched).Hash
    if ($HashSum1 -eq $HashSum2) {
        if ($IsWiiVC -and $GameType.downgrade -and !(IsChecked $Patches.Downgrade -Active) )      { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?" }
        elseif ($IsWiiVC -and $GameType.downgrade -and (IsChecked $Patches.Downgrade -Active) )   { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" }
        else                                                                                      { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged." }
        return $False
    }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatch([String]$File, [String]$Patch, [String]$New, [Switch]$FilesPath, [Switch]$FullPath) {

    if ( !(IsSet -Elem $File) -or !(IsSet -Elem $Patch) ) { return $True }

    # File
    if (!(Test-Path -LiteralPath $File -PathType Leaf)) {
        UpdateStatusLabel -Text "Failed! Could not find file."
        return $False
    }

    # Patch File
    if ($FullPath)         {  }
    elseif ($FilesPath)    { $Patch = $Paths.Master + $Patch }
    else                   { $Patch = $GameFiles.base + $Patch }

    if (Test-Path ($Patch + ".bps") -PathType Leaf)      { $Patch + ".bps" }
    if (Test-Path ($Patch + ".ips") -PathType Leaf)      { $Patch + ".ips" }
    if (Test-Path ($Patch + ".xdelta") -PathType Leaf)   { $Patch + ".xdelta" }
    if (Test-Path ($Patch + ".vcdiff") -PathType Leaf)   { $Patch + ".vcdiff" }
    if (Test-Path ($Patch + ".ppf") -PathType Leaf)      { $Patch + ".ppf" }

    if (Test-Path -LiteralPath $Patch -PathType Leaf) { $Patch = Get-Item -LiteralPath $Patch }
    else {
        UpdateStatusLabel -Text ("Failed! Could not find patch file at: " + $Patch)
        return $False
    }

    # Patching
    if ($Settings.Debug.Console -eq $True) { Write-Host "Applying patch:" $Patch }

    if ($Patch -like "*.bps*" -or $Patch -like "*.ips*") {
        if ($New.Length -gt 0) { & $Files.tool.flips --ignore-checksum --apply $Patch $File $New | Out-Host }
        else { & $Files.tool.flips --ignore-checksum $Patch $File | Out-Host }
    }
    elseif ($Patch -like "*.xdelta*" -or $Patch -like "*.vcdiff*") {
        if ($Patch -like "*.xdelta*")       { $Tool = $Files.tool.xdelta }
        elseif ($Patch -like "*.vcdiff*")   { $Tool = $Files.tool.xdelta3 }

        if ($New.Length -gt 0) {
            RemoveFile -LiteralPath $New
            & $Tool -d -s $File $Patch $New | Out-Host
        }
        else {
            & $Tool -d -s $File $Patch ($File + ".ext") | Out-Host
            Move-Item -LiteralPath ($File + ".ext") -Destination $File -Force
        }
    }
    elseif ($Patch -like "*.ppf*") {
        if ($New.Length -gt 0) {
            Copy-Item -LiteralPath $File -Destination $New -Force
            & $Files.tool.applyPPF3 a $New $Patch | Out-Host
        }
        else { & $Files.tool.applyPPF3 a $File $Patch | Out-Host }
    }

    else { return $False }

    return $True

}



#==============================================================================================================================================================================================
function DecompressROM([Boolean]$Decompress) {

    if (!$Decompress) { return $True }
    
    if ($GameType.decompress -eq 1) {
        UpdateStatusLabel -Text ("Decompressing " + $GameType.mode + " ROM...")

        $HashSum = (Get-FileHash -Algorithm MD5 $GetROM.in).Hash
        if ($HashSum -ne $CheckHashSum -and (IsChecked $Patches.Downgrade -Active))   { Add-Content $Files.dmaTable $GameType.dmaTable }
        elseif (IsChecked -Elem $64BitCheckbox)                                       { & $Files.tool.TabExt $GetROM.in | Out-Host }
        else                                                                          { & $Files.tool.TabExt32 $GetROM.in | Out-Host }
        & $Files.tool.ndec $GetROM.in $GetROM.decomp | Out-Host
        if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force }

        if (!(DowngradeROM -Decompress $Decompress -Hash $HashSum)) { return }
    }
    elseif ($GameType.decompress -eq 2) {
        UpdateStatusLabel -Text ("Extending " + $GameType.mode + " ROM...")

        if (!(IsSet -Elem $GamePatch.extend -Min 18 -Max 64)) {
            UpdateStatusLabel -Text 'Failed. Could not extend SM64 ROM. Make sure the "extend" value is between 18 and 64.'
            return $False
        }

        if (Test-Path -LiteralPath $GetROM.decomp -PathType Leaf)   { & $Files.tool.sm64extend $GetROM.decomp -s $GamePatch.extend $GetROM.decomp | Out-Host }
        else                                                        { & $Files.tool.sm64extend $GetROM.in -s $GamePatch.extend $GetROM.decomp | Out-Host }
    }

    if ($IsWiiVC) { Remove-Item -LiteralPath $GetROM.in }

    return $True

}



#==============================================================================================================================================================================================
function CompressROM([Boolean]$Decompress) {
    
    if (!(Test-Path -LiteralPath $GetROM.decomp -PathType Leaf)) { return }

    if ($GameType.decompress -eq 1) {
        UpdateStatusLabel -Text ("Compressing " + $GameType.mode + " ROM...")

        if ($Settings.Debug.KeepDecompressed -eq $True)   { Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.debug -Force }
        RemoveFile -LiteralPath $Files.archive
        if (IsChecked -Elem $64BitCheckbox)   { & $Files.tool.Compress $GetROM.decomp $GetROM.patched | Out-Null }
        else                                  { & $Files.tool.Compress32 $GetROM.decomp $GetROM.patched | Out-Null }
    }
    elseif ($GameType.decompress -eq 2) { Move-Item -LiteralPath $GetROM.decomp -Destination $GetROM.patched -Force }

}



#==============================================================================================================================================================================================
function CompressROMC() {
    
    if ($GameType.romc -ne 2) { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType.mode + " VC ROM...")

    RemoveFile -LiteralPath $GetROM.romc
    & $Files.tool.romc e $GetROM.in $GetROM.romc | Out-Null
    Move-Item -LiteralPath $GetROM.romc -Destination $GetROM.in -Force

}



#==============================================================================================================================================================================================
function PatchRedux([Boolean]$Decompress) {
    
    # BPS PATCHING REDUX #
    if ( (IsChecked $Patches.Redux -Active) -and (IsSet -Elem $GamePatch.redux.file) ) {

        if ( !$Decompress -and !(Test-Path -LiteralPath $GetROM.decomp) ) { Copy-Item -LiteralPath $GetROM.in -Destination $GetROM.decomp -Force }

        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " REDUX...")

        # Redux patch
        if (IsSet -Elem $GamePatch.redux.file) { ApplyPatch -File $GetROM.decomp -Patch $GamePatch.redux.file }

        if ($GameType.decompress -eq 1 -and (IsSet -Elem $GameType.dmaTable) ) {
            RemoveFile -LiteralPath $Files.dmaTable
            Add-Content $Files.dmaTable $GameType.dmaTable
        }
    }

}



#==============================================================================================================================================================================================
function ExtendROM() {
    
    if ($GameType.romc -ne 1) { return }

    $Bytes = @(08, 00, 00, 00)
    $ByteArray = [IO.File]::ReadAllBytes($GetROM.in)
    [io.file]::WriteAllBytes($GetROM.in, $Bytes + $ByteArray)

    $ByteArray = $null

}



#==============================================================================================================================================================================================
function CheckGameID() {
    
    # Return if freely patching, injecting or extracting
    if ($GameType.checksum -eq 0 -or $Settings.Debug.IgnoreChecksum -eq $True) { return $True }

    # Set the status label.
    UpdateStatusLabel -Text "Checking GameID in .tmd..."

    # Get the ".tmd" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.tmd)
    
    $CompareArray = ($GameType.vc_gameID.ToCharArray() | % { [uint32][char]$_ })
    $CompareAgainst = $ByteArray[400..(403)]

    # Check each value of the array.
    for ($i=0; $i-le 4; $i++) {
        # The current values do not match
        if ($CompareArray[$i] -ne $CompareAgainst[$i]) {
            # This is not a vanilla entry.
            UpdateStatusLabel -Text ("Failed! This is not an vanilla " + $GameType.mode + " USA VC WAD file.")
            # Stop wasting time.
            return $False
        }
    }

    $CompareArray = $null
    $CompareAgainst = $null

    return $True

}



#==============================================================================================================================================================================================
function HackOpeningBNRTitle([String]$Title) {
    
    # Set the status label.
    UpdateStatusLabel -Text "Hacking in Opening.bnr custom title..."

    # Get the "00000000.app" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile00)

    # Initially assume the two chunks of data are identical.
    $Identical = $True

    $Start = 0

    $CompareArray = $ByteArray[(GetDecimal -Hex "F1")..((GetDecimal -Hex "F1") + $VCTitleLength)]

    # Scan only the contents of the IMET header within the file.
    for ($i=(GetDecimal -Hex "80"); $i-lt (GetDecimal -Hex "62F"); $i++) {
        $CompareAgainst = $ByteArray[$i..($i + $VCTitleLength)]

        $Matches = $True
        for ($j=0; $j -lt $CompareAgainst.Length; $j++) {
            if ($CompareAgainst[$j] -notcontains $CompareArray[$j]) { $Matches = $False }
        }

        if ($Matches -eq $True) {
            for ($j=0; $j-lt $VCTitleLength; $j++) { $ByteArray[$i + ($j*2)] = 0 }
            for ($j=0; $j-lt $Title.Length; $j++) { $ByteArray[$i + ($j*2)] = [uint32][char]$Title.Substring($j, 1) }
            $i += $VCTitleLength
        }        
    }

    # Overwrite the patch file with the extended file.
    [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)
    $ByteArray = $null

}



#==============================================================================================================================================================================================
function HackROMGameTitle([String]$Title, [String]$GameID) {
    
    if ($Settings.Debug.NoHeaderChange -eq $True) { return }
    if (StrLike -str $Command -val "Patch Header") { Copy-Item -LiteralPath $GetROM.in -Destination $GetROM.patched -Force }
    if (!(Test-Path -LiteralPath $GetROM.patched -PathType Leaf)) { return }

    UpdateStatusLabel -Text "Hacking in Custom Title and GameID..."
    
    if ( (IsSet -Elem $GameConsole.rom_title_offset) -and  (IsSet -Elem $GameConsole.rom_title_length -Min 1) -and ($GameConsole.rom_title -gt 0) ) {
        $offset = $GameConsole.rom_title_offset
        if ($GameConsole.mode -eq "SNES" -and (IsSet -Elem $GameConsole.rom_title_offset_2) ) {
            if (CheckSNESHeader -Offset (GetDecimal -Hex $GameConsole.rom_title_offset_2) ) { $offset = $GameConsole.rom_title_offset_2 }
        }
        $emptyTitle = foreach ($i in 1..$GameConsole.rom_title_length) { 20 }
        if ($GameConsole.rom_title_uppercase -gt 0) { $Title = $Title.ToUpper() }
        ChangeBytes -File $GetROM.patched -Offset $Offset -Values $emptyTitle
        ChangeBytes -File $GetROM.patched -Offset $offset -Values ($Title.ToCharArray() | % { [uint32][char]$_ }) -IsDec $True
        $offset = $emptyTitle = $null
    }
    if ( (IsSet -Elem $GameConsole.rom_gameID_offset) -and ($GameConsole.rom_gameID -gt 0)) { ChangeBytes -File $GetROM.patched -Offset $GameConsole.rom_gameID_offset -Values ($GameID.ToCharArray() | % { [uint32][char]$_ }) -IsDec $True }

}



#==============================================================================================================================================================================================
function CheckSNESHeader([int]$Offset) {
    
    $ROM = [IO.File]::ReadAllBytes($GetROM.patched)
    for ($i=$Offset; $i -lt ($Offset + $GameConsole.rom_title_length); $i++) {
        if ( ($ROM[$i] -lt 32) -or ($ROM[$i] -gt 122) ) { return $False }
    }

    if (!(IsSet -Elem $ROM[$Offset + $GameConsole.rom_title_length] -Min 32 -Max 64)) { return $False }
    if ($ROM[$Offset + $GameConsole.rom_title_length + 3] -gt 10) { return $False }
    if ($ROM[$Offset + $GameConsole.rom_title_length + 4] -gt 10) { return $False }

    return $True

}



#==============================================================================================================================================================================================
function RepackU8AppFile() {
    
    # The ROM is located witin the "00000005.app" file
    if ($GameConsole.appFile -eq "00000005.app") {
        UpdateStatusLabel -Text 'Repacking "00000005.app" file...'                # Set the status label
        RemovePath -LiteralPath $WadFile.AppFile05                                # Remove the original app file as its going to be replaced
        & $Files.tool.wszst 'C' $WadFile.AppPath05 '-d' $WadFile.AppFile05        # Repack the file using wszst
        $AppByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile05)               # Get the file as a byte array
        for ($i=16; $i -le 31; $i++) { $AppByteArray[$i] = 0 }                    # Overwrite the values in 0x10 with zeroes. I don't know why, I'm just matching the output from another program
        [IO.File]::WriteAllBytes($WadFile.AppFile05, $AppByteArray)               # Overwrite the patch file with the extended file
        RemovePath -LiteralPath $WadFile.AppPath05                                # Remove the extracted WAD folder
    }

    # The ROM is located witin the "00000001.app" VC emulator file
    elseif ($GameConsole.appFile -eq "00000001.app") {
        UpdateStatusLabel -Text 'Re-injecting ROM into "00000001.app" file...'    # Set the status label
        $ByteArrayROM = [IO.File]::ReadAllBytes($GetROM.patched)
        $ByteArrayApp = [IO.File]::ReadAllBytes($WADFile.AppFile01)

        for ($i=0; $i -lt (GetDecimal -Hex $WADFile.Length); $i++) {
            $ByteArrayApp[$i + (GetDecimal -Hex $WADFile.Offset)] = $ByteArrayROM[($i)]
        }

        [io.file]::WriteAllBytes($WADFile.AppFile01, $ByteArrayApp)
        $ByteArrayROM = $ByteArrayApp = $null
    }

}



#==============================================================================================================================================================================================
function RepackWADFile([String]$GameID) {
    
    # Set the status label.
    UpdateStatusLabel -Text "Repacking patched WAD file..."
    
    # Loop through all files in the extracted WAD folder.
    foreach($File in Get-ChildItem -LiteralPath $WadFile.Folder -Force) {
        # Move the file to the same folder as the unpacker tool.
        RemoveFile -LiteralPath ($Paths.WiiVC + "\" + $File.Name)
        Move-Item -LiteralPath $File.FullName -Destination $Paths.WiiVC
        
        # Create an entry for the database.
        $ListEntry = $RepackPath + '\' + $File.Name
        
        # Some files need to be fed into the tool so keep track of them.
        switch ($File.Extension) {
            '.tik'  { $tik  = $Paths.WiiVC + '\' + $File.Name }
            '.tmd'  { $tmd  = $Paths.WiiVC + '\' + $File.Name }
            '.cert' { $cert = $Paths.WiiVC + '\' + $File.Name }
        }
    }

    # We need to be in the same path as some files so just jump there.
    Push-Location $Paths.WiiVC

    # Repack the WAD using the new files.
    & $Files.tool.wadpacker $tik $tmd $cert $WadFile.Patched '-sign' '-i' $GameID

    # If the patched file was created or could not be created.
    if (TestPath -LiteralPath $WadFile.Patched) { 
        # [System.Media.SystemSounds]::Beep.Play()                                         # Play a sound when it is finished.
        UpdateStatusLabel -Text "Complete! Patched Wii VC WAD was successfully patched."   # Set the status label.
    }
    else { UpdateStatusLabel -Text "Failed! Patched Wii VC WAD was not created." }

    # Remove the folder the extracted files were in, and delete files
    RemovePath -LiteralPath $WadFile.Folder

    # Doesn't matter, but return to where we were.
    Pop-Location

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function MainFunction
Export-ModuleMember -Function ApplyPatch
Export-ModuleMember -Function Cleanup