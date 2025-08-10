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

func getResourceName(
  resourceTypeName resourceTypeNameType, 
  environmentName environmentNameType,
  region azureRegionType | null,
  suffix string) string => '${resourceTypePrefix[resourceTypeName]}-${appName}-${(length(suffix) == 0) ? '' : '${suffix}-'}${environmentCodes[environmentName]}${(region == null ? '' : getRegionCode(region!))}'

func getRegionCode(region azureRegionType) string => regionCodes[region]

@export()
func createEnvironment(
    environmentName environmentNameType, 
    notificationEmails string[],
    azureRegion azureRegionType) environmentType => {
  environmentName: environmentName
  environmentCode: environmentCodes[environmentName]
  sharedResourceNames: {
    cosmosDbPrimaryAccountName: getResourceName('CosmosDB', environmentName, null, 'cfg')
    cosmosDbEdgeAccountName: getResourceName('CosmosDB', environmentName, null, 'edge')
  }
  resourceNames: {
    apiManagementName: getResourceName('APIManagement', environmentName, azureRegion, '')
    appServiceName: getResourceName('WebApp', environmentName, azureRegion, '')
    appServicePlanName: getResourceName('FunctionApp', environmentName, azureRegion, '')
    applicationInsightsName: getResourceName('ApplicationInsights', environmentName, azureRegion, '')
    eventGridTopicName: getResourceName('EventGrid', environmentName, azureRegion, '')
    keyVaultName: getResourceName('KeyVault', environmentName, azureRegion, '')
    logAnalyticsWorkspaceName: getResourceName('LogAnalytics', environmentName, azureRegion, '')
    serviceBusNamespaceName: getResourceName('ServiceBus', environmentName, azureRegion, '')
    storageAccountName: getResourceName('StorageAccount', environmentName, azureRegion, '')
    searchServiceName: getResourceName('SearchService', environmentName, azureRegion, '')
  }
  tags: {
    environment: environmentName
  }
  settings: createSettings(environmentName)
  notificationEmails: notificationEmails
  azureRegion: azureRegion
}
