

Clear-Host

[float]$vWallet = "222"
[float]$vCrypto = "88"

$vInput = "1000","1002","1003","1004","1120","1010","1011","1000","950","990","1010"


[float]$vPrice = "1001"
[float]$vPrevGoal = "1000"
$vLastAction = "HOLD"

$vPriceLine =@()

foreach($vPrice in $vInput){

    #Write-Host $vprice "`t`t" -NoNewline
    
    $vTicker = [math]::Round(($vPrice * (9 /100)),2)
    #Write-Host $vTicker  "`t`t" -ForegroundColor Yellow -NoNewline

    [float]$vPriceGoal = [math]::Round($vTicker + $vPrice,2)
    #Write-Host $vPriceGoal  "`t`t" -ForegroundColor Cyan -NoNewline

    #Logic
    # ( [math]::Round(($vPrevGoal * (6 / 100)),2)  )

    if( $vPrice -gt $vPrevGoal ){
        $vAction = "SELL"
    }elseif ((( $vLastAction -eq "SELL" ) -or ( $vLastAction -eq "HOLD" )) -and ( $vPrice -lt 1000 )) {
        $vAction = "BUY"
    }else {
        $vAction = "HOLD"
    }

    #Action
    switch ($vAction) {
        SELL { $vMSG = "Sell - Target Hit" ; if($vCrypto -gt 0){ $vWallet = ($vWallet + $vCrypto); $vCrypto = 0 }}
        HOLD { $vMSG = "Hold ##" }
        BUY  { $vMSG = "Buy - Adding another 10%" ; $vCrypto =  [math]::Round(($vWallet * ( 10 /100)),2)  ;  $vWallet = $vWallet - $vCrypto }
    }


    #Write-Host $vCrypto "`t" -ForegroundColor Magenta -NoNewline
    #Write-Host $vWallet "`t"-ForegroundColor Blue -NoNewline
    #Write-Host $vMSG -ForegroundColor Green

    $vPriceLine += [PSCustomObject]@{
        CurrentPrice = $vprice
        Ticker       = $vTicker
        PriceGoal    = $vPriceGoal
        CryptoWallet = $vCrypto 
        GBPwallet    = $vWallet
        Message      = $vMSG

    }

    
    $vPrevGoal = $vPriceGoal
    $vLastAction = $vAction
}

$vPriceLine | Format-Table 

$vPriceLine.Add("1200","120","1500","31","279","Test")

$vPriceLine | gm

