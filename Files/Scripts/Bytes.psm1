function ChangeBytes([String]$File, [String]$Offset, [Array]$Values, [int]$Interval=1, [Switch]$IsDec, [Switch]$Overflow) {

    WriteToConsole ("Change values: " + $Values)
    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    if ($Interval -lt 1) { $Interval = 1 }
    [uint32]$Offset = GetDecimal $Offset

    if ($Offset -lt 0) {
        WriteToConsole "Offset is negative!"
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        return
    }

    for ($i=0; $i -lt $Values.Length; $i++) {
        if ($IsDec)   {
            if     ($Values[$i] -lt 0   -and $Overflow)   { $Values[$i] = $Values[$i] + 255 }
            elseif ($Values[$i] -gt 255 -and $Overflow)   { $Values[$i] = $Values[$i] - 255 }
            [Byte]$Value = $Values[$i]
        }
        else {
            if     ((GetDecimal $Values[$i]) -lt 0   -and $Overflow)   { $Values[$i] = Get8Bit ($Values[$i] + 255) }
            elseif ((GetDecimal $Values[$i]) -gt 255 -and $Overflow)   { $Values[$i] = Get8Bit ($Values[$i] - 255) }
            [Byte]$Value = GetDecimal $Values[$i]
        }
        $ByteArrayGame[$Offset + ($i * $Interval)] = $Value
    }

    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }
    $File = $Offset = $Interval = $Value = $null
    $Values = $null

}



#==============================================================================================================================================================================================
function PatchBytes([String]$File, [String]$Offset, [String]$Length, [String]$Patch, [Switch]$Texture, [Switch]$Extracted, [Switch]$Pad) {
    
    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    if ($Texture) {
        $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.textures + "\" + $Patch)
        WriteToConsole ("Patch file from: " + $GameFiles.textures + "\" + $Patch)
    }
    elseif ($Extracted) {
        $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.extracted + "\" + $Patch)
        WriteToConsole ("Patch file from: " + $GameFiles.extracted + "\" + $Patch)
    }
    else {
        $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.binaries + "\" + $Patch)
        WriteToConsole ("Patch file from: " + $GameFiles.binaries + "\" + $Patch)
    }

    [uint32]$Offset = GetDecimal $Offset

    if ($Offset -lt 0) {
        WriteToConsole "Offset is negative!"
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        return
    }

    if (IsSet $Length) {
        [uint32]$Length = GetDecimal $Length
        for ($i=0; $i -lt $Length; $i++) {
            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
            elseif ($Pad)                        { $ByteArrayGame[$Offset + $i] = 255 }
            else                                 { $ByteArrayGame[$Offset + $i] = 0 }
        }
    }
    else {
        for ($i=0; $i -lt $PatchByteArray.Length; $i++) { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
    }

    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }
    $File = $Offset = $Length = $Patch = $PatchByteArray = $null

}



#==============================================================================================================================================================================================
function ExportBytes([String]$File, [String]$Offset, [String]$End, [String]$Length, [String]$Output, [Switch]$Force) {
    
    if ( (TestFile $Output) -and ($Settings.Debug.ForceExtract -eq $False) -and !$Force) { return }

    WriteToConsole ("Write file to: " + $Output)
    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    [uint32]$Offset = GetDecimal $Offset

    if ($Offset -lt 0) {
        WriteToConsole "Offset is negative!"
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
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

    $File = $Offset = $Length = $Output = $NewArray = $null

}



#==============================================================================================================================================================================================
function SearchBytes([String]$File, [String]$Start="0", [String]$End, [Array]$Values) {
    
    if (IsSet $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }

    [uint32]$Start = GetDecimal $Start
    if (IsSet $End)   { [uint32]$End = GetDecimal $End }
    else              { [uint32]$End = $ByteArrayGame.Length }

    if ($Start -lt 0 -or $End -lt 0) {
        WriteToConsole "Start or end offset is negative!"
        return
    }
    elseif ($Start -gt $ByteArrayGame.Length -or $End -gt $ByteArrayGame.Length) {
        WriteToConsole "Start or end offset is too large for file!"
        return
    }
    elseif ($Start -gt $End) {
        Write-Host "Start offset can not be greater than end offset"
        return
    }

    for ($i=$Start; $i -lt $End; $i++) {
        $Search = $True
        for ($j=0; $j -lt $Values.Length; $j++) {
            if ($Values[$j] -ne "") {
                if ($ByteArrayGame[$i + $j] -ne (GetDecimal $Values[$j]) ) {
                    $Search = $False
                    break
                }
            }
        }
        if ($Search -eq $True) {
            WriteToConsole ("Found values at: " + (Get32Bit $i))
            return Get32Bit $i
        }
    }

    WriteToConsole "Did not find searched values"
    return -1;

}



#==============================================================================================================================================================================================
function ExportAndPatch([String]$Path, [String]$Offset, [String]$Length, [String]$NewLength, [String]$TableOffset, [Array]$Values) {

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
function GetDecimal([String]$Hex) {
    
    try { return [uint32]("0x" + $Hex) }
    catch { return -1 }

}



#==================================================================================================================================================================================================================================================================
function Get8Bit($Value)            { return '{0:X2}' -f [int]$Value }
function Get16Bit($Value)           { return '{0:X4}' -f [int]$Value }
function Get24Bit($Value)           { return '{0:X6}' -f [int]$Value }
function Get32Bit($Value)           { return '{0:X8}' -f [int]$Value }



#==============================================================================================================================================================================================

Export-ModuleMember -Function ChangeBytes
Export-ModuleMember -Function PatchBytes
Export-ModuleMember -Function ExportBytes
Export-ModuleMember -Function SearchBytes
Export-ModuleMember -Function ExportAndPatch

Export-ModuleMember -Function GetDecimal
Export-ModuleMember -Function Get8Bit
Export-ModuleMember -Function Get16Bit
Export-ModuleMember -Function Get24Bit
Export-ModuleMember -Function Get32Bit