function ChangeBytes([string]$File, [byte[]]$Array, [object]$Offset, [object]$Match=$null, [object]$Values, [byte]$Repeat=0, [uint16]$Interval=1, [switch]$Add, [switch]$Subtract) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File)
            return $False
        }
    }

    if     ($Match  -is [String] -and $Match  -Like "* *")               { $matchDec  = $Match -split ' '            | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match  -is [String])                                        { $matchDec  = $Match -split '(..)' -ne ''  | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match  -is [Array]  -and $Match[0] -is [String])            { $matchDec  = $Match                       | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                 { $matchDec  = @(); $matchDec += $Match }

    if     ($Values -is [String] -and $Values -Like "* *")               { $valuesDec = $Values -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [String])                                        { $valuesDec = $Values -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [Array]  -and $Values[0] -is [System.String])    { $valuesDec = $Values                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                 { $valuesDec = @(); $valuesDec += $Values }

    if ($Repeat -gt 0) { $tempValues = $ValuesDec }
    while ($Repeat -gt 0) {
        $ValuesDec += $tempValues
        $Repeat--
    }

    if     ($Array.count -gt 0 -and $Array -ne $null)                    { $ByteArrayGame = $Array                                }
    elseif (IsSet $File)                                                 { $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) }
    if     ($Interval -lt 1)                                             { $Interval      = 1                                     }

    # Offset
    if ($Offset -is [String]) { $Offset = $Offset -split ' ' }

    $offsetDec = @()
    foreach ($o in $Offset) {
        $dec = GetDecimal $o
        if ($dec -lt 0) {
            WriteToConsole "Offset is negative, too large or not an integer!" -Error
            $global:WarningError = $True
            return $False
        }
        if ($dec -gt $ByteArrayGame.Length) {
            WriteToConsole "Offset is too large for file!" -Error
            $global:WarningError = $True
            return $False
        }
        $offsetDec += $dec
    }

    # Match
    if ($matchDec -ne $null) {
        foreach ($o in $offsetDec) {
            foreach ($i in 0..($matchDec.Length-1)) {
                try {
                    if ($ByteArrayGame[$o + $i] -ne $matchDec[$i]) { return $True }
                }
                catch {
                    WriteToConsole "Match value is negative!" -Error
                    return $False
                }
            }
        }
    }

    # Convert to Byte if needed
    WriteToConsole ($Offset + " -> Change values: " + $Values)

    # Patch
    foreach ($o in $offsetDec) {
        foreach ($i in 0..($valuesDec.Length-1)) {
            $value = $valuesDec[$i]
            do {
                if ($value -ge 255) {
                    $restValue = 255
                    $value    -= 255
                }
                else {
                    $restValue = $value
                    $value     = 0
                }

                if ($Add) {
                    if ($ByteArrayGame[$o + ($i * $Interval)] + $restValue -gt 255) {
                        $ByteArrayGame[$o + ($i * $Interval)]     += $restValue - 256
                        $ByteArrayGame[$o + ($i * $Interval) - 1] += 1
                    }
                    else { $ByteArrayGame[$o + ($i * $Interval)] += $restValue }
                }
                elseif ($Subtract) {
                    if ($ByteArrayGame[$o + ($i * $Interval)] - $restValue -lt 0) {
                        $ByteArrayGame[$o + ($i * $Interval)]     += 256 - $restValue
                        $ByteArrayGame[$o + ($i * $Interval) - 1] -= 1
                    }
                    else { $ByteArrayGame[$o + ($i * $Interval)] -= $restValue }
                }
                else { $ByteArrayGame[$o + ($i * $Interval)]  = $restValue }
            } while ($value -gt 0)
        }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function MultiplyBytes([string]$File, [string]$Offset, [object]$Match=$null, [float]$Factor) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File)
    }

    if     ($Match -is [String] -and $Match  -Like "* *")      { $matchDec = $Match -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match -is [String])                               { $matchDec = $Match -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match -is [Array]  -and $Match[0] -is [String])   { $matchDec = $Match                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                       { $matchDec = $Match }

    # Offset
    $offsetDec = GetDecimal $Offset
    if ($offsetDec -lt 0) {
        WriteToConsole "Offset is negative, too large or not an integer!" -Error
        $global:WarningError = $True
        return $False
    }
    if ($offsetDec -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!" -Error
        $global:WarningError = $True
        return $False
    }

    # Match
    if ($MatchDec -ne $null) {
        foreach ($i in 0..($MatchDec.Length-1)) {
            if ($ByteArrayGame[$offsetDec + $i] -ne $MatchDec[$i]) { return $True }
        }
    }

    # Patch
    if ($Factor -eq 0) {
        WriteToConsole ($Offset + " -> Set value " + (Get8Bit $ByteArrayGame[$offsetDec]) +" to: 1")
        $ByteArrayGame[$offsetDec] = 1
    }
    elseif ($ByteArrayGame[$offsetDec] -gt 0) {
        WriteToConsole ($Offset + " -> Multiplied value " + (Get8Bit $ByteArrayGame[$offsetDec]) +" by: " + $Factor)
        $ByteArrayGame[$offsetDec] *= $Factor
        if ($ByteArrayGame[$offsetDec] -eq 0) { $ByteArrayGame[$offsetDec] = 1 }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function CopyBytes([string]$File, [string]$Start, [string]$Length, [string]$Offset) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    # Offset
    $startDec  = GetDecimal $Start
    $lengthDec = GetDecimal $Length
    $offsetDec = GetDecimal $Offset
    
    if ($startDec -lt 0 -or $Length -lt 0 -or $offsetDec -lt 0) {
        WriteToConsole "lengthDec are negative, too large or not an integer!" -Error
        $global:WarningError = $True
        return $False
    }
    if ($startDec -gt $ByteArrayGame.Length -or $lengthDec -gt $ByteArrayGame.Length -or $offsetDec -gt $ByteArrayGame.Length) {
        WriteToConsole "Offsets are too large for file!" -Error
        $global:WarningError = $True
        return $False
    }

    # Patch
    WriteToConsole ($Offset + " -> Copying values: from " + $Start)
    foreach ($i in 0..($lengthDec-1)) {
        $ByteArrayGame[$offsetDec + $i]  = $ByteArrayGame[$startDec + $i]
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function PatchBytes([string]$File, [string]$Offset, [string]$Length, [string]$Patch, [switch]$Texture, [switch]$Models, [switch]$Extracted, [switch]$Music, [switch]$Editor, [switch]$Temp, [switch]$Shared, [switch]$Pad) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    # Binary Patch File Parameter Check
    if (!(IsSet -Elem $Patch) ) {
        WriteToConsole "No binary patch file is provided" -Error
        $global:WarningError = $True
        return
    }

    # Binary Patch File Path
    if     ($Texture)     { $Patch = $GameFiles.textures  + "\" + $Patch                               }
    elseif ($Models)      { $Patch = $GameFiles.models    + "\" + $Patch                               }
    elseif ($Extracted)   { $Patch = $GameFiles.extracted + "\" + $Patch                               }
    elseif ($Music)       { $Patch = $Paths.Music         + "\" + $Patch                               }
    elseif ($Editor)      { $Patch = $Paths.Games         + "\" + $GameType.mode + "\Editor\" + $Patch }
    elseif ($Temp)        { $Patch = $Paths.Temp          + "\" + $Patch                               }
    elseif ($Shared)      { $Patch = $Paths.Shared        + "\" + $Patch                               }
    else                  { $Patch = $GameFiles.binaries  + "\" + $Patch                               }

    # Binary Patch File Exists
    if (!(TestFile $Patch)) {
        WriteToConsole ("Missing binary patch file: " + $Patch) -Error
        $global:WarningError = $True
        return
    }

    # Read Patch File
    $PatchByteArray = [IO.File]::ReadAllBytes($Patch)

    # Offset
    $offsetDec = GetDecimal $Offset
    if ($offsetDec -lt 0) {
        WriteToConsole "Offset is negative, too large or not an integer!" -Error
        $global:WarningError = $True
        return
    }
    if ($offsetDec -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!" -Error
        $global:WarningError = $True
        return
    }

    # Info
    WriteToConsole ($Offset + " -> Patch file from: " + $Patch)

    # Patch
    if (IsSet $Length) {
        $Length = GetDecimal $Length
        foreach ($i in 0..($Length-1)) {
            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$offsetDec + $i] = $PatchByteArray[($i)] }
            elseif ($Pad)                        { $ByteArrayGame[$offsetDec + $i] = 255 }
            else                                 { $ByteArrayGame[$offsetDec + $i] = 0 }
        }
    }
    else {
        foreach ($i in 0..($PatchByteArray.Length-1)) { $ByteArrayGame[$offsetDec + $i] = $PatchByteArray[($i)] }
    }

    # Write to File
    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }

}



#==============================================================================================================================================================================================
function ExportBytes([string]$File, [string]$Offset, [string]$End, [string]$Length, [string]$Output, [switch]$Force) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    if ( (TestFile $Output) -and ($Settings.Debug.ForceExtract -eq $False) -and !$Force) { return }

    [uint32]$Offset = GetDecimal $Offset
    WriteToConsole ("Write file to: " + $Output)

    if ($Offset -lt 0) {
        WriteToConsole "Offset is negative!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!" -Error
        $global:WarningError = $True
        return
    }

    RemoveFile $Output
    $Path = $Output.substring(0, $Output.LastIndexOf('\'))
    $Folder = $Path.substring($Path.LastIndexOf('\') + 1)
    $Path = $Path.substring(0, $Path.LastIndexOf('\') + 1)
    if (!(TestFile -Path ($Path + $Folder) -Container)) { New-Item -Path $Path -Name $Folder -ItemType Directory | Out-Null }

    if (IsSet $End) {
        $End = GetDecimal $End
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$Offset..($End - 1)])
    }
    elseif (IsSet $Length) {
        $Length = GetDecimal $Length
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$Offset..($Offset + $Length - 1)])
    }

}



#==============================================================================================================================================================================================
function SearchBytes([string]$File, [object]$Start="0", [object]$End, [object]$Values, [switch]$Suppress, [switch]$Decimal) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    if     ($values  -is [String] -and $values  -Like "* *")              { $values  = $values -split ' '           }
    elseif ($values  -is [String])                                        { $values  = $values -split '(..)' -ne '' }
    else {
        WriteToConsole "Search values are not valid to look for" -Error
        return $False
    }

    [uint32]$Start = GetDecimal $Start
    if (IsSet $End)   { [uint32]$End = GetDecimal $End }
    else              { [uint32]$End = $ByteArrayGame.Length }

    if ($Start -lt 0 -or $End -lt 0) {
        WriteToConsole "Start or end offset is negative!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $ByteArrayGame.Length -or $End -gt $ByteArrayGame.Length) {
        WriteToConsole "Start or end offset is too large for file!" -Error
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
            if ($Decimal) { return $i }
            return Get32Bit $i
        }
    }

    if (!$Suppress) { WriteToConsole "Did not find searched values" -Error }
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
function ConvertFloatToHex([string]$Float) {

    $bytes = [BitConverter]::GetBytes([single]$Float)
    $bytes = $bytes | foreach { ("{0:X2}" -f $_) }
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
    foreach ($item in $Hex) { $output += Get8Bit $item }
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