function ChangeBytes([string]$File, [string]$Offset, [object]$Match=$null, [object]$Values, [uint16]$Interval=1, [switch]$Add, [switch]$Subtract, [switch]$IsDec, [switch]$Overflow) {
    
    if     ($Match  -is [System.String] -and $Match  -Like "* *")   { $Match  = $Match  -split ' '           }
    elseif ($Match  -is [System.String])                            { $Match  = $Match  -split '(..)' -ne '' }
    if     ($Values -is [System.String] -and $Values -Like "* *")   { $Values = $Values -split ' '           }
    elseif ($Values -is [System.String])                            { $Values = $Values -split '(..)' -ne '' }

    if (IsSet $File)                   { $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) }
    if ($Interval -lt 1)               { $Interval = 1 }

    # Offset
    try { [uint32]$Offset = GetDecimal $Offset }
    catch {
        WriteToConsole "Offset is negative, too large or not an integer!"
        $global:WarningError = $True
        return $False
    }
    if ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        $global:WarningError = $True
        return $False
    }

    # Match
    if ($Match -ne $null) {
        foreach ($i in 0..($Match.Length-1)) {
            try { [byte]$value  = GetDecimal $Match[$i] }
            catch {
                WriteToConsole "Match value is negative!"
                return $False
            }
            if ($ByteArrayGame[$Offset + $i] -ne $value) { return $True }
        }
    }

    # Convert to Byte if needed
    if ($IsDec) {
        $arr = @()
        foreach ($i in $Values) { $arr += Get8Bit $i }
        WriteToConsole ( (Get32Bit $Offset) + " -> Change values: " + $arr)
        $arr = $null
    }
    else { WriteToConsole ( (Get32Bit $Offset) + " -> Change values: " + $Values) }

    # Patch
    foreach ($i in 0..($Values.Length-1)) {
        if ($IsDec) {
            if     ($Values[$i] -lt 0   -and $Overflow)   { $Values[$i] = $Values[$i] + 255 }
            elseif ($Values[$i] -gt 255 -and $Overflow)   { $Values[$i] = $Values[$i] - 255 }
            [byte]$value = $Values[$i]
        }
        else {
            try { [byte]$value = GetDecimal $Values[$i] }
            catch {
                WriteToConsole "Value is negative!"
                return $False
            }
        }

        if     ($Add)        { $ByteArrayGame[$Offset + ($i * $Interval)] += $value }
        elseif ($Subtract)   { $ByteArrayGame[$Offset + ($i * $Interval)] -= $value }
        else                 { $ByteArrayGame[$Offset + ($i * $Interval)]  = $value }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function MultiplyBytes([string]$File, [string]$Offset, [object]$Match=$null, [float]$Factor) {
    
    if ($Match  -is [System.String])   { $Match  = $Match  -split ' ' }
    if (IsSet $File)                   { $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) }

    # Offset
    try { [uint32]$Offset = GetDecimal $Offset }
    catch {
        WriteToConsole "Offset is negative, too large or not an integer!"
        $global:WarningError = $True
        return $False
    }
    if ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        $global:WarningError = $True
        return $False
    }

    # Match
    if ($Match -ne $null) {
        foreach ($i in 0..($Match.Length-1)) {
            try { [byte]$value  = GetDecimal $Match[$i] }
            catch {
                WriteToConsole "Match value is negative!"
                return $False
            }
            if ($ByteArrayGame[$Offset + $i] -ne $value) { return $True }
        }
    }

    # Patch
    $ByteArrayGame[$Offset] *= $Factor
    WriteToConsole ( (Get32Bit $Offset) + " -> Multiplied value " + (Get8Bit $ByteArrayGame[$Offset]) +" by: " + $Factor)

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function CopyBytes([string]$File, [string]$Start, [string]$Length, [string]$Offset) {
    
    if (IsSet $File) { $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) }

    # Offset
    try {
        [uint32]$Start  = GetDecimal $Start
        [uint32]$Length = GetDecimal $Length
        [uint32]$Offset = GetDecimal $Offset
    }
    catch {
        WriteToConsole "Offsets are negative, too large or not an integer!"
        $global:WarningError = $True
        return $False
    }
    if ($Start -gt $ByteArrayGame.Length -or $Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offsets are too large for file!"
        $global:WarningError = $True
        return $False
    }

    # Patch
    WriteToConsole ( (Get32Bit $Offset) + " -> Copying values: from " + (Get32Bit $Start))
    foreach ($i in 0..($Length-1)) {
        $ByteArrayGame[$Offset + $i]  = $ByteArrayGame[$Start + $i]
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function PatchBytes([string]$File, [string]$Offset, [string]$Length, [string]$Patch, [switch]$Texture, [switch]$Shared, [switch]$Models, [switch]$Extracted, [switch]$Music, [switch]$Pad) {
    
    # Binary Patch File Parameter Check
    if (!(IsSet -Elem $Patch) ) {
        WriteToConsole "No binary patch file is provided"
        $global:WarningError = $True
        return
    }

    # Binary Patch File Path
    if     ($Texture)     { $Patch = $GameFiles.textures  + "\" + $Patch }
    elseif ($Models)      { $Patch = $GameFiles.models    + "\" + $Patch }
    elseif ($Extracted)   { $Patch = $GameFiles.extracted + "\" + $Patch }
    elseif ($Music)       { $Patch = $Paths.Music         + "\" + $Patch }
    elseif ($Shared)      { $Patch = $Paths.Shared        + "\" + $Patch }
    else                  { $Patch = $GameFiles.binaries  + "\" + $Patch }

    # Binary Patch File Exists
    if (!(TestFile $Patch)) {
        WriteToConsole ("Missing binary patch file: " + $Patch)
        $global:WarningError = $True
        return
    }

    # Read File and Patch File
    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    $PatchByteArray = [IO.File]::ReadAllBytes($Patch)

    # Offset
    try { [uint32]$Offset = GetDecimal $Offset }
    catch {
        WriteToConsole "Offset is negative, too large or not an integer!"
        $global:WarningError = $True
        return
    }
    if ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        $global:WarningError = $True
        return
    }

    # Info
    WriteToConsole ( (Get32Bit $Offset) + " -> Patch file from: " + $Patch)

    # Patch
    if (IsSet $Length) {
        [uint32]$Length = GetDecimal $Length
        foreach ($i in 0..($Length-1)) {
            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
            elseif ($Pad)                        { $ByteArrayGame[$Offset + $i] = 255 }
            else                                 { $ByteArrayGame[$Offset + $i] = 0 }
        }
    }
    else {
        foreach ($i in 0..($PatchByteArray.Length-1)) { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
    }

    # Write to File
    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }

}



#==============================================================================================================================================================================================
function ExportBytes([string]$File, [string]$Offset, [string]$End, [string]$Length, [string]$Output, [switch]$Force) {
    
    if ( (TestFile $Output) -and ($Settings.Debug.ForceExtract -eq $False) -and !$Force) { return }

    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    [uint32]$Offset = GetDecimal $Offset
    WriteToConsole ("Write file to: " + $Output)

    if ($Offset -lt 0) {
        WriteToConsole "Offset is negative!"
        $global:WarningError = $True
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        $global:WarningError = $True
        return
    }

    RemoveFile $Output
    $Path = $Output.substring(0, $Output.LastIndexOf('\'))
    $Folder = $Path.substring($Path.LastIndexOf('\') + 1)
    $Path = $Path.substring(0, $Path.LastIndexOf('\') + 1)
    if (!(TestFile -Path ($Path + $Folder) -Container)) { New-Item -Path $Path -Name $Folder -ItemType Directory | Out-Null }

    if (IsSet $End) {
        [uint32]$End = GetDecimal $End
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$Offset..($End - 1)])
    }
    elseif (IsSet $Length) {
        [uint32]$Length = GetDecimal $Length
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$Offset..($Offset + $Length - 1)])
    }

}



#==============================================================================================================================================================================================
function SearchBytes([string]$File, [string]$Start="0", [string]$End, [object]$Values, [switch]$Suppress) {
    
    if ($values -is [System.String]) { $values = $values -split ' ' }

    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }

    [uint32]$Start = GetDecimal $Start
    if (IsSet $End)   { [uint32]$End = GetDecimal $End }
    else              { [uint32]$End = $ByteArrayGame.Length }

    if ($Start -lt 0 -or $End -lt 0) {
        WriteToConsole "Start or end offset is negative!"
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $ByteArrayGame.Length -or $End -gt $ByteArrayGame.Length) {
        WriteToConsole "Start or end offset is too large for file!"
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $End) {
        Write-Host "Start offset can not be greater than end offset"
        $global:WarningError = $True
        return
    }

    foreach ($i in $Start..($End-1)) {
        $Search = $True
        foreach ($j in 0..($Values.Length-1)) {
            if ($Values[$j] -ne "") {
                if ($ByteArrayGame[$i + $j] -ne (GetDecimal $Values[$j]) -and $Values[$j] -ne "xx") {
                    $Search = $False
                    break
                }
            }
        }
        if ($Search -eq $True) {
            if (!$Suppress) { WriteToConsole ("Found values at: " + (Get32Bit $i)) }
            return Get32Bit $i
        }
    }

    if (!$Suppress) { WriteToConsole "Did not find searched values" }
    return -1;

}



#==============================================================================================================================================================================================
function ExportAndPatch([string]$Path, [string]$Offset, [string]$Length, [string]$NewLength, [string]$TableOffset, [object]$Values) {
    
    $File = $GameFiles.extracted + "\" + $Path + ".bin"
    if ( !(TestFile $File) -or ($Settings.Debug.ForceExtract -eq $True) ) {
        ExportBytes -Offset $Offset -Length $Length -Output $File
        ApplyPatch -File $File -Patch (CheckPatchExtension -File ($GameFiles.export + "\" + $Path)) -FullPath
    }

    if (!(IsSet $NewLength))      { $NewLength = $Length }
    if ($NewLength -lt $Length)   { PatchBytes -Offset $Offset -Extracted -Patch ($Path + ".bin") -Length $Length }
    else                          { PatchBytes -Offset $Offset -Extracted -Patch ($Path + ".bin") -Length $NewLength }

    if ( (IsSet $TableOffset) -and (IsSet $Values) ) {
        ChangeBytes -Offset $TableOffset -Values $Values
    }

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([string]$Hex) {
    
    try     { return [uint32]("0x" + $Hex) }
    catch   { return -1 }

}



#==================================================================================================================================================================================================================================================================
function GetChar([string]$Hex) {

    try     { return [char](GetDecimal $Hex) }
    catch   { return -1 }

}



#==================================================================================================================================================================================================================================================================
function GetCharString([object]$Hex) {
    
    if     ($Hex -is [System.String] -and $Hex -Like "* *")   { $Hex = $Hex -split ' '           }
    elseif ($Hex -is [System.String])                         { $Hex = $Hex -split '(..)' -ne '' }
    
    $values = @()
    foreach ($i in $Hex) {
        $values += GetChar $i
    }

    return [string]($values -join '')

}




#==================================================================================================================================================================================================================================================================
function GetHexString([string]$Text) {
    
    return ($Text | Format-Hex | Select-Object -Expand Bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ' '

    $values = @()

    for ($i=0; $i -lt $Text.length; $i++) {
        $values += [byte]$Text.substring($i, 1)
    }

    return $values

}



#==================================================================================================================================================================================================================================================================
function ConvertFloatToHex([string]$Float) {

    $bytes = [BitConverter]::GetBytes([single]$Float)
    $bytes = $bytes | Foreach-Object { ("{0:X2}" -f $_) }
    [array]::Reverse($bytes)
    return $bytes

}



#==================================================================================================================================================================================================================================================================
function ConvertHexToFloat([string]$Hex) {
    
    try     { return ([BitConverter]::ToSingle([BitConverter]::GetBytes([uint32]("0x" + $Hex)), 0)) }
    catch   { return -1 }

}



#==================================================================================================================================================================================================================================================================
function CombineHex([string[]]$Hex) {
    
    $output = ""
    foreach ($item in $Hex) {
        $output += Get8Bit $item
    }
    return [string]$output

}



#==================================================================================================================================================================================================================================================================
function Get8Bit([byte]$Value)                                 { return '{0:X2}' -f $Value }
function Get16Bit([uint16]$Value)                              { return '{0:X4}' -f $Value }
function Get24Bit([uint32]$Value)                              { return '{0:X6}' -f $Value }
function Get32Bit([uint32]$Value)                              { return '{0:X8}' -f $Value }
function AddToOffset([string]$Hex, [string]$Add)               { return (Get32Bit ( (GetDecimal $Hex) + (GetDecimal $Add)      ) ) }
function SubtractFromOffset([string]$Hex, [string]$Subtract)   { return (Get32Bit ( (GetDecimal $Hex) - (GetDecimal $Subtract) ) ) }



#==============================================================================================================================================================================================

(Get-Command -Module "Bytes") | % { Export-ModuleMember $_ }