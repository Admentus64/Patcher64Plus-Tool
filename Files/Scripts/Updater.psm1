function PerformUpdate() {
    
    $Files.json.repo = SetJSONFile ($Paths.Master + "\repo.json")
    if (IsSet $Settings.Core) {
        if ($Settings.Core.DisableUpdates -ne $True) { AutoUpdate }
        if ($Settings.Core.DisableAddons -ne $True) {
            foreach ($addon in $Files.json.repo.addons) {
                CheckAddon  -Title $addon.title
                UpdateAddon -Title $addon.title -Uri $addon.uri -Version $addon.version -VersionFallback $addon.versionFallback
            }
        }
    }
    else {
        AutoUpdate
        foreach ($addon in $Files.json.repo.addons) {
            CheckAddon  -Title $addon.title
            UpdateAddon -Title $addon.title -Uri $addon.uri -Version $addon.version -VersionFallback $addon.versionFallback
        }
    }

}



#==============================================================================================================================================================================================
function InvokeWebRequest([string]$Uri, [String]$OutFile) {
    
    $script = { Param([string]$Uri, [string]$OutFile)
        $ProgressPreference                         = 'SilentlyContinue'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $OutFile
        $ProgressPreference = 'Continue'
    }
    Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Uri, $OutFile)
    StartJobLoop -Name "Script"
    $ProgressPreference = 'Continue'

}



#==============================================================================================================================================================================================
function ReadWebRequest([string]$Uri) {
    
    $script = { Param([string]$Uri)
        $ProgressPreference                         = 'SilentlyContinue'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Write-Output (Invoke-WebRequest -Uri $Uri)
        $ProgressPreference                         = 'Continue'
    }
              Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Uri)
    $result = StartJobLoop -Name "Script" -Output
    return $result

}



#==============================================================================================================================================================================================
function ExpandArchive([string]$LiteralPath, [String]$DestinationPath) {
    
    $script = { Param([string]$LiteralPath, [string]$DestinationPath)
        $global:ProgressPreference = 'SilentlyContinue'
        Expand-Archive -LiteralPath $LiteralPath -DestinationPath $DestinationPath | Out-Null
        $ProgressPreference = 'Continue'
    }
    Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($LiteralPath, $DestinationPath)
    StartJobLoop -Name "Script"
    
}



#==============================================================================================================================================================================================
function CheckUpdate() {
    
    if (TestFile $Patcher.VersionFile) {
        $Patcher.Version    = (Get-Content -LiteralPath $Patcher.VersionFile)[0]
        try { $Patcher.Date = (Get-Date -Format $Patcher.DateFormat -Date (Get-Content -LiteralPath $Patcher.VersionFile)[1]) }
        catch {
            $Patcher.Date = (Get-Date -Format $Patcher.DateFormat -Date "1970-01-01")
            WriteToConsole ("Could not read version date for current update for" + $Patcher.Title) -Error
        }
        try   { [byte]$Patcher.Hotfix = (Get-Content -LiteralPath $Patcher.VersionFile)[2] }
        catch { [byte]$Patcher.Hotfix = 0 }
    }

}



#==============================================================================================================================================================================================
function AutoUpdate([switch]$Manual) {

    $update     = $error = $False
    $oldContent = $newContent = $newVersion = $newDate = $newHotfix = $null

    if (TestFile $Patcher.VersionFile) {
        # Download version info
        try {
            $response   = ReadWebRequest $Files.json.repo.version
          # $newContent = $response.AllElements | Where { $_.class -eq "blob-code blob-code-inner js-file-line" }
            $newcontent = $response.AllElements | Where { $_.type -eq "application/json" }
            
            $newContent = [string]$newContent[1]
            $start      = ($newContent | Select-String "blob").Matches.Index
            $newContent = $newContent.substring($start, $newContent.substring($start).indexOf("]"))
            $newContent = $newContent.substring($newContent.indexOf("[")+1)
            $newContent = $newContent.replace('"', '')
            $newContent = $newContent.split(",")
        }
        catch {
            WriteToConsole "Could not retrieve Patcher version info! Trying fallback URL..." -Error
            $error = $True
        }

        # Download version info using fallback URL
        if ($error) {
            $error = $False
            try {
                if ($Settings.Core.LocalTempFolder -ne $False)   { CreateSubPath $Paths.LocalTemp;   $file = $Paths.LocalTemp   + "\version.txt" }
                else                                             { CreateSubPath $Paths.AppDataTemp; $file = $Paths.AppDataTemp + "\version.txt" }
                InvokeWebRequest -Uri $Files.json.repo.versionFallback -OutFile $file
                [array]$newcontent = Get-Content -LiteralPath $file
                RemoveFile $file
            }
            catch {
                WriteToConsole "Could not retrieve Patcher version info using fallback URL!" -Error
                RemoveFile $file
                $error = $True
            }
        }

        if ($error) { return }

        # Load content
        try { [array]$oldContent = Get-Content -LiteralPath $Patcher.VersionFile }
        catch {
            WriteToConsole ("Could not read current version info for " + $Patcher.Title + "!") -Error
            return
        }
        if ($newContent -eq $null) { WriteToConsole ("Could not read latest version info for " + $Patcher.Title + "!") -Error }
        
        # Parse content
        $Patcher.Version = $oldContent[0]
        $newVersion      = $newContent[0]
        try     { $Patcher.Date = Get-Date -Format $Patcher.DateFormat -Date $oldContent[1] }
        catch   { $Patcher.Date = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read current version date info for " + $Title + "!") -Error }
        try     { $newDate      = Get-Date -Format $Patcher.DateFormat -Date $newContent[1] }
        catch   { $newDate      = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read latest version date info for "  + $Title + "!") -Error }
        if ($oldContent.Count -gt 2)   { try { [byte]$Patcher.Hotfix = $oldContent[2] } catch { [byte]$Patcher.Hotfix = 0 } } else { [byte]$Patcher.Hotfix = 0}
        if ($newContent.Count -gt 2)   { try { [byte]$newHotfix      = $newContent[2] } catch { [byte]$newHotfix      = 0 } } else { [byte]$newHotfix      = 0}

        # Skip update
        if ($Settings.Core.SkipUpdate -eq $True -and !$Manual) {
            try {
                if ($Settings.Core.LastUpdateVersionCheck -eq $newVersion -and $Settings.Core.LastUpdateHotfixCheck -eq $newHotfix -and $Settings.Core.LastUpdateDateCheck -eq $newDate) { return }
                else {
                    $Settings.Core.SkipUpdate = $False
                    Out-IniFile -FilePath $Files.settings -InputObject $Settings
                }
            }
            catch {
                WriteToConsole "Could not save preference to skip this update!" -Error
                return
            }
        }

        # Compare content
        [byte[]]$oldTier = $Patcher.Version.split('.')
        [byte[]]$newTier = $newVersion.split('.')

        if ($newTier.count -gt 0 -and $oldTier.count -gt 0) {
            if ($newTier[0] -gt $oldTier[0])                                                                    { $update = $True }
        }
        if ($newTier.count -gt 1 -and $oldTier.count -gt 1) {
            if ($newTier[0] -ge $oldTier[0] -and $newTier[1] -gt $oldTier[1] )                                  { $update = $True }
        }
        if ($newTier.count -gt 2 -and $oldTier.count -gt 2) {
            if ($newTier[0] -ge $oldTier[0] -and $newTier[1] -ge $oldTier[1] -and $newTier[2] -gt $oldTier[2])  { $update = $True }
        }
        
        if     ($Patcher.Date -lt $newDate)                                                                                                   { $update = $True }
        elseif ($Patcher.Date -le $newDate -and $Patcher.Hotfix -lt $newHotfix -and $newHotfix -ne 0)                                         { $update = $True }
        elseif ($Patcher.Date -le $newDate -and $Patcher.Hotifx -le $newHotfix -and $newHotfix -ne 0 -and $Patcher.Version -ne $newVersion)   { $update = $True }
        elseif ($Patcher.Date -le $newDate -and                                     $newHotfix -eq 0 -and $Patcher.Version -ne $newVersion)   { $update = $True }
        $Settings.Core.LastUpdateVersionCheck = $newVersion
        $Settings.Core.LastUpdateHotfixCheck  = $newHotfix
        $Settings.Core.LastUpdateDateCheck    = $newDate
    }
    else {
        $update = $True
        WriteToConsole "Could not find version info! Downloading latest update now!"

        try {
            $response   = ReadWebRequest $Files.json.repo.version
            $newContent = $response.AllElements | Where {$_.class -eq "blob-code blob-code-inner js-file-line"}
        }
        catch { WriteToConsole "Could not retrieve Patcher version info!" -Error }
        
        if ($newContent -ne $null) {
            $newVersion = $newContent[0]
            
            try { $newDate = Get-Date -Format $Patcher.DateFormat -Date $newContent[1] }
            catch {
                $newDate = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"
                WriteToConsole ("Could not read latest version date info for " + $Title + "!") -Error
            }
            
            if ($newContent.Count -gt 2) {
                try { [byte]$newHotfix = $newContent[2] }
                catch { [byte]$newHotfix = 0 }
            }
            else { [byte]$newHotfix = 0}
        }

    }
    
    if ($update) {
        ShowUpdateDialog -Version $newVersion -Date $newDate -Hotfix $newHotfix
        if ($Manual) { $MainDialog.Close() }
    }

}



#==============================================================================================================================================================================================
function ShowUpdateDialog([String]$Version, [String]$Date, [String]$Hotfix) {
    
    $global:Updater                 = @{}
    $Updater.Dialog                 = New-Object System.Windows.Forms.Form
    $Updater.Dialog.Size            = DPISize (New-Object System.Drawing.Size(440, 200))
    $Updater.Dialog.Text            = $Patcher.Title
    $Updater.Dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $Updater.Dialog.StartPosition   = "CenterScreen"
    $Updater.Dialog.Icon            = $Files.icon.main

    $text = "Would you like to update Patcher64+?`n" + "New Version: " + $version + " (" + $date + ")"
    if (IsSet $Hotfix) { $text += "`nHotfix: #" + $Hotfix }

    $label           = CreateLabel  -x (DPISize 20)  -Y (DPISize 10)   -Text $Text          -Font $Fonts.Medium  -AddTo $Updater.Dialog
    $Updater.yesBtn  = CreateButton -X (DPISize 20)  -Y (DPISize 100)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $Updater.Dialog -Text "Yes"
    $Updater.noBtn   = CreateButton -X (DPISize 160) -Y (DPISize 100)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $Updater.Dialog -Text "No"
    $Updater.skipBtn = CreateButton -X (DPISize 300) -Y (DPISize 100)  -Width (DPISize 100) -Height (DPISize 50) -AddTo $Updater.Dialog -Text "Skip Version"
    
    $Updater.yesBtn.Add_Click(  {
        $Updater.Dialog.Close();
        EnableGUI $False; $Updater.yesBtn.Enabled = $Updater.noBtn.Enabled = $Updater.skipBtn.Enabled = $False
        RunUpdate
        EnableGUI $True
    } )

    $Updater.noBtn.Add_Click( {
        $Updater.Dialog.Close()
    } )

    $Updater.skipBtn.Add_Click( {
        $Updater.Dialog.Close()
        $Settings.Core.SkipUpdate = $True
        Out-IniFile -FilePath $Files.settings -InputObject $Settings
    } )

    $Updater.Dialog.ShowDialog()
    $global:Updater = $null

}



#==============================================================================================================================================================================================
function RunUpdate() {
    
    if ($Settings.Core.LocalTempFolder -eq $True)   { $path = $Paths.LocalTemp   }
    else                                            { $path = $Paths.AppDataTemp }
    CreateSubPath $Path
    $path = $path + "\updater"
    CreateSubPath $Path

    $zip = $path + "\master.zip"
    Get-ChildItem -Path $path -Directory | ForEach-Object { RemovePath ($path + "\" + $_) }
    RemoveFile $zip

    try { InvokeWebRequest -Uri $Files.json.repo.uri -OutFile $zip }
    catch {
        RemovePath $path
        WriteToConsole "Could not download new update!" -Error
        return
    }

    if (!(TestFile $zip)) {
        RemovePath $path
        WriteToConsole "Could not extract new update!" -Error
        return
    }

    ExpandArchive -LiteralPath $zip -DestinationPath $path

    if (TestFile -Path ($Paths.Games + "\Ocarina of Time\Editor") -Container)   { Copy-Item -LiteralPath ($Paths.Games + "\Ocarina of Time\Editor") -Destination ($Paths.Base + "\Ocarina of Time\Editor") -Force -Recurse }
    if (TestFile -Path ($Paths.Games + "\Majora's Mask\Editor")   -Container)   { Copy-Item -LiteralPath ($Paths.Games + "\Majora's Mask\Editor")   -Destination ($Paths.Base + "\Majora's Mask\Editor")   -Force -Recurse }

    RemovePath $Paths.Games
    RemovePath $Paths.Tools
    RemovePath $Paths.Main
    RemovePath $Paths.Scripts
    RemovePath ($Paths.Base + "\Info")

    $folder = $path + "\Patcher64Plus-Tool-master"
    Get-ChildItem -Path $folder -Directory | ForEach-Object {
        if ($_.name -ne ".github") { Copy-Item -LiteralPath ($folder + "\" + $_) -Destination $Paths.Base -Force -Recurse }
    }
    Move-Item -LiteralPath ($folder + "\Patcher64+ Tool.ps1") -Destination ($Paths.Base   + "\Patcher64+ Tool.ps1") -Force
    Move-Item -LiteralPath ($folder + "\Readme.txt")          -Destination ($Paths.Base   + "\ReadMe.txt")          -Force
    Move-Item -LiteralPath ($folder + "\Files\version.txt")   -Destination ($Paths.Master + "\version.txt")         -Force

    if (TestFile -Path ($Paths.Base + "\Ocarina of Time") -Container)   { Move-Item -LiteralPath ($Paths.Base + "\Ocarina of Time") -Destination ($Paths.Games + "\Ocarina of Time") -Force }
    if (TestFile -Path ($Paths.Base + "\Majora's Mask")   -Container)   { Move-Item -LiteralPath ($Paths.Base + "\Majora's Mask")   -Destination ($Paths.Games + "\Majora's Mask")   -Force }

    RemovePath $folder
    $global:FatalError = $global:Relaunch = $True

}



#==============================================================================================================================================================================================
function CheckAddon([string]$Title) {

    $Addons[$Title]           = @{}
    $Addons[$Title].isUpdated = $False
    $file                     = $Paths.Addons + "\" + $Title + "\lastUpdate.txt"

    # Load content
    if (!(TestFile $file)) { return }
    try { [array]$content = Get-Content -LiteralPath $file }
    catch {
        WriteToConsole ("Could not read current version info for " + $Title + "!") -Error
        return
    }
        
    # Parse content
    try     { $Addons[$title].date = Get-Date -Format $Patcher.DateFormat -Date $content[0] }
    catch   { $Addons[$title].date = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read current version date info for " + $Title + "!") -Error }
    
    if ($content.Count -gt 1) {
        try   { [byte]$Addons[$title].hotfix = $content[1] }
        catch { [byte]$Addons[$title].hotfix = 0           }
    }
    else { [byte]$Addons[$title].hotfix = 0}

}



#==============================================================================================================================================================================================
function UpdateAddon([string]$Title, [string]$Uri, [string]$Version, [string]$VersionFallback) {
    
    $update    = $error = $False
    $addonPath = $Paths.Addons + "\" + $Title
    $content   = $date = $hotfix = $null

    if ($Settings.Core.LocalTempFolder -ne $False)   { $path = $Paths.LocalTemp   }
    else                                             { $path = $Paths.AppDataTemp }
    CreateSubPath $path
    $path = $path + "\updater-" + $Title.ToLower()
    CreateSubPath $path

    if (TestFile ($addonPath + "\lastUpdate.txt")) {
        # Download version info
        try {
            $response = ReadWebRequest $Version
          # $content  = $response.AllElements | Where {$_.class -eq "blob-code blob-code-inner js-file-line"}
            $content  = $response.AllElements | Where {$_.type -eq "application/json"}

            $content = [string]$content[1]
            $start   = ($content | Select-String "blob").Matches.Index
            $content = $content.substring($start, $content.substring($start).indexOf("]"))
            $content = $content.substring($content.indexOf("[")+1)
            $content = $content.replace('"', '')
            $content = $content.split(",")
        }
        catch {
            WriteToConsole ("Could not retrieve last version info for " + $Title + "! Trying fallback URL...") -Error
            $error = $True
        }

        # Download version info using fallback URL
        if ($error) {
            $error = $False
            try {
                InvokeWebRequest -Uri $VersionFallback -OutFile     ($Path + "\lastUpdate.txt")
                [array]$content = Get-Content          -LiteralPath ($Path + "\lastUpdate.txt")
                RemoveFile ($Path + "\lastUpdate.txt")
            }
            catch {
                WriteToConsole ("Could not retrieve last version info for " + $Title + " using the fallback URL!") -Error
                RemoveFile ($Path + "\lastUpdate.txt")
                $error = $True
            }
        }

        if ($error) { return }

        # Load content
        if ($content -eq $null) {
            RemovePath $path
            WriteToConsole ("Could not read latest version info for " + $Title + "!") -Error
            return
        }
        
        # Parse content
        try     { $date = Get-Date -Format $Patcher.DateFormat -Date $content[0] }
        catch   { $date = Get-Date -Format $Patcher.DateFormat -Date "1970-01-01"; WriteToConsole ("Could not read latest version date info for " + $Title + "!") -Error }
        
        if ($content.Count -gt 1) {
            try   { [byte]$hotfix = $content[1] }
            catch { [byte]$hotfix = 0 }
        }
        else { [byte]$hotfix = 0}

        # Compare content
        if     ($Addons[$Title].date    -lt $date)                        { $update = $true }
        elseif ($Addons[$Title].hotfix  -lt $hotfix -and $hotfix -ne 0)   { $update = $true }
        else                                                              { RemovePath $path; return }
    }
    else {
        WriteToConsole ("Could not find lastest update for " + $Title + "! Downloading now!")
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
            WriteToConsole ("Could not download lastest version for " + $Title + "!") -Error
            return
        }

        if (!(TestFile $zip)) {
            RemovePath $path
            WriteToConsole ("Could not extract new " + $Title + "!") -Error
            return
        }

        ExpandArchive -LiteralPath $zip -DestinationPath $path -Force
        RemovePath $addonPath
        Copy-Item -LiteralPath ($path + "\Patcher64Plus-Tool-" + $Title + "-main\Files") -Destination $Paths.Base -Force -Recurse
        RemovePath $path
        CheckAddon -Title $Title
        $Addons[$Title].isUpdated = $True
    }

}

(Get-Command -Module "Updater") | % { Export-ModuleMember $_ }