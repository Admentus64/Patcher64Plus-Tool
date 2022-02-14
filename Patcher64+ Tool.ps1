#=============================================================================================================================================================================================
# Patcher By     :  Admentus
# Concept By     :  Bighead
# Testing By     :  Admentus, GhostlyDark



#==============================================================================================================================================================================================
if ( (Get-ExecutionPolicy) -eq "Restricted") {
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
    Write-Host "Execution Policy for the current user has been set to Unrestricted to allow usage of PowerShell scripts such as Patcher64+"
}



#==============================================================================================================================================================================================
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'
[Windows.Forms.Application]::EnableVisualStyles()
#Write-Host $((Get-PSCallStack)[1]).Command



#==============================================================================================================================================================================================
# Setup global variables

$global:ScriptName = "Patcher64+ Tool"
$global:VersionDate = "Date Missing"
$global:Version     = "Version Missing"
$global:SystemDate  = Get-Date -Format yyyy-MM-dd-HH-mm-ss

$global:CommandType = $MyInvocation.MyCommand.CommandType.ToString()
$global:Definition  = $MyInvocation.MyCommand.Definition.ToString()

$global:VCTitleLength = 40
$global:GameConsole = $global:GameType = $global:GamePatch = $global:CheckHashSum = $null
$global:GameFiles = $global:Settings = @{}
$global:IsWiiVC = $global:MissingFiles = $False
$global:Bootup = $global:GameIsSelected = $global:IsActiveGameField = $False
$global:Last = $global:Fonts = @{}
$global:FatalError = $global:WarningError = $False
$global:ConsoleHistory = @()
$global:DialogUpdateRateMS = 50



#==============================================================================================================================================================================================
$HidePSConsole = @"
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
"@
Add-Type -Namespace Console -Name Window -MemberDefinition $HidePSConsole



#==============================================================================================================================================================================================
function GetScriptPath() {
    
    if ($CommandType -eq "ExternalScript") { # This is the command that should have been stored
        $SplitDef  = $Definition.Split('\') # Split the path on every "\" and grab the last one
        $InputFile = $SplitDef[$SplitDef.Count-1]
        $global:ExternalScript = $True
        $Path = $Definition.Replace(($InputFile), '')
        $Path = $Path.substring(0, $Path.length-1)
        return $Path # If it was, the definition will hold the full path to the script
    }

    $FullPath  = ([Environment]::GetCommandLineArgs()[0]).ToString() # Split the path on every "\" and grab the last one
    $SplitDef  = $FullPath.Split('\')
    $InputFile = $SplitDef[$SplitDef.Count-1].Substring(0, $SplitDef[$SplitDef.Count-1].Length - 4) + '.exe'
    $global:ExternalScript = $False
    if ($ScriptPath) { $ScriptPath = $FullPath.Replace(($InputFile), '') } else { $ScriptPath = "." } # If running via an executable, the command will be different so get the path through an argument
    $Paths.FullBase = $FullPath.Replace(($InputFile), '')
    $Paths.FullBase = $Paths.Fullbase.substring(0, $Paths.Fullbase.length-1)
    return $ScriptPath # Return whatever we got in the above.

}



#==============================================================================================================================================================================================
function ImportModule([string]$Name) {
    
    if (Test-Path -LiteralPath ($Paths.Scripts + "\" + $Name + ".psm1") -PathType Leaf)   { Import-Module ($Paths.Scripts + "\" + $Name + ".psm1") }
    else                                                                                  { CreateErrorDialog -Error "Missing Modules" -Exit }

}



#==============================================================================================================================================================================================
function CheckScripts() {
    
    $string  = $ScriptName + " " + $Version + " (" + $VersionDate + ")" + "{0}{0}"
    $string += "Fatal Error: Script files are missing{0}"

    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Bytes.psm1")))      { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Bytes.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Common.psm1")))     { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Common.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Dialogs.psm1")))    { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Dialogs.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\DPI.psm1")))        { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\DPI.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Editor.psm1")))     { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Editor.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Files.psm1")))      { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Files.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Forms.psm1")))      { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Forms.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Main.psm1")))       { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Main.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\MQ.psm1")))         { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\MQ.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Patch.psm1")))      { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Patch.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Settings.psm1")))   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Settings.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\VC.psm1")))         { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\VC.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Zelda 64.psm1")))   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Zelda 64.psm1" }
    
    if (!$FatalError) { return }
    
    $Dialog = New-Object System.Windows.Forms.Form
    $Dialog.Text = $ScriptName
    $Dialog.AutoSize = $True
    $Dialog.StartPosition = "CenterScreen"
    $Dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

    $Label = New-Object System.Windows.Forms.Label
    $Label.AutoSize = $True
    $Label.Location = New-Object System.Drawing.Size(10, 10)
    $Label.Text = [string]::Format($String, [Environment]::NewLine)

    $Dialog.Controls.Add($Label)
    $Dialog.ShowDialog() | Out-Null
    Exit

}



#==================================================================================================================================================================================================================================================================
# Paths

$global:Paths = @{}

# Set all paths
$Paths.Base            = GetScriptPath
if ($Paths.FullBase -eq $null) { $Paths.FullBase = $Paths.Base }
$Paths.Master          = $Paths.Base   + "\Files"
$Paths.Registry        = $Paths.Master + "\Registry"
$Paths.Games           = $Paths.Master + "\Games"
$Paths.Shared          = $Paths.Master + "\Games\Shared"
$Paths.Main            = $Paths.Master + "\Main"
$Paths.Tools           = $Paths.Master + "\Tools"
$Paths.WiiVC           = $Paths.Tools  + "\Wii VC"
$Paths.Scripts         = $Paths.Master + "\Scripts"
$Paths.LocalTemp       = $Paths.FullBase + "\Files\Temp"
$Paths.AppData         = $env:APPDATA + "\Patcher64+ Tool"
$Paths.AppDataTemp     = $Paths.AppData + "\Temp"
$Paths.Temp            = $Paths.Local
$Paths.Settings        = $Paths.Master + "\Settings"
$Paths.Logs            = $Paths.Master + "\Logs"
$Paths.cygdrive        = $Paths.Master + "\Tools\cygdrive"



#==================================================================================================================================================================================================================================================================
# Check if neccessary functions are imported
CheckScripts



#==================================================================================================================================================================================================================================================================
# Load modules

foreach ($Script in Get-ChildItem -LiteralPath $Paths.Scripts -Force) {
    if ( !$Script.PSIsContainer -and $Script.Extension -eq ".psm1") { ImportModule $Script.BaseName }
}



#==================================================================================================================================================================================================================================================================
# Read version data

$versionFile = $Paths.Master + "\Version.txt"
if (TestFile $versionFile) {
    $global:Version     = (Get-Content -LiteralPath $versionFile)[0]
    $global:VersionDate = (Get-Content -LiteralPath $versionFile)[1]
}


#==================================================================================================================================================================================================================================================================
# Auto-Updater

function AutoUpdate() {
    
    $update = $false
    $file = $Paths.base + "\version.txt"
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Admentus64/Patcher64Plus-Tool/master/Files/version.txt" -OutFile $file
        $newVersion = (Get-Content -LiteralPath $file)[0]
        $newDate    = (Get-Content -LiteralPath $file)[1]
        RemoveFile $file

        if ($Version -lt $newVersion)                                { $update = $true }
        elseif ( (Get-Date $VersionDate) -lt (Get-Date $newDate) )   { $update = $true }

        
    }
    catch { UpdateStatusLabel "Could not run the auto-updater" }
    
    if ($update) {
        $UpdateDialog = New-Object System.Windows.Forms.Form
        $UpdateDialog.Size = DPISize (New-Object System.Drawing.Size(360, 180))
        $UpdateDialog.Text = $ScriptName
        $UpdateDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        $UpdateDialog.StartPosition = "CenterScreen"
        $UpdateDialog.Icon = $Files.icon.main

        $label   = CreateLabel -x (DPISize 20)  -Y (DPISize 10) -Text ("Would you like to update Patcher64+?`n" + "New Version: " + $newVersion) -Font $Fonts.Medium -AddTo $UpdateDialog
        $yesBtn  = CreateButton -X (DPISize 60)  -Y (DPISize 80)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $UpdateDialog -Text "Yes"
        $noBtn   = CreateButton  -X (DPISize 200) -Y (DPISize 80)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $UpdateDialog -Text "No"
    
        $yesBtn.Add_Click( { $UpdateDialog.Close(); RunAutoUpdate } )
        $noBtn.Add_Click(  { $UpdateDialog.Close() } )

        $UpdateDialog.ShowDialog() | Out-Null
        $UpdateDialog = $label = $yesBtn = $noBtn = $null
    }
}

function RunAutoUpdate() {
    
    $path   = $Paths.Base
    $master = $Paths.Base + "\master.zip"
    Invoke-WebRequest -Uri "https://github.com/Admentus64/Patcher64Plus-Tool/archive/refs/heads/master.zip" -OutFile $master

    if (!(TestFile $master)) {
        UpdateStatusLabel "Could not extract new update"
        return
    }

    Expand-Archive -LiteralPath $master -DestinationPath $path
    RemoveFile $master

    RemovePath $Paths.Games
    RemovePath $Paths.Tools
    RemovePath $Paths.Main
    RemovePath $Paths.Scripts
    RemovePath $Paths.Base + "\Info"

    $newFolder = $Paths.base + "\Patcher64Plus-Tool-master\"
    Move-Item -LiteralPath ($newFolder + "Files\Games")         -Destination $Paths.Games
    Move-Item -LiteralPath ($newFolder + "Files\Tools")         -Destination $Paths.Tools
    Move-Item -LiteralPath ($newFolder + "Files\Main")          -Destination $Paths.Main
    Move-Item -LiteralPath ($newFolder + "Files\Scripts")       -Destination $Paths.Scripts
    Move-Item -LiteralPath ($newFolder + "Info")                -Destination ($Paths.Base + "\Info")
    Move-Item -LiteralPath ($newFolder + "Patcher64+ Tool.ps1") -Destination $Paths.Base
    Move-Item -LiteralPath ($newFolder + "Files\version.txt")   -Destination $Paths.Master

    RemovePath $newFolder

    $global:FatalError = $True

}



#==============================================================================================================================================================================================
# Run Patcher64+ Tool

Clear-Host

# Retrieve settings
$global:Settings = GetSettings ($Paths.Settings + "\Core.ini")
if (!(IsSet $Settings.Core)  -and !$FatalError)   { $Settings.Core  = @{} }
if (!(IsSet $Settings.Debug) -and !$FatalError)   { $Settings.Debug = @{} }

# Logging
if (!$ExternalScript) { $global:TranscriptTime = $SystemDate }
SetLogging ($Settings.Debug.Logging -ne $False)

# Temp
if ($Settings.Core.LocalTempFolder -eq $True)   { $Paths.Temp = $Paths.LocalTemp }
else                                            { $Paths.Temp = $Paths.AppDataTemp }

# Hi-DPI Mode
$global:DisableHighDPIMode = $Settings.Core.HiDPIMode -eq $False
InitializeHiDPIMode
$global:ColumnWidth  = DPISize 180
$global:FormDistance = DPISize 185
$global:DialogSize   = 185

# Visual Style
SetModernVisualStyle ($Settings.Core.ModernStyle -ne $False)

# Set paths to all the files stored in the script
SetFileParameters

# Enable sounds
LoadSoundEffects ($Settings.Core.EnableSounds -eq $True)

# Font
if ($Settings.Core.ClearType -eq $True)   { $Font = "Segoe UI" }
else                                      { $Font = "Microsoft Sans Serif" }
$Fonts.Medium         = New-Object System.Drawing.Font($Font, 12, [System.Drawing.FontStyle]::Bold)
$Fonts.Small          = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Regular)
$Fonts.SmallBold      = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Bold)
$Fonts.SmallUnderline = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Underline)
$Fonts.TextFile       = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Regular)
$Fonts.Editor         = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Regular)

if (TestFile ($Paths.Base + "\master.zip")) { RemoveFile ($Paths.Base + "\master.zip") }
AutoUpdate

# Hide the PowerShell console from the user
ShowPowerShellConsole ($Settings.Debug.Console -eq $True)

# Ask for default interface mode on first time use
 if ($Settings.Core.Interface -ne 1 -and $Settings.Core.Interface -ne 2 -and $Settings.Core.Interface -ne 3 -and !$FatalError) {
    $global:PopupDialog = New-Object System.Windows.Forms.Form
    $PopupDialog.Size = DPISize (New-Object System.Drawing.Size(390, 150))
    $PopupDialog.Text = $ScriptName
    $PopupDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $PopupDialog.StartPosition = "CenterScreen"
    $PopupDialog.Icon = $Files.icon.main

    $label   = CreateLabel  -x (DPISize 20)  -Y (DPISize 10) -Text "Select Your Default Interface Mode:" -Font $Fonts.Medium -AddTo $PopupDialog
    $hud1Btn = CreateButton -X (DPISize 20)  -Y (DPISize 50)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $PopupDialog -Text "Beginner Mode" -Info "Hide advanced options"
    $hud2Btn = CreateButton -X (DPISize 140) -Y (DPISize 50)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $PopupDialog -Text "Lite Mode"     -Info "Hide options that are likely incompatible with various ROM hacks"
    $hud3Btn = CreateButton -X (DPISize 260) -Y (DPISize 50)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $PopupDialog -Text "Advanced Mode" -Info "Show all options"
    
    $hud1Btn.Add_Click( { $Settings.Core.Interface = 1; $PopupDialog.Close() } )
    $hud2Btn.Add_Click( { $Settings.Core.Interface = 2; $PopupDialog.Close() } )
    $hud3Btn.Add_Click( { $Settings.Core.Interface = 3; $PopupDialog.Close() } )

    $PopupDialog.ShowDialog() | Out-Null
    $global:PopupDialog = $label = $hud1Btn = $Hud2Btn = $Hud3Btn = $null
}

# Create the dialogs to show to the user
CreateMainDialog     | Out-Null
CreateSettingsDialog | Out-Null

# Check if restricted
if (IsRestrictedFolder $Paths.FullBase) {
    $GeneralSettings.LocalTempFolder.Checked = $False
    $GeneralSettings.LocalTempFolder.Enabled = $False
    SetTempFileParameters
}

# Critical info
WriteToConsole ("Version:       " + $Version)
WriteToConsole ("Version Date:  " + $VersionDate)
WriteToConsole ("Full Path:     " + $Paths.FullBase)
WriteToConsole ("System Date:   " + $SystemDate)
WriteToConsole ("Temp Folder:   " + $Paths.Temp)

if (!$FatalError) {
    # Set default game mode
    ChangeConsolesList   | Out-Null
    GetFilePaths         | Out-Null

    # Restore Last Custom Title and GameID
    $CustomHeader.ROMTitle.Add_TextChanged({        if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.ROMTitle"]  = $this.Text } })
    $CustomHeader.ROMGameID.Add_TextChanged({       if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.ROMGameID"] = $this.Text } })
    $CustomHeader.VCTitle.Add_TextChanged({         if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.VCTitle"]   = $this.Text } })
    $CustomHeader.VCGameID.Add_TextChanged({        if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.VCGameID"]  = $this.Text } })
    $CustomHeader.Region.Add_SelectedIndexChanged({ if (IsChecked $CustomHeader.EnableRegion)   { $Settings["Core"]["CustomHeader.Region"]    = $this.SelectedIndex } })
    $CustomHeader.EnableHeader.Add_CheckedChanged({ RestoreCustomHeader })
    $CustomHeader.EnableRegion.Add_CheckedChanged({ RestoreCustomRegion })
    RestoreCustomHeader
    RestoreCustomRegion

    # Restore last settings
    if ($GameConsole -eq $null) { ChangeGamesList | Out-Null }
    ChangeGameMode    | Out-Null
    ChangeGameRev     | Out-Null
    ChangePatchPanel  | Out-Null
    ChangePatch       | Out-Null
    SetMainScreenSize | Out-Null
    SetVCPanel        | Out-Null
    ChangeGamesList   | Out-Null
    ChangeRevList     | Out-Null

    # Active GUI events
    InitializeEvents
}

if (!(TestFile $versionFile)) { UpdateStatusLabel "Could not read version and date of the patcher" }

# Show the dialog to the user
if (!$FatalError) { $MainDialog.ShowDialog() | Out-Null }

# Exit
if (!$FatalError) {
        Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
        if ($GameType.save -gt 0) { Out-IniFile -FilePath (GetGameSettingsFile) -InputObject $GameSettings | Out-Null }
        RemovePath $Paths.Registry
        SetLogging $False
        $global:ConsoleHistory = $global:Redux = $global:Settings = $global:GeneralSettings = $global:MainDialog = $global:InputPaths = $global:Patches = $global:VC = $global:CustomHeader = $null
    }

StopJobs
Exit