import { azureRegionType, createEnvironment, environmentNameType} from './Environment-Module.bicep'

param environmentName environmentNameType

param azureRegion azureRegionType

var environment = createEnvironment(environmentName, ['me@nandanmathure.info'], azureRegion)

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: environment.resourceNames.logAnalyticsWorkspaceName
  location: environment.azureRegion
  tags: environment.tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: environment.settings.logAnalytics.retentionInDays
  }
}
