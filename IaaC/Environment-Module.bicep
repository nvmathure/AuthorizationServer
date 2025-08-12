@export()
type environmentType = {
  environmentName: environmentNameType
  environmentCode: string
  sharedResourceNames: sharedResourceNamesType
  resourceNames: resourceNamesType
  tags: object
  settings: settingsType
  notificationEmails: string[]
  azureRegion: azureRegionType
}

type sharedResourceNamesType = {
  cosmosDbPrimaryAccountName: string
  cosmosDbEdgeAccountName: string
}

@export()
type environmentNameType = 'Production' | 'Integration' | 'Development' | 'Testing' | 'Model'

@export()
type azureRegionType = 'South Central US' | 'North Central US'

type resourceTypeNameType = 'CosmosDB' | 'FunctionApp' | 'WebApp' | 'APIManagement' | 'StorageAccount' | 'KeyVault' | 'EventGrid' | 'ServiceBus' | 'LogAnalytics' | 'ApplicationInsights' | 'SearchService'

type resourceNamesType = {
  applicationInsightsName: string
  logAnalyticsWorkspaceName: string
  keyVaultName: string
  storageAccountName: string
  appServicePlanName: string
  appServiceName: string
  eventGridTopicName: string
  serviceBusNamespaceName: string
  apiManagementName: string
  searchServiceName: string
}

type settingsType = {
  cosmosDbPrimary: {
    databaseName: string
    databaseThroughput: int
    eventsContainerName: string
    dataContainerName: string
    commandContainerName: string
    leaseContainerName: string
    logContainerName: string
  }
  cosmosDbEdge: {
    databaseName: string
    databaseThroughput: int
    dataContainerName: string
  }
  logAnalytics: {
    retentionInDays: int
  }
}

var resourceTypePrefix = {
  CosmosDB: 'cdb'
  FunctionApp: 'fa'
  WebApp: 'wa'
  APIManagement: 'apim'
  StorageAccount: 'sa'
  KeyVault: 'kv'
  EventGrid: 'egt'
  ServiceBus: 'sb'
  LogAnalytics: 'la'
  ApplicationInsights: 'ai'
  SearchService: 'ss'
}

var environmentCodes = {
  Production: 'prod'
  Integration: 'intg'
  Development: 'dev'
  Testing: 'test'
  Model: 'modl'
}

var regionCodes = {
  'South Central US': 'scus'
  'North Central US': 'ncus'
}

func createSettings(environmentName environmentNameType) settingsType => environmentName == 'Production' ? {
  cosmosDbPrimary: {
    databaseName: 'AuthServer'
    databaseThroughput: 1000
    eventsContainerName: 'events'
    dataContainerName: 'data'
    commandContainerName: 'commands'
    leaseContainerName: 'leases'
    logContainerName: 'logs'
  }
  cosmosDbEdge: {
    databaseName: 'AuthServerEdge'
    databaseThroughput: 1000
    dataContainerName: 'data'
  }
  logAnalytics: {
    retentionInDays: 90
  }
} : {
  cosmosDbPrimary: {
    databaseName: 'AuthServer'
    databaseThroughput: 1000
    eventsContainerName: 'events'
    dataContainerName: 'data'
    commandContainerName: 'commands'
    leaseContainerName: 'leases'
    logContainerName: 'logs'    
  }
  cosmosDbEdge: {
    databaseName: 'AuthServerEdge'
    databaseThroughput: 1000
    dataContainerName: 'data'
  }
  logAnalytics: {
    retentionInDays: 30
  }
}

var appName = 'AuthSvr'

func getRegionResourceName(
  resourceTypeName resourceTypeNameType, 
  environmentName environmentNameType,
  region azureRegionType,
  suffix string) string => '${resourceTypePrefix[resourceTypeName]}-${appName}-${(length(suffix) == 0) ? '' : '${suffix}-'}${environmentCodes[environmentName]}${regionCodes[region]}'

func getResourceName(
  resourceTypeName resourceTypeNameType, 
  environmentName environmentNameType,
  suffix string) string => '${resourceTypePrefix[resourceTypeName]}-${appName}-${(length(suffix) == 0) ? '' : '${suffix}-'}${environmentCodes[environmentName]}'

@export()
func createEnvironment(
    environmentName environmentNameType, 
    notificationEmails string[],
    azureRegion azureRegionType) environmentType => {
  environmentName: environmentName
  environmentCode: environmentCodes[environmentName]
  sharedResourceNames: {
    cosmosDbPrimaryAccountName: getResourceName('CosmosDB', environmentName, 'cfg')
    cosmosDbEdgeAccountName: getResourceName('CosmosDB', environmentName, 'edge')
  }
  resourceNames: {
    apiManagementName: getRegionResourceName('APIManagement', environmentName, azureRegion, '')
    appServiceName: getRegionResourceName('WebApp', environmentName, azureRegion, '')
    appServicePlanName: getRegionResourceName('FunctionApp', environmentName, azureRegion, '')
    applicationInsightsName: getRegionResourceName('ApplicationInsights', environmentName, azureRegion, '')
    eventGridTopicName: getRegionResourceName('EventGrid', environmentName, azureRegion, '')
    keyVaultName: getRegionResourceName('KeyVault', environmentName, azureRegion, '')
    logAnalyticsWorkspaceName: getRegionResourceName('LogAnalytics', environmentName, azureRegion, '')
    serviceBusNamespaceName: getRegionResourceName('ServiceBus', environmentName, azureRegion, '')
    storageAccountName: getRegionResourceName('StorageAccount', environmentName, azureRegion, '')
    searchServiceName: getRegionResourceName('SearchService', environmentName, azureRegion, '')
  }
  tags: {
    environment: environmentName
  }
  settings: createSettings(environmentName)
  notificationEmails: notificationEmails
  azureRegion: azureRegion
}
