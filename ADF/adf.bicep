@description('Data Factory Name')
param dataFactoryName string = 'TestFact${uniqueString(resourceGroup().id)}'

@description('Location of the data factory.')
param location string = resourceGroup().location

@description('Name of the Azure storage account that contains the input/output data.')
param storageAccountName string = 'TestACC${uniqueString(resourceGroup().id)}'

@description('Name of the blob container in the Azure Storage account.')
param blobContainerName string = 'TestBlob${uniqueString(resourceGroup().id)}'

var dataFactoryLinkedServiceName = 'TestLink1'
var dataFactoryDataSetInName = 'DataIN'
var dataFactoryDataSetOutName = 'DataOUT'
var pipelineName = 'TestPipe'
var dataflowN = 'testDATA'



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${storageAccount.name}/default/${blobContainerName}'
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

resource dataFactoryLinkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: dataFactoryLinkedServiceName
  properties: {
    type: 'AzureBlobStorage'
    typeProperties: {
      connectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value}'
    }
  }
}

resource dataFactoryDataSetIn 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: dataFactoryDataSetInName
  properties: {
    linkedServiceName: {
      referenceName: dataFactoryLinkedService.name
      type: 'LinkedServiceReference'
    }
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: blobContainerName
        folderPath: 'input'
        fileName: ''
      }
    }
  }
}


resource dataFactoryDataSetOut 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: dataFactoryDataSetOutName
  properties: {
    linkedServiceName: {
      referenceName: dataFactoryLinkedService.name
      type: 'LinkedServiceReference'
    }
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: blobContainerName
        folderPath: 'output'
      }
    }
  }
}

resource symbolicname 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = {
  name: dataflowN
  parent: dataFactory
  properties: {
    description: 'TestData'
    folder: {
      name: 'input'
    }
    // For remaining properties, see DataFlow objects
    type: 'MappingDataFlow'
    typeProperties: {
      sources: [
        {
          
          dataset: {
            referenceName: dataFactoryDataSetInName
            type: 'DatasetReference'
          }
          description: 'testing data set'
          name: 'Source1'
        }
      ]
      sinks: [
        {
          dataset: {
            referenceName: dataFactoryDataSetOutName
            type: 'DatasetReference'
          }
          description: 'export data to output node'
          name: 'sinkTest1'
        }
      ]
      
      // transformations: [
      //   {
      //     dataset: {
      //       parameters: {}
      //       referenceName: 'string'
      //       type: 'DatasetReference'
      //     }
      //     description: 'string'
      //     flowlet: {
      //       referenceName: 'string'
      //       type: 'DataFlowReference'
      //     }
      //     linkedService: {
      //       parameters: {}
      //       referenceName: 'string'
      //       type: 'LinkedServiceReference'
      //     }
      //     name: 'string'
      //   }
      // ]
    }
  }
}

resource dataFactoryPipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: dataFactory
  name: pipelineName
  properties: {
    activities: [
      {
        name: 'TestDataflowBicep'
        type: 'ExecuteDataFlow'
        typeProperties: {
          dataFlow:{
            referenceName : dataFactoryName
            type: 'DataFlowReference'
          }
          compute: {
            coreCount: 8
            computeType: 'General'
        }
        traceLevel: 'Fine'
        }  
      }
    ]
  }
}
