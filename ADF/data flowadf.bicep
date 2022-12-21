type: 'Flowlet'
  typeProperties: {
    script: 'string'
    scriptLines: [
      'string'
    ]
    sinks: [
      {
        dataset: {
          parameters: {}
          referenceName: 'string'
          type: 'DatasetReference'
        }
        description: 'string'
        flowlet: {
          datasetParameters: any()
          parameters: {}
          referenceName: 'string'
          type: 'DataFlowReference'
        }
        linkedService: {
          parameters: {}
          referenceName: 'string'
          type: 'LinkedServiceReference'
        }
        name: 'string'
        rejectedDataLinkedService: {
          parameters: {}
          referenceName: 'string'
          type: 'LinkedServiceReference'
        }
        schemaLinkedService: {
          parameters: {}
          referenceName: 'string'
          type: 'LinkedServiceReference'
        }
      }
    ]
    sources: [
      {
        dataset: {
          parameters: {}
          referenceName: 'string'
          type: 'DatasetReference'
        }
        description: 'string'
        flowlet: {
          datasetParameters: any()
          parameters: {}
          referenceName: 'string'
          type: 'DataFlowReference'
        }
        linkedService: {
          parameters: {}
          referenceName: 'string'
          type: 'LinkedServiceReference'
        }
        name: 'string'
        schemaLinkedService: {
          parameters: {}
          referenceName: 'string'
          type: 'LinkedServiceReference'
        }
      }
    ]
    transformations: [
      {
        dataset: {
          parameters: {}
          referenceName: 'string'
          type: 'DatasetReference'
        }
        description: 'string'
        flowlet: {
          datasetParameters: any()
          parameters: {}
          referenceName: 'string'
          type: 'DataFlowReference'
        }
        linkedService: {
          parameters: {}
          referenceName: 'string'
          type: 'LinkedServiceReference'
        }
        name: 'string'
      }
    ]
  }
