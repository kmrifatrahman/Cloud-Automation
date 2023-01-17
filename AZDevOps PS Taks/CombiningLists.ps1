Param(
    [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca', 
    [string]$Organization = 'hulu007k',
    [boolean]$export
)

$poolandAgent = @()


$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
$UriOrganization = "https://dev.azure.com/$($Organization)/"


$UriPools = $UriOrganization + '/_apis/distributedtask/pools?api-version=6.0'
$PoolsResult = Invoke-RestMethod `
                -Uri $UriPools `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader



    Foreach ($pool in $PoolsResult.value)
    {
        #if ($pool.agentCloudId -ne 1)
        
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

                            $poolandAgent += New-Object -TypeName PSObject -Property @{
                                PoolName=$pool.name
                                AgentName=$agent.name
                                Status = $agent.status
                                AgentVMname = $Capabilities    
                            }

                        
                        
                        }

                }
    }

$poolandAgent





# | Select-Object PoolName, AgentName, Status, AgentVMname | Export-Csv -path .\Agents.csv -NoTypeInformation