function ChangeBytes([string]$File, [string]$Offset, [object]$Values, [uint16]$Interval=1, [switch]$Add, [switch]$Subtract, [switch]$IsDec, [switch]$Overflow) {
    
    if ($Values -is [System.String])   { $Values = $Values -split ' ' }
    if (IsSet $File)                   { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    if ($Interval -lt 1)               { $Interval = 1 }

    try { [uint32]$Offset = GetDecimal $Offset }
    catch {
        WriteToConsole "Offset is negative!"
        return
    }
    if ($Offset -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!"
        return
    }

    if ($IsDec) {
        $arr = @()
        foreach ($i in $Values) {
            $arr += Get8Bit $i
        }
        WriteToConsole ("Change values: " + $arr)
        $arr = $null
    }
    else { WriteToConsole ("Change values: " + $Values) }

    foreach ($i in 0..($Values.Length-1)) {
        if ($IsDec) {
            if     ($Values[$i] -lt 0   -and $Overflow)   { $Values[$i] = $Values[$i] + 255 }
            elseif ($Values[$i] -gt 255 -and $Overflow)   { $Values[$i] = $Values[$i] - 255 }
            [byte]$Value  = $Values[$i]
        }
        else {
            try { [byte]$Value = GetDecimal $Values[$i] }
            catch {
                WriteToConsole "Value is negative!"
                return
            }
        }

        if     ($Add)        { $ByteArrayGame[$Offset + ($i * $Interval)] += $Value }
        elseif ($Subtract)   { $ByteArrayGame[$Offset + ($i * $Interval)] -= $Value }
        else                 { $ByteArrayGame[$Offset + ($i * $Interval)]  = $Value }
    }

    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }
    $File = $Offset = $Interval = $Value = $null
    $Values = $null

}



#==============================================================================================================================================================================================
function PatchBytes([string]$File, [string]$Offset, [string]$Length, [string]$Patch, [switch]$Texture, [switch]$Extracted, [switch]$Pad) {
    
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
        foreach ($i in 0..($Length-1)) {
            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
            elseif ($Pad)                        { $ByteArrayGame[$Offset + $i] = 255 }
            else                                 { $ByteArrayGame[$Offset + $i] = 0 }
        }
    }
    else {
        foreach ($i in 0..($PatchByteArray.Length-1)) { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
    }

    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }
    $File = $Offset = $Length = $Patch = $PatchByteArray = $null

}



#==============================================================================================================================================================================================
function ExportBytes([string]$File, [string]$Offset, [string]$End, [string]$Length, [string]$Output, [switch]$Force) {
    
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
function SearchBytes([string]$File, [string]$Start="0", [string]$End, [object]$Values) {
    
    if ($values -is [System.String]) { $values = $values -split ' ' }

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

    foreach ($i in $Start..($End-1)) {
        $Search = $True
        foreach ($j in 0..($Values.Length-1)) {
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
function Get8Bit([byte]$Value)      { return '{0:X2}' -f $Value }
function Get16Bit([uint16]$Value)   { return '{0:X4}' -f $Value }
function Get24Bit([uint32]$Value)   { return '{0:X6}' -f $Value }
function Get32Bit([uint32]$Value)   { return '{0:X8}' -f $Value }



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