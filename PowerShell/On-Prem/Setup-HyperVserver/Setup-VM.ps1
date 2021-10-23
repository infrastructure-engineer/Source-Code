
$cred = Get-Credential -Credential ( $env:COMPUTERNAME + "\matrix")

Import-Module Hyper-V

Get-VM -Credential $cred -ComputerName $env:COMPUTERNAME 




#"IT Cloud Work"
#"ITCloudWork"

$ServerName = 'ICW-SQLFILE1'

$VHDpath = "D:\Hyper-V\" + $ServerName + "\Virtual Hard Disks\" + $ServerName + ".OS.VHDX"

$NewVM = new-vm -Name $ServerName -MemoryStartupBytes 4GB -NoVHD -SwitchName ICW-Private -Path D:\Hyper-V\ -Generation 2

new-item -Path ( "D:\Hyper-V\" + $ServerName) -ItemType Directory -Name "Virtual Hard Disks" 

Copy-Item -Path D:\Hyper-V\TemplateServer2019.vhdx -Destination $VHDpath

$NewVM | set-vm -ProcessorCount 4 -DynamicMemory -MemoryMinimumBytes 512MB -MemoryMaximumBytes 4GB -AutomaticStartAction Nothing -AutomaticStopAction ShutDown -CheckpointType Disabled

$NewVM | Add-VMHardDiskDrive -Path $VHDpath

$NewVM | Set-VMFirmware -BootOrder (get-VMHardDiskDrive -VMName $servername )

$NewVM | Start-VM

Start-Sleep 120


$sblock = [scriptblock]{
    Rename-Computer -NewName $using:servername -LocalCredential (Get-Credential -Credential Administrator) -Restart
}


Invoke-Command -VMName $ServerName -ScriptBlock $sblock -Credential $cred

$list | Where-Object { $_.InstallState -like 'Installed'} | Out-String | Out-File -PSPath C:\Temp




