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

resource webAppAppServicePlanDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${environment.resourceNames.webAppAppServicePlanName}'
  scope: webAppAppServicePlan
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AppServicePlanMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}

resource functionAppAppServicePlanDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diag-${environment.resourceNames.functionAppAppServicePlanName}'
  scope: functionAppAppServicePlan
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AppServicePlanMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
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
  
  resource logger 'loggers' = {
    name: applicationInsights.name
    properties: {
      loggerType: 'applicationInsights'
      description: applicationInsights.name
      credentials: {
        instrumentationKey: applicationInsights.properties.InstrumentationKey
      }
    }
  }
}

resource webAppAppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
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

resource functionAppAppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: environment.resourceNames.functionAppAppServicePlanName
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
