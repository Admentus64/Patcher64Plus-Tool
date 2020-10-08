#=============================================================================================================================================================================================
# Patcher By     :  Admentus
# Concept By     :  Bighead
# Testing By     :  Admentus, GhostlyDark



#==============================================================================================================================================================================================
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'



#==============================================================================================================================================================================================
# Setup global variables

$global:ScriptName = "Patcher64+ Tool"
$global:VersionDate = "08-10-2020"
$global:Version     = "v7.7.1"

$global:GameType = $global:GamePatch = $global:CheckHashSum = ""
$global:GameFiles = $global:Settings = @{}
$global:IsWiiVC = $global:MissingFiles = $False
$global:GameTitleLength = @(20, 40)

$global:CurrentModeFont = New-Object System.Drawing.Font("Microsoft Sans Serif", 12, [System.Drawing.FontStyle]::Bold)
$global:VCPatchFont     = New-Object System.Drawing.Font("Microsoft Sans Serif", 8,  [System.Drawing.FontStyle]::Bold)
$global:URLFont         = New-Object System.Drawing.Font("Microsoft Sans Serif", 8,  [System.Drawing.FontStyle]::Underline)



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
$Paths.WiiVC           = $Paths.Master + "\Wii VC"
$Paths.Games           = $Paths.Master + "\Games"
$Paths.Main            = $Paths.Master + "\Main"
$Paths.Scripts         = $Paths.Master + "\Scripts"
$Paths.Extraction      = $Paths.Master + "\Data Extraction"



#==============================================================================================================================================================================================
# Import code

function ImportModule([String]$Name) {
    
    if (Test-Path ($Paths.Scripts + "\" + $Name + ".psm1") -PathType Leaf)   { Import-Module -Name ($Paths.Scripts + "\" + $Name + ".psm1") }
    else                                                                     { CreateErrorDialog -Error "Missing Modules" -Exit }

}

ImportModule -Name "Bytes"
ImportModule -Name "Common"
ImportModule -Name "Dialogs"
ImportModule -Name "Files List"
ImportModule -Name "Forms"
ImportModule -Name "Main Dialog"
ImportModule -Name "Master Quest"
ImportModule -Name "Optional"
ImportModule -Name "Patch"
ImportModule -Name "Settings"

#$module = Get-Module -Name "Forms"
#$publicFunctions = (Get-Command -Module $module.name).name
#$privateFunctions = ($module.Invoke({Get-Command -module $module.name})).name | Where-Object { $_ -notin $publicFunctions }
#Write-Host "Private Functions:" $privateFunctions



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



#==============================================================================================================================================================================================

# Retrieve settings
GetSettings

# Hide the PowerShell console from the user.
if ($Settings.Debug.Console -ne $True) { ShowPowerShellConsole -ShowConsole $False }

# Set paths to all the files stored in the script.
SetFileParameters

# Create the dialogs to show to the user.
CreateMainDialog
CreateLanguagesDialog
CreateCreditsDialog
CreateSettingsDialog

# Set default game mode.
GetFilePaths
ChangeGamesList

# Restore Last Custom Title and GameID
$CustomTitleTextBox.Add_TextChanged({  if (IsChecked $CustomHeaderCheckbox)   { $Settings["Core"]["CustomTitle"] = $this.Text } })
$CustomGameIDTextBox.Add_TextChanged({ if (IsChecked $CustomHeaderCheckbox)   { $Settings["Core"]["CustomGameID"] = $this.Text } })
$CustomHeaderCheckbox.Add_CheckedChanged({ RestoreCustomHeader })
RestoreCustomHeader

# Restore VC Checkboxes
CheckVCOptions

# Show the dialog to the user.
$MainDialog.ShowDialog() | Out-Null

# Exit
Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
RemovePath -LiteralPath $Paths.Registry
Exit