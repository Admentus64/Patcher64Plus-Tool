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



#==============================================================================================================================================================================================
# Setup global variables

$global:ScriptName = "Patcher64+ Tool"
$global:VersionDate = "2021-01-12"
$global:Version     = "v10.2.1"

$global:GameConsole = $global:GameType = $global:GamePatch = $global:CheckHashSum = ""
$global:GameFiles = $global:Settings = @{}
$global:IsWiiVC = $global:MissingFiles = $False
$global:VCTitleLength = 40
$global:Bootup = $global:GameIsSelected = $global:IsActiveGameField = $False
$global:Last = @{}
$global:Fonts = @{}



#==============================================================================================================================================================================================
# Set file paths

# Create a hash table
$global:Paths = @{}

# The path this script is found in.
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
    $Paths.Base = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    $global:ExternalScript = $True
}
else {
    $Paths.Base = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
    if (!$Paths.Base) { $Paths.Base = "." }
    $global:ExternalScript = $False
}

# Set all other paths
$Paths.Master          = $Paths.Base + "\Files"
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

#$module = Get-Module -Name "Forms"
#$publicFunctions = (Get-Command -Module $module.name).name
#$privateFunctions = ($module.Invoke({Get-Command -module $module.name})).name | Where-Object { $_ -notin $publicFunctions }
#Write-Host "Private Functions:" $privateFunctions
#Write-Host (Get-PSCallStack)[1].Command



#==============================================================================================================================================================================================
$HidePSConsole = @"
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
"@
Add-Type -Namespace Console -Name Window -MemberDefinition $HidePSConsole




<#
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
#>



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

# Font
if ($Settings.Core.ClearType -eq $True)   { $Font = "Segoe UI" }
else                                      { $Font = "Microsoft Sans Serif" }
$Fonts.Medium         = New-Object System.Drawing.Font($Font, 12, [System.Drawing.FontStyle]::Bold)
$Fonts.Small          = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Regular)
$Fonts.SmallBold      = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Bold)
$Fonts.SmallUnderline = New-Object System.Drawing.Font($Font, 8,  [System.Drawing.FontStyle]::Underline)

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
$CustomTitleTextBox.Add_TextChanged({                  if (IsChecked $CustomHeaderCheckbox)   { $Settings["Core"]["CustomTitle"] = $this.Text } })
$CustomGameIDTextBox.Add_TextChanged({                 if (IsChecked $CustomHeaderCheckbox)   { $Settings["Core"]["CustomGameID"] = $this.Text } })
$CustomRegionCodeComboBox.Add_SelectedIndexChanged({   if (IsChecked $CustomHeaderCheckbox)   { $Settings["Core"]["CustomRegionCode"] = $this.SelectedIndex } })
$CustomHeaderCheckbox.Add_CheckedChanged({ RestoreCustomHeader })
RestoreCustomHeader

# Restore VC Checkboxes
CheckVCOptions
if (!$GameIsSelected) { ChangePatchPanel }

# Show the dialog to the user
$MainDialog.ShowDialog() | Out-Null

# Exit
Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
if ($GameType.save -gt 0) { Out-IniFile -FilePath (GetGameSettingsFile) -InputObject $GameSettings | Out-Null }
RemovePath $Paths.Registry
[System.GC]::Collect() | Out-Null
Exit