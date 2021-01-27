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



#==============================================================================================================================================================================================
# Setup global variables

$global:ScriptName = "Patcher64+ Tool"
$global:VersionDate = "2021-01-27"
$global:Version     = "v11.2.0"

$global:CommandType = $MyInvocation.MyCommand.CommandType.ToString()
$global:Definition  = $MyInvocation.MyCommand.Definition.ToString()

$global:GameConsole = $global:GameType = $global:GamePatch = $global:CheckHashSum = ""
$global:GameFiles = $global:Settings = @{}
$global:IsWiiVC = $global:MissingFiles = $False
$global:VCTitleLength = 40
$global:Bootup = $global:GameIsSelected = $global:IsActiveGameField = $False
$global:Last = @{}
$global:Fonts = @{}
$global:FatalError = $False



#==============================================================================================================================================================================================
# Set file paths

function GetScriptPath() {
    
    if ($CommandType -eq "ExternalScript") { # This is the command that should have been stored
        $SplitDef  = $Definition.Split('\') # Split the path on every "\" and grab the last one
        $InputFile = $SplitDef[$SplitDef.Count-1]
        $global:ExternalScript = $True
        return $Definition.Replace(($InputFile),'') # If it was, the definition will hold the full path to the script
    }

    $FullPath  = ([Environment]::GetCommandLineArgs()[0]).ToString() # Split the path on every "\" and grab the last one
    $SplitDef  = $FullPath.Split('\')
    $InputFile = $SplitDef[$SplitDef.Count-1].Substring(0, $SplitDef[$SplitDef.Count-1].Length - 4) + '.exe'
    $global:ExternalScript = $False
    if ($ScriptPath) { $ScriptPath = $FullPath.Replace(($InputFile),'') } else { $ScriptPath = "." } # If running via an executable, the command will be different so get the path through an argument
    return $ScriptPath # Return whatever we got in the above.

}

# Create a hash table
$global:Paths = @{}

# Set all paths
$Paths.Base            = GetScriptPath
$Paths.Master          = $Paths.Base   + "\Files"
$Paths.Registry        = $Paths.Master + "\Registry"
$Paths.Games           = $Paths.Master + "\Games"
$Paths.Main            = $Paths.Master + "\Main"
$Paths.Tools           = $Paths.Master + "\Tools"
$Paths.WiiVC           = $Paths.Tools  + "\Wii VC"
$Paths.Scripts         = $Paths.Master + "\Scripts"
$Paths.Temp            = $Paths.Master + "\Temp"
$Paths.Settings        = $Paths.Master + "\Settings"
$Paths.cygdrive        = $Paths.Master + "\cygdrive"



#==============================================================================================================================================================================================
# Import code

function ImportModule([String]$Name) {
    
    if (Test-Path -LiteralPath ($Paths.Scripts + "\" + $Name + ".psm1") -PathType Leaf)   { Import-Module ($Paths.Scripts + "\" + $Name + ".psm1") }
    else                                                                                  { CreateErrorDialog -Error "Missing Modules" -Exit }

}

foreach ($Script in Get-ChildItem -LiteralPath $Paths.Scripts -Force) {
    if ( !$Script.PSIsContainer -and $Script.Extension -eq ".psm1") { ImportModule -Name $Script.BaseName }
}
foreach ($Script in Get-ChildItem -LiteralPath ($Paths.Scripts + "\Options") -Force) {
    if ( !$Script.PSIsContainer -and $Script.Extension -eq ".psm1") { ImportModule -Name ("Options\" + $Script.BaseName) }
}



#==============================================================================================================================================================================================
$HidePSConsole = @"
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
"@
Add-Type -Namespace Console -Name Window -MemberDefinition $HidePSConsole



#==================================================================================================================================================================================================================================================================
function IsNumeric([String]$str) {
    
    if ($Str -match "^\d+$") { return $True }

    return $False

}



#==============================================================================================================================================================================================

# Retrieve settings
$global:Settings = GetSettings ($Paths.Settings + "\Core.ini")
if (!(IsSet $Settings.Core))   { $Settings.Core  = @{} }
if (!(IsSet $Settings.Debug))  { $Settings.Debug = @{} }

# Visual Style
SetModernVisualStyle ($Settings.Core.ModernStyle -eq $False)

if ($Settings.Core.ModernStyle -eq $False) { [Windows.Forms.Application]::VisualStyleState = [Windows.Forms.VisualStyles.VisualStyleState]::NonClientAreaEnabled }
else {
    [Windows.Forms.Application]::EnableVisualStyles()
    [Windows.Forms.Application]::VisualStyleState = [Windows.Forms.VisualStyles.VisualStyleState]::ClientAndNonClientAreasEnabled
}

# Hi-DPI Mode
if ($Settings.Core.HiDPIMode -eq $False)   { $global:DisableHighDPIMode = $True }
else                                       { $global:DisableHighDPIMode = $False }
InitializeHiDPIMode

# Font
if ($Settings.Core.ClearType -eq $True)   { $Font = "Segoe UI" }
else                                      { $Font = "Microsoft Sans Serif" }
$Fonts.Medium         = New-Object System.Drawing.Font($Font, 12, [System.Drawing.FontStyle]::Bold)
$Fonts.Small          = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Regular)
$Fonts.SmallBold      = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Bold)
$Fonts.SmallUnderline = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Underline)
$Fonts.TextFile       = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Regular)

# Hide the PowerShell console from the user
if ($Settings.Debug.Console -ne $True) { ShowPowerShellConsole $False }

# Set paths to all the files stored in the script
SetFileParameters

# Create the dialogs to show to the user
CreateMainDialog
CreateCreditsDialog
CreateSettingsDialog

# Set default game mode
ChangeConsolesList
GetFilePaths

# Restore Last Custom Title and GameID
$CustomHeader.Title.Add_TextChanged({           if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.Title"]  = $this.Text } })
$CustomHeader.GameID.Add_TextChanged({          if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.GameID"] = $this.Text } })
$CustomHeader.Region.Add_SelectedIndexChanged({ if (IsChecked $CustomHeader.EnableRegion)   { $Settings["Core"]["CustomHeader.Region"] = $this.SelectedIndex } })
$CustomHeader.EnableHeader.Add_CheckedChanged({ RestoreCustomHeader })
$CustomHeader.EnableRegion.Add_CheckedChanged({ RestoreCustomRegion })
RestoreCustomHeader
RestoreCustomRegion

# Active GUI events
InitializeEvents

# Restore last settings
ChangeGameMode
ChangePatchPanel
SetMainScreenSize
SetVCPanel
CheckVCOptions

# Show the dialog to the user
if (!$FatalError) { $MainDialog.ShowDialog() | Out-Null }

# Exit
Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
if ($GameType.save -gt 0) { Out-IniFile -FilePath (GetGameSettingsFile) -InputObject $GameSettings | Out-Null }
RemovePath $Paths.Registry
[System.GC]::Collect() | Out-Null
Exit