#==============================================================================================================================================================================================
$ScriptName = 'Patcher64+ Tool'



#=============================================================================================================================================================================================
# Patcher By     :  Admentus
# Concept By     :   
# Testing By     :  Admentus, GhostlyDark



#==============================================================================================================================================================================================
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'



#==============================================================================================================================================================================================
# Setup global variables

$global:VersionDate = "17-06-2020"
$global:Version     = "v4.5"

$global:GameID = ""
$global:ChannelTitle = ""
$global:GameType = ""
$global:GetCommand = ""
$global:IsRedux = $False
$global:IsCompress = $False
$global:IsWiiVC = $False
$global:IsDowngrade = $False
$global:PatchedFileName = ""
$global:CheckHashSum = ""
$global:MissingFiles = $False
$global:GameTitleLength = 0

$global:CurrentModeFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 12, [System.Drawing.FontStyle]::Bold)
$global:VCPatchFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 8, [System.Drawing.FontStyle]::Bold)



#==============================================================================================================================================================================================
# Hashes

$global:HashSum_oot_rev0 = "C916AB315FBE82A22169BFF13D6B866E9FDDC907461EB6B0A227B82ACDF5B506"
$global:HashSum_oot_rev1 = "FB87A0DAC188F9292C679DA7AC6F772ACEBE6F68E27293CFC281FC8636008DB0"
$global:HashSum_oot_rev2 = "49ACD3885F13B0730119B78FB970911CC8ABA614FE383368015C21565983368D"



#==============================================================================================================================================================================================
# Set file paths

# The path this script is found in.
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
    $BasePath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else {
  $BasePath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
  if (!$BasePath) { $BasePath = "." }
}

# Set the master path to where the files will be located.
$global:MasterPath = $BasePath + "\Files"
$global:InfoPath = $BasePath + "\Info"
$global:IconsPath = $MasterPath + "\Icons"
$global:WiiVCPath = $MasterPath + "\Wii VC"



#==============================================================================================================================================================================================
# Files to patch and use

$global:WADFilePath = $null
$global:Z64FilePath = $null
$global:BPSFilePath = $null
$global:PatchFile = $null
$global:ROMFile = $null
$global:ROMCFile = $null
$global:PatchedROMFile = $null
$global:DecompressedROMFile = $null
$global:PatchesJSONFile = $null
$global:GamesJSONFile = $null



#==============================================================================================================================================================================================
# Import code

#Import-Module -Name ($BasePath + '\Extension.psm1')



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
function ExtendString([string]$InputString, [int]$Length) {

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
function MainFunction([String]$Command, [boolean]$Redux, [string]$Id, [string]$Title, [string]$Patch, [string]$PatchedFile, [string]$Hash) {
    
    $global:GetCommand = $Command
    $global:IsRedux = $Redux
    $global:PatchFile = $Patch
    $global:PatchedFileName = $PatchedFile
    $global:CheckHashSum = $Hash

    if (!(CheckCheckBox -CheckBox $InputCustomGameIDCheckbox))               { ResetGameID }
    if ($Id.length -gt 0)                                                    { $global:GameID = $Id }
    if ($Title.length -gt 0)                                                 { $global:ChannelTitle = $Title }
    SetCustomGameID

    if ($IsWiiVC) {
        if ($PatchVCDowngrade.Checked -and $PatchVCDowngrade.Visible)        { $global:IsDowngrade = $True }
        if ($GetCommand -eq "Downgrade" -and $PatchVCDowngrade.Visible)      { $global:IsDowngrade = $PatchVCDowngrade.Checked = $True }
        if ($GetCommand -eq "No Downgrade" -and $PatchVCDowngrade.Visible)   { $global:IsDowngrade = $PatchVCDowngrade.Checked = $False }
    }
    else                                                                     { $global:IsDowngrade = $False }
    if ($Z64FilePath.length -gt 0)                                           { $global:Z64File = SetZ64Parameters -Z64Path $global:GameZ64 }
    
    $PatchVCRemapDPad.Checked = ($GetCommand -eq "Remap D-Pad")

    if ($IsRedux) {
        $PatchVCRemapDPad.Checked = $true
        if ($GameType -eq "Ocarina of Time") {
            $PatchVCExpandMemory.Checked = $true
            if ($IsWiiVC -and !$PatchVCRemapCDown.Checked -and !$PatchVCRemapZ.Checked)   { $PatchVCLeaveDPadUp.Checked = $true }
            if ($IsWiiVC)                                                                 { $global:IsDowngrade = $PatchVCDowngrade.Checked = $True }
        }
    }

    if ($PatchFile -like "*\Decompressed\*")   { $global:IsCompress = $True }
    elseif ($IsRedux)                          { $global:IsCompress = $True }
    else                                       { $global:IsCompress = $False }

    MainFunctionPatch
    Cleanup

}



#==============================================================================================================================================================================================
function MainFunctionPatch() {
    
    #if (!(WriteDebug)) { return }

    # Step 01: Disable the main dialog, allow patching and delete files if they still exist.
    EnableGUI -Enable $False

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        
        # Step 02: Extract the contents of the WAD file.
        ExtractWADFile

        # Step 03: Check the GameID to be vanilla.
        if (!(CheckGameID)) { return }

        # Step 04: Replace the Virtual Console emulator within the WAD file.
        PatchVCEmulator

        # Step 05: Extract "00000005.app" file to get the ROM.
        ExtractU8AppFile

        # Step 06: Do some initial patching stuff for the ROM for VC WAD files.
        if (!(PatchVCROM)) { return }

    }

    # Step 07: Downgrade the ROM if required
    if (!(DowngradeROM)) { return }

    # Step 08: Compare HashSums for untouched ROM Files
    if (!(CompareHashSums)) { return }

    # Step 09: Decompress the ROM if required.
    DecompressROM

    # Step 11: Apply additional patches on top of the Redux patches.
    PatchRedux

    # Step 10: Patch and extend the ROM file with the patch through Floating IPS.
    if (!(PatchROM)) { return }

    # Step 12: Compress the decompressed ROM if required.
    CompressROM

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 13: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        ExtendROM

        # Step 14: Compress the ROMC again if possible.
        CompressROMC

        # Step 15: Hack the Channel Title.
        HackOpeningBNRTitle

        # Step 16: Repack the "00000005.app" with the updated ROM file.
        RepackU8AppFile

        # Step 17: Repack the WAD file with the updated APP file.
        RepackWADFile
    }
    else {
        # Step 13: Hack the Game Title and GameID of a N64 ROM
        HackN64GameTitle
    }

    # Step 18: Final message.
    if ($IsWiiVC)   { UpdateStatusLabel -Text ('Finished patching the ' + $GameType + ' VC WAD file.') }
    else            { UpdateStatusLabel -Text ('Finished patching the ' + $GameType + ' ROM file.') }

}



#==============================================================================================================================================================================================
function WriteDebug() {

    Write-Host ""
    Write-Host "--- Patch Info ---"
    Write-Host "GameID:" $global:GameID
    Write-Host "Channel Title:" $ChannelTitle
    Write-Host "Patch File:" $PatchFile
    Write-Host "Command:" $global:GetCommand
    Write-Host "Redux:" $IsRedux
    Write-Host "Downgrade:" $IsDowngrade
    Write-Host "Compress:" $IsCompress
    Write-Host "Wii VC:" $IsWiiVC
    Write-Host "ROM File:" $ROMFile
    Write-Host "WAD File Path:" $WADFilePath
    Write-Host "Z64 File Path:" $Z64FilePath

    return $False

}



#==============================================================================================================================================================================================
function Cleanup() {
    
    RemovePath -LiteralPath ($MasterPath + '\cygdrive')
    DeleteFile -File $Files.flipscfg
    DeleteFile -File $Files.stackdump

    if ($IsWiiVC) {
        RemovePath -LiteralPath $WADFile.Folder
        DeleteFile -File $Files.ckey
        DeleteFile -File ($WiiVCPath + "\00000000.app")
        DeleteFile -File ($WiiVCPath + "\00000001.app")
        DeleteFile -File ($WiiVCPath + "\00000002.app")
        DeleteFile -File ($WiiVCPath + "\00000003.app")
        DeleteFile -File ($WiiVCPath + "\00000004.app")
        DeleteFile -File ($WiiVCPath + "\00000005.app")
        DeleteFile -File ($WiiVCPath + "\00000006.app")
        DeleteFile -File ($WiiVCPath + "\00000007.app")
        DeleteFile -File ($WiiVCPath + "\" + $WADFile.FolderName + ".cert")
        DeleteFile -File ($WiiVCPath + "\" + $WADFile.FolderName + ".tik")
        DeleteFile -File ($WiiVCPath + "\" + $WADFile.FolderName + ".tmd")
        DeleteFile -File ($WiiVCPath + "\" + $WADFile.FolderName + ".trailer")
    }

    DeleteFile -File $Files.dmaTable
    DeleteFile -File $Files.archive
    DeleteFile -File $Files.decompressedROM

    foreach($Folder in Get-ChildItem -LiteralPath $WiiVCPath -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }

    EnableGUI -Enable $True
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function EnableGUI([boolean]$Enable) {
    
    #$InputWADPanel.Enabled = $InputROMPanel.Enabled = $InputBPSPanel.Enabled = $CurrentGamePanel.Enabled = $CustomGameIDPanel.Enabled = $Enable
    $InputWADPanel.Enabled = $Enable
    $PatchPanel.Enabled = $Enable
    $MiscPanel.Enabled = $PatchVCPanel.Enabled = $Enable
    #$MainDialog.Enabled = $StatusPanel.Enabled = $True

}


#==============================================================================================================================================================================================
function DeleteFile([string]$File) { if (Test-Path -LiteralPath $File -PathType Leaf) { Remove-Item -LiteralPath $File -Force } }



#==============================================================================================================================================================================================
function RemovePath([string]$LiteralPath) {
    
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
function CreatePath([string]$LiteralPath) {
    
    # Make sure the path isn't null to avoid errors.
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
function TestPath([string]$LiteralPath, [string]$PathType = 'Any') {
    
    # Make sure the path isn't null to avoid errors.
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
function Get-FileName([string]$Path, [string[]]$Description, [string[]]$FileName) {
    
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
    $Icons.Main                 = $IconsPath + "\Main.ico"

    $Icons.OcarinaOfTime        = $IconsPath + "\Ocarina of Time.ico"
    $Icons.MajorasMask          = $IconsPath + "\Majora's Mask.ico"
    $Icons.SuperMario64         = $IconsPath + "\Super Mario 64.ico"
    $Icons.PaperMario           = $IconsPath + "\Paper Mario.ico"
    $Icons.Free                 = $IconsPath + "\Free.ico"

    $Icons.OcarinaOfTimeRedux   = $IconsPath + "\Ocarina of Time REDUX.ico"
    $Icons.MajorasMaskRedux     = $IconsPath + "\Majora's Mask REDUX.ico"

    $Icons.CheckGameID          = $IconsPath + "\Check GameID.ico"
    $Icons.Credits              = $IconsPath + "\Credits.ico"

    $Icons.GetEnumerator() | ForEach-Object {
        if (!(Test-Path $_.value -PathType leaf)) {
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
    $Files.flips                         = $MasterPath + "\Base\flips.exe"
    $Files.wadpacker                     = $MasterPath + "\Wii VC\wadpacker.exe"
    $Files.wadunpacker                   = $MasterPath + "\Wii VC\wadunpacker.exe"
    $Files.wszst                         = $MasterPath + "\Wii VC\wszst.exe"
    $Files.cygcrypto                     = $MasterPath + "\Wii VC\cygcrypto-0.9.8.dll"
    $Files.cyggccs1                      = $MasterPath + "\Wii VC\cyggcc_s-1.dll"
    $Files.cygncursesw10                 = $MasterPath + "\Wii VC\cygncursesw-10.dll"
    $Files.cygpng1616                    = $MasterPath + "\Wii VC\cygpng16-16.dll"
    $Files.cygwin1                       = $MasterPath + "\Wii VC\cygwin1.dll"
    $Files.cygz                          = $MasterPath + "\Wii VC\cygz.dll"
    $Files.ndec                          = $MasterPath + "\Compression\ndec.exe"
    $Files.TabExt                        = $MasterPath + "\Compression\TabExt.exe"
    $Files.Compress                      = $MasterPath + "\Compression\Compress.exe"
    $Files.lzss                          = $MasterPath + "\Wii VC\lzss.exe"
    $Files.romc                          = $MasterPath + "\Wii VC\romc.exe"
    $Files.romchu                        = $MasterPath + "\Wii VC\romchu.exe"

    $Files.bpspatch_oot_rev1_to_rev0     = $MasterPath + "\Ocarina of Time\oot_rev1_to_rev0.bps"
    $Files.bpspatch_oot_rev2_to_rev0     = $MasterPath + "\Ocarina of Time\oot_rev2_to_rev0.bps"
    $Files.bpspatch_oot_redux            = $MasterPath + "\Ocarina of Time\Decompressed\oot_redux.bps"
    $Files.bpspatch_oot_models_mm        = $MasterPath + "\Ocarina of Time\Decompressed\oot_models_mm.bps"
    $Files.bpspatch_oot_models_mm_redux  = $MasterPath + "\Ocarina of Time\Decompressed\oot_models_mm_redux.bps"
    $Files.bpspatch_oot_widescreen       = $MasterPath + "\Ocarina of Time\Decompressed\oot_widescreen.bps"

    $Files.bpspatch_mm_redux             = $MasterPath + "\Majora's Mask\Decompressed\mm_redux.bps"
    $Files.bpspatch_mm_widescreen        = $MasterPath + "\Majora's Mask\Decompressed\mm_widescreen.bps"

    $Files.bpspatch_sm64_appFile_01      = $MasterPath + "\Super Mario 64\sm64_appFile_01.bps"

    $Files.games                         = $MasterPath + "\Games.json"

    $Files.GetEnumerator() | ForEach-Object {
        if (!(Test-Path $_.value -PathType leaf)) {
            $global:MissingFiles = $True
        }
    }

    $Files.text_gameID                   = $InfoPath + "\GameID's.txt"
    $Files.text_credits                  = $InfoPath + "\Credits.txt"
    $Files.text_info_oot                 = $InfoPath + "\Ocarina of Time.txt"
    $Files.text_info_mm                  = $InfoPath + "\Majora's Mask.txt"
    $Files.text_info_sm64                = $InfoPath + "\Super Mario 64.txt"
    $Files.text_info_pp                  = $InfoPath + "\Paper Mario.txt"
    $Files.text_info_free                = $InfoPath + "\Free.txt"

    $Files.flipscfg                      = $MasterPath + "\Base\flipscfg.bin"
    $Files.ckey                          = $MasterPath + "\Wii VC\common-key.bin"
    $Files.dmaTable                      = $BasePath + "\dmaTable.dat"
    $Files.archive                       = $BasePath + "\ARCHIVE.bin"
    $Files.decompressedROM               = $MasterPath + "\decompressed"
    $Files.stackdump                     = $MasterPath + "\Wii VC\wadpacker.exe.stackdump"

    # Set it to a global value.
    return $Files

}



#==============================================================================================================================================================================================
function SetWADParameters([string]$WADPath, [string]$FolderName) {
    
    # Create a hash table.
    $WADFile = @{}

    # Get the WAD as an item object.
    $WADItem = Get-Item -LiteralPath $WADPath
    
    # Store some stuff about the WAD that I'll probably reference.
    $WADFile.Name         = $WADItem.BaseName
    $WADFile.Folder       = $WiiVCPath + '\' + $FolderName
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
    
    if ($GameType -eq "Majora's Mask" -or $GameType -eq "Paper Mario")   { $WADFile.ROMFile = $WADFile.AppPath05 + '\romc' }
    else                                                                 { $WADFile.ROMFile = $WADFile.AppPath05 + '\rom' }
    $WADFile.Patched      = $WADItem.DirectoryName + '\' + $WADFile.Name + $PatchedFileName + '.wad'
    $WADFile.Extracted    = $WADItem.DirectoryName + '\' + $WADFile.Name + "_extracted_rom" + '.z64'

    SetROMFile

    # Set it to a global value.
    return $WADFile

}



#==============================================================================================================================================================================================
function SetZ64Parameters([string]$Z64Path) {
    
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
        $global:DecompressedROMFile = $MasterPath + "\decompressed"
    }

}



#==============================================================================================================================================================================================
function ExtractWADFile() {
    
    # Set the status label.
    UpdateStatusLabel -Text "Extracting WAD file..."

    # We need to be in the same path as some files so just jump there.
    Push-Location $WiiVCPath

    # Check if an extracted folder existed previously
    foreach($Folder in Get-ChildItem -LiteralPath $WiiVCPath -Force) { if ($Folder.PSIsContainer) { if (TestPath -LiteralPath $Folder) { RemovePath -LiteralPath $Folder } } }
    
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
    foreach($Folder in Get-ChildItem -LiteralPath $WiiVCPath -Force) {
        # There will only be one folder, the one we want.
        if ($Folder.PSIsContainer) {
            # Remember the path to this folder.
            $global:WADFile = SetWADParameters -WADPath $GameWAD -FolderName $Folder.Name
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
function PatchVCEmulator() {
    
    if ($GetCommand -eq "Extract" -or !(CheckBootDolOptions)) { return }

    # Set the status label.
    UpdateStatusLabel -Text ("Patching " + $GameType + " VC Emulator...")

    if ($GameType -eq "Ocarina of Time") {
        
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

    elseif ($GameType -eq "Majora's Mask") {
        
        & $Files.lzss -d $WADFile.AppFile01 | Out-Host

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

        & $Files.lzss -evn $WADFile.AppFile01 | Out-Host

    }

    elseif ($GameType -eq "Super Mario 64") {

        if ($GetCommand -eq "Patch Boot DOL")   { & $Files.flips --ignore-checksum $Files.bpspatch_sm64_appFile_01 $WADFile.AppFile01 | Out-Host }

    }

}



#==============================================================================================================================================================================================
function PatchVCROM() {

    if ($GetCommand -eq "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabel -Text ("Initial patching of " + $GameType + " ROM...")
    
    # Extract ROM if required
    if ($GetCommand -eq "Extract") {
        if ($GameType -eq "Free")   { $ROMTitle = "n64_rom_extracted.z64" }
        else                        { $ROMTitle = $GameType + "_rom_extracted.z64" }

        if (Test-Path -LiteralPath $ROMFile -PathType leaf) {
            Move-Item -LiteralPath $ROMFile -Destination $WADFile.Extracted
            UpdateStatusLabel -Text ("Successfully extracted " + $GameType + " ROM.")
        }
        else { UpdateStatusLabel -Text ("Could not extract " + $GameType + " ROM. Is it a Majora's Mask or Paper Mario ROM?") }

        return $False
    }

    # Replace ROM if needed
    if ($GetCommand -eq "Inject") {
        if (Test-Path -LiteralPath $ROMFile -PathType leaf) {
            Remove-Item -LiteralPath $ROMFile
            if ((Test-Path -LiteralPath $Z64FilePath -PathType leaf)) { Copy-Item -LiteralPath $Z64FilePath -Destination $ROMFile }
            else {
                UpdateStatusLabel -Text ("Could not inject " + $GameType + " ROM. Did you move or rename the ROM file?")
                return $False
            }
        }
        else {
            UpdateStatusLabel -Text ("Could not inject " + $GameType + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
            return $False
        }

        if (!(Test-Path -LiteralPath $ROMFile -PathType leaf)) {
            UpdateStatusLabel -Text ("Could not inject " + $GameType + " ROM. Is your ROM filename or destination path too long?")
            return $False
        }
    }

    # Decompress romc if needed
    if ($GetCommand -ne "Inject" -and ($GameType -eq "Majora's Mask" -or $GameType -eq "Paper Mario") ) {  

        if (Test-Path -LiteralPath $ROMFile -PathType leaf) {
            if ($GameType -eq "Majora's Mask")     { & $Files.romchu $ROMFile $ROMCFile | Out-Null }
            elseif ($GameType -eq "Paper Mario")   { & $Files.romc d $ROMFile $ROMCFile | Out-Null }
            Remove-Item -LiteralPath $ROMFile
            Rename-Item -LiteralPath $ROMCFile -NewName "romc"
        }
        else {
            UpdateStatusLabel -Text ("Could not decompress " + $GameType + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
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
function DowngradeROM() {
    
    if ($GetCommand -eq "Inject") { return $True }

    # Downgrade a ROM if it is required first
    if ($GameType -eq "Ocarina of Time" -and $IsDowngrade) {
        
        $HashSum = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash
        if ($HashSum -ne $HashSum_oot_rev1 -and $HashSum -ne $HashSum_oot_rev2) {
            UpdateStatusLabel -Text "Failed! Ocarina of Time ROM does not match revision 1 or 2."
            return $False
        }

        if ($HashSum -eq $HashSum_oot_rev1)       { & $Files.flips --ignore-checksum $Files.bpspatch_oot_rev1_to_rev0 $ROMFile | Out-Host }
        elseif ($HashSum -eq $HashSum_oot_rev2)   { & $Files.flips --ignore-checksum $Files.bpspatch_oot_rev2_to_rev0 $ROMFile | Out-Host }
        $global:CheckHashSum = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash

        $HashSum = $null

    }

    return $True
    
}



#==============================================================================================================================================================================================
function CompareHashSums() {
    
    if ($GetCommand -eq "Inject" -or $GetCommand -eq "Patch VC") { return $True }

    if (($PatchFile -ne $Null -or $IsRedux) -and $GetCommand -ne "Patch BPS") {

        $ContinuePatching = $True
        $HashSum = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash
        
        if ($CheckHashSum -eq "Dawn & Dusk") {
            if ($HashSum -eq $HashSum_oot_rev0)     { $global:PatchFile = $Files.bpspatch_oot_dawn_rev0 }
            elseif ($HashSum -eq $HashSum_oot_rev1) { $global:PatchFile = $Files.bpspatch_oot_dawn_rev1 }
            elseif ($HashSum -eq $HashSum_oot_rev2) { $global:PatchFile = $Files.bpspatch_oot_dawn_rev2 }
            else { $ContinuePatching = $False }
        }
        elseif ($HashSum -ne $CheckHashSum) { $ContinuePatching = $False }

        if (!$ContinuePatching) {
            UpdateStatusLabel -Text "Failed! ROM does not match the patching button target. ROM has left unchanged."
            return $False
        }

        $HashSum = $Null

    }

    return $True

}



#==============================================================================================================================================================================================
function PatchROM([string]$Hash) {

    if ($GetCommand -eq "Inject" -or $GetCommand -eq "Patch VC") { return $True }
    
    # Set the status label.
    UpdateStatusLabel -Text ("BPS Patching " + $GameType + " ROM...")

    $HashSum1 = $null
    if ($IsWiiVC -and $GetCommand -eq "Patch BPS") { $HashSum1 = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash }

    # Apply the selected patch to the ROM, if it is provided
    if ($PatchFile.Length -gt 0) {
        if ($IsWiiVC -and $IsCompress)         { & $Files.flips --ignore-checksum $PatchFile $DecompressedROMFile | Out-Host }
        elseif ($IsWiiVC -and !$IsCompress)    { & $Files.flips --ignore-checksum $PatchFile $PatchedROMFile | Out-Host }
        elseif (!$IsWiiVC -and $IsCompress)    { & $Files.flips --ignore-checksum $PatchFile $DecompressedROMFile | Out-Host }
        elseif (!$IsWiiVC -and !$IsCompress)   { & $Files.flips --ignore-checksum --apply $PatchFile $ROMFile $PatchedROMFile | Out-Host }
    }

    if ($IsWiiVC -and $GetCommand -eq "Patch BPS") {
        $HashSum2 = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash
        if ($HashSum1 -eq $HashSum2) {
            UpdateStatusLabel -Text 'Failed! BPS or IPS Patch does not match. ROM has left unchanged.'
            if ($GameType -eq "Ocarina of Time" -and !$IsDowngrade) { UpdateStatusLabel -Text "Failed! BPS or IPS Patch does not match. ROM has left unchanged. Enable Downgrade Ocarina of Time?" }
            elseif ($GameType -eq "Ocarina of Time" -and $IsDowngrade) { UpdateStatusLabel -Text "Failed! BPS or IPS Patch does not match. ROM has left unchanged. Disable Downgrade Ocarina of Time?" }
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function DecompressROM() {
    
    if (!$IsCompress -or $GetCommand -eq "Inject" -or ($GameType -ne "Ocarina of Time" -and $GameType -ne "Majora's Mask")) { return }

    UpdateStatusLabel -Text ("Decompressing " + $GameType + " ROM...")

    & $Files.TabExt $ROMFile | Out-Host
    & $Files.ndec $ROMFile $DecompressedROMFile | Out-Host

    if ($IsWiiVC) { Remove-Item -LiteralPath $ROMFile }

}



#==============================================================================================================================================================================================
function CompressROM() {
    
    if (!$IsCompress -or $GetCommand -eq "Inject" -or ($GameType -ne "Ocarina of Time" -and $GameType -ne "Majora's Mask")) { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType + " ROM...")

    & $Files.Compress $DecompressedROMFile $PatchedROMFile | Out-Null
    Remove-Item -LiteralPath $DecompressedROMFile

}



#==============================================================================================================================================================================================
function CompressROMC() {
    
    if ($GameType -ne "Paper Mario") { return }

    UpdateStatusLabel -Text ("Compressing " + $GameType + " VC ROM...")

    & $Files.romc e $ROMFile $ROMCFile | Out-Null
    Remove-Item -LiteralPath $ROMFile
    Rename-Item -LiteralPath $ROMCFile -NewName "romc"

}


#==============================================================================================================================================================================================
function PatchBytesSequence([String]$File, [int]$Offset, $Values, [int]$Increment, [boolean]$IsDec) {
    
    $ByteArray = [IO.File]::ReadAllBytes($File)

    if ($Increment -eq $null -or $Increment -lt 1) { $Increment = 1 }

    for ($i=0; $i -lt $Values.Length; $i++) {
        if ($IsDec)   { $ByteArray[(GetDecimal -Hex ($Offset + ($i * $Increment)))] = $Values[$i] }
        else          { $ByteArray[(GetDecimal -Hex ($Offset + ($i * $Increment)))] = (GetDecimal -Hex $Values[$i]) }  
    }

    [io.file]::WriteAllBytes($File, $ByteArray)
    $ByteArray = $null

}


#==============================================================================================================================================================================================
function PatchRedux() {
    
    # SETUP #
    if (!(CheckReduxOptions) -or !$IsRedux -or ($GameType -ne "Ocarina of Time" -and $GameType -ne "Majora's Mask")) { return }
    UpdateStatusLabel -Text ("Patching " + $GameType + " REDUX...")
    $offsets = ""

    # BPS PATCHING #
    if ($GameType -eq "Ocarina of Time") {
        $offsets = "0 1 2 3 4 5 6 7 8 9 15 16 17 18 19 20 21 22 23 24 25 26 942 944 946 948 950 952 954 956 958 960 962 964 966 968 970 972 974 976 978 980 982 984 986 988 990 992 994 "
        $offsets += "996 998 1000 1002 1004 1497 1498 1499 1500 1501 1502 1503 1504 1505 1506 1507 1508 1509 1510 1511 1512 1513 1514 1515 1516 1517 1518 1519 1520 1521 1522 1523 1524 1525"

        if (CheckCheckBox -CheckBox $IncludeReduxOoT)                                                { & $Files.flips --ignore-checksum $Files.bpspatch_oot_redux $DecompressedROMFile | Out-Host }
        if (CheckCheckBox -CheckBox $MMModelsOoT) {
            if (CheckCheckBox -CheckBox $IncludeReduxOoT)                                            { & $Files.flips --ignore-checksum $Files.bpspatch_oot_models_mm_redux $DecompressedROMFile | Out-Host }
            else                                                                                     { & $Files.flips --ignore-checksum $Files.bpspatch_oot_models_mm $DecompressedROMFile | Out-Host }
        }
        if (CheckCheckBox -CheckBox $WidescreenTexturesOoT)                                          { & $Files.flips --ignore-checksum $Files.bpspatch_oot_widescreen $DecompressedROMFile | Out-Host }
    }
    elseif ($GameType -eq "Majora's Mask") {
        $offsets = "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 25 26 27 28 29 30 -652 1127 -1539 -1540 -1541 -1542 -1543 1544 "
        $offsets += "1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" 

        if (CheckCheckBox -CheckBox $IncludeReduxMM)             { & $Files.flips --ignore-checksum $Files.bpspatch_mm_redux $DecompressedROMFile | Out-Host }
        if (CheckCheckBox -CheckBox $WidescreenTexturesMM)       { & $Files.flips --ignore-checksum $Files.bpspatch_mm_widescreen $DecompressedROMFile | Out-Host }
    }

    if (Test-Path dmaTable.dat -PathType leaf) { Remove-Item dmaTable.dat }
    Add-Content dmaTable.dat $offsets

    # BYTE PATCHING #
    if ($GameType -eq "Ocarina of Time")     { PatchReduxOoT }
    elseif ($GameType -eq "Majora's Mask")   { PatchReduxMM }

}


#==============================================================================================================================================================================================
function PatchReduxOoT() {
    
    # HERO MODE #

    if (CheckCheckBox -CheckBox $OHKOModeOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8073" -Values @("0x09", "0x04") -Increment 16
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x82", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x00", "0x00", "0x00")
    }
    elseif (!(CheckCheckBox -CheckBox $1xDamageOoT) -and !(CheckCheckBox -CheckBox $NormalRecoveryOoT)) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8073" -Values @("0x09", "0x04") -Increment 16
        if (CheckCheckBox -CheckBox $NormalRecoveryOoT) {                
            if (CheckCheckBox -CheckBox $2xDamageOoT )      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x40") }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x80") }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0xC0") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x00", "0x00", "0x00")
        }
        elseif (CheckCheckBox -CheckBox $HalfRecoveryOoT) {               
            if (CheckCheckBox -CheckBox $1xDamageOoT)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x40") }
            elseif (CheckCheckBox -CheckBox $2xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x80") }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0xC0") }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x10", "0x80", "0x43")
        }
        elseif (CheckCheckBox -CheckBox $QuarterRecoveryOoT) {                
            if (CheckCheckBox -CheckBox $1xDamageOoT)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0x80") }
            elseif (CheckCheckBox -CheckBox $2xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x80", "0xC0") }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x00") }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x40") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x10", "0x80", "0x83")

        }
        elseif (CheckCheckBox -CheckBox $NoRecoveryOoT) {                
            if (CheckCheckBox -CheckBox $1xDamageOoT)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x40") }
            elseif (CheckCheckBox -CheckBox $2xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0x80") }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x81", "0xC0") }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8096" -Values @("0x82", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xAE8099" -Values @("0x10", "0x81", "0x43")
        }
    }



    # TEXT DIALOGUE SPEED #

    if (CheckCheckBox -CheckBox $2xTextOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB5006F" -Values @("0x02") }
    elseif (CheckCheckBox -CheckBox $3xTextOoT) {
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

    if (CheckCheckBox -CheckBox $WideScreenOoT)        { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB08038" -Values @("0x3C", "0x07", "0x3F", "0xE3") }
    if (CheckCheckBox -CheckBox $ExtendedDrawOoT)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xA9A970" -Values @("0x00", "0x01") }
    if (CheckCheckBox -CheckBox $ForceHiresModelOoT)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBE608B" -Values @("0x00") }

    if (CheckCheckBox -CheckBox $BlackBarsOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F5A4" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F5D4" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F5E4" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F680" -Values @("0x00", "0x00","0x00", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB0F688" -Values @("0x00", "0x00","0x00", "0x00")
    }


    
    # EQUIPMENT #

    if (CheckCheckBox -CheckBox $ReducedItemCapacityOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC2F" -Values @("0x14", "0x19", "0x1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC37" -Values @("0x0A", "0x0F", "0x14") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC57" -Values @("0x14", "0x19", "0x1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC5F" -Values @("0x05", "0x0A", "0x0F") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC67" -Values @("0x0A", "0x0F", "0x14") -Increment 2
    }
    elseif (CheckCheckBox -CheckBox $IncreasedIemCapacityOOT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC2F" -Values @("0x28", "0x46", "0x63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC37" -Values @("0x1E", "0x37", "0x50") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC57" -Values @("0x28", "0x46", "0x63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC5F" -Values @("0x0F", "0x1E", "0x2D") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xB6EC67" -Values @("0x1E", "0x37", "0x50") -Increment 2
    }

    if (CheckCheckBox -CheckBox $UnlockSwordOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77AD" -Values @("0x09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77F7" -Values @("0x09")
    }

    if (CheckCheckBox -CheckBox $UnlockTunicsOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77B6" -Values @("0x09", "0x09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77FE" -Values @("0x09", "0x09")
    }

    if (CheckCheckBox -CheckBox $UnlockBootsOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC77BA" -Values @("0x09", "0x09")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBC7801" -Values @("0x09", "0x09")
    }



    # OTHER #

    if (CheckCheckBox -CheckBox $MedallionsOoT)            { PatchBytesSequence -File $DecompressedROMFile -Offset "0xE2B454" -Values @("0x80", "0xEA", "0x00", "0xA7", "0x24", "0x01", "0x00", "0x3F", "0x31", "0x4A", "0x00", "0x3F", "0x00", "0x00", "0x00", "0x00") }
    if (CheckCheckBox -CheckBox $DisableLowHPSoundOoT)     { PatchBytesSequence -File $DecompressedROMFile -Offset "0xADBA1A" -Values @("0x00", "0x00") }
    if (CheckCheckBox -CheckBox $DisableNaviooT)           { PatchBytesSequence -File $DecompressedROMFile -Offset "0xDF8B84" -Values @("0x00", "0x00", "0x00", "0x00") }
    if (CheckCheckBox -CheckBox $HideDPadOOT)              { PatchBytesSequence -File $DecompressedROMFile -Offset "0x348086E" -Values @("0x00") }

    if (CheckCheckBox -CheckBox $ReturnChildOoT) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xCB6844" -Values @("0x35")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0x253C0E2" -Values @("0x03")
    }

}



#==============================================================================================================================================================================================
function PatchReduxMM() {
    
    # HERO MODE #

    if (CheckCheckBox -CheckBox $OHKOModeMM) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABE7F" -Values @("0x09", "0x04") -Increment 16
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x2A", "0x00")
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x00", "0x00", "0x00")
    }
    elseif (!(CheckCheckBox -CheckBox $1xDamageMM) -and !(CheckCheckBox -CheckBox $NormalRecoveryMM)) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABE7F" -Values @("0x09", "0x04") -Increment 16
        if (CheckCheckBox -CheckBox $NormalRecoveryMM) {
            if (CheckCheckBox -CheckBox $2xDamageMM)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x40") }
            elseif (CheckCheckBox -CheckBox $4xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x80") }
            elseif (CheckCheckBox -CheckBox $8xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0xC0") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x00", "0x00", "0x00")
        }
        elseif (CheckCheckBox -CheckBox $HalfRecoveryMM) {
            if (CheckCheckBox -CheckBox $1xDamageMM)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x40") }
            elseif (CheckCheckBox -CheckBox $2xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x80") }
            elseif (CheckCheckBox -CheckBox $4xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0xC0") }
            elseif (CheckCheckBox -CheckBox $8xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x05", "0x28", "0x43")
        }
        elseif (CheckCheckBox -CheckBox $QuarterRecoveryMM) {
            if (CheckCheckBox -CheckBox $1xDamageMM)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0x80") }
            elseif (CheckCheckBox -CheckBox $2xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x28", "0xC0") }
            elseif (CheckCheckBox -CheckBox $4xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x00") }
            elseif (CheckCheckBox -CheckBox $8xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x40") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x05", "0x28", "0x83")
        }
        elseif (CheckCheckBox -CheckBox $NoRecoveryMM) {
            if (CheckCheckBox -CheckBox $1xDamageMM)       { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x40") }
            elseif (CheckCheckBox -CheckBox $2xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0x80") }
            elseif (CheckCheckBox -CheckBox $4xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x29", "0xC0") }
            elseif (CheckCheckBox -CheckBox $8xDamageMM)   { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA2" -Values @("0x2A", "0x00") }
            PatchBytesSequence -File $DecompressedROMFile -Offset "0xBABEA5" -Values @("0x05", "0x29", "0x43")
        }
    }



    # D-PAD #

    if (CheckCheckBox -CheckBox $LeftDPadMM)               { PatchBytesSequence -File $DecompressedROMFile -Offset "0x3806365" -Values @("0x01") }
    elseif (CheckCheckBox -CheckBox $RightDPadMM)          { PatchBytesSequence -File $DecompressedROMFile -Offset "0x3806365" -Values @("0x02") }
    elseif (CheckCheckBox -CheckBox $HideDPadMM)           { PatchBytesSequence -File $DecompressedROMFile -Offset "0x3806365" -Values @("0x00") }



    # GRAPHICS #

    if (CheckCheckBox -CheckBox $WideScreenMM)             { PatchBytesSequence -File $DecompressedROMFile -Offset "0xCA58F5" -Values @("0x6C", "0x53", "0x6C", "0x84", "0x9E", "0xB7", "0x53", "0x6C") -Increment 2 }
    if (CheckCheckBox -CheckBox $ExtendedDrawMM)           { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB50874" -Values @("0x00", "0x00", "0x00", "0x00") }
    if (CheckCheckBox -CheckBox $BlackBarsMM)              { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBF72A4" -Values @("0x00", "0x00", "0x00", "0x00") }
    if (CheckCheckBox -CheckBox $PixelatedStarsMM)         { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB943FC" -Values @("0x10", "0x00") }



    # EQUIPMENT #

    if (CheckCheckBox -CheckBox $ReducedItemCapacityMM) {
        PatchBytesSequence -File $DecompressedROMFile "0xC5834F" -Values @("0x14", "0x19", "0x1E") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58357" -Values @("0x0A", "0x0F", "0x14") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC5837F" -Values @("0x05", "0x0A", "0x0F") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58387" -Values @("0x0A", "0x0F", "0x14") -Increment 2
    }
    elseif (CheckCheckBox -CheckBox $IncreasedIemCapacityMM) {
        PatchBytesSequence -File $DecompressedROMFile "0xC5834F" -Values @("0x28", "0x46", "0x63") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58357" -Values @("0x1E", "0x37", "0x50") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC5837F" -Values @("0x0F", "0x1E", "0x2D") -Increment 2
        PatchBytesSequence -File $DecompressedROMFile "0xC58387" -Values @("0x1E", "0x37", "0x50") -Increment 2
    }

    if (CheckCheckBox -CheckBox $RazorSwordMM) {
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xCBA496" -Values @("0x00", "0x00") # Prevent losing hits
        PatchBytesSequence -File $DecompressedROMFile -Offset "0xBDA6B7" -Values @("0x01")         # Keep sword after Song of Time
    }



    # OTHER #
    
    if (CheckCheckBox -CheckBox $DisableLowHPSoundMM)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xB97E2A" -Values @("0x00", "0x00") }
    if (CheckCheckBox -CheckBox $PieceOfHeartSoundMM)      { PatchBytesSequence -File $DecompressedROMFile -Offset "0xBA94C8" -Values @("0x10", "0x00") }

}


#==============================================================================================================================================================================================
function ExtendROM() {
    
    if ($GameType -ne "Majora's Mask") { return }

    $Bytes = @(08, 00, 00, 00)
    $ByteArray = [IO.File]::ReadAllBytes($ROMFile)
    [io.file]::WriteAllBytes($ROMFile, $Bytes + $ByteArray)

    $ByteArray = $null

}



#==============================================================================================================================================================================================
function CheckGameID() {
    
    # Return if freely patching, injecting or extracting
    if ($GameType -eq "Free" -or $GetCommand -eq "Inject" -or $GetCommand -eq "Extract" -or $GetCommand -eq "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabel -Text "Checking GameID in .tmd..."

    # Get the ".tmd" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.tmd)
    
    $CompareArray = $null

    if ($GameType -eq "Ocarina of Time")      { $CompareArray = @(78, 65, 67, 69) }
    elseif ($GameType -eq "Majora's Mask")    { $CompareArray = @(78, 65, 82, 69) }
    elseif ($GameType -eq "Super Mario 64")   { $CompareArray = @(78, 65, 65, 69) }
    elseif ($GameType -eq "Paper Mario 64")   { $CompareArray = @(78, 65, 69, 69) }

    $CompareAgainst = $ByteArray[400..(403)]

    # Check each value of the array.
    for ($i=0; $i-le 4; $i++) {
        # The current values do not match
        if ($CompareArray[$i] -ne $CompareAgainst[$i]) {
            # This is not a "NACE", "NARE", "NAAE" or "NAEE" entry.
            UpdateStatusLabel -Text ("Failed! This is not an vanilla " + $GameType + " USA VC WAD file.")
            # Stop wasting time.
            return $False
        }
    }

    $CompareArray = $null
    $CompareAgainst = $null

    return $True

}



#==============================================================================================================================================================================================
function SetCustomGameID() {
    
    if (!$InputCustomGameIDCheckbox.Checked)                                          { return }
    if ($InputCustomGameIDTextbox.TextLength -eq 4)                                   { $global:GameID = $InputCustomGameIDTextBox.Text }
    if ($InputCustomChannelTitleTextBox.TextLength -gt 0)                             { $global:ChannelTitle = $InputCustomChannelTitleTextBox.Text }

}



#==============================================================================================================================================================================================
function HackOpeningBNRTitle() {
    
    # Set the status label.
    UpdateStatusLabel -Text "Hacking in Opening.bnr custom title..."

    # Get the "00000000.app" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile00)

    # Initially assume the two chunks of data are identical.
    $Identical = $true

    $Start = 0

    $CompareArray = $ByteArray[(GetDecimal -Hex "0xF1")..((GetDecimal -Hex "0xF1") + $GameTitleLength)]

    # Scan only the contents of the IMET header within the file.
    for ($i=(GetDecimal -Hex "0x80"); $i-lt (GetDecimal -Hex "0x62F"); $i++) {
        $CompareAgainst = $ByteArray[$i..($i + $GameTitleLength)]

        $Matches = $True
        for ($j=0; $j -lt $CompareAgainst.Length; $j++) {
            if ($CompareAgainst[$j] -notcontains $CompareArray[$j]) { $Matches = $False }
        }

        if ($Matches -eq $True) {
            for ($j=0; $j-lt $GameTitleLength; $j++) { $ByteArray[$i + ($j*2)] = 0 }
            for ($j=0; $j-lt $ChannelTitle.Length; $j++) { $ByteArray[$i + ($j*2)] = [int][char]$ChannelTitle.Substring($j, 1) }
            $i += $GameTitleLength
        }        
    }

    # Overwrite the patch file with the extended file.
    [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)
    $ByteArray = $null

}



#==============================================================================================================================================================================================
function HackN64GameTitle {
    
    $emptyTitle = foreach ($i in 1..$GameTitleLength) { 32 }
    PatchBytesSequence -File $PatchedROMFile -Offset "0x20" -Values $emptyTitle
    PatchBytesSequence -File $PatchedROMFile -Offset "0x20" -Values ($ChannelTitle.ToUpper().ToCharArray() | % { [int][char]$_ }) -IsDec $True
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
function RepackWADFile() {
    
    # Set the status label.
    UpdateStatusLabel -Text "Repacking patched WAD file..."
    
    # Loop through all files in the extracted WAD folder.
    foreach($File in Get-ChildItem -LiteralPath $WadFile.Folder -Force) {
        # Move the file to the same folder as the unpacker tool.
        DeleteFile -File ($WiiVCPath + "\" + $File.Name)
        Move-Item -LiteralPath $File.FullName -Destination $WiiVCPath
        
        # Create an entry for the database.
        $ListEntry = $RepackPath + '\' + $File.Name
        
        # Some files need to be fed into the tool so keep track of them.
        switch ($File.Extension) {
            '.tik'  { $tik  = $WiiVCPath + '\' + $File.Name }
            '.tmd'  { $tmd  = $WiiVCPath + '\' + $File.Name }
            '.cert' { $cert = $WiiVCPath + '\' + $File.Name }
        }
    }

    # We need to be in the same path as some files so just jump there.
    Push-Location $WiiVCPath

    # Repack the WAD using the new files.
    & $Files.wadpacker $tik $tmd $cert $WadFile.Patched '-sign' '-i' $global:GameID

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
function EnablePatchButtons([boolean]$Enable) {
    
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
function WADPath_Finish([object]$TextBox, [string]$VarName, [string]$WADPath) {
    
    # Set the "GameWAD" variable that tracks the path.
    Set-Variable -Name $VarName -Value $WADPath -Scope 'Global'
    $global:WADFilePath =  $WADPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $WADPath

    EnablePatchButtons -Enable $True
    SetWiiVCMode -Bool $True

    # Check if both a .WAD and .Z64 have been provided for ROM injection
    if ($global:Z64FilePath -ne $null) { $InjectROMButton.Enabled = $true }

    # Check if both a .WAD and .BPS have been provided for BPS patching
    if ($global:BPSFilePath -ne $null) { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_Finish([object]$TextBox, [string]$VarName, [string]$Z64Path) {
    
    # Set the "Z64 ROM" variable that tracks the path.
    Set-Variable -Name $VarName -Value $Z64Path -Scope 'Global'
    $global:Z64FilePath =  $Z64Path

    #Write-Host (Get-FileHash -Algorithm SHA256 $Z64Path).Hash

    # Update the textbox to the current WAD.
    $TextBox.Text = $Z64Path

    if (!$IsWiiVC) { EnablePatchButtons -Enable $true }
    
    # Check if both a .WAD and .Z64 have been provided for ROM injection or both a .Z64 and .BPS have been provided for BPS patching
    if ($WADFilePath -ne $null -and $IsWiiVC)        { $InjectROMButton.Enabled = $true }
    elseif ($BPSFilePath -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Finish([object]$TextBox, [string]$VarName, [string]$BPSPath) {
    
    # Set the "BPS File" variable that tracks the path.
    Set-Variable -Name $VarName -Value $BPSPath -Scope 'Global'
    $global:BPSFilePath =  $BPSPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $BPSPath

    # Check if both a .WAD and .BPS have been provided for BPS patching
    if ($WADFilePath -ne $null -and $IsWiiVC)       { $PatchBPSButton.Enabled = $true }
    elseif ($Z64FilePath -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function WADPath_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
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
        $DroppedPath = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
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
        $DroppedPath = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a BPS File.
            if ($DroppedExtn -eq '.bps' -or $DroppedExtn -eq '.ips') {
                # Finish everything up.
                BPSPath_Finish -TextBox $InputBPSTextBox -VarName $this.Name -BPSPath $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function WADPath_Button([object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $BasePath -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        WADPath_Finish -TextBox $TextBox -VarName $this.Name -WADPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_Button([object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $BasePath -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        Z64Path_Finish -TextBox $TextBox -VarName $this.Name -Z64Path $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Button([object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $BasePath -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        BPSPath_Finish -TextBox $TextBox -VarName $this.Name -BPSPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([string]$Hex) {
    
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
    $global:InputWADButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameWAD" -Text "..." -Info "Select your VC WAD File using file explorer" -AddTo $InputWADGroup
    $InputWADButton.Add_Click({ WADPath_Button -TextBox $InputWADTextBox -Description 'VC WAD File' -FileName '*.wad' })

    # Create a button to clear the WAD Path
    $global:ClearWADPathButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Clear" -Info "Clear the selected WAD file" -AddTo $InputWADGroup
    $ClearWADPathButton.Add_Click({
        if ($WADFilePath.Length -gt 0) {
            $global:WADFilePath = $null
            $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
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
    $global:InputROMButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameZ64" -Text "..." -Info "Select your Z64, N64 or V64 ROM File using file explorer" -AddTo $InputROMGroup
    $InputROMButton.Add_Click({ z64Path_Button -TextBox $InputROMTextBox -Description @('Z64 ROM', 'N64 ROM', 'V64 ROM') -FileName @('*.z64', '*.n64', '*.v64') })
    
    # Create a button to allow patch the WAD with a ROM file.
    $global:InjectROMButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Inject ROM" -Info "Replace the ROM in your selected WAD File with your selected Z64, N64 or V64 ROM File" -AddTo $InputROMGroup
    $InjectROMButton.Add_Click({ MainFunction -Command "Inject" -PatchedFile '_injected' })



    ############
    # BPS Path #
    ############
    
    # Create the panel that holds the BPS path.
    $global:InputBPSPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the BPS path.
    $InputBPSGroup = CreateGroupBox -Width $InputBPSPanel.Width -Height $InputBPSPanel.Height -Name "GameBPS" -Text "BPS Path" -AddTo $InputBPSPanel
    $InputBPSGroup.AllowDrop = $true
    $InputBPSGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSGroup.Add_DragDrop({ BPSPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $global:InputBPSTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameBPS" -Text "Select or drag and drop your BPS or IPS Patch File..." -AddTo $InputBPSGroup
    $InputBPSTextBox.AllowDrop = $true
    $InputBPSTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSTextBox.Add_DragDrop({ BPSPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $global:InputBPSButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameBPS" -Text "..." -Info "Select your BPS or IPS Patch File using file explorer" -AddTo $InputBPSGroup
    $InputBPSButton.Add_Click({ BPSPath_Button -TextBox $InputBPSTextBox -Description @('BPS Patch File', 'IPS Patch File') -FileName @('*.bps', '*.ips') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $global:PatchBPSButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Patch BPS" -Info "Patch the ROM with your selected BPS or IPS Patch File" -AddTo $InputBPSGroup
    $PatchBPSButton.Add_Click({ MainFunction -Command "Patch BPS" -Patch $BPSFilePath -PatchedFile '_bps_patched' })



    ################
    # Current Game #
    ################

    # Create the panel that holds the current game options.
    $global:CurrentGamePanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the current game options
    $CurrentGameGroup = CreateGroupBox -Width $CurrentGamePanel.Width -Height $CurrentGamePanel.Height -Text "Current Game Mode" -AddTo $CurrentGamePanel

    # Create a combox for OoT ROM hack patches
    #$Items = ("The Legend of Zelda: Ocarina of Time", "The Legend of Zelda: Majora's Mask", "Super Mario 64", "Paper Mario", "Free Mode (Nintendo 64)")

    if (Test-Path -LiteralPath $Files.Games -PathType Leaf)   { $global:GamesJSONFile = Get-Content -Raw -Path $Files.Games | ConvertFrom-Json }

    $Items = @()
    Foreach ($i in $GamesJSONFile.game) { $Items += $i.title }

    $global:CurrentGameComboBox = CreateComboBox -X 10 -Y 20 -Width 440 -Height 30 -Items $Items -AddTo $CurrentGameGroup
    $CurrentGameComboBox.Add_SelectedIndexChanged({
        for ($i=0; $i -lt $GamesJSONFile.game.length; $i++) {
            if ($GamesJSONFile.game[$i].title -eq $CurrentGameComboBox.Text) {
                $Item = $i
            }
        }
        ChangeGameMode -Mode $GamesJSONFile.game[$Item].mode
    })
    


    ##################
    # Custom Game ID #
    ##################

    # Create the panel that holds the Custom GameID.
    $global:CustomGameIDPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the Custom GameID.
    $CustomGameIDGroup = CreateGroupBox -Width $CustomGameIDPanel.Width -Height $CustomGameIDPanel.Height -Name "CustomGameID" -Text "Custom Channel Title and GameID" -AddTo $CustomGameIDPanel

    # Create a label to show Custom Channel Title description.
    $global:InputCustomChannelTitleTextBoxLabel = CreateLabel -X 8 -Y 22 -Width 75 -Height 15 -Text "Channel Title:" -AddTo $CustomGameIDGroup

    # Create a textbox to display the selected Custom Channel Title.
    $global:InputCustomChannelTitleTextBox = CreateTextBox -X 85 -Y 20 -Width 260 -Height 22 -Name "CustomGameID" -AddTo $CustomGameIDGroup
    $InputCustomChannelTitleTextBox.Add_TextChanged({
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

    # Create combobox
    $global:PatchComboBox = CreateComboBox -X $PatchButton.Left -Y ($PatchButton.Top - 25) -Width $PatchButton.Width -Height 30 -AddTo $PatchGroup

    # Create a checkbox to enable Redux support.
    $global:PatchReduxLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchButton.Top + 10) -Width 40 -Height 15 -Text "Redux:" -Info "Include the Redux patch on for the translation patches" -AddTo $PatchGroup
    $global:PatchReduxCheckbox = CreateCheckBox -X $PatchReduxLabel.Right -Y ($PatchReduxLabel.Top - 2) -Width 20 -Height 20 -Info "Include the Redux patch on for the translation patches" -AddTo $PatchGroup

    $global:PatchReduxButton = CreateButton -X ($PatchGroup.Right - 170) -Y 20 -Width 150 -Height 55 -Text "Additional Redux Options" -AddTo $PatchGroup



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
    $global:PatchVCRemoveT64Label = CreateLabel -X ($PatchVCCoreLabel.Right + 20) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remove All T64:" -Info "Remove all injected T64 format textures" -AddTo $PatchVCGroup
    $global:PatchVCRemoveT64 = CreateCheckBox -X $PatchVCRemoveT64Label.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -Info "Remove all injected T64 format textures" -AddTo $PatchVCGroup
    $PatchVCRemoveT64.Add_CheckStateChanged({ CheckForCheckboxes })
    
    # Expand Memory
    $global:PatchVCExpandMemoryLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Expand Memory:" -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $global:PatchVCExpandMemory = CreateCheckBox -X $PatchVCExpandMemoryLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $PatchVCExpandMemory.Add_CheckStateChanged({ CheckForCheckboxes })

    # Remap D-Pad
    $global:PatchVCRemapDPadLabel = CreateLabel -X ($PatchVCExpandMemory.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remap D-Pad:" -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $global:PatchVCRemapDPad = CreateCheckBox -X $PatchVCRemapDPadLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $PatchVCRemapDPad.Add_CheckStateChanged({ CheckForCheckboxes })

    # Downgrade
    $global:PatchVCDowngradeLabel = CreateLabel -X ($PatchVCRemapDPad.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Downgrade:" -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $global:PatchVCDowngrade = CreateCheckBox -X $PatchVCDowngradeLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $PatchVCDowngrade.Add_CheckStateChanged({ CheckForCheckboxes })



    # Create a label for Minimap
    $global:PatchVCMinimapLabel = CreateLabel -X 10 -Y ($PatchVCCoreLabel.Bottom + 5) -Width 50 -Height 15 -Text "Minimap" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remap C-Down
    $global:PatchVCRemapCDownLabel = CreateLabel -X ($PatchVCMinimapLabel.Right + 20) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap C-Down:" -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapCDown = CreateCheckBox -X $PatchVCRemapCDownLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $PatchVCRemapCDown.Add_CheckStateChanged({ CheckForCheckboxes })

    # Remap Z
    $global:PatchVCRemapZLabel = CreateLabel -X ($PatchVCRemapCDown.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap Z:" -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapZ = CreateCheckBox -X $PatchVCRemapZLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $PatchVCRemapZ.Add_CheckStateChanged({ CheckForCheckboxes })

    # Leave D-Pad Up
    $global:PatchVCLeaveDPadUpLabel = CreateLabel -X ($PatchVCRemapZ.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Leave D-Pad Up:" -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $global:PatchVCLeaveDPadUp = CreateCheckBox -X $PatchVCLeaveDPadUpLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $PatchVCLeaveDPadUp.Add_CheckStateChanged({ CheckForCheckboxes })



    # Create a label for Patch VC Buttons
    $global:ActionsLabel = CreateLabel -X 10 -Y 72 -Width 50 -Height 15 -Text "Actions" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Create a button to patch the VC
    $global:PatchVCButton = CreateButton -X 80 -Y 65 -Width 150 -Height 30 -Text "Patch VC Emulator Only" -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted" -AddTo $PatchVCGroup
    $PatchVCButton.Add_Click({ MainFunction -Command "Patch VC" -Patch $BPSFilePath -PatchedFile '_vc_patched' })

    # Create a button to extract the ROM
    $global:ExtractROMButton = CreateButton -X 240 -Y 65 -Width 150 -Height 30 -Text "Extract ROM Only" -Info "Only extract the .Z64 ROM from the WAD file`nUseful for native N64 emulators" -AddTo $PatchVCGroup
    $ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -Patch $BPSFilePath -PatchedFile '_extracted' })



    ##############
    # Misc Panel #
    ##############

    # Create a panel to contain everything for other.
    $global:MiscPanel = CreatePanel -Width 625 -Height 75 -AddTo $MainDialog

    # Create a groupbox to show the misc buttons.
    $global:MiscGroup = CreateGroupBox -Width 590 -Height $MiscPanel.Height -Text "Other Buttons" -AddTo $MiscPanel

    # Create a button to show info about which GameID to use.
    $InfoGameIDButton = CreateButton -X 75 -Y 25 -Width 100 -Height 35 -Text "GameID's" -Info "Open the list with official, used and recommend GameID values to refer to" -AddTo $MiscGroup
    $InfoGameIDButton.Add_Click({ $InfoGameIDDialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoButton = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Info              Ocarina of Time" -Info "Open the list with information about the Ocarina of Time patching mode" -AddTo $MiscGroup
    $InfoButton.Add_Click({ $InfoDialog.ShowDialog() | Out-Null })

    # Create a button to show credits about the patches.
    $CreditsButton = CreateButton -X ($InfoButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Credits" -Info ("Open the list with credits of all of patches involved and those who helped with the " + $ScriptName + " tool") -AddTo $MiscGroup
    $CreditsButton.Add_Click({ $CreditsDialog.ShowDialog() | Out-Null })

    # Create a button to close the dialog.
    $global:ExitButton = CreateButton -X ($CreditsButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Exit" -Info ("Close the " + $ScriptName + " tool") -AddTo $MiscGroup
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
function ChangePatchPanel() {
    
    $PatchGroup.text = $GameType + " - Patch Options"

    # Reset
    $PatchComboBox.Items.Clear()
    if ($global:ClickPatchButtonEvent -ne $null) { $PatchButton.Remove_Click($global:ClickPatchButtonEvent) }
    if ($global:ChangeComboBoxEvent -ne $null) { $PatchComboBox.Remove_SelectedIndexChanged($global:ChangeComboBoxEvent) }

    # Stop here if Patchs.JSON file not present
    if ($PatchesJSONFile -eq $null) { return }

    # Assign patch button click
    $global:ClickPatchButtonEvent = {
        for ($i=0; $i -lt $PatchesJSONFile.patch.length; $i++) {
            if ($PatchesJSONFile.patch[$i].title -eq $PatchComboBox.Text) { $Item = $i }
        }

        if ($PatchesJSONFile.patch[$Item].redux -eq 0)        { $Redux = $PatchReduxCheckbox.Checked }
        elseif ($PatchesJSONFile.patch[$Item].redux -eq 1)    { $Redux = $True }
        else                                                  { $Redux = $False }

        if (!$IsWiiVC) {
            $Id = $PatchesJSONFile.patch[$Item].n64_gameID
            $Title = $PatchesJSONFile.patch[$Item].n64_title
        }
        else {
            $Id = $PatchesJSONFile.patch[$Item].wii_gameID
            $Title = $PatchesJSONFile.patch[$Item].wii_title
        }

        if ($PatchesJSONFile.patch[$Item].bps.Length -gt 4)   { $Patch = $MasterPath + "\" + $GameType + $PatchesJSONFile.patch[$Item].bps }
        else                                                  { $Patch = $null }

        $Command = $PatchesJSONFile.patch[$Item].command
        $PatchedFile = $PatchesJSONFile.patch[$Item].output
        $Hash = $PatchesJSONFile.patch[$Item].hash

        MainFunction -Command $Command -Redux $Redux -Id $Id -Title $Title -Patch $Patch -PatchedFile $PatchedFile -Hash $Hash
    }
    $PatchButton.Add_Click($ClickPatchButtonEvent)

    # Set combobox for patches
    $Items = @()
    $FirstItem = 0
    for ($i=0; $i -lt $PatchesJSONFile.patch.length; $i++) {
        if ( ($IsWiiVC -and $PatchesJSONFile.patch[$i].console -eq "Wii VC") -or (!$IsWiiVC -and $PatchesJSONFile.patch[$i].console -eq "N64") -or ($PatchesJSONFile.patch[$i].console -eq "All") ) {
            $Items += $PatchesJSONFile.patch[$i].title
            if ($FirstItem -eq 0) { $FirstItemIndex = $i }
        }
        $ToolTip.SetToolTip($PatchButton, ([String]::Format($PatchesJSONFile.patch[$FirstItem].tooltip, [Environment]::NewLine)))
    }

    
    $PatchComboBox.Items.AddRange($Items)
    if ($Items.Length -gt 0)   { $PatchComboBox.SelectedIndex = 0 }
    else                       { $PatchComboBox.SelectedIndex = -1 }

    $global:ChangeComboBoxEvent = {
        for ($i=0; $i -lt $PatchesJSONFile.patch.length; $i++) {
            if ($PatchesJSONFile.patch[$i].title -eq $PatchComboBox.Text) { $Item = $i }
        }

        $PatchReduxCheckbox.Enabled = $PatchesJSONFile.patch[$Item].redux -eq 0
        $ToolTip.SetToolTip($PatchButton, ([String]::Format($PatchesJSONFile.patch[$Item].tooltip, [Environment]::NewLine)))
    }
    $PatchComboBox.Add_SelectedIndexChanged($global:ChangeComboBoxEvent)

    if ($global:ClickPatchReduxButtonEvent -ne $null)   { $PatchReduxButton.Remove_Click($global:ClickPatchReduxButtonEvent) }
    if ($GameType -eq "Ocarina of Time")                { $global:ClickPatchReduxButtonEvent = { $OoTReduxOptionsDialog.ShowDialog() } }
    elseif ($GameType -eq "Majora's Mask")              { $global:ClickPatchReduxButtonEvent = { $MMReduxOptionsDialog.ShowDialog() } }
    $PatchReduxButton.Add_Click($ClickPatchReduxButtonEvent)

    if ($GameType -eq "Ocarina of Time" -or $GameType -eq "Majora's Mask")   { $ToolTip.SetToolTip($PatchReduxButton, "Toggle additional features for the " + $GameType +  " REDUX romhack") }

    $PatchReduxButton.Visible = $PatchReduxCheckbox.Visible = $PatchReduxLabel.Visible = ($GameType -eq "Ocarina of Time" -or $GameType -eq "Majora's Mask")

}



#==============================================================================================================================================================================================
function SetMainScreenSize() {
    
    if ($IsWiiVC) {
        $InputCustomChannelTitleTextBoxLabel.Text = "Channel Title:"
        if ($GameType -ne "Free")   { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchPanel.Bottom + 5)) }
        else                        { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($CurrentGamePanel.Bottom + 5)) }
        $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchVCPanel.Bottom + 5))
    }

    else {
        $InputCustomChannelTitleTextBoxLabel.Text = "Game Title:"
        if ($GameType -ne "Free")   { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchPanel.Bottom + 5)) }
        else                        { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5)) }
    }

    $StatusPanel.Location = New-Object System.Drawing.Size(10, ($MiscPanel.Bottom + 5))
    $MainDialog.Height = ($StatusPanel.Bottom + 50)

}


#==============================================================================================================================================================================================
function ChangeGameMode([string]$Mode) {
    
    $global:GameType = $Mode

    $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $False
    $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $False
    $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $False
    
    $PatchVCMinimapLabel.Hide()
    $PatchVCRemapCDown.Visible = $PatchVCRemapCDownLabel.Visible = $False
    $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $False
    $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $False
 
    if ($GameType -eq "Ocarina of Time") {
        $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $True
        AddTextFileToTexTbox -TextBox $InfoTextbox -File $Files.text_info_oot
        $InfoDialog.Icon = $Icons.OcarinaOfTime
    }
    elseif ($GameType -eq "Majora's Mask")    {
        AddTextFileToTexTbox -TextBox $InfoTextbox -File $Files.text_info_mm
        $InfoDialog.Icon = $Icons.MajorasMask
    }
    elseif ($GameType -eq "Super Mario 64") {
        AddTextFileToTexTbox -TextBox $InfoTextbox -File $Files.text_info_sm64
        $InfoDialog.Icon = $Icons.SuperMario64
    }
    elseif ($GameType -eq "Paper Mario")      {
        AddTextFileToTexTbox -TextBox $InfoTextbox -File $Files.text_info_pp
        $InfoDialog.Icon = $Icons.PaperMario
    }
    elseif ($GameType -eq "Free") {
        AddTextFileToTexTbox -TextBox $InfoTextbox -File $Files.text_info_free
        $InfoDialog.Icon = $Icons.Free
    }

    if ($GameType -ne "Free" -and (Test-Path -LiteralPath ($MasterPath + "\" + $GameType + "\Patches.json") -PathType Leaf))   { $global:PatchesJSONFile = Get-Content -Raw -Path ($MasterPath + "\" + $GameType + "\Patches.json") | ConvertFrom-Json }
    else                                                                                                                       { $global:PatchesJSONFile = $null }

    $ToolTip.SetToolTip($InfoButton, "Open the list with information about the " + $GameType + " patching mode")
    $InfoButton.Text = "Info                " + $GameType
    $PatchPanel.Visible = ($GameType -ne "Free")

    if ($GameType -eq "Ocarina of Time" -or $GameType -eq "Majora's Mask") {
        $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $True
        $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $True
        $PatchVCMinimapLabel.Show() 
        $PatchVCRemapCDownLabel.Visible = $PatchVCRemapCDown.Visible = $True
        $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $True
    }

    SetWiiVCMode -Bool $IsWiiVC
    CheckForCheckboxes
    
}



#==============================================================================================================================================================================================
function ResetGameID() {

    if ($GameType -eq "Ocarina of Time" -and $IsWiiVC) {
        $global:GameID = "NACE"
        $global:ChannelTitle = "Zelda: Ocarina"
    }
    elseif ($GameType -eq "Majora's Mask" -and $IsWiiVC) {
        $global:GameID = "NARE"
        $global:ChannelTitle = "Zelda: Majora's"
    }
    elseif ($GameType -eq "Super Mario 64" -and $IsWiiVC) {
        $global:GameID = "NAAE"
        $global:ChannelTitle = "Super Mario 64"
    }
    elseif ($GameType -eq "Paper Mario" -and $IsWiiVC) {
        $global:GameID = "NAEE"
        $global:ChannelTitle = "Paper Mario"
        
    }
    elseif ($GameType -eq "Free" -and $IsWiiVC) {
        $global:GameID = "CUST"
        $global:ChannelTitle = "Custom Channel"
    }

    elseif ($GameType -eq "Ocarina of Time" -and !$IsWiiVC) {
        $global:GameID = "CZLE"
        $global:ChannelTitle = "THE LEGEND OF ZELDA"
    }
    elseif ($GameType -eq "Majora's Mask" -and !$IsWiiVC) {
        $global:GameID = "NZSE"
        $global:ChannelTitle = "ZELDA MAJORA'S MASK"
    }
    elseif ($GameType -eq "Super Mario 64" -and !$IsWiiVC) {
        $global:GameID = "NSME"
        $global:ChannelTitle = "SUPER MARIO 64"
    }
    elseif ($GameType -eq "Paper Mario" -and !$IsWiiVC) {
        $global:GameID = "NMQE"
        $global:ChannelTitle = "PAPER MARIO"
    }
    elseif ($GameType -eq "Free" -and !$IsWiiVC) {
        $global:GameID = "CUST"
        $global:ChannelTitle = "CUSTOM NINTENDO 64"
    }

}



#==============================================================================================================================================================================================
function UpdateStatusLabel([string]$Text) {
    
    $StatusLabel.Text = $Text
    $StatusLabel.Refresh()

}



#==============================================================================================================================================================================================
function SetWiiVCMode([boolean]$Bool) {
    
    $InjectROMButton.Visible = $PatchVCPanel.Visible = $Bool

    $global:IsWiiVC = $Bool
    if ($Bool)   {
        EnablePatchButtons -Enable ($WADFilePath -ne $null)
        $global:GameTitleLength = 40
    }
    else {
        EnablePatchButtons -Enable ($Z64FilePath -ne $null)
        $global:GameTitleLength = 20
    }
    
    $InputCustomChannelTitleTextBox.MaxLength = $GameTitleLength
    $ClearWADPathButton.Enabled = ($WADFilePath.Length -gt 0)

    SetMainScreenSize
    ResetGameID
    SetModeLabel
    ChangePatchPanel

    $InputCustomChannelTitleTextBox.Text = $ChannelTitle
    $InputCustomGameIDTextBox.Text =  $GameID

}



#==============================================================================================================================================================================================
function SetModeLabel() {
	
    $CurrentModeLabel.Text = "Current  Mode  :  " + $GameType
    if ($IsWiiVC) { $CurrentModeLabel.Text += "  (Wii  VC)" } else { $CurrentModeLabel.Text += "  (N64)" }
    $CurrentModeLabel.Location = New-Object System.Drawing.Size(([Math]::Floor($MainDialog.Width / 2) - [Math]::Floor($CurrentModeLabel.Width / 2)), 10)

}



#==============================================================================================================================================================================================
function CheckBootDolOptions() {
    
    if ($GetCommand -eq "Patch Boot DOL")   { return $True }
    if ($GameType -eq "Ocarina of Time" -or $GameType -eq "Majora's Mask") {
        if ($PatchVCExpandMemory.Checked)   { return $True }
        if ($PatchVCRemapDPad.Checked)      { return $True }
        if ($PatchVCRemapCDown.Checked)     { return $True }
        if ($PatchVCRemapZ.Checked)         { return $True }
    }
    return $False

}



#==============================================================================================================================================================================================
function CheckForCheckboxes() {
    
    if (CheckCheckBox -CheckBox $PatchVCRemoveT64)          { $PatchVCButton.Enabled = $True }
    elseif (CheckCheckBox -CheckBox $PatchVCExpandMemory)   { $PatchVCButton.Enabled = $True }
    elseif (CheckCheckBox -CheckBox $PatchVCRemapDPad)      { $PatchVCButton.Enabled = $True }
    elseif (CheckCheckBox -CheckBox $PatchVCDowngrade)      { $PatchVCButton.Enabled = $True }
    elseif (CheckCheckBox -CheckBox $PatchVCRemapCDown)     { $PatchVCButton.Enabled = $True }
    elseif (CheckCheckBox -CheckBox $PatchVCRemapZ)         { $PatchVCButton.Enabled = $True }
    elseif (CheckCheckBox -CheckBox $PatchLeaveDPadUp)      { $PatchVCButton.Enabled = $True }
    else                                                    { $PatchVCButton.Enabled = $False }

}



#==============================================================================================================================================================================================
function CheckCheckBox([Object]$CheckBox) {
    
    if (($CheckBox.Checked) -and ($CheckBox.Enabled)) { return $True }
    return $False

}



#==============================================================================================================================================================================================
function CheckReduxOptions() {
    
    if ($GameType -eq "Ocarina of Time") {

        if ($2xDamageOoT.Checked)                                 { return $True }
        if ($4xDamageOoT.Checked)                                 { return $True }
        if ($8xDamageOoT.Checked)                                 { return $True }

        if ($HalfRecoveryOoT.Checked)                             { return $True }
        if ($QuarterRecoveryOoT.Checked)                          { return $True }
        if ($NoRecoveryOoT.Checked)                               { return $True }

        if ($2xTextOoT.Checked)                                   { return $True }
        if ($3xTextOoT.Checked)                                   { return $True }

        if ($WidescreenOoT.Checked)                               { return $True }
        if ($WidescreenTexturesOoT.Checked)                       { return $True }
        if ($ExtendedDrawOoT.Checked)                             { return $True }
        if ($BlackBarsOoT.Checked)                                { return $True }
        if ($ForceHiresModelOoT.Checked)                          { return $True }
        if ($MMModelsOoT.Checked)                                 { return $True }

        if ($ReducedItemCapacityOoT.Checked)                      { return $True }
        if ($IncreasedItemCapacityOoT.Checked)                    { return $True }
        if ($UnlockSwordOoT.Checked)                              { return $True }
        if ($UnlockTunicsOoT.Checked)                             { return $True }
        if ($UnlockBootsOoT.Checked)                              { return $True }

        if ($DisableLowHPSoundOoT.Checked)                        { return $True }
        if ($MedallionsOoT.Checked)                               { return $True }
        if ($ReturnChildOoT.Checked)                              { return $True }
        if ($DisableNaviOoT.Checked)                              { return $True }
        if ($HideDPadOoT.Checked -and $IncludeReduxOoT.Checked)   { return $True }

        if ($IncludeReduxOoT.Checked)                             { return $True }
    }

    elseif ($GameType -eq "Majora's Mask") {
        
        if ($2xDamageMM.Checked)                                  { return $True }
        if ($4xDamageMM.Checked)                                  { return $True }
        if ($8xDamageMM.Checked)                                  { return $True }

        if ($HalfRecoveryMM.Checked)                              { return $True }
        if ($QuarterRecoveryMM.Checked)                           { return $True }
        if ($NoRecoveryMM.Checked)                                { return $True }
        if ($LeftDPadMM.Checked -and $IncludeReduxMM.Checked)     { return $True }
        if ($HideDPadMM.Checked -and $IncludeReduxMM.Checked)     { return $True }

        if ($WidescreenMM.Checked)                                { return $True }
        if ($WidescreenTexturesMM.Checked)                        { return $True }
        if ($ExtendedDrawMM.Checked)                              { return $True }
        if ($BlackBarsMM.Checked)                                 { return $True }
        if ($PixelatedStarsMM.Checked)                            { return $True }

        if ($ReducedItemCapacityMM.Checked)                       { return $True }
        if ($IncreasedItemCapacityMM.Checked)                     { return $True }
        if ($RazorSwordMM.Checked)                                { return $True }

        if ($DisableLowHPSoundMM.Checked)                         { return $True }
        if ($PieceOfHeartSoundMM.Checked)                         { return $True }

        if ($IncludeReduxMM.Checked)                              { return $True }

    }

    return $False

}



#==============================================================================================================================================================================================
function CreateOcarinaOfTimeReduxOptionsDialog() {

    # Create Dialog
    $global:OoTReduxOptionsDialog = CreateDialog -Width 700 -Height 580 -Icon $Icons.OcarinaOfTimeRedux
    $CloseButton = CreateButton -X ($OoTReduxOptionsDialog.Width / 2 - 40) -Y ($OoTReduxOptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OoTReduxOptionsDialog
    $CloseButton.Add_Click({$OoTReduxOptionsDialog.Hide()})

    # Options Label
    $TextLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text "Ocarina of Time REDUX - Additional Options" -AddTo $OoTReduxOptionsDialog
    
   # $OoTReduxOptionsDialog.Show()

    # HERO MODE #
    $global:HeroModeBoxOoT             = CreateReduxGroup -Y 50 -Height 3 -Dialog $OoTReduxOptionsDialog -Text "Hero Mode"
    
    # Damage
    $global:DamagePanelOoT             = CreateReduxPanel -Row 0 -Group $HeroModeBoxOoT 
    $global:1xDamageOoT                = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanelOoT -Checked $True -Text "1x Damage" -Info "Enemies deal normal damage"
    $global:2xDamageOoT                = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanelOoT                -Text "2x Damage" -Info "Enemies deal twice as much damage"
    $global:4xDamageOoT                = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanelOoT                -Text "4x Damage" -Info "Enemies deal four times as much damage"
    $global:8xDamageOoT                = CreateReduxRadioButton -Column 3 -Row 0 -Panel $DamagePanelOoT                -Text "8x Damage" -Info "Enemies deal four times as much damage"

    # Recovery
    $global:RecoveryPanelOoT           = CreateReduxPanel -Row 1 -Group $HeroModeBoxOoT 
    $global:NormalRecoveryOoT          = CreateReduxRadioButton -Column 0 -Row 0 -Panel $RecoveryPanelOoT -Checked $True -Text "1x Recovery"   -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $global:HalfRecoveryOoT            = CreateReduxRadioButton -Column 1 -Row 0 -Panel $RecoveryPanelOoT                -Text "1/2x Recovery" -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $global:QuarterRecoveryOoT         = CreateReduxRadioButton -Column 2 -Row 0 -Panel $RecoveryPanelOoT                -Text "1/4x Recovery" -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $global:NoRecoveryOoT              = CreateReduxRadioButton -Column 3 -Row 0 -Panel $RecoveryPanelOoT                -Text "0x Recovery"   -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $global:BossHPPanelOoT             = CreateReduxPanel -Row 2 -Group $HeroModeBoxOoT 
  # $global:1xBossHPOoT                = CreateReduxRadioButton -Column 0 -Row 0 -Panel $BossHPPanelOoT -Checked $True -Text "1x Boss HP" -Info "Bosses have normal hit points" 
  # $global:2xBossHPOoT                = CreateReduxRadioButton -Column 1 -Row 0 -Panel $BossHPPanelOoT                -Text "2x Boss HP" -Info "Bosses have double as much hit points"
  # $global:3xBossHPOoT                = CreateReduxRadioButton -Column 2 -Row 0 -Panel $BossHPPanelOoT                -Text "3x Boss HP" -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $global:OHKOModeOoT                = CreateReduxCheckbox -Column 0 -Row 3 -Group $HeroModeBoxOoT -Text "OHKO Mode" -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # TEXT SPEED #
    $global:TextBoxOoT                 = CreateReduxGroup -Y ($HeroModeBoxOoT.Bottom + 5) -Height 1 -Dialog $OoTReduxOptionsDialog -Text "Text Dialogue Speed"
    
    $global:TextPanelOoT               = CreateReduxPanel -Row 0 -Group $TextBoxOoT 
    $global:1xTextOoT                  = CreateReduxRadioButton -Column 0 -Row 0 -Panel $TextPanelOoT -Checked $True -Text "1x Speed" -Info "Leave the dialogue text speed at normal"
    $global:2xTextOoT                  = CreateReduxRadioButton -Column 1 -Row 0 -Panel $TextPanelOoT                -Text "2x Speed" -Info "Set the dialogue text speed to be twice as fast"
    $global:3xTextOoT                  = CreateReduxRadioButton -Column 2 -Row 0 -Panel $TextPanelOoT                -Text "3x Speed" -Info "Set the dialogue text speed to be three times as fast"



    # GRAPHICS #
    $global:GraphicsBoxOoT             = CreateReduxGroup -Y ($TextBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTReduxOptionsDialog -Text "Graphics"
    
    $global:WidescreenOoT              = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBoxOoT -Text "16:9 Widescreen"        -Info "Native 16:9 widescreen display support"
    $global:WidescreenTexturesOoT      = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBoxOoT -Text "16:9 Textures"          -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support"
    $global:ExtendedDrawOoT            = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBoxOoT -Text "Extended Draw Distance" -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $global:BlackBarsOoT               = CreateReduxCheckbox -Column 3 -Row 1 -Group $GraphicsBoxOoT -Text "No Black Bars"          -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $global:ForceHiresModelOoT         = CreateReduxCheckbox -Column 0 -Row 2 -Group $GraphicsBoxOoT -Text "Force Hires Link Model" -Info "Always use Link's High Resolution Model when Link is too far away"
    $global:MMModelsOoT                = CreateReduxCheckbox -Column 1 -Row 2 -Group $GraphicsBoxOoT -Text "Replace Link's Models"  -Info "Replaces Link's models to be styled towards Majora's Mask"



    # EQUIPMENT #
    $global:EquipmentBoxOoT            = CreateReduxGroup -Y ($GraphicsBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTReduxOptionsDialog -Text "Equipment"
    
    $global:ItemCapacityPanelOoT       = CreateReduxPanel -Row 0 -Group $EquipmentBoxOoT 
    $global:ReducedItemCapacityOoT     = CreateReduxRadioButton -Column 0 -Row 0 -Panel $ItemCapacityPanelOoT                -Text "Reduced Item Capacity"   -Info "Decrease the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $global:NormalItemCapacityOoT      = CreateReduxRadioButton -Column 1 -Row 0 -Panel $ItemCapacityPanelOoT -Checked $True -Text "Normal Item Capacity"    -Info "Keep the normal amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $global:IncreasedItemCapacityOoT   = CreateReduxRadioButton -Column 2 -Row 0 -Panel $ItemCapacityPanelOoT                -Text "Increased Item Capacity" -Info "Increase the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"

    $global:UnlockSwordOoT             = CreateReduxCheckbox -Column 0 -Row 2 -Group $EquipmentBoxOoT -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword"
    $global:UnlockTunicsOoT            = CreateReduxCheckbox -Column 1 -Row 2 -Group $EquipmentBoxOoT -Text "Unlock Tunics"       -Info "Child Link is able to use the Goron TUnic and Zora Tunic`nSince you might want to walk around in style as well when you are young"
    $global:UnlockBootsOoT             = CreateReduxCheckbox -Column 2 -Row 2 -Group $EquipmentBoxOoT -Text "Unlock Boots"        -Info "Child Link is able to use the Iron Boots and Hover Boots"



    # EVERYTHING ELSE #
    $global:OtherBoxOoT                = CreateReduxGroup -Y ($EquipmentBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTReduxOptionsDialog -Text "Other"

    $global:DisableLowHPSoundOoT       = CreateReduxCheckbox -Column 0 -Row 1 -Group $OtherBoxOoT -Text "Disable Low HP Beep"    -Info "There will be absolute silence when Link's HP is getting low"
    $global:MedallionsOoT              = CreateReduxCheckbox -Column 1 -Row 1 -Group $OtherBoxOoT -Text "Require All Medallions" -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`The vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows"
    $global:ReturnChildOoT             = CreateReduxCheckbox -Column 2 -Row 1 -Group $OtherBoxOoT -Text "Can Always Return"      -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"
    $global:DisableNaviOoT             = CreateReduxCheckbox -Column 3 -Row 1 -Group $OtherBoxOoT -Text "Remove Navi Prompts"    -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes"
    $global:HideDPadOoT                = CreateReduxCheckbox -Column 0 -Row 2 -Group $OtherBoxOoT -Text "Hide D-Pad Icon"        -Info "Hide the D-Pad icon, while it is still active"
    


    # Include Redux (Checkbox)
    $global:IncludeReduxOoT            = CreateCheckbox -X 30 -Y ($CloseButton.Top + 5) -Checked $True -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $OoTReduxOptionsDialog
    $IncludeReduxLabel                 = CreateLabel -X $IncludeReduxOoT.Right -Y ($IncludeReduxOoT.Top + 3) -Width 135 -Height 15 -Text "Include Redux Patch" -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $OoTReduxOptionsDialog

    $IncludeReduxOoT.Add_CheckStateChanged({
        $OtherBoxOoT.Controls[4 * 2].Enabled = $IncludeReduxOoT.Checked
    })

}

 

#==============================================================================================================================================================================================
function CreateMajorasMaskReduxOptionsDialog() {
    
    # Create Dialog
    $global:MMReduxOptionsDialog = CreateDialog -Width 700 -Height 580 -Icon $Icons.MajorasMaskRedux
    $CloseButton = CreateButton -X ($MMReduxOptionsDialog.Width / 2 - 40) -Y ($MMReduxOptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $MMReduxOptionsDialog
    $CloseButton.Add_Click({$MMReduxOptionsDialog.Hide()})

    # Options Label
    $TextLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text "Majora's Mask REDUX - Additional Options" -AddTo $MMReduxOptionsDialog

    #$MMReduxOptionsDialog.Show()

    # HERO MODE #
    $global:HeroModeBoxMM              = CreateReduxGroup -Y 50 -Height 3 -Dialog $MMReduxOptionsDialog -Text "Hero Mode"
    
    # Damage
    $global:DamagePanelMM              = CreateReduxPanel -Row 0 -Group $HeroModeBoxMM 
    $global:1xDamageMM                 = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DamagePanelMM -Checked $True -Text "1x Damage" -Info "Enemies deal normal damage"
    $global:2xDamageMM                 = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DamagePanelMM                -Text "2x Damage" -Info "Enemies deal twice as much damage"
    $global:4xDamageMM                 = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DamagePanelMM                -Text "4x Damage" -Info "Enemies deal four times as much damage"
    $global:8xDamageMM                 = CreateReduxRadioButton -Column 3 -Row 0 -Panel $DamagePanelMM                -Text "8x Damage" -Info "Enemies deal four times as much damage"

    # Recovery
    $global:RecoveryPanelMM            = CreateReduxPanel -Row 1 -Group $HeroModeBoxMM 
    $global:NormalRecoveryMM           = CreateReduxRadioButton -Column 0 -Row 0 -Panel $RecoveryPanelMM -Checked $True -Text "1x Recovery"   -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $global:HalfRecoveryMM             = CreateReduxRadioButton -Column 1 -Row 0 -Panel $RecoveryPanelMM                -Text "1/2x Recovery" -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $global:QuarterRecoveryMM          = CreateReduxRadioButton -Column 2 -Row 0 -Panel $RecoveryPanelMM                -Text "1/4x Recovery" -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $global:NoRecoveryMM               = CreateReduxRadioButton -Column 3 -Row 0 -Panel $RecoveryPanelMM                -Text "0x Recovery"   -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $global:BossHPPanelMM              = CreateReduxPanel -Row 2 -Group $HeroModeBoxMM 
  # $global:1xBossHPMM                 = CreateReduxRadioButton -Column 0 -Row 0 -Panel $BossHPPanelMM -Checked $True -Text "1x Boss HP" -Info "Bosses have normal hit points" 
  # $global:2xBossHPMM                 = CreateReduxRadioButton -Column 1 -Row 0 -Panel $BossHPPanelMM                -Text "2x Boss HP" -Info "Bosses have double as much hit points"
  # $global:3xBossHPMM                 = CreateReduxRadioButton -Column 2 -Row 0 -Panel $BossHPPanelMM                -Text "3x Boss HP" -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $global:OHKOModeMM                 = CreateReduxCheckbox -Column 0 -Row 3 -Group $HeroModeBoxMM -Text "OHKO Mode" -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # D-PAD #
    $global:DPadBoxMM                  = CreateReduxGroup -Y ($HeroModeBoxMM.Bottom + 5) -Height 1 -Dialog $MMReduxOptionsDialog -Text "D-Pad Icons Layout"
    
    $global:DPadPanelMM                = CreateReduxPanel -Row 0 -Group $DPadBoxMM 
    $global:LeftDPadMM                 = CreateReduxRadioButton -Column 0 -Row 0 -Panel $DPadPanelMM                -Text "Left Side" -Info "Show the D-Pad icons on the left side of the HUD"
    $global:RightDPadMM                = CreateReduxRadioButton -Column 1 -Row 0 -Panel $DPadPanelMM -Checked $True -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD"
    $global:HideDPadMM                 = CreateReduxRadioButton -Column 2 -Row 0 -Panel $DPadPanelMM                -Text "Hidden" -Info "Hide the D-Pad icons, while they are still active"
    
    
   
    # GRAPHICS #
    $global:GraphicsBoxMM              = CreateReduxGroup -Y ($DPadBoxMM.Bottom + 5) -Height 2 -Dialog $MMReduxOptionsDialog -Text "Graphics"
    
    $global:WidescreenMM               = CreateReduxCheckbox -Column 0 -Row 1 -Group $GraphicsBoxMM -Text "16:9 Widescreen"         -Info "Native 16:9 Widescreen Display support"
    $global:WidescreenTexturesMM       = CreateReduxCheckbox -Column 1 -Row 1 -Group $GraphicsBoxMM -Text "16:9 Textures"           -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support"
    $global:ExtendedDrawMM             = CreateReduxCheckbox -Column 2 -Row 1 -Group $GraphicsBoxMM -Text "Extended Draw Distance"  -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $global:BlackBarsMM                = CreateReduxCheckbox -Column 3 -Row 1 -Group $GraphicsBoxMM -Text "No Black Bars"           -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $global:PixelatedStarsMM           = CreateReduxCheckbox -Column 0 -Row 2 -Group $GraphicsBoxMM -Text "Disable Pixelated Stars" -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement"

    

    # EQUIPMENT #
    $global:EquipmentBoxMM             = CreateReduxGroup -Y ($GraphicsBoxMM.Bottom + 5) -Height 2 -Dialog $MMReduxOptionsDialog -Text "Equipment"
    
    $global:ItemCapacityPanelMM        = CreateReduxPanel -Row 0 -Group $EquipmentBoxMM 
    $global:ReducedItemCapacityMM      = CreateReduxRadioButton -Column 0 -Row 0 -Panel $ItemCapacityPanelMM                -Text "Reduced Item Capacity"   -Info "Decrease the amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $global:NormalItemCapacityMM       = CreateReduxRadioButton -Column 1 -Row 0 -Panel $ItemCapacityPanelMM -Checked $True -Text "Normal Item Capacity"    -Info "Keep the normal amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $global:IncreasedItemCapacityMM    = CreateReduxRadioButton -Column 2 -Row 0 -Panel $ItemCapacityPanelMM                -Text "Increased Item Capacity" -Info "Increase the amount of deku sticks, deku nuts, bombs and arrows you can carry"

    $global:RazorSwordMM               = CreateReduxCheckbox -Column 0 -Row 2 -Group $EquipmentBoxMM -Text "Permanent Razor Sword" -Info "The Razor Sword won't get destroyed after 100 it`nYou can also keep the Razor Sword when traveling back in time"



    # EVERYTHING ELSE #
    $global:OtherBoxMM                 = CreateReduxGroup -Y ($EquipmentBoxMM.Bottom + 5) -Height 1 -Dialog $MMReduxOptionsDialog -Text "Other"

    $global:DisableLowHPSoundMM        = CreateReduxCheckbox -Column 0 -Row 1 -Group $OtherBoxMM -Text "Disable Low HP Beep"      -Info "There will be absolute silence when Link's HP is getting low"
    $global:PieceOfHeartSoundMM        = CreateReduxCheckbox -Column 1 -Row 1 -Group $OtherBoxMM -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container"



    # Include Redux (Checkbox)
    $global:IncludeReduxMM             = CreateCheckbox -X 30 -Y ($CloseButton.Top + 5) -Checked $True -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $MMReduxOptionsDialog
    $IncludeReduxLabel                 = CreateLabel -X $IncludeReduxMM.Right -Y ($IncludeReduxMM.Top + 3) -Width 135 -Height 15 -Text "Include Redux Patch" -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $MMReduxOptionsDialog

    $IncludeReduxMM.Add_CheckStateChanged({
        $DPadPanelMM.Controls[0 * 2].Enabled = $IncludeReduxMM.Checked
        $DPadPanelMM.Controls[1 * 2].Enabled = $IncludeReduxMM.Checked
        $DPadPanelMM.Controls[2 * 2].Enabled = $IncludeReduxMM.Checked
    })

}



#==============================================================================================================================================================================================
function CreateInfoGameIDDialog() {
    
    # Create Dialog
    $global:InfoGameIDDialog = CreateDialog -Width 500 -Height 500 -Icon $Icons.CheckGameID
    $CloseButton = CreateButton -X ($InfoGameIDDialog.Width / 2 - 40) -Y ($InfoGameIDDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoGameIDDialog
    $CloseButton.Add_Click({$InfoGameIDDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoGameIDDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoGameIDDialog

    # Create textbox
    $TextBox = CreateTextBox -X 40 -Y 50 -Width ($InfoGameIDDialog.Width - 100) -Height ($CloseButton.Top - 60) -ReadOnly $True -AddTo $InfoGameIDDialog
    AddTextFileToTexTbox -TextBox $Textbox -File $Files.text_gameID

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 500 -Height 500 -Icon $Icon.Credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({$CreditsDialog.Hide()})

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create textbox
    $TextBox = CreateTextBox -X 40 -Y 50 -Width ($CreditsDialog.Width - 100) -Height ($CloseButton.Top - 60) -ReadOnly $True -AddTo $CreditsDialog
    AddTextFileToTexTbox -TextBox $Textbox -File $Files.text_credits

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
function AddTextFileToTexTbox($TextBox, $File) {
    
    if (Test-Path -LiteralPath $File -PathType Leaf) {
        $str = ""
        for ($i=0; $i -lt (Get-Content -Path $File).Count; $i++) {
            if ((Get-Content -Path $File)[$i] -ne "") {
                $str += (Get-Content -Path $File)[$i]
                if ($i -lt  (Get-Content -Path $File).Count-1) { $str += "{0}" }
            }
            else { $str += "{0}" }
        }
        $str = [String]::Format($str, [Environment]::NewLine)
        $TextBox.Text = $str
    }

}



#==============================================================================================================================================================================================
function CreateMissingFilesDialog() {
    
    # Create Dialog
    $global:MissingFilesDialog = CreateDialog -Width 300 -Height 200 -Icon $null

    $CloseButton = CreateButton -X ($MissingFilesDialog.Width / 2 - 40) -Y ($MissingFilesDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $MissingFilesDialog
    $CloseButton.Add_Click({$MissingFilesDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " " + $Version + " (" + $VersionDate + ")" + "{0}"

    $String += "{0}"
    $String += "Neccessary files are missing.{0}"
    $String += "{0}"
    $String += "Please download the Patcher64+ Tool again."

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width ($MissingFilesDialog.Width-10) -Height ($MissingFilesDialog.Height - 110) -Text $String -AddTo $MissingFilesDialog

}



#==============================================================================================================================================================================================
function CreateForm([int]$X, [int]$Y, [int]$Width, [int]$Height, [string]$Name, [Object]$Object, [Object]$AddTo) {
    
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
function CreateGroupBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [string]$Name, [string]$Text, [Object]$AddTo) {
    
    $GroupBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
    if ($Text -ne $null -and $Text -ne "") { $GroupBox.Text = (" " + $Text + " ") }
    return $GroupBox

}



#==============================================================================================================================================================================================
function CreatePanel([int]$X, [int]$Y, [int]$Width, [int]$Height, [string]$Name, [Object]$AddTo) {
    
    return CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Panel) -AddTo $AddTo

}



#==============================================================================================================================================================================================
function CreateTextBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [string]$Name, [boolean]$ReadOnly, [string]$Text, [Object]$AddTo) {
    
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
function CreateComboBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [string]$Name, $Items, [Object]$AddTo) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo

    if ($Items -ne $null) {
        $ComboBox.Items.AddRange($Items)
        $ComboBox.SelectedIndex = 0
    }
    $ComboBox.DropDownStyle = "DropDownList"

    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateCheckbox([int]$X, [int]$Y, [string]$Name, [boolean]$Checked, [boolean]$IsRadio, [string]$Info, [Object]$AddTo) {
    
    if ($IsRadio)          { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else                   { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    if ($Info -ne $null)   { $ToolTip.SetToolTip($Checkbox, $Info) }
    $Checkbox.Checked = $Checked
    return $Checkbox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X, [int]$Y, [string]$Name, [int]$Width, [int]$Height, [string]$Text, [Object]$Font, [string]$Info, [Object]$AddTo) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if ($Text -ne $null)   { $Label.Text = $Text }
    if ($Font -ne $null)   { $Label.Font = $Font }
    if ($Info -ne $null)   { $ToolTip.SetToolTip($Label, $Info) }
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X, [int]$Y, [string]$Name, [int]$Width, [int]$Height, [string]$Text, [string]$Info, [Object]$AddTo) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if ($Text -ne $null)   { $Button.Text = $Text }
    if ($Font -ne $null)   { $Button.Font = $Font }
    if ($Info -ne $null)   { $ToolTip.SetToolTip($Button, $Info) }
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxGroup([int]$Y, [int]$Height, [Object]$Dialog, [string]$Text)   { return CreateGroupBox -X 15 -Y $Y -Width ($Dialog.Width - 50) -Height ($Height * 30 + 20) -Text $Text -AddTo $Dialog }
function CreateReduxPanel([int]$Row, [Object]$Group)                               { return CreatePanel -X $Group.Left -Y ($Row * 30 + 20) -Width ($Group.Width - 20) -Height 20 -AddTo $Group }



#==============================================================================================================================================================================================
function CreateReduxRadioButton([int]$Column, [int]$Row, [Object]$Panel, [boolean]$Checked, [string]$Text, [string]$Info) {
    
    $Button = CreateCheckbox -X ($Column * 155) -Y ($Row * 30) -Checked $Checked -IsRadio $True -Info $Info -AddTo $Panel
    CreateLabel -X $Button.Right -Y ($Button.Top + 3) -Width 135 -Height 15 -Text $Text -Info $Info -AddTo $Panel
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxCheckbox([int]$Column, [int]$Row, [Object]$Group, [boolean]$Checked, [string]$Text, [string]$Info) {
    
    $Checkbox = CreateCheckbox -X ($Column * 155 + 15) -Y ($Row * 30 - 10) -Checked $False -IsRadio $False -Info $Info -AddTo $Group
    CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -Info $Info -AddTo $Group
    return $CheckBox

}



#==============================================================================================================================================================================================

# Hide the PowerShell console from the user.
ShowPowerShellConsole -ShowConsole $False

# Find icons
$global:Icons = SetIconParameters

# Set paths to all the files stored in the script.
$global:Files = SetFileParameters

# Files are missing, error!
if ($MissingFiles) {
    CreateMissingFilesDialog
    $MissingFilesDialog.ShowDialog() | Out-Null
    Exit
}

$global:ToolTip = CreateToolTip

# Create the dialogs to show to the user.
CreateMainDialog
CreateOcarinaOfTimeReduxOptionsDialog
CreateMajorasMaskReduxOptionsDialog
CreateInfoGameIDDialog
CreateInfoDialog
CreateCreditsDialog

# Set default game mode.
if ($CurrentGameComboBox.Items.Length -gt 0)   {
    $CurrentGameComboBox.SelectedIndex = 0
    ChangeGameMode -Mode $GamesJSONFile.game[0].mode
}
else {
    $CurrentGameComboBox.SelectedIndex = -1
    ChangeGameMode -Mode $null
}

# Disable patching buttons.
EnablePatchButtons -Enable $False

# Show the dialog to the user.
$MainDialog.ShowDialog() | Out-Null

Exit