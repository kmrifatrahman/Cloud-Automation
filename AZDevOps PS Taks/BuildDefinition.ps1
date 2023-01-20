Param
(
    [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
    [string]$Organization = 'hulu007k',
    [string]$project = 'appGateWayTest'

)

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
    
    } #PoolAgentStatus
    
function BuildDefinition{



$BuildDefinition =@()

$value = PoolAgentStatus
# $value
# $value.PoolName

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
                        
            # $Poolsdef


        foreach($definition in $Poolsdef){
            # $i = 0
            $BuildDefinition += New-Object -TypeName PSObject -Property @{
                            ProjectName=$definition.project.name
                            Pipeline = $definition.name
                            AgentPool = $definition.queue.name
                            PoolLink = $definition.queue.url
                            AgentList = foreach($val in $value){
                                if ( $definition.queue.name -eq $val.PoolName ) {
                                    $val.AgentName
                                }
                            }
                            AgentStatus = foreach($val in $value){
                                if ( $definition.queue.name -eq $val.PoolName ) {
                                    $val.status
                                }
                            }
                            AgentVMName = foreach($val in $value){
                                if ( $definition.queue.name -eq $val.PoolName ) {
                                    $val.AgentVMName
                                } 
                            }
                            #          
                }
                # $i++ 
            }
            
        }
        $BuildDefinition | Format-Table ProjectName, Pipeline, AgentPool, PoolLink, AgentList, AgentStatus, AgentVMName


        # | Select-Object -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool | Export-csv .\tutu.csv -NoTypeInformation

        # | Format-Table -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool
}
BuildDefinition