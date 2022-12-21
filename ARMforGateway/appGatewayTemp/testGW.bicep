@description('Application gateway name')
param appgwName string = '3eAPPgw2'

// @description('Subscription ID')
// param subcriptionID string = 'a77d2c8a-b7ca-4493-8046-38f707c7cd6f'

// @description('Resource Group Name')
// param resourceGroupName string = 'VMResources'

@description('Virtual network Name')
param vnetName string

@description('name for fully dedicated subnet')
param subIpname string

@description('name of PublicIP')
param pubIPname string

@description('name value for gatewayIPConfigurations')
param gatewayIPConfigurations string = '3EappGWconfig'

@description('name value for backendAddressPools')
param backendAddressPools string = '3EPool'

@description('httpListeners name')
param httpListeners string = 'Listener3E'

@description('frontendIPConfigurations name')
param frontendIPConfigurations string = 'frontEndIpConfig'

@description('requestRoutingRules Name')
param requestRoutingRules string = '3EsetRule'

@description('pool ips')
param poolIP string

@description('backendHttpSettingsCollection name')
param backendHttpSettingsCollection string = '3ESet'

@description('urlPathMap name')
param urlPathMap string = 'webPath'

@description('pathRuleName Name')
param pathRuleName string = '3EApp'


@description('Resouce location')
param rgLocation string = resourceGroup().location

param probeName string = '3EHealthProbe'




@description('Multiple Ips')
var ips = split(poolIP, ',')
var IpAddr  = [for ip in ips : {ipAddress: ip}]





var pubIPfront = resourceId('Microsoft.Network/publicIPAddresses', pubIPname)
var subID = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subIpname)
var urlPath = resourceId('Microsoft.Network/applicationGateways/urlPathMaps/', appgwName, urlPathMap)
var pathRules = resourceId('Microsoft.Network/applicationGateways/urlPathMaps/pathRules/', appgwName, urlPathMap, pathRuleName)
var frontendIPConfigurationID = resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations/', appgwName, frontendIPConfigurations)
var frontendPortName = 'frontendPort'
var frontendPortID = resourceId('Microsoft.Network/applicationGateways/frontendPorts/', appgwName, frontendPortName)
var RoutingRuleid = resourceId('Microsoft.Network/applicationGateways/requestRoutingRules/', appgwName, requestRoutingRules)
var httpListId = resourceId('Microsoft.Network/applicationGateways/httpListeners/', appgwName, httpListeners)
var backendPoolId = resourceId('Microsoft.Network/applicationGateways/backendAddressPools/', appgwName, backendAddressPools)
var BackendSetId = resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection/', appgwName, backendHttpSettingsCollection)
var probeID = resourceId('Microsoft.Network/applicationGateways/probes/', appgwName, probeName)



resource symbolicname 'Microsoft.Network/applicationGateways@2022-01-01' = {

  name : appgwName
  location: rgLocation
  tags: {
    Group: 'Monitoring'
  }

  properties: {

    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }

    autoscaleConfiguration: {
      maxCapacity: 10
      minCapacity: 0
    }

    gatewayIPConfigurations: [
      {
        name: gatewayIPConfigurations
        properties: {
          subnet: {
            id: subID
          }
        }
      }
    ]
    
    backendAddressPools: [
      {
        name: backendAddressPools
        properties : {
          backendAddresses: IpAddr
        }
      }
    ]

    backendHttpSettingsCollection: [
      {
        name: backendHttpSettingsCollection
        properties: {
          port: 80
          protocol: 'Http'
          pickHostNameFromBackendAddress: true
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 30
          probe: {
              id : probeID
            }
          
        }
      }
    ]

    frontendIPConfigurations: [
      {
        name: frontendIPConfigurations
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubIPfront
          }
        }
      }
    ]

    frontendPorts: [
      {
        name: frontendPortName
        properties: {
          port: 80
        }
      }
    ]

    httpListeners: [
      {
        name: httpListeners
        properties: {
          frontendIPConfiguration: {
            id: frontendIPConfigurationID
          }
          frontendPort: {
            id: frontendPortID
          }
          protocol: 'Http'
        }
      }
    ]

    probes: [
      {
        name: probeName
        properties: {
          protocol: 'Http'
          path: '/api'
          interval: 30
          minServers: 0
          pickHostNameFromBackendHttpSettings: true
          timeout: 30
          unhealthyThreshold: 3
          match: {}
        }
      }
    ]

    requestRoutingRules: [
      {
        name: requestRoutingRules
        id: RoutingRuleid
        properties: {
          httpListener: {
            id: httpListId
          }
          priority: 1
          ruleType: 'PathBasedRouting'
          urlPathMap: {
            id: urlPath
          }
        }
      }
    ]


    urlPathMaps: [
      {
        id: urlPath
        name: urlPathMap
        properties: {
          defaultBackendAddressPool: {
            id: backendPoolId
          }
          defaultBackendHttpSettings: {
            id: BackendSetId
          }
          
          pathRules: [
            {
              id: pathRules
              name: pathRuleName
              properties: {
                backendAddressPool: {
                  id: backendPoolId
                }
                backendHttpSettings: {
                  id: BackendSetId
                }
                paths: [
                  '/*'
                ]
             }
            }
           ]
         }
       }
     ]
   }
 }
