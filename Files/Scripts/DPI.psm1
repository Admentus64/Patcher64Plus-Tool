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

$global:DisableHighDPIMode = $False



#==============================================================================================================================================================================================
#  DISABLE WINDOWS AUTO-SCALE FOR HIGH DPI
#==============================================================================================================================================================================================
#  Some weird code I accidentally discovered long ago that sets forms to use WPF style that allows higher DPI. This bypasses windows trying to auto-scale 
#  forms using some kind of upscaling filter. This also allows forms to still be created from winforms functions in the "forms" namespace. The drawback is
#  one size does not fit all DPI scaling. Every DPI setting needs a brand new set of values for every single dialog item (buttons, textboxes, groups, etc).
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function DisableWindowsScaling() {
    
    # Check to see if enabling High DPI settings.
    if ($DisableHighDPIMode) { return }

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

function DPISize($Value) {
    
    # Check to see if DPI scaling was disabled.
    if ($DisableHighDPIMode) { return $Value }

    # The type of variable will determine the calculation method.
    switch ($Value.GetType().ToString()) {
        # Calculate the values and return the type of variable that was sent.
        'System.Int32'          { return [int]($Value * $DPIMultiplier) }
        'System.Double'         { return [double]($Value * $DPIMultiplier) }
        'System.Drawing.Size'   { return (New-Object Drawing.Size([int]($Value.Width * $DPIMultiplier), [int]($Value.Height * $DPIMultiplier))) }
        'System.Drawing.Point'  { return (New-Object Drawing.Point([int]($Value.X * $DPIMultiplier), [int]($Value.Y * $DPIMultiplier))) }
    }

    # If it's something else, just return the value sent.
    return $Value

}



#==============================================================================================================================================================================================
#  INITIALIZATION 
#==============================================================================================================================================================================================
#  This is where the magic happens.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function HighDPI_Init() {
    
    # Disable auto-scaling the GUI.
    DisableWindowsScaling

    # Current DPI of the monitor is pulled from the registry.
    $MonitorDPI = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name AppliedDPI).AppliedDPI

    # Calculation of the DPI multiplier. Stored in a global so it's only calculated once.
    $global:DPIMultiplier = ($MonitorDPI / 24) * 0.25

}



#==============================================================================================================================================================================================
#  Call the function to enable high DPI.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

HighDPI_Init