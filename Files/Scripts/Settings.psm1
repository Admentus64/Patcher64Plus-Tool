function GetIniContent ([string]$FilePath) {
    
    $ini = @{}

    $file = Get-Item -LiteralPath $FilePath

    try {
        switch -Regex -File $file {

            "^\[(.+)\]" { # Section
                $section = $Matches[1]
                $ini[$section] = @{}
                $CommentCount = 0
            }

            "^(;.*)$" {
                $value = $Matches[1]
                $CommentCount = $CommentCount + 1
                $name = "Comment" + $CommentCount

                if     ($value -eq "False")   { $value = $False -as [boolean] }
                elseif ($value -eq "True")    { $value = $True  -as [boolean] }

                $ini[$section][$name] = $value
            }

            "(.+?)\s*=(.*)" { # Key
                $name,$value = $Matches[1..2]

                if     ($value -eq "False")   { $value = $False -as [boolean] }
                elseif ($value -eq "True")    { $value = $True  -as [boolean] }

                $ini[$section][$name] = $value
            }

        }

        return $ini
    }
    catch { CreateErrorDialog -Error "Forbidden Path" }

}



#==============================================================================================================================================================================================
function OutIniFile([hashtable]$InputObject, [string]$FilePath) {
    
    if (!(TestFile -Path ($Paths.Settings) -Container)) { New-Item -Path $Paths.Master -Name "Settings" -ItemType Directory }
  # RemoveFile $FilePath
    $OutFile = New-Item -ItemType File -Path $Filepath -Force
    foreach ($i in $InputObject.keys) {
        if (!($($InputObject[$i].GetType().Name) -eq "Hashtable")) { Add-Content -Path $outFile -Value "$i=$($InputObject[$i])" -Encoding UTF8 } # No Sections
        else {
            #Sections
            Add-Content -Path $outFile -Value "[$i]" -Encoding UTF8
            foreach ($j in ($InputObject[$i].keys | Sort-Object)) {
                
                if ($j -match "^Comment[\d]+")   { Add-Content -Path $OutFile -Value "$($InputObject[$i][$j])"    -Encoding UTF8 }
                else                             { Add-Content -Path $OutFile -Value "$j=$($InputObject[$i][$j])" -Encoding UTF8 }
            }
            Add-Content -Path $outFile -Value "" -Encoding UTF8
        }
    }

}



#==============================================================================================================================================================================================
function GetSettings([string]$File) {
    
    if (TestFile $File)   { return GetIniContent $File }
    else                  { return @{}                  }

}



#==============================================================================================================================================================================================
function GetGameTypePreset() {
    
    for ($i=0; $i -lt $GeneralSettings.Presets.length; $i++) {
        if ($GeneralSettings.Presets[$i].checked) {
            if (IsSet $GamePatch.settings)   { return $GamePatch.settings + " - " + ($i+1) }
            if (IsSet $GamePatch.script)     { return $GamePatch.script   + " - " + ($i+1) }
            return $GameType.mode + " - " + ($i+1)
        }
    }
    return $null

}



#==============================================================================================================================================================================================
function GetMember {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [PSCustomObject]$obj
    )
    $obj | Get-Member -MemberType NoteProperty | ForEach-Object {
        $key = $_.Name
        [PSCustomObject]@{Key = $key; Value = $obj."$key"}
    }

}



#==============================================================================================================================================================================================
function GetGameSettingsFile() { return $Paths.Settings + "\" + (GetGameTypePreset) + ".ini" }



#==============================================================================================================================================================================================

Export-ModuleMember -Function GetIniContent
Export-ModuleMember -Function OutIniFile
Export-ModuleMember -Function GetSettings
Export-ModuleMember -Function GetGameTypePreset
Export-ModuleMember -Function CreateGameTypePreset
Export-ModuleMember -Function GetGameSettingsFile
Export-ModuleMember -Function GetMember