#==============================================================================================================================================================================================
#  ADD THE REQUIRED ASSEMBLY
#==============================================================================================================================================================================================
#  This framework allows disabling auto-scaling the GUI with the filter Windows applies.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Add-Type -AssemblyName 'PresentationFramework'



#==============================================================================================================================================================================================
#  SWITCH TO ENABLE/DISABLE HIGH DPI SCALING
#==============================================================================================================================================================================================
#  This can be used as a switch to allow the user to enable/disable high DPI scaling.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# $global:DisableHighDPIMode = $False



#==============================================================================================================================================================================================
#  DISABLE WINDOWS AUTO-SCALE FOR HIGH DPI
#==============================================================================================================================================================================================
#  Some weird code I accidentally discovered long ago that sets forms to use WPF style that allows higher DPI. This bypasses windows trying to auto-scale 
#  forms using some kind of upscaling filter. This also allows forms to still be created from winforms functions in the "forms" namespace. The drawback is
#  one size does not fit all DPI scaling. Every DPI setting needs a brand new set of values for every single dialog item (buttons, textboxes, groups, etc).
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function DisableWindowsScaling() {
    
    # Create a dummy WPF window.
    [xml]$Xaml = @"
    <Window
      xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
      xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
      x:Name="Window">
    </Window>
"@
    
    # This does some stuff that makes it not auto-scale for some reason.
    $Reader = (New-Object System.Xml.XmlNodeReader $Xaml)
    $Window = [Windows.Markup.XamlReader]::Load($Reader)

}



#==============================================================================================================================================================================================
#  FUNCTION TO ADJUST ACCORDING TO DPI SCALING
#==============================================================================================================================================================================================
#  Adjusts a value to scale according to the current DPI. The "$DPIMultiplier" is a global variable calculated on init.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function DPISize($Value, [switch]$Round=$false, $Add=0, $AddX=0, $AddY=0) {
    
    # Immediately return the value if scaling is disabled.
    if ($DisableHighDPIMode) { return $Value }

    # Shorten this massive blob of text with a variable.
    $RMode = [System.MidpointRounding]::AwayFromZero

    # The type of variable will determine the calculation method.
    switch ($Value.GetType().ToString()) {
        # 16-Bit Integer, Aliases: Int16
        'System.Int16' {
            if (!$Round)   { $Value = [int16][Math]::Truncate($Value * $DPIMultiplier) } 
            else           { $Value = [int16][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # 32-Bit Integer, Aliases: Int, Int32
        'System.Int32' {
            if (!$Round)   { $Value = [int32][Math]::Truncate($Value * $DPIMultiplier) } 
            else           { $Value = [int32][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # 64-Bit Integer, Aliases: Int64, Long
        'System.Int64' {
            if (!$Round)   { $Value = [int64][Math]::Truncate($Value * $DPIMultiplier) }
            else           { $Value = [int64][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Single Float, Aliases: Single, Float
        'System.Single' {
            if (!$Round)   { $Value = [single][Math]::Truncate($Value * $DPIMultiplier) }
            else           { $Value = [single][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Double Float
        'System.Double' {
            if (!$Round)   { $Value = [double][Math]::Truncate($Value * $DPIMultiplier) }
            else           { $Value = [double][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Drawing Size (Width, Height)
        'System.Drawing.Size' {
            if (!$Round)   { $Value = New-Object Drawing.Size([int][Math]::Truncate($Value.Width * $DPIMultiplier), [int32][Math]::Truncate($Value.Height * $DPIMultiplier)) }
            else           { $Value = New-Object Drawing.Size([int][Math]::Round(($Value.Width * $DPIMultiplier), $RMode), [int32][Math]::Round(($Value.Height * $DPIMultiplier), $RMode)) }
            return         ( New-Object Drawing.Size(($Value.Width + $Add + $AddX), ($Value.Height + $Add + $AddY)) )
        }

        # Drawing Point (X, Y)
        'System.Drawing.Point' {
            if (!$Round)   { $Value = New-Object Drawing.Point([int][Math]::Truncate($Value.X * $DPIMultiplier), [int32][Math]::Truncate($Value.Y * $DPIMultiplier)) }
            else           { $Value = New-Object Drawing.Point([int][Math]::Round(($Value.X * $DPIMultiplier), $RMode), [int32][Math]::Round(($Value.Y * $DPIMultiplier), $RMode)) }
            return         ( New-Object Drawing.Point(($Value.X + $Add + $AddX), ($Value.Y + $Add + $AddY)) )
        }

    }

}



#==============================================================================================================================================================================================
#  INITIALIZATION 
#==============================================================================================================================================================================================
#  This is where the magic happens.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function InitializeHiDPIMode() {
    
    # Current DPI of the monitor is pulled from the registry.
    $MonitorDPI = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name AppliedDPI).AppliedDPI
    
    # Check to see if high DPI is disabled.
    if (!$DisableHighDPIMode) {
        
        # Disable auto-scaling the GUI.
        DisableWindowsScaling

         # Get the multiplier derived from the DPI setting.
        $global:DPIMultiplier = ($MonitorDPI / 24) * 0.25

    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function DPISize
Export-ModuleMember -Function InitializeHiDPIMode