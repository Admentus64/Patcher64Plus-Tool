function PerformUpdate() {
    
    $Files.json.repo = SetJSONFile ($Paths.Master + "\repo.json")
    if (IsSet $Settings.Core) {
        if ($Settings.Core.DisableUpdates -ne $True) { AutoUpdate }
        if ($Settings.Core.DisableAddons -ne $True) {
            foreach ($addon in $Files.json.repo.addons) {
                CheckAddon  -Title $addon.title
                UpdateAddon -Title $addon.title -Uri $addon.uri -Version $addon.version }
        }
    }
    else {
        AutoUpdate
        foreach ($addon in $Files.json.repo.addons) {
            CheckAddon  -Title $addon.title
            UpdateAddon -Title $addon.title -Uri $addon.uri -Version $addon.version
        }
    }

}



#==============================================================================================================================================================================================
function InvokeWebRequest([string]$Uri, [String]$OutFile) {
    
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Uri -OutFile $outFile
    $ProgressPreference = 'Continue'

}



#==============================================================================================================================================================================================
function ExpandArchive([string]$LiteralPath, [String]$DestinationPath) {
    
    $global:ProgressPreference = 'SilentlyContinue'
    Expand-Archive -LiteralPath $LiteralPath -DestinationPath $DestinationPath
    $global:ProgressPreference = 'Continue'

}



#==============================================================================================================================================================================================
function CheckUpdate() {
    
    if (TestFile $Patcher.VersionFile) {
        $Patcher.Version    = (Get-Content -LiteralPath $Patcher.VersionFile)[0]
        try { $Patcher.Date = (Get-Date -Format $Patcher.DateFormat -Date (Get-Content -LiteralPath $Patcher.VersionFile)[1]) }
        catch {
            $Patcher.Date = (Get-Date -Format $Patcher.DateFormat -Date "1970-01-01")
            WriteToConsole ("Could not read version date for current update for" + $Patcher.Title)
        }
        try   { [byte]$Patcher.Hotfix = (Get-Content -LiteralPath $Patcher.VersionFile)[2] }
        catch { [byte]$Patcher.Hotfix = 0 }
    }

}



#==============================================================================================================================================================================================
function AutoUpdate([switch]$Manual) {
    
    if ($Settings.Core.LocalTempFolder -eq $True)   { CreateSubPath $Paths.LocalTemp;   $file = $Paths.LocalTemp   + "\version.txt" }
    else                                            { CreateSubPath $Paths.AppDataTemp; $file = $Paths.AppDataTemp + "\version.txt" }

    $update = $False
    $oldContent = $newContent = $newVersion = $newDate = $newHotfix = $null

    if (TestFile $Patcher.VersionFile) {
        # Download version info
        try { InvokeWebRequest -Uri $Files.json.repo.version -OutFile $file }
        catch {
            WriteToConsole "Could not retrieve Patcher version info!"
            return
        }

        # Load content
        $oldContent = $newContent = $null
        try { [array]$oldContent = Get-Content -LiteralPath $Patcher.VersionFile }
        catch {
            RemovePath $path
            WriteToConsole ("Could not read current version info for " + $Title + "!")
            return
        }
        try { [array]$newContent = Get-Content -LiteralPath ($Paths.LocalTemp   + "\version.txt") }
        catch {
            RemovePath $path
            WriteToConsole ("Could not read latest version info for " + $Title + "!")
            return
        }
        
        # Parse content
        $Patcher.Version = $oldContent[0]
        $newVersion      = $newContent[0]
        try     { $Patcher.Date = Get-Date -Format $Patcher.DateFormat -Date $oldContent[1] }
        catch   { $Patcher.Date = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read current version date info for " + $Title + "!") }
        try     { $newDate      = Get-Date -Format $Patcher.DateFormat -Date $newContent[1] }
        catch   { $newDate      = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read latest version date info for " + $Title + "!")  }
        if ($oldContent.Count -gt 2) { try { [byte]$Patcher.Hotfix = $oldContent[2] } catch { [byte]$Patcher.Hotfix = 0 } } else { [byte]$Patcher.Hotfix = 0}
        if ($newContent.Count -gt 2) { try { [byte]$newHotfix      = $newContent[2] } catch { [byte]$newHotfix      = 0 } } else { [byte]$newHotifx      = 0}

        # Skip update
        if ($Settings.Core.SkipUpdate -eq $True -and !$Manual) {
            try {
                if ($Settings.Core.LastUpdateVersionCheck -le $newVersion -and $Settings.Core.LastUpdateDateCheck -le $newDate) { return }
                else {
                    $Settings.Core.SkipUpdate = $False
                    Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
                }
            }
            catch {
                WriteToConsole "Could not save preference to skip this update!"
                return
            }
        }

        # Compare content
        if     ($Patcher.Version -lt $newVersion)   { $update = $True }
        elseif ($Patcher.Date    -lt $newDate)      { $update = $True }
        elseif ($Patcher.Version -le $newVersion -and $Patcher.Date -le $newDate -and $Patcher.Hotfix -lt $newHotfix -and $newHotfix -ne 0) { $update = $True }
        $Settings.Core.LastUpdateVersionCheck = $newVersion
        $Settings.Core.LastUpdateDateCheck    = $newDate
    }
    else {
        $update = $True
        WriteToConsole "Could not find version info! Downloading latest update now!"
    }
    
    if ($update) {
        ShowUpdateDialog -Version $NewVersion -Date $NewDate -Hotfix $NewHotfix
        if ($Manual) { $MainDialog.Close() }
    }

}



#==============================================================================================================================================================================================
function ShowUpdateDialog([String]$Version, [String]$Date, [String]$Hotfix) {

    $UpdateDialog = New-Object System.Windows.Forms.Form
    $UpdateDialog.Size = DPISize (New-Object System.Drawing.Size(440, 200))
    $UpdateDialog.Text = $Patcher.Title
    $UpdateDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $UpdateDialog.StartPosition = "CenterScreen"
    $UpdateDialog.Icon = $Files.icon.main

    $text = "Would you like to update Patcher64+?`n" + "New Version: " + $version + " (" + $date + ")"
    if (IsSet $Hotfix) { $text += "`nHotfix: #" + $Hotfix }

    $label   = CreateLabel -x (DPISize 20)  -Y (DPISize 10) -Text $Text -Font $Fonts.Medium -AddTo $UpdateDialog
    $yesBtn  = CreateButton -X (DPISize 20)  -Y (DPISize 100)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $UpdateDialog -Text "Yes"
    $noBtn   = CreateButton -X (DPISize 160) -Y (DPISize 100)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $UpdateDialog -Text "No"
    $skipBtn = CreateButton -X (DPISize 300) -Y (DPISize 100)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $UpdateDialog -Text "Skip Version"
    
    $yesBtn.Add_Click(  { $UpdateDialog.Close(); RunUpdate } )
    $noBtn.Add_Click(   { $UpdateDialog.Close()            } )
    $skipBtn.Add_Click( {
        $UpdateDialog.Close()
        $Settings.Core.SkipUpdate = $True
        Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
    } )

    $UpdateDialog.ShowDialog() | Out-Null
    $UpdateDialog = $label = $yesBtn = $noBtn = $null

}



#==============================================================================================================================================================================================
function RunUpdate() {
    
    if ($Settings.Core.LocalTempFolder -eq $True)   { $path = $Paths.LocalTemp   }
    else                                            { $path = $Paths.AppDataTemp }
    CreateSubPath $Path
    $Path = $Path + "\updater"
    CreateSubPath $Path

    $zip = $path + "\master.zip"
    Get-ChildItem -Path $path -Directory | ForEach-Object { RemovePath ($path + "\" + $_) }
    RemoveFile $zip

    try { InvokeWebRequest -Uri $Files.json.repo.uri -OutFile $zip }
    catch {
        RemovePath $path
        WriteToConsole "Could not download new update!"
        return
    }

    if (!(TestFile $zip)) {
        RemovePath $path
        WriteToConsole "Could not extract new update!"
        return
    }

    ExpandArchive -LiteralPath $zip -DestinationPath $path

    RemovePath $Paths.Games
    RemovePath $Paths.Tools
    RemovePath $Paths.Main
    RemovePath $Paths.Scripts
    RemovePath ($Paths.Base + "\Info")

    Get-ChildItem -Path $path   -Directory | ForEach-Object { $folder = $path + "\" + $_ }
    Get-ChildItem -Path $folder -Directory | ForEach-Object { Copy-Item -LiteralPath ($folder + "\" + $_) -Destination $Paths.Base -Force -Recurse }
    Move-Item -LiteralPath ($folder + "\Patcher64+ Tool.ps1") -Destination ($Paths.Base + "\Patcher64+ Tool.ps1") -Force
    Move-Item -LiteralPath ($folder + "\Readme.txt")          -Destination ($Paths.Base + "\ReadMe.txt")          -Force
    Move-Item -LiteralPath ($folder + "\Files\version.txt")   -Destination ($Paths.Master + "\version.txt")       -Force

    RemovePath $path
    $global:FatalError = $True
    $global:Relaunch   = $True

}



#==============================================================================================================================================================================================
function CheckAddon([string]$Title) {

    $Addons[$Title] = @{}
    $Addons[$Title].isUpdated = $False
    if (!(TestFile ($Paths.Addons + "\" + $Title + "\lastUpdate.txt"))) { return }

    $addonPath = ($Paths.Addons + "\" + $Title)
    if ($Settings.Core.LocalTempFolder -eq $True)   { $path = $Paths.LocalTemp   }
    else                                            { $path = $Paths.AppDataTemp }

    # Load content
    try { [array]$content = Get-Content -LiteralPath ($addonPath + "\lastUpdate.txt") }
    catch {
        WriteToConsole ("Could not read current version info for " + $Title + "!")
        return
    }
        
    # Parse content
    try     { $Addons[$title].date = Get-Date -Format $Patcher.DateFormat -Date $content[0] }
    catch   { $Addons[$title].date = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read current version date info for " + $Title + "!") }
    if ($content.Count -gt 1) { try { [byte]$Addons[$title].hotfix = $content[1] } catch { [byte]$Addons[$title].hotfix = 0 } } else { [byte]$Addons[$title].hotfix = 0}

}



#==============================================================================================================================================================================================
function UpdateAddon([string]$Title, [string]$Uri, [string]$Version) {
    
    $update = $False
    $addonPath = ($Paths.Addons + "\" + $Title)
    if ($Settings.Core.LocalTempFolder -eq $True)   { $path = $Paths.LocalTemp   }
    else                                            { $path = $Paths.AppDataTemp }
    CreateSubPath $Path
    $Path = $Path + "\updater-" + $Title.ToLower()
    CreateSubPath $Path

    $content = $date = $hotfix = $null

    if (TestFile ($addonPath + "\lastUpdate.txt")) {
        # Download version info
        try {
            $file = $Path + "\lastUpdate.txt"
            InvokeWebRequest -Uri $Version -OutFile $file
        }
        catch {
            RemovePath $path
            WriteToConsole ("Could not retrieve last version info for " + $Title + "!")
            return
        }

        # Load content
        try { [array]$content = Get-Content -LiteralPath $file }
        catch {
            RemovePath $path
            WriteToConsole ("Could not read latest version info for " + $Title + "!")
            return
        }
        
        # Parse content
        try     { $date = Get-Date -Format $Patcher.DateFormat -Date $content[0] }
        catch   { $date = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read latest version date info for " + $Title + "!")  }
        if ($content.Count -gt 1) { try { [byte]$hotfix = $content[1] } catch { [byte]$hotfix = 0 } } else { [byte]$hotfix = 0}

        # Compare content
        if     ($Addons[$Title].date    -lt $date)                        { $update = $true }
        elseif ($Addons[$Title].hotfix  -lt $hotfix -and $hotfix -ne 0)   { $update = $true }
        else                                                        { RemovePath $path; return }
    }
    else {
        WriteToConsole ("Could not find last update for " + $Title + "! Downloading now!")
        $update = $true
    }

    if ($update) {
        $zip = $path + "\" + $Title.ToLower() + ".zip"
        Get-ChildItem -Path $path -Directory | ForEach-Object { RemovePath ($path + "\" + $_) }
        RemoveFile $zip

        try {
            InvokeWebRequest -Uri $Uri -OutFile $zip
            WriteToConsole ("Downloading latest update for " + $Title + "!")
        }
        catch {
            RemovePath $path
            WriteToConsole ("Could not download lastest version for " + $Title + "!")
            return
        }

        if (!(TestFile $zip)) {
            RemovePath $path
            WriteToConsole ("Could not extract new " + $Title + "!")
            return
        }

        ExpandArchive -LiteralPath $zip -DestinationPath $path -Force
        RemovePath $addonPath
        Get-ChildItem -Path $path -Directory | ForEach-Object { $folder = $path + "\" + $_ }
        Copy-Item -LiteralPath ($folder + "\Files") -Destination $Paths.Base -Force -Recurse
        RemovePath $path

        CheckAddon -Title $Title
        $Addons[$Title].isUpdated = $True
    }

}

(Get-Command -Module "Updater") | % { Export-ModuleMember $_ }