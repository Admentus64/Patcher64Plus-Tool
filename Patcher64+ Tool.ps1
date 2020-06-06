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

$global:Version = "06-06-2020"

$global:GameID = ""
$global:ChannelTitle = ""
$global:ChannelTitleLength = 40
$global:GameType = $null
$global:GetCommand = $null
$global:IsCompress = $false
$global:IsRedux = $False
$global:IsWiiVC = $True
$global:IsDowngrade = $False
$global:PatchedFileName = ""
$global:CheckHashSum = ""
$global:MissingFiles = $False
$global:CurrentModeFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 12, [System.Drawing.FontStyle]::Bold)
$global:VCPatchFont = [System.Drawing.Font]::new("Microsoft Sans Serif", 8, [System.Drawing.FontStyle]::Bold)



#==============================================================================================================================================================================================
# Hashes

$global:HashSum_oot_rev0 = "C916AB315FBE82A22169BFF13D6B866E9FDDC907461EB6B0A227B82ACDF5B506"
$global:HashSum_oot_rev1 = "FB87A0DAC188F9292C679DA7AC6F772ACEBE6F68E27293CFC281FC8636008DB0"
$global:HashSum_oot_rev2 = "49ACD3885F13B0730119B78FB970911CC8ABA614FE383368015C21565983368D"
$global:HashSum_mm = "EFB1365B3AE362604514C0F9A1A2D11F5DC8688BA5BE660A37DEBF5E3BE43F2B"
$global:HashSum_sm64 = "17CE077343C6133F8C9F2D6D6D9A4AB62C8CD2AA57C40AEA1F490B4C8BB21D91"
$global:HashSum_pp = "9EC6D2A5C2FCA81AB86312328779FD042B5F3B920BF65DF9F6B87B376883CB5B"



#==============================================================================================================================================================================================
# Default GameID's

$global:OoT_US_GameID = "NACE"
$global:MM_US_GameID = "NARE"
$global:SM64_US_GameID = "NAAE"
$global:PP_US_GameID = "NAEE"
$global:CUST_GameID = "CUST"



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
function MainFunctionReset([string]$Command, [string]$Hash, [boolean]$Compress) {
    
    $global:GetCommand = $Command
    $global:IsCompress = $Compress
    $global:IsRedux = $False
    $global:IsDowngrade = $False
    $global:PatchFile = $null
    $global:PatchedFileName = "_patched"
    $global:CheckHashSum = $Hash

    if (!$global:IsWiiVC)                                               { $global:Z64File = SetZ64Parameters -Z64Path $global:GameZ64 }
    if (!(CheckCheckBox -CheckBox $global:InputCustomGameIDCheckbox))   { ChangeGameMode -Mode $global:GameType }

    if ($global:IsWiiVC -and $global:GetCommand -eq "Downgrade" -and $global:PatchVCDowngrade.Visible) {
        $global:PatchVCDowngrade.Checked = $True
        $global:IsDowngrade = $True
    }
    elseif ($global:IsWiiVC -and $global:GetCommand -eq "No Downgrade") { $global:PatchVCDowngrade.Checked = $False }

    SetROMFile

}



#==============================================================================================================================================================================================
function MainFunctionOoTRedux([string]$Command, [string]$Hash, [boolean]$Compress) {
    
    MainFunctionReset -Command $Command -Hash $Hash -Compress $Compress

    $global:GameID = "NAC0"
    $global:ChannelTitle = "Redux: Ocarina"
    $global:PatchedFileName = '_redux_patched'
    $global:IsRedux = $true

    $global:PatchVCExpandMemory.Checked = $true
    $global:PatchVCRemapDPad.Checked = $true
    if ($global:IsWiiVC -and !$global:PatchVCRemapCDown.Checked -and !$global:PatchVCRemapZ.Checked)   { $global:PatchVCLeaveDPadUp.Checked = $true }
    if ($global:IncludeReduxOoT.Checked)                                                               { $global:PatchFile = $Files.bpspatch_oot_redux }
    else { $global:PatchFile = $null }
    
    MainFunction

}



#==============================================================================================================================================================================================
function MainFunctionMMRedux([string]$Command, [string]$Hash, [boolean]$Compress) {
    
    MainFunctionReset -Command $Command -Hash $Hash -Compress $Compress

    $global:GameID = "NAR0"
    $global:ChannelTitle = "Redux: Majora's"
    $global:PatchedFileName = '_redux_patched'
    $global:IsRedux = $true

    if ($IncludeReduxMM.Checked) { $global:PatchFile = $Files.bpspatch_mm_redux }
    else { $global:PatchFile = $null }
    $global:PatchVCRemapDPad.Checked = $true

    MainFunction

}



#==============================================================================================================================================================================================
function MainFunctionPatchRemap([String]$Command, [string]$Id, [string]$Title, [string]$Patch, [string]$PatchedFile, [string]$Hash, [Boolean]$Compress) {
    
    $global:PatchVCRemapDPad.Checked = $true
    MainFunctionPatch -Command $Command -Id $Id -Title $Title -Patch $Patch -PatchedFile $PatchedFile -Hash $Hash -Compress $Compress

}



#==============================================================================================================================================================================================
function MainFunctionPatch([String]$Command, [string]$Id, [string]$Title, [string]$Patch, [string]$PatchedFile, [string]$Hash, [Boolean]$Compress) {
    
    MainFunctionReset -Command $Command -Hash $Hash -Compress $Compress

    if ($global:GameID -ne $null)         { $global:GameID = $Id }
    if ($global:ChannelTitle -ne $null)   { $global:ChannelTitle = $Title }
    $global:PatchFile = $Patch
    $global:PatchedFileName = $PatchedFile

    MainFunction

}



#==============================================================================================================================================================================================
function MainFunction() {
    
    # Step 01: Disable the main dialog, allow patching and delete files if they still exist.
    $ContinuePatching = $True
    $MainDialog.Enabled = $False

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        
        # Step 02: Extract the contents of the WAD file.
        ExtractWADFile

        # Step 03: Check the GameID to be vanilla.
        $ContinuePatching = CheckGameID
        if (!$ContinuePatching) {
            Cleanup
            return
        }

        # Step 04: Replace the Virtual Console emulator within the WAD file.
        PatchVCEmulator

        # Step 05: Extract "00000005.app" file to get the ROM.
        ExtractU8AppFile

        # Step 06: Do some initial patching stuff for the ROM for VC WAD files.
        $ContinuePatching = PatchVCROM
        if (!$ContinuePatching) {
            Cleanup
            return
        }

    }

    # Step 07: Downgrade the ROM if required
    $ContinuePatching = DowngradeROM
    if (!$ContinuePatching) {
        Cleanup
        return
    }

    # Step 08: Compare HashSums for untouched ROM Files
    $ContinuePatching = CompareHashSums
    if (!$ContinuePatching) {
        Cleanup
        return
    }

    # Step 09: Decompress the ROM if required.
    DecompressROM

    # Step 10: Patch and extend the ROM file with the patch through Floating IPS.
    $ContinuePatching = PatchROM
    if (!$ContinuePatching) {
        Cleanup
        return
    }

    # Step 11: Apply additional patches on top of the Redux patches.
    PatchRedux

    # Step 12: Compress the decompressed ROM if required.
    CompressROM

    # Only continue with these steps in VC WAD mode. Otherwise ignore these steps.
    if ($IsWiiVC) {
        # Step 13: Extend a ROM if it is neccesary for the Virtual Console. Mostly applies to decompressed ROMC files
        ExtendROM

        # Step 14: Compress the ROMC again if possible.
        CompressROMC

        # Step 15: Apply Custom Channel Title and GameID if enabled.
        SetCustomGameID

        # Step 16: Hack the Channel Title.
        HackOpeningBNRTitle

        # Step 17: Repack the "00000005.app" with the updated ROM file.
        RepackU8AppFile

        # Step 18: Repack the WAD file with the updated APP file.
        RepackWADFile
    }

    # Step 19: Final message.
    if ($IsWiiVC)   { UpdateStatusLabelDuringPatching -Text ('Finished patching the ' + $GameType + ' VC WAD file.') }
    else            { UpdateStatusLabelDuringPatching -Text ('Finished patching the ' + $GameType + ' ROM file.') }

    # Step 20: Get rid of everything and enable the main dialog.
    Cleanup

}



#==============================================================================================================================================================================================
function Cleanup() {
    
    RemovePath -LiteralPath ($MasterPath + '\cygdrive')

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

    $MainDialog.Enabled = $True
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function DeleteFile([string]$File) { if (Test-Path $File -PathType leaf) { Remove-Item $File } }



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
    $Files.ndec                          = $MasterPath + "\Compress\ndec.exe"
    $Files.TabExt                        = $MasterPath + "\Compress\TabExt.exe"
    $Files.Compress                      = $MasterPath + "\Compress\Compress.exe"
    $Files.lzss                          = $MasterPath + "\Wii VC\lzss.exe"
    $Files.romc                          = $MasterPath + "\Wii VC\romc.exe"
    $Files.romchu                        = $MasterPath + "\Wii VC\romchu.exe"

    $Files.bpspatch_mm_masked_quest      = $MasterPath + "\Majora's Mask\mm_masked_quest.bps"
    $Files.bpspatch_mm_pol               = $MasterPath + "\Majora's Mask\mm_pol.bps"
    $Files.bpspatch_mm_rus               = $MasterPath + "\Majora's Mask\mm_rus.bps"
    $Files.bpspatch_mm_redux             = $MasterPath + "\Majora's Mask\mm_redux.bps"

    $Files.bpspatch_oot_dawn_rev0        = $MasterPath + "\Ocarina of Time\oot_dawn_rev0.bps"
    $Files.bpspatch_oot_dawn_rev1        = $MasterPath + "\Ocarina of Time\oot_dawn_rev1.bps"
    $Files.bpspatch_oot_dawn_rev2        = $MasterPath + "\Ocarina of Time\oot_dawn_rev2.bps"
    $Files.bpspatch_oot_chi              = $MasterPath + "\Ocarina of Time\oot_chi.bps"
    $Files.bpspatch_oot_pol              = $MasterPath + "\Ocarina of Time\oot_pol.bps"
    $Files.bpspatch_oot_spa              = $MasterPath + "\Ocarina of Time\oot_spa.bps"
    $Files.bpspatch_oot_rus              = $MasterPath + "\Ocarina of Time\oot_rus.bps"
    $Files.bpspatch_oot_bombiwa          = $MasterPath + "\Ocarina of Time\Decompressed\oot_bombiwa.bps"
    $Files.bpspatch_oot_rev1_to_rev0     = $MasterPath + "\Ocarina of Time\oot_rev1_to_rev0.bps"
    $Files.bpspatch_oot_rev2_to_rev0     = $MasterPath + "\Ocarina of Time\oot_rev2_to_rev0.bps"
    $Files.bpspatch_oot_redux            = $MasterPath + "\Ocarina of Time\oot_redux.bps"
    $Files.bpspatch_oot_models_mm        = $MasterPath + "\Ocarina of Time\Decompressed\oot_models_mm.bps"
    $Files.bpspatch_oot_widescreen       = $MasterPath + "\Ocarina of Time\Decompressed\oot_widescreen.bps"
    
    $Files.bpspatch_pp_hard_mode         = $MasterPath + "\Paper Mario\pp_hard_mode.bps"
    $Files.bpspatch_pp_hard_mode_plus    = $MasterPath + "\Paper Mario\pp_hard_mode_plus.bps"
    $Files.bpspatch_pp_insane_mode       = $MasterPath + "\Paper Mario\pp_insane_mode.bps"

    $Files.bpspatch_sm64_appFile_01      = $MasterPath + "\Super Mario 64\sm64_appFile_01.bps"
    $Files.bpspatch_sm64_cam             = $MasterPath + "\Super Mario 64\sm64_cam.bps"
    $Files.bpspatch_sm64_fps             = $MasterPath + "\Super Mario 64\sm64_fps.bps"
    $Files.bpspatch_sm64_multiplayer     = $MasterPath + "\Super Mario 64\sm64_multiplayer.bps"

    $Files.GetEnumerator() | ForEach-Object {
        if (!(Test-Path $_.value -PathType leaf)) {
            $global:MissingFiles = $True
        }
    }

    $Files.ckey                          = $MasterPath + "\Wii VC\common-key.bin"
    $Files.dmaTable                      = $BasePath + "\dmaTable.dat"
    $Files.archive                       = $BasePath + "\ARCHIVE.bin"

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
        $global:DecompressedROMFile = "decompressed"
    }

}



#==============================================================================================================================================================================================
function ExtractWADFile() {
    
    # Set the status label.
    UpdateStatusLabelDuringPatching -Text 'Extracting WAD file...'

    # We need to be in the same path as some files so just jump there.
    Push-Location $WiiVCPath
    
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

            # If it already exists remove it first. Helps me with testing this out.
            #if (TestPath -LiteralPath $WADFile.Folder) { RemovePath -LiteralPath $WADFile.Folder }

            # Move this folder to where the WAD file is located.
            #Move-Item -LiteralPath $Folder.FullName -Destination $WADFile.Path -Force
        }
    }

    # Doesn't matter, but return to where we were.
    Pop-Location

    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function ExtractU8AppFile() {

    # Set the status label.
    UpdateStatusLabelDuringPatching -Text 'Extracting "00000005.app" file...'
    
    # Unpack the file using wszst.
    & $Files.wszst 'X' $WADFile.AppFile05 '-d' $WADFile.AppPath05 | Out-Null

    # Remove all .T64 files when selected
    if ($PatchVCRemoveT64.Checked) {
        Get-ChildItem $WADFile.AppPath05 -Include *.T64 -Recurse | Remove-Item
    }

    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function PatchVCEmulator() {
    
    if ($GetCommand -eq "Extract" -or !(CheckBootDolOptions)) { return }

    # Set the status label.
    UpdateStatusLabelDuringPatching -Text ('Patching ' + $GameType + ' VC Emulator...')

    $ByteArray = $null

    if ($GameType -eq "Ocarina of Time") {
        
        $ByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile01)

        if ($PatchVCExpandMemory.Checked) {
            $ByteArray[(GetDecimal -Hex "0x2EB0")] = (GetDecimal -Hex "0x60")
            $ByteArray[(GetDecimal -Hex "0x2EB1")] = 0
            $ByteArray[(GetDecimal -Hex "0x2EB2")] = 0
            $ByteArray[(GetDecimal -Hex "0x2EB3")] = 0

            $ByteArray[(GetDecimal -Hex "0x5BF44")] = (GetDecimal -Hex "0x3C")
            $ByteArray[(GetDecimal -Hex "0x5BF45")] = (GetDecimal -Hex "0x80")
            $ByteArray[(GetDecimal -Hex "0x5BF46")] = (GetDecimal -Hex "0x72")
            $ByteArray[(GetDecimal -Hex "0x5BF47")] = 0

            $ByteArray[(GetDecimal -Hex "0x5BFD7")] = 0
        }

        if ($PatchVCRemapDPad.Checked) {
            if (!$PatchLeaveDPadUp.Checked) {
                $ByteArray[(GetDecimal -Hex "0x16BAF0")] = 8
                $ByteArray[(GetDecimal -Hex "0x16BAF1")] = 0
            }

            $ByteArray[(GetDecimal -Hex "0x16BAF4")] = 4
            $ByteArray[(GetDecimal -Hex "0x16BAF5")] = 0

            $ByteArray[(GetDecimal -Hex "0x16BAF8")] = 2
            $ByteArray[(GetDecimal -Hex "0x16BAF9")] = 0

            $ByteArray[(GetDecimal -Hex "0x16BAFC")] = 1
            $ByteArray[(GetDecimal -Hex "0x16BAFD")] = 0
        }

        if ($PatchVCRemapCDown.Checked) {
            $ByteArray[(GetDecimal -Hex "0x16BB04")] = 0
            $ByteArray[(GetDecimal -Hex "0x16BB05")] = (GetDecimal -Hex "0x20")
        }

        if ($PatchVCRemapZ.Checked) {
            $ByteArray[(GetDecimal -Hex "0x16BAD8")] = 0
            $ByteArray[(GetDecimal -Hex "0x16BAD9")] = (GetDecimal -Hex "0x20")
        }

        [io.file]::WriteAllBytes($WADFile.AppFile01, $ByteArray)

    }

    elseif ($GameType -eq "Majora's Mask") {
        
        & $Files.lzss -d $WADFile.AppFile01 | Out-Host
        $ByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile01)

        if ($PatchVCExpandMemory.Checked) {
            $ByteArray[(GetDecimal -Hex "0x10B58")] = (GetDecimal -Hex "0x3C")
            $ByteArray[(GetDecimal -Hex "0x10B59")] = (GetDecimal -Hex "0x80")
            $ByteArray[(GetDecimal -Hex "0x10B5A")] = 0
            $ByteArray[(GetDecimal -Hex "0x10B5B")] = (GetDecimal -Hex "0xC0")

            $ByteArray[(GetDecimal -Hex "0x4BD20")] = (GetDecimal -Hex "0x67")
            $ByteArray[(GetDecimal -Hex "0x4BD21")] = (GetDecimal -Hex "0xE4")
            $ByteArray[(GetDecimal -Hex "0x4BD22")] = (GetDecimal -Hex "0x70")
            $ByteArray[(GetDecimal -Hex "0x4BD23")] = 0

            $ByteArray[(GetDecimal -Hex "0x4BC80")] = (GetDecimal -Hex "0x3C")
            $ByteArray[(GetDecimal -Hex "0x4BC81")] = (GetDecimal -Hex "0xA0")
            $ByteArray[(GetDecimal -Hex "0x4BC82")] = 1
            $ByteArray[(GetDecimal -Hex "0x4BC83")] = 0
        }

        if ($PatchVCRemapDPad.Checked) {
            $ByteArray[(GetDecimal -Hex "0x148514")] = 8
            $ByteArray[(GetDecimal -Hex "0x148515")] = 0

            $ByteArray[(GetDecimal -Hex "0x148518")] = 4
            $ByteArray[(GetDecimal -Hex "0x148519")] = 0

            $ByteArray[(GetDecimal -Hex "0x14851C")] = 2
            $ByteArray[(GetDecimal -Hex "0x14851D")] = 0

            $ByteArray[(GetDecimal -Hex "0x148520")] = 1
            $ByteArray[(GetDecimal -Hex "0x148521")] = 0
        }

        if ($PatchVCRemapCDown.Checked) {
            $ByteArray[(GetDecimal -Hex "0x148528")] = 0
            $ByteArray[(GetDecimal -Hex "0x148529")] = (GetDecimal -Hex "0x20")
        }

        if ($PatchVCRemapZ.Checked) {
            $ByteArray[(GetDecimal -Hex "0x1484F8")] = 0
            $ByteArray[(GetDecimal -Hex "0x1484F9")] = (GetDecimal -Hex "0x20")
        }

        [io.file]::WriteAllBytes($WADFile.AppFile01, $ByteArray)
        & $Files.lzss -evn $WADFile.AppFile01 | Out-Host

    }

    elseif ($GameType -eq "Super Mario 64") {

        if ($GetCommand -eq "Patch Boot DOL") {
            & $Files.flips $Files.bpspatch_sm64_appFile_01 $WADFile.AppFile01 | Out-Host
        }

    }

    $ByteArray = $null
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function PatchVCROM() {
    
    if ($GetCommand -eq "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabelDuringPatching -Text ("Initial patching of " + $GameType + " ROM...")
    
    # Extract ROM if required
    if ($GetCommand -eq "Extract") {
        if ($GameType -eq "Free")   { $ROMTitle = "n64_rom_extracted.z64" }
        else                        { $ROMTitle = $GameType + "_rom_extracted.z64" }

        if (Test-Path $ROMFile -PathType leaf) {
            Move-Item $ROMFile -Destination $WADFile.Extracted
            UpdateStatusLabelDuringPatching -Text ("Successfully extracted " + $GameType + " ROM.")
        }
        else { UpdateStatusLabelDuringPatching -Text ("Could not extract " + $GameType + " ROM. Is it a Majora's Mask or Paper Mario ROM?") }

        return $False
    }

    # Replace ROM if needed
    if ($GetCommand -eq "Inject") {
        if (Test-Path $ROMFile -PathType leaf) {
            Remove-Item $ROMFile
            Copy-Item $Z64FilePath -Destination $ROMFile
        }
        else {
            UpdateStatusLabelDuringPatching -Text ("Could not inject " + $GameType + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
            return $False
        }
    }

    # Decompress romc if needed
    if ($GetCommand -ne "Inject" -and ($GameType -eq "Majora's Mask" -or $GameType -eq "Paper Mario") ) {  

        if (Test-Path $ROMFile -PathType leaf) {
            if ($GameType -eq "Majora's Mask")     { & $Files.romchu $ROMFile $ROMCFile | Out-Null }
            elseif ($GameType -eq "Paper Mario")   { & $Files.romc d $ROMFile $ROMCFile | Out-Null }
            Remove-Item $ROMFile
            Rename-Item -Path $ROMCFile -NewName "romc"
        }
        else {
            UpdateStatusLabelDuringPatching -Text ("Could not decompress " + $GameType + " ROM. Is it a Majora's Mask or Paper Mario ROM?")
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
    [System.GC]::Collect() | Out-Null

    return $True

}



#==============================================================================================================================================================================================
function DowngradeROM() {
    
    if ($GetCommand -eq "Inject") { return $True }

    # Downgrade a ROM if it is required first
    if ($GameType -eq "Ocarina of Time" -and $IsDowngrade) {

        $HashSum = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash
        if ($HashSum -ne $HashSum_oot_rev1 -and $HashSum -ne $HashSum_oot_rev2) {
            UpdateStatusLabelDuringPatching -Text ("Failed! Ocarina of Time ROM does not match revision 1 or 2.")
            return $False
        }

        if ($HashSum -eq $HashSum_oot_rev1) { & $Files.flips $Files.bpspatch_oot_rev1_to_rev0 $ROMFile | Out-Host }
        elseif ($HashSum -eq $HashSum_oot_rev2) { & $Files.flips $Files.bpspatch_oot_rev2_to_rev0 $ROMFile | Out-Host }
        $global:CheckHashSum = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash

        $HashSum = $null
        [System.GC]::Collect() | Out-Null

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
            UpdateStatusLabelDuringPatching -Text ("Failed! ROM does not match the patching button target. ROM has left unchanged.")
            return $False
        }

        $HashSum = $Null
        [System.GC]::Collect() | Out-Null

    }

    return $True

}



#==============================================================================================================================================================================================
function PatchROM([string]$Hash) {

    if ($GetCommand -eq "Inject" -or $GetCommand -eq "Patch VC") { return $True }
    
    # Set the status label.
    UpdateStatusLabelDuringPatching -Text ("BPS Patching " + $GameType + " ROM...")

    $HashSum1 = $null
    if ($IsWiiVC -and $GetCommand -eq "BPS Patch") { $HashSum1 = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash }

    # Apply the selected patch to the ROM, if it is provided
    if ($PatchFile -ne $null) {
        if ($IsWiiVC -and $IsCompress)         { & $Files.flips $PatchFile $DecompressedROMFile | Out-Host }
        elseif ($IsWiiVC -and !$IsCompress)    { & $Files.flips $PatchFile $PatchedROMFile | Out-Host }
        elseif (!$IsWiiVC -and $IsCompress)    { & $Files.flips $PatchFile $DecompressedROMFile | Out-Host }
        elseif (!$IsWiiVC -and !$IsCompress)   { & $Files.flips --apply $PatchFile $ROMFile $PatchedROMFile | Out-Host }
    }

    if ($IsWiiVC -and $GetCommand -eq "BPS Patch") {
        $HashSum2 = (Get-FileHash -Algorithm SHA256 $ROMFile).Hash
        if ($HashSum1 -eq $HashSum2) {
            UpdateStatusLabelDuringPatching -Text 'Failed! BPS or IPS Patch does not match. ROM has left unchanged.'
            if ($GameType -eq "Ocarina of Time" -and !$IsDowngrade) { UpdateStatusLabelDuringPatching -Text "Failed! BPS or IPS Patch does not match. ROM has left unchanged. Enable Downgrade Ocarina of Time?" }
            elseif ($GameType -eq "Ocarina of Time" -and $IsDowngrade) { UpdateStatusLabelDuringPatching -Text "Failed! BPS or IPS Patch does not match. ROM has left unchanged. Disable Downgrade Ocarina of Time?" }
            return $False
        }
    }

    return $True

}



#==============================================================================================================================================================================================
function DecompressROM() {

    if (!$IsCompress -or $GetCommand -eq "Inject" -or ($GameType -ne "Ocarina of Time" -and $GameType -ne "Majora's Mask")) { return }
    
    & $Files.TabExt $ROMFile | Out-Host
    & $Files.ndec $ROMFile $DecompressedROMFile | Out-Host

    if ($IsWiiVC) { Remove-Item $ROMFile }
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function CompressROM() {
    
    if (!$IsCompress -or $GetCommand -eq "Inject" -or ($GameType -ne "Ocarina of Time" -and $GameType -ne "Majora's Mask")) { return }

    & $Files.Compress $DecompressedROMFile $PatchedROMFile | Out-Null
    Remove-Item $DecompressedROMFile
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function CompressROMC() {
    
    if ($GameType -ne "Paper Mario") { return }

    & $Files.romc e $ROMFile $ROMCFile | Out-Null
    Remove-Item $ROMFile
    Rename-Item -Path $ROMCFile -NewName "romc"
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function PatchRedux() {
    
    # SETUP #
    if (!(CheckReduxOptions) -or !$IsRedux -or ($GameType -ne "Ocarina of Time" -and $GameType -ne "Majora's Mask")) { return }
    UpdateStatusLabelDuringPatching -Text ("Patching " + $GameType + " REDUX...")

    # RUN DECOMPRESS #
    if (!$IsCompress) {
        $global:IsCompress = $True
        DecompressROM
    }
    
    # NEW DMATABLE #
    $offsets = ""
    if ($GameType -eq "Ocarina of Time") {
        $offsets = "0 1 2 3 4 5 6 7 8 9 15 16 17 18 19 20 21 22 23 24 25 26 942 944 946 948 950 952 954 956 958 960 962 964 966 968 970 972 974 976 978 980 982 984 986 988 990 992 994 "
        $offsets += "996 998 1000 1002 1004 1497 1498 1499 1500 1501 1502 1503 1504 1505 1506 1507 1508 1509 1510 1511 1512 1513 1514 1515 1516 1517 1518 1519 1520 1521 1522 1523 1524 1525"
    }
    elseif ($GameType -eq "Majora's Mask") {
        $offsets = "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 25 26 27 28 29 30 -652 1127 -1539 -1540 -1541 -1542 -1543 1544 "
        $offsets += "1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" 
    }
    
    DeleteFile -File $Files.dmaTable
    Add-Content $Files.dmaTable $offsets

    # BPS PATCHING #
    if ($GameType -eq "Ocarina of Time") {
        if (CheckCheckBox -CheckBox $MMModelsOoT)                { & $Files.flips --ignore-checksum $Files.bpspatch_oot_models_mm $DecompressedROMFile | Out-Host }
        if (CheckCheckBox -CheckBox $WidescreenBackgroundsOoT)   { & $Files.flips --ignore-checksum $Files.bpspatch_oot_widescreen $DecompressedROMFile | Out-Host }
        [System.GC]::Collect() | Out-Null
    }

    # BYTE PATCHING #
    $ByteArray = [IO.File]::ReadAllBytes($DecompressedROMFile)
    if ($GameType -eq "Ocarina of Time")     { $ByteArray = PatchReduxOoT -ByteArray $ByteArray }
    elseif ($GameType -eq "Majora's Mask")   { $ByteArray = PatchReduxMM -ByteArray $ByteArray }
    [io.file]::WriteAllBytes($DecompressedROMFile, $ByteArray)

    $ByteArray = $null
    [System.GC]::Collect() | Out-Null

}


#==============================================================================================================================================================================================
function PatchReduxOoT($ByteArray) {
    
    # HERO MODE #

    if (CheckCheckBox -CheckBox $OHKOModeOoT) {
        $ByteArray[(GetDecimal -Hex "0xAE8073")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0xAE8083")] = (GetDecimal -Hex "0x04")
        $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x82")
        $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x00")
        $ByteArray[(GetDecimal -Hex "0xAE8099")] = (GetDecimal -Hex "0x00")
        $ByteArray[(GetDecimal -Hex "0xAE809A")] = (GetDecimal -Hex "0x00")
        $ByteArray[(GetDecimal -Hex "0xAE809B")] = (GetDecimal -Hex "0x00")
    }
    elseif (!(CheckCheckBox -CheckBox $1xDamageOoT) -and !(CheckCheckBox -CheckBox $NormalRecoveryOoT)) {
        $ByteArray[(GetDecimal -Hex "0xAE8073")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0xAE8083")] = (GetDecimal -Hex "0x04")
        if (CheckCheckBox -CheckBox $NormalRecoveryOoT) {                
            $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x80")
            if (CheckCheckBox -CheckBox $2xDamageOoT )      { $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x40") }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT)   { $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x80") }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT)   { $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0xC0") }
            $ByteArray[(GetDecimal -Hex "0xAE8099")] = (GetDecimal -Hex "0x00")
            $ByteArray[(GetDecimal -Hex "0xAE809A")] = (GetDecimal -Hex "0x00")
            $ByteArray[(GetDecimal -Hex "0xAE809B")] = (GetDecimal -Hex "0x00")
        }
        elseif (CheckCheckBox -CheckBox $HalfRecoveryOoT) {               
            if (CheckCheckBox -CheckBox $1xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x80")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x40")
            }
            elseif (CheckCheckBox -CheckBox $2xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x80")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x80")
            }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x80")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0xC0")
            }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x81")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x00")
            }
            $ByteArray[(GetDecimal -Hex "0xAE8099")] = (GetDecimal -Hex "0x10")
            $ByteArray[(GetDecimal -Hex "0xAE809A")] = (GetDecimal -Hex "0x80")
            $ByteArray[(GetDecimal -Hex "0xAE809B")] = (GetDecimal -Hex "0x43")
        }
        elseif (CheckCheckBox -CheckBox $QuarterRecoveryOoT) {                
            if (CheckCheckBox -CheckBox $1xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x80")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x80")
            }
            elseif (CheckCheckBox -CheckBox $2xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x80")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0xC0")
            }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x81")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x00")
            }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x81")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x40")
                }
                $ByteArray[(GetDecimal -Hex "0xAE8099")] = (GetDecimal -Hex "0x10")
                $ByteArray[(GetDecimal -Hex "0xAE809A")] = (GetDecimal -Hex "0x80")
                $ByteArray[(GetDecimal -Hex "0xAE809B")] = (GetDecimal -Hex "0x83")

            }
            elseif (CheckCheckBox -CheckBox $NoRecoveryOoT) {                
            if (CheckCheckBox -CheckBox $1xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x81")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x40")
            }
            elseif (CheckCheckBox -CheckBox $2xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x81")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x80")
            }
            elseif (CheckCheckBox -CheckBox $4xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x81")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0xC0")
            }
            elseif (CheckCheckBox -CheckBox $8xDamageOoT) {
                $ByteArray[(GetDecimal -Hex "0xAE8096")] = (GetDecimal -Hex "0x82")
                $ByteArray[(GetDecimal -Hex "0xAE8097")] = (GetDecimal -Hex "0x00")
            }
            $ByteArray[(GetDecimal -Hex "0xAE8099")] = (GetDecimal -Hex "0x10")
            $ByteArray[(GetDecimal -Hex "0xAE809A")] = (GetDecimal -Hex "0x81")
            $ByteArray[(GetDecimal -Hex "0xAE809B")] = (GetDecimal -Hex "0x43")
        }
    }



    # TEXT DIALOGUE SPEED #

    if (CheckCheckBox -CheckBox $1xTextOoT)       { $ByteArray[(GetDecimal -Hex "0xB5006F")] = 1 }
    elseif (CheckCheckBox -CheckBox $2xTextOoT)   { $ByteArray[(GetDecimal -Hex "0xB5006F")] = 2 }
    elseif (CheckCheckBox -CheckBox $3xTextOoT) {
        $ByteArray[(GetDecimal -Hex "0x93B6E7")] = (GetDecimal -Hex "0x05")
        $ByteArray[(GetDecimal -Hex "0x93B6E8")] = (GetDecimal -Hex "0x40")
        $ByteArray[(GetDecimal -Hex "0x93B6E9")] = (GetDecimal -Hex "0x2E")
        $ByteArray[(GetDecimal -Hex "0x93B6EA")] = (GetDecimal -Hex "0x05")
        $ByteArray[(GetDecimal -Hex "0x93B6EB")] = (GetDecimal -Hex "0x46")
        $ByteArray[(GetDecimal -Hex "0x93B6EC")] = (GetDecimal -Hex "0x01")
        $ByteArray[(GetDecimal -Hex "0x93B6ED")] = (GetDecimal -Hex "0x05")
        $ByteArray[(GetDecimal -Hex "0x93B6EE")] = (GetDecimal -Hex "0x40")
        $ByteArray[(GetDecimal -Hex "0x93B6EF")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B6F1")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B71E")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B71D")] = (GetDecimal -Hex "0x2E")

        $ByteArray[(GetDecimal -Hex "0x93B722")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B74C")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B74D")] = (GetDecimal -Hex "0x21")
        $ByteArray[(GetDecimal -Hex "0x93B74E")] = (GetDecimal -Hex "0x05")
        $ByteArray[(GetDecimal -Hex "0x93B74F")] = (GetDecimal -Hex "0x42")

        $ByteArray[(GetDecimal -Hex "0x93B752")] = (GetDecimal -Hex "0x01")
        $ByteArray[(GetDecimal -Hex "0x93B753")] = (GetDecimal -Hex "0x05")
        $ByteArray[(GetDecimal -Hex "0x93B754")] = (GetDecimal -Hex "0x40")

        $ByteArray[(GetDecimal -Hex "0x93B776")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B777")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B77A")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B7A1")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B7A2")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B7A5")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B7A8")] = (GetDecimal -Hex "0x1A")

        $ByteArray[(GetDecimal -Hex "0x93B7C9")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B7CA")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B7CD")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B7F2")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B7F3")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B7F6")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B81C")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B81D")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B820")] = (GetDecimal -Hex "0x1")

        $ByteArray[(GetDecimal -Hex "0x93B849")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B84A")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B84D")] = (GetDecimal -Hex "0x1")

        $ByteArray[(GetDecimal -Hex "0x93B86D")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B86E")] = (GetDecimal -Hex "0x2E")

        $ByteArray[(GetDecimal -Hex "0x93B871")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B88F")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B890")] = (GetDecimal -Hex "0x2E")

        $ByteArray[(GetDecimal -Hex "0x93B893")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B8BE")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B8BF")] = (GetDecimal -Hex "0x2E")

        $ByteArray[(GetDecimal -Hex "0x93B8C2")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B8EF")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B8F0")] = (GetDecimal -Hex "0x2E")

        $ByteArray[(GetDecimal -Hex "0x93B8F3")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B91A")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B91B")] = (GetDecimal -Hex "0x21")

        $ByteArray[(GetDecimal -Hex "0x93B91E")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B94E")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0x93B94F")] = (GetDecimal -Hex "0x2E")

        $ByteArray[(GetDecimal -Hex "0x93B952")] = (GetDecimal -Hex "0x01")

        $ByteArray[(GetDecimal -Hex "0x93B728")] = (GetDecimal -Hex "0x10")
        $ByteArray[(GetDecimal -Hex "0x93B72A")] = (GetDecimal -Hex "0x01")

            $ByteArray[(GetDecimal -Hex "0xB5006F")] = (GetDecimal -Hex "0x03")
    }



    # GRAPHICS #

    if (CheckCheckBox -CheckBox $WideScreenOoT) {
        $ByteArray[(GetDecimal -Hex "0xB08038")] = (GetDecimal -Hex "0x3C")
        $ByteArray[(GetDecimal -Hex "0xB08039")] = (GetDecimal -Hex "0x07")
        $ByteArray[(GetDecimal -Hex "0xB0803A")] = (GetDecimal -Hex "0x3F")
        $ByteArray[(GetDecimal -Hex "0xB0803B")] = (GetDecimal -Hex "0xE3")
    }

    if (CheckCheckBox -CheckBox $ExtendedDrawOoT) {
        $ByteArray[(GetDecimal -Hex "0xA9A970")] = 0
        $ByteArray[(GetDecimal -Hex "0xA9A971")] = 1
    }

    if (CheckCheckBox -CheckBox $BlackBarsOoT) {
        $ByteArray[(GetDecimal -Hex "0xB0F5A4")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5A5")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5A6")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5A7")] = 0

        $ByteArray[(GetDecimal -Hex "0xB0F5D4")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5D5")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5D6")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5D7")] = 0

        $ByteArray[(GetDecimal -Hex "0xB0F5E4")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5E5")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5E6")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F5E7")] = 0

        $ByteArray[(GetDecimal -Hex "0xB0F680")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F681")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F682")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F683")] = 0

        $ByteArray[(GetDecimal -Hex "0xB0F688")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F689")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F68A")] = 0
        $ByteArray[(GetDecimal -Hex "0xB0F68B")] = 0
    }

    if (CheckCheckBox -CheckBox $ForceHiresModelOoT)   { $ByteArray[(GetDecimal -Hex "0xBE608B")] = 0 }



    # EQUIPMENT #

    if (CheckCheckBox -CheckBox $ReducedItemCapacityOoT) {
        $ByteArray[(GetDecimal -Hex "0xB6EC2F")] = 20
        $ByteArray[(GetDecimal -Hex "0xB6EC31")] = 25
        $ByteArray[(GetDecimal -Hex "0xB6EC33")] = 30
        $ByteArray[(GetDecimal -Hex "0xB6EC37")] = 10
        $ByteArray[(GetDecimal -Hex "0xB6EC39")] = 15
        $ByteArray[(GetDecimal -Hex "0xB6EC3B")] = 20
        $ByteArray[(GetDecimal -Hex "0xB6EC57")] = 20
        $ByteArray[(GetDecimal -Hex "0xB6EC59")] = 25
        $ByteArray[(GetDecimal -Hex "0xB6EC5B")] = 30
        $ByteArray[(GetDecimal -Hex "0xB6EC5F")] = 5
        $ByteArray[(GetDecimal -Hex "0xB6EC61")] = 10
        $ByteArray[(GetDecimal -Hex "0xB6EC63")] = 15
        $ByteArray[(GetDecimal -Hex "0xB6EC67")] = 10
        $ByteArray[(GetDecimal -Hex "0xB6EC69")] = 15
        $ByteArray[(GetDecimal -Hex "0xB6EC6A")] = 20
    }
    elseif (CheckCheckBox -CheckBox $IncreasedIemCapacityOOT) {
        $ByteArray[(GetDecimal -Hex "0xB6EC2F")] = 40
        $ByteArray[(GetDecimal -Hex "0xB6EC31")] = 70
        $ByteArray[(GetDecimal -Hex "0xB6EC33")] = 99
        $ByteArray[(GetDecimal -Hex "0xB6EC37")] = 30
        $ByteArray[(GetDecimal -Hex "0xB6EC39")] = 55
        $ByteArray[(GetDecimal -Hex "0xB6EC3B")] = 80
        $ByteArray[(GetDecimal -Hex "0xB6EC57")] = 40
        $ByteArray[(GetDecimal -Hex "0xB6EC59")] = 70
        $ByteArray[(GetDecimal -Hex "0xB6EC5B")] = 99
        $ByteArray[(GetDecimal -Hex "0xB6EC5F")] = 15
        $ByteArray[(GetDecimal -Hex "0xB6EC61")] = 30
        $ByteArray[(GetDecimal -Hex "0xB6EC63")] = 45
        $ByteArray[(GetDecimal -Hex "0xB6EC67")] = 30
        $ByteArray[(GetDecimal -Hex "0xB6EC69")] = 55
        $ByteArray[(GetDecimal -Hex "0xB6EC6A")] = 80
    }

    if (CheckCheckBox -CheckBox $UnlockSwordOoT) {
        $ByteArray[(GetDecimal -Hex "0xBC77AD")] = 9
        $ByteArray[(GetDecimal -Hex "0xBC77F7")] = 9
    }

    if (CheckCheckBox -CheckBox $UnlockTunicsOoT) {
        $ByteArray[(GetDecimal -Hex "0xBC77B6")] = 9 # Goron Tunic
        $ByteArray[(GetDecimal -Hex "0xBC77B7")] = 9
        $ByteArray[(GetDecimal -Hex "0xBC77FE")] = 9 # Zora Tunic
        $ByteArray[(GetDecimal -Hex "0xBC77FF")] = 9
    }

    if (CheckCheckBox -CheckBox $UnlockBootsOoT) {
        $ByteArray[(GetDecimal -Hex "0xBC77BA")] = 9 # Iron Boots
        $ByteArray[(GetDecimal -Hex "0xBC77BB")] = 9
        $ByteArray[(GetDecimal -Hex "0xBC7801")] = 9 # Hover Boots
        $ByteArray[(GetDecimal -Hex "0xBC7802")] = 9
    }



    # OTHER #

    if (CheckCheckBox -CheckBox $MedallionsOoT) {
        $ByteArray[(GetDecimal -Hex "0xE2B454")] = (GetDecimal -Hex "0x80")
        $ByteArray[(GetDecimal -Hex "0xE2B455")] = (GetDecimal -Hex "0xEA")
        $ByteArray[(GetDecimal -Hex "0xE2B456")] = 0
        $ByteArray[(GetDecimal -Hex "0xE2B457")] = (GetDecimal -Hex "0xA7")
        $ByteArray[(GetDecimal -Hex "0xE2B458")] = (GetDecimal -Hex "0x24")
        $ByteArray[(GetDecimal -Hex "0xE2B459")] = 1
        $ByteArray[(GetDecimal -Hex "0xE2B45A")] = 0
        $ByteArray[(GetDecimal -Hex "0xE2B45B")] = (GetDecimal -Hex "0x3F")
        $ByteArray[(GetDecimal -Hex "0xE2B45C")] = (GetDecimal -Hex "0x31")
        $ByteArray[(GetDecimal -Hex "0xE2B45D")] = (GetDecimal -Hex "0x4A")
        $ByteArray[(GetDecimal -Hex "0xE2B45E")] = 0
        $ByteArray[(GetDecimal -Hex "0xE2B45F")] = (GetDecimal -Hex "0x3F")
        $ByteArray[(GetDecimal -Hex "0xE2B460")] = 0
        $ByteArray[(GetDecimal -Hex "0xE2B461")] = 0
        $ByteArray[(GetDecimal -Hex "0xE2B462")] = 0
        $ByteArray[(GetDecimal -Hex "0xE2B463")] = 0
    }

    if (CheckCheckBox -CheckBox $ReturnChildOoT) {
        $ByteArray[(GetDecimal -Hex "0xCB6844")] = (GetDecimal -Hex "0x35")
        $ByteArray[(GetDecimal -Hex "0x253C0E2")] = 3
    }

    if (CheckCheckBox -CheckBox $DisableLowHPSoundOoT) {
        $ByteArray[(GetDecimal -Hex "0xADBA1A")] = 0
        $ByteArray[(GetDecimal -Hex "0xADBA1B")] = 0
    }

    if (CheckCheckBox -CheckBox $DisableNaviooT) {
        $ByteArray[(GetDecimal -Hex "0xDF8B84")] = 0
        $ByteArray[(GetDecimal -Hex "0xDF8B85")] = 0
        $ByteArray[(GetDecimal -Hex "0xDF8B86")] = 0
        $ByteArray[(GetDecimal -Hex "0xDF8B87")] = 0
    }

    if (CheckCheckBox -CheckBox $HideDPadOOT)   { $ByteArray[(GetDecimal -Hex "0x348086E")] = (GetDecimal -Hex "0x00") }



    # Finished
    return $ByteArray

}



#==============================================================================================================================================================================================
function PatchReduxMM($ByteArray) {
    
    # HERO MODE #

    if (CheckCheckBox -CheckBox $OHKOModeMM) {
        $ByteArray[(GetDecimal -Hex "0xBABE7F")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0xBABE8F")] = (GetDecimal -Hex "0x04")
        $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x2A")
        $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x00")
        $ByteArray[(GetDecimal -Hex "0xBABEA5")] = (GetDecimal -Hex "0x00")
        $ByteArray[(GetDecimal -Hex "0xBABEA6")] = (GetDecimal -Hex "0x00")
        $ByteArray[(GetDecimal -Hex "0xBABEA7")] = (GetDecimal -Hex "0x00")
    }
    elseif (!(CheckCheckBox -CheckBox $1xDamageMM) -and !(CheckCheckBox -CheckBox $NormalRecoveryMM)) {
        $ByteArray[(GetDecimal -Hex "0xBABE7F")] = (GetDecimal -Hex "0x09")
        $ByteArray[(GetDecimal -Hex "0xBABE8F")] = (GetDecimal -Hex "0x04")
        if (CheckCheckBox -CheckBox $NormalRecoveryMM) {
            $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x28")
            if (CheckCheckBox -CheckBox $2xDamageMM)       { $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x40") }
            elseif (CheckCheckBox -CheckBox $4xDamageMM)   { $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x80") }
            elseif (CheckCheckBox -CheckBox $8xDamageMM)   { $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0xC0") }
            $ByteArray[(GetDecimal -Hex "0xBABEA5")] = (GetDecimal -Hex "0x00")
            $ByteArray[(GetDecimal -Hex "0xBABEA6")] = (GetDecimal -Hex "0x00")
            $ByteArray[(GetDecimal -Hex "0xBABEA7")] = (GetDecimal -Hex "0x00")
        }
        elseif (CheckCheckBox -CheckBox $HalfRecoveryMM) {
            if (CheckCheckBox -CheckBox $1xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x28")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x40")
            }
            elseif (CheckCheckBox -CheckBox $2xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x28")
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x80")
            }
            elseif (CheckCheckBox -CheckBox $4xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x28")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0xC0")
            }
            elseif (CheckCheckBox -CheckBox $8xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x29")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x00")
            }
            $ByteArray[(GetDecimal -Hex "0xBABEA5")] = (GetDecimal -Hex "0x05")
            $ByteArray[(GetDecimal -Hex "0xBABEA6")] = (GetDecimal -Hex "0x28")
            $ByteArray[(GetDecimal -Hex "0xBABEA7")] = (GetDecimal -Hex "0x43")
        }
        elseif (CheckCheckBox -CheckBox $QuarterRecoveryMM) {
            if (CheckCheckBox -CheckBox $1xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x28")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x80")
            }
            elseif (CheckCheckBox -CheckBox $2xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x28")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0xC0")
            }
            elseif (CheckCheckBox -CheckBox $4xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x29")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x00")
            }
            elseif (CheckCheckBox -CheckBox $8xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x29")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x40")
            }
            $ByteArray[(GetDecimal -Hex "0xBABEA5")] = (GetDecimal -Hex "0x05")
            $ByteArray[(GetDecimal -Hex "0xBABEA6")] = (GetDecimal -Hex "0x28")
            $ByteArray[(GetDecimal -Hex "0xBABEA7")] = (GetDecimal -Hex "0x83")
        }
        elseif (CheckCheckBox -CheckBox $NoRecoveryMM) {
            if (CheckCheckBox -CheckBox $1xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x29")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x40")
            }
            elseif (CheckCheckBox -CheckBox $2xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x29")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x80")
            }
            elseif (CheckCheckBox -CheckBox $4xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x29")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0xC0")
            }
            elseif (CheckCheckBox -CheckBox $8xDamageMM) {
                $ByteArray[(GetDecimal -Hex "0xBABEA2")] = (GetDecimal -Hex "0x2A")
                $ByteArray[(GetDecimal -Hex "0xBABEA3")] = (GetDecimal -Hex "0x00")
            }
            $ByteArray[(GetDecimal -Hex "0xBABEA5")] = (GetDecimal -Hex "0x05")
            $ByteArray[(GetDecimal -Hex "0xBABEA6")] = (GetDecimal -Hex "0x29")
            $ByteArray[(GetDecimal -Hex "0xBABEA7")] = (GetDecimal -Hex "0x43")
        }
    }



    # D-PAD #

    if (CheckCheckBox -CheckBox $LeftDPadMM)        { $ByteArray[(GetDecimal -Hex "0x3806365")] = 1  }
    elseif (CheckCheckBox -CheckBox $RightDPadMM)   { $ByteArray[(GetDecimal -Hex "0x3806365")] = 2 }
    elseif (CheckCheckBox -CheckBox $HideDPadMM)    { $ByteArray[(GetDecimal -Hex "0x3806365")] = 0 }



    # GRAPHICS #

    if (CheckCheckBox -CheckBox $WideScreenMM) {
        $ByteArray[(GetDecimal -Hex "0xBD5D74")] = (GetDecimal -Hex "0x3C")
        $ByteArray[(GetDecimal -Hex "0xBD5D75")] = (GetDecimal -Hex "0x07")
        $ByteArray[(GetDecimal -Hex "0xBD5D76")] = (GetDecimal -Hex "0x3F")
        $ByteArray[(GetDecimal -Hex "0xBD5D77")] = (GetDecimal -Hex "0xE3")

        $ByteArray[(GetDecimal -Hex "0xCA58F5")] = (GetDecimal -Hex "0x6C")
        $ByteArray[(GetDecimal -Hex "0xCA58F7")] = (GetDecimal -Hex "0x53")
        $ByteArray[(GetDecimal -Hex "0xCA58F9")] = (GetDecimal -Hex "0x6C")
        $ByteArray[(GetDecimal -Hex "0xCA58FB")] = (GetDecimal -Hex "0x84")
        $ByteArray[(GetDecimal -Hex "0xCA58FD")] = (GetDecimal -Hex "0x9E")
        $ByteArray[(GetDecimal -Hex "0xCA58FF")] = (GetDecimal -Hex "0xB7")
        $ByteArray[(GetDecimal -Hex "0xCA5901")] = (GetDecimal -Hex "0x53")
        $ByteArray[(GetDecimal -Hex "0xCA5903")] = (GetDecimal -Hex "0x6C")
    }

    if (CheckCheckBox -CheckBox $ExtendedDrawMM) {
        $ByteArray[(GetDecimal -Hex "0xB50874")] = 0
        $ByteArray[(GetDecimal -Hex "0xB50875")] = 0
        $ByteArray[(GetDecimal -Hex "0xB50876")] = 0
        $ByteArray[(GetDecimal -Hex "0xB50877")] = 0
    }

    if (CheckCheckBox -CheckBox $BlackBarsMM) {
        $ByteArray[(GetDecimal -Hex "0xBF72A4")] = 0
        $ByteArray[(GetDecimal -Hex "0xBF72A5")] = 0
        $ByteArray[(GetDecimal -Hex "0xBF72A6")] = 0
        $ByteArray[(GetDecimal -Hex "0xBF72A7")] = 0
    }

    if (CheckCheckBox -CheckBox $PixelatedStarsMM) {
        $ByteArray[(GetDecimal -Hex "0xB943FC")] = (GetDecimal -Hex "0x10")
        $ByteArray[(GetDecimal -Hex "0xB943FD")] = 0
    }



    # EQUIPMENT #

    if (CheckCheckBox -CheckBox $ReducedItemCapacityMM) {
        $ByteArray[(GetDecimal -Hex "0xC5834F")] = 20
        $ByteArray[(GetDecimal -Hex "0xC58351")] = 25
        $ByteArray[(GetDecimal -Hex "0xC58353")] = 30
        $ByteArray[(GetDecimal -Hex "0xC58357")] = 10
        $ByteArray[(GetDecimal -Hex "0xC58359")] = 15
        $ByteArray[(GetDecimal -Hex "0xC5835B")] = 20
        $ByteArray[(GetDecimal -Hex "0xC5837F")] = 5
        $ByteArray[(GetDecimal -Hex "0xC58381")] = 10
        $ByteArray[(GetDecimal -Hex "0xC58383")] = 15
        $ByteArray[(GetDecimal -Hex "0xC58387")] = 10
        $ByteArray[(GetDecimal -Hex "0xC58389")] = 15
        $ByteArray[(GetDecimal -Hex "0xC5838B")] = 20
    }
    elseif (CheckCheckBox -CheckBox $IncreasedIemCapacityMM) {
        $ByteArray[(GetDecimal -Hex "0xC5834F")] = 40
        $ByteArray[(GetDecimal -Hex "0xC58351")] = 70
        $ByteArray[(GetDecimal -Hex "0xC58353")] = 99
        $ByteArray[(GetDecimal -Hex "0xC58357")] = 30
        $ByteArray[(GetDecimal -Hex "0xC58359")] = 55
        $ByteArray[(GetDecimal -Hex "0xC5835B")] = 80
        $ByteArray[(GetDecimal -Hex "0xC5837F")] = 15
        $ByteArray[(GetDecimal -Hex "0xC58381")] = 30
        $ByteArray[(GetDecimal -Hex "0xC58383")] = 45
        $ByteArray[(GetDecimal -Hex "0xC58387")] = 30
        $ByteArray[(GetDecimal -Hex "0xC58389")] = 55
        $ByteArray[(GetDecimal -Hex "0xC5838B")] = 80
    }

    if (CheckCheckBox -CheckBox $RazorSwordMM) {
        $ByteArray[(GetDecimal -Hex "0xCBA496")] = 0 # Prevent losing hits
        $ByteArray[(GetDecimal -Hex "0xCBA497")] = 0
        $ByteArray[(GetDecimal -Hex "0xBDA6B7")] = 1 # Keep sword after Song of Time
    }



    # OTHER #
    
    if (CheckCheckBox -CheckBox $DisableLowHPSoundMM) {
        $ByteArray[(GetDecimal -Hex "0xB97E2A")] = 0
        $ByteArray[(GetDecimal -Hex "0xB97E2B")] = 0
    }

    if (CheckCheckBox -CheckBox $PieceOfHeartSoundMM) {
        $ByteArray[(GetDecimal -Hex "0xBA94C8")] = (GetDecimal -Hex "0x10")
        $ByteArray[(GetDecimal -Hex "0xBA94C9")] = (GetDecimal -Hex "0x00")
    }



    # Finished
    return $ByteArray

}


#==============================================================================================================================================================================================
function ExtendROM() {
    
    if ($GameType -ne "Majora's Mask") { return }

    $Bytes = @(08, 00, 00, 00)
    $ByteArray = [IO.File]::ReadAllBytes($ROMFile)
    [io.file]::WriteAllBytes($ROMFile, $Bytes + $ByteArray)

    $ByteArray = $null
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function CheckGameID() {
    
    # Return if freely patching, injecting or extracting
    if ($GameType -eq "Free" -or $GetCommand -eq "Inject" -or $GetCommand -eq "Extract" -or $GetCommand -eq "Patch VC") { return $True }

    # Set the status label.
    UpdateStatusLabelDuringPatching -Text 'Checking GameID in .tmd...'

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
            UpdateStatusLabelDuringPatching -Text ('Failed! This is not an vanilla ' + $GameType + ' USA VC WAD file.')
            # Stop wasting time.
            return $False
        }
    }

    $CompareArray = $null
    $CompareAgainst = $null
    [System.GC]::Collect() | Out-Null

    return $True

}



#==============================================================================================================================================================================================
function SetCustomGameID() {
    
    if (!$InputCustomGameIDCheckbox.Checked -or !$IsWiiVC)                                   { return }
    if ($InputCustomGameIDTextbox.TextLength -eq 4)                                          { $global:GameID = $InputCustomGameIDTextBox.Text }
    if ($InputCustomChannelTitleTextBox.TextLength -gt 0 -and $global:GameType -ne "Free")   { $global:ChannelTitle = $InputCustomChannelTitleTextBox.Text }

}



#==============================================================================================================================================================================================
function HackOpeningBNRTitle() {
    
    # Set the status label.
    UpdateStatusLabelDuringPatching -Text 'Hacking in Opening.bnr custom title...'

    # Get the "00000000.app" file as a byte array.
    $ByteArray = [IO.File]::ReadAllBytes($WadFile.AppFile00)

    # Initially assume the two chunks of data are identical.
    $Identical = $true

    $Start = 0

    # Scan only the contents of the IMET header within the file.
    for ($i=128; $i-lt 1583; $i++) {
        # Search each byte for hex 5A (90 decimal) which is a capital "Z".
        if ($ByteArray[$i] -eq 90 -and $GameType -eq "Ocarina of Time") {
            
            # This actually spells "Zelda: Ocarina" in a weird way. It will be used to find matches.
            $CompareArray = @(90, 00, 101, 00, 108, 00, 100, 00, 97, 00, 58, 00, 32, 00, 79, 00, 99, 00, 97, 00, 114, 00, 105, 00, 110, 00, 97)

            # Grab a chunk of the header starting with the byte matching "Z".
            $CompareAgainst = $ByteArray[$i..($i+26)]
            
            # Check each value of the array.
            for ($z=0; $z-le $CompareAgainst.Length; $z++) {
                # The current values do not match.
                if ($CompareArray[$z] -ne $CompareAgainst[$z]) {
                    # This is not a "Zelda: Ocarina" entry.
                    $Identical = $false
                    break
                }
            }

            if ($Identical = $false) {
                return
            }

            if ($ByteArray[$i-2] -eq 00) {
                $Start = $i
            }

            for ($j=0; $j-lt $ChannelTitleLength; $j++) {
                $ByteArray[$Start + ($j*2)] = 00
            }

            for ($j=0; $j-lt $ChannelTitle.Length; $j++) {
                $Dec = [int][char]$ChannelTitle.Substring($j, 1)
                $ByteArray[$Start + ($j*2)] = $Dec
            }

            # Overwrite the patch file with the extended file.
            [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)

        }

        # Search each byte for hex 5A (90 decimal) which is a capital "Z".
        elseif ($ByteArray[$i] -eq 90 -and $GameType -eq "Majora's Mask") {
            
            # This actually spells "Zelda: Majora's" in a weird way. It will be used to find matches.
            $CompareArray = @(90, 00, 101, 00, 108, 00, 100, 00, 97, 00, 58, 00, 32, 00, 77, 00, 97, 00, 106, 00, 111, 00, 114, 00, 97, 00, 39, 00, 115)

            # Grab a chunk of the header starting with the byte matching "Z".
            $CompareAgainst = $ByteArray[$i..($i+28)]

            # Check each value of the array.
            for ($z=0; $z-le $CompareAgainst.Length; $z++) {
                # The current values do not match.
                if ($CompareArray[$z] -ne $CompareAgainst[$z]) {
                    # This is not a "Zelda: Majora's" entry.
                    $Identical = $false
                    break
                }
            }

            if ($Identical = $false) {
                return
            }

            if ($ByteArray[$i-2] -eq 00) {
                $Start = $i
            }

            for ($j=0; $j-lt $ChannelTitleLength; $j++) {
                $ByteArray[$Start + ($j*2)] = 00
            }

            for ($j=0; $j-lt $ChannelTitle.Length; $j++) {
                $Dec = [int][char]$ChannelTitle.Substring($j, 1)
                $ByteArray[$Start + ($j*2)] = $Dec
            }

            # Overwrite the patch file with the extended file.
            [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)

        }

        # Search each byte for hex 53 (83 decimal) which is a capital "S".
        elseif ($ByteArray[$i] -eq 83 -and $GameType -eq "Super Mario 64") {
            
            # This actually spells "Super Mario 64" in a weird way. It will be used to find matches.
            $CompareArray = @(83, 00, 117, 00, 112, 00, 101, 00, 114, 00, 32, 00, 77, 00, 97, 00, 114, 00, 105, 00, 111, 00, 32, 00, 54, 00, 52)

            # Grab a chunk of the header starting with the byte matching "S".
            $CompareAgainst = $ByteArray[$i..($i+26)]

            # Check each value of the array.
            for ($z=0; $z-le $CompareAgainst.Length; $z++) {
                # The current values do not match.
                if ($CompareArray[$z] -ne $CompareAgainst[$z]) {
                    # This is not a "Super Mario 64" entry.
                    $Identical = $false
                    break
                }
            }

            if ($Identical = $false) {
                return
            }

            if ($ByteArray[$i-2] -eq 00) {
                $Start = $i
            }

            for ($j=0; $j-lt $ChannelTitleLength; $j++) {
                $ByteArray[$Start + ($j*2)] = 00
            }

            for ($j=0; $j-lt $ChannelTitle.Length; $j++) {
                $Dec = [int][char]$ChannelTitle.Substring($j, 1)
                $ByteArray[$Start + ($j*2)] = $Dec
            }

            # Overwrite the patch file with the extended file.
            [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)

        }

        # Search each byte for hex 50 (80 decimal) which is a capital "P".
        elseif ($ByteArray[$i] -eq 80 -and $GameType -eq "Paper Mario") {
            
            # This actually spells "Paper Mario" in a weird way. It will be used to find matches.
            $CompareArray = @(80, 00, 97, 00, 112, 00, 101, 00, 114, 00, 32, 00, 77, 00, 97, 00, 114, 00, 105, 00, 111)

            # Grab a chunk of the header starting with the byte matching "P".
            $CompareAgainst = $ByteArray[$i..($i+20)]

            # Check each value of the array.
            for ($z=0; $z-le $CompareAgainst.Length; $z++) {
                # The current values do not match.
                if ($CompareArray[$z] -ne $CompareAgainst[$z]) {
                    # This is not a "Paper Mario" entry.
                    $Identical = $false
                    break
                }
            }

            if ($Identical = $false) {
                return
            }

            if ($ByteArray[$i-2] -eq 00) {
                $Start = $i
            }

            for ($j=0; $j-lt $ChannelTitleLength; $j++) {
                $ByteArray[$Start + ($j*2)] = 00
            }

            for ($j=0; $j-lt $ChannelTitle.Length; $j++) {
                $Dec = [int][char]$ChannelTitle.Substring($j, 1)
                $ByteArray[$Start + ($j*2)] = $Dec
            }

            # Overwrite the patch file with the extended file.
            [IO.File]::WriteAllBytes($WadFile.AppFile00, $ByteArray)

        }

    }

}



#==============================================================================================================================================================================================
function RepackU8AppFile() {
    
    # Set the status label.
    UpdateStatusLabelDuringPatching -Text 'Repacking "00000005.app" file...'

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
    UpdateStatusLabelDuringPatching -Text 'Repacking patched WAD file...'
    
    # Loop through all files in the extracted WAD folder.
    foreach($File in Get-ChildItem -LiteralPath $WadFile.Folder -Force) {
        # Move the file to the same folder as the unpacker tool.
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
        UpdateStatusLabelDuringPatching -Text 'Complete! File successfully patched.'
    }
    # If the patched file failed to be created, set the status label to failed.
    UpdateStatusLabelDuringPatching -Text "Failed! Patched Wii VC WAD was not created."

    # Remove the folder the extracted files were in, and delete files
    RemovePath -LiteralPath $WadFile.Folder

    # Doesn't matter, but return to where we were.
    Pop-Location

}



#==================================================================================================================================================================================================================================================================
function EnablePatchButtons([boolean]$Enable) {
    
    # Set the status that we are ready to roll... Or not...
    if ($Enable)        { $StatusLabel.Text = 'Ready to patch!' }
    elseif ($IsWiiVC)   { $StatusLabel.Text = 'Select your Virtual Console WAD file to continue.' }
    else                { $StatusLabel.Text = 'Select your Nintendo 64 ROM file to continue.' }

    if ($IsWiiVC)      {
        $InjectROMButton.Enabled = ($WADFilePath -ne $null -and $Z64FilePath -ne $null)
        $PatchBPSButton.Enabled = ($WADFilePath -ne $null -and $BPSFilePath -ne $null) } else { $PatchBPSButton.Enabled = ($Z64FilePath -ne $null -and $BPSFilePath -ne $null)
   }
    
    # Enable patcher buttons.
    $PatchOoTReduxButton.Enabled = $Enable
    $PatchOoTReduxOptionsButton.Enabled = $Enable
    $PatchOoTDawnButton.Enabled = $Enable
    $PatchOoTBombiwaButton.Enabled = $Enable
    $PatchOoTSpaButton.Enabled = $Enable
    $PatchOoTPolButton.Enabled = $Enable
    $PatchOoTRusButton.Enabled = $Enable
    $PatchOoTChiButton.Enabled = $Enable

    $PatchMMReduxButton.Enabled = $Enable
    $PatchMMReduxOptionsButton.Enabled = $Enable
    $PatchMMMaskedQuestButton.Enabled = $Enable
    $PatchMMPolButton.Enabled = $Enable
    $PatchMMRusButton.Enabled = $Enable

    $PatchSM64FPSButton.Enabled = $Enable
    $PatchSM64CamButton.Enabled = $Enable
    $PatchSM64MultiplayerButton.Enabled = $Enable

    $PatchPPHardMode.Enabled = $Enable
    $PatchPPHardModePlus.Enabled = $Enable
    $PatchPPInsaneMode.Enabled = $Enable

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

    EnablePatchButtons -Enable $true

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

    Write-Host (Get-FileHash -Algorithm SHA256 $Z64Path).Hash

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

    # Create ToolTip
    $ToolTip = CreateToolTip

    # Create a label to show current mode.
    $global:CurrentModeLabel = CreateLabel -Font $CurrentModeFont -AddTo $MainDialog
    $CurrentModeLabel.AutoSize = $True

    # Create a label to show current version.
    $global:VersionLabel = CreateLabel -X 15 -Y 10 -Width 120 -Height 20 -Text ("Version: " + $Version) -Font $VCPatchFont -AddTo $MainDialog



    ############
    # WAD Path #
    ############

    # Create the panel that holds the WAD path.
    $global:InputWADPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the WAD path.
    $global:InputWADGroup = CreateGroupBox -Width $InputWADPanel.Width -Height $InputWADPanel.Height -Name "GameWAD" -Text "WAD Path" -AddTo $InputWADPanel
    $InputWADGroup.AllowDrop = $true
    $InputWADGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADGroup.Add_DragDrop({ WADPath_DragDrop })

    # Create a textbox to display the selected WAD.
    $global:InputWADTextBox = CreateTextBox -X 10 -Y 20 -Width 540 -Height 22 -Name "GameWAD" -Text "Select or drag and drop your Virtual Console WAD file..." -AddTo $InputWADGroup
    $InputWADTextBox.AllowDrop = $true
    $InputWADTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADTextBox.Add_DragDrop({ WADPath_DragDrop })

    # Create a button to allow manually selecting a WAD.
    $global:InputWADButton = CreateButton -X 556 -Y 18 -Width 24 -Height 22 -Name "GameWAD" -Text "..." -ToolTip $ToolTip -Info "Select your VC WAD File using file explorer" -AddTo $InputWADGroup
    $InputWADButton.Add_Click({ WADPath_Button -TextBox $InputWADTextBox -Description 'VC WAD File' -FileName '*.wad' })



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
    $InjectROMButton.Add_Click({ MainFunctionPatch -Command "Inject" -Id $null -Title $null -Patch $null -PatchedFile '_injected' -Hash $null -Compress $False })



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
    $global:InputBPSButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameBPS" -Text "..." -ToolTip $ToolTip -Info "Select your BPS or IPS Patch File using file explorer" -AddTo $InputBPSGroup
    $InputBPSButton.Add_Click({ BPSPath_Button -TextBox $InputBPSTextBox -Description @('BPS Patch File', 'IPS Patch File') -FileName @('*.bps', '*.ips') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $global:PatchBPSButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Patch BPS" -ToolTip $ToolTip -Info "Patch the ROM with your selected BPS or IPS Patch File" -AddTo $InputBPSGroup
    $PatchBPSButton.Add_Click({ MainFunctionPatch -Command "Patch BPS" -Id $null -Title $null -Patch $BPSFilePath -PatchedFile '_bps_patched' -Hash $null -Compress $False })



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
    $InputCustomChannelTitleTextBox.MaxLength = $global:ChannelTitleLength
    $InputCustomChannelTitleTextBox.Add_TextChanged({
        if ($this.Text -match "[^a-z 0-9 : - ']") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text -replace "[^a-z 0-9 : - ']",''
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




    #####################
    # OoT Patch Buttons #
    #####################

    # Create a panel to contain everything for SM64.
    $global:PatchOoTPanel = CreatePanel -Width 590 -Height 170 -AddTo $MainDialog

    # Create a groupbox to show the OoT patching buttons.
    $PatchOoTReduxGroup = CreateGroupBox -Width ($PatchOoTPanel.Width/2-5) -Height ($PatchOoTPanel.Height/2) -Text "Ocarina of Time - REDUX Buttons" -AddTo $PatchOoTPanel

    # Create a button to allow patching the WAD (OoT Redux).
    $global:PatchOoTReduxButton = CreateButton -X 75 -Y 30 -Width 100 -Height 35 -Text "OoT Redux" -ToolTip $ToolTip -Info "A romhack that improves mechanics for Ocarina of Time`nIt includes the use of the D-Pad for additional dedicated item buttons`nSupports rev0 US ROM File only" -AddTo $PatchOoTReduxGroup
    $PatchOoTReduxButton.Add_Click({ MainFunctionOoTRedux -Command "Downgrade" -Hash $HashSum_oot_rev0 -Compress $False })

    # Create a button to select additional Redux options.
    $global:PatchOoTReduxOptionsButton = CreateButton -X $PatchOoTReduxButton.Right -Y 30 -Width 40 -Height 35 -Text "+" -ToolTip $ToolTip -Info "Toggle additional features for the Ocarina of Time REDUX romhack" -AddTo $PatchOoTReduxGroup
    $PatchOoTReduxOptionsButton.Add_Click({ $OoTReduxOptionsDialog.ShowDialog() })

    # Create a groupbox to show the OoT patching buttons.
    $PatchOoTHackGroup = CreateGroupBox -X ($PatchOoTReduxGroup.Right + 10)  -Width ($PatchOoTPanel.Width/2-5) -Height ($PatchOoTPanel.Height/2) -Text "Ocarina of Time - ROM Hack Buttons" -AddTo $PatchOoTPanel

    # Create a button to allow patching the WAD (OoT Dawn and Dusk).
    $global:PatchOoTDawnButton = CreateButton -X 35 -Y 30 -Width 100 -Height 35 -Text "Dawn and Dusk" -ToolTip $ToolTip -Info "A small-sized romhack in a completely new setting`nSupports rev0, rev1 or rev2 US ROM Files" -AddTo $PatchOoTHackGroup
    $PatchOoTDawnButton.Add_Click({ MainFunctionPatch -Command "No Downgrade" -Id "NAC1" -Title "Zelda: Dawn & Dusk" -Patch $Files.bpspatch_oot_dawn_rev0 -PatchedFile '_dawn_&_dusk_patched' -Hash "Dawn & Dusk" -Compress $False })

    # Create a button to allow patching the WAD (OoT The Fate of the Bombiwa).
    $global:PatchOoTBombiwaButton = CreateButton -X ($PatchOoTDawnButton.Right + 15) -Y 30 -Width 100 -Height 35 -Text "Bombiwa" -ToolTip $ToolTip -Info "A small-sized romhack in a completely new setting, and extremely tricky and difficult`nSupports rev0 US ROM File only" -AddTo $PatchOoTHackGroup
    $PatchOoTBombiwaButton.Add_Click({ MainFunctionPatch -Command "Downgrade" -Id "NAC2" -Title "Zelda: Bombiwa" -Patch $Files.bpspatch_oot_bombiwa -PatchedFile '_bombiwa_patched' -Hash $HashSum_oot_rev0 -Compress $True })

    # Create a groupbox to show the OoT patching buttons.
    $PatchOoTTranslationGroup = CreateGroupBox -Y $PatchOoTReduxGroup.Bottom -Width $PatchOoTPanel.Width -Height ($PatchOoTPanel.Height/2) -Text "Ocarina of Time - Translation Buttons" -AddTo $PatchOoTPanel

    # Create a button to allow patching the WAD (OoT Spanish).
    $global:PatchOoTSpaButton = CreateButton -X 50 -Y 30 -Width 100 -Height 35 -Text "Spanish Translation" -ToolTip $ToolTip -Info "Spanish Fan-Translation of Ocarina of Time`nSupports rev0 US ROM File only" -AddTo $PatchOoTTranslationGroup
    $PatchOoTSpaButton.Add_Click({ MainFunctionPatch -Command "Downgrade" -Id "NACS" -Title "Zelda: Ocarina (SPA)" -Patch $Files.bpspatch_oot_spa -PatchedFile "_spanish_patched" -Hash $HashSum_oot_rev0 -Compress $False })

    # Create a button to allow patching the WAD (OoT Polish).
    $global:PatchOoTPolButton = CreateButton -X ($PatchOoTSpaButton.Right + 30) -Y 30 -Width 100 -Height 35 -Text "Polish Translation" -ToolTip $ToolTip -Info "Polish Fan-Translation of Ocarina of Time`nSupports rev0 US ROM File only" -AddTo $PatchOoTTranslationGroup
    $PatchOoTPolButton.Add_Click({ MainFunctionPatch -Command "Downgrade" -Id "NACO" -Title "Zelda: Ocarina (POL)" -Patch $Files.bpspatch_oot_pol -PatchedFile "_polish_patched" -Hash $HashSum_oot_rev0 -Compress $False })

    # Create a button to allow patching the WAD (OoT Russian).
    $global:PatchOoTRusButton = CreateButton -X ($PatchOoTPolButton.Right + 30) -Y 30 -Width 100 -Height 35 -Text "Russian Translation" -ToolTip $ToolTip -Info "Russian Fan-Translation of Ocarina of Time`nSupports rev0 US ROM File only" -AddTo $PatchOoTTranslationGroup
    $PatchOoTRusButton.Add_Click({ MainFunctionPatch -Command "Downgrade" -Id "NACR" -Title "Zelda: Ocarina (RUS)" -Patch $Files.bpspatch_oot_rus -PatchedFile '_russian_patched' -Hash $HashSum_oot_rev0 -Compress $False })

    # Create a button to allow patching the WAD (OoT Chinese Simplified).
    $global:PatchOoTChiButton = CreateButton -X ($PatchOoTRusButton.Right + 30) -Y 30 -Width 100 -Height 35 -Text "Chinese Translation" -ToolTip $ToolTip -Info "Chinese Fan-Translation of Ocarina of Time`nSupports rev0 US ROM File only" -AddTo $PatchOoTTranslationGroup
    $PatchOoTChiButton.Add_Click({ MainFunctionPatch -Command "Downgrade" -Id "NACC" -Title "Zelda: Ocarina (CHI)" -Patch $Files.bpspatch_oot_chi -PatchedFile "_chinese_patched" -Hash $HashSum_oot_rev0 -Compress $False })



    ####################
    # MM Patch Buttons #
    ####################

    # Create a panel to contain everything for SM64.
    $global:PatchMMPanel = CreatePanel -Width 590 -Height 170 -AddTo $MainDialog

    # Create a groupbox to show the MM patching buttons.
    $PatchMMReduxGroup = CreateGroupBox -Width ($PatchMMPanel.Width/2-5) -Height ($PatchMMPanel.Height/2) -Text "Majora's Mask - REDUX Buttons" -AddTo $PatchMMPanel

    # Create a button to allow patching the WAD (MM Redux).
    $global:PatchMMReduxButton = CreateButton -X 75 -Y 30 -Width 100 -Height 35 -Text "MM Redux" -ToolTip $ToolTip -Info "A romhack that improves mechanics for Majorea's Mask`nIt includes the use of the D-Pad for additional dedicated item buttons`nSupports US ROM File only" -AddTo $PatchMMReduxGroup
    $PatchMMReduxButton.Add_Click({ MainFunctionMMRedux -Command $null -Hash $HashSum_mm -Compress $False })

    # Create a button to select additional Redux options.
    $global:PatchMMReduxOptionsButton = CreateButton -X $PatchMMReduxButton.Right -Y 30 -Width 40 -Height 35 -Text "+" -ToolTip $ToolTip -Info "Toggle additional features for the Majora's Mask REDUX romhack" -AddTo $PatchMMReduxGroup
    $PatchMMReduxOptionsButton.Add_Click({ $MMReduxOptionsDialog.ShowDialog() })

    # Create a groupbox to show the MM patching buttons.
    $PatchMMHackGroup = CreateGroupBox -X ($PatchMMReduxGroup.Right + 10) -Width ($PatchMMPanel.Width/2-5) -Height ($PatchMMPanel.Height/2) -Text "Majora's Mask - ROM Hack Buttons" -AddTo $PatchMMPanel

    # Create a button to allow patching the WAD (MM Masked Quest).
    $global:PatchMMMaskedQuestButton = CreateButton -X 100 -Y 30 -Width 100 -Height 35 -Text "Masked Quest" -ToolTip $ToolTip -Info "A Master Quest style romhack for Majora's Mask, offering a higher difficulty`nSupports US ROM File only" -AddTo $PatchMMHackGroup
    $PatchMMMaskedQuestButton.Add_Click({ MainFunctionPatchRemap -Command $null -Id "NAR1" -Title "Zelda: Masked Quest" -Patch $Files.bpspatch_mm_masked_quest -PatchedFile "_masked_quest_patched" -Hash $HashSum_mm -Compress $False })

    # Create a groupbox to show the MM patching buttons.
    $PatchMMTranslationGroup = CreateGroupBox -Y $PatchMMReduxGroup.Bottom -Width $PatchMMPanel.Width -Height ($PatchMMPanel.Height/2) -Text "Majora's Mask - Translation Buttons" -AddTo $PatchMMPanel

    # Create a button to allow patching the WAD (MM Polish).
    $global:PatchMMPolButton = CreateButton -X 180 -Y 30 -Width 100 -Height 35 -Text "Polish Translation" -ToolTip $ToolTip -Info "Polish Fan-Translation of Majora's Mask`nSupports US ROM File only" -AddTo $PatchMMTranslationGroup
    $PatchMMPolButton.Size = New-Object System.Drawing.Size(100, 35)
    $PatchMMPolButton.Add_Click({ MainFunctionPatch -Command $null -Id "NARO" -Title "Zelda: Majora's (POL)" -Patch $Files.bpspatch_mm_pol -PatchedFile "_polish_patched" -Hash $HashSum_mm -Compress $False })

    # Create a button to allow patching the WAD (MM Russian).
    $global:PatchMMRusButton = CreateButton -X ($PatchMMPolButton.Right + 30) -Y 30 -Width 100 -Height 35 -Text "Russian Translation" -ToolTip $ToolTip -Info "Polish Fan-Translation of Majora's Mask`nSupports US ROM File only" -AddTo $PatchMMTranslationGroup
    $PatchMMRusButton.Add_Click({ MainFunctionPatch -Command $null -Id "NARR" -Title "Zelda: Majora's (RUS)" -Patch $Files.bpspatch_mm_rus -PatchedFile "_russian_patched" -Hash $HashSum_mm -Compress $False })



    ######################
    # SM64 Patch Buttons #
    ######################

    # Create a panel to contain everything for SM64.
    $global:PatchSM64Panel = CreatePanel -Width 590 -Height 80 -AddTo $MainDialog

    # Create a groupbox to show the SM64 patching buttons.
    $PatchSM64Group = CreateGroupBox -Width $PatchSM64Panel.Width -Height $PatchSM64Panel.Height -Text "Super Mario 64 - Patch Buttons" -AddTo $PatchSM64Panel

    # Create a button to allow patching the WAD (SM64 60 FPS V2).
    $global:PatchSM64FPSButton = CreateButton -X 130 -Y 25 -Width 100 -Height 35 -Text "60 FPS v2" -ToolTip $ToolTip -Info "Increases the FPS from 30 to 60`nWtiness Super Mario 64 in glorious 60 FPS`nSupports US ROM File only" -AddTo $PatchSM64Group
    $PatchSM64FPSButton.Add_Click({ MainFunctionPatch -Command $null -Id "NAAX" -Title "Super Mario 64: 60 FPS v2" -Patch $Files.bpspatch_sm64_fps -PatchedFile "_60_fps_v2_patched" -Hash $HashSum_sm64 -Compress $False })

    # Create a button to allow patching the WAD (SM64 Analog Camera).
    $global:PatchSM64CamButton = CreateButton -X ($PatchSM64FPSButton.Right + 15) -Y $PatchSM64FPSButton.Top -Width 100 -Height 35 -Text "Analog Camera" -ToolTip $ToolTip -AddTo $PatchSM64Group
    $ToolTip.SetToolTip($PatchSM64CamButton, "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Analog stick to the C-Stick on the first emulated controller`nSupports US ROM File only")
    $PatchSM64CamButton.Add_Click({ MainFunctionPatch -Command $null -Id "NAAY" -Title "Super Mario 64: Free Cam" -Patch $Files.bpspatch_sm64_cam -PatchedFile "_analog_camera_patched" -Hash $HashSum_sm64 -Compress $False })

    # Create a button to allow patching the WAD (SM64 Multiplayer).
    $global:PatchSM64MultiplayerButton = CreateButton -X ($PatchSM64CamButton.Right + 15) -Y $PatchSM64FPSButton.Top -Width 100 -Height 35 -Text "Multiplayer v1.4.2" -ToolTip $ToolTip -Info "Single-Screen Multiplayer with Mario and Luigi`nPlugin a second emulated controller for Luigi`nSupports US ROM File only" -AddTo $PatchSM64Group
    $PatchSM64MultiplayerButton.Add_Click({ MainFunctionPatch -Command "Patch Boot DOL" -Id "NAAM" -Title "SM64: Multiplayer" -Patch $Files.bpspatch_sm64_multiplayer -PatchedFile "_multiplayer__v1.4.2_patched" -Hash $HashSum_sm64 -Compress $False })



    ####################
    # PP Patch Buttons #
    ####################

    # Create a panel to contain everything for PP.
    $global:PatchPPPanel = CreatePanel -Width 590 -Height 80 -AddTo $MainDialog

    # Create a groupbox to show the PP patching buttons.
    $PatchPPGroup = CreateGroupBox -Width $PatchPPPanel.Width -Height $PatchPPPanel.Height -Text "Paper Mario - Patch Buttons" -AddTo $PatchPPPanel

    # Create a button to allow patching the WAD (PP 60 Hard Mode).
    $global:PatchPPHardMode = CreateButton -X 130 -Y 25 -Width 100 -Height 35 -Text "Hard Mode" -ToolTip $ToolTip -Info "Increases the damage dealt by enemies by 1.5x`nSupports US ROM File only" -AddTo $PatchPPGroup
    $PatchPPHardMode.Add_Click({ MainFunctionPatch -Command $null -Id "NAE0" -Title "Paper Mario: Hard Mode" -Patch $Files.bpspatch_pp_hard_mode -PatchedFile "_hard_mode_patched" -Hash $HashSum_pp -Compress $False })

    # Create a button to allow patching the WAD (PP 60 Hard Mode+).
    $global:PatchPPHardModePlus = CreateButton -X ($PatchPPHardMode.Right + 15) -Y $PatchPPHardMode.Top -Width 100 -Height 35 -Text "Hard Mode+" -ToolTip $ToolTip -Info "Increases the damage dealt by enemies by 1.5x`nAlso increases the HP of enemies`nSupports US ROM File only" -AddTo $PatchPPGroup
    $PatchPPHardModePlus.Add_Click({ MainFunctionPatch -Command $null -Id "NAE1" -Title "Paper Mario: Hard Mode+" -Patch $Files.bpspatch_pp_hard_mode_plus -PatchedFile "_hard_mode_plus_patched" -Hash $HashSum_pp -Compress $False })

    # Create a button to allow patching the WAD (PP 60 Insane Mode).
    $global:PatchPPInsaneMode = CreateButton -X ($PatchPPHardModePlus.Right + 15) -Y $PatchPPHardMode.Top -Width 100 -Height 35 -Text "Insane Mode" -ToolTip $ToolTip -Info "Increases the damage dealt by enemies by 2x`nSupports US ROM File only" -AddTo $PatchPPGroup
    $PatchPPInsaneMode.Add_Click({ MainFunctionPatch -Command $null -Id "NAE2" -Title "Paper Mario: Insane Mode" -Patch $Files.bpspatch_pp_insane_mode -PatchedFile "_insane_mode_patched" -Hash $HashSum_pp -Compress $False })



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
    $PatchVCRemoveT64.Add_CheckStateChanged({ CheckForCheckboxes })
    
    # Expand Memory
    $global:PatchVCExpandMemoryLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Expand Memory:" -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $global:PatchVCExpandMemory = CreateCheckBox -X $PatchVCExpandMemoryLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $PatchVCExpandMemory.Add_CheckStateChanged({ CheckForCheckboxes })

    # Remap D-Pad
    $global:PatchVCRemapDPadLabel = CreateLabel -X ($PatchVCExpandMemory.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remap D-Pad:" -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $global:PatchVCRemapDPad = CreateCheckBox -X $PatchVCRemapDPadLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $PatchVCRemapDPad.Add_CheckStateChanged({ CheckForCheckboxes })

    # Downgrade
    $global:PatchVCDowngradeLabel = CreateLabel -X ($PatchVCRemapDPad.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Downgrade:" -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $global:PatchVCDowngrade = CreateCheckBox -X $PatchVCDowngradeLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $PatchVCDowngrade.Add_CheckStateChanged({ CheckForCheckboxes })



    # Create a label for Minimap
    $global:PatchVCMinimapLabel = CreateLabel -X 10 -Y ($PatchVCCoreLabel.Bottom + 5) -Width 50 -Height 15 -Text "Minimap" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remap C-Down
    $global:PatchVCRemapCDownLabel = CreateLabel -X ($PatchVCMinimapLabel.Right + 20) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap C-Down:" -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapCDown = CreateCheckBox -X $PatchVCRemapCDownLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $PatchVCRemapCDown.Add_CheckStateChanged({ CheckForCheckboxes })

    # Remap Z
    $global:PatchVCRemapZLabel = CreateLabel -X ($PatchVCRemapCDown.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap Z:" -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $global:PatchVCRemapZ = CreateCheckBox -X $PatchVCRemapZLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $PatchVCRemapZ.Add_CheckStateChanged({ CheckForCheckboxes })

    # Leave D-Pad Up
    $global:PatchVCLeaveDPadUpLabel = CreateLabel -X ($PatchVCRemapZ.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Leave D-Pad Up:" -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $global:PatchVCLeaveDPadUp = CreateCheckBox -X $PatchVCLeaveDPadUpLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $PatchVCLeaveDPadUp.Add_CheckStateChanged({ CheckForCheckboxes })



    # Create a label for Patch VC Buttons
    $global:ActionsLabel = CreateLabel -X 10 -Y 72 -Width 50 -Height 15 -Text "Actions" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Create a button to patch the VC
    $global:PatchVCButton = CreateButton -X 80 -Y 65 -Width 150 -Height 30 -Text "Patch VC Emulator Only" -ToolTip $ToolTip -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted" -AddTo $PatchVCGroup
    $PatchVCButton.Add_Click({ MainFunctionPatch -Command "Patch VC" -Id $null -Title $null -Patch $BPSFilePath -PatchedFile '_vc_patched' -Hash $null -Compress $False })

    # Create a button to extract the ROM
    $global:ExtractROMButton = CreateButton -X 240 -Y 65 -Width 150 -Height 30 -Text "Extract ROM Only" -ToolTip $ToolTip -Info "Only extract the .Z64 ROM from the WAD file`nUseful for native N64 emulators" -AddTo $PatchVCGroup
    $ExtractROMButton.Add_Click({ MainFunctionPatch -Command "Extract" -Id $null -Title $null -Patch $BPSFilePath -PatchedFile '_extracted' -Hash $null -Compress $False })



    ##############
    # Misc Panel #
    ##############

    # Create a panel to contain everything for other.
    $global:MiscPanel = CreatePanel -Width 625 -Height 205 -AddTo $MainDialog



    ########################
    # Game Options Buttons #
    ########################

    # Create a groupbox to show the game option buttons.
    $global:GameOptionsGroup = CreateGroupBox -Width 400 -Height 90 -Text "Set Game Mode" -AddTo $MiscPanel

    # Create a button to switch to OoT.
    $OoTGameOptionButton = CreateButton -X 40 -Y 25 -Width 100 -Height 22 -Text "Ocarina of Time" -ToolTip $ToolTip -Info "Switch to Ocarina of Time Patching Mode" -AddTo $GameOptionsGroup
    $OoTGameOptionButton.Add_Click({ ChangeGameMode -Mode "Ocarina of Time" })

    # Create a button to switch to MM.
    $MMGameOptionButton = CreateButton -X $OoTGameOptionButton.Left -Y ($OoTGameOptionButton.Bottom + 10) -Width 100 -Height 22 -Text "Majora's Mask" -ToolTip $ToolTip -Info "Switch to Majora's Mask Patching Mode" -AddTo $GameOptionsGroup
    $MMGameOptionButton.Add_Click({ ChangeGameMode -Mode "Majora's Mask" })

    # Create a button to switch to SM64.
    $SM64GameOptionButton = CreateButton -X ($MMGameOptionButton.Right + 15) -Y $OoTGameOptionButton.Top -Width 100 -Height 22 -Text "Super Mario 64" -ToolTip $ToolTip -Info "Switch to Super Mario 64 Patching Mode" -AddTo $GameOptionsGroup
    $SM64GameOptionButton.Add_Click({ ChangeGameMode -Mode "Super Mario 64" })

    # Create a button to switch to PP.
    $PPGameOptionButton = CreateButton -X $SM64GameOptionButton.Left -Y ($SM64GameOptionButton.Bottom + 10) -Width 100 -Height 22 -Text "Paper Mario" -ToolTip $ToolTip -Info "Switch to Paper Mario Patching Mode" -AddTo $GameOptionsGroup
    $PPGameOptionButton.Add_Click({ ChangeGameMode -Mode "Paper Mario" })

    # Create a button to switch to Free.
    $FreeGameOptionButton = CreateButton -X ($PPGameOptionButton.Right + 15) -Y $OoTGameOptionButton.Top -Width 100 -Height 52 -Text "Free (N64)" -ToolTip $ToolTip -Info "Switch to Free Patching Mode for other Nintendo 64 titles" -AddTo $GameOptionsGroup
    $FreeGameOptionButton.Add_Click({ ChangeGameMode -Mode "Free" })



    ###################
    # Console Buttons #
    ###################

    # Create a groupbox to show the game option buttons.
    $global:ConsoleOptionsGroup = CreateGroupBox -X ($GameOptionsGroup.Right + 10) -Y 0 -Width 180 -Height 90 -Text "Set Console" -AddTo $MiscPanel

    # Create a button to switch to VC WAD format.
    $WiiVCOptionButton = CreateButton -X 40 -Y 25 -Width 100 -Height 22 -Text "Wii VC (N64)" -ToolTip $ToolTip -Info "Switch to patching Wii Virtual Console WAD files" -AddTo $ConsoleOptionsGroup
    $WiiVCOptionButton.Add_Click({ SetWiiVCMode -Bool $true })

    # Create a button to switch to N64 format.
    $N64OptionButton = CreateButton -X $WiiVCOptionButton.Left -Y ($WiiVCOptionButton.Bottom + 10) -Width 100 -Height 22 -Text "Nintendo 64" -ToolTip $ToolTip -Info "Switch to patching Nintendo 64 ROMS in the format Z64, N64 or V64" -AddTo $ConsoleOptionsGroup
    $N64OptionButton.Add_Click({ SetWiiVCMode -Bool $false })



    ################
    # Misc Buttons #
    ################

    # Create a groupbox to show the misc buttons.
    $global:MiscGroup = CreateGroupBox -X 0 -Y 95 -Width 590 -Height 75 -Text "Other Buttons" -AddTo $MiscPanel

    # Create a button to show info about which GameID to use.
    $InfoGameIDButton = CreateButton -X 75 -Y 25 -Width 100 -Height 35 -Text "GameID's" -ToolTip $ToolTip -Info "Open the list with official, used and recommend GameID values to refer to" -AddTo $MiscGroup
    $InfoGameIDButton.Add_Click({ $InfoGameIDDialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoOcarinaOfTimeButton = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Info              Zelda 64" -ToolTip $ToolTip -Info "Open the list with information about the Ocarina of Time patching mode" -AddTo $MiscGroup
    $InfoOcarinaOfTimeButton.Add_Click({ $InfoOcarinaOfTimeDialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoMajorasMaskButton = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Info              Majora's Mask" -ToolTip $ToolTip -Info "Open the list with information about the Majora's Mask patching mode" -AddTo $MiscGroup
    $InfoMajorasMaskButton.Add_Click({ $InfoMajorasMaskDialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoSuperMario64Button = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Info              Super Mario 64" -ToolTip $ToolTip -Info "Open the list with information about the Super Mario 64 patching mode" -AddTo $MiscGroup
    $InfoSuperMario64Button.Add_Click({ $InfoSuperMario64Dialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoPaperMarioButton = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Info              Paper Mario" -ToolTip $ToolTip -Info "Open the list with information about the Paper Mario patching mode" -AddTo $MiscGroup
    $InfoPaperMarioButton.Add_Click({ $InfoPaperMarioDialog.ShowDialog() | Out-Null })

    # Create a button to show information about the patches.
    $global:InfoFreeButton = CreateButton -X ($InfoGameIDButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Info                Free" -ToolTip $ToolTip -Info "Open the list with information about the Free (N64) patching mode" -AddTo $MiscGroup
    $InfoFreeButton.Add_Click({ $InfoFreeDialog.ShowDialog() | Out-Null })

    # Create a button to show credits about the patches.
    $CreditsButton = CreateButton -X ($InfoOcarinaOfTimeButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Credits" -ToolTip $ToolTip -Info ("Open the list with credits of all of patches involved and those who helped with the " + $ScriptName + " tool") -AddTo $MiscGroup
    $CreditsButton.Add_Click({ $CreditsDialog.ShowDialog() | Out-Null })

    # Create a button to close the dialog.
    $global:ExitButton = CreateButton -X ($CreditsButton.Right + 15) -Y $InfoGameIDButton.Top -Width 100 -Height 35 -Text "Exit" -ToolTip $ToolTip -Info ("Close the " + $ScriptName + " tool") -AddTo $MiscGroup
    $ExitButton.Add_Click({ $MainDialog.Close() })



    ##################
    # Current Status #
    ##################

    $global:StatusGroup = CreateGroupBox -X 0 -Y 175 -Width 590 -Height 30 -AddTo $MiscPanel
    $global:statusLabel = Createlabel -X 8 -Y 10 -Width 570 -Height 15 -AddTo $StatusGroup

}



#==============================================================================================================================================================================================
function SetMainScreenSize() {
    
    if ($IsWiiVC) {
        
        $InputROMTextBox.Width = $InputBPSTextBox.Width
        $InputROMButton.Left = $InputBPSButton.Left

        $InputWADPanel.Location = New-Object System.Drawing.Size(10, 35)
        $InputROMPanel.Location = New-Object System.Drawing.Size(10, ($InputWADPanel.Bottom + 5))
        $InputBPSPanel.Location = New-Object System.Drawing.Size(10, ($InputROMPanel.Bottom + 5))
        $CustomGameIDPanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))

        $PatchOoTPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5))
        $PatchMMPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5))
        $PatchSM64Panel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5))
        $PatchPPPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5))

        if ($GameType -eq "Ocarina of Time")      { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchOoTPanel.Bottom + 5)) }
        elseif ($GameType -eq "Majora's Mask")    { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchMMPanel.Bottom + 5)) }
        elseif ($GameType -eq "Super Mario 64")   { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchSM64Panel.Bottom + 5)) }
        elseif ($GameType -eq "Paper Mario")      { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchPPPanel.Bottom + 5)) }
        else                                      { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5)) }

        $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchVCPanel.Bottom + 5))

    }

    else {
        
        $InputROMTextBox.Width = $InputWADTextBox.Width
        $InputROMButton.Left = $InputWADButton.Left

        $InputROMPanel.Location = New-Object System.Drawing.Size(10, 35)
        $InputBPSPanel.Location = New-Object System.Drawing.Size(10, ($InputROMPanel.Bottom + 5))

        $PatchOoTPanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))
        $PatchMMPanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))
        $PatchSM64Panel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))
        $PatchPPPanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))

        if ($GameType -eq "Ocarina of Time")      { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchOoTPanel.Bottom + 5)) }
        elseif ($GameType -eq "Majora's Mask")    { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchMMPanel.Bottom + 5)) }
        elseif ($GameType -eq "Super Mario 64")   { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchSM64Panel.Bottom + 5)) }
        elseif ($GameType -eq "Paper Mario")      { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchPPPanel.Bottom + 5)) }
        else                                      { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5)) }

    }

    $MainDialog.Height = ($MiscPanel.Bottom + 50)

}


#==============================================================================================================================================================================================
function ChangeGameMode([string]$Mode) {
    
    $PatchOoTPanel.Visible = $PatchMMPanel.Visible = $PatchSM64Panel.Visible = $PatchPPPanel.Visible = $False
    $InfoOcarinaOfTimeButton.Visible = $InfoMajorasMaskButton.Visible = $InfoSuperMario64Button.Visible = $InfoPaperMarioButton.Visible = $InfoFreeButton.Visible = $False
    
    $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $False
    $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $False
    $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $False
    
    $PatchVCMinimapLabel.Hide()
    $PatchVCRemapCDown.Visible = $PatchVCRemapCDownLabel.Visible = $False
    $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $False
    $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $False
    

    $global:GameType = $Mode
 
    if ($GameType -eq "Ocarina of Time") {
        $global:GameID = $OoT_US_GameID
        $global:ChannelTitle = "Zelda: Ocarina"
        $PatchOoTPanel.Visible = $InfoOcarinaOfTimeButton.Visible = $True
        $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $True
    }
    elseif ($GameType -eq "Majora's Mask") {
        $global:GameID = $MM_US_GameID
        $global:ChannelTitle = "Zelda: Majora's"
        $PatchMMPanel.Visible = $InfoMajorasMaskButton.Visible = $True
    }
    elseif ($GameType -eq "Super Mario 64") {
        $global:GameID = $SM64_US_GameID
        $global:ChannelTitle = "Super Mario 64"
        $PatchSM64Panel.Visible = $InfoSuperMario64Button.Visible = $True
    }
    elseif ($GameType -eq "Paper Mario") {
        $global:GameID = $PP_US_GameID
        $global:ChannelTitle = "Paper Mario"
        $PatchPPPanel.Visible = $InfoPaperMarioButton.Visible = $True
        
    }
    else {
        $global:GameID = $CUST_GameID
        $global:ChannelTitle = "Custom Channel"
        $InfoFreeButton.Show()
        $InputCustomChannelTitleTextBox.Visible = $InputCustomChannelTitleTextBoxLabel.Visible = $False
        $InputCustomChannelTitleTextBox.Enabled = $InputCustomChannelTitleTextBoxLabel.Enabled = $False
    }

    if ($GameType -ne "Free") {
        $InputCustomChannelTitleTextBox.Visible = $InputCustomChannelTitleTextBoxLabel.Visible = $True
        $InputCustomChannelTitleTextBox.Enabled = $InputCustomChannelTitleTextBoxLabel.Enabled = $True
    }

    if ($GameType -eq "Ocarina of Time" -or $GameType -eq "Majora's Mask") {
        $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $True
        $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $True
        $PatchVCMinimapLabel.Show() 
        $PatchVCRemapCDownLabel.Visible = $PatchVCRemapCDown.Visible = $True
        $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $True
        
    }

    $InputCustomChannelTitleTextBox.Text = $ChannelTitle
    $InputCustomGameIDTextBox.Text =  $GameID

    CheckForCheckboxes
    SetWiiVCMode -Bool $IsWiiVC

}



#==============================================================================================================================================================================================
function SetWiiVCMode([boolean]$Bool) {
    
    $InputWADPanel.Visible = $InjectROMButton.Visible = $CustomGameIDPanel.Visible = $PatchVCPanel.Visible = $Bool
    $InputCustomGameIDCheckbox.Enabled = $Bool

    $global:IsWiiVC = $Bool
    if ($Bool) { EnablePatchButtons -Enable ($WADFilePath -ne $null) } else { EnablePatchButtons -Enable ($Z64FilePath -ne $null) }
    
    SetMainScreenSize
    SetModeLabel

}



#==============================================================================================================================================================================================
function SetModeLabel() {
	
    $CurrentModeLabel.Text = "Current  Mode  :  " + $GameType
    if ($IsWiiVC) { $CurrentModeLabel.Text += "  (Wii  VC)" } else { $CurrentModeLabel.Text += "  (N64)" }
    $CurrentModeLabel.Location = New-Object System.Drawing.Size(([Math]::Floor($MainDialog.Width / 2) - [Math]::Floor($CurrentModeLabel.Width / 2)), 10)

}


function UpdateStatusLabelDuringPatching([String]$Text) {
    
    $MainDialog.Enabled = $True
    $StatusLabel.Text = $Text
    $MainDialog.Enabled = $False

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
    
    if (CheckCheckBox -CheckBox $PatchVCRemoveT64)          { $PatchVCButton.Enabled = $true }
    elseif (CheckCheckBox -CheckBox $PatchVCExpandMemory)   { $PatchVCButton.Enabled = $true }
    elseif (CheckCheckBox -CheckBox $PatchVCRemapDPad)      { $PatchVCButton.Enabled = $true }
    elseif (CheckCheckBox -CheckBox $PatchVCDowngrade)      { $PatchVCButton.Enabled = $true }
    elseif (CheckCheckBox -CheckBox $PatchVCRemapCDown)     { $PatchVCButton.Enabled = $true }
    elseif (CheckCheckBox -CheckBox $PatchVCRemapZ)         { $PatchVCButton.Enabled = $true }
    elseif (CheckCheckBox -CheckBox $PatchLeaveDPadUp)      { $PatchVCButton.Enabled = $true }
    else                                                    { $PatchVCButton.Enabled = $false }

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

        if ($1xTextOoT.Checked -and $IncludeReduxOoT.Checked)     { return $True }
        if ($2xTextOoT.Checked -and !$IncludeReduxOoT.Checked)    { return $True }
        if ($3xTextOoT.Checked)                                   { return $True }

        if ($WidescreenOoT.Checked)                               { return $True }
        if ($WidescreenBackgroundsOoT.Checked)                    { return $True }
        if ($ExtendedDrawOoT.Checked)                             { return $True }
        if ($BlackBarsOoT.Checked)                                { return $True }
        if ($ForceHiresModelOoT.Checked)                          { return $True }
        if ($MMModelsOoT.Checked -and $IncludeReduxOoT.Checked)   { return $True }

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

    }

    elseif ($GameType -eq "Majora's Mask") {
        
        if ($2xDamageMM.Checked)                                 { return $True }
        if ($4xDamageMM.Checked)                                 { return $True }
        if ($8xDamageMM.Checked)                                 { return $True }

        if ($HalfRecoveryMM.Checked)                             { return $True }
        if ($QuarterRecoveryMM.Checked)                          { return $True }
        if ($NoRecoveryMM.Checked)                               { return $True }
        if ($LeftDPadMM.Checked -and $IncludeReduxMM.Checked)    { return $True }
        if ($HideDPadMM.Checked -and $IncludeReduxMM.Checked)    { return $True }

        if ($WidescreenMM.Checked)                               { return $True }
        if ($ExtendedDrawMM.Checked)                             { return $True }
        if ($BlackBarsMM.Checked)                                { return $True }
        if ($PixelatedStarsMM.Checked)                           { return $True }

        if ($ReducedItemCapacityMM.Checked)                      { return $True }
        if ($IncreasedItemCapacityMM.Checked)                    { return $True }
        if ($RazorSwordMM.Checked)                               { return $True }

        if ($DisableLowHPSoundMM.Checked)                        { return $True }
        if ($PieceOfHeartSoundMM.Checked)                        { return $True }

    }

    return $False

}



#==============================================================================================================================================================================================
function CreateOcarinaOfTimeReduxOptionsDialog() {

    # Create Dialog
    $global:OoTReduxOptionsDialog = CreateDialog -Width 700 -Height 580 -Icon $Icons.OcarinaOfTimeRedux
    $CloseButton = CreateButton -X ($OoTReduxOptionsDialog.Width / 2 - 40) -Y ($OoTReduxOptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OoTReduxOptionsDialog
    $CloseButton.Add_Click({$OoTReduxOptionsDialog.Hide()})

    # Create ToolTip
    $ToolTip = CreateToolTip

    # Options Label
    $TextLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text "Ocarina of Time REDUX - Additional Options" -AddTo $OoTReduxOptionsDialog
    
   # $OoTReduxOptionsDialog.Show()

    # HERO MODE #
    $global:HeroModeBoxOoT             = CreateReduxGroup -Y 50 -Height 3 -Dialog $OoTReduxOptionsDialog -Text "Hero Mode"
    
    # Damage
    $global:DamagePanelOoT             = CreateReduxPanel -Row 0 -Group $HeroModeBoxOoT 
    $global:1xDamageOoT                = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelOoT -Checked $True -Text "1x Damage" -Info "Enemies deal normal damage"
    $global:2xDamageOoT                = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelOoT                -Text "2x Damage" -Info "Enemies deal twice as much damage"
    $global:4xDamageOoT                = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelOoT                -Text "4x Damage" -Info "Enemies deal four times as much damage"
    $global:8xDamageOoT                = CreateReduxRadioButton -Column 3 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelOoT                -Text "8x Damage" -Info "Enemies deal four times as much damage"

    # Recovery
    $global:RecoveryPanelOoT           = CreateReduxPanel -Row 1 -Group $HeroModeBoxOoT 
    $global:NormalRecoveryOoT          = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelOoT -Checked $True -Text "1x Recovery"   -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $global:HalfRecoveryOoT            = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelOoT                -Text "1/2x Recovery" -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $global:QuarterRecoveryOoT         = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelOoT                -Text "1/4x Recovery" -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $global:NoRecoveryOoT              = CreateReduxRadioButton -Column 3 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelOoT                -Text "0x Recovery"   -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $global:BossHPPanelOoT             = CreateReduxPanel -Row 2 -Group $HeroModeBoxOoT 
  # $global:1xBossHPOoT                = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $BossHPPanelOoT -Checked $True -Text "1x Boss HP" -Info "Bosses have normal hit points" 
  # $global:2xBossHPOoT                = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $BossHPPanelOoT                -Text "2x Boss HP" -Info "Bosses have double as much hit points"
  # $global:3xBossHPOoT                = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $BossHPPanelOoT                -Text "3x Boss HP" -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $global:OHKOModeOoT                = CreateReduxCheckbox -Column 0 -Row 3 -ToolTip $ToolTip -Group $HeroModeBoxOoT -Text "OHKO Mode" -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # TEXT SPEED #
    $global:TextBoxOoT                 = CreateReduxGroup -Y ($HeroModeBoxOoT.Bottom + 5) -Height 1 -Dialog $OoTReduxOptionsDialog -Text "Text Dialogue Speed"
    
    $global:TextPanelOoT               = CreateReduxPanel -Row 0 -Group $TextBoxOoT 
    $global:1xTextOoT                  = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $TextPanelOoT                -Text "1x Speed" -Info "Leave the dialogue text speed at normal"
    $global:2xTextOoT                  = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $TextPanelOoT -Checked $True -Text "2x Speed" -Info "Set the dialogue text speed to be twice as fast"
    $global:3xTextOoT                  = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $TextPanelOoT                -Text "3x Speed" -Info "Set the dialogue text speed to be three times as fast"



    # GRAPHICS #
    $global:GraphicsBoxOoT             = CreateReduxGroup -Y ($TextBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTReduxOptionsDialog -Text "Graphics"
    
    $global:WidescreenOoT              = CreateReduxCheckbox -Column 0 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxOoT -Text "16:9 Widescreen"        -Info "Native 16:9 widescreen display support"
    $global:WidescreenBackgroundsOoT   = CreateReduxCheckbox -Column 1 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxOoT -Text "16:9 Backgrounds"       -Info "16:9 backgrounds suitable for native 16:9 widescreen display support"
    $global:ExtendedDrawOoT            = CreateReduxCheckbox -Column 2 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxOoT -Text "Extended Draw Distance" -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $global:BlackBarsOoT               = CreateReduxCheckbox -Column 3 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxOoT -Text "No Black Bars"          -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $global:ForceHiresModelOoT         = CreateReduxCheckbox -Column 0 -Row 2 -ToolTip $ToolTip -Group $GraphicsBoxOoT -Text "Force Hires Link Model" -Info "Always use Link's High Resolution Model when Link is too far away"
    $global:MMModelsOoT                = CreateReduxCheckbox -Column 1 -Row 2 -ToolTip $ToolTip -Group $GraphicsBoxOoT -Text "Replace Link's Models"  -Info "Replaces Link's models to be styled towards Majora's Mask"



    # EQUIPMENT #
    $global:EquipmentBoxOoT            = CreateReduxGroup -Y ($GraphicsBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTReduxOptionsDialog -Text "Equipment"
    
    $global:ItemCapacityPanelOoT       = CreateReduxPanel -Row 0 -Group $EquipmentBoxOoT 
    $global:ReducedItemCapacityOoT     = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $ItemCapacityPanelOoT                -Text "Reduced Item Capacity"   -Info "Decrease the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $global:NormalItemCapacityOoT      = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $ItemCapacityPanelOoT -Checked $True -Text "Normal Item Capacity"    -Info "Keep the normal amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"
    $global:IncreasedItemCapacityOoT   = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $ItemCapacityPanelOoT                -Text "Increased Item Capacity" -Info "Increase the amount of deku sticks, deku nuts, deku seeds, bombs and arrows you can carry"

    $global:UnlockSwordOoT             = CreateReduxCheckbox -Column 0 -Row 2 -ToolTip $ToolTip -Group $EquipmentBoxOoT -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword"
    $global:UnlockTunicsOoT            = CreateReduxCheckbox -Column 1 -Row 2 -ToolTip $ToolTip -Group $EquipmentBoxOoT -Text "Unlock Tunics"       -Info "Child Link is able to use the Goron TUnic and Zora Tunic`nSince you might want to walk around in style as well when you are young"
    $global:UnlockBootsOoT             = CreateReduxCheckbox -Column 2 -Row 2 -ToolTip $ToolTip -Group $EquipmentBoxOoT -Text "Unlock Boots"        -Info "Child Link is able to use the Iron Boots and Hover Boots"



    # EVERYTHING ELSE #
    $global:OtherBoxOoT                = CreateReduxGroup -Y ($EquipmentBoxOoT.Bottom + 5) -Height 2 -Dialog $OoTReduxOptionsDialog -Text "Other"

    $global:DisableLowHPSoundOoT       = CreateReduxCheckbox -Column 0 -Row 1 -ToolTip $ToolTip -Group $OtherBoxOoT -Text "Disable Low HP Beep"    -Info "There will be absolute silence when Link's HP is getting low"
    $global:MedallionsOoT              = CreateReduxCheckbox -Column 1 -Row 1 -ToolTip $ToolTip -Group $OtherBoxOoT -Text "Require All Medallions" -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`The vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows"
    $global:ReturnChildOoT             = CreateReduxCheckbox -Column 2 -Row 1 -ToolTip $ToolTip -Group $OtherBoxOoT -Text "Can Always Return"      -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"
    $global:DisableNaviOoT             = CreateReduxCheckbox -Column 3 -Row 1 -ToolTip $ToolTip -Group $OtherBoxOoT -Text "Remove Navi Prompts"    -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes"
    $global:HideDPadOoT                = CreateReduxCheckbox -Column 0 -Row 2 -ToolTip $ToolTip -Group $OtherBoxOoT -Text "Hide D-Pad Icon"        -Info "Hide the D-Pad icon, while it is still active"
    


    # Include Redux (Checkbox)
    $global:IncludeReduxOoT            = CreateCheckbox -X 30 -Y ($CloseButton.Top + 5) -Checked $True -ToolTip $ToolTip -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $OoTReduxOptionsDialog
    $IncludeReduxLabel                 = CreateLabel -X $IncludeReduxOoT.Right -Y ($IncludeReduxOoT.Top + 3) -Width 135 -Height 15 -Text "Include Redux Patch" -ToolTip $ToolTip -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $OoTReduxOptionsDialog

    $IncludeReduxOoT.Add_CheckStateChanged({
        $GraphicsBoxOoT.Controls[5 * 2].Enabled = $IncludeReduxOoT.Checked
        $OtherBoxOoT.Controls[4 * 2].Enabled = $IncludeReduxOoT.Checked
    })

}

 

#==============================================================================================================================================================================================
function CreateMajorasMaskReduxOptionsDialog() {
    
    # Create Dialog
    $global:MMReduxOptionsDialog = CreateDialog -Width 700 -Height 580 -Icon $Icons.MajorasMaskRedux
    $CloseButton = CreateButton -X ($MMReduxOptionsDialog.Width / 2 - 40) -Y ($MMReduxOptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $MMReduxOptionsDialog
    $CloseButton.Add_Click({$MMReduxOptionsDialog.Hide()})

    # Create ToolTip
    $ToolTip = CreateToolTip

    # Options Label
    $TextLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text "Majora's Mask REDUX - Additional Options" -AddTo $MMReduxOptionsDialog

    #$MMReduxOptionsDialog.Show()

    # HERO MODE #
    $global:HeroModeBoxMM              = CreateReduxGroup -Y 50 -Height 3 -Dialog $MMReduxOptionsDialog -Text "Hero Mode"
    
    # Damage
    $global:DamagePanelMM              = CreateReduxPanel -Row 0 -Group $HeroModeBoxMM 
    $global:1xDamageMM                 = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelMM -Checked $True -Text "1x Damage" -Info "Enemies deal normal damage"
    $global:2xDamageMM                 = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelMM                -Text "2x Damage" -Info "Enemies deal twice as much damage"
    $global:4xDamageMM                 = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelMM                -Text "4x Damage" -Info "Enemies deal four times as much damage"
    $global:8xDamageMM                 = CreateReduxRadioButton -Column 3 -Row 0 -ToolTip $ToolTip -Panel $DamagePanelMM                -Text "8x Damage" -Info "Enemies deal four times as much damage"

    # Recovery
    $global:RecoveryPanelMM            = CreateReduxPanel -Row 1 -Group $HeroModeBoxMM 
    $global:NormalRecoveryMM           = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelMM -Checked $True -Text "1x Recovery"   -Info "Recovery Hearts restore Link's health for their full amount (1 Heart)" 
    $global:HalfRecoveryMM             = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelMM                -Text "1/2x Recovery" -Info "Recovery Hearts restore Link's health for half their amount (1/2 Heart)"
    $global:QuarterRecoveryMM          = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelMM                -Text "1/4x Recovery" -Info "Recovery Hearts restore Link's for a quarter of their amount (1/4 Heart)"
    $global:NoRecoveryMM               = CreateReduxRadioButton -Column 3 -Row 0 -ToolTip $ToolTip -Panel $RecoveryPanelMM                -Text "0x Recovery"   -Info "Recovery Hearts will not restore Link's health anymore"

    # Boss HP
  # $global:BossHPPanelMM              = CreateReduxPanel -Row 2 -Group $HeroModeBoxMM 
  # $global:1xBossHPMM                 = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $BossHPPanelMM -Checked $True -Text "1x Boss HP" -Info "Bosses have normal hit points" 
  # $global:2xBossHPMM                 = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $BossHPPanelMM                -Text "2x Boss HP" -Info "Bosses have double as much hit points"
  # $global:3xBossHPMM                 = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $BossHPPanelMM                -Text "3x Boss HP" -Info "Bosses have thrice as much hit points"

    # OHKO MODE
    $global:OHKOModeMM                 = CreateReduxCheckbox -Column 0 -Row 3 -ToolTip $ToolTip -Group $HeroModeBoxMM -Text "OHKO Mode" -Info "Enemies kill Link with just a single hit\`nPrepare too die a lot"



    # D-PAD #
    $global:DPadBoxMM                  = CreateReduxGroup -Y ($HeroModeBoxMM.Bottom + 5) -Height 1 -Dialog $MMReduxOptionsDialog -Text "D-Pad Icons Layout"
    
    $global:DPadPanelMM                = CreateReduxPanel -Row 0 -Group $DPadBoxMM 
    $global:LeftDPadMM                 = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $DPadPanelMM                -Text "Left Side" -Info "Show the D-Pad icons on the left side of the HUD"
    $global:RightDPadMM                = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $DPadPanelMM -Checked $True -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD"
    $global:HideDPadMM                 = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $DPadPanelMM                -Text "Hidden" -Info "Hide the D-Pad icons, while they are still active"
    
    
   
    # GRAPHICS #
    $global:GraphicsBoxMM              = CreateReduxGroup -Y ($DPadBoxMM.Bottom + 5) -Height 1 -Dialog $MMReduxOptionsDialog -Text "Graphics"
    
    $global:WidescreenMM               = CreateReduxCheckbox -Column 0 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxMM -Text "16:9 Widescreen"         -Info "Native 16:9 Widescreen Display support"
    $global:ExtendedDrawMM             = CreateReduxCheckbox -Column 1 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxMM -Text "Extended Draw Distance"  -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    $global:BlackBarsMM                = CreateReduxCheckbox -Column 2 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxMM -Text "No Black Bars"           -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    $global:PixelatedStarsMM           = CreateReduxCheckbox -Column 3 -Row 1 -ToolTip $ToolTip -Group $GraphicsBoxMM -Text "Disable Pixelated Stars" -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement"

    

    # EQUIPMENT #
    $global:EquipmentBoxMM             = CreateReduxGroup -Y ($GraphicsBoxMM.Bottom + 5) -Height 2 -Dialog $MMReduxOptionsDialog -Text "Equipment"
    
    $global:ItemCapacityPanelMM        = CreateReduxPanel -Row 0 -Group $EquipmentBoxMM 
    $global:ReducedItemCapacityMM      = CreateReduxRadioButton -Column 0 -Row 0 -ToolTip $ToolTip -Panel $ItemCapacityPanelMM                -Text "Reduced Item Capacity"   -Info "Decrease the amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $global:NormalItemCapacityMM       = CreateReduxRadioButton -Column 1 -Row 0 -ToolTip $ToolTip -Panel $ItemCapacityPanelMM -Checked $True -Text "Normal Item Capacity"    -Info "Keep the normal amount of deku sticks, deku nuts, bombs and arrows you can carry"
    $global:IncreasedItemCapacityMM    = CreateReduxRadioButton -Column 2 -Row 0 -ToolTip $ToolTip -Panel $ItemCapacityPanelMM                -Text "Increased Item Capacity" -Info "Increase the amount of deku sticks, deku nuts, bombs and arrows you can carry"

    $global:RazorSwordMM               = CreateReduxCheckbox -Column 0 -Row 2 -ToolTip $ToolTip -Group $EquipmentBoxMM -Text "Permanent Razor Sword" -Info "The Razor Sword won't get destroyed after 100 it`nYou can also keep the Razor Sword when traveling back in time"



    # EVERYTHING ELSE #
    $global:OtherBoxMM                 = CreateReduxGroup -Y ($EquipmentBoxMM.Bottom + 5) -Height 1 -Dialog $MMReduxOptionsDialog -Text "Other"

    $global:DisableLowHPSoundMM        = CreateReduxCheckbox -Column 0 -Row 1 -ToolTip $ToolTip -Group $OtherBoxMM -Text "Disable Low HP Beep"      -Info "There will be absolute silence when Link's HP is getting low"
    $global:PieceOfHeartSoundMM        = CreateReduxCheckbox -Column 1 -Row 1 -ToolTip $ToolTip -Group $OtherBoxMM -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container"



    # Include Redux (Checkbox)
    $global:IncludeReduxMM             = CreateCheckbox -X 30 -Y ($CloseButton.Top + 5) -Checked $True -ToolTip $ToolTip -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $MMReduxOptionsDialog
    $IncludeReduxLabel                 = CreateLabel -X $IncludeReduxMM.Right -Y ($IncludeReduxMM.Top + 3) -Width 135 -Height 15 -Text "Include Redux Patch" -ToolTip $ToolTip -Info "Include the base REDUX patch`nDisable this option to patch only the vanilla ROM with the above options" -AddTo $MMReduxOptionsDialog

    $IncludeReduxMM.Add_CheckStateChanged({
        $DPadPanelMM.Controls[0 * 2].Enabled = $IncludeReduxMM.Checked
        $DPadPanelMM.Controls[1 * 2].Enabled = $IncludeReduxMM.Checked
        $DPadPanelMM.Controls[2 * 2].Enabled = $IncludeReduxMM.Checked
    })

}



#==============================================================================================================================================================================================
function CreateInfoGameIDDialog() {
    
    # Create Dialog
    $global:InfoGameIDDialog = CreateDialog -Width 400 -Height 560 -Icon $Icons.CheckGameID
    $CloseButton = CreateButton -X ($InfoGameIDDialog.Width / 2 - 40) -Y ($InfoGameIDDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoGameIDDialog
    $CloseButton.Add_Click({$InfoGameIDDialog.Hide()})

    # Create the string that will be displayed on the window.
    $InfoString = $ScriptName + " (" + $Version + ")" + '{0}'

    $InfoString += '{0}'
    $InfoString += "--- OFFICIAL GAMEID'S ---{0}"
    $InfoString += '- NACE = Ocarina of Time{0}'
    $InfoString += "- NARE = Majora's Mask{0}"
    $InfoString += '- NAAE = Super Mario 64{0}'
    $InfoString += '- NAEE = Paper Mario{0}'
    
    $InfoString += '{0}'
    $InfoString += "--- UNOFFICIAL GAMEID'S (Rom Hacks) ---{0}"
    $InfoString += '- NAC0 = Ocarina of Time REDUX{0}'
    $InfoString += '- NAC1 = Ocarina of Time: Dawn & Dusk{0}'
    $InfoString += "- NAR0 = Majora's Mask REDUX{0}"
    $InfoString += "- NAR1 = Majora's Mask: Masked Quest{0}"
    $InfoString += "- NAAX = Super Mario 64: 60 FPS v2{0}"
    $InfoString += "- NAAY = Super Mario 64: Analog Camera{0}"
    $InfoString += "- NAAM = Super Mario 64: Multiplayer v1.4.2{0}"
    $InfoString += "- NAE0 = Paper Mario: Hard Mode{0}"
    $InfoString += "- NAE1 = Paper Mario: Hard Mode+{0}"
    $InfoString += "- NAE2 = Paper Mario: Insane Mode{0}"

    $InfoString += '{0}'
    $InfoString += "--- UNOFFICIAL GAMEID'S (Translations) ---{0}"
    $InfoString += '- NACS = Ocarina of Time (Spanish){0}'
    $InfoString += '- NACO = Ocarina of Time (Polish){0}'
    $InfoString += '- NACR = Ocarina of Time (Russian){0}'
    $InfoString += '- NACC = Ocarina of Time (Chinese){0}'
    $InfoString += "- NARO = Majora's Mask (Polish){0}"
    $InfoString += "- NARR = Majora's Mask (Russian){0}"

    $InfoString += '{0}'
    $InfoString += "--- RECOMMENDED GAMEID'S (Custom Injection) ---{0}"
    $InfoString += '- NAQE = Master Quest {0}'
    $InfoString += '- NAQS = Master Quest (Spanish){0}'

    $InfoString += '{0}'
    $InfoString += "--- Instructions (Custom GameID and Channel Title) ---{0}"
    $InfoString += '- Can be overwritten for any patch or ROM injection{0}'
    $InfoString += '- Check the checkbox to enable override{0}'
    $InfoString += '- Custom GameID requires 4 characters for acceptance{0}'
    $InfoString += '- Incorrect length uses default values instead {0}'

    $InfoString = [String]::Format($InfoString, [Environment]::NewLine)

    #Create Label
    $InfoLabel = CreateLabel -X 10 -Y 10 -Width 350 -Height ($InfoGameIDDialog.Height - 110) -Text $InfoString -AddTo $InfoGameIDDialog

}



#==============================================================================================================================================================================================
function CreateInfoOcarinaOfTimeDialog() {
    
    # Create Dialog
    $global:InfoOcarinaOfTimeDialog = CreateDialog -Width 400 -Height 510 -Icon $Icons.OcarinaOfTime
    $CloseButton = CreateButton -X ($InfoOcarinaOfTimeDialog.Width / 2 - 40) -Y ($InfoOcarinaOfTimeDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoOcarinaOfTimeDialog
    $CloseButton.Add_Click({$InfoOcarinaOfTimeDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " (" + $Version + ")" + '{0}'

    $String += "{0}"
    $String += "Patches The Legend of Zelda: Ocarina of Time game WAD:{0}"
    $String += "1. ROM Injection (requires .Z64 ROM){0}"
    $String += "2. Free BPS Patching (requires .IPS or .BPS File){0}"
    $String += "3. Two ROM hacks (OoT Redux, Dawn and Dusk){0}"
    $String += "4. Four fan translations (Spanish, Polish, Russian, Chinese){0}"

    $String += "{0}"
    $String += "Known Issues:{0}"
    $String += "- Trees show transparent outlines through walls (Dawn and Dusk){0}"

    $String += "{0}"
    $String += "Requirements:{0}"
    $String += "- The Legend of Zelda: Ocarina of Time USA VC WAD File{0}"

    $String += "{0}"
    $String += "Instructions:{0}"
    $InfoString += "- Select WAD File{0}"
    $String += "- Press one of several patching buttons{0}"
    $String += "- Enable optional Remap D-Pad{0}"

    $String += "{0}"
    $String += "Information:{0}"
    $String += "- Original WAD is preserved{0}"
    $String += "- Few patches are compatible with existing AR/Gecko Codes{0}"
    $String += "- Redux forces Expand Memory, Remap D-Pad and Leave D-Pad Up{0}"
    $String += "- Most patches forces Downgrade{0}"
    
    $String += "{0}"
    $String += "Programs:{0}"
    $String += "- Wad Packer/Wad Unpacker{0}"
    $String += "- Floating IPS{0}"
    $String += "- Wiimm's 'wszst' Tool{0}"
    $String += "- Compress Tool{0}"
    $String += "- ndec Tool{0}"
    $String += "- TabExt Tool"

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width 350 -Height ($InfoOcarinaOfTimeDialog.Height - 110) -Text $String -AddTo $InfoOcarinaOfTimeDialog

}



#==============================================================================================================================================================================================
function CreateInfoMajorasMaskDialog() {
    
    # Create Dialog
    $global:InfoMajorasMaskDialog = CreateDialog -Width 400 -Height 540 -Icon $Icons.MajorasMask
    $CloseButton = CreateButton -X ($InfoOcarinaOfTimeDialog.Width / 2 - 40) -Y ($InfoMajorasMaskDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoMajorasMaskDialog
    $CloseButton.Add_Click({$InfoMajorasMaskDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " (" + $Version + ")" + '{0}'

    $String += "{0}"
    $String += "Patches The Legend of Zelda: Majora's Mask game WAD:{0}"
    $String += "1. ROM Injection (requires .Z64 ROM){0}"
    $String += "2. Free BPS Patching (requires .IPS or .BPS File){0}"
    $String += "3. Two ROM hack (MM Redux, Masked Quest){0}"
    $String += "4. Two fan translations (Polish, Russian){0}"

    $String += "{0}"
    $String += "Known Issues:{0}"
    $String += "- Unknown{0}"

    $String += "{0}"
    $String += "Requirements:{0}"
    $String += "- The Legend of Zelda: Majora's Mask USA VC WAD File{0}"

    $String += "{0}"
    $String += "Instructions:{0}"
    $String += "- Select WAD File{0}"
    $String += "- Press one of several patching buttons{0}"
    $String += "- Enable optional Remap D-Pad{0}"

    $String += "{0}"
    $String += "Information:{0}"
    $String += "- Original WAD is preserved{0}"
    $String += "- Patches are mostly compatible with existing AR/Gecko Codes{0}"
    $String += "- Redux forces Remap D-Pad {0}"
    $String += "- Expand Memory renders AR/Gecko Codes unsuable{0}"
    
    $String += "{0}"
    $String += "Programs:{0}"
    $String += "- Wad Packer/Wad Unpacker{0}"
    $String += "- Floating IPS{0}"
    $String += "- Wiimm's 'wszst' Tool{0}"
    $String += "- Romchu Tool{0}"
    $String += "- LZSS Compression Tool{0}"
    $String += "- Compress Tool{0}"
    $String += "- ndec Tool{0}"
    $String += "- TabExt Tool"

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width 350 -Height ($InfoMajorasMaskDialog.Height - 110) -Text $String -AddTo $InfoMajorasMaskDialog

}



#==============================================================================================================================================================================================
function CreateInfoSuperMario64Dialog() {
    
    # Create Dialog
    $global:InfoSuperMario64Dialog = CreateDialog -Width 400 -Height 500 -Icon $Icons.SuperMario64
    $CloseButton = CreateButton -X ($InfoSuperMario64Dialog.Width / 2 - 40) -Y ($InfoSuperMario64Dialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoSuperMario64Dialog
    $CloseButton.Add_Click({$InfoSuperMario64Dialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " (" + $Version + ")" + '{0}'

    $String += '{0}'
    $String += 'Patches Super Mario 64 game WAD:{0}'
    $String += '1. ROM Injection (requires .Z64 ROM){0}'
    $String += "2. Free BPS Patching (requires .IPS or .BPS File){0}"
    $String += '3. Super Mario 64: 60 FPS v2 (Native 60 FPS support){0}'
    $String += '4. Super Mario 64: Free Cam (Analog Camera){0}'
    $String += '5. SM64: Multiplayer (V1.4.2){0}'

    $String += '{0}'
    $String += 'Known Issues:{0}'
    $String += '- Mario camera is inoperable (60 FPS){0}'
    $String += '- Intro demo is broken (60 FPS){0}'

    $String += '{0}'
    $String += 'Requirements:{0}'
    $String += '- Super Mario 64 VC USA WAD File{0}'

    $String += '{0}'
    $String += 'Instructions:{0}'
    $String += '- Select Super Mario 64 VC USA WAD File{0}'
    $String += '- Press one of several patching buttons{0}'
    $String += '- Original WAD is preserved{0}'

    $String += '{0}'
    $String += 'Information:{0}'
    $String += '- Existing AR/Gecko codes still work (60 FPS / Analog Camera){0}'
    $String += '- Existing AR/Gecko codes do not work (Multiplayer){0}'
    $String += '- Enable second emulated controller (Analog Camera / Multiplayer){0}'
    $String += '- Bind second emulated Control Stick to primary physical controller{0}'
    
    $String += '{0}'
    $String += 'Programs:{0}'
    $String += '- Wad Packer/Wad Unpacker{0}'
    $String += '- Floating IPS{0}'
    $String += "- Wiimm's 'wszst' Tool"

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width 350 -Height ($InfoSuperMario64Dialog.Height - 110) -Text $String -AddTo $InfoSuperMario64Dialog

}


#==============================================================================================================================================================================================
function CreateInfoPaperMarioDialog() {
    
     # Create Dialog
    $global:InfoPaperMarioDialog = CreateDialog -Width 400 -Height 460 -Icon $Icons.PaperMario
    $CloseButton = CreateButton -X ($InfoPaperMarioDialog.Width / 2 - 40) -Y ($InfoPaperMarioDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoPaperMarioDialog
    $CloseButton.Add_Click({$InfoPaperMarioDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " (" + $Version + ")" + '{0}'

    $String += '{0}'
    $String += 'Patches Paper Mario game WAD:{0}'
    $String += '1. ROM Injection (requires .Z64 ROM){0}'
    $String += "2. Free BPS Patching (requires .IPS or .BPS File){0}"
    $String += '3. Paper Mario: Hard Mode (Extra damage){0}'
    $String += '4. Paper Mario: Hard Mode+ (Extra damage and enemy HP) {0}'
    $String += '5. Paper Mario: Insane Mode (Insane damage){0}'

    $String += '{0}'
    $String += 'Known Issues:{0}'
    $String += '- Unknown{0}'

    $String += '{0}'
    $String += 'Requirements:{0}'
    $String += '- Paper Mario VC USA WAD File{0}'

    $String += '{0}'
    $String += 'Instructions:{0}'
    $String += '- Select Paper Mario VC USA WAD File{0}'
    $String += '- Press one of several patching buttons{0}'
    $String += '- Original WAD is preserved{0}'

    $String += '{0}'
    $String += 'Information:{0}'
    $String += '- Existing AR/Gecko codes still work{0}'
    
    $String += '{0}'
    $String += 'Programs:{0}'
    $String += '- Wad Packer/Wad Unpacker{0}'
    $String += '- Floating IPS{0}'
    $String += "- Wiimm's 'wszst' Tool{0}"
    $String += "- Romc Tool"

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width 350 -Height ($InfoPaperMarioDialog.Height - 110) -Text $String -AddTo $InfoPaperMarioDialog

}


#==============================================================================================================================================================================================
function CreateInfoFreeDialog() {
    
    # Create Dialog
    $global:InfoFreeDialog = CreateDialog -Width 400 -Height 410 -Icon $Icons.Free
    $CloseButton = CreateButton -X ($InfoFreeDialog.Width / 2 - 40) -Y ($InfoFreeDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoFreeDialog
    $CloseButton.Add_Click({$InfoFreeDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " (" + $Version + ")" + '{0}'

    $String += '{0}'
    $String += 'Patches Custom game WAD:{0}'
    $String += '1. ROM Injection (requires .Z64 ROM){0}'
    $String += "2. Free BPS Patching (requires .IPS or .BPS File){0}"

    $String += '{0}'
    $String += 'Known Issues:{0}'
    $String += '- Unknown{0}'

    $String += '{0}'
    $String += 'Requirements:{0}'
    $String += '- Any VC WAD File{0}'

    $String += '{0}'
    $String += 'Instructions:{0}'
    $String += '- Select VC WAD File{0}'
    $String += '- Press Inject ROM or Patch BPS{0}'
    $String += '- Original WAD is preserved{0}'

    $String += '{0}'
    $String += 'Information:{0}'
    $String += '- Existing AR/Gecko codes likely will not work{0}'
    
    $String += '{0}'
    $String += 'Programs:{0}'
    $String += '- Wad Packer/Wad Unpacker{0}'
    $String += '- Floating IPS{0}'
    $String += "- Wiimm's 'wszst' Tool"

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width 350 -Height ($InfoFreeDialog.Height - 110) -Text $String -AddTo $InfoFreeDialog

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 760 -Height 470 -Icon $Icons.Credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({$CreditsDialog.Hide()})



    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 80) -Y 10 -Width 160 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " (" + $Version + ")") -AddTo $CreditsDialog



    # Create the string that will be displayed on the window.
    $String = "--- Ocarina of Time REDUX ---{0}"
    $String += "- Maroc, ShadowOne, MattKimura, Roman971, TestRunnerSRL, AmazingAmpharos, Krimtonz, Fig, rlbond86, KevinPal, junglechief{0}"

    $String += "{0}"
    $String += "--- Majora's Mask REDUX ---{0}"
    $String += "- Maroc, Saneki{0}"

    $String += "{0}"
    $String += "--- MM Young Link Model for Ocarina of Time ---{0}"
    $String += "- slash004, The3Dude{0}"

    $String += "{0}"
    $String += "--- MM Adult Link Model for Ocarina of Time ---{0}"
    $String += "- Skilar (https://youtu.be/x6MIeEZIsPw){0}"

    $String += "{0}"
    $String += "--- 16:9 Backgrounds for Ocarina of Time ---{0}"
    $String += "GhostlyDark (Patch), Admentus (Scripting and Assistance){0}"

    $String += "{0}"
    $String += "--- Dawn and Dusk ---{0}"
    $String += "- Lead Development and Music: Captain Seedy-Eye{0}"
    $String += "- 64DD Porting: LuigiBlood{0}"
    $String += "- Special Thanks: PK-LOVE, BWIX, Hylian Modding{0}"
    $String += "- Testers:  Captain Seedy, LuigiBlood, Hard4Games, ZFG, Dry4Haz, Fig{0}"

    $String += "{0}"
    $String += "--- The Fate of the Bombiwa ---{0}"
    $String += "DezZiBao{0}"

    #Create Label
    $String = [String]::Format($String, [Environment]::NewLine)
    $LeftLabel = CreateLabel -X 10 -Y ($InfoLabel.Bottom + 15) -Width 370 -Height ($CreditsDialog.Height - 110) -Text $String -AddTo $CreditsDialog



    # Create the string that will be displayed on the window.
    $String = "--- Majora's Mask: Masked Quest ---{0}"
    $String += "- Garo-Mastah, Aroenai, CloudMax, fkualol, VictorHale, Ideka, Saneki{0}"

    $String += "{0}"
    $String += '--- Translations Ocarina of Time ---{0}'
    $String += '- Spanish: eduardo_a2j (v2.2){0}'
    $String += '- Polish: RPG (v1.3){0}'
    $String += '- Russian: Zelda64rus (v2.32){0}'
    $String += '- Chinese Simplified: madcell (2009){0}'

    $String += '{0}'
    $String += "--- Translations Majora's Mask ---{0}"
    $String += '- Polish: RPG (v1.1){0}'
    $String += '- Russian: Zelda64rus (v2.0 Beta){0}'

    $String += '{0}'
    $String += '--- Super Mario 64: 60 FPS v2 / Analog Camera ---{0}'
    $String += '- Kaze Emanuar{0}'

    $String += '{0}'
    $String += '--- Super Mario 64: Multiplayer v1.4.2 ---{0}'
    $String += '- Skelux{0}'

    $String += '{0}'
    $String += '--- Paper Mario: Hard Mode / Insane Mode ---{0}'
    $String += '- Skelux (Extra Damage), Knux5577 (Enemy HP){0}'

    $String += '{0}'
    $String += '--- Dolphin ---{0}'
    $String += '- Admentus (Testing and PowerShell Patcher){0}'
    $String += '- Bighead (Initial PowerShell patcher){0}'
    $String += '- GhostlyDark (Testing and Assistance)'
    
    #Create Label
    $String = [String]::Format($String, [Environment]::NewLine)
    $RightLabel = CreateLabel -X $LeftLabel.Right -Y ($InfoLabel.Bottom + 15) -Width 370 -Height ($CreditsDialog.Height - 110) -Text $String -AddTo $CreditsDialog

}



#==============================================================================================================================================================================================
function CreateMissingFilesDialog() {
    
    # Create Dialog
    $global:MissingFilesDialog = CreateDialog -Width 300 -Height 200 -Icon $null

    $CloseButton = CreateButton -X ($MissingFilesDialog.Width / 2 - 40) -Y ($MissingFilesDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $MissingFilesDialog
    $CloseButton.Add_Click({$MissingFilesDialog.Hide()})

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " (" + $Version + ")" + "{0}"

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
function CreateTextBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [string]$Name, [string]$Text, [Object]$AddTo) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    if ($Text -ne $null) { $TextBox.Text = $Text }
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateCheckbox([int]$X, [int]$Y, [string]$Name, [boolean]$Checked, [boolean]$IsRadio, [Object]$ToolTip, [string]$Info, [Object]$AddTo) {
    
    if ($IsRadio)   { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else            { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    $Checkbox.Checked = $Checked
    if ($ToolTip -ne $null) { $ToolTip.SetToolTip($Checkbox, $Info) }
    return $Checkbox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X, [int]$Y, [string]$Name, [int]$Width, [int]$Height, [string]$Text, [Object]$Font, [Object]$ToolTip, [string]$Info, [Object]$AddTo) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if ($Text -ne $null)      { $Label.Text = $Text }
    if ($Font -ne $null)      { $Label.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Label, $Info) }
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X, [int]$Y, [string]$Name, [int]$Width, [int]$Height, [string]$Text, [Object]$ToolTip, [string]$Info, [Object]$AddTo) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if ($Text -ne $null)      { $Button.Text = $Text }
    if ($Font -ne $null)      { $Button.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Button, $Info) }
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxGroup([int]$Y, [int]$Height, [Object]$Dialog, [string]$Text)   { return CreateGroupBox -X 15 -Y $Y -Width ($Dialog.Width - 50) -Height ($Height * 30 + 20) -Text $Text -AddTo $Dialog }
function CreateReduxPanel([int]$Row, [Object]$Group)                               { return CreatePanel -X $Group.Left -Y ($Row * 30 + 20) -Width ($Group.Width - 20) -Height 20 -AddTo $Group }



#==============================================================================================================================================================================================
function CreateReduxRadioButton([int]$Column, [int]$Row, [Object]$ToolTip, [Object]$Panel, [boolean]$Checked, [string]$Text, [string]$Info) {
    
    $Button = CreateCheckbox -X ($Column * 155) -Y ($Row * 30) -Checked $Checked -IsRadio $True -ToolTip $ToolTip -Info $Info -AddTo $Panel
    CreateLabel -X $Button.Right -Y ($Button.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $Panel
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxCheckbox([int]$Column, [int]$Row, [Object]$ToolTip, [Object]$Group, [boolean]$Checked, [string]$Text, [string]$Info) {
    
    $Checkbox = CreateCheckbox -X ($Column * 155 + 15) -Y ($Row * 30 - 10) -Checked $False -IsRadio $False -ToolTip $ToolTip -Info $Info -AddTo $Group
    CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $Group
    return $CheckBox

}



#==============================================================================================================================================================================================

# Hide the PowerShell console from the user.
ShowPowerShellConsole -ShowConsole $False
[System.GC]::Collect() | Out-Null

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

# Create the dialogs to show to the user.
CreateMainDialog
ChangeGameMode -Mode "Ocarina of Time"

# Disable patching buttons
EnablePatchButtons -Enable $false

CreateOcarinaOfTimeReduxOptionsDialog
CreateMajorasMaskReduxOptionsDialog
CreateInfoGameIDDialog
CreateInfoOcarinaOfTimeDialog
CreateInfoMajorasMaskDialog
CreateInfoSuperMario64Dialog
CreateInfoPaperMarioDialog
CreateInfoFreeDialog
CreateCreditsDialog

# Show the dialog to the user.
$MainDialog.ShowDialog() | Out-Null

Exit