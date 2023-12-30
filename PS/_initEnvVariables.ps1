<# 
Helper to create environmental variables
Run as admin
#>

<#
IoT Hub configuration
SAS Token for IoT Hub has the following form:
'SharedAccessSignature sr=<YOUR_IOT_HUB_NAME>.azure-devices.net%2Fdevices%2F<YOUR_IOT_DEVICE_NAME>&sig=<SIG>&se=<EXPIRATION_TIMESTAMP>'
#>
$env:IOT_HubName = '<YOUR_IOT_HUB_NAME>'
$env:IOT_DeviceID = '<YOUR_IOT_DEVICE_NAME>'
$env:IOT_SASToken_EventHub = '<YOUR_IOT_DEVICE_SAS_TOKEN>'

<#
Storage Account configuration
#>
$env:IOT_StorageAccount = '<YOUR_STORAGE_ACCOUNT_NAME>'
$env:IOT_Container = '<YOUR_STORAGE_ACCOUNT_CONTAINER_NAME>'
$env:IOT_SASToken_Blob = '<YOUR_STORAGE_ACCOUNT_CONTAINER_SAS_TOKEN>'
