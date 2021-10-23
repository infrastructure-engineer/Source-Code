#Setup Azure Network IAAS 

##Import and Connect
import-module az
Connect-AzAccount

##Set Context
set-azcontext (Get-AzSubscription | Where-Object { $_.name -like "Azure Pass*"})

##Variables
$AZcontext = get-azcontext
$SubscriptionID = $AZcontext.Subscription.id
$TenantID = $AZcontext.Tenant.Id

$RGname         = 'Network-EastUS2-RG'
$Azregion       = 'eastus2'
$vPurpose       = 'Learning Azure'

$tags           = @{ 
    Created =  (get-date -Format yyyy/MM/dd) 
    Purpose =  $vPurpose 
    State   =  'Temporary'
}

[string]$MyIP = Invoke-RestMethod -Method GEt  https://api.ipify.org

##Create Resource Group
$RG =  New-AzResourceGroup -Name $RGname -Location $Azregion -Tag $tags

##Create Core Network

#$rdpRule   = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
#$gwnsg     = New-AzNetworkSecurityGroup -ResourceGroupName $RGname -Location $Azregion -Tag $tags -Name "GatewaySubnet-NSG"    
#$fwnsg     = New-AzNetworkSecurityGroup -ResourceGroupName $RGname -Location $Azregion -Tag $tags -Name "AzureFirewallSubnet-NSG"  
#$basnsg    = New-AzNetworkSecurityGroup -ResourceGroupName $RGname -Location $Azregion -Tag $tags -Name "AzureBastionSubnet-NSG"

$endpnsg   = New-AzNetworkSecurityGroup -ResourceGroupName $RGname -Location $Azregion -Tag $tags -Name "AzureEndpointsSubnet-NSG"   
$servernsg = New-AzNetworkSecurityGroup -ResourceGroupName $RGname -Location $Azregion -Tag $tags -Name "ServerCoreSubnet-NSG"     #-SecurityRules $rdpRule


$GatewaySubnet        = New-AzVirtualNetworkSubnetConfig -Name GatewaySubnet       -AddressPrefix "10.10.10.0/26" 
$AzureFirewallSubnet  = New-AzVirtualNetworkSubnetConfig -Name AzureFirewallSubnet -AddressPrefix "10.10.20.0/26" #-NetworkSecurityGroup $fwnsg
$AzureFirewallManagementSubnet  = New-AzVirtualNetworkSubnetConfig -Name AzureFirewallManagementSubnet -AddressPrefix "10.10.20.64/26"
$AzureBastionSubnet   = New-AzVirtualNetworkSubnetConfig -Name AzureBastionSubnet  -AddressPrefix "10.10.30.0/27" #-NetworkSecurityGroup $basnsg next 10.10.30.0/27
$AzureEndpointSubnet  = New-AzVirtualNetworkSubnetConfig -Name AzureEndpointSubnet -AddressPrefix "10.10.40.0/24" -NetworkSecurityGroup $endpnsg
$ServerSubnet         = New-AzVirtualNetworkSubnetConfig -Name ServerCoreSubnet    -AddressPrefix "10.10.50.0/24" -NetworkSecurityGroup $servernsg

$corevnet = New-AzVirtualNetwork -Name Network-EastUS2-Core-VNET -ResourceGroupName $RGname -Location $Azregion -AddressPrefix "10.10.0.0/16" -Subnet $GatewaySubnet, $AzureFirewallSubnet, $AzureBastionSubnet, $AzureEndpointSubnet, $ServerSubnet -Tag $tags

#GateWay
$GWPIP1 = New-AzPublicIpAddress -ResourceGroupName $RGname -Location $Azregion -Name Gateway-PIP1 -AllocationMethod Dynamic -Sku basic -Tag $tags -Zone 1
$GWPIP2 = New-AzPublicIpAddress -ResourceGroupName $RGname -Location $Azregion -Name Gateway-PIP2 -AllocationMethod Dynamic -Sku basic -Tag $tags -Zone 2
$subnet = Get-AzVirtualNetworkSubnetConfig -name 'gatewaysubnet' -VirtualNetwork $corevnet
$ngwipconfig1 = New-AzVirtualNetworkGatewayIpConfig -Name ngwipconfig -SubnetId $subnet.Id -PublicIpAddressId $GWPIP1.Id
$ngwipconfig2 = New-AzVirtualNetworkGatewayIpConfig -Name ngwipconfig -SubnetId $subnet.Id -PublicIpAddressId $GWPIP2.Id

$vGW = New-AzVirtualNetworkGateway -Name EASTUS2-NGW -ResourceGroupName $RGname -Location $Azregion -IpConfigurations $ngwIpConfig1 -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku "VpnGw1" -CustomRoute 172.16.0.0/16 -Tag $tags

$Gateway = Get-AzVirtualNetworkGateway -Name EASTUS2-NGW -ResourceGroupName $RGname

Set-AzVirtualNetworkGateway -VirtualNetworkGateway $vGW -EnableActiveActiveFeature

#TODO
# $LGW = New-AzLocalNetworkGateway -Name EASTUS2-NGW-LocalGW -ResourceGroupName $RGname -Location $Azregion -GatewayIpAddress $MyIP -AddressPrefix "172.16.0.0/16"
# new connection
# config NetworkGateway + LocalNetworkGateway + Connection


#Bastion
$BastionPIP = New-AzPublicIpAddress -ResourceGroupName $RGname  -Location $Azregion -Name Bastion-PIP -AllocationMethod Dynamic -Sku standard -Tag $tags -Tier Regional
$vBastion = New-AzBastion -ResourceGroupName $RGname -Name Bastion-EastUS2 -PublicIpAddress $BastionPIP -VirtualNetwork $corevnet -Tag $tags



$vmName = 'AZUVM2'

#Create the NIC
$wsn = Get-AzVirtualNetworkSubnetConfig -Name ServerSubnet -VirtualNetwork $corevnet
$NIC01 = New-AzNetworkInterface -Name ($vmName + '-NIC-') -ResourceGroupName $RGname  -Location $Azregion -Subnet $wsn


#Define the virtual machine
$VirtualMachine = New-AzVMConfig -VMName Srv-Work -VMSize "Standard_B2s"
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName Srv-Work -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC01.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2019-Datacenter' -Version latest


#Create the virtual machine
New-AzVM -ResourceGroupName $RGname -Location $Azregion -VM $VirtualMachine -Verbose


Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True






'Network-Development-EastUS2-VNET'

Get-AzResourceGroup -Location $Azregion




#And FINALLY 
# Clean Up All Deployments in the Resource group
# Remove-AzResourceGroup -Name $RG -Force


