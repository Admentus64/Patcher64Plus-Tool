#==============================================================================================================================================================================================
$ScriptName = 'Patcher64+ Tool'



#=============================================================================================================================================================================================
# Patcher By     :  Admentus
# Concept By     :  Bighead
# Testing By     :  Admentus, GhostlyDark



#==============================================================================================================================================================================================
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'



#==============================================================================================================================================================================================
# Setup global variables

$global:VersionDate = "09-07-2020"
$global:Version     = "v6.1"

$global:GameType = $global:GamePatch = $global:CheckHashSum = ""
$global:GameFiles = @{}
$global:IsWiiVC = $global:MissingFiles = $False
$global:GameTitleLength = @(20, 40)

$global:CurrentModeFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 12, [System.Drawing.FontStyle]::Bold)
$global:VCPatchFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 8, [System.Drawing.FontStyle]::Bold)



#==============================================================================================================================================================================================
# Set file paths

# Create a hash table
$global:Paths = @{}

# The path this script is found in.
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
    $Paths.Base = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else {
    $Paths.Base = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
    if (!$Paths.Base) { $Paths.Base = "." }
}

# Set all other paths
$Paths.Master      = $Paths.Base + "\Files"
$Paths.WiiVC       = $Paths.Master + "\Wii VC"
$Paths.Games       = $Paths.Master + "\Games"
$Paths.Main        = $Paths.Master + "\Main"



#==============================================================================================================================================================================================
$HidePSConsole = @"
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
"@
Add-Type -Namespace Console -Name Window -MemberDefinition $HidePSConsole



#==============================================================================================================================================================================================
# Function that shows or hides the console window.
function ShowPowerShellConsole([bool]$ShowConsole) {

    switch ($ShowConsole) {
        $true   { [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 5) | Out-Null }
        $false  { [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0) | Out-Null }
    }

}



#==============================================================================================================================================================================================
function ExtendString([String]$InputString, [int]$Length) {

    # Count the number of characters in the input string.
    $Count = ($InputString | Measure-Object -Character).Characters

    # Check the number of characters against the desired amount.
    if ($Count -lt $Length) {
        # If the string is to be lengthened, find out by how much.
        $AddLength = $Length - $Count
        
        # Loop until the string matches the desired number of characters.
        for ($i = 1 ; $i -le $AddLength ; $i++) {
            # Add an empty space to the end of the string.
            $InputString += ' '
        }
    }

    # Return the modified string.
    return $InputString

}



#==============================================================================================================================================================================================
function MainFunction([String]$Command, [String]$PatchedFileName) {
    
    # Header
    $Header = @($GameType.n64_title, $GameType.n64_gameID, $GameType.wii_title, $GameType.wii_gameID)
    $Header = SetHeader -Header $Header -N64Title $GamePatch.n64_title -N64GameID $GamePatch.n64_gameID -WiiTitle $GamePatch.wii_title -WiiGameID $GamePatch.wii_gameID

    # Hash
    if (IsSet -Elem $GamePatch.Hash)   { $global:CheckHashSum = $GamePatch.Hash }
    else                                { $global:CheckHashSum = $GameType.Hash }

    # Output
    if (!(IsSet -Elem $PatchedFileName)) { $PatchedFileName = "_patched" }

    # Downgrade
    if ($IsWiiVC) {
        if ($PatchVCDowngrade.Visible -and (StrLike -str $Command -val "Force Downgrade") )    { $PatchVCDowngrade.Checked = $True }
        elseif ($PatchVCDowngrade.Visible -and (StrLike -str $Command -val "No Downgrade") )   { $PatchVCDowngrade.Checked = $False }
    }
    
    # Remap D-Pad
    if ($GameType.patch_vc -ge 3 -and $PatchVCRemapDPad.Visible -and (StrLike -str $Command -val "Force Remap D-Pad") ) { $PatchVCRemapDPad.Checked = $True }

    # Redux
    if ( (IsChecked -Elem $PatchReduxCheckbox) -and (IsSet -Elem $GamePatch.redux.file) ) {
        $PatchVCRemapDPad.Checked = $True
        if ($GameType.patch_vc -eq 4) {
            $PatchVCExpandMemory.Checked = $True
            if ($IsWiiVC -and !(IsChecked -Elem $PatchVCRemapCDown -Visible) -and !(IsChecked -Elem $PatchVCRemapZ -Visible) ) { $PatchVCLeaveDPadUp.Checked = $True }
        }
        $Header = SetHeader -Header $Header -N64Title $GamePatch.redux.n64_title -N64GameID $GamePatch.redux.n64_gameID -WiiTitle $GamePatch.redux.wii_title -WiiGameID $GamePatch.redux.wii_gameID
        if (IsSet -Elem $GamePatch.redux.output)       { $PatchedFileName = $GamePatch.redux.output }
    }

    # Language Patch
    $LanguagePatch = $null
    if (IsSet -Elem $GamePatch.languages -MinLength 1) {
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($LanguagesBox.Controls[$i*2].checked) { $Item = $i }
        }
        $Header = SetHeader -Header $Header -N64Title $GamePatch.languages[$Item].n64_title -N64GameID $GamePatch.languages[$Item].n64_gameID -WiiTitle $GamePatch.languages[$Item].wii_title -WiiGameID $GamePatch.languages[$Item].wii_gameID
        if (IsSet -Elem $GamePatch.languages[$Item].output)       { $PatchedFileName = $GamePatch.languages[$Item].output }
        $LanguagePatch = $GamePatch.languages[$Item].file
    }

    # GameID / Title
    if ($InputCustomGameIDCheckbox.Checked) {
        if ($InputCustomTitleTextBox.TextLength -gt 0)    { $Header[0 + [int]$IsWiiVC * 2] = $InputCustomTitleTextBox.Text }

        if (!(IsSet -Elem $GamePatch.languages[$Item].n64_gameID)) {
            if ($InputCustomGameIDTextbox.TextLength -eq 4)   { $Header[1 + [int]$IsWiiVC * 2] = $InputCustomGameIDTextBox.Text }
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
    
    #if (!(WriteDebug -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress)) { return }

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

    # Step 09: Apply option patches for SM64.
    if ($GameType.mode -eq "Super Mario 64") { PatchOptionsSM64 }

    # Step 10: Decompress the ROM if required.
    if (!(DecompressROM -Command $Command -Decompress $Decompress)) { return }

    # Step 11: Apply option patches for Zelda.
    if ($GameType.decompress -eq 1) { PatchOptionsZelda }

    # Step 12: Patch and extend the ROM file with the patch through Floating IPS.
    if (!(PatchROM -Command $Command -Decompress $Decompress)) { return }

    # Step 13: Compress the decompressed ROM if required.
    CompressROM -Decompress $Decompress

    # Step 14: Update the .Z64 ROM CRC
    UpdateROMCRC

    # Step 15: Hack the Game Title and GameID of a N64 ROM
    HackN64GameTitle -Title $Header[0] -GameID $Header[1]

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 16: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        ExtendROM

        # Step 17: Compress the ROMC again if possible.
        CompressROMC 

        # Step 18: Hack the Channel Title.
        HackOpeningBNRTitle -Title $Header[2]

        # Step 19: Repack the "00000005.app" with the updated ROM file 
        RepackU8AppFile
        
        # Step 20: Repack the WAD file with the updated APP file.
        RepackWADFile -GameID $Header[3]
    }

    # Step 21: Final message.
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

    return $False

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
    RemoveFile -LiteralPath $Files.decompressedROM

    foreach($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }

    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {

    if (!(Test-Path -LiteralPath $Files.patchedROM -PathType Leaf)) { Copy-Item -LiteralPath $Files.ROM -Destination $Files.patchedROM }
    & $Files.tool.rn64crc $Files.PatchedROM -update | Out-Host

}



#==============================================================================================================================================================================================
function EnableGUI([Boolean]$Enable) {
    
    $InputWADPanel.Enabled = $Enable
    $PatchPanel.Enabled = $Enable
    $MiscPanel.Enabled = $PatchVCPanel.Enabled = $Enable

}


#==============================================================================================================================================================================================
function RemoveFile([String]$LiteralPath) { if (Test-Path -LiteralPath $LiteralPath -PathType Leaf) { Remove-Item -LiteralPath $LiteralPath -Force } }



#==============================================================================================================================================================================================
function RemovePath([String]$LiteralPath) {
    
    # Make sure the path isn't null to avoid errors.
    if ($LiteralPath -ne '') {
        # Check to see if the path exists.
        if (Test-Path -LiteralPath $LiteralPath) {
            # Remove the path.
            Remove-Item -LiteralPath $LiteralPath -Recurse -Force -ErrorAction 'SilentlyContinue' | Out-Null
        }
    }

}



#==============================================================================================================================================================================================
function CreatePath([String]$LiteralPath) {
    
    # Make sure the path is not null to avoid errors.
    if ($LiteralPath -ne '') {
        # Check to see if the path does not exist.
        if (!(Test-Path -LiteralPath $LiteralPath)) {
            # Create the path.
            New-Item -Path $LiteralPath -ItemType 'Directory' | Out-Null
        }
    }

    # Return the path so it can be set to a variable when creating.
    return $LiteralPath

}



#==============================================================================================================================================================================================
function TestPath([String]$LiteralPath, [String]$PathType = 'Any') {
    
    # Make sure the path is not null to avoid errors.
    if ($LiteralPath -ne '') {
        # Check to see if the path exists.
        if (Test-Path -LiteralPath $LiteralPath -PathType $PathType -ErrorAction 'SilentlyContinue') {
            # The path exists.
            return $true
        }
    }

    # The path is bunk.
    return $false

}



#==============================================================================================================================================================================================
function Get-FileName([String]$Path, [String[]]$Description, [String[]]$FileName) {
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $Path
    
    for($i = 0; $i -lt $FileName.Count; $i++) {
        $FilterString += $Description[$i] + '|' + $FileName[$i] + '|'
    }
    
    $OpenFileDialog.Filter = $FilterString.TrimEnd('|')
    $OpenFileDialog.ShowDialog() | Out-Null
    
    return $OpenFileDialog.FileName

}



#==============================================================================================================================================================================================
function SetFileParameters() {
    
    # Create a hash table.
    $global:Files = @{}
    $Files.tool = @{}
    $Files.oot = @{}
    $Files.mm = @{}
    $Files.sm64 = @{}
    $Files.json = @{}
    $Files.icon = @{}
    $Files.text = @{}

    # Store all tool files
    $Files.tool.flips                       = $Paths.Master + "\Base\flips.exe"
    $Files.tool.rn64crc                     = $Paths.Master + "\Base\rn64crc.exe"
    $Files.tool.xdelta                      = $Paths.Master + "\Base\xdelta.exe"
    $Files.tool.xdelta3                     = $Paths.Master + "\Base\xdelta3.exe"

    $Files.tool.Compress                    = $Paths.Master + "\Compression\Compress.exe"
    $Files.tool.ndec                        = $Paths.Master + "\Compression\ndec.exe"
    $Files.tool.sm64extend                  = $Paths.Master + "\Compression\sm64extend.exe"
    $Files.tool.TabExt                      = $Paths.Master + "\Compression\TabExt.exe"
    
    $Files.tool.wadpacker                   = $Paths.WiiVC + "\wadpacker.exe"
    $Files.tool.wadunpacker                 = $Paths.WiiVC + "\wadunpacker.exe"
    $Files.tool.wszst                       = $Paths.WiiVC + "\wszst.exe"
    $Files.tool.cygcrypto                   = $Paths.WiiVC + "\cygcrypto-0.9.8.dll"
    $Files.tool.cyggccs1                    = $Paths.WiiVC + "\cyggcc_s-1.dll"
    $Files.tool.cygncursesw10               = $Paths.WiiVC + "\cygncursesw-10.dll"
    $Files.tool.cygpng1616                  = $Paths.WiiVC + "\cygpng16-16.dll"
    $Files.tool.cygwin1                     = $Paths.WiiVC + "\cygwin1.dll"
    $Files.tool.cygz                        = $Paths.WiiVC + "\cygz.dll"
    $Files.tool.lzss                        = $Paths.WiiVC + "\lzss.exe"
    $Files.tool.romc                        = $Paths.WiiVC + "\romc.exe"
    $Files.tool.romchu                      = $Paths.WiiVC + "\romchu.exe"
    
    # Store Ocarina of Time files
    $Files.oot.dawn_rev1                    = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Compressed\dawn_rev1")
    $Files.oot.dawn_rev2                    = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Compressed\dawn_rev2")
    $Files.oot.models_mm                    = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\models_mm")
    $Files.oot.models_mm_redux              = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\models_mm_redux")
    $Files.oot.fire_temple                  = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\fire_temple.bps")
    $Files.oot.lens_of_truth                = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Binaries\Lens of Truth.bin")
    $Files.oot.title_copyright              = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Binaries\Master Quest\Title Copyright.bin")
    $Files.oot.title_master_quest           = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Binaries\Master Quest\Title Logo.bin")
    $Files.oot.file_select_1                = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Binaries\File Select\1.bin")
    $Files.oot.file_select_2                = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Binaries\File Select\2.bin")
    for ($i=1; $i -le 18; $i++) {
        if ($i -ne 6) { $Files["oot"][$i]   = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Binaries\Gerudo\" + $i + ".bin") }
    }

    # Store Majora's Mask files
    $Files.mm.troupe_leaders_mask           = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Textures\Troupe Leader's Mask.yaz0")
    $Files.mm.carnival_of_time              = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Carnival of Time.bin")
    $Files.mm.four_giant                    = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Four Giants.bin")
    $Files.mm.lens_of_truth                 = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Lens of Truth.bin")
    $Files.mm.romani_ranch                  = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Romani Sign.bin")
    $Files.mm.deku_room_00                  = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Palace Route\DekuRoom00.bin")
    $Files.mm.deku_room_01                  = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Palace Route\DekuRoom01.bin")
    $Files.mm.deku_room_02                  = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Palace Route\DekuRoom02.bin")
    $Files.mm.deku_scene                    = CheckPatchExtension -File ($Paths.Games + "\Majora's Mask\Binaries\Palace Route\DekuScene.bin")

    # Store Super Mario 64 files
    $Files.sm64.cam                         = CheckPatchExtension -File ($Paths.Games + "\Super Mario 64\Compressed\cam")
    $Files.sm64.fps                         = CheckPatchExtension -File ($Paths.Games + "\Super Mario 64\Compressed\fps")

    # Store JSON files
    $Files.json.games                       = $Paths.Games + "\Games.json"

    # Store ICO files
    $Files.icon.main                        = $Paths.Main + "\Main.ico"
    $Files.icon.gameID                      = $Paths.Main + "\GameID.ico"
    $Files.icon.credits                     = $Paths.Main + "\Credits.ico"

    # Store text files
    $Files.text.credits                     = $Paths.Main + "\Credits.txt"
    $Files.text.gameID                      = $Paths.Main + "\GameID.txt"


    # Check if all files so far exist
    CheckFilesExists -HashTable $Files.tool
    CheckFilesExists -HashTable $Files.oot
    CheckFilesExists -HashTable $Files.mm
    CheckFilesExists -HashTable $Files.sm64
    CheckFilesExists -HashTable $Files.json
    CheckFilesExists -HashTable $Files.icon

    # Store misc files
    $Files.flipscfg                         = $Paths.Master + "\Base\flipscfg.bin"
    $Files.ckey                             = $Paths.Master + "\Wii VC\common-key.bin"
    $Files.decompressedROM                  = $Paths.Master + "\decompressed"

    $Files.stackdump                        = $Paths.WiiVC + "\wadpacker.exe.stackdump"

    $Files.dmaTable                         = $Paths.Base + "\dmaTable.dat"
    $Files.archive                          = $Paths.Base + "\ARCHIVE.bin"
    $Files.settings                         = $Paths.Base + "\Settings.ini"

}



#==============================================================================================================================================================================================
function CheckFilesExists([hashtable]$HashTable) {
    
    $HashTable.GetEnumerator() | ForEach-Object {
        if ( !(Test-Path $_.value -PathType Leaf) -and (IsSet -Elem $_.value) ) { CreateErrorDialog -Error "Missing Files" -Exit }
    }

}




#==============================================================================================================================================================================================
function CheckPatchExtension([String]$File) {
    
    if (Test-Path ($File + ".bps") -PathType Leaf)      { return $File + ".bps" }
    if (Test-Path ($File + ".ips") -PathType Leaf)      { return $File + ".ips" }
    if (Test-Path ($File + ".xdelta") -PathType Leaf)   { return $File + ".xdelta" }
    if (Test-Path ($File + ".vcdiff") -PathType Leaf)   { return $File + ".vcdiff" }
    return $File

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
    else                         { $WADFile.ROMFile = $WADFile.AppPath05 + '\rom' }
    $WADFile.Patched      = $WADItem.DirectoryName + '\' + $WADFile.Name + $PatchedFileName + '.wad'
    $WADFile.Extracted    = $WADItem.DirectoryName + '\' + $WADFile.Name + "_extracted_rom" + '.z64'

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

    SetROMFile

    # Set it to a global value.
    return $Z64File

}



#==============================================================================================================================================================================================
function SetROMFile() {
    
    if ($IsWiiVC) { $Files.ROM = $Files.patchedROM = $WADFile.ROMFile }
    else {
        $Files.ROM = $Z64File.ROMFile
        $Files.patchedROM = $Z64File.Patched
    }

    $Files.outROM = $Paths.Master + "\out"
    $Files.decompressedROM = $Paths.Master + "\decompressed"

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

    if ($GameType.mode -eq "Ocarina of Time") {
        
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
    
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Patch VC") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }

    $ContinuePatching = $True
    $HashSum = (Get-FileHash -Algorithm MD5 $Files.ROM).Hash

    if ($CheckHashSum -eq "Dawn & Dusk") {
        if ($HashSum -eq "5BD1FE107BF8106B2AB6650ABECD54D6")     { $GamePatch.file = "\dawn_rev0.bps" }
        elseif ($HashSum -eq "721FDCC6F5F34BE55C43A807F2A16AF4") { $GamePatch.file = "\dawn_rev1.bps" }
        elseif ($HashSum -eq "57A9719AD547C516342E1A15D5C28C3D") { $GamePatch.file = "\dawn_rev2.bps" }
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
function PatchROM([String]$Command, [Boolean]$Decompress) {
    
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Patch VC") -or !(IsSet $GamePatch.file) ) { return $True }
    
    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " ROM with patch file...")

    if (StrLike -str $Command -val "Apply Patch") { $HashSum1 = (Get-FileHash -Algorithm MD5 $Files.ROM).Hash }

    # Apply the selected patch to the ROM, if it is provided
    if ($IsWiiVC -and $Decompress)         { if (!(ApplyPatch -File $Files.decompressedROM -Patch $GamePatch.file))              { return $False } }
    elseif ($IsWiiVC -and !$Decompress)    { if (!(ApplyPatch -File $Files.patchedROM -Patch $GamePatch.file))                   { return $False } }
    elseif (!$IsWiiVC -and $Decompress)    { if (!(ApplyPatch -File $Files.decompressedROM -Patch $GamePatch.file))              { return $False } }
    elseif (!$IsWiiVC -and !$Decompress)   { if (!(ApplyPatch -File $Files.ROM -Patch $GamePatch.file -New $Files.patchedROM))   { return $False } }

    if (StrLike -str $Command -val "apply patch") {
        $HashSum2 = (Get-FileHash -Algorithm MD5 $Files.patchedROM).Hash
        if ($HashSum1 -eq $HashSum2) {
            if ($IsWiiVC -and $GameType.downgrade -and !(IsChecked $PatchVCDowngrade -Visible) )      { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?" }
            elseif ($IsWiiVC -and $GameType.downgrade -and (IsChecked $PatchVCDowngrade -Visible) )   { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" }
            else                                                                                      { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged." }
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatch([String]$File, [String]$Patch, [String]$New) {
    
    if ( !(IsSet -Elem $File) -or !(IsSet -Elem $Patch) ) { return $True }

    # File
    if (!(Test-Path -LiteralPath $File -PathType Leaf)) {
        UpdateStatusLabel -Text "Failed! Could not find ROM file."
        return $False
    }

    # Patch File
    $Patch = $GameFiles.base + $Patch
    if (Test-Path ($Patch + ".bps") -PathType Leaf)      { $Patch + ".bps" }
    if (Test-Path ($Patch + ".ips") -PathType Leaf)      { $Patch + ".ips" }
    if (Test-Path ($Patch + ".xdelta") -PathType Leaf)   { $Patch + ".xdelta" }
    if (Test-Path ($Patch + ".vcdiff") -PathType Leaf)   { $Patch + ".vcdiff" }

    if (Test-Path -LiteralPath $Patch -PathType Leaf) { $Patch = Get-Item -LiteralPath $Patch }
    else {
        UpdateStatusLabel -Text "Failed! Could not find patch file."
        return $False
    }

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
    else { return $False }

    return $True

}



#==============================================================================================================================================================================================
function DecompressROM([String]$Command, [Boolean]$Decompress) {

    if (!$Decompress -or (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }
    
    UpdateStatusLabel -Text ("Decompressing " + $GameType.mode + " ROM...")

    if ($GameType.decompress -eq 1) {
        & $Files.tool.TabExt $Files.ROM | Out-Host
        & $Files.tool.ndec $Files.ROM $Files.decompressedROM | Out-Host   
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
        RemoveFile -LiteralPath $Files.archive
        & $Files.tool.Compress $Files.decompressedROM $Files.patchedROM | Out-Null
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
function ChangeBytes([String]$File, [String]$Offset, [String[]]$Values, [int]$Interval, [Boolean]$IsDec) {
    
    $ByteArray = [IO.File]::ReadAllBytes($File)

    if (!(IsSet -Elem $Interval -Min 1)) { $Interval = 1 }
    [uint32]$Offset = GetDecimal -Hex $Offset

    for ($i=0; $i -lt $Values.Length; $i++) {
        if ($IsDec)   { [uint32]$Value = $Values[$i] }
        else          { [uint32]$Value = GetDecimal -Hex $Values[$i] }
        $ByteArray[$Offset + ($i * $Interval)] = $Value
    }

    [io.file]::WriteAllBytes($File, $ByteArray)
    $File = $Offset = $Interval = $ByteArray = $Value = $null
    $Values = $null

}



#==============================================================================================================================================================================================
function PatchBytes([String]$File, [String]$Offset, [String]$Length, [String]$Patch, [Switch]$Texture) {

    $ByteArray = [IO.File]::ReadAllBytes($File)
    if ($Texture)   { $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.textures + "\" + $Patch) }
    else            { $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.binaries + "\" + $Patch) }

    [uint32]$Offset = GetDecimal -Hex $Offset

    if (IsSet -Elem $Length) {
        [uint32]$Length = GetDecimal -Hex $Length
        for ($i=0; $i -lt $Length; $i++) {
            if ($i -le $PatchByteArray.Length)   { $ByteArray[$Offset + $i] = $PatchByteArray[($i)] }
            else                                 { $ByteArray[$Offset + $i] = 0 }
        }
    }
    else {
        for ($i=0; $i -lt $PatchByteArray.Length; $i++) { $ByteArray[$Offset + $i] = $PatchByteArray[($i)] }
    }

    [io.file]::WriteAllBytes($File, $ByteArray)
    $File = $Offset = $Length = $Patch = $ByteArray = $PatchByteArray = $null

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([String]$Hex) { return [uint32]("0x" + $Hex) }



#==============================================================================================================================================================================================
function PatchOptionsZelda() {
    
    if (!$Decompress) { return }

    # BPS PATCHING REDUX #
    if ( (IsChecked $PatchReduxCheckbox -Visible) -and (IsSet -Elem $GamePatch.redux.file) ) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " REDUX...")
        if (IsSet -Elem $GamePatch.redux.file) { ApplyPatch -File $Files.decompressedROM -Patch $GamePatch.redux.file } # Redux

        if ($GameType.decompress -eq 1 -and (IsSet -Elem $GameType.dmaTable) ) {
            RemoveFile -LiteralPath $Files.dmaTable
            Add-Content $Files.dmaTable $GameType.dmaTable
        }
    }

    # BYE PATCHING & BPS PATCHING OPTIONS #
    if ( (IsChecked $PatchOptionsCheckbox -Visible) -and $GamePatch.options) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")
        if ($GameType.mode -eq "Ocarina of Time")     { PatchOptionsOoT }
        elseif ($GameType.mode -eq "Majora's Mask")   { PatchOptionsMM }
    }

    # BPS PATCHING LANGUAGE #
    if (IsSet -Elem $LanguagePatch) { # Language
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $Files.decompressedROM -Patch $LanguagePatch
    } 

}


#==============================================================================================================================================================================================
function PatchOptionsOoT() {
    
    # HERO MODE #

    if (IsText -Elem $Options.Damage -Text "OKHO Mode" -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "AE8073" -Values @("09", "04") -Interval 16
        ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("82", "00")
        ChangeBytes -File $Files.decompressedROM -Offset "AE8099" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled -Not) -and (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled -Not) ) {
        ChangeBytes -File $Files.decompressedROM -Offset "AE8073" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled) {                
            if (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "C0") }
            ChangeBytes -File $Files.decompressedROM -Offset "AE8099" -Values @("00", "00", "00")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {               
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("81", "00") }
            ChangeBytes -File $Files.decompressedROM -Offset "AE8099" -Values @("10", "80", "43")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {                
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("81", "00") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("81", "40") }
            ChangeBytes -File $Files.decompressedROM -Offset "AE8099" -Values @("10", "80", "83")

        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {                
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("81", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("81", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("81", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "AE8096" -Values @("82", "00") }
            ChangeBytes -File $Files.decompressedROM -Offset "AE8099" -Values @("10", "81", "43")
        }
    }

    if (IsChecked -Elem $Options.MasterQuest -Enabled) {
        PatchBytes -File $Files.decompressedROM -Offset "1795300" -Length "19000" -Patch "Master Quest\Title Logo.bin"
        PatchBytes -File $Files.decompressedROM -Offset "17AE380" -Length "700"   -Patch "Master Quest\Title Copyright.bin"
        ChangeBytes -File $Files.decompressedROM -Offset "E6C4BC" -Values @("3C", "01", "43", "48", "44", "81", "30", "00", "E4", "60", "62", "D8", "E4", "60", "62", "DC", "E4", "60", "62", "E4", "E4", "64", "62", "D4", "E4", "66", "62", "E0")
        ChangeBytes -File $Files.decompressedROM -Offset "E6C764" -Values @("3C", "01", "43", "2A", "44", "81", "50", "00", "26", "01", "7F", "FF", "24", "0A", "00", "02", "E4", "42", "62", "D8", "E4", "42", "62", "DC", "E4", "42", "62", "E4", "E4", "48", "62", "D4", "E4", "4A", "62", "E0")
        ChangeBytes -File $Files.decompressedROM -Offset "E6C9F0" -Values @("3C", "01", "BF", "B0", "C4", "44", "62", "D4", "44", "81", "80", "00", "C4", "4A", "62", "E0", "46", "06", "22", "00", "84", "4E", "62", "CA", "26", "01", "7F", "FF", "46", "10", "54", "80", "E4", "48", "62", "D4", "25", "CF", "FF", "FF", "E4", "52", "62", "E0")
        ChangeBytes -File $Files.decompressedROM -Offset "E6CA48" -Values @("3C", "01", "43", "48", "44", "81", "40", "00", "26", "01", "7F", "FF", "E4", "46", "62", "D4", "E4", "48", "62", "E0")
    }

    if (IsText -Elem $Options.BossHP -Text "2x Boss HP" -Enabled) {
        #ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("14") # Gohma             0xC44C30 -> 0xC4ABB0 (Length: 0x5F80) (ovl_Boss_Goma) (HP: 0A) (Mass: FF)

        #ChangeBytes -File $Files.decompressedROM -Offset "C3B9FF" -Values @("18") # King Dodongo      0xC3B150 -> 0xC44C30 (Length: 0x9AE0) (ovl_Boss_Dodongo) (HP: 0C) (Mass: 00)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("08") # Barinade        0xD22360  -> 0xD30B50 (Length: 0xE7F0)(ovl_Boss_Va) (HP: 04 -> 03 -> 03) (Mass: 00)
        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("06") # Barinade        

        #ChangeBytes -File $Files.decompressedROM -Offset "C91F8F" -Values @("3C") # Phantom Ganon     0xC91AD0  -> 0xC96840  (Length: 0x4D70) (ovl_Boss_Ganondrof) (HP: 1E -> 18) (Mass: 32)

        #ChangeBytes -File $Files.decompressedROM -Offset "C91B99" -Values @("1D") # Phantom Ganon 2A
        #ChangeBytes -File $Files.decompressedROM -Offset "C91C95" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C922C3" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C92399" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C9263F" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C9266B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C92AE7" -Values @("1D") # Phantom Ganon

        #ChangeBytes -File $Files.decompressedROM -Offset "C91BE1" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91C4B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91C91" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91CCD" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91D2D" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91D8D" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91E9B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C91F83" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C9200B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C920EB" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C92123" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C92177" -Values @("1D") # Phantom Ganon
        #ChangeBytes -File $Files.decompressedROM -Offset "C9219F" -Values @("1D") # Phantom Ganon



        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("30") # Volvagia        0xCE65F0  -> 0xCED920 (Length: 0x7330) (ovl_Boss_Fd) (Has HP) (HP: 18) (Mass: 32)
                                                                                    # Volvagia        0xD04790 -> 0xD084C0 (Length:0x3D30) (ovl_Boss_Fd2) (Has No HP, Forwards HP to Flying)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("28") # Morpha          ? -> ? (Length: ?) (ovl_Boss_Mo) (HP: 14) (Mass: 00)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("48") # Bongo Bongo     ? -> ? (Length: ?) (ovl_Boss_Sst) (HP: 24) (Mass: C8)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("30") # Twinrova        0xD612E0 -> 0xD74360 (Length: 0x13080) (ovl_Boss_Tw) (HP: 18) (Mass: FF)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("50") # Ganondorf       ? -> ? (Length: ?) (ovl_Boss_Ganon) (HP: 28) (Mass: 32)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("3C") # Ganon           0xE826C0 -> 0xE939B0 (Length: 0x112F0) (ovl_Boss_Ganon2) (HP: 1E) (Mass: FF)
    }
    elseif (IsText -Elem $Options.BossHP -Text "3x Boss HP" -Enabled) {
        #ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("1E") # Gohma             0xC44C30 -> 0xC4ABB0 (Length: 0x5F80) (ovl_Boss_Goma) (HP: 0A) (Mass: FF)

        #ChangeBytes -File $Files.decompressedROM -Offset "C3B9FF" -Values @("24") # King Dodongo      0xC3B150 -> 0xC44C30 (Length: 0x9AE0) (ovl_Boss_Dodongo) (HP: 0C) (Mass: 00)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("0C") # Barinade        0xD22360  -> 0xD30B50 (Length: 0xE7F0)(ovl_Boss_Va) (HP: 04 -> 03 -> 03) (Mass: 00)
        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("09") # Barinade        

        #ChangeBytes -File $Files.decompressedROM -Offset "C91F8F" -Values @("5A") # Phantom Ganon     0xC91AD0  -> 0xC96840  (Length: 0x4D70) (ovl_Boss_Ganondrof) (HP: 1E -> 18) (Mass: 32)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("48") # Volvagia        0xCE65F0  -> 0xCED920 (Length: 0x7330) (ovl_Boss_Fd) (Has HP) (HP: 18) (Mass: 32)
                                                                                    # Volvagia        0xD04790 -> 0xD084C0 (Length:0x3D30) (ovl_Boss_Fd2) (Has No HP, Forwards HP to Flying)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("3C") # Morpha          ? -> ? (Length: ?) (ovl_Boss_Mo) (HP: 14) (Mass: 00)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("6C") # Bongo Bongo     ? -> ? (Length: ?) (ovl_Boss_Sst) (HP: 24) (Mass: C8)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("48") # Twinrova        0xD612E0 -> 0xD74360 (Length: 0x13080) (ovl_Boss_Tw) (HP: 18) (Mass: FF)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("78") # Ganondorf       ? -> ? (Length: ?) (ovl_Boss_Ganon) (HP: 28) (Mass: 32)

        # ChangeBytes -File $Files.decompressedROM -Offset "C44F2B" -Values @("5A") # Ganon           0xE826C0 -> 0xE939B0 (Length: 0x112F0) (ovl_Boss_Ganon2) (HP: 1E) (Mass: FF)
    }



    # TEXT DIALOGUE SPEED #

    if (IsChecked -Elem $Options.Text2x -Enabled) { ChangeBytes -File $Files.decompressedROM -Offset "B5006F" -Values @("02") }
    elseif (IsChecked -Elem $Options.Text3x -Enabled $True) {
        ChangeBytes -File $Files.decompressedROM -Offset "93B6E7" -Values @("09", "05", "40", "2E", "05", "46", "01", "05", "40")
        ChangeBytes -File $Files.decompressedROM -Offset "93B6F1" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B71E" -Values @("09", "2E")
        ChangeBytes -File $Files.decompressedROM -Offset "93B722" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B74C" -Values @("09", "21", "05", "42")
        ChangeBytes -File $Files.decompressedROM -Offset "93B752" -Values @("01", "05", "40")
        ChangeBytes -File $Files.decompressedROM -Offset "93B776" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B77A" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7A1" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7A5" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7A8" -Values @("1A")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7C9" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7CD" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7F2" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B7F6" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B81C" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B820" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B849" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B84D" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B86D" -Values @("09", "2E")
        ChangeBytes -File $Files.decompressedROM -Offset "93B871" -Values @("01") 
        ChangeBytes -File $Files.decompressedROM -Offset "93B88F" -Values @("09", "2E")
        ChangeBytes -File $Files.decompressedROM -Offset "93B893" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B8BE" -Values @("09", "2E")
        ChangeBytes -File $Files.decompressedROM -Offset "93B8C2" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B8EF" -Values @("09", "2E")
        ChangeBytes -File $Files.decompressedROM -Offset "93B8F3" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B91A" -Values @("09", "21")
        ChangeBytes -File $Files.decompressedROM -Offset "93B91E" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B94E" -Values @("09", "2E")
        ChangeBytes -File $Files.decompressedROM -Offset "93B952" -Values @("01")
        ChangeBytes -File $Files.decompressedROM -Offset "93B728" -Values @("10")
        ChangeBytes -File $Files.decompressedROM -Offset "93B72A" -Values @("01")

        ChangeBytes -File $Files.decompressedROM -Offset "B5006F" -Values @("03")
    }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled)          { ChangeBytes -File $Files.decompressedROM -Offset "B08038" -Values @("3C", "07", "3F", "E3") }
    
    if (IsChecked -Elem $Options.WidescreenTextures -Enabled $True) {
        PatchBytes -File $Files.decompressedROM -Offset "28E7FB0" -Length "3A57" -Texture -Patch "Bazaar.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2DDB160" -Length "38B8" -Texture -Patch "Bombchu Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2D339D0" -Length "3934" -Texture -Patch "Goron Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2CD0DA0" -Length "37CF" -Texture -Patch "Gravekeeper's Hut.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "3412E40" -Length "4549" -Texture -Patch "Happy Mask Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2E30EF0" -Length "4313" -Texture -Patch "Impa's House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "300CD80" -Length "43AC" -Texture -Patch "Kakariko House 3.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2C8A7C0" -Length "31C6" -Texture -Patch "Kakariko House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2D89660" -Length "3E49" -Texture -Patch "Kakariko Potion Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "268D430" -Length "5849" -Texture -Patch "Kokiri Know-It-All-Brothers' House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2592490" -Length "410F" -Texture -Patch "Kokiri Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2AA90C0" -Length "5D69" -Texture -Patch "Kokiri Twins' House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2560480" -Length "5B1E" -Texture -Patch "Link's House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2C5DA50" -Length "4B12" -Texture -Patch "Lon Lon Ranch Stables.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2E037A0" -Length "3439" -Texture -Patch "Mamamu Yan's House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2946120" -Length "4554" -Texture -Patch "Market Back Alley 1 Day.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2A2A110" -Length "2F31" -Texture -Patch "Market Back Alley 1 Night.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "296B920" -Length "41ED" -Texture -Patch "Market Back Alley 2 Day.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2A4F910" -Length "3015" -Texture -Patch "Market Back Alley 2 Night.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2991120" -Length "4AC4" -Texture -Patch "Market Back Alley 3 Day.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2A75110" -Length "366B" -Texture -Patch "Market Back Alley 3 Night.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2718370" -Length "62CE" -Texture -Patch "Market Entrance Day.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2A02360" -Length "54CC" -Texture -Patch "Market Entrance Future.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "29DB370" -Length "4144" -Texture -Patch "Market Entrance Night.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2DB1430" -Length "39DF" -Texture -Patch "Market Potion Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2F7B0F0" -Length "669B" -Texture -Patch "Mido's House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2FB60E0" -Length "5517" -Texture -Patch "Saria's House.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "307EAF0" -Length "428D" -Texture -Patch "Temple of Time Entrance Day.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "3142AF0" -Length "3222" -Texture -Patch "Temple of Time Entrance Future.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "30EDB10" -Length "2C02" -Texture -Patch "Temple of Time Entrance Night.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "30A42F0" -Length "5328" -Texture -Patch "Temple of Time Path Day.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "31682F0" -Length "3860" -Texture -Patch "Temple of Time Path Future.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "3113310" -Length "3BC7" -Texture -Patch "Temple of Time Path Night.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2E65EA0" -Length "49E0" -Texture -Patch "Tent.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "2D5B9E0" -Length "4119" -Texture -Patch "Zora Shop.jpeg"
        PatchBytes -File $Files.decompressedROM -Offset "F21810"  -Length "1000" -Patch "Lens of Truth.bin"
    }

    if (IsChecked -Elem $Options.ExtendedDraw -Enabled)        { ChangeBytes -File $Files.decompressedROM -Offset "A9A970" -Values @("00", "01") }
    if (IsChecked -Elem $Options.ForceHiresModel -Enabled)     { ChangeBytes -File $Files.decompressedROM -Offset "BE608B" -Values @("00") }

    if (IsChecked -Elem $Options.BlackBars -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "B0F5A4" -Values @("00", "00","00", "00")
        ChangeBytes -File $Files.decompressedROM -Offset "B0F5D4" -Values @("00", "00","00", "00")
        ChangeBytes -File $Files.decompressedROM -Offset "B0F5E4" -Values @("00", "00","00", "00")
        ChangeBytes -File $Files.decompressedROM -Offset "B0F680" -Values @("00", "00","00", "00")
        ChangeBytes -File $Files.decompressedROM -Offset "B0F688" -Values @("00", "00","00", "00")
    }

    if (IsChecked -Elem $Options.MMModels -Enabled) {
        if (IsChecked $PatchReduxCheckbox -Visible)            { ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\models_mm_redux.bps" }
        else                                                   { ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\models_mm.bps" }
    }



    # GAMEPLAY

    if (IsChecked -Elem $Options.Medallions -Enabled)          { ChangeBytes -File $Files.decompressedROM -Offset "E2B454" -Values @("80", "EA", "00", "A7", "24", "01", "00", "3F", "31", "4A", "00", "3F", "00", "00", "00", "00") }

    if (IsChecked -Elem $Options.ReturnChild -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "CB6844"  -Values @("35")
        ChangeBytes -File $Files.decompressedROM -Offset "253C0E2" -Values @("03")
    }

    if (IsChecked -Elem $Options.EasierMinigames -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "CC4024" -Values @("00", "00", "00", "00") # Dampe's Digging Game

        ChangeBytes -File $Files.decompressedROM -Offset "DBF428" -Values @("0C", "10", "07", "7D", "3C", "01", "42", "82", "44", "81", "40", "00", "44", "98", "90", "00", "E6", "52") # Easier Fishing
        ChangeBytes -File $Files.decompressedROM -Offset "DBF484" -Values @("00", "00", "00", "00") # Easier Fishing
        ChangeBytes -File $Files.decompressedROM -Offset "DBF4A8" -Values @("00", "00", "00", "00") # Easier Fishing

        ChangeBytes -File $Files.decompressedROM -Offset "DCBEAB" -Values @("48") # Adult Fish size requirement
        ChangeBytes -File $Files.decompressedROM -Offset "DCBF27" -Values @("48") # Adult Fish size requirement

        ChangeBytes -File $Files.decompressedROM -Offset "DCBF33" -Values @("30") # Child Fish size requirement
        ChangeBytes -File $Files.decompressedROM -Offset "DCBF9F" -Values @("30") # Child Fish size requirement
    }



    # RESTORE
    if (IsChecked -Elem $Options.RestoreFireTemple -Enabled)   { ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\fire_temple.bps" }

    if (IsChecked -Elem $Options.CorrectRupeeColors -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "F47EB0" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -File $Files.decompressedROM -Offset "F47ED0" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Options.RestoreGerudoTextures -Enabled) {
        PatchBytes -File $Files.decompressedROM -Offset "2464D88" -Patch "Gerudo/1.bin"
        PatchBytes -File $Files.decompressedROM -Offset "12985F0" -Patch "Gerudo/2.bin"
        PatchBytes -File $Files.decompressedROM -Offset "21B8678" -Patch "Gerudo/3.bin"
        PatchBytes -File $Files.decompressedROM -Offset "13B4000" -Patch "Gerudo/4.bin"
        PatchBytes -File $Files.decompressedROM -Offset "7FD000"  -Patch "Gerudo/5.bin"
        PatchBytes -File $Files.decompressedROM -Offset "28BBCD8" -Patch "Gerudo/7.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F70350"  -Patch "Gerudo/8.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F80CB0"  -Patch "Gerudo/9.bin"
        PatchBytes -File $Files.decompressedROM -Offset "11FB000" -Patch "Gerudo/10.bin"
        PatchBytes -File $Files.decompressedROM -Offset "2B03928" -Patch "Gerudo/11.bin"
        PatchBytes -File $Files.decompressedROM -Offset "2B5CDA0" -Patch "Gerudo/12.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F7A8A0"  -Patch "Gerudo/13.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F71350"  -Patch "Gerudo/14.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F92280"  -Patch "Gerudo/15.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F748A0"  -Patch "Gerudo/16.bin"
        PatchBytes -File $Files.decompressedROM -Offset "E68CE8"  -Patch "Gerudo/17.bin"
        PatchBytes -File $Files.decompressedROM -Offset "F70B50"  -Patch "Gerudo/18.bin"
    }


    
    # EQUIPMENT #

    if (IsChecked -Elem $Options.ReducedItemCapacity -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC2F" -Values @("14", "19", "1E") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC37" -Values @("0A", "0F", "14") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC57" -Values @("14", "19", "1E") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC5F" -Values @("05", "0A", "0F") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC67" -Values @("0A", "0F", "14") -Interval 2
    }
    elseif (IsChecked -Elem $Options.IncreasedIemCapacity -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC2F" -Values @("28", "46", "63") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC37" -Values @("1E", "37", "50") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC57" -Values @("28", "46", "63") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC5F" -Values @("0F", "1E", "2D") -Interval 2
        ChangeBytes -File $Files.decompressedROM -Offset "B6EC67" -Values @("1E", "37", "50") -Interval 2
    }

    if (IsChecked -Elem $Options.UnlockSword -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "BC77AD" -Values @("09")
        ChangeBytes -File $Files.decompressedROM -Offset "BC77F7" -Values @("09")
    }

    if (IsChecked -Elem $Options.UnlockTunics -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "BC77B6" -Values @("09", "09")
        ChangeBytes -File $Files.decompressedROM -Offset "BC77FE" -Values @("09", "09")
    }

    if (IsChecked -Elem $Options.UnlockBoots -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "BC77BA" -Values @("09", "09")
        ChangeBytes -File $Files.decompressedROM -Offset "BC7801" -Values @("09", "09")
    }



    # OTHER #

    if (IsChecked -Elem $Options.DisableLowHPSound -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "ADBA1A"  -Values @("00", "00") }
    if (IsChecked -Elem $Options.DisableNavi -Enabled)         { ChangeBytes -File $Files.decompressedROM -Offset "DF8B84"  -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.HideDPad -Enabled)            { ChangeBytes -File $Files.decompressedROM -Offset "348086E" -Values @("00") }

    if (IsChecked -Elem $Options.HideFileSelectIcons -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "348A1FD"  -Values @("FF", "FF", "FF") -Interval 2
        PatchBytes -File $Files.decompressedROM -Offset "3488EA4" -Patch "File Select/1.bin"
        PatchBytes -File $Files.decompressedROM -Offset "34890B0" -Patch "File Select/2.bin"
    }

}



#==============================================================================================================================================================================================
function PatchOptionsMM() {
    
    # HERO MODE #

    if (IsText -Elem $Options.Damage -Text "OKHO Mode" -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "BABE7F" -Values @("09", "04") -Interval 16
        ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("2A", "00")
        ChangeBytes -File $Files.decompressedROM -Offset "BABEA5" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled -Not) -and (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled -Not) ) {
        ChangeBytes -File $Files.decompressedROM -Offset "BABE7F" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "C0") }
            ChangeBytes -Elem -File $Files.decompressedROM -Offset "BABEA5" -Values @("00", "00", "00")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("29", "00") }
            ChangeBytes -File $Files.decompressedROM -Offset "BABEA5" -Values @("05", "28", "43")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/4x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("29", "00") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("29", "40") }
            ChangeBytes -File $Files.decompressedROM -Offset "BABEA5" -Values @("05", "28", "83")
        }
        elseif (IsText -Elem $Options.Recovery -Text "0x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("29", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("29", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("29", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BABEA2" -Values @("2A", "00") }
            ChangeBytes -File $Files.decompressedROM -Offset "BABEA5" -Values @("05", "29", "43")
        }
    }



    # D-PAD #

    if (IsChecked -Elem $Options.LeftDPad -Enabled)            { ChangeBytes -File $Files.decompressedROM -Offset "3806365" -Values @("01") }
    elseif (IsChecked -Elem $Options.RightDPad -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "3806365" -Values @("02") }
    elseif (IsChecked -Elem $Options.HideDPad -Enabled)        { ChangeBytes -File $Files.decompressedROM -Offset "3806365" -Values @("00") }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "BD5D74" -Values @("3C", "07", "3F", "E3")
        ChangeBytes -File $Files.decompressedROM -Offset "CA58F5" -Values @("6C", "53", "6C", "84", "9E", "B7", "53", "6C") -Interval 2
    }

    if (IsChecked -Elem $Options.WidescreenTextures -Enabled) {
        PatchBytes -File $Files.decompressedROM -Offset "A9A000" -Length "12C00" -Patch "Carnival of Time.bin"
        PatchBytes -File $Files.decompressedROM -Offset "AACC00" -Length "12C00" -Patch "Four Giants.bin"
        PatchBytes -File $Files.decompressedROM -Offset "C74DD0" -Length "800"   -Patch "Lens of Truth.bin"
    }

    if (IsChecked -Elem $Options.ExtendedDraw -Enabled)        { ChangeBytes -File $Files.decompressedROM -Offset "B50874" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.BlackBars -Enabled)           { ChangeBytes -File $Files.decompressedROM -Offset "BF72A4" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.PixelatedStars -Enabled)      { ChangeBytes -File $Files.decompressedROM -Offset "B943FC" -Values @("10", "00") }



    # GAMEPLAY
    
    if (IsChecked -Elem $Options.ZoraPhysics -Enabled $True)   { PatchBytes -File $Files.decompressedROM -Offset "65D000" -Patch "Zora Physics Fix.bin" }



    # RESTORE

    if (IsChecked -Elem $Options.CorrectRomaniSign -Enabled)   { PatchBytes -File $Files.decompressedROM -Offset "26A58C0" -Patch "Romani Sign.bin" }
    if (IsChecked -Elem $Options.CorrectComma -Enabled)        { ChangeBytes -File $Files.decompressedROM -Offset "ACC660" -Values @("00", "F3", "00", "00", "00", "00", "00", "00", "4F", "60", "00", "00", "00", "00", "00", "00", "24") }
    if (IsChecked -Elem $Options.RestoreTitle -Enabled)        { ChangeBytes -File $Files.decompressedROM -Offset "DE0C2E" -Values @("DE", "D0", "36", "10", "66", "00") }

    if (IsChecked -Elem $Options.CorrectRupeeColors -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "10ED020" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -File $Files.decompressedROM -Offset "10ED040" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Options.CorrectCircusMask -Enabled) {
        PatchBytes -File $Files.decompressedROM -Offset "A2DDC4" -Length "26F" -Texture -Patch "Troupe Leader's Mask.yaz0"

        ChangeBytes -File $Files.decompressedROM -Offset "AD423D" -Values @("54", "72", "6F", "75", "70", "65")
        ChangeBytes -File $Files.decompressedROM -Offset "B12B60" -Values @("54", "72", "6F", "75", "70", "65")
        ChangeBytes -File $Files.decompressedROM -Offset "B1B766" -Values @("54", "72", "6F", "75", "70", "65")
        ChangeBytes -File $Files.decompressedROM -Offset "B1F495" -Values @("54", "72", "6F", "75", "70", "65")
        ChangeBytes -File $Files.decompressedROM -Offset "B20678" -Values @("74", "72", "6F", "75", "70", "65")
        ChangeBytes -File $Files.decompressedROM -Offset "B21258" -Values @("54", "72", "6F", "75", "70", "65")
        ChangeBytes -File $Files.decompressedROM -Offset "B22B67" -Values @("54", "72", "6F", "75", "70", "65")
    }

    if (IsChecked -Elem $Options.RestoreSkullKid -Enabled) {
        $Values = @()
        for ($i=0; $i -lt 256; $i++) {
            $Values += 0
            $Values += 1
        }
        ChangeBytes -File $Files.decompressedROM -Offset "181C820" -Values $Values
    }

    if (IsChecked -Elem $Options.RestorePalaceRoute -Enabled) {
        PatchBytes -File $Files.decompressedROM -Offset "2534000" -Patch "Palace Route\DekuScene.bin"

        PatchBytes -File $Files.decompressedROM -Offset "2542000" -Patch "Palace Route\DekuRoom00.bin"

        PatchBytes -File $Files.decompressedROM -Offset "2554000" -Patch "Palace Route\DekuRoom01.bin"
        ChangeBytes -File $Files.decompressedROM "1F6A7" -Values @("B0")
        ChangeBytes -File $Files.decompressedROM "253419F" -Values @("B0")

        PatchBytes -File $Files.decompressedROM -Offset "2563000" -Patch "Palace Route\DekuRoom02.bin"
        ChangeBytes -File $Files.decompressedROM "1F6B7" -Values @("B0")
        ChangeBytes -File $Files.decompressedROM "25341A7" -Values @("B0")
    }

    if (IsChecked -Elem $Options.RestoreCowNoseRing -Enabled) {
        ChangeBytes -File $Files.decompressedROM "E0FB84" -Values @("C4", "84", "00", "98", "44", "81", "30", "00", "34", "AE", "00", "04", "46", "06", "20", "3C", "00", "00", "00", "00", "45", "00", "00", "1F")
        ChangeBytes -File $Files.decompressedROM "E10270" -Values @("00", "00", "00", "00", "03", "E0", "00", "08", "00", "00", "00", "00", "27", "BD", "FF", "E8")
    }



    # EQUIPMENT #

    if (IsChecked -Elem $Options.ReducedItemCapacity -Enabled) {
        ChangeBytes -File $Files.decompressedROM "C5834F" -Values @("14", "19", "1E") -Interval 2
        ChangeBytes -File $Files.decompressedROM "C58357" -Values @("0A", "0F", "14") -Interval 2
        ChangeBytes -File $Files.decompressedROM "C5837F" -Values @("05", "0A", "0F") -Interval 2
        ChangeBytes -File $Files.decompressedROM "C58387" -Values @("0A", "0F", "14") -Interval 2
    }
    elseif (IsChecked -Elem $Options.IncreasedIemCapacity -Enabled) {
        ChangeBytes -File $Files.decompressedROM "C5834F" -Values @("28", "46", "63") -Interval 2
        ChangeBytes -File $Files.decompressedROM "C58357" -Values @("1E", "37", "50") -Interval 2
        ChangeBytes -File $Files.decompressedROM "C5837F" -Values @("0F", "1E", "2D") -Interval 2
        ChangeBytes -File $Files.decompressedROM "C58387" -Values @("1E", "37", "50") -Interval 2
    }

    if (IsChecked -Elem $Options.RazorSword -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "CBA496" -Values @("00", "00") # Prevent losing hits
        ChangeBytes -File $Files.decompressedROM -Offset "BDA6B7" -Values @("01")       # Keep sword after Song of Time
    }



    # OTHER #
    
    if (IsChecked -Elem $Options.DisableLowHPSound -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "B97E2A"  -Values @("00", "00") }
    if (IsChecked -Elem $Options.PieceOfHeartSound -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "BA94C8"  -Values @("10", "00") }
    if (IsChecked -Elem $Options.FixGohtCutscene -Enabled)     { ChangeBytes -File $Files.decompressedROM -Offset "F6DE89"  -Values @("8D", "00", "02", "10", "00", "00", "0A") }
    if (IsChecked -Elem $Options.MoveBomberKid -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "2DE4396" -Values @("02", "C5", "01", "18", "FB", "55", "00", "07", "2D") }
    if (IsChecked -Elem $Options.FixMushroomBottle -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "CD7C48"  -Values @("1E", "6B") }

}



#==============================================================================================================================================================================================
function PatchOptionsSM64() {
    
    if ( !(IsChecked -Elem $PatchOptionsCheckbox -Visible) -or !$GamePatch.options) { return }
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")

    Copy-Item -LiteralPath $Files.ROM -Destination $Files.decompressedROM



    # HERO MODE

    if (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)       { ChangeBytes -File $Files.decompressedROM -Offset "F207" -Values @("80") }
    elseif (IsText -Elem $Options.Damage -Text "3x Damage" -Enabled)   { ChangeBytes -File $Files.decompressedROM -Offset "F207" -Values @("40") }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "3855E" -Values @("47", "40")
        ChangeBytes -File $Files.decompressedROM -Offset "35456" -Values @("46", "C0")
    }

    if (IsChecked -Elem $Options.ForceHiresModel -Enabled)     { ChangeBytes -File $Files.decompressedROM -Offset "32184" -Values @("10", "00")}
    
    if (IsChecked -Elem $Options.BlackBars -Enabled) {
        ChangeBytes -File $Files.decompressedROM -Offset "23A7" -Values @("BC", "00") -Interval 12
        ChangeBytes -File $Files.decompressedROM -Offset "248E" -Values @("00")
        ChangeBytes -File $Files.decompressedROM -Offset "2966" -Values @("00", "00") -Interval 48
        ChangeBytes -File $Files.decompressedROM -Offset "3646A" -Values @("00")
        ChangeBytes -File $Files.decompressedROM -Offset "364AA" -Values @("00")
        ChangeBytes -File $Files.decompressedROM -Offset "364F6" -Values @("00")
        ChangeBytes -File $Files.decompressedROM -Offset "36582" -Values @("00")
        ChangeBytes -File $Files.decompressedROM -Offset "3799F" -Values @("BC", "00") -Interval 12
    }



    # GAMEPLAY #
    if (IsChecked -Elem $Options.FPS -Enabled)                 { ApplyPatch -File $Files.decompressedROM -Patch "\fps.bps" }
    if (IsChecked -Elem $Options.FreeCam -Enabled)             { ApplyPatch -File $Files.decompressedROM -Patch "\cam.bps" }
    if (IsChecked -Elem $Options.LagFix -Enabled)              { ChangeBytes -File $Files.decompressedROM -Offset "F0022" -Values @("0D") }

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
    $Identical = $true

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

    # If the patched file was created.
    if (TestPath -LiteralPath $WadFile.Patched) {
        # Play a sound when it is finished.
        [Media.SystemSounds]::Beep.Play()
  
        # Set the status label.
        UpdateStatusLabel -Text "Complete! File successfully patched."
    }
    # If the patched file failed to be created, set the status label to failed.
    UpdateStatusLabel -Text "Failed! Patched Wii VC WAD was not created."

    # Remove the folder the extracted files were in, and delete files
    RemovePath -LiteralPath $WadFile.Folder

    # Doesn't matter, but return to where we were.
    Pop-Location

}



#==================================================================================================================================================================================================================================================================
function EnablePatchButtons([Boolean]$Enable) {
    
    # Set the status that we are ready to roll... Or not...
    if ($Enable)        { UpdateStatusLabel -Text "Ready to patch!" }
    elseif ($IsWiiVC)   { UpdateStatusLabel -Text "Select your Virtual Console WAD file to continue." }
    else                { UpdateStatusLabel -Text "Select your Nintendo 64 ROM file to continue." }

    if ($IsWiiVC)      {
        $InjectROMButton.Enabled = ($Files.WAD -ne $null -and $Files.Z64 -ne $null)
        $PatchBPSButton.Enabled = ($Files.WAD -ne $null -and $Files.BPS -ne $null) } else { $PatchBPSButton.Enabled = ($Files.Z64 -ne $null -and $Files.BPS -ne $null)
   }
    
    # Enable patcher buttons.
    $PatchPanel.Enabled = $Enable

    # Enable ROM extract
    $ExtractROMButton.Enabled = $Enable

}



#==================================================================================================================================================================================================================================================================
function WADPath_Finish([Object]$TextBox, [String]$VarName, [String]$WADPath) {

    # Set the "GameWAD" variable that tracks the path.
    Set-Variable -Name $VarName -Value $WADPath -Scope 'Global'
    $Files.WAD = Get-Item -LiteralPath $WADPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $WADPath

    ChangeGamesList
    SetWiiVCMode -Enable $True

    # Check if both a .WAD and .Z64 have been provided for ROM injection
    if ($Files.Z64 -ne $null) { $InjectROMButton.Enabled = $true }

    # Check if both a .WAD and .BPS have been provided for BPS patching
    if ($Files.BPS -ne $null) { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_Finish([Object]$TextBox, [String]$VarName, [String]$Z64Path) {
    
    # Set the "Z64 ROM" variable that tracks the path.
    Set-Variable -Name $VarName -Value $Z64Path -Scope 'Global'
    $Files.Z64 = Get-Item -LiteralPath $Z64Path

    $HashSumROMTextBox.Text = (Get-FileHash -Algorithm MD5 $Z64Path).Hash

    # Update the textbox to the current WAD.
    $TextBox.Text = $Z64Path

    if (!$IsWiiVC) { EnablePatchButtons -Enable $True }
    
    # Check if both a .WAD and .Z64 have been provided for ROM injection or both a .Z64 and .BPS have been provided for BPS patching
    if ($Files.WAD -ne $null -and $IsWiiVC)        { $InjectROMButton.Enabled = $true }
    elseif ($Files.BPS -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Finish([Object]$TextBox, [String]$VarName, [String]$BPSPath) {
    
    # Set the "BPS File" variable that tracks the path.
    Set-Variable -Name $VarName -Value $BPSPath -Scope 'Global'
    $Files.BPS = Get-Item -LiteralPath $BPSPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $BPSPath

    # Check if both a .WAD and Patch File have been provided for Patch File patching
    if ($Files.WAD -ne $null -and $IsWiiVC)        { $PatchBPSButton.Enabled = $true }
    elseif ($Files.Z64 -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function WADPath_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a WAD file.
            if ($DroppedExtn -eq '.wad') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                WADPath_Finish -TextBox $InputWADTextBox -VarName $this.Name -WADPath $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a Z64 ROM.
            if ($DroppedExtn -eq '.z64' -or $DroppedExtn -eq '.n64' -or $DroppedExtn -eq '.v64') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                Z64Path_Finish -TextBox $InputROMTextBox -VarName $this.Name -Z64Path $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a BPS File.
            if ($DroppedExtn -eq '.bps' -or $DroppedExtn -eq '.ips' -or $DroppedExtn -eq '.xdelta' -or $DroppedExtn -eq '.vcdiff') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                BPSPath_Finish -TextBox $InputBPSTextBox -VarName $this.Name -BPSPath $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function WADPath_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        $Settings["Core"][$this.name] = $SelectedPath
        WADPath_Finish -TextBox $TextBox -VarName $this.Name -WADPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        $Settings["Core"][$this.name] = $SelectedPath
        Z64Path_Finish -TextBox $TextBox -VarName $this.Name -Z64Path $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        $Settings["Core"][$this.name] = $SelectedPath
        BPSPath_Finish -TextBox $TextBox -VarName $this.Name -BPSPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function CreateToolTip() {

    # Create ToolTip
    $ToolTip = New-Object System.Windows.Forms.ToolTip
    $ToolTip.AutoPopDelay = 32767
    $ToolTip.InitialDelay = 500
    $ToolTip.ReshowDelay = 0
    $ToolTip.ShowAlways = $true
    return $ToolTip

}



#==============================================================================================================================================================================================
function CreateMainDialog() {

    # Create the main dialog that is shown to the user.
    $global:MainDialog = New-Object System.Windows.Forms.Form
    $MainDialog.Text = $ScriptName
    $MainDialog.Size = New-Object System.Drawing.Size(625, 745)
    $MainDialog.MaximizeBox = $false
    $MainDialog.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None
    $MainDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $MainDialog.StartPosition = "CenterScreen"
    $MainDialog.KeyPreview = $true
    $MainDialog.Add_Shown({ $MainDialog.Activate() })
    $MainDialog.Icon = $Files.icon.main

    # Create a tooltip
    $global:ToolTip = CreateToolTip

    # Create a label to show current mode.
    $global:CurrentModeLabel = CreateLabel -Font $CurrentModeFont -AddTo $MainDialog
    $CurrentModeLabel.AutoSize = $True

    # Create a label to show current version.
    $global:VersionLabel = CreateLabel -X 15 -Y 10 -Width 120 -Height 30 -Text ("Version: " + $Version + "`n(" + $VersionDate + ")") -Font $VCPatchFont -AddTo $MainDialog



    ############
    # WAD Path #
    ############

    # Create the panel that holds the WAD path.
    $global:InputWADPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the WAD path.
    $global:InputWADGroup = CreateGroupBox -Width $InputWADPanel.Width -Height $InputWADPanel.Height -Name "GameWAD" -Text "WAD Path" -AddTo $InputWADPanel
    $InputWADGroup.AllowDrop = $True
    $InputWADGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADGroup.Add_DragDrop({ WADPath_DragDrop })

    # Create a textbox to display the selected WAD.
    $global:InputWADTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameWAD" -Text "Select or drag and drop your Virtual Console WAD file..." -ReadOnly $True -AddTo $InputWADGroup
    $InputWADTextBox.AllowDrop = $True
    $InputWADTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADTextBox.Add_DragDrop({ WADPath_DragDrop })

    # Create a button to allow manually selecting a WAD.
    $global:InputWADButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameWAD" -Text "..." -ToolTip $ToolTip -Info "Select your VC WAD File using file explorer" -AddTo $InputWADGroup
    $InputWADButton.Add_Click({ WADPath_Button -TextBox $InputWADTextBox -Description 'VC WAD File' -FileName '*.wad' })

    # Create a button to clear the WAD Path
    $global:ClearWADPathButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Clear" -ToolTip $ToolTip -Info "Clear the selected WAD file" -AddTo $InputWADGroup
    $ClearWADPathButton.Add_Click({
        if (IsSet -Elem $Files.WAD -MinLength 1) {
            $Files.WAD = $null
            $Settings["Core"][$InputWADTextBox.name] = ""
            $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
            ChangeGamesList
            SetWiiVCMode -Enable $False
        }
    })



    ############
    # ROM Path #
    ############

    # Create the panel that holds the ROM path.
    $global:InputROMPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the ROM path.
    $InputROMGroup = CreateGroupBox -Width $InputROMPanel.Width -Heigh $InputROMPanel.Height -Name "GameZ64" -Text "ROM Path" -AddTo $InputROMPanel
    $InputROMGroup.AllowDrop = $True
    $InputROMGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMGroup.Add_DragDrop({ Z64Path_DragDrop })

    # Create a textbox to display the selected ROM.
    $global:InputROMTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameZ64" -Text "Select or drag and drop your Z64, N64 or V64 ROM..." -ReadOnly $True -AddTo $InputROMGroup
    $InputROMTextBox.AllowDrop = $True
    $InputROMTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMTextBox.Add_DragDrop({ Z64Path_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $global:InputROMButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameZ64" -Text "..." -ToolTip $ToolTip -Info "Select your Z64, N64 or V64 ROM File using file explorer" -AddTo $InputROMGroup
    $InputROMButton.Add_Click({ z64Path_Button -TextBox $InputROMTextBox -Description @('Z64 ROM', 'N64 ROM', 'V64 ROM') -FileName @('*.z64', '*.n64', '*.v64') })
    
    # Create a button to allow patch the WAD with a ROM file.
    $global:InjectROMButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Inject ROM" -ToolTip $ToolTip -Info "Replace the ROM in your selected WAD File with your selected Z64, N64 or V64 ROM File" -AddTo $InputROMGroup
    $InjectROMButton.Add_Click({ MainFunction -Command "Inject" -PatchedFileName '_injected' })



    ############
    # BPS Path #
    ############
    
    # Create the panel that holds the BPS path.
    $global:InputBPSPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the BPS path.
    $InputBPSGroup = CreateGroupBox -Width $InputBPSPanel.Width -Height $InputBPSPanel.Height -Name "GameBPS" -Text "Custom Patch Path" -AddTo $InputBPSPanel
    $InputBPSGroup.AllowDrop = $True
    $InputBPSGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSGroup.Add_DragDrop({ BPSPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $global:InputBPSTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameBPS" -Text "Select or drag and drop your BPS, IPS, Xdelta or VCDiff Patch File..." -ReadOnly $True -AddTo $InputBPSGroup
    $InputBPSTextBox.AllowDrop = $True
    $InputBPSTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSTextBox.Add_DragDrop({ BPSPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $global:InputBPSButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameBPS" -Text "..." -ToolTip $ToolTip -Info "Select your BPS, IPS, Xdelta or VCDiff Patch File using file explorer" -AddTo $InputBPSGroup
    $InputBPSButton.Add_Click({ BPSPath_Button -TextBox $InputBPSTextBox -Description @('BPS Patch File', 'IPS Patch File', 'XDelta Patch File', 'VCDiff Patch File') -FileName @('*.bps', '*.ips', '*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $global:PatchBPSButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Apply Patch" -ToolTip $ToolTip -Info "Patch the ROM with your selected BPS or IPS Patch File" -AddTo $InputBPSGroup
    $PatchBPSButton.Add_Click({ MainFunction -Command "Apply Patch" -Patch $Files.BPS -PatchedFileName '_bps_patched' })



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game.
    $global:CurrentGamePanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the current game options
    $CurrentGameGroup = CreateGroupBox -Width $CurrentGamePanel.Width -Height $CurrentGamePanel.Height -Text "Current Game Mode" -Name "CurrentGame" -AddTo $CurrentGamePanel

    # Create a combox for OoT ROM hack patches
    $global:CurrentGameComboBox = CreateComboBox -X 10 -Y 20 -Width 440 -Height 30 -Name "CurrentGame" -AddTo $CurrentGameGroup
    $CurrentGameComboBox.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameType.title) { ChangeGameMode }
    })

    if (Test-Path -LiteralPath $Files.json.games) {
        try { $Files.json.games = Get-Content -Raw -Path $Files.json.games | ConvertFrom-Json }
        catch { CreateErrorDialog -Error "Corrupted JSON" -Exit }
    }
    else { CreateErrorDialog -Error "Corrupted JSON" }



    ##################
    # Custom Game ID #
    ##################

    # Create the panel that holds the Custom GameID.
    $global:CustomGameIDPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the Custom GameID.
    $CustomGameIDGroup = CreateGroupBox -Width $CustomGameIDPanel.Width -Height $CustomGameIDPanel.Height -Name "CustomGameID" -Text "Custom Channel Title and GameID" -AddTo $CustomGameIDPanel

    # Create a label to show Custom Channel Title description.
    $global:InputCustomTitleTextBoxLabel = CreateLabel -X 8 -Y 22 -Width 75 -Height 15 -Text "Channel Title:" -AddTo $CustomGameIDGroup

    # Create a textbox to display the selected Custom Channel Title.
    $global:InputCustomTitleTextBox = CreateTextBox -X 85 -Y 20 -Width 260 -Height 22 -Name "CustomGameID" -AddTo $CustomGameIDGroup
    $InputCustomTitleTextBox.Add_TextChanged({
        if ($this.Text -match "[^a-z 0-9 \: \- \( \) \']") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text -replace "[^a-z 0-9 \: \- \( \) \']",''
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })

    # Create a label to show Custom GameID description
    $global:InputCustomGameIDTextBoxLabel = CreateLabel -X 370 -Y 22 -Width 50 -Height 15 -Text "GameID:" -AddTo $CustomGameIDGroup

    # Create a textbox to display the selected Custom GameID.
    $global:InputCustomGameIDTextBox = CreateTextBox -X 425 -Y 20 -Width 55 -Height 22 -Name "CustomGameID" -AddTo $CustomGameIDGroup
    $InputCustomGameIDTextBox.MaxLength = 4
    $InputCustomGameIDTextBox.Add_TextChanged({
        if ($this.Text -cmatch "[^A-Z 0-9]") {
            $this.Text = $this.Text.ToUpper() -replace "[^A-Z 0-9]",''
            $this.Select($this.Text.Length, $this.Text.Length)
        }
    })

    # Create a label to show Custom GameID description
    $global:InputCustomGameIDCheckboxLabel = CreateLabel -X 510 -Y 22 -Width 50 -Height 15 -Text "Enable:" -AddTo $CustomGameIDGroup

    # Create a checkbox to allow Custom Channel Title & GameID.
    $global:InputCustomGameIDCheckbox = CreateCheckBox -X 560 -Y 20 -Width 20 -Height 20 -Name "CustomGameID" -AddTo $CustomGameIDGroup




    ###############
    # Patch Panel #
    ###############

    # Create a panel to contain everything for patches.
    $global:PatchPanel = CreatePanel -Width 590 -Height 90 -AddTo $MainDialog 

    # Create a groupbox to show the patching buttons.
    $global:PatchGroup = CreateGroupBox -Width $PatchPanel.Width -Height $PatchPanel.Height -AddTo $PatchPanel

    # Create patch button
    $global:PatchButton = CreateButton -X 10 -Y 45 -Width 300 -Height 35 -Text "Patch Selected Option" -AddTo $PatchGroup
    $PatchButton.Add_Click( { MainFunction -Command $GamePatch.command -PatchedFileName $GamePatch.output } )

    # Create combobox
    $global:PatchComboBox = CreateComboBox -X $PatchButton.Left -Y ($PatchButton.Top - 25) -Width $PatchButton.Width -Height 30 -Name "Patch" -AddTo $PatchGroup
    $PatchComboBox.Add_SelectedIndexChanged( {
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        foreach ($Item in $Files.json.patches.patch) {
            if ($Item.title -eq $PatchComboBox.Text) {
                if ( ($IsWiiVC -and $Item.console -eq "Wii VC") -or (!$IsWiiVC -and $Item.console -eq "N64") -or ($Item.console -eq "All") ) {
                    $global:GamePatch = $Item
                }
            }
        }
        DisablePatches
        CreateLanguagesContent
    } )

    # Create a checkbox to enable Redux and Options support.
    $global:PatchReduxLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchComboBox.Top + 5) -Width 85 -Height 15 -Text "Enable Redux:" -ToolTip $ToolTip -Info "Enable the Redux patch" -AddTo $PatchGroup
    $global:PatchReduxCheckbox = CreateCheckBox -X $PatchReduxLabel.Right -Y ($PatchReduxLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -Name "Redux" -AddTo $PatchGroup
    $PatchReduxCheckbox.Add_CheckStateChanged({ EnableReduxOptions })

    $global:PatchOptionsLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchReduxLabel.Bottom + 15) -Width 85 -Height 15 -Text "Enable Options:" -ToolTip $ToolTip -Info "Enable options" -AddTo $PatchGroup
    $global:PatchOptionsCheckbox = CreateCheckBox -X $PatchOptionsLabel.Right -Y ($PatchOptionsLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable options" -Name "Options" -AddTo $PatchGroup
    $PatchOptionsCheckbox.Add_CheckStateChanged({ $PatchOptionsButton.Enabled = $this.Checked })

    $global:PatchLanguagesButton = CreateButton -X ($PatchOptionsCheckbox.Right + 5) -Y 20 -Width 145 -Height 25 -Text "Select Language" -ToolTip $ToolTip -Info 'Open the "Languages" panel to change the language' -AddTo $PatchGroup
    $PatchLanguagesButton.Add_Click( { $LanguagesDialog.ShowDialog() } )

    $global:PatchOptionsButton = CreateButton -X $PatchLanguagesButton.Left -Y ($PatchLanguagesButton.Bottom + 5) -Width $PatchLanguagesButton.Width -Height $PatchLanguagesButton.Height -Text "Select Options" -ToolTip $ToolTip -Info 'Open the "Additional Options" panel to change preferences' -AddTo $PatchGroup
    $PatchOptionsButton.Add_Click( { $OptionsDialog.ShowDialog() } )
    $PatchOptionsButton.Enabled = $False



    ####################
    # Patch VC Options #
    ####################

    # Create a panel to show the patch options.
    $global:PatchVCPanel = CreatePanel -Width 590 -Height 105 -AddTo $MainDialog

    # Create a groupbox to show the patch options.
    $global:PatchVCGroup = CreateGroupBox -Width $PatchVCPanel.Width -Height $PatchVCPanel.Height -Text "Virtual Console - Patch Options" -AddTo $PatchVCPanel



    # Create a label for Core patches
    $global:PatchVCCoreLabel = CreateLabel -X 10 -Y 22 -Width 50 -Height 15 -Text "Core" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remove T64 description
    $global:PatchVCRemoveT64Label = CreateLabel -X ($PatchVCCoreLabel.Right + 20) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remove All T64:" -ToolTip $ToolTip -Info "Remove all injected T64 format textures" -AddTo $PatchVCGroup
    $global:PatchVCRemoveT64 = CreateCheckBox -X $PatchVCRemoveT64Label.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remove all injected T64 format textures" -Name "RemoveT64" -AddTo $PatchVCGroup
    $PatchVCRemoveT64.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })
    
    # Expand Memory
    $global:PatchVCExpandMemoryLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Expand Memory:" -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $global:PatchVCExpandMemory = CreateCheckBox -X $PatchVCExpandMemoryLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -Name "ExpandMemory" -AddTo $PatchVCGroup
    $PatchVCExpandMemory.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Remove Filter
    $global:PatchVCRemoveFilterLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remove Filter:" -ToolTip $ToolTip -Info "Remove the dark overlay filter" -AddTo $PatchVCGroup
    $global:PatchVCRemoveFilter = CreateCheckBox -X $PatchVCRemoveFilterLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remove the dark overlay filter" -Name "RemoveFilter" -AddTo $PatchVCGroup
    $PatchVCRemoveFilter.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Remap D-Pad
    $global:PatchVCRemapDPadLabel = CreateLabel -X ($PatchVCExpandMemory.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remap D-Pad:" -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $global:PatchVCRemapDPad = CreateCheckBox -X $PatchVCRemapDPadLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -Name "RemapDPad" -AddTo $PatchVCGroup
    $PatchVCRemapDPad.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Downgrade
    $global:PatchVCDowngradeLabel = CreateLabel -X ($PatchVCRemapDPad.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Downgrade:" -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $global:PatchVCDowngrade = CreateCheckBox -X $PatchVCDowngradeLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -Name "Downgrade" -AddTo $PatchVCGroup
    $PatchVCDowngrade.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })



    # Create a label for Minimap
    $global:PatchVCMinimapLabel = CreateLabel -X 10 -Y ($PatchVCCoreLabel.Bottom + 5) -Width 50 -Height 15 -Text "Minimap" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remap C-Down
    $global:PatchVCRemapCDownLabel = CreateLabel -X ($PatchVCMinimapLabel.Right + 20) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap C-Down:" -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapCDown = CreateCheckBox -X $PatchVCRemapCDownLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -Name "RemapCDown" -AddTo $PatchVCGroup
    $PatchVCRemapCDown.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Remap Z
    $global:PatchVCRemapZLabel = CreateLabel -X ($PatchVCRemapCDown.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap Z:" -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapZ = CreateCheckBox -X $PatchVCRemapZLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -Name "RemapZ" -AddTo $PatchVCGroup
    $PatchVCRemapZ.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Leave D-Pad Up
    $global:PatchVCLeaveDPadUpLabel = CreateLabel -X ($PatchVCRemapZ.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Leave D-Pad Up:" -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $global:PatchVCLeaveDPadUp = CreateCheckBox -X $PatchVCLeaveDPadUpLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -Name "LeaveDPadUp" -AddTo $PatchVCGroup
    $PatchVCLeaveDPadUp.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })



    # Create a label for Patch VC Buttons
    $global:ActionsLabel = CreateLabel -X 10 -Y 72 -Width 50 -Height 15 -Text "Actions" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Create a button to patch the VC
    $global:PatchVCButton = CreateButton -X 80 -Y 65 -Width 150 -Height 30 -Text "Patch VC Emulator Only" -ToolTip $ToolTip -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted" -AddTo $PatchVCGroup
    $PatchVCButton.Add_Click({ MainFunction -Command "Patch VC" -Patch $Files.BPS -PatchedFileName '_vc_patched' })

    # Create a button to extract the ROM
    $global:ExtractROMButton = CreateButton -X 240 -Y 65 -Width 150 -Height 30 -Text "Extract ROM Only" -ToolTip $ToolTip -Info "Only extract the .Z64 ROM from the WAD file`nUseful for native N64 emulators" -AddTo $PatchVCGroup
    $ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -Patch $Files.BPS })



    ##############
    # Misc Panel #
    ##############

    # Create a panel to contain everything for other.
    $global:MiscPanel = CreatePanel -Width 625 -Height 75 -AddTo $MainDialog

    # Create a groupbox to show the misc buttons.
    $global:MiscGroup = CreateGroupBox -Width 590 -Height $MiscPanel.Height -Text "Other Buttons" -AddTo $MiscPanel

    # Create a button to show info about which GameID to use.
    $InfoGameIDButton = CreateButton -X 30 -Y 25 -Width 120 -Height 35 -Text "GameID's and Hashsums" -ToolTip $ToolTip -Info "Open the list with official, used and recommend GameID and hashsum values to refer to" -AddTo $MiscGroup
    $InfoGameIDButton.Add_Click({ $InfoGameIDDialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoButton = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 120 -Height 35 -AddTo $MiscGroup
    $InfoButton.Add_Click({ $InfoDialog.ShowDialog() | Out-Null })

    # Create a button to show credits about the patches.
    $global:CreditsButton = CreateButton -X ($InfoButton.Right + 15) -Y $InfoGameIDButton.Top -Width 120 -Height 35 -ToolTip $ToolTip -Info ("Open the list with credits of all of patches involved and those who helped with the " + $ScriptName + " tool") -AddTo $MiscGroup
    $CreditsButton.Add_Click({ $CreditsDialog.ShowDialog() | Out-Null })

    # Create a button to close the dialog.
    $global:ExitButton = CreateButton -X ($CreditsButton.Right + 15) -Y $InfoGameIDButton.Top -Width 120 -Height 35 -Text "Exit" -ToolTip $ToolTip -Info ("Save all settings and close the " + $ScriptName + " tool") -AddTo $MiscGroup
    $ExitButton.Add_Click({ $MainDialog.Close() })



    ##############
    # Misc Panel #
    ##############

    $global:StatusPanel = CreatePanel -Width 625 -Height 30 -AddTo $MainDialog
    $global:StatusGroup = CreateGroupBox -Width 590 -Height 30 -AddTo $StatusPanel
    $global:StatusLabel = Createlabel -X 8 -Y 10 -Width 570 -Height 15 -AddTo $StatusGroup



    ###############
    # Positioning #
    ###############

    $InputWADPanel.Location = New-Object System.Drawing.Size(10, 50)
    $InputROMPanel.Location = New-Object System.Drawing.Size(10, ($InputWADPanel.Bottom + 5))
    $InputBPSPanel.Location = New-Object System.Drawing.Size(10, ($InputROMPanel.Bottom + 5))
    $CurrentGamePanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))
    $CustomGameIDPanel.Location = New-Object System.Drawing.Size(10, ($CurrentGamePanel.Bottom + 5))
    $PatchPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5))

}



#==============================================================================================================================================================================================
function ChangeGamesList() {
    
    # Reset
    $CurrentGameComboBox.Items.Clear()

    $Items = @()
    Foreach ($Game in $Files.json.games.game) {
        if ( ($IsWiiVC -and $Game.console -eq "Wii VC") -or (!$IsWiiVC -and $Game.console -eq "N64") -or ($Game.console -eq "All") ) { $Items += $Game.title }
    }

    $CurrentGameComboBox.Items.AddRange($Items)

    # Reset last index
    For ($i=0; $i -lt $Items.Length; $i++) {
        if ($GameType.title -eq $Items[$i]) { $CurrentGameComboBox.SelectedIndex = $i }
    }

    if ($Items.Length -gt 0 -and $CurrentGameComboBox.SelectedIndex -eq -1) {
        try { $CurrentGameComboBox.SelectedIndex = $Settings["Core"][$CurrentGameComboBox.Name] }
        catch { $CurrentGameComboBox.SelectedIndex = 0 }
    }

}



#==============================================================================================================================================================================================
function ChangePatchPanel() {
    
    # Reset
    $PatchGroup.text = $GameType.mode + " - Patch Options"
    $PatchComboBox.Items.Clear()

    # Set combobox for patches
    $Items = @()
    foreach ($i in $Files.json.patches.patch) {
        if ( ($IsWiiVC -and $i.console -eq "Wii VC") -or (!$IsWiiVC -and $i.console -eq "N64") -or ($i.console -eq "All") ) {
            $Items += $i.title
            if (!(IsSet -Elem $FirstItem)) { $FirstItem = $i }
        }
        $global:ToolTip.SetToolTip($PatchButton, ([String]::Format($FirstItem.tooltip, [Environment]::NewLine)))
    }

    $PatchComboBox.Items.AddRange($Items)

    # Reset last index
    For ($i=0; $i -lt $Items.Length; $i++) {
        Foreach ($Item in $Files.json.patches.patch) {
            if ($Item.title -eq $GamePatch.title -and $Item.title -eq $Items[$i]) { $PatchComboBox.SelectedIndex = $i }
        }
    }
    if ($Items.Length -gt 0 -and $PatchComboBox.SelectedIndex -eq -1) {
        try { $PatchComboBox.SelectedIndex = $Settings["Core"][$PatchComboBox.Name] }
        catch { $PatchComboBox.SelectedIndex = 0 }
    }

    if ($GameType.options)  { $global:ToolTip.SetToolTip($PatchOptionsButton, "Toggle options for the " + $GameType.mode +  " REDUX romhack") }

}



#==============================================================================================================================================================================================
function SetMainScreenSize() {
    
    if ($IsWiiVC) {
        $InputCustomTitleTextBoxLabel.Text = "Channel Title:"
        if ($GameType.patches)   { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchPanel.Bottom + 5)) }
        else                     { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($CurrentGamePanel.Bottom + 5)) }
        $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchVCPanel.Bottom + 5))
    }

    else {
        $InputCustomTitleTextBoxLabel.Text = "Game Title:"
        if ($GameType.patches)   { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchPanel.Bottom + 5)) }
        else                     { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5)) }
    }

    $StatusPanel.Location = New-Object System.Drawing.Size(10, ($MiscPanel.Bottom + 5))
    $MainDialog.Height = ($StatusPanel.Bottom + 50)

}


#==============================================================================================================================================================================================
function ChangeGameMode() {
    
    Foreach ($Item in $Files.json.games.game) {
        if ($Item.title -eq $CurrentGameComboBox.text) {
            $global:GameType = $Item
            break
        }
    }

    $GameFiles.base = $Paths.games + "\" + $GameType.mode
    $GameFiles.binaries = $GameFiles.base + "\Binaries"
    $GameFiles.compressed = $GameFiles.base + "\Compressed"
    $GameFiles.decompressed = $GameFiles.base + "\Decompressed"
    $GameFiles.textures = $GameFiles.base + "\Textures"
    $GameFiles.credits = $GameFiles.base + "\Credits.txt"
    $GameFiles.info = $GameFiles.base + "\Info.txt"
    $GameFiles.icon = $GameFiles.base + "\Icon.ico"
    $GameFiles.json = $GameFiles.base + "\Patches.json"

    $Lines = Get-Content -Path $Files.settings
    if ( $Lines -notcontains ("[" + $GameType.mode + "]") ) {
        Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
        Add-Content -Path $Files.settings -Value ("[" + $GameType.mode + "]") | Out-Null
        $global:Settings = Get-IniContent $Files.settings
    }

    $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $False
    $PatchVCRemoveFilterLabel.Visible = $PatchVCRemoveFilter.Visible = $False
    $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $False
    $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $False
    
    $PatchVCMinimapLabel.Hide()
    $PatchVCRemapCDown.Visible = $PatchVCRemapCDownLabel.Visible = $False
    $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $False
    $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $False

    if (IsSet -Elem $GameType.patches) {
        if (Test-Path -LiteralPath $GameFiles.json) {
            try { $Files.json.patches = Get-Content -Raw -Path $GameFiles.json | ConvertFrom-Json }
           catch { CreateErrorDialog -Error "Corrupted JSON" }
        }
        else { CreateErrorDialog -Error "Missing JSON" }
    }

    # Info
    if (Test-Path -LiteralPath $GameFiles.info -PathType Leaf)       { AddTextFileToTextbox -TextBox $InfoTextbox -File $GameFiles.info }
    else                                                             { AddTextFileToTextbox -TextBox $InfoTextbox -File $null }
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $InfoDialog.Icon = $OptionsDialog.Icon = $LanguagesDialog.Icon = $GameFiles.icon }
    else                                                             { $InfoDialog.Icon = $OptionsDialog.Icon = $LanguagesDialog.Icon = $null }

    # Credits
    if (Test-Path -LiteralPath $Files.text.credits -PathType Leaf)   { AddTextFileToTextbox -TextBox $CreditsTextBox -File $Files.text.credits }
    if (Test-Path -LiteralPath $GameFiles.credits -PathType Leaf)    { AddTextFileToTextbox -TextBox $CreditsTextBox -File $GameFiles.credits -Add -PreSpace 2 }

    $global:ToolTip.SetToolTip($InfoButton, "Open the list with information about the " + $GameType.mode + " patching mode")
    $InfoButton.Text = "Info`n" + $GameType.mode
    $CreditsButton.Text = "Credits`n" + $GameType.mode

    $PatchPanel.Visible = $GameType.patches

    if ($GameType.mode -eq "Ocarina of Time")      { CreateOoTOptionsContent }
    elseif ($GameType.mode -eq "Majora's Mask")    { CreateMMOptionsContent }
    elseif ($GameType.mode -eq "Super Mario 64")   { CreateSM64OptionsContent }

    $OptionsLabel.text = $GameType.mode + " - Additional Options"
    $LanguagesBox.text = $GameType.mode + " - Languages"

    if ($GameType.downgrade)      { $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $True }
    if ($GameType.patch_vc -eq 2) { $PatchVCRemoveFilterLabel.Visible = $PatchVCRemoveFilter.Visible = $True }
    if ($GameType.patch_vc -eq 4) { $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $True }
    if ($GameType.patch_vc -ge 3) {
        $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $True
        $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $True
        $PatchVCMinimapLabel.Show() 
        $PatchVCRemapCDownLabel.Visible = $PatchVCRemapCDown.Visible = $True
        $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $True
    }

    SetWiiVCMode -Enable $IsWiiVC
    $PatchVCButton.Enabled = CheckVCOptions
    
}



#==============================================================================================================================================================================================
function UpdateStatusLabel([String]$Text) {
    
    $StatusLabel.Text = $Text
    $StatusLabel.Refresh()

}



#==============================================================================================================================================================================================
function SetWiiVCMode([Boolean]$Enable) {
    
    $global:IsWiiVC = $Enable

    if ($IsWiiVC) {
        EnablePatchButtons -Enable (IsSet -Elem $Files.WAD)
        $InputCustomTitleTextBox.Text = $GameType.wii_title
        $InputCustomGameIDTextBox.Text =  $GameType.wii_gameID
    }
    else {
        EnablePatchButtons -Enable (IsSet -Elem $Files.Z64)
        $InputCustomTitleTextBox.Text = $GameType.n64_title
        $InputCustomGameIDTextBox.Text =  $GameType.n64_gameID
    }
    
    $InjectROMButton.Visible = $PatchVCPanel.Visible = $IsWiiVC
    $InputCustomTitleTextBox.MaxLength = $GameTitleLength[[uint32]$IsWiiVC]
    $ClearWADPathButton.Enabled = (IsSet -Elem $Files.WAD -MinLength 1)

    SetMainScreenSize
    SetModeLabel
    ChangePatchPanel

}



#==============================================================================================================================================================================================
function SetModeLabel() {
	
    $CurrentModeLabel.Text = "Current  Mode  :  " + $GameType.mode
    if ($IsWiiVC) { $CurrentModeLabel.Text += "  (Wii  VC)" } else { $CurrentModeLabel.Text += "  (N64)" }
    $CurrentModeLabel.Location = New-Object System.Drawing.Size(([Math]::Floor($MainDialog.Width / 2) - [Math]::Floor($CurrentModeLabel.Width / 2)), 10)

}



#==============================================================================================================================================================================================
function CheckVCOptions() {

    if (IsChecked -Elem $PatchVCRemoveT64 -Visible)      { return $True }
    if (IsChecked -Elem $PatchVCExpandMemory -Visible)   { return $True }
    if (IsChecked -Elem $PatchVCRemoveFilter -Visible)   { return $True }
    if (IsChecked -Elem $PatchVCRemapDPad -Visible)      { return $True }
    if (IsChecked -Elem $PatchVCDowngrade -Visible)      { return $True }
    if (IsChecked -Elem $PatchVCRemapCDown -Visible)     { return $True }
    if (IsChecked -Elem $PatchVCRemapZ -Visible)         { return $True }
    if (IsChecked -Elem $PatchLeaveDPadUp -Visible)      { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsChecked([Object]$Elem, [Switch]$Visible, [Switch]$Enabled, [Switch]$Not) {
    
    if (!(IsSet -Elem $Elem))              { return $False }
    if ($Visible -and !$Elem.Visible)      { return $False }
    if ($Enabled -and !$Elem.Enabled)      { return $False }
    if ($Not -and !$Elem.Checked)          { return $True }
    if (!$Not -and $Elem.Checked)          { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsText([Object]$Elem, [String]$Text, [Switch]$Visible, [Switch]$Enabled, [Switch]$Not) {
    
    if (!(IsSet -Elem $Elem))              { return $False }
    if ($Visible -and !$Elem.Visible)      { return $False }
    if ($Enabled -and !$Elem.Enabled)      { return $False }
    if ($Not -and $Elem.Text -ne $Text)    { return $True }
    if (!$Not -and $Elem.Text -eq $Text)   { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsSet([Object]$Elem, [int]$Min, [int]$Max, [int]$MinLength, [int]$MaxLength) {
    
    if ($Elem -eq $null -or $Elem -eq "" -or $Elem -eq 0) { return $False }
    if ($Min -ne $null -and $Min -ne "" -and $Elem -lt $Min) { return $False }
    if ($Max -ne $null -and $Max -ne "" -and $Elem -gt $Max) { return $False }
    if ($MinLength -ne $null -and $MinLength -ne "" -and $Elem.Length -lt $MinLength) { return $False }
    if ($MaxLength -ne $null -and $MaxLength -ne "" -and $Elem.Length -gt $MaxLength) { return $False }

    return $True

}



#==============================================================================================================================================================================================
function CreateLanguagesDialog() {

    # Create Dialog
    $global:LanguagesDialog = CreateDialog -Width 300 -Height 300
    $CloseButton = CreateButton -X ($LanguagesDialog.Width / 2 - 40) -Y ($LanguagesDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $LanguagesDialog
    $CloseButton.Add_Click({$LanguagesDialog.Hide()})

    # Box
    $global:LanguagesBox = CreateGroupBox -X 10 -Y 10 -Width ($LanguagesDialog.Width - 40) -Text ($GameType.mode + " - Languages") -AddTo $LanguagesDialog

}



#==============================================================================================================================================================================================
function CreateLanguagesContent() {
    
    $PatchLanguagesButton.Visible = $GamePatch.languages -ne $null

    if (!(IsSet -Elem $GamePatch.languages -MinLength 0)) { return }

    $LanguagesBox.Controls.Clear()
    $LanguagesBox.Height = ([Math]::Ceiling($GamePatch.languages.Length/2 + 1)) * 30

    $Row = -1
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        if ($i % 2) { $X = 160 }
        else {
            $X = 20
            $Row += 1
        }

        $Button = CreateCheckbox -X $X -Y ($Row  * 30 + 30) -IsRadio $True -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -AddTo $LanguagesBox -IsGame $True -Name $GamePatch.languages[$i].title
        $Label = CreateLabel -X $Button.Right -Y ($Button.Top + 3) -Width 70 -Height 15 -Text $GamePatch.languages[$i].title -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -AddTo $LanguagesBox
    }
    
    $HasDefault = $False
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        if ($LanguagesBox.Controls[$i*2].Checked) {
            $HasDefault = $True
            break
        }
    }
    if (!$HasDefault) { $LanguagesBox.Controls[0].Checked = $True } 

}



#==============================================================================================================================================================================================
function CreateOptionsDialog([int]$Width, [int]$Height) {
    
    # Create Dialog
    if ( (IsSet -Elem $Width) -and (IsSet -Elem $Height) )   { $global:OptionsDialog = CreateDialog -Width $Width -Height $Height }
    else                                                     { $global:OptionsDialog = CreateDialog -Width 900 -Height 640 }

    # Close Button
    $CloseButton = CreateButton -X ($OptionsDialog.Width / 2 - 40) -Y ($OptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OptionsDialog
    $CloseButton.Add_Click( {$OptionsDialog.Hide()} )

    # Options Label
    $global:OptionsLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $OptionsDialog

    # Options
    $global:Options = @{}
    $global:OptionsToolTip = CreateToolTip
    $Options.Panel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog

}



#==============================================================================================================================================================================================
function EnableReduxOptions() {

    if ($GameType.mode -eq "Ocarina of Time") {
        $Options.HideDPad.Enabled = $this.Checked
        $Options.HideFileSelectIcons.Enabled = $this.Checked
    }
    elseif ($GameType.mode -eq "Majora's Mask") {
        $Options.LeftDPad.Enabled = $this.Checked
        $Options.RightDPad.Enabled = $this.Checked
        $Options.HideDPad.Enabled = $this.Checked
    }

}




#==============================================================================================================================================================================================
function CreateOoTOptionsContent() {
    
    CreateOptionsDialog -Width 900 -Height 600

    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"

    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OKHO Mode") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive`nOKHO Mode = You die in one hit" -Name "Damage"
    $Options.Recovery                  = CreateReduxComboBox -Column 2 -Row 1 -AddTo $HeroModeBox -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $OptionsToolTip -Info "Set the amount health you recovery from Recovery Hearts" -Name "Recovery"
    #$Options.BossHP                    = CreateReduxComboBox -Column 0 -Row 2 -AddTo $HeroModeBox -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP") -Text "Boss HP:" -ToolTip $OptionsToolTip -Info "Set the amount of health for bosses" -Name "BossHP"
    #$Options.MasterQuest               = CreateReduxCheckbox -Column 2 -Row 2 -AddTo $HeroModeBox -Text "Master Quest (WIP)" -ToolTip $OptionsToolTip -Info "Changes Ocarina of Time into Master Quest`nMaster Quest remixes the dungeons with harder challenges`nThe intro title is changed as well" -Name "MasterQuest"



    # TEXT SPEED #
    $TextBox                           = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Text Dialogue Speed"
    
    $TextPanel                         = CreateReduxPanel -Row 0 -AddTo $TextBox
    $Options.Text1x                    = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $TextPanel -Checked -Text "1x Speed" -ToolTip $OptionsToolTip -Info "Leave the dialogue text speed at normal" -Name "Text1x"
    $Options.Text2x                    = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $TextPanel          -Text "2x Speed" -ToolTip $OptionsToolTip -Info "Set the dialogue text speed to be twice as fast" -Name "Text2x"
    $Options.Text3x                    = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $TextPanel          -Text "3x Speed" -ToolTip $OptionsToolTip -Info "Set the dialogue text speed to be three times as fast" -Name "Text3x"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($TextBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"        -ToolTip $OptionsToolTip -Info "Native 16:9 widescreen display support" -Name "Widescreen"
    $Options.WidescreenTextures        = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "16:9 Textures"          -ToolTip $OptionsToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support" -Name "WideScreenTextures"
    $Options.BlackBars                 = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"          -ToolTip $OptionsToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckbox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance" -ToolTip $OptionsToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Name "ExtendedDraw"
    $Options.ForceHiresModel           = CreateReduxCheckbox -Column 4 -Row 1 -AddTo $GraphicsBox -Text "Force Hires Link Model" -ToolTip $OptionsToolTip -Info "Always use Link's High Resolution Model when Link is too far away" -Name "ForceHiresModel"
    $Options.MMModels                  = CreateReduxCheckbox -Column 0 -Row 2 -AddTo $GraphicsBox -Text "Replace Link's Models"  -ToolTip $OptionsToolTip -Info "Replaces Link's models to be styled towards Majora's Mask" -Name "MMModels"



    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.ReturnChild               = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Can Always Return"      -ToolTip $OptionsToolTip -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!" -Name "ReturnChild"
    $Options.Medallions                = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Require All Medallions" -ToolTip $OptionsToolTip -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Name "Medallions"
    $Options.EasierMinigames           = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Easier Minigames"       -ToolTip $OptionsToolTip -Info "Certain minigames are made easier`nDampe's Digging Game (first try) & Fishing (less random and requirements)" -Name "EasierMinigames"



    # RESTORE #
    $RestoreBox                        = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Restore / Correct"

    $Options.CorrectRupeeColors        = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $RestoreBox -Text "Correct Rupee Colors"    -ToolTip $OptionsToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees" -Name "CorrectRupeeColors"
    $Options.RestoreFireTemple         = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $RestoreBox -Text "Restore Fire Temple"     -ToolTip $OptionsToolTip -Info "Restore the censored Fire Temple theme used in the Rev 2 ROM" -Name "RestoreFireTemple"
    $Options.RestoreGerudoTextures     = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $RestoreBox -Text "Restore Gerudo Textures" -ToolTip $OptionsToolTip -Info "Restore the censored Gerudo symbol textures used in the Rev 2 ROM" -Name "RestoreGerudoTextures"



    # EQUIPMENT #
    $EquipmentBox                      = CreateReduxGroup -Y ($RestoreBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Equipment"
    
    $ItemCapacityPanel                 = CreateReduxPanel -Row 0 -AddTo $EquipmentBox
    $Options.ReducedItemCapacity       = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $ItemCapacityPanel          -Text "Reduced Item Capacity"   -ToolTip $OptionsToolTip -Info "Decrease the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry" -Name "ReducedItemCapacity"
    $Options.NormalItemCapacity        = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $ItemCapacityPanel -Checked -Text "Normal Item Capacity"    -ToolTip $OptionsToolTip -Info "Keep the normal amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry" -Name "NormalItemCapacity"
    $Options.IncreasedItemCapacity     = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $ItemCapacityPanel          -Text "Increased Item Capacity" -ToolTip $OptionsToolTip -Info "Increase the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry" -Name "IncreasedItemCapacity"

    $Options.UnlockSword               = CreateReduxCheckbox -Column 0 -Row 2 -AddTo $EquipmentBox -Text "Unlock Kokiri Sword" -ToolTip $OptionsToolTip -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Name "UnlockSword"
    $Options.UnlockTunics              = CreateReduxCheckbox -Column 1 -Row 2 -AddTo $EquipmentBox -Text "Unlock Tunics"       -ToolTip $OptionsToolTip -Info "Child Link is able to use the Goron TUnic and Zora Tunic`nSince you might want to walk around in style as well when you are young" -Name "UnlockTunics"
    $Options.UnlockBoots               = CreateReduxCheckbox -Column 2 -Row 2 -AddTo $EquipmentBox -Text "Unlock Boots"        -ToolTip $OptionsToolTip -Info "Child Link is able to use the Iron Boots and Hover Boots" -Name "UnlockBoots"



    # EVERYTHING ELSE #
    $OtherBox                          = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Other"

    $Options.DisableLowHPSound         = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $OtherBox -Text "Disable Low HP Beep"             -ToolTip $OptionsToolTip -Info "There will be absolute silence when Link's HP is getting low" -Name "DisableLowHPSound"
    $Options.DisableNavi               = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $OtherBox -Text "Remove Navi Prompts"             -ToolTip $OptionsToolTip -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes" -Name "DisableNavi"
    $Options.HideDPad                  = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $OtherBox -Text "Hide D-Pad Icon" -Disable        -ToolTip $OptionsToolTip -Info "Hide the D-Pad icon, while it is still active" -Name "HideDPad"
    $Options.HideFileSelectIcons       = CreateReduxCheckbox -Column 3 -Row 1 -AddTo $OtherBox -Text "Hide File Select Icons" -Disable -ToolTip $OptionsToolTip -Info "Hide the icons shown on the File Select screen" -Name "HideFileSelectIcons"



    $Options.Damage.Add_SelectedIndexChanged({ $Options.Recovery.Enabled = $this.Text -ne "OKHO Mode" })

}



#==============================================================================================================================================================================================
function CreateMMOptionsContent() {
    
    CreateOptionsDialog -Width 900 -Height 600

    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"

    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OKHO Mode") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive`nOKHO Mode = You die in one hit" -Name "Damage"
    $Options.Recovery                  = CreateReduxComboBox -Column 2 -Row 1 -AddTo $HeroModeBox -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $OptionsToolTip -Info "Set the amount health you recovery from Recovery Hearts" -Name "Recovery"
    #$Options.BossHP                    = CreateReduxComboBox -Column 0 -Row 2 -AddTo $HeroModeBox -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP") -Text "Boss HP:" -ToolTip $OptionsToolTip -Info "Set the amount of health for bosses" -Name "BossHP"



    # D-PAD #
    $DPadBox                           = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "D-Pad Icons Layout"
    
    $DPadPanel                         = CreateReduxPanel -Row 0 -AddTo $DPadBox
    $Options.LeftDPad                  = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $DPadPanel          -Disable -Text "Left Side"  -ToolTip $OptionsToolTip -Info "Show the D-Pad icons on the left side of the HUD" -Name "LeftDPad"
    $Options.RightDPad                 = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $DPadPanel -Checked -Disable -Text "Right Side" -ToolTip $OptionsToolTip -Info "Show the D-Pad icons on the right side of the HUD" -Name "RightDPad"
    $Options.HideDPad                  = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $DPadPanel          -Disable -Text "Hidden"     -ToolTip $OptionsToolTip -Info "Hide the D-Pad icons, while they are still active" -Name "HideDPad"
    

   
    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($DPadBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"         -ToolTip $OptionsToolTip -Info "Native 16:9 Widescreen Display support" -Name "Widescreen"
    $Options.WidescreenTextures        = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "16:9 Textures"           -ToolTip $OptionsToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support" -Name "WidescreenTextures"
    $Options.BlackBars                 = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"           -ToolTip $OptionsToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckbox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance"  -ToolTip $OptionsToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Name "ExtendedDraw"
    $Options.PixelatedStars            = CreateReduxCheckbox -Column 4 -Row 1 -AddTo $GraphicsBox -Text "Disable Pixelated Stars" -ToolTip $OptionsToolTip -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement" -Name "PixelatedStars"
    
    
    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.ZoraPhysics               = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Zora Physics" -ToolTip $OptionsToolTip -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot" -Name "ZoraPhysics"



    # RESTORE #
    $RestoreBox                        = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Restore / Correct"

    $Options.CorrectRupeeColors        = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $RestoreBox -Text "Correct Rupee Colors"  -ToolTip $OptionsToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees" -Name "CorrectRupeeColors"
    $Options.CorrectRomaniSign         = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $RestoreBox -Text "Correct Romani Sign"   -ToolTip $OptionsToolTip -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village" -Name "CorrectRomaniSign"
    $Options.CorrectComma              = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $RestoreBox -Text "Correct Comma"         -ToolTip $OptionsToolTip -Info "Make the comma not look as awful" -Name "CorrectComma"
    $Options.CorrectCircusMask         = CreateReduxCheckbox -Column 3 -Row 1 -AddTo $RestoreBox -Text "Correct Circus Mask"   -ToolTip $OptionsToolTip -Info "Change the Circus Leader's Mask to Troupe Leader's Mask and all references to it." -Name "CorrectCircusMask"
    $Options.RestoreTitle              = CreateReduxCheckbox -Column 4 -Row 1 -AddTo $RestoreBox -Text "Restore Title"         -ToolTip $OptionsToolTip -Info "Restore the title logo colors as seen in the Japanese release" -Name "RestoreTitle"
    $Options.RestoreSkullKid           = CreateReduxCheckbox -Column 0 -Row 2 -AddTo $RestoreBox -Text "Restore Skull Kid"     -ToolTip $OptionsToolTip -Info "Restore Skull Kid's face as seen in the Japanese release" -Name "RestoreSkullKid"
    $Options.RestorePalaceRoute        = CreateReduxCheckbox -Column 1 -Row 2 -AddTo $RestoreBox -Text "Restore Palace Route"  -ToolTip $OptionsToolTip -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release" -Name "RestorePalaceRoute"
    $Options.RestoreCowNoseRing        = CreateReduxCheckbox -Column 2 -Row 2 -AddTo $RestoreBox -Text "Restore Cow Nose Ring" -ToolTip $OptionsToolTip -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Name "RestoreCowNoseRing"


    # EQUIPMENT #
    $EquipmentBox                     = CreateReduxGroup -Y ($RestoreBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Equipment"
    
    $ItemCapacityPanel                = CreateReduxPanel -Row 0 -AddTo $EquipmentBox
    $Options.ReducedItemCapacity      = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $ItemCapacityPanel          -Text "Reduced Item Capacity"   -ToolTip $OptionsToolTip -Info "Decrease the amount of deku sticks, deku nuts, bombs and arrows you can carry" -Name "ReducedItemCapacity"
    $Options.NormalItemCapacity       = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $ItemCapacityPanel -Checked -Text "Normal Item Capacity"    -ToolTip $OptionsToolTip -Info "Keep the normal amount of deku sticks, deku nuts, bombs and arrows you can carry" -Name "NormalItemCapacity"
    $Options.IncreasedItemCapacity    = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $ItemCapacityPanel          -Text "Increased Item Capacity" -ToolTip $OptionsToolTip -Info "Increase the amount of deku sticks, deku nuts, bombs and arrows you can carry" -Name "IncreasedItemCapacity"

    $Options.RazorSword               = CreateReduxCheckbox -Column 0 -Row 2 -AddTo $EquipmentBox -Text "Permanent Razor Sword" -ToolTip $ToolTip -Info "The Razor Sword won't get destroyed after 100 it`nYou can also keep the Razor Sword when traveling back in time" -Name "RazorSword"



    # EVERYTHING ELSE #
    $OtherBox                         = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Other"

    $Options.DisableLowHPSound        = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $OtherBox -Text "Disable Low HP Beep"      -ToolTip $OptionsToolTip -Info "There will be absolute silence when Link's HP is getting low" -Name "DisableLowHPSound"
    $Options.PieceOfHeartSound        = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $OtherBox -Text "4th Piece of Heart Sound" -ToolTip $OptionsToolTip -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container" -Name "PieceOfHeartSound"
    $Options.FixGohtCutscene          = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $OtherBox -Text "Fix Goht Cutscene"        -ToolTip $OptionsToolTip -Info "Fix Goht's awakening cutscene so that Link no longer gets run over" -Name "FixGohtCutscene"
    $Options.MoveBomberKid            = CreateReduxCheckbox -Column 3 -Row 1 -AddTo $OtherBox -Text "Move Bomber Kid"          -ToolTip $OptionsToolTip -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM" -Name "MoveBomberKid"
    $Options.FixMushroomBottle        = CreateReduxCheckbox -Column 4 -Row 1 -AddTo $OtherBox -Text "Fix Mushroom Bottle"      -ToolTip $OptionsToolTip -Info "Correct the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error" -Name "FixMushroomBottle"



    $Options.Damage.Add_SelectedIndexChanged({ $Options.Recovery.Enabled = $this.Text -ne "OKHO Mode" })

}



#==============================================================================================================================================================================================
function CreateSM64OptionsContent() {
    
    CreateOptionsDialog -Width 550 -Height 320

     # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"
    
    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "3x Damage") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive" -Name "Damage"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"         -ToolTip $OptionsToolTip -Info "Native 16:9 Widescreen Display support" -Name "Widescreen"
    $Options.ForceHiresModel           = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "Force Hires Mario Model" -ToolTip $OptionsToolTip -Info "Always use Mario's High Resolution Model when Mario is too far away" -Name "ForceHiresModel"
    $Options.BlackBars                 = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"           -ToolTip $OptionsToolTip -Info "Removes the black bars shown on the top and bottom of the screen" -Name "BlackBars"
    


    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.FPS                       = CreateReduxCheckbox -Column 0 -Row 1 -AddTo $GameplayBox -Text "60 FPS"        -ToolTip $OptionsToolTip -Info "Increases the FPS from 30 to 60`nWitness Super Mario 64 in glorious 60 FPS" -Name "FPS"
    $Options.FreeCam                   = CreateReduxCheckbox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Analog Camera" -ToolTip $OptionsToolTip -Info "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Left / Right for the Analog stick" -Name "FreeCam"
    $Options.LagFix                    = CreateReduxCheckbox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Lag Fix"       -ToolTip $OptionsToolTip -Info "Smoothens gameplay by reducing lag" -Name "LagFix"



    $Options.FPS.Add_CheckStateChanged({ $Options.FreeCam.Enabled = !$this.Checked })
    $Options.FreeCam.Add_CheckStateChanged({ $Options.FPS.Enabled = !$this.Checked })

}



#==============================================================================================================================================================================================
function DisablePatches() {
    
    $PatchReduxCheckbox.Visible = $PatchReduxLabel.Visible = (IsSet -Elem $GamePatch.redux.file)
    $PatchOptionsCheckbox.Visible = $PatchOptionsLabel.Visible = $PatchOptionsButton.Visible = $GamePatch.options
    $PatchOptionsButton.Enabled = $GamePatch.options -and $PatchOptionsCheckbox.Checked

    $PatchVCRemoveFilterLabel.Enabled = $PatchVCRemoveFilter.Enabled = !(StrLike -str $GamePatch.command -val "Patch Boot DOL")
    $global:ToolTip.SetToolTip($PatchButton, ([String]::Format($Item.tooltip, [Environment]::NewLine)))

}



#==============================================================================================================================================================================================
function CreateInfoGameIDDialog() {
    
    # Create Dialog
    $global:InfoGameIDDialog = CreateDialog -Width 500 -Height 500 -Icon $Files.icon.gameID
    $CloseButton = CreateButton -X ($InfoGameIDDialog.Width / 2 - 40) -Y ($InfoGameIDDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoGameIDDialog
    $CloseButton.Add_Click({$InfoGameIDDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoGameIDDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoGameIDDialog

    $HashSumROMLabel = CreateLabel -X 40 -Y 55 -Width 120 -Height 15 -Font $VCPatchFont -Text "N64 ROM Hashsum:" -AddTo $InfoGameIDDialog
    $global:HashSumROMTextBox = CreateTextBox -X $HashSumROMLabel.Right -Y ($HashSumROMLabel.Top - 3) -Width ($InfoGameIDDialog.Width -$HashSumROMLabel.Width - 100) -Height 50 -AddTo $InfoGameIDDialog
    $HashSumROMTextBox.ReadOnly = $True

    # Create textbox
    $TextBox = CreateTextBox -X 40 -Y ($HashSumROMTextBox.Bottom + 10) -Width ($InfoGameIDDialog.Width - 100) -Height ($CloseButton.Top - 100) -ReadOnly $True -Multiline $True -AddTo $InfoGameIDDialog
    AddTextFileToTextbox -TextBox $Textbox -File $Files.text.gameID

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 500 -Height 500 -Icon $Files.icon.credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({$CreditsDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create textbox
    $global:CreditsTextBox = CreateTextBox -X 40 -Y 50 -Width ($CreditsDialog.Width - 100) -Height ($CloseButton.Top - 60) -ReadOnly $True -Multiline $True -AddTo $CreditsDialog

}



#==============================================================================================================================================================================================
function CreateInfoDialog() {
    
    # Create Dialog
    $global:InfoDialog = CreateDialog -Width 500 -Height 500 -Icon $Icon
    $CloseButton = CreateButton -X ($InfoDialog.Width / 2 - 40) -Y ($InfoDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoDialog
    $CloseButton.Add_Click({$InfoDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoDialog

    # Create Text Box
    $global:InfoTextBox = CreateTextBox -X 40 -Y 50 -Width ($InfoDialog.Width - 100) -Height ($CloseButton.Top - 60) -ReadOnly $True -Multiline $True -AddTo $InfoDialog
    
}



#==============================================================================================================================================================================================
function AddTextFileToTextbox([Object]$TextBox, [String]$File, [Switch]$Add, [int]$PreSpace, [int]$PostSpace) {
    
    if (!(IsSet -Elem $File)) {
        $TextBox.Text = ""
        return
    }

    if (Test-Path -LiteralPath $File -PathType Leaf) {
        $str = ""
        for ($i=0; $i -lt (Get-Content -Path $File).Count; $i++) {
            if ((Get-Content -Path $File)[$i] -ne "") {
                $str += (Get-Content -Path $File)[$i]
                if ($i -lt  (Get-Content -Path $File).Count-1) { $str += "{0}" }
            }
            else { $str += "{0}" }
        }

        if ($PreSpace -gt 0) {
            for ($i=0; $i -lt $PreSpace; $i++) { $str = "{0}" + $str }
        }
        if ($PostSpace -gt 0) {
            for ($i=0; $i -lt $PostSpace; $i++) { $str = $str + "{0}" }
        }

        $str = [String]::Format($str, [Environment]::NewLine)

        if ($Add) { $TextBox.Text += $str }
        else      { $TextBox.Text = $str }
    }

}



#==============================================================================================================================================================================================
function CreateErrorDialog([String]$Error, [Switch]$Exit) {
    
    # Create Dialog
    $ErrorDialog = CreateDialog -Width 300 -Height 200 -Icon $null

    $CloseButton = CreateButton -X ($ErrorDialog.Width / 2 - 40) -Y ($ErrorDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $ErrorDialog
    $CloseButton.Add_Click({$ErrorDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " " + $Version + " (" + $VersionDate + ")" + "{0}{0}"

    if ($Error -eq "Missing Files")        { $String += "Neccessary files are missing.{0}" }
    elseif ($Error -eq "Missing JSON")     { $String += "Games.json or Patches.json files are missing.{0}" }
    elseif ($Error -eq "Corrupted JSON")   { $String += "Games.json or Patches.json files are corrupted.{0}" }

    $String += "{0}"
    $String += "Please download the Patcher64+ Tool again."

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width ($ErrorDialog.Width-10) -Height ($ErrorDialog.Height - 110) -Text $String -AddTo $ErrorDialog

    if (IsSet -Elem $MainDialog) { $MainDialog.Hide() }
    $ErrorDialog.ShowDialog() | Out-Null
    if ($Exit -eq $True) { Exit }

}



#==============================================================================================================================================================================================
function CreateForm([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Object]$Object, [Object]$AddTo) {
    
    $Form = $Object
    if ($Width -ne $null -and $Height -ne $null)   { $Form.Size = New-Object System.Drawing.Size($Width, $Height) }
    else                                           { $Form.Size = New-Object System.Drawing.Size(0, 0) }
    if ($X -ne $null -and $Y -ne $null)            { $Form.Location = New-Object System.Drawing.Size($X, $Y) }
    else                                           { $Form.Location = New-Object System.Drawing.Size(0, 0) }
    if ($Name -ne $null)                           { $Form.Name = $Name }
    $AddTo.Controls.Add($Form)
    return $Form

}



#==============================================================================================================================================================================================
function CreateDialog([int]$Width, [int]$Height, [Object]$Icon) {
    
    # Create the dialog that displays more info.
    $Dialog = New-Object System.Windows.Forms.Form
    $Dialog.Text = $ScriptName
    $Dialog.Size = New-Object System.Drawing.Size($Width, $Height)
    $Dialog.MaximumSize = $Dialog.Size
    $Dialog.MinimumSize = $Dialog.Size
    $Dialog.MaximizeBox = $True
    $Dialog.MinimizeBox = $True
    $Dialog.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Inherit
    $Dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $Dialog.StartPosition = "CenterScreen"
    $Dialog.Icon = $Icon
    return $Dialog

}


#==============================================================================================================================================================================================
function CreateGroupBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [String]$Text, [Object]$AddTo) {
    
    $GroupBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
    if ($Text -ne $null -and $Text -ne "") { $GroupBox.Text = (" " + $Text + " ") }
    return $GroupBox

}



#==============================================================================================================================================================================================
function CreatePanel([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Boolean]$Hide, [Object]$AddTo) {
    
    $Panel = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Panel) -AddTo $AddTo
    if ($Hide) { $Panel.Hide() }
    return $Panel

}



#==============================================================================================================================================================================================
function CreateTextBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Boolean]$ReadOnly, [Boolean]$Multiline, [String]$Text, [Object]$AddTo) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    if ($Text -ne $null) { $TextBox.Text = $Text }

    if ($ReadOnly) {
        $TextBox.ReadOnly = $True
        $TextBox.Cursor = 'Default'
        $TextBox.ShortcutsEnabled = $False
        $TextBox.BackColor = "White"
    }

    if ($Multiline) {
        $TextBox.Multiline = $True
        $TextBox.Scrollbars = 'Vertical'
        $TextBox.WordWrap = $False
        $TextBox.TabStop = $False
    }
    
    $TextBox.Add_Click({ $this.SelectionLength = 0 })

    return $TextBox

}



#==============================================================================================================================================================================================
function CreateComboBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Object]$Items, [Object]$ToolTip, [String]$Info, [Switch]$Game, [Object]$AddTo) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo

    if ($Items -ne $null) {
        $ComboBox.Items.AddRange($Items)

        if (IsSet -Elem $ComboBox.Name) {
            if ($Game) {
                if (IsSet $Settings[$GameType.mode][$ComboBox.Name])   { $ComboBox.SelectedIndex = $Settings[$GameType.mode][$ComboBox.Name] }
                else                                                    { $Settings[$GameType.mode][$ComboBox.Name] = 0 }
                $ComboBox.Add_SelectedIndexChanged({ $Settings[$GameType.mode][$this.Name] = $this.SelectedIndex })
            }
            else {
                if (IsSet $Settings["Core"][$ComboBox.Name])            { $ComboBox.SelectedIndex = $Settings["Core"][$ComboBox.Name] }
                else                                                    { $Settings["Core"][$ComboBox.Name] = "False" }
                $ComboBox.Add_SelectedIndexChanged({ $Settings["Core"][$this.Name] = $this.SelectedIndex })
            }

        }
        if ($ComboBox.SelectedIndex -eq -1) { $ComboBox.SelectedIndex = 0 }
    }

    $ComboBox.DropDownStyle = "DropDownList"
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($ComboBox, $Info) }

    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateCheckbox([int]$X, [int]$Y, [String]$Name, [Boolean]$Checked, [Boolean]$Disable, [Boolean]$IsRadio, [Object]$ToolTip, [String]$Info, [Boolean]$IsGame, [Object]$AddTo) {
    
    if ($IsRadio)             { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else                      { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Checkbox, $Info) }
    $Checkbox.Enabled = !$Disable

    if (IsSet -Elem $Checkbox.Name) {
        if ($IsGame) {
            if (IsSet $Settings[$GameType.mode][$Checkbox.Name])   { $Checkbox.Checked = $Settings[$GameType.mode][$Checkbox.Name] -eq "True" }
            else                                                   { $Checkbox.Checked = $Settings[$GameType.mode][$Checkbox.Name] = $Checked }
            if ($IsRadio)                                          { $Checkbox.Add_CheckedChanged({ $Settings[$GameType.mode][$this.Name] = $this.Checked }) }
            else                                                   { $Checkbox.Add_CheckStateChanged({ $Settings[$GameType.mode][$this.Name] = $this.Checked }) }
        }
        else {
            if (IsSet $Settings["Core"][$Checkbox.Name])           { $Checkbox.Checked = $Settings["Core"][$Checkbox.Name] -eq "True" }
            else                                                   { $Checkbox.Checked = $Settings["Core"][$Checkbox.Name] = $Checked }
            if ($IsRadio)                                          { $Checkbox.Add_CheckedChanged({ $Settings["Core"][$this.Name] = $this.Checked }) }
            else                                                   { $Checkbox.Add_CheckStateChanged({ $Settings["Core"][$this.Name] = $this.Checked }) }
        }
    }
    else { $Checkbox.Checked = $Checked }

    return $Checkbox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X, [int]$Y, [String]$Name, [int]$Width, [int]$Height, [String]$Text, [Object]$Font, [Object]$ToolTip, [String]$Info, [Object]$AddTo) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if ($Text -ne $null)      { $Label.Text = $Text }
    if ($Font -ne $null)      { $Label.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Label, $Info) }
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X, [int]$Y, [String]$Name, [int]$Width, [int]$Height, [String]$Text, [Object]$ToolTip, [String]$Info, [Object]$AddTo) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if ($Text -ne $null)      { $Button.Text = $Text }
    if ($Font -ne $null)      { $Button.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Button, $Info) }
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxGroup([int]$Y, [int]$Height, [Object]$AddTo, [String]$Text)   { return CreateGroupBox -X 15 -Y $Y -Width ($AddTo.Width - 50) -Height ($Height * 30 + 20) -Text $Text -AddTo $AddTo }
function CreateReduxPanel([int]$Row, [Object]$AddTo)                              { return CreatePanel -X $AddTo.Left -Y ($Row * 30 + 20) -Width ($AddTo.Width - 20) -Height 20 -AddTo $AddTo }



#==============================================================================================================================================================================================
function CreateReduxRadioButton([int]$Column, [int]$Row, [Object]$AddTo, [Switch]$Checked, [Switch]$Disable, [String]$Text, [Object]$ToolTip, [String]$Info, [String]$Name) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckbox.Checked }
    $Radio = CreateCheckbox -X ($Column * 165) -Y ($Row * 30) -Checked $Checked -Disable $Disable  -IsRadio $True -ToolTip $ToolTip -Info $Info -IsGame $True -Name $Name -AddTo $AddTo
    $Label = CreateLabel -X $Radio.Right -Y ($Radio.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    return $Radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckbox([int]$Column, [int]$Row, [Object]$AddTo, [Switch]$Checked, [Switch]$Disable, [String]$Text, [Object]$ToolTip, [String]$Info, [String]$Name) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckbox.Checked }
    $Checkbox = CreateCheckbox -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Checked $Checked -Disable $Disable -IsRadio $False -ToolTip $ToolTip -Info $Info -IsGame $True -Name $Name -AddTo $AddTo
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([int]$Column, [int]$Row, [Object]$AddTo, [Object]$Items, [String]$Text, [Object]$ToolTip, [String]$Info, [String]$Name) {
    
    $Label = CreateLabel -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Width 80 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    $ComboBox = CreateComboBox -X $Label.Right -Y ($Label.Top - 3) -Width 150 -Height 40 -Items $Items -ToolTip $ToolTip -Info $Info -IsGame $True -Name $Name -AddTo $AddTo
    return $ComboBox

}



#==============================================================================================================================================================================================
function StrLike([String]$str, [String]$val) {
    
    if ($str.ToLower() -like "*" + $val + "*") { return $True }
    return $False

}



#==============================================================================================================================================================================================
function Get-IniContent ([String]$FilePath) {

    $ini = @{}
    switch -regex -file $FilePath {
        "^\[(.+)\]" # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        "^(;.*)$"
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value
        }
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini

}



#==============================================================================================================================================================================================
function Out-IniFile([hashtable]$InputObject, [String]$FilePath) {
    
    RemoveFile $FilePath
    $OutFile = New-Item -ItemType file -Path $Filepath
    foreach ($i in $InputObject.keys) {
        if (!($($InputObject[$i].GetType().Name) -eq "Hashtable")) { Add-Content -Path $outFile -Value "$i=$($InputObject[$i])" } # No Sections
        else {
            #Sections
            Add-Content -Path $outFile -Value "[$i]"
            foreach ($j in ($InputObject[$i].keys | Sort-Object)) {
                if ($j -match "^Comment[\d]+")   { Add-Content -Path $OutFile -Value "$($InputObject[$i][$j])" }
                else                             { Add-Content -Path $OutFile -Value "$j=$($InputObject[$i][$j])" }
            }
            Add-Content -Path $outFile -Value ""
        }
    }

}



#==============================================================================================================================================================================================
function SetSettings() {
    
    if (!(Test-Path -LiteralPath $Files.settings -PathType Leaf)) { New-Item -Path $Files.settings | Out-Null }
    $Lines = Get-Content -Path $Files.settings
    if ($Lines -notcontains "[Core]") { Add-Content -Path $Files.settings -Value "[Core]" | Out-Null }
    $global:Settings = Get-IniContent $Files.settings

}



#==============================================================================================================================================================================================
function GetFilePaths() {
    
    if (IsSet $Settings["Core"][$InputWADTextBox.Name]) {	
        if (Test-Path -LiteralPath $Settings["Core"][$InputWADTextBox.Name] -PathType Leaf) {
            WADPath_Finish $InputWADTextBox -VarName $InputWADTextBox.Name -WADPath $Settings["Core"][$InputWADTextBox.Name]
        }
    }

    if (IsSet $Settings["Core"][$InputROMTextBox.Name]) {
        if (Test-Path -LiteralPath $Settings["Core"][$InputROMTextBox.Name] -PathType Leaf) {
            Z64Path_Finish $InputROMTextBox -VarName $InputROMTextBox.Name -Z64Path $Settings["Core"][$InputROMTextBox.Name]
        }
    }

    if (IsSet $Settings["Core"][$InputBPSTextBox.Name]) {	
        if (Test-Path -LiteralPath $Settings["Core"][$InputBPSTextBox.Name] -PathType Leaf) {	
            BPSPath_Finish $InputBPSTextBox -VarName $InputBPSTextBox.Name -BPSPath $Settings["Core"][$InputBPSTextBox.Name]
        }	
    }

}



#==============================================================================================================================================================================================

# Hide the PowerShell console from the user.
ShowPowerShellConsole -ShowConsole $False

# Set paths to all the files stored in the script.
SetFileParameters
SetSettings

# Create the dialogs to show to the user.
CreateMainDialog
CreateOptionsDialog
CreateLanguagesDialog
CreateInfoGameIDDialog
CreateInfoDialog
CreateCreditsDialog

# Set default game mode.
ChangeGamesList
GetFilePaths

# Show the dialog to the user.
$MainDialog.ShowDialog() | Out-Null

# Exit
Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
Exit