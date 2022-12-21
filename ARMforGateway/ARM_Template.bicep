@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
// @minLength(12)
@secure()
param adminPassword string 

@description('Name for the Virtual Machine.')
param vmName string

@description('Name for the Virtual Netwrok.')
param virtualNetworkName string

@description('Name for the network security group.')
param networkSecurityGroupName string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param subnetName string

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = 'myPublicIP'

// @description('Automation account name')
// param automationAccountName string = 'dsc-automation'

@description('RegistrationUrl for DSC.')
param RegistrationUrlvalue string

@description('Username for the Virtual Machine.')
param NodeConfigurationNamevalue string

@description('Username for the Virtual Machine.')
param registrationKeyPrivatevalue string

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('The Windows version for the VM. This will pick a fully patched Gen2 image of this given Windows version.')
@allowed([
  '2019-datacenter-gensecond'
  '2019-datacenter-core-gensecond'
  '2019-datacenter-core-smalldisk-gensecond'
  '2019-datacenter-core-with-containers-gensecond'
  '2019-datacenter-core-with-containers-smalldisk-g2'
  '2019-datacenter-smalldisk-gensecond'
  '2019-datacenter-with-containers-gensecond'
  '2019-datacenter-with-containers-smalldisk-g2'
  '2016-datacenter-gensecond'
])
param OSVersion string = '2019-datacenter-gensecond'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2s'

@description('Location for all resources.')
param location string = resourceGroup().location

// @description('Location for all resources.')
// param storageResourceGroupName string = 'DSC_Storage_Account'

// @description('Location for all resources.')
// param scriptStorageName string = 'dscartifacts98'

var storageAccountName_var = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName_var = 'myVMNic'
var addressPrefix = '10.0.0.0/16'
var subnetPrefix = '10.0.0.0/24'
// var scriptAccountid = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${storageResourceGroupName}/providers/Microsoft.Storage/storageAccounts/${scriptStorageName}'
// var dscLcmModule = 'https://${scriptStorageName}.blob.core.windows.net/public/UpdateLCMforAAPull.zip'
// var dscLcmFunction = 'UpdateLCMforAAPull.ps1\\ConfigureLCMforAAPull'

resource storageAccountName 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName_var
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource publicIpName_resource 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource networkSecurityGroupName_resource 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'allow-80'
        properties: {
          priority: 1001
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroupName_resource.id
          }
        }
      }
    ]
  }
}

resource nicName 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName_var
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpName_resource.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
  dependsOn: [

    virtualNetworkName_resource
  ]
}

resource vmName_resource 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 500
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageAccountName.properties.primaryEndpoints.blob
      }
    }
  }
}

resource VMName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = {
  parent: vmName_resource
  name: 'Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      Items: {
        registrationKeyPrivate: registrationKeyPrivatevalue
      }
    }
    settings: {
      Properties: [
        {
          Name: 'RegistrationKey'
          Value: {
            UserName: 'PLACEHOLDER_DONOTUSE'
            Password: 'PrivateSettingsRef:registrationKeyPrivate'
          }
          TypeName: 'System.Management.Automation.PSCredential'
        }
        {
          Name: 'RegistrationUrl'
          Value: RegistrationUrlvalue
          TypeName: 'System.String'
        }
        {
          Name: 'NodeConfigurationName'
          Value: NodeConfigurationNamevalue
          TypeName: 'System.String'
        }
        {
          Name: 'ConfigurationMode'
          Value: 'ApplyAndAutocorrect'
          TypeName: 'System.String'
        }
        {
          Name: 'ConfigurationModeFrequencyMins'
          Value: '15'
          TypeName: 'System.Int32'
        }
        {
          Name: 'RefreshFrequencyMins'
          Value: '30'
          TypeName: 'System.Int32'
        }
        {
          Name: 'RebootNodeIfNeeded'
          Value: true
          TypeName: 'System.Boolean'
        }
        {
          Name: 'ActionAfterReboot'
          Value: 'ContinueConfiguration'
          TypeName: 'System.String'
        }
        {
          Name: 'AllowModuleOverwrite'
          Value: false
          TypeName: 'System.Boolean'
        }
      ]
    }
  }
}

output hostname string = publicIpName_resource.properties.dnsSettings.fqdn
