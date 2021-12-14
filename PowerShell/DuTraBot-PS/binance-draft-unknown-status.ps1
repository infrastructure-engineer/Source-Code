
<#
.Synopsis
    Duane's Trading Bot - On binance
.Description  
    ### Main ##
    Start-CommanderWindow    
    if (Connect-Binance){ 
        do {
            Get-BinanceWallet
            Get-BinanceSpotTicker
            Update-TradeStragigy
            Send-BinanceSell
            Send-BinanceBuy
            Start-Sleep -Seconds 30  
        } until ($DGexit -eq $true)
#>

#API Credentials
$vAPIKey     = 'wc78LxAtiT6S9bj3q7xMlzw6hYfKTDzqXoAmdNStyjOieP72CGHzvAIqMB7QAs5F'
$vAPISecret  = '1J87tpasIodYXUk4lqsEIVpi6926MHC39TDFllbubSsEIS5PyNpnr3u1Vxm7n1fy'

#Set HTPPS Header
$vHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$vHeaders.Add("X-MBX-APIKEY",$vAPIKey)    

#Endpoint Rule Details Hash Table
$Global:vEndPoint = @{ 

#General endpoints

    Time = @{
            Description  = 'Check Server Time'
            Method       = 'GET'
            Endpoint     = '/api/v3/time'
            SecAPIKEY    = $false
            SecSignature = $false
    } #/Time

    exchangeInfo= @{
            Description  = 'Exchange information'
            Method       = 'GET'
            Endpoint     = '/api/v3/exchangeInfo'
            SecAPIKEY    = $false
            SecSignature = $false
    } #/exchangeInfo

#Market Data endpoints

    depth = @{
            Description  = 'Order book'
            Method       = 'GET'
            Endpoint     = '/api/v3/depth'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/depth


    trades = @{
            Description  = 'Recent trades list'
            Method       = 'GET'
            Endpoint     = '/api/v3/trades'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/trades

    aggTrades = @{
            Description  = 'Compressed/Aggregate trades list'
            Method       = 'GET'
            Endpoint     = '/api/v3/aggTrades'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/aggTrades

    klines = @{
            Description  = 'Candlestick data'
            Method       = 'GET'
            Endpoint     = '/api/v3/klines'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/klines

    avgPrice = @{
            Description  = 'Current average price'
            Method       = 'GET'
            Endpoint     = '/api/v3/avgPrice'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/avgPrice

    Ticker24hr = @{
            Description  = '24hr ticker price change statistics'
            Method       = 'GET'
            Endpoint     = '/api/v3/ticker/24hr'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/24hr

    price = @{
            Description  = 'Symbol price ticker'
            Method       = 'GET'
            Endpoint     = '/api/v3/ticker/price'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/price

    bookTicker = @{
            Description  = 'Symbol order book ticker'
            Method       = 'GET'
            Endpoint     = '/api/v3/ticker/bookTicker'
            SecAPIKEY    = $true
            SecSignature = $false
    } #/bookTicker

#Account endpoints
    NewOrder = @{
            Description  = 'New order'
            Method       = 'POST'
            Endpoint     = '/api/v3/order'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/NewOrder

    OrderTest= @{
            Description  = 'Test new order'
            Method       = 'POST'
            Endpoint     = '/api/v3/order/test'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/OrderTest

    order = @{
            Description  = 'Query order'
            Method       = 'GET'
            Endpoint     = '/api/v3/order'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/order

    CancelOrder= @{
            Description  = 'Cancel order'
            Method       = 'DELETE'
            Endpoint     = '/api/v3/order'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/CancelOrder

    CancelAllopenOrders = @{
            Description  = 'Cancel All Open Orders on a Symbol'
            Method       = 'DELETE'
            Endpoint     = '/api/v3/openOrders'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/CancelAllopenOrders

    GetAllopenOrders = @{
            Description  = 'Current open orders'
            Method       = 'GET'
            Endpoint     = '/api/v3/openOrders'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/GetAllopenOrders

    allOrders = @{
            Description  = 'All orders'
            Method       = 'GET'
            Endpoint     = '/api/v3/allOrders'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/allOrders

    Account = @{
            Description  = 'Get Account Information'
            Method       = 'GET'
            Endpoint     = '/api/v3/account'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/Acccount

    myTrades = @{
            Description  = 'Account trade list'
            Method       = 'GET'
            Endpoint     = '/api/v3/myTrades'
            SecAPIKEY    = $true
            SecSignature = $true
    } #/myTrades

} #/vEndpoint


#Optimising EndPoint
$vBinanceAPIpoints = 'api.binance.com','api1.binance.com','api2.binance.com','api3.binance.com'

$vBestEndpoint = $vBinanceAPIpoints | ForEach-Object -Parallel { Test-NetConnection $_  } | `
                                    sort-object -Property {$_.PingReplyDetails.RoundtripTime} -Descending | `
                                    Select-object -last 1 -ExpandProperty computername

$Global:vUriBase = 'https://' + $vBestEndpoint 

$Global:vTimeUri = $vUriBase + $vEndPoint.Item("Time").Endpoint

$vSpotList = @("BTCGBP","BNBGBP","ETHGBP","GBPBUSD","ETHBUSD","BNBBUSD","BTCBUSD","ETHBTC","BNBBTC","ETHBNB","BNBETH")

$vSpotResults = @()

############################   Functions  ############################

function Initialize-CryptoDB {
    [CmdletBinding()]
    param (
        [Parameter()][string]$path = 'C:\ProgramData\CryptoDB'
    )

    $Global:vWalletFile     = $path + '\' + "Wallet.CSV"
    $Global:vCommanderFile  = $path + '\' + "Commander.CSV"
    $Global:vErrorFile      = $path + '\' + "Error.CSV"
    $Global:vOperationsFile = $path + '\' + "Operations.CSV"
    $Global:vSpotResultFile = $path + '\' + "SpotResult.CSV"

    if( Test-Path -Path $path ){}else{ New-Item -Path $path -Force -ItemType Directory }
    if( Test-Path -Path $vErrorFile ){}else{ New-Item -Path $path -Force -ItemType File -Name "Error.CSV" }
    if( Test-Path -Path $vWalletFile ){}else{  New-Item -Path $path -Force -ItemType File -Name "Wallet.CSV"}
    if( Test-Path -Path $vCommanderFile ){}else{ New-Item -Path $path -Force -ItemType File -Name "Commander.CSV" }
    if( Test-Path -Path $vOperationsFile ){}else{ New-Item -Path $path -Force -ItemType File -Name "Operations.CSV" }
    if( Test-Path -Path $vSpotResultFile ){}else{ New-Item -Path $path -Force -ItemType File -Name "SpotResult.CSV" }

} #/Initialize-CryptoDB

#Initialize and connect to CryptoDB
Initialize-CryptoDB

function Get-BinanceWallet {
    [CmdletBinding()]

#Static

    #Variables
    $vQueryString   = ''
    $vExchangeResponse = @()

#Logic
   
    #Time
    $vMySystemTime  = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $vBinanceTime   = (Invoke-RestMethod -Uri $vTimeUri -Method Get).servertime

    $vTimeDiff =  $vMySystemTime - $vBinanceTime
    $vTimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds() - $vTimeDiff

    #Query String
    $vQueryString = "recvWindow=6000&timestamp=" + $vTimeStamp
            
    #Compute Signature
    $vHmacsha     = New-Object System.Security.Cryptography.HMACSHA256
    $vHmacsha.key = [Text.Encoding]::ASCII.GetBytes($vAPISecret)
    $vSignature   = $vHmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($vQueryString))
    $vSignature   = [System.BitConverter]::ToString($vSignature).Replace('-', '').ToLower()

    #Construct URI
    $vUri = $vUriBase + $vEndPoint.Item("Account").Endpoint  + '?' + $vQueryString  + '&signature=' + $vSignature

    try{

        $vExchangeResponse = Invoke-RestMethod -Uri $vUri -Headers $vHeaders -Method $vEndPoint.Item("Account").method 
    
    }#/Try

    Catch {

            Write-Error ("ERROR occurred: $($_.Exception.Message)`r`n" + "Response body:`r`n$($_.ToString())")

    } #/Catch

Finally{

    $MyBalances = $vExchangeResponse.balances | Select-Object asset, @{N='free';e={[decimal]$_.free}}, @{N='locked';e={[decimal]$_.locked}} | Where-Object { ($_.free -gt '0') -or ($_.locked -gt '0')  }
    $MyFullBalances = $MyBalances | Select-Object Asset,Free,FreeinGBP,Locked,LockedinGBP,@{N='TotalAsset';E={ $_.free + $_.locked }},TotalinGBP,TradingPrice,24Change,LastUpdated  | Sort-Object Asset
    $MyFullBalances
    }#/Finally
} #/Function

#Call Function and Output to DB
$vWalletResult = Get-BinanceWallet 

function Get-BinanceSpotTicker {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string[]]$Symbols        
    )
    
    begin {

        #Static 
        $vResult = @()

        #Variables
        $vExchangeResponse = @()
        $vUri = $vUriBase + $vEndPoint.Item("price").Endpoint 

        try{
            $vExchangeResponse = Invoke-RestMethod -Uri $vUri -Headers $vHeaders -Method ($vEndPoint.Item("price").method)         
            }#/Try

        Catch {
                Write-Error ("ERROR occurred: $($_.Exception.Message)`r`n" + "Response body:`r`n$($_.ToString())")
        } #/Catch
    
    } #begin
    
    process {

        $vResult += $vExchangeResponse.Where({$_.symbol -like $Symbols})      

    } #/Process
    
    end {
        $vResult | Select-Object symbol, @{N='price';e={[decimal]$_.price}}


    } #/end
} #/ Get-BinanceSpotTicker

#Call Function
$vSpotResults = $vSpotList | Get-BinanceSpotTicker 
$vSpotResults | export-csv -path $vSpotResultFile -NoTypeInformation



#Update Wallet DB
foreach ($line in $vSpotResults){
    $vAsset = ($line.symbol).Substring(0,3)
    if($vAsset -eq 'GBP'){
        ($vWalletResult | Where-object { $_.asset -like 'BUSD'}).TradingPrice = $line.price
    }
    else{
        ($vWalletResult | Where-object { $_.asset -like $vAsset}).TradingPrice = $line.price
    }
}

foreach($vline in $vWalletResult ){
    if($vline.TradingPrice){
        if($vline.free){
            $vline.FreeinGBP = [Math]::Round(($vline.free * $vline.TradingPrice),2)
        }elseif (vline.locked){
            $vline.LockedinGBP = [Math]::Round(($vline.locked * $vline.TradingPrice),2)
        } 
        $vline.TotalinGBP = [Math]::Round(($vline.FreeinGBP + $vline.LockedinGBP),2)
        
    }
}

#Write DB to Disk
try{
    $vWalletResult | Export-csv -path $vWalletFile -NoTypeInformation -Force
    $vWalletResult | Format-Table -AutoSize
}catch{
    Write-Error "Unable to write to CryptoDB"
}


function Get-TickerTadeHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$asset #='btc'
    )
    
    begin {       
        
    } #/begin
    
    process {

        $vQueryString   = 'symbol=' + $asset
        
        $vHmacsha = New-Object System.Security.Cryptography.HMACSHA256
        $vHmacsha.key = [Text.Encoding]::ASCII.GetBytes($vAPISecret)
        $vSignature = $vHmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($vQueryString))
        $vSignature = [System.BitConverter]::ToString($vSignature).Replace('-', '').ToLower()
        
        $vUri = $vUriBase + $vEndPoint.Item("depth").Endpoint + '?' + $QueryString  + '&signature=' + $signature

        #Query Exchange 
        try{
            $vExchangeResponse = Invoke-RestMethod -Uri $vUri -Headers $vHeaders -Method $vEndPoint.Item("depth").method        
        }#/Try    
        Catch {    
            Write-Error ("ERROR occurred: $($_.Exception.Message)`r`n" + "Response body:`r`n$($_.ToString())")    
        } #/Catch
        $vExchangeResponse

    } #/process
    
    end {
        
    } #/end
} #/Get-TickerTadeHistory

Get-TickerTadeHistory -asset btc




   #Logic
function Send-SignedRequest {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]

    param (
        [Parameter(Mandatory=$true)][string]$EndpointName,
        [Parameter(Mandatory=$true)][string]$QueryString        
    )

    process {
        #Time
        $vMySystemTime  = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
        $vBinanceTime   = (Invoke-RestMethod -Uri $vTimeUri -Method Get).servertime

        $vTimeDiff =  $vMySystemTime - $vBinanceTime
        $vTimeStamp = [DateTimeOffset]::Now.ToUnixTimeMilliseconds() - $vTimeDiff

        #Query String
        $vQueryString =  $QueryString + "&recvWindow=5000&timestamp=" + $vTimeStamp
                
        #Compute Signature
        $vHmacsha     = New-Object System.Security.Cryptography.HMACSHA256
        $vHmacsha.key = [Text.Encoding]::ASCII.GetBytes($vAPISecret)
        $vSignature   = $vHmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($vQueryString))
        $vSignature   = [System.BitConverter]::ToString($vSignature).Replace('-', '').ToLower()

        #Construct URI
        $vUri = $vUriBase + $vEndPoint.Item($EndpointName).Endpoint  + '?' + $vQueryString  + '&signature=' + $vSignature

        
        try{

            $vExchangeResponse = Invoke-RestMethod -Uri $vUri -Headers $vHeaders -Method $vEndPoint.Item($EndpointName).method 
        
        }#/Try

        Catch {
            Write-Error ("ERROR occurred: $($_.Exception.Message)`r`n" + "Response body:`r`n$($_.ToString())")

        } #/Catch

        Finally{
            $vExchangeResponse
        } #/Finally    
    
    } #/process

}

function Send-Request {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]

    param (
        [Parameter(Mandatory=$true)][string]$EndpointName,
        [Parameter(Mandatory=$true)][string]$QueryString        
    )

    process { 

        #Construct URI
        $vUri = $vUriBase + $vEndPoint.Item($EndpointName).Endpoint  + '?' + $QueryString  
        
        try{
            $vExchangeResponse = Invoke-RestMethod -Uri $vUri -Headers $vHeaders -Method $vEndPoint.Item($EndpointName).method         
        } #/Try

        Catch {
            Write-Error ("ERROR occurred: $($_.Exception.Message)`r`n" + "Response body:`r`n$($_.ToString())")
            $vExchangeResponse= 'ERROR'
        } #/Catch

        Finally{
            $vExchangeResponse
        } #/Finally    
    
    } #/process

}

function Submit-Trade {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (        
        [Parameter(Mandatory=$true)][string]$Symbol         = 'NXSBTC',
        [Parameter(Mandatory=$true)][string]$Side           = 'BUY',
        [Parameter(Mandatory=$true)][string]$Type           = 'LIMIT',
        [Parameter(Mandatory=$true)][string]$TimeInForce    = 'GTC',
        [Parameter(Mandatory=$true)][string]$Quantity       = '10',
        [Parameter(Mandatory=$true)][string]$Price          = '0.00001900'
        )

    $vNewOrder = "symbol=" + $symbol + "&side=" + $side + "&type=" + $Type + "&timeInForce=" + $timeInForce + "&quantity=" + $quantity + "&price=" + $price 

    Send-SignedRequest -EndpointName NewOrder -QueryString $vNewOrder

} #/function Submit-Trade

Submit-Trade


function Get-Depth {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (        
        [Parameter(Mandatory=$true)][string]$Symbol                                                             = 'NXSBTC',
        [Parameter(Mandatory=$false)][ValidateSet('5','10','20','50','100','500','1000','5000')][string]$Limit  = '100'        
        )

    $vNewOrder = "symbol=" + $Symbol + "&limit=" + $Limit

    $obj1 = Send-Request -EndpointName Depth -QueryString $vNewOrder

    $obj1 | fl *

    $obj2 = $obj1.bids | select-object @{N='Symbol';E={ $Symbol }}, @{N='Market';E={'Bids'}}, @{N='Price';E={ [decimal]$_[0] }}, @{N='QTY';E={ [decimal]$_[1] }}
    $obj3 = $obj1.asks | select-object @{N='Symbol';E={ $Symbol }}, @{N='Market';E={'Asks'}}, @{N='Price';E={ [decimal]$_[0] }}, @{N='QTY';E={ [decimal]$_[1] }}

    $obj4 = $obj2 + $obj3 | Sort-Object -Descending Price

    $obj4

} #/function Submit-Trade

$DepthObj = Get-Depth -Symbol NXSBTC -Limit 100

$DepthObj | Where-object {$_.QTY -gt 500} | Where-object {$_.Market -eq 'Asks'}








### Main ##

Initialize-CryptoDB

Start-CommanderWindow



if (Connect-Binance){ 
    do {
        Get-BinanceWallet
        Get-BinanceSpotTicker
        Update-TradeStragigy -PrimaryStragigy Big6
        Send-BinanceSell
        Send-BinanceBuy
        Start-Sleep -Seconds 30  
    } until ($DGexit -eq $true)

}else {
    Write-Host -ForegroundColor Red -BackgroundColor Yellow "Error Connecting to Binance"

} #/ Connect-Binance


