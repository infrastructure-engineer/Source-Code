<#
.Synopsis
        Ported Binance Module
.
        .Note



Security Type 	                    Description
NONE 	                        =   Endpoint can be accessed freely.
TRADE       &   USER_DATA       =   Endpoint requires sending a valid API-Key and signature.	        
MARKET_DATA &   USER_STREAM     =   Endpoint requires sending a valid API-Key.



        #>


<# Secret management
function Get-BinanceCredentials {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true,
        HelpMessage='APIKEY',
        Position=0)]
        [ValidatePattern('[A-Z]')] #Validate that the string only contains letter
        [String[]]$APIKEY,
    
        [Parameter(Mandatory=$true,
        HelpMessage='Secret',
        Position=0)]
        [ValidatePattern('[A-Z]')] #Validate that the string only contains letter
        [String[]]$APISECRET     
    )
    
    
    $APIKEY

    $APISECRET

        
    
}

$params = @{
    APIKEY    = $BINANCEAPI 
    APISECRET = $BINANCEKEY
}

Get-BinanceCredentials @params



#Set Reposittory To Trusted to skip Prompts
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

#Install Update to PowerShellGet
$params = @{
    Name              = 'PowerShellGet'
    Repository        = 'PSGallery'
    AllowClobber      = $true
    Force             = $true
}
Install-Module @Params

#Install Secret processing and encryption engine
$params = @{
    Name              = 'Microsoft.PowerShell.SecretManagement'
    AllowPreRelease   = $true
    Repository        = 'PSGallery'
}
Install-Module @Params

#Install Vault modules that will store your secrets
$params = @{
    Name              = 'Microsoft.PowerShell.SecretStore'
    AllowPreRelease   = $true
    Repository        = 'PSGallery'
}
Install-Module @Params

#Set Reposittory back to Default
Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted


#Creating the Secrets Vault
$params = @{
    Name            = 'DG.PWSH.Vault'
    ModuleName      = 'Microsoft.PowerShell.SecretStore'
    DefaultVault    = $true
    AllowClobber    = $true
}
Register-SecretVault @params

# Create an Entry into the Secret Vault
Set-Secret -name Binance -secret (get-credential -UserName $BINANCEAPI)

#>

#Binance Make Check Time

#Production
#$APISecret = (Get-Secret Binance).UserName
#$APIKey    = (Get-Secret Binance).password | ConvertFrom-SecureString -AsPlainText

#Testing
$APIKey     = 'wc78LxAtiT6S9bj3q7xMlzw6hYfKTDzqXoAmdNStyjOieP72CGHzvAIqMB7QAs5F'
$APISecret  = '1J87tpasIodYXUk4lqsEIVpi6926MHC39TDFllbubSsEIS5PyNpnr3u1Vxm7n1fy'

$TimeStamp = (Get-Date (Get-Date).ToUniversalTime() -UFormat %s).replace(',', '').replace('.', '').SubString(0,13)
$TimeStamp = 

$QueryString ="symbol=LTCBTC&side=BUY&type=LIMIT&timeInForce=GTC&quantity=1&price=0.1&recvWindow=5000&timestamp=1499827319559"

$hmacsha = New-Object System.Security.Cryptography.HMACSHA256
$hmacsha.key = [Text.Encoding]::ASCII.GetBytes($APISecret)
$signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($QueryString))
$signature = [System.BitConverter]::ToString($signature).Replace('-', '').ToLower()

$uri ="https://api.binance.com/api/v3/account?$QueryString&signature=$signature"

$headers = New-Object"System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-MBX-APIKEY",$APIKey)  

try {

    Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
}

Catch {

    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()
    $ErrResp
}



##DG

$BinanceAPIpoints = 'api.binance.com','api1.binance.com','api2.binance.com','api3.binance.com'

$results = $BinanceAPIpoints | ForEach-Object -Parallel { start-process cmd.exe  -argument "/K PING.EXE $_"  }

Test-NetConnection -Verbose 'api.binance.com' -InformationLevel Detailed


$uri = 'https://api.binance.com' + '/api/v3/time'
https://api1.binance.com
https://api2.binance.com
https://api3.binance.com



function Connect-Binance {
    [CmdletBinding()]
param (
    [Parameter()][TypeName]
    $ParameterName
)

try {

    #Testing
  #Inputs

  $APIKey     = 'wc78LxAtiT6S9bj3q7xMlzw6hYfKTDzqXoAmdNStyjOieP72CGHzvAIqMB7QAs5F'
  $APISecret  = '1J87tpasIodYXUk4lqsEIVpi6926MHC39TDFllbubSsEIS5PyNpnr3u1Vxm7n1fy'

  $uriEndPoint   = '/api/v3/account'
  $QueryString   = ''
  $ExchangeResponse = @()

    #Ensure Time Sync
    $vTimeuri = 'https://api.binance.com/api/v3/time'

    $MySysTime   = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $binanceTime = (Invoke-RestMethod -Uri $vTimeuri -Method Get).servertime
    $MySysTime 
    $binanceTime
    $vTimeDiff =  $MySysTime - $binanceTime

    $NewTimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds() - $vTimeDiff


#Logic
    
    #$TimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()

    if($QueryString){
        write-host "Good"
    }else{
        write-host "Bad"
        $QueryString = "recvWindow=6000&timestamp=" + $NewTimeStamp
    }
    
    
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($APISecret)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($QueryString))
    $signature = [System.BitConverter]::ToString($signature).Replace('-', '').ToLower()
    
    #$uri ="https://api.binance.com/api/v3/account?$QueryString&signature=$signature"
    
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("X-MBX-APIKEY",$APIKey) 
 

    $uriBase       = 'https://api.binance.com'

    $uri = $uriBase + $uriEndPoint + '?' + $QueryString  + '&signature=' + $signature


     $ExchangeResponse = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
     
     $MyBalances = $ExchangeResponse.balances | Select-Object asset, @{N='free';e={[decimal]$_.free}}, @{N='locked';e={[decimal]$_.locked}} 
     $MyBalances = $MyBalances | Where-Object { ($_.free -gt '0') -or ($_.locked -gt '0')  }
     $MyBalances[4].free
     

     Asset,Free,Free-GBP,Locked,Locked-GBP,TotalAsset,TotalGBP,TradingPrice,24Change,LastUpdated
     
     
 #
     $vCurrentPrice = $ExchangeResponse.asks[0][0]

     ($ExchangeResponse.symbols | where-object { $_.symbol -like '*GBP'})[1].filters
     
     | select-object symbol


    #$MyAccount
    try{
}
Catch {
    $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
    $streamReader.Close()
    $ErrResp
}

Finally{
    if($ErrResp){
        $ErrResp
    }else{
        $obj
    }    
}
} #/Function

function Send-BinanceBuy {
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

function Send-BinanceSell {
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

function Get-BinanceWallet {
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

function Get-BinanceSpotTicker {
    [CmdletBinding()]
    param (
        [ValidateNotNull]
        [string]$Symbol = 'BTCGBP'
        
    )
    
    begin {
        
    }
    
    process {
        $TimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    
        $QueryString = "timestamp=" + $TimeStamp
        
        $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
        $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($APISecret)
        $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($QueryString))
        $signature = [System.BitConverter]::ToString($signature).Replace('-', '').ToLower()
        
        $uri ="https://api.binance.com/api/v3/account?$QueryString&signature=$signature"
        
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("X-MBX-APIKEY",$APIKey) 
     
    
        $uriBase       = 'https://api.binance.com'
        $uriEndPoint   = '/api/v3/depth'
        $uriEPspecific = 'symbol=' + $Symbol
        #All Prices
        #/api/v3/ticker/price#
        $uri = $uriBase + $uriEndPoint + '?' + $uriEPspecific
    
    
         $ExchangeResponse = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
         $vCurrentPrice = $ExchangeResponse.asks[0][0]

         write-host $Symbol '=' $vCurrentPrice 

    }
    
    end {
        
    }
}


function Get-TickerTadeHistory {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
  #Inputs

  $APIKey     = 'wc78LxAtiT6S9bj3q7xMlzw6hYfKTDzqXoAmdNStyjOieP72CGHzvAIqMB7QAs5F'
  $APISecret  = '1J87tpasIodYXUk4lqsEIVpi6926MHC39TDFllbubSsEIS5PyNpnr3u1Vxm7n1fy'

  $uriEndPoint   = '/api/v3/historicalTrades'
  $QueryString   = 'symbol=BTCGBP'



  $ExchangeResponse = @()
  $TimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()  

  #$QueryString = "timestamp=" + $TimeStamp
  
  $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
  $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($APISecret)
  $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($QueryString))
  $signature = [System.BitConverter]::ToString($signature).Replace('-', '').ToLower()
  
  #$uri ="https://api.binance.com/api/v3/account?$QueryString&signature=$signature"
  
  $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
  $headers.Add("X-MBX-APIKEY",$APIKey) 


  $uriBase       = 'https://api.binance.com'

  $uri = $uriBase + $uriEndPoint + '?' + $QueryString # + '&signature=' + $signature


   $ExchangeResponse = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
   $ExchangeResponse[11]

    }
    
    end {
        
    }
}

$DGexit = $false
### Main ##

Start-CommanderWindow
    Start-SyncBinanceWallet

if (Connect-Binance){ 
    do {
        Get-BinanceWallet
        Get-BinanceSpotTicker
        Update-TradeStragigy
        Send-BinanceSell
        Send-BinanceBuy
        Start-Sleep -Seconds 30  
    } until ($DGexit -eq $true)

}else {
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "Error Connecting to Binance"

} #/ Connect-Binance


