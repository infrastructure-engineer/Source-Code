
#Configure Window 

$pshost                 = get-host
$pswindow               = $pshost.ui.rawui
$pswindow.WindowTitle   = 'PWSH DuTraBot'
$newsize                = $pswindow.buffersize
$newsize.height         = 3000
$newsize.width          = 150
$pswindow.buffersize    = $newsize
$newsize                = $pswindow.windowsize
$newsize.height         = 50
$newsize.width          = 150
$pswindow.windowsize    = $newsize

#Functions

function Show-Menu{
    param (
        [string]$Title = 'PWSH DuTraBot'
    )
    $Data = import-csv -path .\wallet.csv
    Clear-Host
    Write-Host "=================== $Title ===================="
    Write-Host "" 
    Write-Host "1: Press '1' For Market Crash !! All Crypto To GBP !!"
    Write-Host "3: Press '3' For All Reserve GBP to BTC - Bitcoin"
    Write-Host "5: Press '5' For All Reserve GBP to ETH - Etherium"
    Write-Host "7: Press '7' For All Reserve GBP to BNB - Binance Coin"
    Write-Host "9: Press '9' For All Reserve GBP to LTC - LiteCoin"
    Write-Host ""
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
    Write-Host "================== WALLET  STATUS ===================="
    Write-Host ""
    $Data |  Format-Table -AutoSize -Wrap -Property Asset,Free,Free-GBP,Locked,Locked-GBP,TotalAsset,TotalGBP,TradingPrice,24Change
    Write-Host "------------------------------------------------------"
    Write-Host "TOTAL GBP : £"($Data.TotalGBP | Measure-Object -Sum).Sum
    Write-Host ""
    Write-Host "LastUpdated : " (get-date -UnixTimeSeconds ($Data[0].LastUpdated).SubString(0,10))
    Write-Host "======================================================"

}

#Main Logic

do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
        '1' {
             'You chose option #1'
             } 
        
        '3' {
             'You chose option #3'
            }
        
        '5' {
             'You chose option #5'
            }
        '7' {
             'You chose option #7'
            }

        '9' {
             'You chose option #9'
            }


     }
     start-sleep -seconds 5
 }
 until ( ($selection -eq 'q'))

 Clear-Host
 Write-Host -ForegroundColor Yellow "!!! Program Succesfully Exited !!!"

 #EOF
