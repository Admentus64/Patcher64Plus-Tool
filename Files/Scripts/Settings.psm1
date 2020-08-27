function Get-IniContent ([String]$FilePath) {

    $ini = @{}
    switch -regex -file $FilePath {
        "^\[(.+)\]" # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        "^(;.*)$"
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value
        }
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini

}



#==============================================================================================================================================================================================
function Out-IniFile([hashtable]$InputObject, [String]$FilePath) {
    
    RemoveFile $FilePath
    $OutFile = New-Item -ItemType File -Path $Filepath
    foreach ($i in $InputObject.keys) {
        if (!($($InputObject[$i].GetType().Name) -eq "Hashtable")) { Add-Content -Path $outFile -Value "$i=$($InputObject[$i])" } # No Sections
        else {
            #Sections
            Add-Content -Path $outFile -Value "[$i]"
            foreach ($j in ($InputObject[$i].keys | Sort-Object)) {
                if ($j -match "^Comment[\d]+")   { Add-Content -Path $OutFile -Value "$($InputObject[$i][$j])" }
                else                             { Add-Content -Path $OutFile -Value "$j=$($InputObject[$i][$j])" }
            }
            Add-Content -Path $outFile -Value ""
        }
    }

}



#==============================================================================================================================================================================================
function GetSettings() {
    
    $File = $Paths.Base + "\Settings.ini"

    if (!(Test-Path -LiteralPath $File -PathType Leaf)) { New-Item -Path $File | Out-Null }
    $Lines = Get-Content -Path $File
    if ($Lines -notcontains "[Core]") { Add-Content -Path $File -Value "[Core]" | Out-Null }
    if ($Lines -notcontains "[Debug]") { Add-Content -Path $File -Value "[Debug]" | Out-Null }
    $global:Settings = Get-IniContent $File

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function Get-IniContent
Export-ModuleMember -Function Out-IniFile
Export-ModuleMember -Function GetSettings