import { azureRegionType, createEnvironment, environmentNameType} from './Environment-Module.bicep'

param environmentName environmentNameType

param azureRegion azureRegionType

param azurePrimaryRegions azureRegionType[]

var environment = createEnvironment(environmentName, ['me@nandanmathure.info'], azureRegion)

var locations = map(range(0, length(azurePrimaryRegions)), i => {
    locationName: azurePrimaryRegions[i]
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
      schemaType: 'Json'
    }
    databaseAccountOfferType: 'Standard'
    locations: locations
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    minimalTlsVersion: 'Tls12'
  }
}
