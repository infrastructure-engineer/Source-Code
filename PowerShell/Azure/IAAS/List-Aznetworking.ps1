
$vNetwork = @()
$vNetwork = [PSCustomObject]@{

    HomeHub                     = '192.168.0.0/24'
    OnPrem                      = '172.16.0.0/24'
    Azure                       = '10.0.0.0/8'

    Regions                     = @{
        UKSOUTH                 = @{
        VNET                    = @{
        Vnet1                   = @{  
            Name                = 'Hub-VNET'
            IPRange             = '10.10.0.0/16'
            Subnet0             = @{
                Name            = 
                IPRange         = '10.10.0.0/24'
            } #Subnet1
            Subnet1            = @{
                Name            = 'AzureBastionSubnet'
                IPRange         = '10.10.10.0/27'
            } #Subnet2
            Subnet2             = @{
                Name            = 'GatewaySubnet'
                IPRange         = '10.10.20.0/27'
            } #Subnet3
            Subnet3             = @{
                Name            = 'AzureFirewallSubnet'
                IPRange         = '10.10.30.0/26'
            } #Subnet4 'Hub-Network-Devices-SN'
            Subnet4             = @{
                Name            = 'Hub-PrivateEndpoints-SN'
                IPRange         = '10.10.40.0/24'
            } #Subnet5
            Subnet5             = @{
                Name            = 'Hub-SharedServices-SN'
                IPRange         = '10.10.50.0/24'
            } #Subnet5

        } #UKVnet1
        Vnet2                   = @{  
            Name                = 'Production-Backend-Spoke-VNET'
            IPRange             = '10.20.0.0/16'
            Subnet0             = @{
                Name            = 'Hub-Network-Devices-SN'
                IPRange         = '10.30.0.0/24'
            } #Subnet1     
        } #UKVnet2
        Vnet3                   = @{  
            Name                = 'Production-Backend-Spoke-VNET'
            IPRange             = '10.20.0.0/16'
            Subnet0             = @{
                Name            = 'Hub-Network-Devices-SN'
                IPRange         = '10.10.0.0/24'
            } #Subnet3     
        } #UKVnet3        
    } 
}






        
        Region2              = 'southafricawest'
        SAWVnet1                 = @{  
            Name                = 'Hub-VNET'
            IPRange             = '10.10.0.0/16'
            Subnets1            = @{
                Name            = 'Hub-Network-Devices-SN'
                IPRange         = '10.10.0.0/24'
            }
        } #Vnet2
    } # UKKRegion
} #vNetwork


NetworkWatcherRG
SubscriptionWide-RG



    
    uksouth Azure.Production (Production-Network-RG)
    Production-Network-VNET     = '10.20.0.0/16'
    AzureBastionSubnet          = '10.20.10.0/27'
    Production-Server-SN        = '10.20.50.0/24'
    }
    }
    southafricanorth Azure.Core ( )
    Central-Core-VNET           = '10.81.0.0/16'
    Core-Network-Devices-SN     = '10.81.0.0/24'
    AzureBastionSubnet          = '10.81.10.0/27'
    
    southafricawest Azure.Core ( )
    Central-Core-VNET           = '10.83.0.0/16'
    Core-Network-Devices-SN     = '10.83.0.0/24'
    AzureBastionSubnet          = '10.83.10.0/27'
    
    }]
    
    $vNetwork | Select-Object -ExpandProperty Region
    
    $SetupFlow = $true
    
    $VNETname       = 'Production-Network-VNET'
    
    $VnetRG         = 'Production-Network-RG'
    $vlocation      = 'uksouth'
    $VnetAddress    = '10.20.0.0/16'
    $vPurpose       = 'Production Network Infrastructure'
    $tags           = @{ 
            Created =  (get-date -Format yyyy/MM/dd) 
            Purpose =  $vPurpose 
    }