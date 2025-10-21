import { azureRegionType, createEnvironment, environmentNameType} from './Environment-Module.bicep'

param environmentName environmentNameType

param azureRegion azureRegionType

var environment = createEnvironment(environmentName, ['me@nandanmathure.info'], azureRegion)

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@' = {
  name: environment.resourceNames.logAnalyticsWorkspace
  location: environment.location
  tags: environment.tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: environment.settings.logAnalytics.retentionInDays
    publicNetworkAccessForIngestion: true
    publicNetworkAccessForQuery: true
    workspaceCapping: {
      dailyCap: 1
    }
  }
}
