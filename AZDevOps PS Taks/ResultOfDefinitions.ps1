param (
    [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
    [string]$Organization = 'hulu007k',
    [string]$project = 'appGateWayTest',
    [bool] $export
)

function BuildDefinition{
    # Param
# (
#     [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
#     [string]$Organization = 'hulu007k',
#     [string]$project = 'appGateWayTest'

# )

$BuildDefinition =@()



 $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
 $UriPro = "https://dev.azure.com/$($Organization)/$($project)"




 $defUri = $UriPro + "/_apis/build/definitions?api-version=6.0"
 $defResult = Invoke-RestMethod `
                -Uri $defUri `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader 
                    

        foreach($def in $defResult.value){

        $PoolLink = $UriPro + "/_apis/build/definitions/$($def.Id)?api-version=6.0"
        $Poolsdef = Invoke-RestMethod `
                        -Uri $PoolLink `
                        -Method get `
                        -Headers $AzureDevOpsAuthenicationHeader
                        

        foreach($definition in $Poolsdef){

            $BuildDefinition += New-Object -TypeName PSObject -Property @{
                            ProjectName=$definition.project.name
                            Pipelines = $definition.name
                            agentInPool = $definition.queue.name
                            PoolLink = $definition.queue.url                
                }
            }
            
        }
        $BuildDefinition


        # | Select-Object -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool | Export-csv .\tutu.csv -NoTypeInformation

        # | Format-Table -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool
    } BuildDefinition

function pipelineResult{
    #     param (
    #     [string] $Organization = 'hulu007k',
    #     [string] $PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca'
    # )
    
    $base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    $headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
    
    $result = Invoke-RestMethod `
                -Uri "https://dev.azure.com/$Organization/_apis/projects?api-version=6.0" `
                -Method Get -Headers $headers
    
    $projectNames = $result.value.name
    
    $projectNames | ForEach-Object {
         $project = $_
    
        $pipelineResult = Invoke-RestMethod `
                    -Uri "https://dev.azure.com/$Organization/$project/_apis/pipelines?api-version=6.0-preview.1" `
                    -Method Get -Headers $headers
    $pipelineResult.value
    }
    
    
    
    } pipelineResult

function PoolAgentStatus{
        # Param(
        #     [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca', 
        #     [string]$Organization = 'hulu007k',
        #     [boolean]$export
        # )
        
        $PoolAgentStatus = @()
        
        
        $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        $UriOrganization = "https://dev.azure.com/$($Organization)/"
        
        
        $UriPools = $UriOrganization + '/_apis/distributedtask/pools?api-version=6.0'
        $PoolsResult = Invoke-RestMethod `
                        -Uri $UriPools `
                        -Method get `
                        -Headers $AzureDevOpsAuthenicationHeader
        
        
        
            Foreach ($pool in $PoolsResult.value)
            {        
                $uriAgents = $UriOrganization + "_apis/distributedtask/pools/$($pool.Id)/agents?api-version=6.0"
                $AgentsResults = Invoke-RestMethod `
                                    -Uri $uriAgents `
                                    -Method get `
                                    -Headers $AzureDevOpsAuthenicationHeader
        
                        Foreach ($agent in $AgentsResults.value)
                        {
                            $uripoolandAgent = $UriOrganization + "_apis/distributedtask/pools/$($pool.Id)/agents/$($agent.Id)?includeCapabilities=true&api-version=6.0"
                            $poolandAgentsResult = Invoke-RestMethod `
                                                    -Uri $uripoolandAgent `
                                                    -Method get `
                                                    -Headers $AzureDevOpsAuthenicationHeader
        
                                                        
                                Foreach ($shac in $poolandAgentsResult)
                                {
                                    $Capabilities = $shac.systemCapabilities.'Agent.ComputerName'
        
                                    $PoolAgentStatus += New-Object -TypeName PSObject -Property @{
                                        PoolName=$pool.name
                                        AgentName=$agent.name
                                        Status = $agent.status
                                        AgentVMname = $Capabilities    
                                    }
        
                                }
                        }
            }
            $PoolAgentStatus
                # | Select-Object PoolName, AgentName, Status, AgentVMname | Export-Csv -path .\Agents.csv -NoTypeInformation
    } PoolAgentStatus
        
function ServiceConnection{
    #     param (
    #     [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
    #     [string]$Organization = 'hulu007k',
    #     [string]$project = 'appGateWayTest'
    # )
    
    $ServiceConnection = @()
    
    $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
    $UriOrganization = "https://dev.azure.com/$($Organization)/$($project)" 
    
    
    $endpointsurl = $UriOrganization + "/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
    # $head = @{ Authorization =" Basic $token" }
    
    $endpointsresult = Invoke-RestMethod `
                -Uri $endpointsurl `
                -Method GET `
                -Headers $AzureDevOpsAuthenicationHeader
    
    
    foreach($endpoints in $endpointsresult.value){
        $ServiceConnection += New-Object -TypeName PSObject -Property @{
            subscriptions = $endpoints.data.subscriptionName 
            subscriptionId =   $endpoints.data.subscriptionId 
            ServiceConn =  $endpoints.name 
            isShared = $endpoints.isShared 
            isReady = $endpoints.isReady
        }
    }
    $ServiceConnection #| Format-Table subscriptionId
    # $ServiceConnection #| Format-Table subscriptions, subscriptionId, ServiceConn, isShared, isReady       
    } ServiceConnection



$ResultOfDefinitions=@()

$ResultOfDefinitions += New-Object -TypeName PSObject -Property @{
    PipelinesAvailable = BuildDefinition
    PoolsLink = $BuildDefinition.PoolLink
    PoolsName = $PoolAgentStatus.PoolName 
    PoolAgent = $PoolAgentStatus.AgentName
    AgentVM = $PoolAgentStatus.AgentVMname
    AgentStatus = $PoolAgentStatus.Status
    ServiceConnections = $ServiceConnection.ServiceConn
    ServiceConnSubscriptionID = $ServiceConnection.subscriptionId
    ServiceConnisReady = $ServiceConnection.isReady
    ServiceConnisShared = $ServiceConnection.isShared
}


$ResultOfDefinitions.PipelinesAvailable