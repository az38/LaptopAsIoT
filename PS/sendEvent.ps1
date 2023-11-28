<# 
any event type as a parameter could be used
use Windows Environmental Variables to store any credentials
#>

param ($eventtype='LogOn')

$IoTHubName = $env:IOT_HubName
$deviceID = $env:IOT_DeviceID
$SASToken = $env:IOT_SASToken_EventHub

$IOTHubDeviceURI= "$($IoTHubName).azure-devices.net/devices/$($deviceID)" 
$iotHubAPIVer = "2020-03-13"
$iotHubRestURI = "https://$($IOTHubDeviceURI)/messages/events?api-version=$($iotHubAPIVer)"

# Headers
$Headers = @{"Authorization" = $SASToken; "Content-Type" = "application/json"}
$msg = @{
    "Event" = $eventtype;
    "ServerName" = $env:computername
} | ConvertTo-Json
 
# Message Payload
$body = @{
 deviceHubClient = $deviceID
 Message = $msg | ConvertFrom-Json
}

$body = $body | ConvertTo-Json

# Send Message
Invoke-RestMethod -Uri $iotHubRestURI -Headers $Headers -Method Post -Body $body 
