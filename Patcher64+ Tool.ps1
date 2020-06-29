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

$global:VersionDate = "29-06-2020"
$global:Version     = "v5.3.1"

$global:GameType = $global:GamePatch = $global:CheckHashSum = ""
$global:IsWiiVC = $global:IsDowngrade = $global:MissingFiles = $False
$global:GameTitleLength = @(20, 40)

$global:CurrentModeFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 12, [System.Drawing.FontStyle]::Bold)
$global:VCPatchFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 8, [System.Drawing.FontStyle]::Bold)



#==============================================================================================================================================================================================
# Hashes

$global:HashSum_oot_rev0 = "5BD1FE107BF8106B2AB6650ABECD54D6"
$global:HashSum_oot_rev1 = "721FDCC6F5F34BE55C43A807F2A16AF4"
$global:HashSum_oot_rev2 = "57A9719AD547C516342E1A15D5C28C3D"



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
$Paths.Master  = $Paths.Base + "\Files"
$Paths.Icons   = $Paths.Master + "\Icons"
$Paths.Text    = $Paths.Master + "\Text"
$Paths.Credits = $Paths.Text + "\Credits"
$Paths.Info    = $Paths.Text + "\Info"
$Paths.WiiVC   = $Paths.Master + "\Wii VC"



#==============================================================================================================================================================================================
# Files to patch and use

$global:WADFilePath = $global:Z64FilePath = $global:BPSFilePath = $null

$global:ROMFile = $global:ROMCFil = $null
$global:PatchedROMFile = $global:DecompressedROMFile = $null
$global:DecompressedROMFile = $null
$global:GamesJSONFile = $global:PatchesJSONFile = $null



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
    
    # Init
    $Header = @($GameType.n64_title, $GameType.n64_gameID, $GameType.wii_title, $GameType.wii_gameID)
    $global:Patches = @{}
    $Patches.Base = $Patches.Redux = $Patches.Languages = $null
    
    # Hash
    if (IsSet -Elem $GamePatch.Hash)   { $global:CheckHashSum = $GamePatch.Hash }
    else                               { $global:CheckHashSum = $GameType.Hash }

    # Base Patch File
    $Patches.Base = SetPatch -Attribute $GamePatch.file -File ($Paths.Master + "\" + $GameType.mode + $GamePatch.file) -Error ("Failed! The provided patch in Patches.json does not exist.") { return }
    if ($Patches.Base -eq 0) { return }

    # Output
    if (!(IsSet -Elem $PatchedFileName)) { $PatchedFileName = "_patched" }

    # Downgrade
    $Downgrade = $False
    if ($IsWiiVC) {
        if ($PatchVCDowngrade.Visible -and (StrLike -str $Command -val "Force Downgrade") )    { $PatchVCDowngrade.Checked = $True }
        elseif ($PatchVCDowngrade.Visible -and (StrLike -str $Command -val "No Downgrade") )   { $PatchVCDowngrade.Checked = $False }
    }
    
    # Remap D-Pad
    if ($GameType.patch_vc -ge 3 -and $PatchVCRemapDPad.Visible -and (StrLike -str $Command -val "Force Remap D-Pad") ) { $PatchVCRemapDPad.Checked = $True }

    # Header
    $Header = SetHeader -Header $Header -N64Title $GamePatch.n64_title -N64GameID $GamePatch.n64_gameID -WiiTitle $GamePatch.wii_title -WiiGameID $GamePatch.wii_gameID

    # Redux
    if ( (IsChecked -Elem $PatchReduxCheckbox) -and (IsSet -Elem $GamePatch.redux.file) ) {
        $PatchVCRemapDPad.Checked = $True
        if ($GameType.patch_vc -eq 4) {
            $PatchVCExpandMemory.Checked = $True
            if ($IsWiiVC -and !(IsChecked -Elem $PatchVCRemapCDown -Visible $True) -and !(IsChecked -Elem $PatchVCRemapZ -Visible $True)) { $PatchVCLeaveDPadUp.Checked = $True }
            if ($IsWiiVC) { $Downgrade = $PatchVCDowngrade.Checked = $True }
        }
        $Header = SetHeader -Header $Header -N64Title $GamePatch.redux.n64_title -N64GameID $GamePatch.redux.n64_gameID -WiiTitle $GamePatch.redux.wii_title -WiiGameID $GamePatch.redux.wii_gameID
        if (IsSet -Elem $GamePatch.redux.output)       { $PatchedFileName = $GamePatch.redux.output }
        $Patches.Redux = SetPatch -Attribute $GamePatch.redux.file -File ($Paths.Master + "\" + $GameType.mode + $GamePatch.redux.file) -Error ("Failed! The provided Redux patch in Patches.json does not exist.")
        if ($Patches.Redux -eq 0) { return }
    }

    # Language Patch
    if (IsSet -Elem $GamePatch.languages -MinLength 1) {
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($LanguagesBox.Controls[$i*2].checked) { $Item = $i }
        }
        $Header = SetHeader -Header $Header -N64Title $GamePatch.languages[$Item].n64_title -N64GameID $GamePatch.languages[$Item].n64_gameID -WiiTitle $GamePatch.languages[$Item].wii_title -WiiGameID $GamePatch.languages[$Item].wii_gameID
        if (IsSet -Elem $GamePatch.languages[$Item].output)       { $PatchedFileName = $GamePatch.languages[$Item].output }
        $Patches.Language = SetPatch -Attribute $GamePatch.languages[$Item].file -File ($Paths.Master + "\" + $GameType.mode + $GamePatch.languages[$Item].file) -Error ("Failed! The provided language patch in Patches.json does not exist.") { return }
        if ($Patches.Language -eq 0) { return }
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
    if ($GameType.decompress -eq 1) {
        if ( (IsChecked -Elem $PatchReduxCheckbox -Visible $True) -or (IsChecked -Elem $PatchOptionsCheckbox -Visible $True) ) { $Decompress = $True }
    }
    $Patches.GetEnumerator() | ForEach-Object {
        if ($_.value -like "*\Decompressed\*") { $Decompress = $True }
    }

    # Patch File Name
    if (IsSet -Elem $Z64FilePath -MinLength 4) { $global:Z64File = SetZ64Parameters -Z64Path $global:GameZ64 -PatchedFileName $PatchedFileName }

    # GO!

    MainFunctionPatch -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress -Downgrade $Downgrade
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
function SetPatch([String]$Attribute, [String]$Patch, [String]$File, [String]$Error) {
    
    if (IsSet -Elem $Attribute) {
        if (Test-Path -LiteralPath $File -PathType Leaf) { return Get-Item -LiteralPath $File }
        else {
            UpdateStatusLabel -Text $Error
            return 0
        }
    }
    return $null

}



#==============================================================================================================================================================================================
function MainFunctionPatch([String]$Command, [String[]]$Header, [String]$PatchedFileName, [Boolean]$Decompress, [Boolean]$Downgrade) {
    
    #if (!(WriteDebug -Command $Command -Header $Header -PatchedFileName $PatchedFileName -Decompress $Decompress -Downgrade $Downgrade)) { return }

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
        if (!(DowngradeROM -Command $Command, -Downgrade $Downgrade)) { return }
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
    if (!(PatchROM -Command $Command -Decompress $Decompress -Downgrade $Downgrade)) { return }

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
function WriteDebug([String]$Command, [String[]]$Header, [String]$PatchedFileName, [Boolean]$Decompress, [Boolean]$Downgrader) {

    Write-Host ""
    Write-Host "--- Patch Info ---"
    Write-Host "Header:" $Header
    Write-Host "Patches:" $Patches.Base   $Patches.Redux   $Patches.Language
    Write-Host "Patched File Name:" $PatchedFileName
    Write-Host "Command:" $Command
    Write-Host "Downgrade:" $Downgrade
    Write-Host "Decompress:" $Decompress
    Write-Host "Hash:" $CheckHashSum
    Write-Host "Wii VC:" $IsWiiVC
    Write-Host "ROM File:" $ROMFile
    Write-Host "WAD File Path:" $WADFilePath
    Write-Host "Z64 File Path:" $Z64FilePath

    return $False

}



#==============================================================================================================================================================================================
function Cleanup() {
    
    RemovePath -LiteralPath ($Paths.Master + '\cygdrive')
    DeleteFile -File $Files.flipscfg
    DeleteFile -File $Files.stackdump

    if ($IsWiiVC) {
        RemovePath -LiteralPath $WADFile.Folder
        DeleteFile -File $Files.ckey
        DeleteFile -File ($Paths.WiiVC + "\00000000.app")
        DeleteFile -File ($Paths.WiiVC + "\00000001.app")
        DeleteFile -File ($Paths.WiiVC + "\00000002.app")
        DeleteFile -File ($Paths.WiiVC + "\00000003.app")
        DeleteFile -File ($Paths.WiiVC + "\00000004.app")
        DeleteFile -File ($Paths.WiiVC + "\00000005.app")
        DeleteFile -File ($Paths.WiiVC + "\00000006.app")
        DeleteFile -File ($Paths.WiiVC + "\00000007.app")
        DeleteFile -File ($Paths.WiiVC + "\" + $WADFile.FolderName + ".cert")
        DeleteFile -File ($Paths.WiiVC + "\" + $WADFile.FolderName + ".tik")
        DeleteFile -File ($Paths.WiiVC + "\" + $WADFile.FolderName + ".tmd")
        DeleteFile -File ($Paths.WiiVC + "\" + $WADFile.FolderName + ".trailer")
    }

    DeleteFile -File $Files.dmaTable
    DeleteFile -File $Files.archive
    DeleteFile -File $Files.decompressedROM

    foreach($Folder in Get-ChildItem -LiteralPath $Paths.WiiVC -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }

    EnableGUI -Enable $True
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function UpdateROMCRC() {

    if (!(Test-Path -LiteralPath $PatchedROMFile -PathType Leaf)) { Copy-Item -LiteralPath $ROMFile -Destination $PatchedROMFile }
    & $Files.rn64crc $PatchedROMFile -update | Out-Host

}



#==============================================================================================================================================================================================
function EnableGUI([Boolean]$Enable) {
    
    $InputWADPanel.Enabled = $Enable
    $PatchPanel.Enabled = $Enable
    $MiscPanel.Enabled = $PatchVCPanel.Enabled = $Enable

}


#==============================================================================================================================================================================================
function DeleteFile([String]$File) { if (Test-Path -LiteralPath $File -PathType Leaf) { Remove-Item -LiteralPath $File -Force } }



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



#==================================================================================================================================================================================================================================================================
function SetIconParameters() {
    
    # Create a hash table.
    $Icons = @{}

    # Store all files by their name.
    $Icons.Main                 = $Paths.Icons + "\Main.ico"

    $Icons.CheckGameID          = $Paths.Icons + "\Check GameID.ico"
    $Icons.Credits              = $Paths.Icons + "\Credits.ico"

    $Icons.GetEnumerator() | ForEach-Object {
        if (!(Test-Path $_.value -PathType Leaf)) {
            $global:MissingFiles = $True
        }
    }

    return $Icons

}



#==============================================================================================================================================================================================
function SetFileParameters() {
    
    # Create a hash table.
    $Files = @{}

    # Store all files by their name.
    $Files.flips                            = $Paths.Master + "\Base\flips.exe"
    $Files.rn64crc                          = $Paths.Master + "\Base\rn64crc.exe"
    $Files.xdelta                           = $Paths.Master + "\Base\xdelta.exe"
    $Files.xdelta3                          = $Paths.Master + "\Base\xdelta3.exe"

    $Files.Compress                         = $Paths.Master + "\Compression\Compress.exe"
    $Files.ndec                             = $Paths.Master + "\Compression\ndec.exe"
    $Files.sm64extend                       = $Paths.Master + "\Compression\sm64extend.exe"
    $Files.TabExt                           = $Paths.Master + "\Compression\TabExt.exe"
    
    $Files.wadpacker                        = $Paths.WiiVC + "\wadpacker.exe"
    $Files.wadunpacker                      = $Paths.WiiVC + "\wadunpacker.exe"
    $Files.wszst                            = $Paths.WiiVC + "\wszst.exe"
    $Files.cygcrypto                        = $Paths.WiiVC + "\cygcrypto-0.9.8.dll"
    $Files.cyggccs1                         = $Paths.WiiVC + "\cyggcc_s-1.dll"
    $Files.cygncursesw10                    = $Paths.WiiVC + "\cygncursesw-10.dll"
    $Files.cygpng1616                       = $Paths.WiiVC + "\cygpng16-16.dll"
    $Files.cygwin1                          = $Paths.WiiVC + "\cygwin1.dll"
    $Files.cygz                             = $Paths.WiiVC + "\cygz.dll"
    $Files.lzss                             = $Paths.WiiVC + "\lzss.exe"
    $Files.romc                             = $Paths.WiiVC + "\romc.exe"
    $Files.romchu                           = $Paths.WiiVC + "\romchu.exe"

    $Files.bpspatch_oot_rev1_to_rev0        = CheckPatchExtension -File ($Paths.Master + "\Ocarina of Time\oot_rev1_to_rev0")
    $Files.bpspatch_oot_rev2_to_rev0        = CheckPatchExtension -File ($Paths.Master + "\Ocarina of Time\oot_rev2_to_rev0")
    $Files.bpspatch_oot_models_mm           = CheckPatchExtension -File ($Paths.Master + "\Ocarina of Time\Decompressed\oot_models_mm")
    $Files.bpspatch_oot_models_mm_redux     = CheckPatchExtension -File ($Paths.Master + "\Ocarina of Time\Decompressed\oot_models_mm_redux")
    $Files.bpspatch_oot_redux               = CheckPatchExtension -File ($Paths.Master + "\Ocarina of Time\Decompressed\oot_redux")
    $Files.bpspatch_oot_widescreen_textures = CheckPatchExtension -File ($Paths.Master + "\Ocarina of Time\Decompressed\oot_widescreen_textures")

    $Files.bpspatch_mm_redux                = CheckPatchExtension -File ($Paths.Master + "\Majora's Mask\Decompressed\mm_redux")
    $Files.bpspatch_mm_widescreen_textures  = CheckPatchExtension -File ($Paths.Master + "\Majora's Mask\Decompressed\mm_widescreen_textures")

    $Files.bpspatch_sm64_cam                = CheckPatchExtension -File ($Paths.Master + "\Super Mario 64\sm64_cam")
    $Files.bpspatch_sm64_fps                = CheckPatchExtension -File ($Paths.Master + "\Super Mario 64\sm64_fps")

    $Files.games                            = $Paths.Master + "\Games.json"

    # Error
    $Files.GetEnumerator() | ForEach-Object {
        if (!(Test-Path $_.value -PathType Leaf)) { CreateErrorDialog -Error "Missing Files" -Exit $True }
    }

    $Files.text_gameID                      = $Paths.Text + "\GameID's.txt"

    $Files.flipscfg                         = $Paths.Master + "\Base\flipscfg.bin"
    $Files.ckey                             = $Paths.Master + "\Wii VC\common-key.bin"
    $Files.dmaTable                         = $Paths.Base + "\dmaTable.dat"
    $Files.archive                          = $Paths.Base + "\ARCHIVE.bin"
    $Files.decompressedROM                  = $Paths.Master + "\decompressed"
    $Files.stackdump                        = $Paths.WiiVC + "\wadpacker.exe.stackdump"

    # Set it to a global value.
    return $Files

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
    else                        { $WADFile.ROMFile = $WADFile.AppPath05 + '\rom' }
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
    
    if ($IsWiiVC) {
        $global:ROMFile = $WADFile.ROMFile
        $global:ROMCFile = $WADFile.AppPath05 + "\out"
        $global:PatchedROMFile = $WADFile.ROMFile
        $global:DecompressedROMFile = $WADFile.AppPath05 + "\decompressed"
    }
    else {
        $global:ROMFile = $Z64File.ROMFile
        $global:PatchedROMFile = $Z64File.Patched
        $global:DecompressedROMFile = ($Paths.Master + "\decompressed")
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
    try   { & $Files.wadunpacker $GameWAD | Out-Null }
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
    & $Files.wszst 'X' $WADFile.AppFile05 '-d' $WADFile.AppPath05 | Out-Null

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
        $Patch = $Paths.Master + "\" + $GameType.mode + "\AppFile01\" +  $Patches.Base.BaseName + ".bps"
        ApplyPatch -File $WADFile.AppFile01 -Patch $Patch
    }

    if ($GameType.mode -eq "Ocarina of Time") {
        
        if ($PatchVCExpandMemory.Checked) {
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "2EB0" -Values @("60", "00", "00", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "5BF44" -Values @("3C", "80", "72", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "5BFD7" -Values @("00")
        }

        if ($PatchVCRemapDPad.Checked) {
            if (!$PatchVCLeaveDPadUp.Checked) { PatchBytesSequence -File $WadFile.AppFile01 -Offset "16BAF0" -Values @("08", "00") }
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "16BAF4" -Values @("04", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "16BAF8" -Values @("02", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "16BAFC" -Values @("01", "00")
        }

        if ($PatchVCRemapCDown.Checked)         { PatchBytesSequence -File $WadFile.AppFile01 -Offset "16BB04" -Values @("00", "20") }
        if ($PatchVCRemapZ.Checked)             { PatchBytesSequence -File $WadFile.AppFile01 -Offset "16BAD8" -Values @("00", "20") }

    }

    elseif ($GameType.mode -eq "Majora's Mask") {
        
        if ($PatchVCExpandMemory.Checked -or $PatchVCRemapDPad.Checked -or $PatchVCRemapCDown.Checked -or $PatchVCRemapZ.Checked) { & $Files.lzss -d $WADFile.AppFile01 | Out-Host }

        if ($PatchVCExpandMemory.Checked) {
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "10B58" -Values @("3C", "80", "00", "C0")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "4BD20" -Values @("67", "E4", "70", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "4BC80" -Values @("3C", "A0", "01", "00")
        }

        if ($PatchVCRemapDPad.Checked) {
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "148514" -Values @("08", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "148518" -Values @("04", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "14851C" -Values @("02", "00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "148520" -Values @("01", "00")
        }

        if ($PatchVCRemapCDown.Checked)         { PatchBytesSequence -File $WadFile.AppFile01 -Offset "148528" -Values @("00", "20") }
        if ($PatchVCRemapZ.Checked)             { PatchBytesSequence -File $WadFile.AppFile01 -Offset "1484F8" -Values @("00", "20") }

        if ($PatchVCExpandMemory.Checked -or $PatchVCRemapDPad.Checked -or $PatchVCRemapCDown.Checked -or $PatchVCRemapZ.Checked) { & $Files.lzss -evn $WADFile.AppFile01 | Out-Host }

    }

    elseif ($GameType.mode -eq "Super Mario 64") {
        
        if ($PatchVCRemoveFilter.Checked -and (StrLike -str $Command -val "Multiplayer") )   { PatchBytesSequence -File $WadFile.AppFile01 -Offset "53124" -Values @("60", "00", "00", "00") }
        elseif ($PatchVCRemoveFilter.Checked)                                                { PatchBytesSequence -File $WadFile.AppFile01 -Offset "46210" -Values @("4E", "80", "00", "20") }

    }

}



#==============================================================================================================================================================================================
function PatchVCROM([String]$Command) {

    if (StrLike -str $Command -val "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabel -Text ("Initial patching of " + $GameType.mode + " ROM...")
    
    # Extract ROM if required
    if (StrLike -str $Command -val "Extract") {
        if (!$GameType.patches)   { $ROMTitle = "n64_rom_extracted.z64" }
        else                      { $ROMTitle = $GameType.mode + "_rom_extracted.z64" }

        if (Test-Path -LiteralPath $ROMFile -PathType Leaf) {
            Move-Item -LiteralPath $ROMFile -Destination $WADFile.Extracted
            UpdateStatusLabel -Text ("Successfully extracted " + $GameType.mode + " ROM.")
        }
        else { UpdateStatusLabel -Text ("Could not extract " + $GameType.mode + " ROM. Is it a Majora's Mask or Paper Mario ROM?") }

        return $False
    }

    # Replace ROM if needed
    if (StrLike -str $Command -val "Inject") {
        if (Test-Path -LiteralPath $ROMFile -PathType Leaf) {
            Remove-Item -LiteralPath $ROMFile
            if ((Test-Path -LiteralPath $Z64FilePath -PathType Leaf)) { Copy-Item -LiteralPath $Z64FilePath -Destination $ROMFile }
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

        if (Test-Path -LiteralPath $ROMFile -PathType Leaf) {
            if ($GameType.romc -eq 1)       { & $Files.romchu $ROMFile $ROMCFile | Out-Null }
            elseif ($GameType.romc -eq 2)   { & $Files.romc d $ROMFile $ROMCFile | Out-Null }
            Remove-Item -LiteralPath $ROMFile
            Rename-Item -LiteralPath $ROMCFile -NewName "romc"
        }
        else {
            UpdateStatusLabel -Text ("Could not decompress " + $GameType.mode + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
            return $False
        }

    }

    # Get the file as a byte array so the size can be analyzed.
    $ByteArray = [IO.File]::ReadAllBytes($ROMFile)
    
    # Create an empty byte array that matches the size of the ROM byte array.
    $NewByteArray = New-Object Byte[] $ByteArray.Length
    
    # Fill the entire array with junk data. The patched ROM is slightly smaller than 8MB but we need an 8MB ROM.
    for ($i=0; $i-lt $ByteArray.Length; $i++) { $NewByteArray[$i] = 255 }

    $ByteArray = $null

    return $True

}



#==============================================================================================================================================================================================
function DowngradeROM([String]$Command, [Boolean]$Downgrade) {
    
    if (StrLike -str $Command -val "Inject") { return $True }

    # Downgrade a ROM if it is required first
    if ( (IsChecked $PatchVCDowngrade -Visible $True) -and $GameType.downgrade) {
        
        $HashSum = (Get-FileHash -Algorithm MD5 $ROMFile).Hash
        if ($HashSum -ne $HashSum_oot_rev1 -and $HashSum -ne $HashSum_oot_rev2) {
            UpdateStatusLabel -Text "Failed! Ocarina of Time ROM does not match revision 1 or 2."
            return $False
        }

        if ($HashSum -eq $HashSum_oot_rev1)       { ApplyPatch -File $ROMFile -Patch $Files.bpspatch_oot_rev1_to_rev0 }
        elseif ($HashSum -eq $HashSum_oot_rev2)   { ApplyPatch -File $ROMFile -Patch $Files.bpspatch_oot_rev2_to_rev0 }
        $global:CheckHashSum = (Get-FileHash -Algorithm MD5 $ROMFile).Hash

        $HashSum = $null

    }

    return $True
    
}



#==============================================================================================================================================================================================
function CompareHashSums([String]$Command) {
    
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Patch VC") -or (StrLike -str $Command -val "Apply Patch") ) { return $True }

    $ContinuePatching = $True
    $HashSum = (Get-FileHash -Algorithm MD5 $ROMFile).Hash
        
    if ($CheckHashSum -eq "Dawn & Dusk") {
        if ($HashSum -eq $HashSum_oot_rev0)     { $global:Patches.Base = Get-Item -LiteralPath $Files.bpspatch_oot_dawn_rev0 }
        elseif ($HashSum -eq $HashSum_oot_rev1) { $global:Patches.Base = Get-Item -LiteralPath $Files.bpspatch_oot_dawn_rev1 }
        elseif ($HashSum -eq $HashSum_oot_rev2) { $global:Patches.Base = Get-Item -LiteralPath $Files.bpspatch_oot_dawn_rev2 }
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
function PatchROM([String]$Command, [Boolean]$Decompress, [Boolean]$Downgrade) {
    
    if ( (StrLike -str $Command -val "Inject") -or (StrLike -str $Command -val "Patch VC") -or !(IsSet $Patches.Base) ) { return $True }
    
    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " ROM with patch file...")

    if (StrLike -str $Command -val "Apply Patch") { $HashSum1 = (Get-FileHash -Algorithm MD5 $ROMFile).Hash }

    # Apply the selected patch to the ROM, if it is provided
    if ($IsWiiVC -and $Decompress)         { if (!(ApplyPatch -File $DecompressedROMFile -Patch $Patches.Base))            { return $False } }
    elseif ($IsWiiVC -and !$Decompress)    { if (!(ApplyPatch -File $PatchedROMFile -Patch $Patches.Base))                 { return $False } }
    elseif (!$IsWiiVC -and $Decompress)    { if (!(ApplyPatch -File $DecompressedROMFile -Patch $Patches.Base))            { return $False } }
    elseif (!$IsWiiVC -and !$Decompress)   { if (!(ApplyPatch -File $ROMFile -Patch $Patches.Base -New $PatchedROMFile))   { return $False } }

    if (StrLike -str $Command -val "apply patch") {
        $HashSum2 = (Get-FileHash -Algorithm MD5 $PatchedROMFile).Hash
        if ($HashSum1 -eq $HashSum2) {
            if ($IsWiiVC -and $GameType.downgrade -and !$Downgrade)      { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Enable Downgrade?" }
            elseif ($IsWiiVC -and $GameType.downgrade -and $Downgrade)   { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged. Disable Downgrade?" }
            else                                                         { UpdateStatusLabel -Text "Failed! Patch file does not match source. ROM has left unchanged." }
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function ApplyPatch([String]$File, [String]$Patch, [String]$New) {
    
    if ( !(IsSet -Elem $File) -or !(IsSet -Elem $Patch) ) { return $True }

    if (!(Test-Path -LiteralPath $File -PathType Leaf)) {
        UpdateStatusLabel -Text "Failed! Could not find ROM file."
        return $False
    }

    if (!(Test-Path -LiteralPath $Patch -PathType Leaf)) {
        UpdateStatusLabel -Text "Failed! Could not find Patch file."
        return $False
    }

    if ($Patch -like "*.bps*" -or $Patch -like "*.ips*") {
        if ($New.Length -gt 0) { & $Files.flips --ignore-checksum --apply $Patch $File $New | Out-Host }
        else { & $Files.flips --ignore-checksum $Patch $File | Out-Host }
    }
    elseif ($Patch -like "*.xdelta*" -or $Patch -like "*.vcdiff*") {
        if ($Patch -like "*.xdelta*")       { $File = $Files.xdelta }
        elseif ($Patch -like "*.vcdiff*")   { $File = $Files.xdelta3 }

        if ($New.Length -gt 0) {
            DeleteFile -File $New
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
        & $Files.TabExt $ROMFile | Out-Host
        & $Files.ndec $ROMFile $DecompressedROMFile | Out-Host
    }
    elseif ($GameType.decompress -eq 2) {
        if (!(IsSet -Elem $GamePatch.extend -Min 18 -Max 64)) {
            UpdateStatusLabel -Text 'Failed. Could not extend SM64 ROM. Make sure the "extend" value is between 18 and 64.'
            return $False
        }

        if (Test-Path -LiteralPath $DecompressedROMFile -PathType Leaf)   { & $Files.sm64extend $DecompressedROMFile -s $GamePatch.extend $DecompressedROMFile | Out-Host }
        else                                                              { & $Files.sm64extend $ROMFile -s $GamePatch.extend $DecompressedROMFile | Out-Host }
    }

    if ($IsWiiVC) { Remove-Item -LiteralPath $ROMFile }

    return $True

}



#==============================================================================================================================================================================================
function CompressROM([Boolean]$Decompress) {
    
    if (!(Test-Path -LiteralPath $DecompressedROMFile -PathType Leaf)) { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType.mode + " ROM...")

    if ($GameType.decompress -eq 1) {
        & $Files.Compress $DecompressedROMFile $PatchedROMFile | Out-Null
        Remove-Item -LiteralPath $DecompressedROMFile
    }
    elseif ($GameType.decompress -eq 2) { Move-Item -LiteralPath $DecompressedROMFile -Destination $PatchedROMFile -Force }

}



#==============================================================================================================================================================================================
function CompressROMC() {
    
    if ($GameType.romc -ne 2) { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType.mode + " VC ROM...")

    & $Files.romc e $ROMFile $ROMCFile | Out-Null
    Remove-Item -LiteralPath $ROMFile
    Rename-Item -LiteralPath $ROMCFile -NewName "romc"

}



#==============================================================================================================================================================================================
function PatchBytesSequence([String]$File, [String]$Offset, [String[]]$Values, [int]$Increment, [Boolean]$IsDec) {
    
    $ByteArray = [IO.File]::ReadAllBytes($File)

    if (!(IsSet -Elem $Increment -Min 1)) { $Increment = 1 }
    [uint32]$Offset = GetDecimal -Hex $Offset

    for ($i=0; $i -lt $Values.Length; $i++) {
        if ($IsDec)   { [uint32]$Value = $Values[$i] }
        else          { [uint32]$Value = GetDecimal -Hex $Values[$i] }
        $ByteArray[$Offset + ($i * $Increment)] = $Value
    }

    [io.file]::WriteAllBytes($File, $ByteArray)
    $ByteArray = $Offset = $Value = $File = $Increment = $null
    $Values = $null

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([String]$Hex) { return [uint32]("0x" + $Hex) }



#==============================================================================================================================================================================================
function PatchOptionsZelda() {
    
    if (!$Decompress) { return }

    # BPS PATCHING REDUX #
    if ( (IsChecked $PatchReduxCheckbox -Visible $True) -and (IsSet -Elem $GamePatch.redux.file) ) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " REDUX...")
        if (IsSet -Elem $Patches.Redux) { $DecompressedROMFile; ApplyPatch -File $DecompressedROMFile -Patch $Patches.Redux } # Redux

        if ($Gametype.decompress -eq 1 -and (IsSet -Elem $GameType.dmaTable) ) {
            DeleteFile -File $Files.dmaTable
            Add-Content $Files.dmaTable $GameType.dmaTable
        }
    }

    # BYE PATCHING & BPS PATCHING OPTIONS #
    if ( (IsChecked $PatchOptionsCheckbox -Visible $True) -and $GamePatch.options) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")
        if ($GameType.mode -eq "Ocarina of Time")     { PatchOptionsOoT }
        elseif ($GameType.mode -eq "Majora's Mask")   { PatchOptionsMM }
    }

    # BPS PATCHING LANGUAGE #
    if (IsSet -Elem $Patches.Language) { # Language
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $DecompressedROMFile -Patch $Patches.Language
    } 

}


#==============================================================================================================================================================================================
function PatchOptionsOoT() {
    
    # HERO MODE #

    if (IsChecked -Elem $Options.OHKOMode -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "AE8073" -Values @("09", "04") -Increment 16
        PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("82", "00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "AE8099" -Values @("00", "00", "00")
    }
    elseif (!(IsChecked -Elem $Options.Damage1x -Enabled $True) -and !(IsChecked -Elem $Options.NormalRecovery -Enabled $True)) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "AE8073" -Values @("09", "04") -Increment 16
        if (IsChecked -Elem $Options.NormalRecovery -Enabled $True) {                
            if (IsChecked -Elem $Options.Damage2x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "40") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "80") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "C0") }
            PatchBytesSequence -File $Options.DecompressedROMFile -Offset "AE8099" -Values @("00", "00", "00")
        }
        elseif (IsChecked -Elem $Options.HalfRecovery -Enabled $True) {               
            if (IsChecked -Elem $Options.Damage1x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "40") }
            elseif (IsChecked -Elem $Options.Damage2x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "80") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("81", "00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "AE8099" -Values @("10", "80", "43")
        }
        elseif (IsChecked -Elem $Options.QuarterRecovery -Enabled $True) {                
            if (IsChecked -Elem $Options.Damage1x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "80") }
            elseif (IsChecked -Elem $Options.Damage2x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("81", "00") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("81", "40") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "AE8099" -Values @("10", "80", "83")

        }
        elseif (IsChecked -Elem $Options.NoRecovery -Enabled $True) {                
            if (IsChecked -Elem $Options.Damage1x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("81", "40") }
            elseif (IsChecked -Elem $Options.Damage2x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("81", "80") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("81", "C0") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "AE8096" -Values @("82", "00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "AE8099" -Values @("10", "81", "43")
        }
    }



    # TEXT DIALOGUE SPEED #

    if (IsChecked -Elem $Options.Text2x -Enabled $True) { PatchBytesSequence -File $DecompressedROMFile -Offset "B5006F" -Values @("02") }
    elseif (IsChecked -Elem $Options.Text3x -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B6E7" -Values @("09", "05", "40", "2E", "05", "46", "01", "05", "40")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B6F1" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B71E" -Values @("09", "2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B722" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B74C" -Values @("09", "21", "05", "42")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B752" -Values @("01", "05", "40")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B776" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B77A" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7A1" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7A5" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7A8" -Values @("1A")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7C9" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7CD" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7F2" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B7F6" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B81C" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B820" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B849" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B84D" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B86D" -Values @("09", "2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B871" -Values @("01") 
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B88F" -Values @("09", "2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B893" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B8BE" -Values @("09", "2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B8C2" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B8EF" -Values @("09", "2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B8F3" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B91A" -Values @("09", "21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B91E" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B94E" -Values @("09", "2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B952" -Values @("01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B728" -Values @("10")
        PatchBytesSequence -File $DecompressedROMFile -Offset "93B72A" -Values @("01")

        PatchBytesSequence -File $DecompressedROMFile -Offset "B5006F" -Values @("03")
    }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled $True)             { PatchBytesSequence -File $DecompressedROMFile -Offset "B08038" -Values @("3C", "07", "3F", "E3") }
    if (IsChecked -Elem $Options.WidescreenTextures -Enabled $True)     { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_oot_widescreen_textures }
    if (IsChecked -Elem $Options.ExtendedDraw -Enabled $True)           { PatchBytesSequence -File $DecompressedROMFile -Offset "A9A970" -Values @("00", "01") }
    if (IsChecked -Elem $Options.ForceHiresModel -Enabled $True)        { PatchBytesSequence -File $DecompressedROMFile -Offset "BE608B" -Values @("00") }

    if (IsChecked -Elem $Options.BlackBars -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "B0F5A4" -Values @("00", "00","00", "00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "B0F5D4" -Values @("00", "00","00", "00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "B0F5E4" -Values @("00", "00","00", "00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "B0F680" -Values @("00", "00","00", "00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "B0F688" -Values @("00", "00","00", "00")
    }

    if (IsChecked -Elem $Options.MMModels -Enabled $True) {
        if (IsChecked $PatchReduxCheckbox -Visible $True)               { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_oot_models_mm_redux }
        else                                                            { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_oot_models_mm }
    }

    if (IsChecked -Elem $Options.CorrectRupeeColors -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "F47EB0" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        PatchBytesSequence -File $DecompressedROMFile -Offset "F47ED0" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }


    
    # EQUIPMENT #

    if (IsChecked -Elem $Options.ReducedItemCapacity -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC2F" -Values @("14", "19", "1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC37" -Values @("0A", "0F", "14") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC57" -Values @("14", "19", "1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC5F" -Values @("05", "0A", "0F") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC67" -Values @("0A", "0F", "14") -Increment 2
    }
    elseif (IsChecked -Elem $Options.IncreasedIemCapacity -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC2F" -Values @("28", "46", "63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC37" -Values @("1E", "37", "50") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC57" -Values @("28", "46", "63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC5F" -Values @("0F", "1E", "2D") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "B6EC67" -Values @("1E", "37", "50") -Increment 2
    }

    if (IsChecked -Elem $Options.UnlockSword -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "BC77AD" -Values @("09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "BC77F7" -Values @("09")
    }

    if (IsChecked -Elem $Options.UnlockTunics -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "BC77B6" -Values @("09", "09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "BC77FE" -Values @("09", "09")
    }

    if (IsChecked -Elem $Options.UnlockBoots -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "BC77BA" -Values @("09", "09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "BC7801" -Values @("09", "09")
    }



    # OTHER #

    if (IsChecked -Elem $Options.Medallions -Enabled $True)                 { PatchBytesSequence -File $DecompressedROMFile -Offset "E2B454" -Values @("80", "EA", "00", "A7", "24", "01", "00", "3F", "31", "4A", "00", "3F", "00", "00", "00", "00") }
    if (IsChecked -Elem $Options.DisableLowHPSound -Enabled $True)          { PatchBytesSequence -File $DecompressedROMFile -Offset "ADBA1A" -Values @("00", "00") }
    if (IsChecked -Elem $Options.DisableNavi -Enabled $True)                { PatchBytesSequence -File $DecompressedROMFile -Offset "DF8B84" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.HideDPad -Enabled $True)                   { PatchBytesSequence -File $DecompressedROMFile -Offset "348086E" -Values @("00") }

    if (IsChecked -Elem $Options.ReturnChild -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "CB6844" -Values @("35")
        PatchBytesSequence -File $DecompressedROMFile -Offset "253C0E2" -Values @("03")
    }

}



#==============================================================================================================================================================================================
function PatchOptionsMM() {
    
    # HERO MODE #

    if (IsChecked -Elem $Options.OHKOMode -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "BABE7F" -Values @("09", "04") -Increment 16
        PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("2A", "00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA5" -Values @("00", "00", "00")
    }
    elseif (!(IsChecked -Elem $Options.Damage1x -Enabled $True) -and !(IsChecked -Elem $Options.NormalRecovery -Enabled $True)) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "BABE7F" -Values @("09", "04") -Increment 16
        if (IsChecked -Elem $Options.NormalRecovery -Enabled $True) {
            if (IsChecked -Elem $Options.Damage2x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "C0") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA5" -Values @("00", "00", "00")
        }
        elseif (IsChecked -Elem $Options.HalfRecovery -Enabled $True) {
            if (IsChecked -Elem $Options.Damage1x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsChecked -Elem $Options.Damage2x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("29", "00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA5" -Values @("05", "28", "43")
        }
        elseif (IsChecked -Elem $Options.QuarterRecovery -Enabled $True) {
            if (IsChecked -Elem $Options.Damage1x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsChecked -Elem $Options.Damage2x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("29", "00") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("29", "40") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA5" -Values @("05", "28", "83")
        }
        elseif (IsChecked -Elem $Options.NoRecovery -Enabled $True) {
            if (IsChecked -Elem $Options.Damage1x -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("29", "40") }
            elseif (IsChecked -Elem $Options.Damage2x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("29", "80") }
            elseif (IsChecked -Elem $Options.Damage4x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("29", "C0") }
            elseif (IsChecked -Elem $Options.Damage8x -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA2" -Values @("2A", "00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "BABEA5" -Values @("05", "29", "43")
        }
    }



    # D-PAD #

    if (IsChecked -Elem $Options.LeftDPad -Enabled $True)               { PatchBytesSequence -File $DecompressedROMFile -Offset "3806365" -Values @("01") }
    elseif (IsChecked -Elem $Options.RightDPad -Enabled $True)          { PatchBytesSequence -File $DecompressedROMFile -Offset "3806365" -Values @("02") }
    elseif (IsChecked -Elem $Options.HideDPad -Enabled $True)           { PatchBytesSequence -File $DecompressedROMFile -Offset "3806365" -Values @("00") }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "BD5D74" -Values @("3C", "07", "3F", "E3")
        PatchBytesSequence -File $DecompressedROMFile -Offset "CA58F5" -Values @("6C", "53", "6C", "84", "9E", "B7", "53", "6C") -Increment 2
    }

    if (IsChecked -Elem $Options.WidescreenTextures -Enabled $True)     { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_mm_widescreen_textures }
    if (IsChecked -Elem $Options.ExtendedDraw -Enabled $True)           { PatchBytesSequence -File $DecompressedROMFile -Offset "B50874" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.BlackBars -Enabled $True)              { PatchBytesSequence -File $DecompressedROMFile -Offset "BF72A4" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.PixelatedStars -Enabled $True)         { PatchBytesSequence -File $DecompressedROMFile -Offset "B943FC" -Values @("10", "00") }

    if (IsChecked -Elem $Options.CorrectRupeeColors -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "10ED020" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        PatchBytesSequence -File $DecompressedROMFile -Offset "10ED040" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }



    # EQUIPMENT #

    if (IsChecked -Elem $Options.ReducedItemCapacity -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile "C5834F" -Values @("14", "19", "1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "C58357" -Values @("0A", "0F", "14") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "C5837F" -Values @("05", "0A", "0F") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "C58387" -Values @("0A", "0F", "14") -Increment 2
    }
    elseif (IsChecked -Elem $Options.IncreasedIemCapacity -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile "C5834F" -Values @("28", "46", "63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "C58357" -Values @("1E", "37", "50") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "C5837F" -Values @("0F", "1E", "2D") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "C58387" -Values @("1E", "37", "50") -Increment 2
    }

    if (IsChecked -Elem $Options.RazorSword -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "CBA496" -Values @("00", "00") # Prevent losing hits
        PatchBytesSequence -File $DecompressedROMFile -Offset "BDA6B7" -Values @("01")         # Keep sword after Song of Time
    }



    # OTHER #
    
    if (IsChecked -Elem $Options.DisableLowHPSound -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "B97E2A" -Values @("00", "00") }
    if (IsChecked -Elem $Options.PieceOfHeartSound -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "BA94C8" -Values @("10", "00") }
    if (IsChecked -Elem $Options.FixGothCutscene -Enabled $True)        { PatchBytesSequence -File $DecompressedROMFile -Offset "F6DE89" -Values @("8D", "00", "02", "10", "00", "00", "0A") }
    if (IsChecked -Elem $Options.MoveBomberKid -Enabled $True)          { PatchBytesSequence -File $DecompressedROMFile -Offset "2DE4396" -Values @("02", "C5", "01", "18", "FB", "55", "00", "07", "2D") }

}



#==============================================================================================================================================================================================
function PatchOptionsSM64() {
    
    if ( !(IsChecked -Elem $PatchOptionsCheckbox -Visible $True) -or !$GamePatch.options) { return }
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")

    Copy-Item -LiteralPath $ROMFile -Destination $DecompressedROMFile



    # HERO MODE

    if (IsChecked -Elem $Options.Damage2x -Enabled $True)          { PatchBytesSequence -File $DecompressedROMFile -Offset "F207" -Values @("80") }
    elseif (IsChecked -Elem $Options.Damage3x -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "F207" -Values @("40") }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "3855E" -Values @("47", "40")
        PatchBytesSequence -File $DecompressedROMFile -Offset "35456" -Values @("46", "C0")
    }

    if (IsChecked -Elem $Options.ForceHiresModel -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "32184" -Values @("10", "00")}
    
    if (IsChecked -Elem $Options.BlackBars -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "23A7" -Values @("BC", "00") -Increment 12
        PatchBytesSequence -File $DecompressedROMFile -Offset "248E" -Values @("00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "2966" -Values @("00", "00") -Increment 48
        PatchBytesSequence -File $DecompressedROMFile -Offset "3646A" -Values @("00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "364AA" -Values @("00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "364F6" -Values @("00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "36582" -Values @("00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "3799F" -Values @("BC", "00") -Increment 12
    }



    # GAMEPLAY #
    if (IsChecked -Elem $Options.FPS -Enabled $True)               { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_sm64_fps }
    if (IsChecked -Elem $Options.FreeCam -Enabled $True)           { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_sm64_cam }
    if (IsChecked -Elem $Options.LagFix -Enabled $True)            { PatchBytesSequence -File $DecompressedROMFile -Offset "F0022" -Values @("0D") }

}



#==============================================================================================================================================================================================
function ExtendROM() {
    
    if ($GameType.romc -ne 1) { return }

    $Bytes = @(08, 00, 00, 00)
    $ByteArray = [IO.File]::ReadAllBytes($ROMFile)
    [io.file]::WriteAllBytes($ROMFile, $Bytes + $ByteArray)

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
    
    if (!(Test-Path -LiteralPath $PatchedROMFile -PathType Leaf)) { return }

    UpdateStatusLabel -Text "Hacking in Custom Title and GameID..."

    $emptyTitle = foreach ($i in 1..$GameTitleLength[0]) { 20 }
    PatchBytesSequence -File $PatchedROMFile -Offset "20" -Values $emptyTitle
    PatchBytesSequence -File $PatchedROMFile -Offset "20" -Values ($Title.ToUpper().ToCharArray() | % { [uint32][char]$_ }) -IsDec $True
    PatchBytesSequence -File $PatchedROMFile -Offset "3B" -Values ($GameID.ToCharArray() | % { [uint32][char]$_ }) -IsDec $True

}



#==============================================================================================================================================================================================
function RepackU8AppFile() {
    
    # Set the status label.
    UpdateStatusLabel -Text 'Repacking "00000005.app" file...'

    # Remove the original app file as its going to be replaced.
    RemovePath -LiteralPath $WadFile.AppFile05

    # Repack the file using wszst.
    & $Files.wszst 'C' $WadFile.AppPath05 '-d' $WadFile.AppFile05 # | Out-Host

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
        DeleteFile -File ($Paths.WiiVC + "\" + $File.Name)
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
    & $Files.wadpacker $tik $tmd $cert $WadFile.Patched '-sign' '-i' $GameID

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
        $InjectROMButton.Enabled = ($WADFilePath -ne $null -and $Z64FilePath -ne $null)
        $PatchBPSButton.Enabled = ($WADFilePath -ne $null -and $BPSFilePath -ne $null) } else { $PatchBPSButton.Enabled = ($Z64FilePath -ne $null -and $BPSFilePath -ne $null)
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
    $global:WADFilePath = Get-Item -LiteralPath $WADPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $WADPath

    EnablePatchButtons -Enable $True
    ChangeGamesList
    SetWiiVCMode -Bool $True

    # Check if both a .WAD and .Z64 have been provided for ROM injection
    if ($global:Z64FilePath -ne $null) { $InjectROMButton.Enabled = $true }

    # Check if both a .WAD and .BPS have been provided for BPS patching
    if ($global:BPSFilePath -ne $null) { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_Finish([Object]$TextBox, [String]$VarName, [String]$Z64Path) {
    
    # Set the "Z64 ROM" variable that tracks the path.
    Set-Variable -Name $VarName -Value $Z64Path -Scope 'Global'
    $global:Z64FilePath = Get-Item -LiteralPath $Z64Path

    $HashSumROMTextBox.Text = (Get-FileHash -Algorithm MD5 $Z64Path).Hash

    # Update the textbox to the current WAD.
    $TextBox.Text = $Z64Path

    if (!$IsWiiVC) { EnablePatchButtons -Enable $true }
    
    # Check if both a .WAD and .Z64 have been provided for ROM injection or both a .Z64 and .BPS have been provided for BPS patching
    if ($WADFilePath -ne $null -and $IsWiiVC)        { $InjectROMButton.Enabled = $true }
    elseif ($BPSFilePath -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Finish([Object]$TextBox, [String]$VarName, [String]$BPSPath) {
    
    # Set the "BPS File" variable that tracks the path.
    Set-Variable -Name $VarName -Value $BPSPath -Scope 'Global'
    $global:BPSFilePath = Get-Item -LiteralPath $BPSPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $BPSPath

    # Check if both a .WAD and Patch File have been provided for Patch File patching
    if ($WADFilePath -ne $null -and $IsWiiVC)        { $PatchBPSButton.Enabled = $true }
    elseif ($Z64FilePath -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

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
    $MainDialog.Icon = $Icons.Main

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
    $InputWADGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADGroup.Add_DragDrop({ WADPath_DragDrop })

    # Create a textbox to display the selected WAD.
    $global:InputWADTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameWAD" -Text "Select or drag and drop your Virtual Console WAD file..." -AddTo $InputWADGroup
    $InputWADTextBox.AllowDrop = $true
    $InputWADTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADTextBox.Add_DragDrop({ WADPath_DragDrop })

    # Create a button to allow manually selecting a WAD.
    $global:InputWADButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameWAD" -Text "..." -ToolTip $ToolTip -Info "Select your VC WAD File using file explorer" -AddTo $InputWADGroup
    $InputWADButton.Add_Click({ WADPath_Button -TextBox $InputWADTextBox -Description 'VC WAD File' -FileName '*.wad' })

    # Create a button to clear the WAD Path
    $global:ClearWADPathButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Clear" -ToolTip $ToolTip -Info "Clear the selected WAD file" -AddTo $InputWADGroup
    $ClearWADPathButton.Add_Click({
        if ($WADFilePath.Length -gt 0) {
            $global:WADFilePath = $null
            $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
            ChangeGamesList
            SetWiiVCMode -Bool $False
        }
    })



    ############
    # ROM Path #
    ############

    # Create the panel that holds the ROM path.
    $global:InputROMPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the ROM path.
    $InputROMGroup = CreateGroupBox -Width $InputROMPanel.Width -Heigh $InputROMPanel.Height -Name "GameZ64" -Text "ROM Path" -AddTo $InputROMPanel
    $InputROMGroup.AllowDrop = $true
    $InputROMGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMGroup.Add_DragDrop({ Z64Path_DragDrop })

    # Create a textbox to display the selected ROM.
    $global:InputROMTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameZ64" -Text "Select or drag and drop your Z64, N64 or V64 ROM..." -AddTo $InputROMGroup
    $InputROMTextBox.AllowDrop = $true
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
    $InputBPSGroup.AllowDrop = $true
    $InputBPSGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSGroup.Add_DragDrop({ BPSPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $global:InputBPSTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameBPS" -Text "Select or drag and drop your BPS, IPS, Xdelta or VCDiff Patch File..." -AddTo $InputBPSGroup
    $InputBPSTextBox.AllowDrop = $true
    $InputBPSTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSTextBox.Add_DragDrop({ BPSPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $global:InputBPSButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameBPS" -Text "..." -ToolTip $ToolTip -Info "Select your BPS, IPS, Xdelta or VCDiff Patch File using file explorer" -AddTo $InputBPSGroup
    $InputBPSButton.Add_Click({ BPSPath_Button -TextBox $InputBPSTextBox -Description @('BPS Patch File', 'IPS Patch File', 'XDelta Patch File', 'VCDiff Patch File') -FileName @('*.bps', '*.ips', '*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $global:PatchBPSButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Apply Patch" -ToolTip $ToolTip -Info "Patch the ROM with your selected BPS or IPS Patch File" -AddTo $InputBPSGroup
    $PatchBPSButton.Add_Click({ MainFunction -Command "Apply Patch" -Patch $BPSFilePath -PatchedFileName '_bps_patched' })



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game.
    $global:CurrentGamePanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the current game options
    $CurrentGameGroup = CreateGroupBox -Width $CurrentGamePanel.Width -Height $CurrentGamePanel.Height -Text "Current Game Mode" -AddTo $CurrentGamePanel

    # Create a combox for OoT ROM hack patches
    $global:CurrentGameComboBox = CreateComboBox -X 10 -Y 20 -Width 440 -Height 30 -AddTo $CurrentGameGroup
    $CurrentGameComboBox.Add_SelectedIndexChanged({
        if ($CurrentGameComboBox.Text -ne $GameType.title) { ChangeGameMode }
    })

    if (Test-Path -LiteralPath $Files.Games) {
        try { $global:GamesJSONFile = Get-Content -Raw -Path $Files.Games | ConvertFrom-Json }
        catch { CreateErrorDialog -Error "Corrupted JSON" -Exit $True }
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
    $global:PatchComboBox = CreateComboBox -X $PatchButton.Left -Y ($PatchButton.Top - 25) -Width $PatchButton.Width -Height 30 -AddTo $PatchGroup
    $PatchComboBox.Add_SelectedIndexChanged( {
        foreach ($Item in $PatchesJSONFile.patch) {
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
    $global:PatchReduxCheckbox = CreateCheckBox -X $PatchReduxLabel.Right -Y ($PatchReduxLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -AddTo $PatchGroup

    $global:PatchOptionsLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchReduxLabel.Bottom + 15) -Width 85 -Height 15 -Text "Enable Options:" -ToolTip $ToolTip -Info "Enable options" -AddTo $PatchGroup
    $global:PatchOptionsCheckbox = CreateCheckBox -X $PatchOptionsLabel.Right -Y ($PatchOptionsLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable options" -AddTo $PatchGroup
    $PatchOptionsCheckbox.Add_CheckStateChanged({
        $PatchOptionsButton.Enabled = $PatchOptionsCheckbox.Checked
    })

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
    $global:PatchVCRemoveT64 = CreateCheckBox -X $PatchVCRemoveT64Label.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remove all injected T64 format textures" -AddTo $PatchVCGroup
    $PatchVCRemoveT64.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })
    
    # Expand Memory
    $global:PatchVCExpandMemoryLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Expand Memory:" -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $global:PatchVCExpandMemory = CreateCheckBox -X $PatchVCExpandMemoryLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $PatchVCExpandMemory.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Remove Filter
    $global:PatchVCRemoveFilterLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remove Filter:" -ToolTip $ToolTip -Info "Remove the dark overlay filter" -AddTo $PatchVCGroup
    $global:PatchVCRemoveFilter = CreateCheckBox -X $PatchVCRemoveFilterLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remove the dark overlay filter" -AddTo $PatchVCGroup
    $PatchVCRemoveFilter.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Remap D-Pad
    $global:PatchVCRemapDPadLabel = CreateLabel -X ($PatchVCExpandMemory.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remap D-Pad:" -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $global:PatchVCRemapDPad = CreateCheckBox -X $PatchVCRemapDPadLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $PatchVCRemapDPad.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Downgrade
    $global:PatchVCDowngradeLabel = CreateLabel -X ($PatchVCRemapDPad.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Downgrade:" -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $global:PatchVCDowngrade = CreateCheckBox -X $PatchVCDowngradeLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $PatchVCDowngrade.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })



    # Create a label for Minimap
    $global:PatchVCMinimapLabel = CreateLabel -X 10 -Y ($PatchVCCoreLabel.Bottom + 5) -Width 50 -Height 15 -Text "Minimap" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remap C-Down
    $global:PatchVCRemapCDownLabel = CreateLabel -X ($PatchVCMinimapLabel.Right + 20) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap C-Down:" -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapCDown = CreateCheckBox -X $PatchVCRemapCDownLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $PatchVCRemapCDown.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Remap Z
    $global:PatchVCRemapZLabel = CreateLabel -X ($PatchVCRemapCDown.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap Z:" -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapZ = CreateCheckBox -X $PatchVCRemapZLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $PatchVCRemapZ.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })

    # Leave D-Pad Up
    $global:PatchVCLeaveDPadUpLabel = CreateLabel -X ($PatchVCRemapZ.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Leave D-Pad Up:" -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $global:PatchVCLeaveDPadUp = CreateCheckBox -X $PatchVCLeaveDPadUpLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $PatchVCLeaveDPadUp.Add_CheckStateChanged({ $PatchVCButton.Enabled = CheckVCOptions })



    # Create a label for Patch VC Buttons
    $global:ActionsLabel = CreateLabel -X 10 -Y 72 -Width 50 -Height 15 -Text "Actions" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Create a button to patch the VC
    $global:PatchVCButton = CreateButton -X 80 -Y 65 -Width 150 -Height 30 -Text "Patch VC Emulator Only" -ToolTip $ToolTip -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted" -AddTo $PatchVCGroup
    $PatchVCButton.Add_Click({ MainFunction -Command "Patch VC" -Patch $BPSFilePath -PatchedFileName '_vc_patched' })

    # Create a button to extract the ROM
    $global:ExtractROMButton = CreateButton -X 240 -Y 65 -Width 150 -Height 30 -Text "Extract ROM Only" -ToolTip $ToolTip -Info "Only extract the .Z64 ROM from the WAD file`nUseful for native N64 emulators" -AddTo $PatchVCGroup
    $ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -Patch $BPSFilePath })



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
    $global:ExitButton = CreateButton -X ($CreditsButton.Right + 15) -Y $InfoGameIDButton.Top -Width 120 -Height 35 -Text "Exit" -ToolTip $ToolTip -Info ("Close the " + $ScriptName + " tool") -AddTo $MiscGroup
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
    Foreach ($Game in $GamesJSONFile.game) {
        if ( ($IsWiiVC -and $Game.console -eq "Wii VC") -or (!$IsWiiVC -and $Game.console -eq "N64") -or ($Game.console -eq "All") ) { $Items += $Game.title }
    }

    $CurrentGameComboBox.Items.AddRange($Items)

    # Reset last index
    For ($i=0; $i -lt $Items.Length; $i++) {
        if ($GameType.title -eq $Items[$i]) { $CurrentGameComboBox.SelectedIndex = $i }
    }
    if ($Items.Length -gt 0 -and $CurrentGameComboBox.SelectedIndex -eq -1)   { $CurrentGameComboBox.SelectedIndex = 0 }

}



#==============================================================================================================================================================================================
function ChangePatchPanel() {
    
    # Reset
    $PatchGroup.text = $GameType.mode + " - Patch Options"
    $PatchComboBox.Items.Clear()

    # Set combobox for patches
    $Items = @()
    foreach ($i in $PatchesJSONFile.patch) {
        if ( ($IsWiiVC -and $i.console -eq "Wii VC") -or (!$IsWiiVC -and $i.console -eq "N64") -or ($i.console -eq "All") ) {
            $Items += $i.title
            if (!(IsSet -Elem $FirstItem)) { $FirstItem = $i }
        }
        $global:ToolTip.SetToolTip($PatchButton, ([String]::Format($FirstItem.tooltip, [Environment]::NewLine)))
    }

    $PatchComboBox.Items.AddRange($Items)

    # Reset last index
    For ($i=0; $i -lt $Items.Length; $i++) {
        Foreach ($Item in $PatchesJSONFile.patch) {
            if ($Item.title -eq $GamePatch.title -and $Item.title -eq $Items[$i]) { $PatchComboBox.SelectedIndex = $i }
        }
    }
    if ($Items.Length -gt 0 -and $PatchComboBox.SelectedIndex -eq -1)   { $PatchComboBox.SelectedIndex = 0 }

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
    
     Foreach ($Item in $GamesJSONFile.game) {
        if ($Item.title -eq $CurrentGameComboBox.text) { $global:GameType = $Item }
    }

    $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $False
    $PatchVCRemoveFilterLabel.Visible = $PatchVCRemoveFilter.Visible = $False
    $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $False
    $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $False
    
    $PatchVCMinimapLabel.Hide()
    $PatchVCRemapCDown.Visible = $PatchVCRemapCDownLabel.Visible = $False
    $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $False
    $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $False

    if ($GameType.patches) {
        if (Test-Path -LiteralPath ($Paths.Master + "\" + $GameType.mode + "\Patches.json")) {
            try { $global:PatchesJSONFile = Get-Content -Raw -Path ($Paths.Master + "\" + $GameType.mode + "\Patches.json") | ConvertFrom-Json }
           catch { CreateErrorDialog -Error "Corrupted JSON" }
        }
        else { CreateErrorDialog -Error "Missing JSON" }
    }

    # Info
    if (Test-Path -LiteralPath ($Paths.Info + "\" + $GameType.mode + ".txt") -PathType Leaf)      { AddTextFileToTextbox -TextBox $InfoTextbox -File ($Paths.Info + "\" + $GameType.mode + ".txt") }
    else                                                                                          { AddTextFileToTextbox -TextBox $InfoTextbox -File $null }
    if (Test-Path -LiteralPath ($Paths.Icons + "\" + $GameType.mode + ".ico") -PathType Leaf)     { $InfoDialog.Icon = $OptionsDialog.Icon = $LanguagesDialog.Icon = $Paths.Icons + "\" + $GameType.mode + ".ico" }
    else                                                                                          { $InfoDialog.Icon = $OptionsDialog.Icon = $LanguagesDialog.Icon = $null }

    # Credits
    if (Test-Path -LiteralPath ($Paths.Credits + "\Common.txt") -PathType Leaf)                   { AddTextFileToTextbox -TextBox $CreditsTextBox -File ($Paths.Credits + "\Common.txt") }
    if (Test-Path -LiteralPath ($Paths.Credits + "\" + $GameType.mode + ".txt") -PathType Leaf)   { AddTextFileToTextbox -TextBox $CreditsTextBox -File ($Paths.Credits + "\" + $GameType.mode + ".txt") -Add $True -PreSpace 2 }

    $global:ToolTip.SetToolTip($InfoButton, "Open the list with information about the " + $GameType.mode + " patching mode")
    $InfoButton.Text = "Info`n" + $GameType.mode
    $CreditsButton.Text = "Credits`n" + $GameType.mode

    $PatchPanel.Visible = $GameType.patches

    if ($GameType.mode -eq "Ocarina of Time")      { CreateOoTOptionsContent }
    elseif ($GameType.mode -eq "Majora's Mask")    { CreateMMOptionsContent }
    elseif ($GameType.mode -eq "Super Mario 64")   { CreateSM64OptionsContent }

    $OptionsLabel.text = $GameType.mode + " - Additional Options"
    $LanguagesLabel.text = $GameType.mode + " - Languages"

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

    SetWiiVCMode -Bool $IsWiiVC
    $PatchVCButton.Enabled = CheckVCOptions
    
}



#==============================================================================================================================================================================================
function UpdateStatusLabel([String]$Text) {
    
    $StatusLabel.Text = $Text
    $StatusLabel.Refresh()

}



#==============================================================================================================================================================================================
function SetWiiVCMode([Boolean]$Bool) {
    
    $InjectROMButton.Visible = $PatchVCPanel.Visible = $Bool

    $global:IsWiiVC = $Bool
    if ($Bool)   {
        EnablePatchButtons -Enable ($WADFilePath -ne $null)
        $InputCustomTitleTextBox.Text = $GameType.wii_title
        $InputCustomGameIDTextBox.Text =  $Gametype.wii_gameID
    }
    else {
        EnablePatchButtons -Enable ($Z64FilePath -ne $null)
        $InputCustomTitleTextBox.Text = $Gametype.n64_title
        $InputCustomGameIDTextBox.Text =  $Gametype.n64_gameID
    }
    
    $InputCustomTitleTextBox.MaxLength = $GameTitleLength[[uint32]$IsWiiVC]
    $ClearWADPathButton.Enabled = ($WADFilePath.Length -gt 0)

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

    if (IsChecked -Elem $PatchVCRemoveT64 -Visible $True)      { return $True }
    if (IsChecked -Elem $PatchVCExpandMemory -Visible $True)   { return $True }
    if (IsChecked -Elem $PatchVCRemoveFilter -Visible $True)   { return $True }
    if (IsChecked -Elem $PatchVCRemapDPad -Visible $True)      { return $True }
    if (IsChecked -Elem $PatchVCDowngrade -Visible $True)      { return $True }
    if (IsChecked -Elem $PatchVCRemapCDown -Visible $True)     { return $True }
    if (IsChecked -Elem $PatchVCRemapZ -Visible $True)         { return $True }
    if (IsChecked -Elem $PatchLeaveDPadUp -Visible $True)      { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsChecked([Object]$Elem, [Boolean]$Visible, [Boolean]$Enabled) {
    
    if ($Visible -and !$Elem.Visible)   { return $False }
    if ($Enabled -and !$Elem.Enabled)   { return $False }
    if ($Elem.Checked)                  { return $True }
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

    # Label
    $global:LanguagesLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $LanguagesDialog

    # Box
    $global:LanguagesBox = CreateGroupBox -X 10 -Y 10 -Width ($LanguagesDialog.Width - 40) -Text "Languages" -AddTo $LanguagesDialog

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

        $Button = CreateCheckbox -X $X -Y ($Row  * 30 + 30) -IsRadio $True -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -AddTo $LanguagesBox
        $Label = CreateLabel -X $Button.Right -Y ($Button.Top + 3) -Width 70 -Height 15 -Text $GamePatch.languages[$i].title -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -AddTo $LanguagesBox
    }
    
    $LanguagesBox.Controls[0].Checked = $True

}



#==============================================================================================================================================================================================
function CreateOptionsDialog() {

    # Create Dialog
    $global:OptionsDialog = CreateDialog -Width 700 -Height 580
    $CloseButton = CreateButton -X ($OptionsDialog.Width / 2 - 40) -Y ($OptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OptionsDialog
    $CloseButton.Add_Click({$OptionsDialog.Hide()})

    # Options Label
    $global:OptionsLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $OptionsDialog

    $global:Options = @{}

    $PatchReduxCheckbox.Add_CheckStateChanged({
        
        if ($GameType.mode -eq "Ocarina of Time") {
            $Options.HideDPad.Enabled = $PatchReduxCheckbox.Checked
        }

        elseif ($GameType.mode -eq "Majora's Mask") {
            $Options.LeftDPad.Enabled = $PatchReduxCheckbox.Checked
            $Options.RightDPad.Enabled = $PatchReduxCheckbox.Checked
            $Options.HideDPad.Enabled = $PatchReduxCheckbox.Checked
        }

        elseif ($GameType.mode -eq "Super Mario 64") {
        }

        
    })

}



#==============================================================================================================================================================================================
function CreateOptionsContent() {
    
    if (IsSet -Elem $Options.panel) {
        $OptionsDialog.Controls.Remove($Options.panel)
    }

    $global:Options = @{}
    $Options.Panel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog

}




#==============================================================================================================================================================================================
function CreateOoTOptionsContent() {
    
    CreateOptionsContent

    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 3 -Dialog $Options.Panel -Text "Hero Mode"

    # Damage
    $DamagePanel                       = CreateReduxPanel -Row 0 -Group $HeroModeBox
    $Options.Damage1x                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanel -Checked $True -Text "1x Damage" -ToolTip $ToolTip -Info "Enemies deal normal damage"
    $Options.Damage2x                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanel                -Text "2x Damage" -ToolTip $ToolTip -Info "Enemies deal twice as much damage"
    $Options.Damage4x                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanel                -Text "4x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"
    $Options.Damage8x                  = CreateReduxRadioButton -Column 3 -Row 0 -Panel $DamagePanel                -Text "8x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"

    # Recovery
    $RecoveryPanel                     = CreateReduxPanel -Row 1 -Group $HeroModeBox
    $Options.NormalRecovery            = CreateReduxRadioButton -Column 0 -Row 0 -Panel $RecoveryPanel -Checked $True -Text "1x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $Options.HalfRecover               = CreateReduxRadioButton -Column 1 -Row 0 -Panel $RecoveryPanel                -Text "1/2x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $Options.QuarterRecover            = CreateReduxRadioButton -Column 2 -Row 0 -Panel $RecoveryPanel                -Text "1/4x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $Options.NoRecover                 = CreateReduxRadioButton -Column 3 -Row 0 -Panel $RecoveryPanel                -Text "0x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts will not restore Link's health anymore"
    
    # Boss HP
  # $BossHPPanel                       = CreateReduxPanel -Row 2 -Group $HeroModeBox
  # $Options.BossHP1x                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $BossHPPanel -Checked $True -Text "1x Boss HP" -ToolTip $ToolTip -Info "Bosses have normal hit points" 
  # $Options.BossHP2x                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $BossHPPanel                -Text "2x Boss HP" -ToolTip $ToolTip -Info "Bosses have double as much hit points"
  # $Options.BossHP3x                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $BossHPPanel                -Text "3x Boss HP" -ToolTip $ToolTip -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $Options.OHKOMode                  = CreateReduxCheckbox -Column 0 -Row 3 -Group $HeroModeBox -Text "OHKO Mode" -ToolTip $ToolTip -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"
    


    # TEXT SPEED #
    $TextBox                           = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -Dialog $Options.Panel -Text "Text Dialogue Speed"
    
    $TextPanel                         = CreateReduxPanel -Row 0 -Group $TextBox
    $Options.Text1x                    = CreateReduxRadioButton -Column 0 -Row 0 -Panel $TextPanel -Checked $True -Text "1x Speed" -ToolTip $ToolTip -Info "Leave the dialogue text speed at normal"
    $Options.Text2x                    = CreateReduxRadioButton -Column 1 -Row 0 -Panel $TextPanel                -Text "2x Speed" -ToolTip $ToolTip -Info "Set the dialogue text speed to be twice as fast"
    $Options.Text3x                    = CreateReduxRadioButton -Column 2 -Row 0 -Panel $TextPanel                -Text "3x Speed" -ToolTip $ToolTip -Info "Set the dialogue text speed to be three times as fast"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($TextBox.Bottom + 5) -Height 2 -Dialog $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBox -Text "16:9 Widescreen"        -ToolTip $ToolTip -Info "Native 16:9 widescreen display support"
    $Options.WidescreenTextures        = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBox -Text "16:9 Textures"          -ToolTip $ToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support"
    $Options.ExtendedDraw              = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBox -Text "Extended Draw Distance" -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $Options.BlackBars                 = CreateReduxCheckbox -Column 3 -Row 1 -Group $GraphicsBox -Text "No Black Bars"          -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $Options.ForceHiresModel           = CreateReduxCheckbox -Column 0 -Row 2 -Group $GraphicsBox -Text "Force Hires Link Model" -ToolTip $ToolTip -Info "Always use Link's High Resolution Model when Link is too far away"
    $Options.MMModels                  = CreateReduxCheckbox -Column 1 -Row 2 -Group $GraphicsBox -Text "Replace Link's Models"  -ToolTip $ToolTip -Info "Replaces Link's models to be styled towards Majora's Mask"
    $Options.CorrectRupeeColors        = CreateReduxCheckbox -Column 2 -Row 2 -Group $GraphicsBox -Text "Correct Rupee Colors"   -ToolTip $ToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"



    # EQUIPMENT #
    $EquipmentBox                      = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 2 -Dialog $Options.Panel -Text "Equipment"
    
    $ItemCapacityPanel                 = CreateReduxPanel -Row 0 -Group $EquipmentBox
    $Options.ReducedItemCapacity       = CreateReduxRadioButton -Column 0 -Row 0 -Panel $ItemCapacityPanel                -Text "Reduced Item Capacity"   -ToolTip $ToolTip -Info "Decrease the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $Options.NormalItemCapacity        = CreateReduxRadioButton -Column 1 -Row 0 -Panel $ItemCapacityPanel -Checked $True -Text "Normal Item Capacity"    -ToolTip $ToolTip -Info "Keep the normal amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $Options.IncreasedItemCapacity     = CreateReduxRadioButton -Column 2 -Row 0 -Panel $ItemCapacityPanel                -Text "Increased Item Capacity" -ToolTip $ToolTip -Info "Increase the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"

    $Options.UnlockSword               = CreateReduxCheckbox -Column 0 -Row 2 -Group $EquipmentBox -Text "Unlock Kokiri Sword" -ToolTip $ToolTip -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword"
    $Options.UnlockTunics              = CreateReduxCheckbox -Column 1 -Row 2 -Group $EquipmentBox -Text "Unlock Tunics"       -ToolTip $ToolTip -Info "Child Link is able to use the Goron TUnic and Zora Tunic`nSince you might want to walk around in style as well when you are young"
    $Options.UnlockBoots               = CreateReduxCheckbox -Column 2 -Row 2 -Group $EquipmentBox -Text "Unlock Boots"        -ToolTip $ToolTip -Info "Child Link is able to use the Iron Boots and Hover Boots"



    # EVERYTHING ELSE #
    $OtherBox                          = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 2 -Dialog $Options.Panel -Text "Other"

    $Options.DisableLowHPSound         = CreateReduxCheckbox -Column 0 -Row 1 -Group $OtherBox -Text "Disable Low HP Beep"             -ToolTip $ToolTip -Info "There will be absolute silence when Link's HP is getting low"
    $Options.Medallions                = CreateReduxCheckbox -Column 1 -Row 1 -Group $OtherBox -Text "Require All Medallions"          -ToolTip $ToolTip -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`The vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows"
    $Options.ReturnChild               = CreateReduxCheckbox -Column 2 -Row 1 -Group $OtherBox -Text "Can Always Return"               -ToolTip $ToolTip -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"
    $Options.DisableNavi               = CreateReduxCheckbox -Column 3 -Row 1 -Group $OtherBox -Text "Remove Navi Prompts"             -ToolTip $ToolTip -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes"
    $Options.HideDPad                  = CreateReduxCheckbox -Column 0 -Row 2 -Group $OtherBox -Text "Hide D-Pad Icon" -Disable $True -ToolTip $ToolTip -Info "Hide the D-Pad icon, while it is still active"

}



#==============================================================================================================================================================================================
function CreateMMOptionsContent() {
    
    CreateOptionsContent

    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 3 -Dialog $Options.Panel -Text "Hero Mode"

    # Damage
    $DamagePanel                       = CreateReduxPanel -Row 0 -Group $HeroModeBox
    $Options.Damage1x                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanel -Checked $True -Text "1x Damage" -ToolTip $ToolTip -Info "Enemies deal normal damage"
    $Options.Damage2x                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanel                -Text "2x Damage" -ToolTip $ToolTip -Info "Enemies deal twice as much damage"
    $Options.Damage4x                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanel                -Text "4x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"
    $Options.Damage8x                  = CreateReduxRadioButton -Column 3 -Row 0 -Panel $DamagePanel                -Text "8x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"

    # Recovery
    $RecoveryPanel                     = CreateReduxPanel -Row 1 -Group $HeroModeBox
    $Options.NormalRecovery            = CreateReduxRadioButton -Column 0 -Row 0 -Panel $RecoveryPanel -Checked $True -Text "1x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $Options.HalfRecovery              = CreateReduxRadioButton -Column 1 -Row 0 -Panel $RecoveryPanel                -Text "1/2x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $Options.QuarterRecovery           = CreateReduxRadioButton -Column 2 -Row 0 -Panel $RecoveryPanel                -Text "1/4x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $Options.NoRecovery                = CreateReduxRadioButton -Column 3 -Row 0 -Panel $RecoveryPanel                -Text "0x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $BossHPPanel                       = CreateReduxPanel -Row 2 -Group $HeroModeBox
  # $Options.BossHP1x                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $BossHPPanel -Checked $True -Text "1x Boss HP" -ToolTip $ToolTip -Info "Bosses have normal hit points" 
  # $Options.BossHP2x                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $BossHPPanel                -Text "2x Boss HP" -ToolTip $ToolTip -Info "Bosses have double as much hit points"
  # $Options.BossHP3x                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $BossHPPanel                -Text "3x Boss HP" -ToolTip $ToolTip -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $Options.OHKOMode                  = CreateReduxCheckbox -Column 0 -Row 3 -Group $HeroModeBox -Text "OHKO Mode" -ToolTip $ToolTip -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # D-PAD #
    $DPadBox                           = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -Dialog $Options.Panel -Text "D-Pad Icons Layout"
    
    $DPadPanel                         = CreateReduxPanel -Row 0 -Group $DPadBox
    $Options.LeftDPad                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DPadPanel                -Disable $True -Text "Left Side" -ToolTip $ToolTip -Info "Show the D-Pad icons on the left side of the HUD"
    $Options.RightDPad                 = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DPadPanel -Checked $True -Disable $True -Text "Right Side" -ToolTip $ToolTip -Info "Show the D-Pad icons on the right side of the HUD"
    $Options.HideDPad                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DPadPanel                -Disable $True -Text "Hidden" -ToolTip $ToolTip -Info "Hide the D-Pad icons, while they are still active"
    
    
   
    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($DPadBox.Bottom + 5) -Height 2 -Dialog $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBox -Text "16:9 Widescreen"         -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support"
    $Options.WidescreenTextures        = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBox -Text "16:9 Textures"           -ToolTip $ToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support"
    $Options.ExtendedDraw              = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBox -Text "Extended Draw Distance"  -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $Options.BlackBars                 = CreateReduxCheckbox -Column 3 -Row 1 -Group $GraphicsBox -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $Options.PixelatedStars            = CreateReduxCheckbox -Column 0 -Row 2 -Group $GraphicsBox -Text "Disable Pixelated Stars" -ToolTip $ToolTip -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement"
    $Options.CorrectRupeeColors        = CreateReduxCheckbox -Column 1 -Row 2 -Group $GraphicsBox -Text "Correct Rupee Colors"   -ToolTip $ToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"
    


    # EQUIPMENT #
    $EquipmentBox                     = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 2 -Dialog $Options.Panel -Text "Equipment"
    
    $ItemCapacityPanel                = CreateReduxPanel -Row 0 -Group $EquipmentBox
    $Options.ReducedItemCapacity      = CreateReduxRadioButton -Column 0 -Row 0 -Panel $ItemCapacityPanel                -Text "Reduced Item Capacity"   -ToolTip $ToolTip -Info "Decrease the amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $Options.NormalItemCapacity       = CreateReduxRadioButton -Column 1 -Row 0 -Panel $ItemCapacityPanel -Checked $True -Text "Normal Item Capacity"    -ToolTip $ToolTip -Info "Keep the normal amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $Options.IncreasedItemCapacity    = CreateReduxRadioButton -Column 2 -Row 0 -Panel $ItemCapacityPanel                -Text "Increased Item Capacity" -ToolTip $ToolTip -Info "Increase the amount of deku sticks, deku nuts, bombs and arrows you can carry"

    $Options.RazorSword               = CreateReduxCheckbox -Column 0 -Row 2 -Group $EquipmentBox -Text "Permanent Razor Sword" -ToolTip $ToolTip -Info "The Razor Sword won't get destroyed after 100 it`nYou can also keep the Razor Sword when traveling back in time"



    # EVERYTHING ELSE #
    $OtherBox                         = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 1 -Dialog $Options.Panel -Text "Other"

    $Options.DisableLowHPSound        = CreateReduxCheckbox -Column 0 -Row 1 -Group $OtherBox -Text "Disable Low HP Beep"      -ToolTip $ToolTip -Info "There will be absolute silence when Link's HP is getting low"
    $Options.PieceOfHeartSound        = CreateReduxCheckbox -Column 1 -Row 1 -Group $OtherBox -Text "4th Piece of Heart Sound" -ToolTip $ToolTip -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container"

    $Options.FixGothCutscene          = CreateReduxCheckbox -Column 2 -Row 1 -Group $OtherBox -Text "Fix Goth Cutscene"        -ToolTip $ToolTip -Info "Fix Goht's awakening cutscene so that Link no longer gets run over"
    $Options.MoveBomberKid            = CreateReduxCheckbox -Column 3 -Row 1 -Group $OtherBox -Text "Move Bomber Kid"          -ToolTip $ToolTip -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"

}



#==============================================================================================================================================================================================
function CreateSM64OptionsContent() {
    
    CreateOptionsContent

     # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -Dialog $Options.Panel -Text "Hero Mode"
    
    # Damage
    $DamagePanel                       = CreateReduxPanel -Row 0 -Group $HeroModeBox
    $Options.Damage1x                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanel -Checked $True -Text "1x Damage" -ToolTip $ToolTip -Info "Enemies deal normal damage"
    $Options.Damage2x                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanel                -Text "2x Damage" -ToolTip $ToolTip -Info "Enemies deal twice as much damage"
    $Options.Damage3x                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanel                -Text "3x Damage" -ToolTip $ToolTip -Info "Enemies deal trice as much damage"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -Dialog $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBox -Text "16:9 Widescreen"         -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support"
    $Options.ForceHiresModel           = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBox -Text "Force Hires Mario Model" -ToolTip $ToolTip -Info "Always use Mario's High Resolution Model when Mario is too far away"
    $Options.BlackBars                 = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBox -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen"
    


    # GRAPHICS #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -Dialog $Options.Panel -Text "Gameplay"

    $Options.FPS                       = CreateReduxCheckbox -Column 0 -Row 1 -Group $GameplayBox -Text "60 FPS"        -ToolTip $ToolTip -Info "Increases the FPS from 30 to 60`nWitness Super Mario 64 in glorious 60 FPS"
    $Options.FreeCam                   = CreateReduxCheckbox -Column 1 -Row 1 -Group $GameplayBox -Text "Analog Camera" -ToolTip $ToolTip -Info "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Left / Right for the Analog stick"
    $Options.LagFix                    = CreateReduxCheckbox -Column 2 -Row 1 -Group $GameplayBox -Text "Lag Fix"       -ToolTip $ToolTip -Info "Smoothens gameplay by reducing lag"



    $Options.FPS.Add_CheckStateChanged({ Write-Host "TRUE!"; $Options.FreeCam.Enabled = !$Options.FPS.Checked })
    $Options.FreeCam.Add_CheckStateChanged({ $Options.FPS.Enabled = !$Options.FreeCam.Checked })

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
    $global:InfoGameIDDialog = CreateDialog -Width 500 -Height 500 -Icon $Icons.CheckGameID
    $CloseButton = CreateButton -X ($InfoGameIDDialog.Width / 2 - 40) -Y ($InfoGameIDDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoGameIDDialog
    $CloseButton.Add_Click({$InfoGameIDDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoGameIDDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoGameIDDialog

    $HashSumROMLabel = CreateLabel -X 40 -Y 55 -Width 120 -Height 15 -Font $VCPatchFont -Text "N64 ROM Hashsum:" -AddTo $InfoGameIDDialog
    $global:HashSumROMTextBox = CreateTextBox -X $HashSumROMLabel.Right -Y ($HashSumROMLabel.Top - 3) -Width ($InfoGameIDDialog.Width -$HashSumROMLabel.Width - 100) -Height 50 -AddTo $InfoGameIDDialog
    $HashSumROMTextBox.ReadOnly = $True

    # Create textbox
    $TextBox = CreateTextBox -X 40 -Y ($HashSumROMTextBox.Bottom + 10) -Width ($InfoGameIDDialog.Width - 100) -Height ($CloseButton.Top - 100) -ReadOnly $True -AddTo $InfoGameIDDialog
    AddTextFileToTextbox -TextBox $Textbox -File $Files.text_gameID

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 500 -Height 500 -Icon $Icons.Credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({$CreditsDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create textbox
    $global:CreditsTextBox = CreateTextBox -X 40 -Y 50 -Width ($CreditsDialog.Width - 100) -Height ($CloseButton.Top - 60) -ReadOnly $True -AddTo $CreditsDialog

}



#==============================================================================================================================================================================================
function CreateInfoDialog() {
    
    # Create Dialog
    $global:InfoDialog = CreateDialog -Width 500 -Height 500 -Icon $Icon
    $CloseButton = CreateButton -X ($InfoDialog.Width / 2 - 40) -Y ($InfoDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoDialog
    $CloseButton.Add_Click({$InfoDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoDialog

    # Create textbox
    $global:InfoTextBox = CreateTextBox -X 40 -Y 50 -Width ($InfoDialog.Width - 100) -Height ($CloseButton.Top - 60) -ReadOnly $True -AddTo $InfoDialog
    
}



#==============================================================================================================================================================================================
function AddTextFileToTextbox([Object]$TextBox, [String]$File, [Boolean]$Add, [int]$PreSpace, [int]$PostSpace) {
    
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
function CreateErrorDialog([String]$Error, [Boolean]$Exit) {
    
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
function CreateTextBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Boolean]$ReadOnly, [String]$Text, [Object]$AddTo) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    if ($Text -ne $null) { $TextBox.Text = $Text }

    if ($ReadOnly) {
        $TextBox.Multiline = $True
        $TextBox.ReadOnly = $True
        $TextBox.Scrollbars = 'Vertical'
        $TextBox.Cursor = 'Default'
        $TextBox.ShortcutsEnabled = $False
        $TextBox.TabStop = $False
        $TextBox.WordWrap = $False
    }
    
    $TextBox.Add_Click({ $this.SelectionLength = 0 })

    return $TextBox

}



#==============================================================================================================================================================================================
function CreateComboBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Object]$Items, [Object]$AddTo) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo

    if ($Items -ne $null) {
        $ComboBox.Items.AddRange($Items)
        $ComboBox.SelectedIndex = 0
    }
    $ComboBox.DropDownStyle = "DropDownList"

    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateCheckbox([int]$X, [int]$Y, [String]$Name, [Boolean]$Checked, [Boolean]$Disable, [Boolean]$IsRadio, [Object]$Tooltip, [String]$Info, [Object]$AddTo) {
    
    if ($IsRadio)             { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else                      { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    if ($Tooltip -ne $null)   { $ToolTip.SetToolTip($Checkbox, $Info) }
    $Checkbox.Checked = $Checked
    $Checkbox.Enabled = !$Disable
    return $Checkbox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X, [int]$Y, [String]$Name, [int]$Width, [int]$Height, [String]$Text, [Object]$Font, [Object]$Tooltip, [String]$Info, [Object]$AddTo) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if ($Text -ne $null)      { $Label.Text = $Text }
    if ($Font -ne $null)      { $Label.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Label, $Info) }
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X, [int]$Y, [String]$Name, [int]$Width, [int]$Height, [String]$Text, [Object]$Tooltip, [String]$Info, [Object]$AddTo) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if ($Text -ne $null)      { $Button.Text = $Text }
    if ($Font -ne $null)      { $Button.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Button, $Info) }

    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxGroup([int]$Y, [int]$Height, [Object]$Dialog, [String]$Text)   { return CreateGroupBox -X 15 -Y $Y -Width ($Dialog.Width - 50) -Height ($Height * 30 + 20) -Text $Text -AddTo $Dialog }
function CreateReduxPanel([int]$Row, [Object]$Group)                               { return CreatePanel -X $Group.Left -Y ($Row * 30 + 20) -Width ($Group.Width - 20) -Height 20 -AddTo $Group }



#==============================================================================================================================================================================================
function CreateReduxRadioButton([int]$Column, [int]$Row, [Object]$Panel, [Boolean]$Checked, [Boolean]$Disable, [String]$Text, [Object]$Tooltip, [String]$Info) {
    
    $Button = CreateCheckbox -X ($Column * 155) -Y ($Row * 30) -Checked $Checked -Disable $Disable -IsRadio $True -ToolTip $ToolTip -Info $Info -AddTo $Panel
    $Label = CreateLabel -X $Button.Right -Y ($Button.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $Panel
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxCheckbox([int]$Column, [int]$Row, [Object]$Group, [Boolean]$Checked, [Boolean]$Disable, [String]$Text, [Object]$Tooltip, [String]$Info) {
    
    $Checkbox = CreateCheckbox -X ($Column * 155 + 15) -Y ($Row * 30 - 10) -Checked $False -Disable $Disable -IsRadio $False -ToolTip $ToolTip -Info $Info -AddTo $Group
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $Group

    return $CheckBox

}



#==============================================================================================================================================================================================
function StrLike([String]$str, [String]$val) {
    
    if ($str.ToLower() -like "*" + $val + "*") { return $True }
    return $False

}



#==============================================================================================================================================================================================

# Hide the PowerShell console from the user.
ShowPowerShellConsole -ShowConsole $False

# Find icons
$global:Icons = SetIconParameters

# Set paths to all the files stored in the script.
$global:Files = SetFileParameters

# Create the dialogs to show to the user.
CreateMainDialog
CreateOptionsDialog
CreateLanguagesDialog
CreateInfoGameIDDialog
CreateInfoDialog
CreateCreditsDialog

# Set default game mode.
ChangeGamesList

# Disable patching buttons.
EnablePatchButtons -Enable $False

# Show the dialog to the user.
$MainDialog.ShowDialog() | Out-Null

Exit