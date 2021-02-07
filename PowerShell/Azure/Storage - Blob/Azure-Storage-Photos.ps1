
Import-Module az

Connect-AzAccount -TenantId fdf0b54d-7b16-4ad8-b658-305fcade329b -Subscription 151c8209-2740-453c-a087-a7136d22e427






$key = '+TVXo9ZK/K9ulYOw6hO8Q5l1o2GNVGZIPHOquwVOx5YX4nodObOIKlM+vFmGv5hF1vvn44wsMOZmbfrYOG16vw=='
$uri = 'https://sapersonalmedia.blob.core.windows.net/photos-and-videos'


#login
C:\temp\azcopy.exe login

#
C:\temp\azcopy.exe copy D:\Photos


$files = Get-ChildItem -Path D:\Photos -Recurse -Force | Select-Object PSIsContainer, FullName, Name, Length, CreationTime, LastWriteTime, Attributes

| export-csv -path C:\temp\allphotos.csv -NoTypeInformation


$files.count

$uniquefiles = $files | Select-Object name -Unique
$uniquefiles.count

$duplicatefiles = Compare-Object -ReferenceObject $uniquefiles -DifferenceObject $files

$duplicatefiles.count

| Where-Object { ( $_.name   }

.count

$files | Select-Object -first 100 | FT



