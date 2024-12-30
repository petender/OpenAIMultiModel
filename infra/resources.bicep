targetScope = 'resourceGroup'

param location string
param tags object
param environmentName string

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

module monitoring 'br/public:avm/ptn/azd/monitoring:0.1.0' = {
  name: 'monitoring'
  params: {
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
    applicationInsightsDashboardName: '${abbrs.portalDashboards}${resourceToken}'
    location: location
    tags: tags
  }
}

module aiAccount 'br/public:avm/res/cognitive-services/account:0.9.0' = {
  name: 'aiAccountDeployment'
  params: {
    kind: 'OpenAI'
    name: '${abbrs.cognitiveServicesAccounts}${resourceToken}'
    tags: tags
    // Managed Identity Authentication doesn't work without a custom subdomain
    customSubDomainName: '${abbrs.cognitiveServicesAccounts}${resourceToken}'
    deployments: [
      {
        model: {
          format: 'OpenAI'
          name: 'dall-e-3'
          version: '3.0'
        }
        name: 'dall-e-3'
        sku: {
          capacity: 1
          name: 'Standard'
        }
      }
      //add a model for gpt4o
      {
        model: {
          format: 'OpenAI'
          name: 'gpt-4o'
          version: '2024-08-06'
        }
        name: 'gpt-4o'
        sku: {
          capacity: 1
          name: 'Standard'
        }
        
      }
      {
        model: {
          format: 'OpenAI'
          name: 'gpt-35-turbo'
          version: '0301'
        }
        name: 'gpt-35-turbo'
        sku: {
          capacity: 2
          name: 'Standard'
        }
      }
    ]
    location: location

    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    diagnosticSettings: [
      {
        name: 'basicSetting'
        workspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
  }
}

output aiAccountResourceId string = aiAccount.outputs.endpoint
output aiAccountName string = aiAccount.outputs.name

