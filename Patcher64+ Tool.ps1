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

$global:Patcher     = @{}
$global:Addons      = @{}
$Patcher.Title      = "Patcher64+ Tool"
$Patcher.Date       = "Date Missing"
$Patcher.DateFormat = "yyyy-MM-dd"
$Patcher.Version    = "Version Missing"
$Patcher.Hotfix     = 0

$global:CommandType = $MyInvocation.MyCommand.CommandType.ToString()
$global:Definition  = $MyInvocation.MyCommand.Definition.ToString()

$global:GameConsole        = $global:GameType       = $global:GamePatch         = $global:CheckHashSum = $null
$global:Bootup             = $global:GameIsSelected = $global:IsActiveGameField = $False
$global:GameFiles          = $global:Settings       = @{}
$global:IsWiiVC            = $global:MissingFiles   = $False
$global:Last               = $global:Fonts          = @{}
$global:FatalError         = $global:WarningError   = $False
$global:SystemDate         = Get-Date -Format yyyy-MM-dd
$global:ConsoleHistory     = @()
$global:VCTitleLength      = 40
$global:DialogUpdateRateMS = 50
$global:Relaunch           = $False



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
    
    $string  = $Patcher.Title + " " + $Patcher.Version + " (" + $Patcher.Date + ")" + "{0}{0}"
    $string += "Fatal Error: Script files are missing{0}"

    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Bytes.psm1")        ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Bytes.psm1"        }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Common.psm1")       ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Common.psm1"       }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Dialogs.psm1")      ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Dialogs.psm1"      }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\DPI.psm1")          ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\DPI.psm1"          }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Text Editor.psm1")  ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Text Editor.psm1"  }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Files.psm1")        ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Files.psm1"        }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Forms.psm1")        ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Forms.psm1"        }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Main.psm1")         ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Main.psm1"         }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\MQ.psm1")           ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\MQ.psm1"           }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Patch.psm1")        ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Patch.psm1"        }
  # if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Actor Editor.psm1") ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Actor Editor.psm1" }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Settings.psm1")     ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Settings.psm1"     }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\VC.psm1")           ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\VC.psm1"           }
    if (!(Test-Path -PathType Leaf -LiteralPath ($Paths.Scripts + "\Zelda 64.psm1")     ) )   { $FatalError = $True; $string += "{0}" + $Paths.Scripts + "\Zelda 64.psm1"     }
    
    if (!$FatalError) { return }
    
    $Dialog                 = New-Object System.Windows.Forms.Form
    $Dialog.Text            = $Patcher.Title
    $Dialog.AutoSize        = $True
    $Dialog.StartPosition   = "CenterScreen"
    $Dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

    $Label          = New-Object System.Windows.Forms.Label
    $Label.AutoSize = $True
    $Label.Location = New-Object System.Drawing.Size(10, 10)
    $Label.Text     = [string]::Format($String, [Environment]::NewLine)

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
$Paths.AddonIcons      = $Paths.Master + "\Main\Addons"
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
$Paths.Addons          = $Paths.Master + "\Addons"
$Paths.Models          = $Paths.Addons + "\Models"
$Paths.Music           = $Paths.Addons + "\Music"
$Patcher.VersionFile   = $Paths.Master + "\version.txt"



#==================================================================================================================================================================================================================================================================
# Check if neccessary functions are imported
CheckScripts



#==================================================================================================================================================================================================================================================================
# Load modules

foreach ($Script in Get-ChildItem -LiteralPath $Paths.Scripts -Force) {
    if ( !$Script.PSIsContainer -and $Script.Extension -eq ".psm1") { ImportModule $Script.BaseName }
}



#==============================================================================================================================================================================================
# Run Patcher64+ Tool

Clear-Host

if ([Environment]::Is64BitOperatingSystem) { $Patcher.Bit = "x86-64" } else { $Patcher.Bit = "x86" }
$Patcher.OS = GetWindowsVersion
if ([Environment]::OSVersion -Match "Windows") { $Patcher.OS = "Windows " + $Patcher.OS }

CheckUpdate

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
$Fonts.Medium         = New-Object System.Drawing.Font($Font,      12, [System.Drawing.FontStyle]::Bold)
$Fonts.Small          = New-Object System.Drawing.Font($Font,      8,  [System.Drawing.FontStyle]::Regular)
$Fonts.SmallBold      = New-Object System.Drawing.Font($Font,      8,  [System.Drawing.FontStyle]::Bold)
$Fonts.SmallUnderline = New-Object System.Drawing.Font($Font,      8,  [System.Drawing.FontStyle]::Underline)
$Fonts.TextFile       = New-Object System.Drawing.Font("Consolas", 8,  [System.Drawing.FontStyle]::Regular)
$Fonts.Editor         = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Regular)

# Hide the PowerShell console from the user
ShowPowerShellConsole ($Settings.Debug.Console -eq $True)

# Auto-Updater
PerformUpdate

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
WriteToConsole ("OS:             " + $Patcher.OS + " (" + $Patcher.Bit + ")")
WriteToConsole ("Version:        " + $Patcher.Version)
WriteToConsole ("Version Date:   " + $Patcher.Date)
WriteToConsole ("Version Hotfix: #" + $Patcher.Hotfix)
WriteToConsole ("Full Path:      " + $Paths.FullBase)
WriteToConsole ("System Date:    " + $SystemDate)
WriteToConsole ("Temp Folder:    " + $Paths.Temp)

if (!$FatalError) {
    # Set default game mode
    GetFilePaths       | Out-Null
    WriteToConsole "--------------------------------"

    # Restore Last Custom Title and GameID
    RestoreCustomHeader
    RestoreCustomRegion
    $CustomHeader.ROMTitle.Add_TextChanged({        if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.ROMTitle"]  = $this.Text          } })
    $CustomHeader.ROMGameID.Add_TextChanged({       if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.ROMGameID"] = $this.Text          } })
    $CustomHeader.VCTitle.Add_TextChanged({         if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.VCTitle"]   = $this.Text          } })
    $CustomHeader.VCGameID.Add_TextChanged({        if (IsChecked $CustomHeader.EnableHeader)   { $Settings["Core"]["CustomHeader.VCGameID"]  = $this.Text          } })
    $CustomHeader.Region.Add_SelectedIndexChanged({ if (IsChecked $CustomHeader.EnableRegion)   { $Settings["Core"]["CustomHeader.Region"]    = $this.SelectedIndex } })
    $CustomHeader.EnableHeader.Add_CheckedChanged({ RestoreCustomHeader })
    $CustomHeader.EnableRegion.Add_CheckedChanged({ RestoreCustomRegion })

    # Restore last settings
    ChangeConsolesList | Out-Null
    ChangeGamesList    | Out-Null
    ChangeGameMode     | Out-Null
    ChangeGameRev      | Out-Null
    ChangePatch        | Out-Null
    SetMainScreenSize  | Out-Null
    SetVCPanel         | Out-Null

    # Active GUI events
    InitializeEvents
}

if (!(TestFile $Patcher.VersionFile)) { UpdateStatusLabel "Could not read version and date of the patcher" }

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

if (TestFile -Path $Paths.Logs -Container) {
    $logs = [System.Collections.ArrayList]@(Get-ChildItem -Path $Paths.Logs -Filter "*.log" -File)
    while ($logs.count -gt 10) { RemoveFile ($Paths.Logs + "\" + $logs[0]); $logs.RemoveAt(0) }
}

StopJobs
if ($Relaunch) {
    Get-ChildItem -Path ".\" -Filter "*.ps1" -File -Name| ForEach-Object { $scriptPath = $Paths.Base + "\" + ([System.IO.Path]::GetFileName($_)) }
    Start-Process -FilePath powershell.exe -ArgumentList @("-File `"$ScriptPath`" $arg")
}

Exit