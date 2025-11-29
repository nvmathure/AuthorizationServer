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

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: environment.resourceNames.applicationInsightsName
  location: environment.azureRegion
  tags: environment.tags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource apim 'Microsoft.ApiManagement/service@2024-10-01-preview' = {
  name: environment.resourceNames.apiManagementName
  location: environment.azureRegion
  tags: environment.tags
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'me@nandanmathure.info'
    publisherName: 'Nandan Mathure'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: environment.resourceNames.webAppAppServicePlanName
  location: environment.azureRegion
  tags: environment.tags
  sku: {
    name: 'FC1'
    tier: 'FlexConsumption'
  }
  properties: {
    reserved: false
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
}
