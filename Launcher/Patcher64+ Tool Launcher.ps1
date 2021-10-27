#==============================================================================================================================================================================================
# Patcher64+ Tool Launcher v1.0
# By: Bighead (adjusted by Admentus)
#==============================================================================================================================================================================================
$global:CommandType = $MyInvocation.MyCommand.CommandType.ToString()
$global:Definition  = $MyInvocation.MyCommand.Definition.ToString()
#==============================================================================================================================================================================================
function GetScriptName()
{
  # This is the command that should have been stored.
  if ($CommandType -eq "ExternalScript")
  {
    # Split the path on every "\" and grab the last one.
    $SplitDef  = $Definition.Split('\')
    return $SplitDef[$SplitDef.Count-1]
  }
  # Split the path on every "\" and grab the last one.
  $SplitDef  = ([Environment]::GetCommandLineArgs()[0]).ToString().Split('\')
  return $SplitDef[$SplitDef.Count-1].Substring(0, $SplitDef[$SplitDef.Count-1].Length - 4) + '.exe'
}
#==============================================================================================================================================================================================
function GetScriptPath()
{
  # This is the command that should have been stored.
  if ($CommandType -eq "ExternalScript")
  {
    # Split the path on every "\" and grab the last one.
    $SplitDef  = $Definition.Split('\')
    $InputFile = $SplitDef[$SplitDef.Count-1]

    # If it was, the definition will hold the full path to the script.
    return $Definition.Replace(('\' + $InputFile),'')
  }
  # Split the path on every "\" and grab the last one.
  $FullPath  = ([Environment]::GetCommandLineArgs()[0]).ToString()
  $SplitDef  = $FullPath.Split('\')
  $InputFile = $SplitDef[$SplitDef.Count-1].Substring(0, $SplitDef[$SplitDef.Count-1].Length - 4) + '.exe'

  # If running via an executable, the command will be different so get the path through an argument.
  if ($ScriptPath) { $ScriptPath = $FullPath.Replace(('\' + $InputFile),'') } else { $ScriptPath = "." }

  # Return whatever we got in the above.
  return $ScriptPath
}
#==============================================================================================================================================================================================
$global:ScriptName = GetScriptName
$global:BaseFolder = GetScriptPath
$global:EntirePath = $BaseFolder + '\' + $ScriptName
#==============================================================================================================================================================================================
foreach ($File in [System.IO.Directory]::EnumerateFiles($BaseFolder,'*.ps1','TopDirectoryOnly'))
{
  # Get the file as an item to reference properties of it.
  $FileItem = Get-Item -LiteralPath $File

  # CTT-PS has the name of the script on line 2.
  if ($FileItem.Name -like 'Patcher64+ Tool*')
  {
    # Set the full path to the script.
    $ScriptPath = $BaseFolder + '\' + $FileItem.Name

    # PowerShell is picky about paths, so perform some manipulation to make sure it gets the corrent path.
    $Arguments = "-file `"$ScriptPath`""

    # Start the script.
    Start-Process PowerShell -ArgumentList $Arguments

    # Exit this loop in case there is multiple scripts.
    break
  }
}
#==============================================================================================================================================================================================