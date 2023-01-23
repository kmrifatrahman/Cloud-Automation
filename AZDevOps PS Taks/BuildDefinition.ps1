Param
(
    [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
    [string]$Organization = 'hulu007k',
    [string]$project = 'appGateWayTest'

)

function GetAgentsDetails {
    # Param(
    #     [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca', 
    #     [string]$Organization = 'hulu007k',
    #     [boolean]$export
    # )
    
    $agentsDetails = @()
    
    
    $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
    $UriOrganization = "https://dev.azure.com/$($Organization)/"
    
    
    $UriPools = $UriOrganization + '/_apis/distributedtask/pools?api-version=6.0'
    $PoolsResult = Invoke-RestMethod `
        -Uri $UriPools `
        -Method get `
        -Headers $AzureDevOpsAuthenicationHeader
    
    
    
    Foreach ($pool in $PoolsResult.value) {        
        $uriAgents = $UriOrganization + "_apis/distributedtask/pools/$($pool.Id)/agents?api-version=6.0"
        $AgentsResults = Invoke-RestMethod `
            -Uri $uriAgents `
            -Method get `
            -Headers $AzureDevOpsAuthenicationHeader
    
        Foreach ($agent in $AgentsResults.value) {
            $getAgentApiEndpoint = $UriOrganization + "_apis/distributedtask/pools/$($pool.Id)/agents/$($agent.Id)?includeCapabilities=true&api-version=6.0"
            $agentDetails = Invoke-RestMethod `
                -Uri $getAgentApiEndpoint `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader
    
            $agentComputerName = $agentDetails.systemCapabilities.'Agent.ComputerName'                            
            $agentsDetails += New-Object -TypeName PSObject -Property @{
                PoolName    = $pool.name
                AgentName   = $agent.name
                Status      = $agent.status
                AgentVMname = $agentComputerName    
    
            }
        }
    }
    $agentsDetails
    
} 

# GetAgentsDetails




function ListOfCollectedData{



$ListOfCollectedData =@()

$agetnsDetail = GetAgentsDetails
# $agetnsDetail
# $agetnsDetail.PoolName

 $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
 $UriPro = "https://dev.azure.com/$($Organization)/$($project)"




 $definitionsUri = $UriPro + "/_apis/build/definitions?api-version=6.0"
 $getDefinitions = Invoke-RestMethod `
                -Uri $definitionsUri `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader 
                    

        foreach($def in $getDefinitions.value){

        $PoolLink = $UriPro + "/_apis/build/definitions/$($def.Id)?api-version=6.0"
        $Poolsdef = Invoke-RestMethod `
                        -Uri $PoolLink `
                        -Method get `
                        -Headers $AzureDevOpsAuthenicationHeader
                        

        foreach($definition in $Poolsdef){
            $ListOfCollectedData += New-Object -TypeName PSObject -Property @{
                            ProjectName=$definition.project.name
                            Pipeline = $definition.name
                            AgentPools = $definition.queue.name
                            AgentPoolsLink = $definition.queue.url
                            AgentsList = $allAgent = foreach($agents in $agetnsDetail){
                                if ( $definition.queue.name -eq $agents.PoolName ) {
                                    $agents.AgentName
                                }
                            }
                            AgentsStatus = foreach($agents in $agetnsDetail){
                                if ( $allAgent -eq $agents.AgentName ) {
                                    $agents.status
                                }
                            }
                            AgentsVMName = foreach($agents in $agetnsDetail){
                                if ( $allAgent -eq $agents.AgentName ) {
                                    $agents.AgentVMName
                                } 
                            }
                                     
                }
    
            }
            
        }
        $ListOfCollectedData | Format-Table ProjectName, Pipeline, AgentPools, AgentPoolsLink, AgentsList, AgentsStatus, AgentsVMName


        # | Select-Object -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool | Export-csv .\tutu.csv -NoTypeInformation

        # | Format-Table -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool
}
ListOfCollectedData