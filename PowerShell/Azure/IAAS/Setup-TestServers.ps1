Connect-AzAccount

# Variables for common values
$VMresourceGroup = "Server1-Core-UKS-RG"
$location = "uksouth"
$vmName = "AZU-DC-1"


function Switch-AzvmState{
    [CmdletBinding()]
    param (
     
        [Parameter(Mandatory)][string]$name,
        [Parameter(Mandatory)][ValidateSet('start','stop')]$State
    )

    Switch ($State.ToLower()) {
        "stop" {
                          
            #Save or update the current State and Metainfo to resource tag
            try {
                    Get-azvm -Name $name | Stop-AzVM -Force
            }
            catch {
                throw "Error while Stopping Azure VM: $($_.Exception.Message)"
            }

        } #End Stop Switch

        "start" {
                          
            #Save or update the current State and Metainfo to resource tag
            try {
                Get-azvm -Name $name | Stop-AzVM -Force
            }
            catch {
                throw "Error while Starting Azure VM: $($_.Exception.Message)"
            }

        } #End Stop Switch
    } #End Switch
} #End Function

Switch-AzvmState -name $vmName -State start


$tags           = @{ 
    Created =  (get-date -Format yyyy/MM/dd) 
    Purpose =  $vmName
    State   =  'Temporary'
}

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine." -UserName AzureAdmin


#######  Core  Server ######

# Create a resource group
#New-AzResourceGroup -Name "Server1-Core-UKS-RG" -Location $location

# Create a subnet configuration
#$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24
$coreVNET = Get-AzVirtualNetwork -Name 'Central-Core-VNET' -ResourceGroupName 'Core-Network-RG'
$vmSubnet = $vnet.Subnets | Where-Object { $_.name -match 'Core-Server-SN' } 
$subnetConfig = Get-AzVirtualNetworkSubnetConfig -Name  'Core-Server-SN' -VirtualNetwork $coreVNET
Get-AzVirtualNetworkSubnet

# Create a virtual network
#$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
#  -Name MYvNET -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig


# Create a public IP address and specify a DNS name
#$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
#  -Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name AllowRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $VMresourceGroup -Location $location `
  -Name ($vmName + '-NSG') -SecurityRules $nsgRuleRDP -Tag $tags

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzNetworkInterface -Name ($vmName + '-NIC') -ResourceGroupName $VMresourceGroup -Location $location `
  -SubnetId $vmSubnet.Id -NetworkSecurityGroupId $nsg.Id -Tag $tags

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_B2MS -Tag $tags | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred  | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic.Id | Set-AzVMBootDiagnostic -Enable -ResourceGroupName "SubscriptionWide-RG" -StorageAccountName "azdiagnosticstorage"

# Create a virtual machine
New-AzVM -ResourceGroupName $VMresourceGroup -Location $location -VM $vmConfig


#Allow Ping FW Rule on Server 
New-NetFirewallRule –DisplayName "Allow ICMPv4-In" –Protocol ICMPv4 -IcmpType 8