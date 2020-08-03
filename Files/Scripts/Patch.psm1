function MainFunction([String]$Command, [String]$PatchedFileName) {
    
    # Header
    $Header = @($GameType.n64_title, $GameType.n64_gameID, $GameType.wii_title, $GameType.wii_gameID)
    $Header = SetHeader -Header $Header -N64Title $GamePatch.n64_title -N64GameID $GamePatch.n64_gameID -WiiTitle $GamePatch.wii_title -WiiGameID $GamePatch.wii_gameID

    # Hash
    if (IsSet -Elem $GamePatch.Hash)   { $global:CheckHashSum = $GamePatch.Hash }
    else                               { $global:CheckHashSum = $GameType.Hash }

    # Output
    if (!(IsSet -Elem $PatchedFileName)) { $PatchedFileName = "_patched" }
    
    # Downgrade, Expand Memory, Remap D-Pad
    if ($IsWiiVC) {
        if ($PatchVCDowngrade.Visible -and (StrLike -str $Command -val "Force Downgrade") )               { $PatchVCDowngrade.Checked = $True }
        elseif ($PatchVCDowngrade.Visible -and (StrLike -str $Command -val "No Downgrade") )              { $PatchVCDowngrade.Checked = $False }
        
        if ($GameType.patch_vc -ge 3) {
            if ($PatchVCExpandMemory.Visible -and (StrLike -str $Command -val "Force Expand Memory") )    { $PatchVCExpandMemory.Checked = $True }
            elseif ($PatchVCExpandMemory.Visible -and (StrLike -str $Command -val "No Expand Memory") )   { $PatchVCExpandMemory.Checked = $False }
    
            if ($PatchVCRemapDPad.Visible -and (StrLike -str $Command -val "Force Remap D-Pad") )         { $PatchVCRemapDPad.Checked = $True }
            elseif ($PatchVCRemapDPad.Visible -and (StrLike -str $Command -val "No Remap D-Pad") )        { $PatchVCRemapDPad.Checked = $False }
        }
    }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Patch VC") -and !(StrLike -str $Command -val "Extract") ) {
        # Redux
        if ( (IsChecked -Elem $PatchReduxCheckbox) -and (IsSet -Elem $GamePatch.redux.file)) {
            $PatchVCRemapDPad.Checked = $True
            if ($GameType.patch_vc -eq 4) {
                $PatchVCExpandMemory.Checked = $True
                if ($IsWiiVC -and !(IsChecked -Elem $PatchVCRemapCDown -Visible) -and !(IsChecked -Elem $PatchVCRemapZ -Visible) ) { $PatchVCLeaveDPadUp.Checked = $True }
            }
            $Header = SetHeader -Header $Header -N64Title $GamePatch.redux.n64_title -N64GameID $GamePatch.redux.n64_gameID -WiiTitle $GamePatch.redux.wii_title -WiiGameID $GamePatch.redux.wii_gameID
            if (IsSet -Elem $GamePatch.redux.output) { $PatchedFileName = $GamePatch.redux.output }
            if (StrLike -str $Command -val "Inject") { $PatchedFileName += "_injected" }
        }

        # Language Patch
        $LanguagePatch = $null
        if (IsSet -Elem $GamePatch.languages -MinLength 1) {
            for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
                if ($Languages[$i].checked) { $Item = $i }
            }
            $Header = SetHeader -Header $Header -N64Title $GamePatch.languages[$Item].n64_title -N64GameID $GamePatch.languages[$Item].n64_gameID -WiiTitle $GamePatch.languages[$Item].wii_title -WiiGameID $GamePatch.languages[$Item].wii_gameID
            if (IsSet -Elem $GamePatch.languages[$Item].output) { $PatchedFileName = $GamePatch.languages[$Item].output }
            $LanguagePatch = $GamePatch.languages[$Item].file
        }
    }
    
    # GameID / Title
    if ($CustomHeaderCheckbox.Checked) {
        if ($CustomTitleTextBox.TextLength -gt 0)    { $Header[0 + [int]$IsWiiVC * 2] = $CustomTitleTextBox.Text }

        if (!(IsSet -Elem $GamePatch.languages[$Item].n64_gameID)) {
            if ($CustomGameIDTextbox.TextLength -eq 4)   { $Header[1 + [int]$IsWiiVC * 2] = $CustomGameIDTextBox.Text }
        }
    }

    # Decompress
    $Decompress = $False
    if ($GamePatch.file -like "*\Decompressed\*") { $Decompress = $True }
    if ($LanguagePatch -like "*\Decompressed\*") { $Decompress = $True }
    if ($GameType.decompress -eq 1) {
        if ( (IsChecked -Elem $PatchReduxCheckbox -Visible) -or (IsChecked -Elem $PatchOptionsCheckbox -Visible) ) { $Decompress = $True }
    }
    
    # Patch File Name
    if (IsSet -Elem $Files.Z64 -MinLength 4) { $global:Z64File = SetZ64Parameters -Z64Path $global:GameZ64 -PatchedFileName $PatchedFileName }

    # GO!
    MainFunctionPatch -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress
    EnableGUI -Enable $True
    Cleanup

}



#==============================================================================================================================================================================================
function SetHeader([String[]]$Header, [String]$N64Title, [String]$N64GameID, [String]$WiiTitle, [String]$WiiGameID) {
    
    if (IsSet -Elem $N64Title)    { $Header[0] = $N64Title }
    if (IsSet -Elem $N64GameID)   { $Header[1] = $N64GameID }
    if (IsSet -Elem $WiiTitle)    { $Header[2] = $WiiTitle }
    if (IsSet -Elem $WiiGameID)   { $Header[3] = $WiiGameID }
    return $Header

}



#==============================================================================================================================================================================================
function MainFunctionPatch([String]$Command, [String[]]$Header, [String]$PatchedFileName, [Boolean]$Decompress) {
    
    if ($Settings.Debug.Console -eq $True) {
        if ( (WriteDebug -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress) -eq $True) { return }
    }

    # Step 01: Disable the main dialog, allow patching and delete files if they still exist.
    EnableGUI -Enable $False

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 02: Extract the contents of the WAD file.
        ExtractWADFile -PatchedFileName $PatchedFileName

        # Step 03: Check the GameID to be vanilla.
        if (!(CheckGameID -Command $Command)) { return }

        # Step 04: Replace the Virtual Console emulator within the WAD file.
        PatchVCEmulator -Command $Command

        # Step 05: Extract "00000005.app" file to get the ROM.
        ExtractU8AppFile

        # Step 06: Do some initial patching stuff for the ROM for VC WAD files.
        if (!(PatchVCROM -Command $Command)) { return }

        # Step 07: Downgrade the ROM if required
        if (!(DowngradeROM -Command $Command)) { return }
    }

    # Step 08: Compare HashSums for untouched ROM Files
    if (!(CompareHashSums -Command $Command)) { return }

    if ( !(StrLike -str $Command -val "Inject") -and !(StrLike -str $Command -val "Apply Patch") -and !(StrLike -str $Command -val "Patch VC") -and !(StrLike -str $Command -val "Extract") ) {
        # Step 09: Apply option patches for SM64.
        if ($GameType.mode -eq "Super Mario 64") { PatchOptionsSM64 }

        # Step 10: Decompress the ROM if required.
        if (!(DecompressROM -Decompress $Decompress)) { return }

        # Step 11: Apply option patches for Zelda.
        if ($GameType.decompress -eq 1) { PatchOptionsZelda }

        # Step 12: Patch and extend the ROM file with the patch through Floating IPS.
        if (!(PatchROM)) { return }

        # Step 13: Compress the decompressed ROM if required.
        CompressROM -Decompress $Decompress
    }
    elseif (StrLike -str $Command -val "Apply Patch") {
        # Step 14: Apply provided BPS Patch
        if (!(ApplyPatchROM)) { return }
    }

    # Step 15: Update the .Z64 ROM CRC
    UpdateROMCRC

    # Step 16: Hack the Game Title and GameID of a N64 ROM
    HackN64GameTitle -Title $Header[0] -GameID $Header[1]

    # Step 17: Debug
    CreateDebugPatches

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 18: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        ExtendROM

        # Step 19: Compress the ROMC again if possible.
        CompressROMC

        # Step 20: Hack the Channel Title.
        HackOpeningBNRTitle -Title $Header[2]

        # Step 21: Repack the "00000005.app" with the updated ROM file 
        RepackU8AppFile
        
        # Step 22: Repack the WAD file with the updated APP file.
        RepackWADFile -GameID $Header[3]
    }

    # Step 23: Final message.
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
    Write-Host "Downgrade:" (IsChecked $PatchVCDowngrade -Visible)
    Write-Host "Decompress:" $Decompress
    Write-Host "Hash:" $CheckHashSum
    Write-Host "Wii VC:" $IsWiiVC
    Write-Host "ROM File:" $Files.ROM
    Write-Host "WAD File Path:" $Files.WAD
    Write-Host "Z64 File Path:" $Files.Z64
    Write-Host "BPS File Path:" $Files.BPS

    return $Settings.Debug.Stop

}



#==============================================================================================================================================================================================
function Cleanup() {
    
    RemovePath -LiteralPath ($Paths.Master + '\cygdrive')
    RemoveFile -LiteralPath $Files.flipscfg
    RemoveFile -LiteralPath $Files.stackdump

    if ($IsWiiVC) {
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
    }

    RemoveFile -LiteralPath $Files.dmaTable
    RemoveFile -LiteralPath $Files.archive
    RemoveFile -LiteralPath $Files.cleanROM
    RemoveFile -LiteralPath $Files.cleanDecompressedROM
    RemoveFile -LiteralPath $Files.decompressedROM
    RemoveFile -LiteralPath $Files.masterQuestROM

    $Global:ByteArrayGame = $null

    foreach($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }

    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {
    
    if ($Settings.Debug.NoCRCChange -eq $True) { return }
    if (!(Test-Path -LiteralPath $Files.patchedROM -PathType Leaf)) { Copy-Item -LiteralPath $Files.ROM -Destination $Files.patchedROM }
    & $Files.tool.rn64crc $Files.PatchedROM -update | Out-Host
    if ($Settings.KeepDecompressed -eq $True) { & $Files.tool.rn64crc $Files.DebugROM -update | Out-Host }

}



#==============================================================================================================================================================================================
function CreateDebugPatches() {
    
    if ($Settings.Debug.CreateBPS -ne $True) { return }
    if ( (Test-Path -LiteralPath $Files.cleanDecompressedROM -PathType Leaf) -and (Test-Path -LiteralPath $Files.decompressedROM -PathType Leaf) ) { & $Files.tool.flips --create --bps $Files.cleanDecompressedROM $Files.decompressedROM $Files.decompressedBPS | Out-Host }
    & $Files.tool.flips --create --bps $Files.cleanROM $Files.patchedROM $Files.compressedBPS | Out-Host

}



#==============================================================================================================================================================================================
function SetWADParameters([String]$WADPath, [String]$FolderName, [String]$PatchedFileName) {
    
    # Create a hash table.
    $WADFile = @{}

    # Get the WAD as an item object.
    $WADItem = Get-Item -LiteralPath $WADPath
    
    # Store some stuff about the WAD that I'll probably reference.
    $WADFile.Name         = $WADItem.BaseName
    $WADFile.Folder       = $Paths.WiiVC + '\' + $FolderName
    $WADFile.FolderName   = $FolderName

    $WADFile.AppFile00    = $WADFile.Folder + '\00000000.app'
    $WADFile.AppPath00    = $WADFile.Folder + '\00000000'
    $WADFile.AppFile01    = $WADFile.Folder + '\00000001.app'
    $WADFile.AppPath01    = $WADFile.Folder + '\00000001'
    $WADFile.AppFile05    = $WADFile.Folder + '\00000005.app'
    $WADFile.AppPath05    = $WADFile.Folder + '\00000005'

    $WADFile.cert         = $WADFile.Folder + '\' + $FolderName + '.cert'
    $WADFile.tik          = $WADFile.Folder + '\' + $FolderName + '.tik'
    $WADFile.tmd          = $WADFile.Folder + '\' + $FolderName + '.tmd'
    $WADFile.trailer      = $WADFile.Folder + '\' + $FolderName + '.trailer'
    
    if ($GameType.romc -gt 0)   { $WADFile.ROMFile = $WADFile.AppPath05 + '\romc' }
    else                        { $WADFile.ROMFile = $WADFile.AppPath05 + '\rom' }
    $WADFile.Patched      = $WADItem.DirectoryName + '\' + $WADFile.Name + $PatchedFileName + '.wad'
    $WADFile.Extracted    = $WADItem.DirectoryName + '\' + $WADFile.Name + "_extracted_rom" + '.z64'
    $WADFile.Debug        = $WADItem.DirectoryName + '\' + $WADFile.Name + "_decompressed" + '.z64'

    SetROMFile

    # Set it to a global value.
    return $WADFile

}



#==============================================================================================================================================================================================
function SetZ64Parameters([String]$Z64Path, [String]$PatchedFileName) {
    
    # Create a hash table.
    $Z64File = @{}

    # Get the ROM as an item object.
    $Z64Item = Get-Item -LiteralPath $Z64Path
    
    # Store some stuff about the ROM that I'll probably reference.
    $Z64File.Name      = $Z64Item.BaseName
    $Z64File.Path      = $Z64Item.DirectoryName

    $Z64File.ROMFile   = $Z64Path
    $Z64File.Patched   = $Z64File.Path + '\' + $Z64File.Name + $PatchedFileName + '.z64'
    $Z64File.Debug   = $Z64File.Path + '\' + $Z64File.Name + "_decompressed" + '.z64'

    SetROMFile

    # Set it to a global value.
    return $Z64File

}



#==============================================================================================================================================================================================
function SetROMFile() {
    
    if ($IsWiiVC) {
        $Files.ROM = $Files.patchedROM = $WADFile.ROMFile
        $Files.DebugROM = $WADFile.Debug
    }
    else {
        $Files.ROM = $Z64File.ROMFile
        $Files.patchedROM = $Z64File.Patched
        $Files.DebugROM = $Z64File.Debug
    }

    if ($Settings.Debug.CreateBPS -eq $True) {
        $Files.compressedBPS = $Paths.Base + "\compressed.bps"
        $Files.decompressedBPS = $Paths.Base + "\decompressed.bps"
    }

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
    foreach($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) {
        # There will only be one folder, the one we want.
        if ($Folder.PSIsContainer) {
            # Remember the path to this folder.
            $global:WADFile = SetWADParameters -WADPath $GameWAD -FolderName $Folder.Name -PatchedFileName $PatchedFileName
        }
    }

    # Doesn't matter, but return to where we were.
    Pop-Location

}



#==============================================================================================================================================================================================
function ExtractU8AppFile() {

    # Set the status label.
    UpdateStatusLabel -Text 'Extracting "00000005.app" file...'
    
    # Unpack the file using wszst.
    & $Files.tool.wszst 'X' $WADFile.AppFile05 '-d' $WADFile.AppPath05 | Out-Null

    # Remove all .T64 files when selected
    if ($PatchVCRemoveT64.Checked) {
        Get-ChildItem $WADFile.AppPath05 -Include *.T64 -Recurse | Remove-Item
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
        
        if ($PatchVCExpandMemory.Checked) {
        ChangeBytes -File $WadFile.AppFile01 -Offset "2EB0" -Values @("60", "00", "00", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "5BF44" -Values @("3C", "80", "72", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "5BFD7" -Values @("00")
        }

        if ($PatchVCRemapDPad.Checked) {
            if (!$PatchVCLeaveDPadUp.Checked) { ChangeBytes -File $WadFile.AppFile01 -Offset "16BAF0" -Values @("08", "00") }
        ChangeBytes -File $WadFile.AppFile01 -Offset "16BAF4" -Values @("04", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "16BAF8" -Values @("02", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "16BAFC" -Values @("01", "00")
        }

        if ($PatchVCRemapCDown.Checked)         { ChangeBytes -File $WadFile.AppFile01 -Offset "16BB04" -Values @("00", "20") }
        if ($PatchVCRemapZ.Checked)             { ChangeBytes -File $WadFile.AppFile01 -Offset "16BAD8" -Values @("00", "20") }

    }

    elseif ($GameType.mode -eq "Majora's Mask") {
        
        if ($PatchVCExpandMemory.Checked -or $PatchVCRemapDPad.Checked -or $PatchVCRemapCDown.Checked -or $PatchVCRemapZ.Checked) { & $Files.tool.lzss -d $WADFile.AppFile01 | Out-Host }

        if ($PatchVCExpandMemory.Checked) {
        ChangeBytes -File $WadFile.AppFile01 -Offset "10B58" -Values @("3C", "80", "00", "C0")
        ChangeBytes -File $WadFile.AppFile01 -Offset "4BD20" -Values @("67", "E4", "70", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "4BC80" -Values @("3C", "A0", "01", "00")
        }

        if ($PatchVCRemapDPad.Checked) {
        ChangeBytes -File $WadFile.AppFile01 -Offset "148514" -Values @("08", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "148518" -Values @("04", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "14851C" -Values @("02", "00")
        ChangeBytes -File $WadFile.AppFile01 -Offset "148520" -Values @("01", "00")
        }

        if ($PatchVCRemapCDown.Checked)         { ChangeBytes -File $WadFile.AppFile01 -Offset "148528" -Values @("00", "20") }
        if ($PatchVCRemapZ.Checked)             { ChangeBytes -File $WadFile.AppFile01 -Offset "1484F8" -Values @("00", "20") }

        if ($PatchVCExpandMemory.Checked -or $PatchVCRemapDPad.Checked -or $PatchVCRemapCDown.Checked -or $PatchVCRemapZ.Checked) { & $Files.tool.lzss -evn $WADFile.AppFile01 | Out-Host }

    }

    elseif ($GameType.mode -eq "Super Mario 64") {
        
        if ($PatchVCRemoveFilter.Checked -and (StrLike -str $Command -val "Multiplayer") )   { ChangeBytes -File $WadFile.AppFile01 -Offset "53124" -Values @("60", "00", "00", "00") }
        elseif ($PatchVCRemoveFilter.Checked)                                                { ChangeBytes -File $WadFile.AppFile01 -Offset "46210" -Values @("4E", "80", "00", "20") }

    }

}



#==============================================================================================================================================================================================
function PatchVCROM([String]$Command) {

    if (StrLike -str $Command -val "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabel -Text ("Initial patching of " + $GameType.mode + " ROM...")
    
    # Extract ROM if required
    if (StrLike -str $Command -val "Extract") {
        if (Test-Path -LiteralPath $Files.ROM -PathType Leaf) {
            Move-Item -LiteralPath $Files.ROM -Destination $WADFile.Extracted
            UpdateStatusLabel -Text ("Successfully extracted " + $GameType.mode + " ROM.")
        }
        else { UpdateStatusLabel -Text ("Could not extract " + $GameType.mode + " ROM. Is it a Majora's Mask or Paper Mario ROM?") }

        return $False
    }

    # Replace ROM if needed
    if (StrLike -str $Command -val "Inject") {
        if (Test-Path -LiteralPath $Files.ROM -PathType Leaf) {
            Remove-Item -LiteralPath $Files.ROM
            if ((Test-Path -LiteralPath $Files.Z64 -PathType Leaf)) { Copy-Item -LiteralPath $Files.Z64 -Destination $Files.ROM }
            else {
                UpdateStatusLabel -Text ("Could not inject " + $GameType.mode + " ROM. Did you move or rename the ROM file?")
                return $False
            }
        }
        else {
            UpdateStatusLabel -Text ("Could not inject " + $GameType.mode + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
            return $False
        }
    }

    # Decompress romc if needed
    if ($GameType.romc -ge 1 -and !(StrLike -str $Command -val "Inject") ) {  

        if (Test-Path -LiteralPath $Files.ROM -PathType Leaf) {
            RemoveFile -LiteralPath $Files.OutROM
            if ($GameType.romc -eq 1)       { & $Files.tool.romchu $Files.ROM $Files.OutROM | Out-Null }
            elseif ($GameType.romc -eq 2)   { & $Files.tool.romc d $Files.ROM $Files.OutROM | Out-Null }
            Move-Item -LiteralPath $Files.OutROM -Destination $Files.ROM -Force
        }
        else {
            UpdateStatusLabel -Text ("Could not decompress " + $GameType.mode + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
            return $False
        }

    }

    # Get the file as a byte array so the size can be analyzed.
    $ByteArray = [IO.File]::ReadAllBytes($Files.ROM)
    
    # Create an empty byte array that matches the size of the ROM byte array.
    $NewByteArray = New-Object Byte[] $ByteArray.Length
    
    # Fill the entire array with junk data. The patched ROM is slightly smaller than 8MB but we need an 8MB ROM.
    for ($i=0; $i-lt $ByteArray.Length; $i++) { $NewByteArray[$i] = 255 }

    $ByteArray = $null

    return $True

}



#==============================================================================================================================================================================================
function DowngradeROM([String]$Command) {
    
    if (StrLike -str $Command -val "Inject") { return $True }

    # Downgrade a ROM if it is required first
    if ( (IsChecked $PatchVCDowngrade -Visible) -and (IsSet -Elem $GameType.downgrade) ) {
        $HashSum = (Get-FileHash -Algorithm MD5 $Files.ROM).Hash
        $Applied = $False

        Foreach ($Item in $GameType.downgrade) {
            if ($HashSum -eq $Item.hash) {
                if (!(ApplyPatch -File $Files.ROM -Patch $Item.file)) {
                    UpdateStatusLabel -Text "Failed! Could not apply downgrade patch."
                    return $False
                }
                $Applied = $True
            }
        }

        if (!$Applied) {
            UpdateStatusLabel -Text "Failed! Ocarina of Time ROM does not match revision 1 or 2."
            return $False
        }

        $global:CheckHashSum = (Get-FileHash -Algorithm MD5 $Files.ROM).Hash
        $HashSum = $Applied = $null
    }

    return $True
    
}



#==============================================================================================================================================================================================
function CompareHashSums([String]$Command) {
    
    if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $Files.ROM -Destination $Files.cleanROM -Force }

    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Patch VC") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }

    $ContinuePatching = $True
    $HashSum = (Get-FileHash -Algorithm MD5 $Files.ROM).Hash

    if ($CheckHashSum -eq "Dawn & Dusk") {
        if ($HashSum -eq "5BD1FE107BF8106B2AB6650ABECD54D6")     { $GamePatch.file = "\Compressed\dawn_rev0.bps" }
        elseif ($HashSum -eq "721FDCC6F5F34BE55C43A807F2A16AF4") { $GamePatch.file = "\Compressed\dawn_rev1.bps" }
        elseif ($HashSum -eq "57A9719AD547C516342E1A15D5C28C3D") { $GamePatch.file = "\Compressed\dawn_rev2.bps" }
        else { $ContinuePatching = $False }
    }
    elseif ($HashSum -ne $CheckHashSum) { $ContinuePatching = $False }

    if (!$ContinuePatching) {
        UpdateStatusLabel -Text "Failed! ROM does not match the patching button target. ROM has left unchanged."
        return $False
    }

    $HashSum = $Null
    return $True

}



#==============================================================================================================================================================================================
function PatchROM() {

    if (!(IsSet $GamePatch.file)) { return $True }
    
    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " ROM with patch file...")

    # Apply the selected patch to the ROM, if it is provided
    if ($IsWiiVC -and $Decompress)         { if (!(ApplyPatch -File $Files.decompressedROM -Patch $GamePatch.file))              { return $False } }
    elseif ($IsWiiVC -and !$Decompress)    { if (!(ApplyPatch -File $Files.patchedROM -Patch $GamePatch.file))                   { return $False } }
    elseif (!$IsWiiVC -and $Decompress)    { if (!(ApplyPatch -File $Files.decompressedROM -Patch $GamePatch.file))              { return $False } }
    elseif (!$IsWiiVC -and !$Decompress)   { if (!(ApplyPatch -File $Files.ROM -Patch $GamePatch.file -New $Files.patchedROM))   { return $False } }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatchROM() {

    $HashSum1 = (Get-FileHash -Algorithm MD5 $Files.ROM).Hash
    if (!(ApplyPatch -File $Files.ROM -Patch $Files.BPS -New $Files.patchedROM -FullPath)) { return $False }
    $HashSum2 = (Get-FileHash -Algorithm MD5 $Files.patchedROM).Hash
    if ($HashSum1 -eq $HashSum2) {
        if ($IsWiiVC -and $GameType.downgrade -and !(IsChecked $PatchVCDowngrade -Visible) )      { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?" }
        elseif ($IsWiiVC -and $GameType.downgrade -and (IsChecked $PatchVCDowngrade -Visible) )   { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" }
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
        UpdateStatusLabel -Text "Failed! Could not find ROM file."
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

    if ($ExternalScript) { Write-Host $Patch }

    # Patching
    if ($Patch -like "*.bps*" -or $Patch -like "*.ips*") {
        if ($New.Length -gt 0) { & $Files.tool.flips --ignore-checksum --apply $Patch $File $New | Out-Host }
        else { & $Files.tool.flips --ignore-checksum $Patch $File | Out-Host }
    }
    elseif ($Patch -like "*.xdelta*" -or $Patch -like "*.vcdiff*") {
        if ($Patch -like "*.xdelta*")       { $File = $Files.tool.xdelta }
        elseif ($Patch -like "*.vcdiff*")   { $File = $Files.tool.xdelta3 }

        if ($New.Length -gt 0) {
            RemoveFile -LiteralPath $New
            & $File -d -s $File $Patch $New | Out-Host
        }
        else {
            & $File -d -s $File $Patch ($File + ".ext") | Out-Host
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
    
    UpdateStatusLabel -Text ("Decompressing " + $GameType.mode + " ROM...")

    if ($GameType.decompress -eq 1) {
        if (IsChecked -Elem $64BitCheckbox)   { & $Files.tool.TabExt $Files.ROM | Out-Host }
        else                                  { & $Files.tool.TabExt32 $Files.ROM | Out-Host }
        & $Files.tool.ndec $Files.ROM $Files.decompressedROM | Out-Host
        if ($Settings.Debug.CreateBPS -eq $True) { Copy-Item -LiteralPath $Files.decompressedROM -Destination $Files.cleanDecompressedROM -Force } 
    }
    elseif ($GameType.decompress -eq 2) {
        if (!(IsSet -Elem $GamePatch.extend -Min 18 -Max 64)) {
            UpdateStatusLabel -Text 'Failed. Could not extend SM64 ROM. Make sure the "extend" value is between 18 and 64.'
            return $False
        }

        if (Test-Path -LiteralPath $Files.decompressedROM -PathType Leaf)   { & $Files.tool.sm64extend $Files.decompressedROM -s $GamePatch.extend $Files.decompressedROM | Out-Host }
        else                                                                { & $Files.tool.sm64extend $Files.ROM -s $GamePatch.extend $Files.decompressedROM | Out-Host }
    }

    if ($IsWiiVC) { Remove-Item -LiteralPath $Files.ROM }

    return $True

}



#==============================================================================================================================================================================================
function CompressROM([Boolean]$Decompress) {
    
    if (!(Test-Path -LiteralPath $Files.decompressedROM -PathType Leaf)) { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType.mode + " ROM...")

    if ($GameType.decompress -eq 1) {
        if ($Settings.Debug.KeepDecompressed -eq $True)   { Copy-Item -LiteralPath $Files.decompressedROM -Destination $Files.debugROM -Force }
        RemoveFile -LiteralPath $Files.archive
        if (IsChecked -Elem $64BitCheckbox)   { & $Files.tool.Compress $Files.decompressedROM $Files.patchedROM | Out-Null }
        else                                  { & $Files.tool.Compress32 $Files.decompressedROM $Files.patchedROM | Out-Null }
    }
    elseif ($GameType.decompress -eq 2) { Move-Item -LiteralPath $Files.decompressedROM -Destination $Files.patchedROM -Force }

}



#==============================================================================================================================================================================================
function CompressROMC() {
    
    if ($GameType.romc -ne 2) { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType.mode + " VC ROM...")

    RemoveFile -LiteralPath $Files.OutROM
    & $Files.tool.romc e $Files.ROM $Files.OutROM | Out-Null
    Move-Item -LiteralPath $Files.OutROM -Destination $Files.ROM -Force

}



#==============================================================================================================================================================================================
function ExtractDungeon([String]$Path, [String]$Offset, [int]$Length) {
    
    if (Test-Path -LiteralPath $Path -PathType Container) { return }

    $Start = Get8Bit -Value ( (GetDecimal -Hex $Offset) )
    $End = Get8Bit -Value ( (GetDecimal -Hex $Start) + ($Length * 16) + 16)
    $Table = $ByteArrayGame[(GetDecimal -Hex $Start)..(GetDecimal -Hex $End)]
    CreateSubPath -Path $Path

    ExportBytesGame -Offset $Start -End $End -Output ($Path + "\table.dmaTable") 
    
    for ($i=0; $i -le $Length; $i++) {
        $Start = (Get8Bit -Value $Table[($i*16)+0]) + (Get8Bit -Value $Table[($i*16)+1]) + (Get8Bit -Value $Table[($i*16)+2]) + (Get8Bit -Value $Table[($i*16)+3])
        $End   = (Get8Bit -Value $Table[($i*16)+4]) + (Get8Bit -Value $Table[($i*16)+5]) + (Get8Bit -Value $Table[($i*16)+6]) + (Get8Bit -Value $Table[($i*16)+7])
        if ($i -eq 0)   { ExportBytesGame -Offset $Start -End $End -Output ($Path + "\scene.zscene") }
        else            { ExportBytesGame -Offset $Start -End $End -Output ($Path + "\room_" + ($i-1) + ".zmap") }
    }

}



#==============================================================================================================================================================================================
function ExtractAllDungeons([String]$Path) {
    
    if (!(Test-Path -LiteralPath $Path -PathType Container)) { CreateSubPath  -Path $Path }
    ExtractDungeon -Path ($Path + "\Inside the Deku Tree")     -Offset "BB40" -Length 12
    ExtractDungeon -Path ($Path + "\Dodongo's Cavern")         -Offset "B320" -Length 17
    ExtractDungeon -Path ($Path + "\Inside Jabu-Jabu's Belly") -Offset "BF50" -Length 16
    ExtractDungeon -Path ($Path + "\Forest Temple")            -Offset "B9C0" -Length 23
    ExtractDungeon -Path ($Path + "\Fire Temple")              -Offset "B800" -Length 27
    ExtractDungeon -Path ($Path + "\Water Temple")             -Offset "BCA0" -Length 23
    ExtractDungeon -Path ($Path + "\Shadow Temple")            -Offset "C060" -Length 23
    ExtractDungeon -Path ($Path + "\Spirit Temple")            -Offset "C450" -Length 29
    ExtractDungeon -Path ($Path + "\Ice Cavern")               -Offset "C630" -Length 12
    ExtractDungeon -Path ($Path + "\Bottom of the Well")       -Offset "CEA0" -Length 7
    ExtractDungeon -Path ($Path + "\Gerudo Training Ground")   -Offset "C230" -Length 11
    ExtractDungeon -Path ($Path + "\Inside Ganon's Castle")    -Offset "CCC0" -Length 20

}



#==============================================================================================================================================================================================
function PatchOptionsZelda() {
    

    if (!$Decompress) { return }


    
    # EXTRACT MQ DATA #
    if ($GameType.mode -eq "Ocarina of Time") {
        if ( (IsChecked -Elem $Options.MasterQuest -Enabled)) {
            ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\master_quest.bps" -New $Files.masterQuestROM
            $Global:ByteArrayGame = [IO.File]::ReadAllBytes($Files.masterQuestROM)
            ExtractAllDungeons -Path ($Paths.Games + "\Ocarina of Time\Binaries\Master Quest")
        }
        if ($Settings.Debug.Rev0DungeonFiles -eq $True) { # EXTRACT VANILLA DUNGEON DATA DEBUG #
            $Global:ByteArrayGame = [IO.File]::ReadAllBytes($Files.decompressedROM)
            ExtractAllDungeons -Path ($Paths.Games + "\Ocarina of Time\Binaries\Master Quest (Rev 0)")
        }
    }
    


    # BPS PATCHING REDUX #
    if ( (IsChecked $PatchReduxCheckbox -Visible) -and (IsSet -Elem $GamePatch.redux.file) ) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " REDUX...")
        if (IsSet -Elem $GamePatch.redux.file) { ApplyPatch -File $Files.decompressedROM -Patch $GamePatch.redux.file } # Redux

        if ($GameType.decompress -eq 1 -and (IsSet -Elem $GameType.dmaTable) ) {
            RemoveFile -LiteralPath $Files.dmaTable
            Add-Content $Files.dmaTable $GameType.dmaTable
        }
    }



    # BPS PATCHING LANGUAGE #
    if (IsSet -Elem $LanguagePatch) { # Language
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $Files.decompressedROM -Patch $LanguagePatch
    }



    # BPS PATCHING OPTIONS #
    if ( (IsChecked $PatchOptionsCheckbox -Visible) -and $GamePatch.options) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options BPS Patches...")
        if ($GameType.mode -eq "Ocarina of Time")     { PatchBPSOptionsOoT }
        elseif ($GameType.mode -eq "Majora's Mask")   { PatchBPSOptionsMM }
    }



    # BYTE PATCHING OPTIONS #
    if ( (IsChecked $PatchOptionsCheckbox -Visible) -and $GamePatch.options) {
        $Global:ByteArrayGame = [IO.File]::ReadAllBytes($Files.decompressedROM)

        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")
        if ($GameType.mode -eq "Ocarina of Time")     { PatchByteOptionsOoT }
        elseif ($GameType.mode -eq "Majora's Mask")   { PatchByteOptionsMM }

        [io.file]::WriteAllBytes($Files.decompressedROM, $ByteArrayGame) 
    }



    # LANGUAGE BYTE PATCHING OPTIONS #
    if ( (IsChecked $PatchOptionsCheckbox -Visible) -and $GamePatch.options) {
        $Global:ByteArrayGame = [IO.File]::ReadAllBytes($Files.decompressedROM)

        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options English...")
        if ($GameType.mode -eq "Ocarina of Time")     { PatchLanguageOptionsOoT }
        elseif ($GameType.mode -eq "Majora's Mask")   { PatchLanguageOptionsMM }

        [io.file]::WriteAllBytes($Files.decompressedROM, $ByteArrayGame) 
    }

}



#==============================================================================================================================================================================================
function ExtendROM() {
    
    if ($GameType.romc -ne 1) { return }

    $Bytes = @(08, 00, 00, 00)
    $ByteArray = [IO.File]::ReadAllBytes($Files.ROM)
    [io.file]::WriteAllBytes($Files.ROM, $Bytes + $ByteArray)

    $ByteArray = $null

}



#==============================================================================================================================================================================================
function CheckGameID([String]$Command) {
    
    # Return if freely patching, injecting or extracting
    if (!$GameType.patches -or (StrLike -str $Command -val "inject") -or (StrLike -str $Command -val "extract") -or (StrLike -str $Command -val "Patch VC" ) ) { return $True }

    # Set the status label.
    UpdateStatusLabel -Text "Checking GameID in .tmd..."

    # Get the ".tmd" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.tmd)
    
    $CompareArray = ($GameType.wii_gameID.ToCharArray() | % { [uint32][char]$_ })
    $CompareAgainst = $ByteArray[400..(403)]

    # Check each value of the array.
    for ($i=0; $i-le 4; $i++) {
        # The current values do not match
        if ($CompareArray[$i] -ne $CompareAgainst[$i]) {
            # This is not a "NACE", "NARE", "NAAE" or "NAEE" entry.
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

    $CompareArray = $ByteArray[(GetDecimal -Hex "F1")..((GetDecimal -Hex "F1") + $GameTitleLength[1])]

    # Scan only the contents of the IMET header within the file.
    for ($i=(GetDecimal -Hex "80"); $i-lt (GetDecimal -Hex "62F"); $i++) {
        $CompareAgainst = $ByteArray[$i..($i + $GameTitleLength[1])]

        $Matches = $True
        for ($j=0; $j -lt $CompareAgainst.Length; $j++) {
            if ($CompareAgainst[$j] -notcontains $CompareArray[$j]) { $Matches = $False }
        }

        if ($Matches -eq $True) {
            for ($j=0; $j-lt $GameTitleLength[1]; $j++) { $ByteArray[$i + ($j*2)] = 0 }
            for ($j=0; $j-lt $Title.Length; $j++) { $ByteArray[$i + ($j*2)] = [uint32][char]$Title.Substring($j, 1) }
            $i += $GameTitleLength[1]
        }        
    }

    # Overwrite the patch file with the extended file.
    [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)
    $ByteArray = $null

}



#==============================================================================================================================================================================================
function HackN64GameTitle([String]$Title, [String]$GameID) {
    
    if ($Settings.Debug.NoHeaderChange -eq $True) { return }
    if (!(Test-Path -LiteralPath $Files.PatchedROM -PathType Leaf)) { return }

    UpdateStatusLabel -Text "Hacking in Custom Title and GameID..."

    $emptyTitle = foreach ($i in 1..$GameTitleLength[0]) { 20 }
    ChangeBytes -File $Files.PatchedROM -Offset "20" -Values $emptyTitle
    ChangeBytes -File $Files.PatchedROM -Offset "20" -Values ($Title.ToUpper().ToCharArray() | % { [uint32][char]$_ }) -IsDec $True
    ChangeBytes -File $Files.PatchedROM -Offset "3B" -Values ($GameID.ToCharArray() | % { [uint32][char]$_ }) -IsDec $True

}



#==============================================================================================================================================================================================
function RepackU8AppFile() {
    
    # Set the status label.
    UpdateStatusLabel -Text 'Repacking "00000005.app" file...'

    # Remove the original app file as its going to be replaced.
    RemovePath -LiteralPath $WadFile.AppFile05

    # Repack the file using wszst.
    & $Files.tool.wszst 'C' $WadFile.AppPath05 '-d' $WadFile.AppFile05

    # Get the file as a byte array.
    $AppByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile05)

    # Overwrite the values in 0x10 with zeroes. I don't know why, I'm just matching the output from another program.
    for ($i=16; $i -le 31; $i++) { $AppByteArray[$i] = 0 }

    # Overwrite the patch file with the extended file.
    [IO.File]::WriteAllBytes($WadFile.AppFile05, $AppByteArray)
    
    # Remove the extracted WAD folder.
    RemovePath -LiteralPath $WadFile.AppPath05

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