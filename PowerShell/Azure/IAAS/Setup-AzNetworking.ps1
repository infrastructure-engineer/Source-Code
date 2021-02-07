
#Setup Azure Network IAAS 

import-module az
Connect-AzAccount 
Get-AzContext

#Import Variables
. .\list-aznetworking.ps1

#Create VNET
if (!(Get-AzVirtualNetwork -Name $VNETname -ResourceGroupName $VnetRG) ){
    write-host -ForegroundColor Cyan "Creating VNET $($VNETname)"
    New-AzVirtualNetwork -Name $VNETname -ResourceGroupName $VnetRG -Location $vlocation -AddressPrefix $VnetAddress -Tag $tags
}else {
    Write-Host -ForegroundColor Yellow "VNET '$($VNETname)' already found. Skipping VNET creation"
}

$vVnet = Get-AzVirtualNetwork -Name $VNETname -ResourceGroupName $VnetRG

#Create Subnet
$subbetAdd  = "10.20.50.0/24"
$vSubnetname = 'Production-Server-SN'
$SubTest = Get-AzVirtualNetworkSubnetConfig -Name $vSubnetname -VirtualNetwork $vVnet -ErrorAction SilentlyContinue 
if (!( $SubTest ) ){
    write-host -ForegroundColor Cyan "Creating Subnet $($vSubnetname)"
    try {
        Add-AzVirtualNetworkSubnetConfig -Name $vSubnetname -AddressPrefix $subbetAdd -VirtualNetwork $vVnet
        $vVnet | Set-AzVirtualNetwork
    }
    catch {
        $_.ErrorDetails
    }    
}else {
    Write-Host -ForegroundColor Yellow "Subnet '$($vSubnetname)' already found. Skipping Subnet creation"
}

#Create Site-to-Site VPN / Setup Gateway

$gwpipname      = 'AZU-GW-PIP'
$RG             = 'Core-Network-RG'
$Azregion       = 'uksouth'
$vPurpose       = 'Site-to-Site VPN'

$tags           = @{ 
    Created =  (get-date -Format yyyy/MM/dd) 
    Purpose =  $vPurpose 
    State   =  'Temporary'
}

#Create a New PIP
New-AzPublicIpAddress -Name $gwpipname -ResourceGroupName $RG -Location $Azregion -AllocationMethod Dynamic -Sku Basic -Tag $tags

$gwpip = Get-AzPublicIpAddress -Name $gwpipname 


#Create a Azure Gateway
$CoreVnet = 'Central-Core-VNET'

$vnet = Get-AzVirtualNetwork -Name $CoreVnet -ResourceGroupName $RG
$subnet = Get-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id

$GWname = 'AZU-GW'
$starttime = get-date
& New-AzVirtualNetworkGateway -Name $GWname -ResourceGroupName $RG -Location $Azregion -IpConfigurations $gwipconfig -GatewayType Vpn -VpnType RouteBased -GatewaySku Basic -tag $tags
$enddate = get-date

$gwdeplytime =  $enddate - $starttime 
write-host "Time it took to Deploy Gateway: "
$gwdeplytime

$vgateway = Get-AzVirtualNetworkGateway -Name $GWname -ResourceGroupName $RG

$LNG = "HomeNetwork"

$vlocal = Get-AzLocalNetworkGateway -Name $LNG -ResourceGroupName $RG

#Create Connection
$Gwconnection = 'AZU_To_HomeNetwork'

New-AzVirtualNetworkGatewayConnection `
    -Name $Gwconnection `
    -ResourceGroupName $RG `
    -Location $Azregion `
    -VirtualNetworkGateway1 $vgateway `
    -LocalNetworkGateway2 $vlocal `
    -ConnectionType IPsec `
    -RoutingWeight 10 `
    -SharedKey 'Turnippen801!' `
    -ConnectionProtocol IKEv2 `
    -Tag $tags


#Test Connection
Get-AzVirtualNetworkGatewayConnection -Name $Gwconnection -ResourceGroupName $rg | Select-Object ConnectionStatus, EgressBytesTransferred,IngressBytesTransferred



#Firewall

$vnet = Get-AzVirtualNetwork -Name $CoreVnet -ResourceGroupName $rg

$azfwpip= "AZU-FW-PIP1"
$vPurpose = "AzuFirewall"
$tags           = @{ 
    Created =  (get-date -Format yyyy/MM/dd) 
    Purpose =  $vPurpose 
    State   =  'Temporary'
}

New-AzPublicIpAddress `
  -Name $azfwpip `
  -ResourceGroupName $rg `
  -Sku "Standard" `
  -Location $Azregion `
  -AllocationMethod Static `
  -Tag $tags


$pip1 = Get-AzPublicIpAddress -Name $azfwname -ResourceGroupName $rg

$azfwname = "AZU-FW"
New-AzFirewall -Name $azfwname -ResourceGroupName $rg -Location $Azregion -VirtualNetwork $vnet.name -PublicIpAddress @($pip1) -Tag $tags


#Azure Route Table
$Route = New-AzRouteConfig -Name "Route07" -AddressPrefix 10.1.0.0/16 -NextHopType "VnetLocal"#
New-AzRouteTable -Name "RouteTable01" -ResourceGroupName "ResourceGroup11" -Location "EASTUS" -Route $Route




function Setup-AZvnet {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}

function Setup-AZsubnet {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}

function Setup-AZgateway {
    [CmdletBinding()]
    param (
    [string]$location = 'UKS'

    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}


function Setup-AZfirewall {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}
