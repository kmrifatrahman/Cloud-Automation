Param
    (
        [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
        [string]$Organization = 'hulu007k'
    )
$SelfHostedAgentCapabilities = @()

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
$UriOrganization = "https://dev.azure.com/$($Organization)/"

$UriPools = $UriOrganization + '/_apis/distributedtask/pools?api-version=6.0'
$PoolsResult = Invoke-RestMethod `
                -Uri $UriPools `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader


# $PoolsResult.value | Format-Table name, status

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
            $uriSelfHostedAgentCapabilities = $UriOrganization + "_apis/distributedtask/pools/$($pool.Id)/agents/$($agent.Id)?includeCapabilities=true&api-version=6.0"
            $SelfHostedAgentCapabilitiesResult = Invoke-RestMethod `
                                                -Uri $uriSelfHostedAgentCapabilities `
                                                -Method get `
                                                -Headers $AzureDevOpsAuthenicationHeader
            Foreach ($shac in $SelfHostedAgentCapabilitiesResult)
            {
                
                    $SelfHostedAgentCapabilities += New-Object -TypeName PSObject -Property @{
                        # CapabilityName=$cap.name
                        # CapabilityValue=$($shac.systemCapabilities.$($cap.name))
                        PoolName=$pool.name
                        AgentName=$agent.name
                        Status = $agent.status
                    }
                
            }
            $SelfHostedAgentCapabilities 
        }

# | Select-Object PoolName, AgentName, Status, AgentVMname | Export-Csv -path .\Agents.csv -NoTypeInformation
}


