import { azureRegionType, createEnvironment, environmentNameType} from './Environment-Module.bicep'

param environmentName environmentNameType

param azureRegion azureRegionType

param azureRegions azureRegionType[]

param edgeAzureRegions azureRegionType[]

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
  kind: 'web'
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

resource webAppAppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = if (contains(azureRegions, environment.azureRegion)) {
  name: environment.resourceNames.webAppAppServicePlanName
  location: environment.azureRegion
  tags: environment.tags
  sku: {
    name: 'Y1'
  }
  properties: {
    reserved: false
  }
}

resource functionAppAppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = if (contains(azureRegions, environment.azureRegion) && !environment.sharedAppServicePlans) {
  name: environment.resourceNames.functionAppAppServicePlanName
  location: environment.azureRegion
  tags: environment.tags
  sku: {
    name: 'Y1'
  }
  properties: {
    reserved: false
  }
}

resource edgeFunctionAppAppServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = if (contains(edgeAzureRegions, environment.azureRegion) && !environment.sharedAppServicePlans) {
  name: environment.resourceNames.edgeFunctionAppAppServicePlanName
  location: environment.azureRegion
  tags: environment.tags
  sku: {
    name: 'Y1'
  }
  properties: {
    reserved: false
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = if (contains(azureRegions, environment.azureRegion))  {
  name: environment.resourceNames.webAppName
  location: environment.azureRegion
  tags: environment.tags
  properties: {
    serverFarmId: webAppAppServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'APPLICATIONINSIGHTS_ROLE_NAME'
          value: 'WebApp'
        }
      ]
    }
  }
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = if (contains(azureRegions, environment.azureRegion))  {
  name: environment.resourceNames.functionAppName
  location: environment.azureRegion
  tags: environment.tags
  properties: {
    serverFarmId: functionAppAppServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'APPLICATIONINSIGHTS_ROLE_NAME'
          value: 'FunctionApp'
        }
      ]
    }
  }
}

resource edgeFunctionApp 'Microsoft.Web/sites@2023-12-01' = if (contains(edgeAzureRegions, environment.azureRegion))  {
  name: environment.resourceNames.edgeFunctionAppName
  location: environment.azureRegion
  tags: environment.tags
  properties: {
    serverFarmId: edgeFunctionAppAppServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'APPLICATIONINSIGHTS_ROLE_NAME'
          value: 'EdgeFunctionApp'
        }
      ]
    }
  }
}
