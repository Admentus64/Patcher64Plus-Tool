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

$global:VersionDate = "28-06-2020"
$global:Version     = "v5.3"

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
            if ($LanguageBox.Controls[$i*2].checked) { $Item = $i }
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
    #$MainDialog.Enabled = $StatusPanel.Enabled = $True

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
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x2EB0" -Values @("0x60", "0x00", "0x00", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x5BF44" -Values @("0x3C", "0x80", "0x72", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x5BFD7" -Values @("0x00")
        }

        if ($PatchVCRemapDPad.Checked) {
            if (!$PatchVCLeaveDPadUp.Checked) { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x16BAF0" -Values @("0x08", "0x00") }
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x16BAF4" -Values @("0x04", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x16BAF8" -Values @("0x02", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x16BAFC" -Values @("0x01", "0x00")
        }

        if ($PatchVCRemapCDown.Checked)         { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x16BB04" -Values @("0x00", "0x20") }
        if ($PatchVCRemapZ.Checked)             { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x16BAD8" -Values @("0x00", "0x20") }

    }

    elseif ($GameType.mode -eq "Majora's Mask") {
        
        if ($PatchVCExpandMemory.Checked -or $PatchVCRemapDPad.Checked -or $PatchVCRemapCDown.Checked -or $PatchVCRemapZ.Checked) { & $Files.lzss -d $WADFile.AppFile01 | Out-Host }

        if ($PatchVCExpandMemory.Checked) {
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x10B58" -Values @("0x3C", "0x80", "0x00", "0xC0")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x4BD20" -Values @("0x67", "0xE4", "0x70", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x4BC80" -Values @("0x3C", "0xA0", "0x01", "0x00")
        }

        if ($PatchVCRemapDPad.Checked) {
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x148514" -Values @("0x08", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x148518" -Values @("0x04", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x14851C" -Values @("0x02", "0x00")
            PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x148520" -Values @("0x01", "0x00")
        }

        if ($PatchVCRemapCDown.Checked)         { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x148528" -Values @("0x00", "0x20") }
        if ($PatchVCRemapZ.Checked)             { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x1484F8" -Values @("0x00", "0x20") }

        if ($PatchVCExpandMemory.Checked -or $PatchVCRemapDPad.Checked -or $PatchVCRemapCDown.Checked -or $PatchVCRemapZ.Checked) { & $Files.lzss -evn $WADFile.AppFile01 | Out-Host }

    }

    elseif ($GameType.mode -eq "Super Mario 64") {
        
        if ($PatchVCRemoveFilter.Checked -and (StrLike -str $Command -val "Multiplayer") )   { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x53124" -Values @("0x60", "0x00", "0x00", "0x00") }
        elseif ($PatchVCRemoveFilter.Checked)                                                { PatchBytesSequence -File $WadFile.AppFile01 -Offset "0x46210" -Values @("0x4E", "0x80", "0x00", "0x20") }

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
function PatchBytesSequence([String]$File, [int]$Offset, $Values, [int]$Increment, [Boolean]$IsDec) {
    
    $ByteArray = [IO.File]::ReadAllBytes($File)

    if (!(IsSet -Elem $Increment -Min 1)) { $Increment = 1 }

    for ($i=0; $i -lt $Values.Length; $i++) {
        if ($IsDec)   { $ByteArray[(GetDecimal -Hex ($Offset + ($i * $Increment)))] = $Values[$i] }
        else          { $ByteArray[(GetDecimal -Hex ($Offset + ($i * $Increment)))] = (GetDecimal -Hex $Values[$i]) }  
    }

    [io.file]::WriteAllBytes($File, $ByteArray)
    $ByteArray = $null

}



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

    # BPS PATCHING OPTIONS #
    if ( (IsChecked $PatchOptionsCheckbox -Visible $True) -and $GamePatch.options) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")

        if ($GameType.mode -eq "Ocarina of Time") {
            if (IsChecked -Elem $MMModelsOoT -Enabled $True) {
                if (IsChecked $PatchReduxCheckbox -Visible $True)               { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_oot_models_mm_redux }
                else                                                            { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_oot_models_mm }
            }
            if (IsChecked -Elem $WidescreenTexturesOoT -Enabled $True)          { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_oot_widescreen_textures }

            PatchOptionsOoT # BYTE PATCHING
        }

        elseif ($GameType.mode -eq "Majora's Mask") {
            if (IsChecked -Elem $WidescreenTexturesMM -Enabled $True)           { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_mm_widescreen_textures }

            PatchOptionsMM # BYTE PATCHING
        }
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

    if (IsChecked -Elem $OHKOModeOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8073" -Values @("0x09", "0x04") -Increment 16
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x82", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x00", "0x00", "0x00")
    }
    elseif (!(IsChecked -Elem $1xDamageOoT -Enabled $True) -and !(IsChecked -Elem $NormalRecoveryOoT -Enabled $True)) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8073" -Values @("0x09", "0x04") -Increment 16
        if (IsChecked -Elem $NormalRecoveryOoT -Enabled $True) {                
            if (IsChecked -Elem $2xDamageOoT -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x40") }
            elseif (IsChecked -Elem $4xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x80") }
            elseif (IsChecked -Elem $8xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0xC0") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x00", "0x00", "0x00")
        }
        elseif (IsChecked -Elem $HalfRecoveryOoT -Enabled $True) {               
            if (IsChecked -Elem $1xDamageOoT -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x40") }
            elseif (IsChecked -Elem $2xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x80") }
            elseif (IsChecked -Elem $4xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0xC0") }
            elseif (IsChecked -Elem $8xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x10", "0x80", "0x43")
        }
        elseif (IsChecked -Elem $QuarterRecoveryOoT -Enabled $True) {                
            if (IsChecked -Elem $1xDamageOoT -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x80") }
            elseif (IsChecked -Elem $2xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0xC0") }
            elseif (IsChecked -Elem $4xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x00") }
            elseif (IsChecked -Elem $8xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x40") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x10", "0x80", "0x83")

        }
        elseif (IsChecked -Elem $NoRecoveryOoT -Enabled $True) {                
            if (IsChecked -Elem $1xDamageOoT -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x40") }
            elseif (IsChecked -Elem $2xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x80") }
            elseif (IsChecked -Elem $4xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0xC0") }
            elseif (IsChecked -Elem $8xDamageOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x82", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x10", "0x81", "0x43")
        }
    }



    # TEXT DIALOGUE SPEED #

    if (IsChecked -Elem $2xTextOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB5006F" -Values @("0x02") }
    elseif (IsChecked -Elem $3xTextOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B6E7" -Values @("0x09", "0x05", "0x40", "0x2E", "0x05", "0x46", "0x01", "0x05", "0x40")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B6F1" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B71E" -Values @("0x09", "0x2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B722" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B74C" -Values @("0x09", "0x21", "0x05", "0x42")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B752" -Values @("0x01", "0x05", "0x40")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B776" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B77A" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7A1" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7A5" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7A8" -Values @("0x1A")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7C9" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7CD" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7F2" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B7F6" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B81C" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B820" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B849" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B84D" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B86D" -Values @("0x09", "0x2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B871" -Values @("0x01") 
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B88F" -Values @("0x09", "0x2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B893" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B8BE" -Values @("0x09", "0x2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B8C2" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B8EF" -Values @("0x09", "0x2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B8F3" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B91A" -Values @("0x09", "0x21")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B91E" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B94E" -Values @("0x09", "0x2E")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B952" -Values @("0x01")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B728" -Values @("0x10")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x93B72A" -Values @("0x01")

        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB5006F" -Values @("0x03")
    }



    # GRAPHICS #

    if (IsChecked -Elem $WideScreenOoT -Enabled $True)        { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB08038" -Values @("0x3C", "0x07", "0x3F", "0xE3") }
    if (IsChecked -Elem $ExtendedDrawOoT -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xA9A970" -Values @("0x00", "0x01") }
    if (IsChecked -Elem $ForceHiresModelOoT -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBE608B" -Values @("0x00") }

    if (IsChecked -Elem $BlackBarsOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F5A4" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F5D4" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F5E4" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F680" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F688" -Values @("0x00", "0x00","0x00", "0x00")
    }


    
    # EQUIPMENT #

    if (IsChecked -Elem $ReducedItemCapacityOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC2F" -Values @("0x14", "0x19", "0x1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC37" -Values @("0x0A", "0x0F", "0x14") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC57" -Values @("0x14", "0x19", "0x1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC5F" -Values @("0x05", "0x0A", "0x0F") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC67" -Values @("0x0A", "0x0F", "0x14") -Increment 2
    }
    elseif (IsChecked -Elem $IncreasedIemCapacityOOT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC2F" -Values @("0x28", "0x46", "0x63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC37" -Values @("0x1E", "0x37", "0x50") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC57" -Values @("0x28", "0x46", "0x63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC5F" -Values @("0x0F", "0x1E", "0x2D") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC67" -Values @("0x1E", "0x37", "0x50") -Increment 2
    }

    if (IsChecked -Elem $UnlockSwordOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77AD" -Values @("0x09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77F7" -Values @("0x09")
    }

    if (IsChecked -Elem $UnlockTunicsOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77B6" -Values @("0x09", "0x09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77FE" -Values @("0x09", "0x09")
    }

    if (IsChecked -Elem $UnlockBootsOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77BA" -Values @("0x09", "0x09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC7801" -Values @("0x09", "0x09")
    }



    # OTHER #

    if (IsChecked -Elem $MedallionsOoT -Enabled $True)            { PatchBytesSequence -File $DecompressedROMFile -Offset "0xE2B454" -Values @("0x80", "0xEA", "0x00", "0xA7", "0x24", "0x01", "0x00", "0x3F", "0x31", "0x4A", "0x00", "0x3F", "0x00", "0x00", "0x00", "0x00") }
    if (IsChecked -Elem $DisableLowHPSoundOoT -Enabled $True)     { PatchBytesSequence -File $DecompressedROMFile -Offset "0xADBA1A" -Values @("0x00", "0x00") }
    if (IsChecked -Elem $DisableNaviooT -Enabled $True)           { PatchBytesSequence -File $DecompressedROMFile -Offset "0xDF8B84" -Values @("0x00", "0x00", "0x00", "0x00") }
    if (IsChecked -Elem $HideDPadOOT -Enabled $True)              { PatchBytesSequence -File $DecompressedROMFile -Offset "0x348086E" -Values @("0x00") }

    if (IsChecked -Elem $ReturnChildOoT -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xCB6844" -Values @("0x35")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x253C0E2" -Values @("0x03")
    }

}



#==============================================================================================================================================================================================
function PatchOptionsMM() {
    
    # HERO MODE #

    if (IsChecked -Elem $OHKOModeMM -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABE7F" -Values @("0x09", "0x04") -Increment 16
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x2A", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x00", "0x00", "0x00")
    }
    elseif (!(IsChecked -Elem $1xDamageMM -Enabled $True) -and !(IsChecked -Elem $NormalRecoveryMM -Enabled $True)) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABE7F" -Values @("0x09", "0x04") -Increment 16
        if (IsChecked -Elem $NormalRecoveryMM -Enabled $True) {
            if (IsChecked -Elem $2xDamageMM -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x40") }
            elseif (IsChecked -Elem $4xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x80") }
            elseif (IsChecked -Elem $8xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0xC0") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x00", "0x00", "0x00")
        }
        elseif (IsChecked -Elem $HalfRecoveryMM -Enabled $True) {
            if (IsChecked -Elem $1xDamageMM -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x40") }
            elseif (IsChecked -Elem $2xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x80") }
            elseif (IsChecked -Elem $4xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0xC0") }
            elseif (IsChecked -Elem $8xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x05", "0x28", "0x43")
        }
        elseif (IsChecked -Elem $QuarterRecoveryMM -Enabled $True) {
            if (IsChecked -Elem $1xDamageMM -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x80") }
            elseif (IsChecked -Elem $2xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0xC0") }
            elseif (IsChecked -Elem $4xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x00") }
            elseif (IsChecked -Elem $8xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x40") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x05", "0x28", "0x83")
        }
        elseif (IsChecked -Elem $NoRecoveryMM -Enabled $True) {
            if (IsChecked -Elem $1xDamageMM -Enabled $True)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x40") }
            elseif (IsChecked -Elem $2xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x80") }
            elseif (IsChecked -Elem $4xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0xC0") }
            elseif (IsChecked -Elem $8xDamageMM -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x2A", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x05", "0x29", "0x43")
        }
    }



    # D-PAD #

    if (IsChecked -Elem $LeftDPadMM -Enabled $True)               { PatchBytesSequence -File $DecompressedROMFile -Offset "0x3806365" -Values @("0x01") }
    elseif (IsChecked -Elem $RightDPadMM -Enabled $True)          { PatchBytesSequence -File $DecompressedROMFile -Offset "0x3806365" -Values @("0x02") }
    elseif (IsChecked -Elem $HideDPadMM -Enabled $True)           { PatchBytesSequence -File $DecompressedROMFile -Offset "0x3806365" -Values @("0x00") }



    # GRAPHICS #

    if (IsChecked -Elem $WideScreenMM -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBD5D74" -Values @("0x3C", "0x07", "0x3F", "0xE3")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xCA58F5" -Values @("0x6C", "0x53", "0x6C", "0x84", "0x9E", "0xB7", "0x53", "0x6C") -Increment 2
    }

    if (IsChecked -Elem $ExtendedDrawMM -Enabled $True)           { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB50874" -Values @("0x00", "0x00", "0x00", "0x00") }
    if (IsChecked -Elem $BlackBarsMM -Enabled $True)              { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBF72A4" -Values @("0x00", "0x00", "0x00", "0x00") }
    if (IsChecked -Elem $PixelatedStarsMM -Enabled $True)         { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB943FC" -Values @("0x10", "0x00") }



    # EQUIPMENT #

    if (IsChecked -Elem $ReducedItemCapacityMM -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile "0xC5834F" -Values @("0x14", "0x19", "0x1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58357" -Values @("0x0A", "0x0F", "0x14") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC5837F" -Values @("0x05", "0x0A", "0x0F") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58387" -Values @("0x0A", "0x0F", "0x14") -Increment 2
    }
    elseif (IsChecked -Elem $IncreasedIemCapacityMM -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile "0xC5834F" -Values @("0x28", "0x46", "0x63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58357" -Values @("0x1E", "0x37", "0x50") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC5837F" -Values @("0x0F", "0x1E", "0x2D") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58387" -Values @("0x1E", "0x37", "0x50") -Increment 2
    }

    if (IsChecked -Elem $RazorSwordMM -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xCBA496" -Values @("0x00", "0x00") # Prevent losing hits
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBDA6B7" -Values @("0x01")         # Keep sword after Song of Time
    }



    # OTHER #
    
    if (IsChecked -Elem $DisableLowHPSoundMM -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB97E2A" -Values @("0x00", "0x00") }
    if (IsChecked -Elem $PieceOfHeartSoundMM -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBA94C8" -Values @("0x10", "0x00") }

}



#==============================================================================================================================================================================================
function PatchOptionsSM64() {
    
    if ( !(IsChecked -Elem $PatchOptionsCheckbox -Visible $True) -or !$GamePatch.options) { return }
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")

    Copy-Item -LiteralPath $ROMFile -Destination $DecompressedROMFile



    # HERO MODE

    if (IsChecked -Elem $2xDamageSM64 -Enabled $True)          { PatchBytesSequence -File $DecompressedROMFile -Offset "0xF207" -Values @("0x80") }
    elseif (IsChecked -Elem $3xDamageSM64 -Enabled $True)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xF207" -Values @("0x40") }



    # GRAPHICS #

    if (IsChecked -Elem $WideScreenSM64 -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x3855E" -Values @("0x47", "0x40")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x35456" -Values @("0x46", "0xC0")
    }

    if (IsChecked -Elem $ForceHiresModelSM64 -Enabled $True)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0x32184" -Values @("0x10", "0x00")}
    
    if (IsChecked -Elem $BlackBarsSM64 -Enabled $True) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x23A7" -Values @("0xBC", "0x00") -Increment 12
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x248E" -Values @("0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0X2966" -Values @("0x00", "00") -Increment 48
        PatchBytesSequence -File $DecompressedROMFile -Offset "0X3646A" -Values @("0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0X364AA" -Values @("0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0X364F6" -Values @("0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0X36582" -Values @("0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0X3799F" -Values @("0xBC", "00") -Increment 12
    }



    # GAMEPLAY #
    if (IsChecked -Elem $60FPSSM64 -Enabled $True)             { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_sm64_fps }
    if (IsChecked -Elem $FreeCamSM64 -Enabled $True)           { ApplyPatch -File $DecompressedROMFile -Patch $Files.bpspatch_sm64_cam }
    if (IsChecked -Elem $LagFixSM64 -Enabled $True)            { PatchBytesSequence -File $DecompressedROMFile -Offset "0xF0022" -Values @("0x0D") }

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
    
    $CompareArray = ($GameType.wii_gameID.ToCharArray() | % { [int][char]$_ })
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

    $CompareArray = $ByteArray[(GetDecimal -Hex "0xF1")..((GetDecimal -Hex "0xF1") + $GameTitleLength[1])]

    # Scan only the contents of the IMET header within the file.
    for ($i=(GetDecimal -Hex "0x80"); $i-lt (GetDecimal -Hex "0x62F"); $i++) {
        $CompareAgainst = $ByteArray[$i..($i + $GameTitleLength[1])]

        $Matches = $True
        for ($j=0; $j -lt $CompareAgainst.Length; $j++) {
            if ($CompareAgainst[$j] -notcontains $CompareArray[$j]) { $Matches = $False }
        }

        if ($Matches -eq $True) {
            for ($j=0; $j-lt $GameTitleLength[1]; $j++) { $ByteArray[$i + ($j*2)] = 0 }
            for ($j=0; $j-lt $Title.Length; $j++) { $ByteArray[$i + ($j*2)] = [int][char]$Title.Substring($j, 1) }
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

    $emptyTitle = foreach ($i in 1..$GameTitleLength[0]) { 32 }
    PatchBytesSequence -File $PatchedROMFile -Offset "0x20" -Values $emptyTitle
    PatchBytesSequence -File $PatchedROMFile -Offset "0x20" -Values ($Title.ToUpper().ToCharArray() | % { [int][char]$_ }) -IsDec $True
    PatchBytesSequence -File $PatchedROMFile -Offset "0x3B" -Values ($GameID.ToCharArray() | % { [int][char]$_ }) -IsDec $True

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
    for ($i = 16 ; $i -le 31 ; $i++) { $AppByteArray[$i] = 0 }

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
function GetDecimal([String]$Hex) {
    
    $decimal = [uint32]$hex
    return $decimal

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
        Foreach ($Item in $PatchesJSONFile.patch) {
            if ($Item.title -eq $PatchComboBox.Text) {
                if ( ($IsWiiVC -and $Item.console -eq "Wii VC") -or (!$IsWiiVC -and $Item.console -eq "N64") -or ($Item.console -eq "All") ) {
                    $global:GamePatch = $Item
                }
            }
            
        }
        DisablePatches
        CreateLanguageContent
    } )

    # Create a checkbox to enable Redux and Options support.
    $global:PatchReduxLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchComboBox.Top + 5) -Width 85 -Height 15 -Text "Enable Redux:" -ToolTip $ToolTip -Info "Enable the Redux patch" -AddTo $PatchGroup
    $global:PatchReduxCheckbox = CreateCheckBox -X $PatchReduxLabel.Right -Y ($PatchReduxLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -AddTo $PatchGroup

    $global:PatchOptionsLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchReduxLabel.Bottom + 15) -Width 85 -Height 15 -Text "Enable Options:" -ToolTip $ToolTip -Info "Enable options" -AddTo $PatchGroup
    $global:PatchOptionsCheckbox = CreateCheckBox -X $PatchOptionsLabel.Right -Y ($PatchOptionsLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable options" -AddTo $PatchGroup
    $PatchOptionsCheckbox.Add_CheckStateChanged({
        $PatchOptionsButton.Enabled = $PatchOptionsCheckbox.Checked
    })

    $global:PatchLanguageButton = CreateButton -X ($PatchOptionsCheckbox.Right + 5) -Y 20 -Width 145 -Height 25 -Text "Select Language" -ToolTip $ToolTip -Info 'Open the "Languages" panel to change the language' -AddTo $PatchGroup
    $PatchLanguageButton.Add_Click( { $LanguageDialog.ShowDialog() } )

    $global:PatchOptionsButton = CreateButton -X $PatchLanguageButton.Left -Y ($PatchLanguageButton.Bottom + 5) -Width $PatchLanguageButton.Width -Height $PatchLanguageButton.Height -Text "Select Options" -ToolTip $ToolTip -Info 'Open the "Additional Options" panel to change preferences' -AddTo $PatchGroup
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
    Foreach ($i in $PatchesJSONFile.patch) {
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
    if (Test-Path -LiteralPath ($Paths.Icons + "\" + $GameType.mode + ".ico") -PathType Leaf)     { $InfoDialog.Icon = $OptionsDialog.Icon = $LanguageDialog.Icon = $Paths.Icons + "\" + $GameType.mode + ".ico" }
    else                                                                                          { $InfoDialog.Icon = $OptionsDialog.Icon = $LanguageDialog.Icon = $null }

    # Credits
    if (Test-Path -LiteralPath ($Paths.Credits + "\Common.txt") -PathType Leaf)                   { AddTextFileToTextbox -TextBox $CreditsTextBox -File ($Paths.Credits + "\Common.txt") }
    if (Test-Path -LiteralPath ($Paths.Credits + "\" + $GameType.mode + ".txt") -PathType Leaf)   { AddTextFileToTextbox -TextBox $CreditsTextBox -File ($Paths.Credits + "\" + $GameType.mode + ".txt") -Add $True -PreSpace 2 }

    $global:ToolTip.SetToolTip($InfoButton, "Open the list with information about the " + $GameType.mode + " patching mode")
    $InfoButton.Text = "Info`n" + $GameType.mode
    $CreditsButton.Text = "Credits`n" + $GameType.mode

    $PatchPanel.Visible = $GameType.patches

    $OoTOptionsPanel.Visible = $MMOptionsPanel.Visible = $SM64OptionsPanel.Visible = $False
    if ($GameType.mode -eq "Ocarina of Time")      { $OoTOptionsPanel.Show() }
    elseif ($GameType.mode -eq "Majora's Mask")    { $MMOptionsPanel.Show() }
    elseif ($GameType.mode -eq "Super Mario 64")   { $SM64OptionsPanel.Show() }

    $OptionsLabel.text = $GameType.mode + " - Additional Options"

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
    
    $InputCustomTitleTextBox.MaxLength = $GameTitleLength[[int]$IsWiiVC]
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
function CreateLanguageDialog() {

    # Create Dialog
    $global:LanguageDialog = CreateDialog -Width 300 -Height 300
    $CloseButton = CreateButton -X ($LanguageDialog.Width / 2 - 40) -Y ($LanguageDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $LanguageDialog
    $CloseButton.Add_Click({$LanguageDialog.Hide()})

    # Create tooltip
    $ToolTip =  

    # Options Label
    $global:LanguageBox = CreateGroupBox -X 10 -Y 10 -Width ($LanguageDialog.Width - 40) -Text "Languages" -AddTo $LanguageDialog
    #$global:LanguageDialog = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $LanguageDialog
    #$global:LanguageBox = CreateReduxGroup -Y 10 -Height ([Math]::Ceiling($GamePatch.languages.Length/2 + 1)) -Dialog $LanguageDialog -Text "Languages"

}



#==============================================================================================================================================================================================
function CreateLanguageContent() {
    
    $PatchLanguageButton.Visible = $GamePatch.languages -ne $null

    if (!(IsSet -Elem $GamePatch.languages -MinLength 0)) { return }

    $LanguageBox.Controls.Clear()
    $LanguageBox.Height = ([Math]::Ceiling($GamePatch.languages.Length/2 + 1)) * 30

    $Row = -1
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        if ($i % 2) { $X = 160 }
        else {
            $X = 20
            $Row += 1
        }

        $Button = CreateCheckbox -X $X -Y ($Row  * 30 + 30) -IsRadio $True -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -AddTo $LanguageBox
        $Label = CreateLabel -X $Button.Right -Y ($Button.Top + 3) -Width 70 -Height 15 -Text $GamePatch.languages[$i].title -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -AddTo $LanguageBox
    }
    
    $LanguageBox.Controls[0].Checked = $True

}



#==============================================================================================================================================================================================
function CreateOptionsDialog() {

    # Create Dialog
    $global:OptionsDialog = CreateDialog -Width 700 -Height 580
    $CloseButton = CreateButton -X ($OptionsDialog.Width / 2 - 40) -Y ($OptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OptionsDialog
    $CloseButton.Add_Click({$OptionsDialog.Hide()})

    # Create tooltip
    $ToolTip = CreateToolTip

    # Options Label
    $global:OptionsLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $OptionsDialog
    
    $global:OoTOptionsPanel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog
    $global:MMOptionsPanel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog
    $global:SM64OptionsPanel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog

    CreateOoTOptionsContent
    CreateMMOptionsContent
    CreateSM64OptionsContent

}




#==============================================================================================================================================================================================
function CreateOoTOptionsContent() {

    # HERO MODE #
    $HeroModeBoxOoT                    = CreateReduxGroup -Y 50 -Height 3 -Dialog $OoTOptionsPanel -Text "Hero Mode"
    
    # Damage
    $DamagePanelOoT                    = CreateReduxPanel -Row 0 -Group $HeroModeBoxOoT 
    $global:1xDamageOoT                = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanelOoT -Checked $True -Text "1x Damage" -ToolTip $ToolTip -Info "Enemies deal normal damage"
    $global:2xDamageOoT                = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanelOoT                -Text "2x Damage" -ToolTip $ToolTip -Info "Enemies deal twice as much damage"
    $global:4xDamageOoT                = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanelOoT                -Text "4x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"
    $global:8xDamageOoT                = CreateReduxRadioButton -Column 3 -Row 0 -Panel $DamagePanelOoT                -Text "8x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"

    # Recovery
    $RecoveryPanelOoT                  = CreateReduxPanel -Row 1 -Group $HeroModeBoxOoT 
    $global:NormalRecoveryOoT          = CreateReduxRadioButton -Column 0 -Row 0 -Panel $RecoveryPanelOoT -Checked $True -Text "1x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $global:HalfRecoveryOoT            = CreateReduxRadioButton -Column 1 -Row 0 -Panel $RecoveryPanelOoT                -Text "1/2x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $global:QuarterRecoveryOoT         = CreateReduxRadioButton -Column 2 -Row 0 -Panel $RecoveryPanelOoT                -Text "1/4x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $global:NoRecoveryOoT              = CreateReduxRadioButton -Column 3 -Row 0 -Panel $RecoveryPanelOoT                -Text "0x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $BossHPPanelOoT                    = CreateReduxPanel -Row 2 -Group $HeroModeBoxOoT 
  # $global:1xBossHPOoT                = CreateReduxRadioButton -Column 0 -Row 0 -Panel $BossHPPanelOoT -Checked $True -Text "1x Boss HP" -ToolTip $ToolTip -Info "Bosses have normal hit points" 
  # $global:2xBossHPOoT                = CreateReduxRadioButton -Column 1 -Row 0 -Panel $BossHPPanelOoT                -Text "2x Boss HP" -ToolTip $ToolTip -Info "Bosses have double as much hit points"
  # $global:3xBossHPOoT                = CreateReduxRadioButton -Column 2 -Row 0 -Panel $BossHPPanelOoT                -Text "3x Boss HP" -ToolTip $ToolTip -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $global:OHKOModeOoT                = CreateReduxCheckbox -Column 0 -Row 3 -Group $HeroModeBoxOoT -Text "OHKO Mode" -ToolTip $ToolTip -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # TEXT SPEED #
    $TextBoxOoT                        = CreateReduxGroup -Y ($HeroModeBoxOoT.Bottom + 5) -Height 1 -Dialog $OoTOptionsPanel -Text "Text Dialogue Speed"
    
    $TextPanelOoT                      = CreateReduxPanel -Row 0 -Group $TextBoxOoT 
    $global:1xTextOoT                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $TextPanelOoT -Checked $True -Text "1x Speed" -ToolTip $ToolTip -Info "Leave the dialogue text speed at normal"
    $global:2xTextOoT                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $TextPanelOoT                -Text "2x Speed" -ToolTip $ToolTip -Info "Set the dialogue text speed to be twice as fast"
    $global:3xTextOoT                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $TextPanelOoT                -Text "3x Speed" -ToolTip $ToolTip -Info "Set the dialogue text speed to be three times as fast"



    # GRAPHICS #
    $GraphicsBoxOoT                    = CreateReduxGroup -Y ($TextBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTOptionsPanel -Text "Graphics"
    
    $global:WidescreenOoT              = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBoxOoT -Text "16:9 Widescreen"        -ToolTip $ToolTip -Info "Native 16:9 widescreen display support"
    $global:WidescreenTexturesOoT      = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBoxOoT -Text "16:9 Textures"          -ToolTip $ToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support"
    $global:ExtendedDrawOoT            = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBoxOoT -Text "Extended Draw Distance" -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $global:BlackBarsOoT               = CreateReduxCheckbox -Column 3 -Row 1 -Group $GraphicsBoxOoT -Text "No Black Bars"          -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $global:ForceHiresModelOoT         = CreateReduxCheckbox -Column 0 -Row 2 -Group $GraphicsBoxOoT -Text "Force Hires Link Model" -ToolTip $ToolTip -Info "Always use Link's High Resolution Model when Link is too far away"
    $global:MMModelsOoT                = CreateReduxCheckbox -Column 1 -Row 2 -Group $GraphicsBoxOoT -Text "Replace Link's Models"  -ToolTip $ToolTip -Info "Replaces Link's models to be styled towards Majora's Mask"



    # EQUIPMENT #
    $EquipmentBoxOoT                   = CreateReduxGroup -Y ($GraphicsBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTOptionsPanel -Text "Equipment"
    
    $ItemCapacityPanelOoT              = CreateReduxPanel -Row 0 -Group $EquipmentBoxOoT 
    $global:ReducedItemCapacityOoT     = CreateReduxRadioButton -Column 0 -Row 0 -Panel $ItemCapacityPanelOoT                -Text "Reduced Item Capacity"   -ToolTip $ToolTip -Info "Decrease the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $global:NormalItemCapacityOoT      = CreateReduxRadioButton -Column 1 -Row 0 -Panel $ItemCapacityPanelOoT -Checked $True -Text "Normal Item Capacity"    -ToolTip $ToolTip -Info "Keep the normal amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $global:IncreasedItemCapacityOoT   = CreateReduxRadioButton -Column 2 -Row 0 -Panel $ItemCapacityPanelOoT                -Text "Increased Item Capacity" -ToolTip $ToolTip -Info "Increase the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"

    $global:UnlockSwordOoT             = CreateReduxCheckbox -Column 0 -Row 2 -Group $EquipmentBoxOoT -Text "Unlock Kokiri Sword" -ToolTip $ToolTip -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword"
    $global:UnlockTunicsOoT            = CreateReduxCheckbox -Column 1 -Row 2 -Group $EquipmentBoxOoT -Text "Unlock Tunics"       -ToolTip $ToolTip -Info "Child Link is able to use the Goron TUnic and Zora Tunic`nSince you might want to walk around in style as well when you are young"
    $global:UnlockBootsOoT             = CreateReduxCheckbox -Column 2 -Row 2 -Group $EquipmentBoxOoT -Text "Unlock Boots"        -ToolTip $ToolTip -Info "Child Link is able to use the Iron Boots and Hover Boots"



    # EVERYTHING ELSE #
    $OtherBoxOoT                       = CreateReduxGroup -Y ($EquipmentBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTOptionsPanel -Text "Other"

    $global:DisableLowHPSoundOoT       = CreateReduxCheckbox -Column 0 -Row 1 -Group $OtherBoxOoT -Text "Disable Low HP Beep"             -ToolTip $ToolTip -Info "There will be absolute silence when Link's HP is getting low"
    $global:MedallionsOoT              = CreateReduxCheckbox -Column 1 -Row 1 -Group $OtherBoxOoT -Text "Require All Medallions"          -ToolTip $ToolTip -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`The vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows"
    $global:ReturnChildOoT             = CreateReduxCheckbox -Column 2 -Row 1 -Group $OtherBoxOoT -Text "Can Always Return"               -ToolTip $ToolTip -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"
    $global:DisableNaviOoT             = CreateReduxCheckbox -Column 3 -Row 1 -Group $OtherBoxOoT -Text "Remove Navi Prompts"             -ToolTip $ToolTip -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes"
    $global:HideDPadOoT                = CreateReduxCheckbox -Column 0 -Row 2 -Group $OtherBoxOoT -Text "Hide D-Pad Icon" -Disable $True -ToolTip $ToolTip -Info "Hide the D-Pad icon, while it is still active"
    


    $PatchReduxCheckbox.Add_CheckStateChanged({
        $HideDPadOoT.Enabled = $PatchReduxCheckbox.Checked
    })

}



#==============================================================================================================================================================================================
function CreateMMOptionsContent() {

    # HERO MODE #
    $HeroModeBoxMM                     = CreateReduxGroup -Y 50 -Height 3 -Dialog $MMOptionsPanel -Text "Hero Mode"
    
    # Damage
    $DamagePanelMM                     = CreateReduxPanel -Row 0 -Group $HeroModeBoxMM 
    $global:1xDamageMM                 = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanelMM -Checked $True -Text "1x Damage" -ToolTip $ToolTip -Info "Enemies deal normal damage"
    $global:2xDamageMM                 = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanelMM                -Text "2x Damage" -ToolTip $ToolTip -Info "Enemies deal twice as much damage"
    $global:4xDamageMM                 = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanelMM                -Text "4x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"
    $global:8xDamageMM                 = CreateReduxRadioButton -Column 3 -Row 0 -Panel $DamagePanelMM                -Text "8x Damage" -ToolTip $ToolTip -Info "Enemies deal four times as much damage"

    # Recovery
    $RecoveryPanelMM                   = CreateReduxPanel -Row 1 -Group $HeroModeBoxMM 
    $global:NormalRecoveryMM           = CreateReduxRadioButton -Column 0 -Row 0 -Panel $RecoveryPanelMM -Checked $True -Text "1x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $global:HalfRecoveryMM             = CreateReduxRadioButton -Column 1 -Row 0 -Panel $RecoveryPanelMM                -Text "1/2x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $global:QuarterRecoveryMM          = CreateReduxRadioButton -Column 2 -Row 0 -Panel $RecoveryPanelMM                -Text "1/4x Recovery" -ToolTip $ToolTip -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $global:NoRecoveryMM               = CreateReduxRadioButton -Column 3 -Row 0 -Panel $RecoveryPanelMM                -Text "0x Recovery"   -ToolTip $ToolTip -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $BossHPPanelMM                     = CreateReduxPanel -Row 2 -Group $HeroModeBoxMM 
  # $global:1xBossHPMM                 = CreateReduxRadioButton -Column 0 -Row 0 -Panel $BossHPPanelMM -Checked $True -Text "1x Boss HP" -ToolTip $ToolTip -Info "Bosses have normal hit points" 
  # $global:2xBossHPMM                 = CreateReduxRadioButton -Column 1 -Row 0 -Panel $BossHPPanelMM                -Text "2x Boss HP" -ToolTip $ToolTip -Info "Bosses have double as much hit points"
  # $global:3xBossHPMM                 = CreateReduxRadioButton -Column 2 -Row 0 -Panel $BossHPPanelMM                -Text "3x Boss HP" -ToolTip $ToolTip -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $global:OHKOModeMM                 = CreateReduxCheckbox -Column 0 -Row 3 -Group $HeroModeBoxMM -Text "OHKO Mode" -ToolTip $ToolTip -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # D-PAD #
    $DPadBoxMM                         = CreateReduxGroup -Y ($HeroModeBoxMM.Bottom + 5) -Height 1 -Dialog $MMOptionsPanel -Text "D-Pad Icons Layout"
    
    $DPadPanelMM                       = CreateReduxPanel -Row 0 -Group $DPadBoxMM 
    $global:LeftDPadMM                 = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DPadPanelMM                -Disable $True -Text "Left Side" -ToolTip $ToolTip -Info "Show the D-Pad icons on the left side of the HUD"
    $global:RightDPadMM                = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DPadPanelMM -Checked $True -Disable $True -Text "Right Side" -ToolTip $ToolTip -Info "Show the D-Pad icons on the right side of the HUD"
    $global:HideDPadMM                 = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DPadPanelMM                -Disable $True -Text "Hidden" -ToolTip $ToolTip -Info "Hide the D-Pad icons, while they are still active"
    
    
   
    # GRAPHICS #
    $GraphicsBoxMM                     = CreateReduxGroup -Y ($DPadBoxMM.Bottom + 5) -Height 2 -Dialog $MMOptionsPanel -Text "Graphics"
    
    $global:WidescreenMM               = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBoxMM -Text "16:9 Widescreen"         -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support"
    $global:WidescreenTexturesMM       = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBoxMM -Text "16:9 Textures"           -ToolTip $ToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support"
    $global:ExtendedDrawMM             = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBoxMM -Text "Extended Draw Distance"  -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $global:BlackBarsMM                = CreateReduxCheckbox -Column 3 -Row 1 -Group $GraphicsBoxMM -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $global:PixelatedStarsMM           = CreateReduxCheckbox -Column 0 -Row 2 -Group $GraphicsBoxMM -Text "Disable Pixelated Stars" -ToolTip $ToolTip -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement"

    

    # EQUIPMENT #
    $EquipmentBoxMM                    = CreateReduxGroup -Y ($GraphicsBoxMM.Bottom + 5) -Height 2 -Dialog $MMOptionsPanel -Text "Equipment"
    
    $global:ItemCapacityPanelMM        = CreateReduxPanel -Row 0 -Group $EquipmentBoxMM 
    $global:ReducedItemCapacityMM      = CreateReduxRadioButton -Column 0 -Row 0 -Panel $ItemCapacityPanelMM                -Text "Reduced Item Capacity"   -ToolTip $ToolTip -Info "Decrease the amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $global:NormalItemCapacityMM       = CreateReduxRadioButton -Column 1 -Row 0 -Panel $ItemCapacityPanelMM -Checked $True -Text "Normal Item Capacity"    -ToolTip $ToolTip -Info "Keep the normal amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $global:IncreasedItemCapacityMM    = CreateReduxRadioButton -Column 2 -Row 0 -Panel $ItemCapacityPanelMM                -Text "Increased Item Capacity" -ToolTip $ToolTip -Info "Increase the amount of deku sticks, deku nuts, bombs and arrows you can carry"

    $global:RazorSwordMM               = CreateReduxCheckbox -Column 0 -Row 2 -Group $EquipmentBoxMM -Text "Permanent Razor Sword" -ToolTip $ToolTip -Info "The Razor Sword won't get destroyed after 100 it`nYou can also keep the Razor Sword when traveling back in time"



    # EVERYTHING ELSE #
    $OtherBoxMM                        = CreateReduxGroup -Y ($EquipmentBoxMM.Bottom + 5) -Height 1 -Dialog $MMOptionsPanel -Text "Other"

    $global:DisableLowHPSoundMM        = CreateReduxCheckbox -Column 0 -Row 1 -Group $OtherBoxMM -Text "Disable Low HP Beep"      -ToolTip $ToolTip -Info "There will be absolute silence when Link's HP is getting low"
    $global:PieceOfHeartSoundMM        = CreateReduxCheckbox -Column 1 -Row 1 -Group $OtherBoxMM -Text "4th Piece of Heart Sound" -ToolTip $ToolTip -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container"



    $PatchReduxCheckbox.Add_CheckStateChanged({
        $LeftDPadMM.Enabled = $PatchReduxCheckbox.Checked
        $RightDPadMM.Enabled = $PatchReduxCheckbox.Checked
        $HideDPadMM.Enabled = $PatchReduxCheckbox.Checked
    })

}



#==============================================================================================================================================================================================
function CreateSM64OptionsContent() {
    
     # HERO MODE #
    $HeroModeBoxSM64                   = CreateReduxGroup -Y 50 -Height 1 -Dialog $SM64OptionsPanel -Text "Hero Mode"
    
    # Damage
    $DamagePanelSM64                   = CreateReduxPanel -Row 0 -Group $HeroModeBoxSM64
    $global:1xDamageSM64               = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanelSM64 -Checked $True -Text "1x Damage" -ToolTip $ToolTip -Info "Enemies deal normal damage"
    $global:2xDamageSM64               = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanelSM64                -Text "2x Damage" -ToolTip $ToolTip -Info "Enemies deal twice as much damage"
    $global:3xDamageSM64               = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanelSM64                -Text "3x Damage" -ToolTip $ToolTip -Info "Enemies deal trice as much damage"



    # GRAPHICS #
    $GraphicsBoxSM64                   = CreateReduxGroup -Y ($HeroModeBoxSM64.Bottom + 5) -Height 1 -Dialog $SM64OptionsPanel -Text "Graphics"
    
    $global:WidescreenSM64             = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBoxSM64 -Text "16:9 Widescreen"         -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support"
    $global:ForceHiresModelSM64        = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBoxSM64 -Text "Force Hires Mario Model" -ToolTip $ToolTip -Info "Always use Mario's High Resolution Model when Mario is too far away"
    $global:BlackBarsSM64              = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBoxSM64 -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen"
    



    # GRAPHICS #
    $GameplayBoxSM64                   = CreateReduxGroup -Y ($GraphicsBoxSM64.Bottom + 5) -Height 1 -Dialog $SM64OptionsPanel -Text "Gameplay"

    $global:60FPSSM64                  = CreateReduxCheckbox -Column 0 -Row 1 -Group $GameplayBoxSM64 -Text "60 FPS"        -ToolTip $ToolTip -Info "Increases the FPS from 30 to 60`nWitness Super Mario 64 in glorious 60 FPS"
    $global:FreeCamSM64                = CreateReduxCheckbox -Column 1 -Row 1 -Group $GameplayBoxSM64 -Text "Analog Camera" -ToolTip $ToolTip -Info "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Left / Right for the Analog stick"
    $global:LagFixSM64                 = CreateReduxCheckbox -Column 2 -Row 1 -Group $GameplayBoxSM64 -Text "Lag Fix"       -ToolTip $ToolTip -Info "Smoothens gameplay by reducing lag"

    

    $60FPSSM64.Add_CheckStateChanged({ $FreeCamSM64.Enabled = !$60FPSSM64.Checked})
    $FreeCamSM64.Add_CheckStateChanged({ $60FPSSM64.Enabled = !$FreeCamSM64.Checked})

}



#==============================================================================================================================================================================================
function DisablePatches() {
    
    $PatchReduxCheckbox.Visible = $PatchReduxLabel.Visible = (IsSet -Elem $GamePatch.redux.file)
    $PatchOptionsCheckbox.Visible = $PatchOptionsLabel.Visible = $PatchOptionsButton.Visible = $GamePatch.options
    $PatchOptionsButton.Enabled = $GamePatch.options -and $PatchOptionsCheckbox.Checked

    $PatchVCRemoveFilterLabel.Enabled = $PatchVCRemoveFilter.Enabled = !(StrLike -str $GamePatch.command -val "Patch Boot DOL")
    $global:ToolTip.SetToolTip($PatchButton, ([String]::Format($Item.tooltip, [Environment]::NewLine)))

    $60FPSSM64.Enabled   = !(StrLike -str $GamePatch.command -val "No FPS")
    $FreeCamSM64.Enabled = !(StrLike -str $GamePatch.command -val "No Free Cam")

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
CreateLanguageDialog
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