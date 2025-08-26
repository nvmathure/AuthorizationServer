import { azureRegionType, createEnvironment, environmentNameType} from './Environment-Module.bicep'

param environmentName environmentNameType

param azureRegion azureRegionType

param azureRegions azureRegionType[]

param edgeAzureRegions azureRegionType[]

var environment = createEnvironment(environmentName, ['me@nandanmathure.info'], azureRegion)

var locations = map(range(0, length(azureRegions)), i => {
    locationName: azureRegions[i]
    failoverPriority: i
  })

var edgeLocations = map(range(0, length(edgeAzureRegions)), i => {
    locationName: edgeAzureRegions[i]
    failoverPriority: i
  })

resource cosmosDbPrimary 'Microsoft.DocumentDB/databaseAccounts@2025-05-01-preview' = {
  name: environment.sharedResourceNames.cosmosDbPrimaryAccountName
  location: azureRegion
  kind: 'GlobalDocumentDB'
  tags: environment.tags
  properties: {
    enableAnalyticalStorage: true
    analyticalStorageConfiguration: {
      schemaType: 'FullFidelity'
    }
    databaseAccountOfferType: 'Standard'
    locations: locations
    minimalTlsVersion: 'Tls12'
  }
}

resource cosmosDbEdge 'Microsoft.DocumentDB/databaseAccounts@2025-05-01-preview' = {
  name: environment.sharedResourceNames.cosmosDbEdgeAccountName
  location: azureRegion
  kind: 'GlobalDocumentDB'
  tags: environment.tags
  properties: {
    enableAnalyticalStorage: true
    analyticalStorageConfiguration: {
      schemaType: 'FullFidelity'
    }
    databaseAccountOfferType: 'Standard'
    locations: edgeLocations
    minimalTlsVersion: 'Tls12'
  }
}
