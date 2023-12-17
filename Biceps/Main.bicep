param location string = resourceGroup().location
param hubName string
param stAccName string
param endpointContainerName string

param convertedEpoch int = dateTimeToEpoch(utcNow())

var delpoymentName = convertedEpoch

module storage 'StorageAccount.bicep' = {
  name: 'st${delpoymentName}-deployment'
  params: {
    location: location
    stAccName: stAccName
  }
}

var envUrls = storage.outputs.outSaEnv

module iothub 'IoT-Hub.bicep' = {
  name: 'ih${delpoymentName}-deployment'
  params: {
    location: location
    stAccName: stAccName
    hubName: hubName
    endpointContainerName: endpointContainerName
    envUrls: envUrls
  }
}

