param location string
param hubName string
param stAccName string
param endpointContainerName string
param envUrls string

var routeName = '${hubName}-Route'

resource iothub 'Microsoft.Devices/IotHubs@2023-06-30' = {
  name: hubName
  location: location
  tags: {}
  properties: {
    ipFilterRules: []
    eventHubEndpoints: {
      events: {
        retentionTimeInDays: 1
        partitionCount: 2
      }
    }
    routing: {
      endpoints: {
        serviceBusQueues: []
        serviceBusTopics: []
        eventHubs: []
        storageContainers: []
        cosmosDBSqlContainers: []
      }
      routes: [
        {
          name: routeName
          source: 'DeviceMessages'
          condition: 'true'
          endpointNames: [
            'events'
          ]
          isEnabled: true
        }
      ]
      fallbackRoute: {
        name: '$fallback'
        source: 'DeviceMessages'
        condition: 'true'
        endpointNames: [
          'events'
        ]
        isEnabled: true
      }
    }
    storageEndpoints: {
      '$default': {
        sasTtlAsIso8601: 'PT1H'
        connectionString: 'DefaultEndpointsProtocol=https;EndpointSuffix=${envUrls};AccountName=${stAccName};AccountKey=****'
        containerName: endpointContainerName
        authenticationType: 'keyBased'
      }
    }
    messagingEndpoints: {
      fileNotifications: {
        lockDurationAsIso8601: 'PT1M'
        ttlAsIso8601: 'PT1H'
        maxDeliveryCount: 10
      }
    }
    enableFileUploadNotifications: false
    cloudToDevice: {
      maxDeliveryCount: 3
      defaultTtlAsIso8601: 'PT1H'
      feedback: {
        lockDurationAsIso8601: 'PT1M'
        ttlAsIso8601: 'PT1H'
        maxDeliveryCount: 10
      }
    }
    features: 'GWV2, RootCertificateV2'
    disableLocalAuth: false
    allowedFqdnList: []
    enableDataResidency: false
  }
  sku: {
    name: 'F1'
    capacity: 1
  }
  identity: {
    type: 'None'
  }
}
