<#
  # Save USB device(s) object in variable
  # Version - 1
  $usbDrive = Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"}
  # Version - 2
  $usbDrive = Get-Disk | Where-Object BusType -Eq USB
  # Ask user to choose USB
  $usbDriveNr = Write-Host -Prompt "To choose USB device enter corresponding number: "
  # Remove all data on USB device
  Clear-Disk -Number "$usbDriveNr" -RemoveData -RemoveOEM 
  Out-GridView -Title 'Select USB Drive to Format' -OutputMode Single |
  Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru |
  New-Partition -UseMaximumSize -IsActive -AssignDriveLetter |
  Format-Volume -FileSystem FAT32
#>

# Load .NET class System.Windows.Forms into a PowerShell session
Add-Type -Assembly System.Windows.Forms

# Create GUI window
$GuiBox = New-Object System.Windows.Forms.Form

# Set size and title of the GUI window
$GuiBox.Text	= 'MkUSB'
$GuiBox.Width = 800
$GuiBox.Height = 600

# If elements on the GUI window exceeds width and height, then automatically resize
$GuiBox.AutoSize = $true

# Create lablel element on the GUI window
$Label = New-Object System.Windows.Forms.Label
$Label.Text = 'USB Drives:'
$Label.Location = New-Object System.Drawing.Point(0, 10)
$Label.AutoSize = $true
$GuiBox.Controls.Add($Label)


# Create a drop-down list with available USB Drives. Disks can be retreived with Get-Disk cmdlet
$USBDropDownList = New-Object System.Windows.Forms.ComboBox
$USBDropDownList.Width = 400
$USBDrives = Get-Disk | Where-Object –FilterScript {$_.Bustype -Eq "USB"}

ForEach ($USBDrive in $USBDrives)
{
    $USBDropDownList.Items.Add($USBDrive.FriendlyName);
}

$GuiBox.Controls.Add($USBDropDownList)

# Display GUI window
$GuiBox.ShowDialog()
