<#

    Configure Azure credentials as an Environment variables first (valid SAS token, storage account and container name)

#>


$storageAccount = $env:IOT_StorageAccount
$container = $env:IOT_Container
$SASToken = $env:IOT_SASToken_Blob

$dateFolder = (Get-Date).ToString("yyyy/MM/dd")
$fileTimestamp = (Get-Date(Get-Date).ToUniversalTime() -UFormat %s) + ".json"
$fileTimestampName = "$PSScriptRoot\$fileTimestamp"
$blob = "$dateFolder/$fileTimestamp"

$Context = New-AzStorageContext -StorageAccountName $storageAccount -SasToken $SASToken 

$data = @{}
$data["LogicalDisks"] = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace
$data["Memory"] = Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory | Select-Object AvailableKBytes
$data["Battery"] = (Get-WmiObject win32_battery) | Select-Object EstimatedChargeRemaining, EstimatedRunTime
$data["UTC"] = Get-CimInstance -ClassName Win32_UTCTime
$data | ConvertTo-JSON | Out-File -FilePath "$fileTimestampName"

Set-AzStorageBlobContent -Container $container -File $fileTimestampName -Blob $blob -Context $Context -Force

Remove-Item -Path $fileTimestampName -Force
