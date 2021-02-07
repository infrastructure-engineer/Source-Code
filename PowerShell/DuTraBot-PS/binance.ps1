<#
.Synopsis
        Ported Binance Module
.


#>



$ENDPOINT   = "https://www.binance.com"

$BUY        = "BUY"
$SELL       = "SELL"

$LIMIT      = "LIMIT"
$MARKET     = "MARKET"

$GTC        = "GTC"
$IOC        = "IOC"


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
        [String[]]$APISECRET,       
    )
    

        
    
}

