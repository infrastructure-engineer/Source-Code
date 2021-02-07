
import-module AZ
Connect-AzAccount

$vlocation = "uksouth"
$vresourceGroup = "PhotoStorage-RG"
$vSaName = 'photostoragecoolsa'
$vBlobContainerName = "our-cloud-photos"


###############################################################################################################


function New-NewPhotoAZstorage {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory=$true)]$location = "uksouth",
        [Parameter(Mandatory=$true)]$resourceGroup = "PhotoStorage-RG",
        [Parameter(Mandatory=$true)]$saName = 'photostoragecoolsa',
        [Parameter(Mandatory=$true)]$containerName = "our-cloud-photos"
    )
        $vdate = get-date -Format yyyy/MM/dd

        # Crate New Resource Group
        New-AzResourceGroup -Name $resourceGroup -Location $location

        # Create New Storage Account that is Private

        $NewAzStorageAccountArguments = @{
            AccessTier = 'Cool'
            ResourceGroupName  = $resourceGroup
            Name = $saName
            SkuName  = 'Standard_ZRS'
            Location = $location
            Kind = 'StorageV2'
            MinimumTlsVersion = 'TLS1_2'
            AllowBlobPublicAccess = $false
            Tag = @{Created=$vdate;Purpose='OnlineStorage'}
        }

        $storageAccount = New-AzStorageAccount @NewAzStorageAccountArguments

        $ctx = $storageAccount.Context
        
        # Create New Storage Container that is Private

        New-AzStorageContainer -Name $containerName -Context $ctx -Permission Off

        return "Success"  


} #End function New-MyNewPhotoAZstorage

###############################################################################################################

function Upload-PhotoAZstorage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$vfolder,
        [Parameter(Mandatory=$true)]$resourceGroup = "PhotoStorage-RG",
        [Parameter(Mandatory=$true)]$saName = 'photostoragecoolsa',
        [Parameter(Mandatory=$true)]$containerName = "our-cloud-photos"        
    )
    
    $ctx = (Get-AzStorageAccount -Name $saName -ResourceGroupName $resourceGroup).context

    # upload another file to the Cool access tier

    $vfolder = 'F:\Photos'

    $uploadfiles = Get-ChildItem -Path $vfolder -Recurse -File

    write-host -foreground yellow 'Amount of Files to upload' $uploadfiles.count
    
    $obj = $uploadfiles  | Select-Object fullname, @{n='AzureFullName';e={($_.fullname.subString(3,($_.fullname.Length - 3))).Replace('\','...')}}
    $csvfile =  $vfolder + '\AzureBlob.'  + (get-date -Format yyyy.MM.dd.HHmm) + '.csv'
    $obj = $obj += [PSCustomObject]@{
        FullName = $csvfile
        $AzureFullName = $csvfile.Split('\')[-1]
    }
    
    $obj | Export-Csv -Path $csvfile -NoTypeInformation -Force

    foreach ($line in $obj ) {  
        Write-host $line.FullName
        Set-AzStorageBlobContent -File $line.FullName -Container $containerName -BlobType 'Block' -Blob $line.AzureFullName -Context $ctx -StandardBlobTier 'Cool' -Force

    }   

}

###############################################################################################################

function Download-PhotoAZstorage {
    [CmdletBinding()]
    param (
    
    [Parameter(Mandatory=$true)]$vDest = "C:\Temp",
    [Parameter(Mandatory=$true)]$resourceGroup = "PhotoStorage-RG",
    [Parameter(Mandatory=$true)]$saName = 'photostoragecoolsa',
    [Parameter(Mandatory=$true)]$containerName = "our-cloud-photos",
    [Parameter()][ValidateSet("All", "File", "Folder")]$DownloadSelection = 'All'
        
    )
    #get Blob Context
    $ctx = (Get-AzStorageAccount -Name $saName -ResourceGroupName $resourceGroup).context

    #Get AzureBlob CSV file (Crude Database)
    Get-AzStorageContainer -name $containerName -Context $ctx | Get-AzStorageBlob -Blob "AzureBlob.*" | Get-AzStorageBlobContent -Destination $vDest -Force

    #List the files that can be restored
    $vAZlist = Import-Csv -Path (Get-ChildItem -Path ($vDest + '\*.csv'))

    #Select files to be restored
    $vrestore = $vAZlist | Select-Object -First 5

    #Create folders 
    $restorefolders = ($vrestore.AzureFullName[1]).Split('...') 

    $restorefolders.Count



}

###############################################################################################################

# Testing







  photostoragesa

  $storagekey = '0X9rY7zRKVwqeSKoW37mh0FXwl+4e7DffCYXrvNbvvNKWQfrvxOejNfc8jV3EVDoTpX2nFG88BtlSYbJlc1I5w=='

  $connectionstring = 'DefaultEndpointsProtocol=https;AccountName=photostoragesa;AccountKey=0X9rY7zRKVwqeSKoW37mh0FXwl+4e7DffCYXrvNbvvNKWQfrvxOejNfc8jV3EVDoTpX2nFG88BtlSYbJlc1I5w==;EndpointSuffix=core.windows.net'

https://photostoragesa.blob.core.windows.net/our-photos

Get-AzStorageBlob


Get-AzStorageAccount -Name photostoragesa -ResourceGroupName PhotoStorage-RG



# Testing File


$objcsv = import-Csv -Path $csvfile


$a1 = ''
$b2 = ''

foreach ($item in $objcsv) {
    if ($item.AzureFullName.Length -gt $b2.Length) {
     $b2 = $item.AzureFullName 
    }
}

$b2.Length



