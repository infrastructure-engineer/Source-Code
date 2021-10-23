
#Current User Profile & Security Information
[Security.Principal.WindowsIdentity]::GetCurrent()

import-module dbatools

#Get List of commands
#get-command -Module dbatools -Name '*table*'

$credSQLsa      = Get-Credential
$SqlInstance    = '192.168.0.39\SQLEXPRESS'                                            # SQL Server name 
$dbName         = 'CryptoTradingDB2'                                                    # database name

try {
    $dbObject = Get-DbaDatabase -SqlInstance $SqlInstance -SqlCredential $credSQLsa -Database $dbName
}
catch {}     

if($dbObject){
    Write-Host "SUCCESS: Can Connect to Database '$($dbName)' | $(get-date)" -ForegroundColor Green
    }
Else{
        Write-Host "ERROR  : Database '$($dbName)' not found. | $(get-date)" -ForegroundColor Red
        Write-Host "ACTION : Creating Database '$($dbName)' | $(get-date)" -ForegroundColor Yellow

        $DataFilePath       = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA'  # data file path
        $LogFilePath        = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA'  # log file path
        $Recoverymodel      = 'Simple'                                                               # recovery model
        $Owner              = 'sa'                                                                   # database owner
        $PrimaryFilesize    = 64                                                                     # data file initial size
        $PrimaryFileGrowth  = 64                                                                     # data file autrogrowth amount
        $LogSize            = 32                                                                     # data file initial size
        $LogGrowth          = 16                                                                     # data file autrogrowth amount
        
        try {
            New-DbaDatabase -SqlInstance $SqlInstance -Name $dbName -DataFilePath $DataFilePath -LogFilePath $LogFilePath -Recoverymodel $Recoverymodel -Owner $Owner -PrimaryFilesize $PrimaryFilesize -PrimaryFileGrowth $PrimaryFileGrowth -LogSize $LogSize -LogGrowth $LogGrowth -SqlCredential $credSQLsa | Out-Null        
        }
        catch {
            $_
            break
            }

        try {
            $dbObject = Get-DbaDatabase -SqlInstance $SqlInstance -SqlCredential $credSQLsa -Database $dbName
            Write-Host "SUCCESS: Can Connect to Database '$($dbName)' | $(get-date)" -ForegroundColor Green
        }
        catch {
            $_
            break
        }        
    } #/Else



$cols = @()
# Add columns to collection
$cols += @{
  Name      = 'testId'
      Type      = 'int'
      Identity  = $true
  }
$cols += @{
      Name      = 'test'
      Type      = 'varchar'
      MaxLength = 20
      Nullable  = $true
  }
 $cols += @{
      Name      = 'test2'
      Type      = 'int'
      Nullable  = $false
  }
 $cols += @{
      Name      = 'test3'
      Type      = 'decimal'
      MaxLength = 9
      Nullable  = $true
  }
 $cols += @{
      Name      = 'test4'
      Type      = 'decimal'
      Precision = 8
      Scale = 2
      Nullable  = $false
  }
 $cols += @{
      Name      = 'test5'
      Type      = 'Nvarchar'
      MaxLength = 50
      Nullable  =  $false
      Default  =  'Hello'
      DefaultName = 'DF_Name_test5'
  }
 $cols += @{
      Name      = 'test6'
      Type      = 'int'
      Nullable  =  $false
      Default  =  '0'
  }
 $cols += @{
      Name      = 'test7'
      Type      = 'smallint'
      Nullable  =  $false
      Default  =  100
  }
 $cols += @{
      Name      = 'test8'
      Type      = 'Nchar'
      MaxLength = 3
      Nullable  =  $false
      Default  =  'ABC'
  }
 $cols += @{
      Name      = 'test9'
      Type      = 'char'
      MaxLength = 4
      Nullable  =  $false
      Default  =  'XPTO'
  }
 $cols += @{
      Name      = 'test10'
      Type      = 'datetime'
      Nullable  =  $false
      Default  =  'GETDATE()'
  }

$dbObject | New-DbaDbTable -Name 'FirstTable' -ColumnMap 




### SQLite Development ###


#Get SQLite Binary
$vUri       = "http://system.data.sqlite.org/blobs/1.0.113.0/sqlite-netFx40-static-binary-bundle-x64-2010-1.0.113.0.zip"
$vTempFile = $env:TEMP + "\SQLite.zip"
Invoke-WebRequest -Uri $vUri -Method Get -OutFile $vTempFile
Expand-Archive -Path $vTempFile -DestinationPath C:\Temp\sqlite -Force


"https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.12.1/DB.Browser.for.SQLite-3.12.1-win64.zip"





#load
Add-Type -Path "C:\Temp\sqlite\System.Data.SQLite.dll"

#Connect to SQLlite DB
$con = New-Object -TypeName System.Data.SQLite.SQLiteConnection
$con.ConnectionString = "Data Source=C:\temp\test.db"
$con.Open()


#create table 
$sql = $con.CreateCommand()
$sql.CommandText = 'CREATE TABLE "Botsettings" ("ID" INTEGER NOT NULL, "APIkey"	TEXT, "APIsecret" TEXT,	PRIMARY KEY("ID") );'
$adapter = New-Object -TypeName System.Data.SQLite.SQLiteDataAdapter $sql
$data = New-Object System.Data.DataSet
[void]$adapter.Fill($data)

$sql.CommandText = 'DROP TABLE "mysettings";'

$sql.ExecuteNonQuery()

$sql.



$sql.Dispose()
$con.Close()



# Grab the SQLite3 DLL here:
#    https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki
#
# PowerShell SQLite DB example.
# C. Nichols <mohawke@gmail.com>, Aug. 2019
# Make sure to change DLL, database, and log file paths.
  
Add-Type -Path "C:\Temp\sqlite\System.Data.SQLite.dll" # Change path
  
Function createDataBase([string]$db) {
    Try {
        If (!(Test-Path $db)) {
        
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
  
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            # TEXT as ISO8601 strings ('YYYY-MM-DD HH:MM:SS.SSS')
            # ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, INSERT NULL to increment.
            $createTableQuery = "CREATE TABLE printer_usage (
                                        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                                        printed_dt        TEXT    NULL,
                                        printed_tm        TEXT    NULL,
                                        printed_doc_nm    TEXT    NULL,
                                        printed_doc_sz    INTEGER NULL,
                                        printed_page_cnt  INTEGER NULL,
                                        print_user_id     TEXT    NULL,
                                        print_user_comp   TEXT    NULL,
                                        print_serv_nm     TEXT    NULL,
                                        printer_nm        TEXT    NULL
                                        );"
            $createUniqueIndex = "CREATE UNIQUE INDEX print_idx ON printer_usage(printed_dt, printed_tm, print_user_id, printed_doc_nm);"
  
  
            $CMD = $CONN.CreateCommand()
            $CMD.CommandText = $createTableQuery
            $CMD.ExecuteNonQuery()
            $CMD.CommandText = $createUniqueIndex
            $CMD.ExecuteNonQuery()
  
            $CMD.Dispose()
            $CONN.Close()
            Log-It "Create database and table: Ok"
  
        } Else {
            Log-It "DB Exists: Ok"
        }
  
    } Catch {
        Log-It "Could not create database: Error"
    }
}
  
Function queryDatabase([string]$db, [string]$sql) {
  
    Try {
        If (Test-Path $db) {
  
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            $CMD = $CONN.CreateCommand()
            $CMD.CommandText = $sql
  
            $ADAPTER = New-Object  -TypeName System.Data.SQLite.SQLiteDataAdapter $CMD
            $DATA = New-Object System.Data.DataSet
  
            $ADAPTER.Fill($DATA)
  
            $TABLE = $DATA.Tables
  
            ForEach ($t in $TABLE){
                Write-Output $t
            }
  
            $CMD.Dispose()
            $CONN.Close()
  
        } Else {
            Log-It "Unable to find database: Query Failed"
        }
  
    } Catch {
        Log-It "Unable to query database: Error"
    }
}
  
Function insertDatabase([string]$db, [System.Collections.ArrayList]$rows) {
  
    Try {
        If (Test-Path $db) {
        
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
  
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            $CMD = $CONN.CreateCommand()
            #$Counter = 0
            ForEach($row in $rows) {
        
                $sql = "INSERT OR REPLACE INTO printer_usage (ID,printed_dt,printed_tm,printed_doc_nm,printed_doc_sz,printed_page_cnt,print_user_id,print_user_comp,print_serv_nm,printer_nm)"
                $sql += " VALUES (@ID,@printed_dt,@printed_tm,@printed_doc_nm,@printed_doc_sz,@printed_page_cnt,@print_user_id,@print_user_comp,@print_serv_nm,@printer_nm);"
                 
                $CMD.Parameters.AddWithValue("@ID", $NULL)
                $CMD.Parameters.AddWithValue("@printed_dt", $row.printed_dt)
                $CMD.Parameters.AddWithValue("@printed_tm", $row.printed_tm)
                $CMD.Parameters.AddWithValue("@printed_doc_nm", $row.printed_doc_nm)
                $CMD.Parameters.AddWithValue("@printed_doc_sz", $row.printed_doc_sz)
                $CMD.Parameters.AddWithValue("@printed_page_cnt", $row.printed_page_cnt)
                $CMD.Parameters.AddWithValue("@print_user_id", $row.print_user_id)
                $CMD.Parameters.AddWithValue("@print_user_comp", $row.print_user_comp)
                $CMD.Parameters.AddWithValue("@print_serv_nm", $row.print_serv_nm)
                $CMD.Parameters.AddWithValue("@printer_nm", $row.printer_nm)
  
                Write-Output $sql

                $sql = "DROP TABLE printer_usage;"
  
                $CMD.CommandText = $sql
                $CMD.ExecuteNonQuery()
                #$Counter += 1
            }
  
            $CMD.Dispose()
            $CONN.Close()
  
            Log-It "Inserted records successfully: Ok"
  
        } Else {
            Log-It "Unable to find database: Insert Failed"
        }
  
    } Catch {
        Log-It "Unable to insert into database: Error"
    }
}
  
Function Log-It([string]$logLine)
{
    $LogPath = "c:\temp\sqlite.log" # Change path
    $NewLine = "`r`n"
  
    $Line = "{0}{1}" -f $logLine, $NewLine
    if ($logPath) {
        write-output $Line
        $Line | Out-File $logPath -Append
    } else {
        write-output $Line
    }
}
  
# ******** MAIN ********
$DB = 'C:\temp\DuTraBot.db'
$DBPath = 'C:\temp\DuTraBot.db' # Change path
$Rows = New-Object System.Collections.ArrayList


  
$CDate = Get-Date -format "yyyy-MM-dd"
$CTime = Get-Date -format "HH:mm:ss"

$vAPIKey     = 'wc78LxAtiT6S9bj3q7xMlzw6hYfKTDzqXoAmdNStyjOieP72CGHzvAIqMB7QAs5F'
$vAPISecret  = '1J87tpasIodYXUk4lqsEIVpi6926MHC39TDFllbubSsEIS5PyNpnr3u1Vxm7n1fy'


$Rows.Add(@{"Binance_API_Date" =$CDate ;"Binance_API_Time"= $CTime;"Binance_API_APIkey" = $vAPIKey;"Binance_API_APIsecret" = $vAPISecret })
  
# Fake Records
$Rows.Add(@{'printed_dt'=$CDate; 'printed_tm'= $CTime; 'printed_doc_nm'='test3.txt'; 'printed_doc_sz'=10; 'printed_page_cnt'=10; 'print_user_id'='nich12'; 'print_user_comp'='m123'; 'print_serv_nm'='printA'; 'printer_nm'='l52'})
$Rows.Add(@{'printed_dt'=$CDate; 'printed_tm'= $CTime; 'printed_doc_nm'='test3.doc'; 'printed_doc_sz'=20; 'printed_page_cnt'=12; 'print_user_id'='ward32'; 'print_user_comp'='m234'; 'print_serv_nm'='printA'; 'printer_nm'='l67'})
$Rows.Add(@{'printed_dt'=$CDate; 'printed_tm'= $CTime; 'printed_doc_nm'='test3.ps1'; 'printed_doc_sz'=30; 'printed_page_cnt'=14; 'print_user_id'='jame67'; 'print_user_comp'='m345'; 'print_serv_nm'='printB'; 'printer_nm'='l87'})
  
$Query = "Select * From printer_usage"
  
# Create Db and Table.
createDataBase $DBPath
  
# Insert records.
insertDatabase $DBPath $Rows


  
# Fetch records.
queryDatabase $DBPath $Query




CREATE TABLE "Table_Binance_API" (
	"ID"	INTEGER NOT NULL,
    "Binance_API_Date"	TEXT,
    "Binance_API_Time"	TEXT,
	"Binance_API_APIkey"	TEXT,
	"Binance_API_APIsecret"	TEXT,
	PRIMARY KEY("ID" )
);


CREATE TABLE "Table_Binance_Wallet" (
	"ID"	INTEGER NOT NULL,
    "Binance_Wallet_Date"	TEXT,
    "Binance_Wallet_Time"	TEXT,
	"Binance_Wallet_Asset"	TEXT,
	"Binance_Wallet_Free"	TEXT,
    "Binance_Wallet_FreeGBP"	TEXT,
    "Binance_Wallet_Locked"	TEXT,
    "Binance_Wallet_LockedGBP"	TEXT,
    "Binance_Wallet_TotalAsset"	TEXT,
    "Binance_Wallet_TotalAssetGBP"	TEXT,
    "Binance_Wallet_TradingPrice"	TEXT,
    "Binance_Wallet_24hChange"	TEXT,

	PRIMARY KEY("ID")
);


CREATE TABLE "Table_Binance_Trades" (
	"ID"	INTEGER NOT NULL,
	"Binance_Trades_Date"	TEXT,
	"Binance_Trades_Time"	TEXT,
    "Binance_Trades_Asset"	TEXT,
    "Binance_Trades_BuySell"	TEXT,
    "Binance_Trades_PairAsset"	TEXT,
    "Binance_Trades_Amount"	TEXT,
    "Binance_Trades_AmountGBP"	TEXT,
    "Binance_Trades_SpotPrice"	TEXT,
    "Binance_Trades_Logic"	TEXT,
	PRIMARY KEY("ID")
);


CREATE TABLE "Table_Binance_SpotResults" (
	"ID"	INTEGER NOT NULL,
	"Binance_SpotResults_Date"	TEXT,
	"Binance_SpotResults_Time"	TEXT,
    "Binance_SpotResults_Symbol"	TEXT,
    "Binance_SpotResults_Price"	TEXT,
	PRIMARY KEY("ID")
);



$Row = New-Object System.Collections.ArrayList  
$CDate = Get-Date -format "yyyy-MM-dd"
$CTime = Get-Date -format "HH:mm:ss"
$vAPIKey     = 'wc78LxAtiT6S9bj3q7xMlzw6hYfKTDzqXoAmdNStyjOieP72CGHzvAIqMB7QAs5F'
$vAPISecret  = '1J87tpasIodYXUk4lqsEIVpi6926MHC39TDFllbubSsEIS5PyNpnr3u1Vxm7n1fy'

$Row.Add(@{"Binance_API_Date" = $CDate ;"Binance_API_Time"= $CTime;"Binance_API_APIkey" = $vAPIKey;"Binance_API_APIsecret" = $vAPISecret })



$CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection  
$CONN.ConnectionString = "Data Source=$db"
$CONN.Open()

$CMD = $CONN.CreateCommand()
#$Counter = 0
    $sql = "INSERT OR REPLACE INTO Table_Binance_API (ID,Binance_API_Date,Binance_API_Time,Binance_API_APIkey,Binance_API_APIsecret)"
    $sql += " VALUES (@ID,@Binance_API_Date,@Binance_API_Time,@Binance_API_APIkey,@Binance_API_APIsecret);"
     
    $CMD.Parameters.AddWithValue("@ID", $NULL)
    $CMD.Parameters.AddWithValue("@Binance_API_Date", $row.Binance_API_Date)
    $CMD.Parameters.AddWithValue("@Binance_API_Time", $row.Binance_API_Time)
    $CMD.Parameters.AddWithValue("@Binance_API_APIkey", $row.Binance_API_APIkey)
    $CMD.Parameters.AddWithValue("@Binance_API_APIsecret", $row.Binance_API_APIsecret)

    Write-Output $sql



    $CMD.CommandText = $sql
   # $CMD.CommandText = "SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%';"

    $CMD.ExecuteNonQuery()
    #$Counter += 1

    $ADAPTER = New-Object  -TypeName System.Data.SQLite.SQLiteDataAdapter $CMD
    $DATA = New-Object System.Data.DataSet

    $ADAPTER.Fill($DATA)

    $TABLE = $DATA.Tables

    ForEach ($t in $TABLE){
        Write-Output $t
    }







#Connect and List The Table values

function Get-AllTableContents {
    [CmdletBinding()]
    [OutputType([array])]
    param (
         [Parameter(Mandatory=$True)][string]$dbPath, #= 'C:\temp\DuTraBot.db';
         [Parameter(Mandatory=$True)][string]$Table #= 'Table_Binance_API';
        
    )

    process {
        $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection  
        $CONN.ConnectionString = "Data Source=$dbPath"
        $CONN.Open()

            $CMD = New-Object -TypeName System.Data.SQLite.SQLiteCommand
            $CMD.Connection = $CONN
            $CMD.CommandText = "SELECT * FROM $($Table);"

                $ADAPTER = New-Object  -TypeName System.Data.SQLite.SQLiteDataAdapter $CMD
                $DATA = New-Object System.Data.DataSet  
                $ADAPTER.Fill($DATA)
                
                $TableData = $DATA.Tables  
                $TableData

            $CMD.Dispose()

        $CONN.Close()
    }   
}

$Mydata= @()
$Mydata = Get-AllTableContents -dbPath $db -Table 'Table_Binance_API'
$Mydata[1] | Format-Table



