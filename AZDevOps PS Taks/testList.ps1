Param
    (
        [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
        [string]$Organization = 'hulu007k',
        [boolean]$export
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
                $Capabilities = $shac.systemCapabilities.'Agent.ComputerName' # | Get-Member | where {$_.MemberType -eq 'NoteProperty'}
                        $SelfHostedAgentCapabilities += New-Object -TypeName PSObject -Property @{
                            PoolName=$pool.name
                            AgentName=$agent.name
                            Status = $agent.status
                            AgentVMname = $Capabilities
                    
                
            }

            #$SelfHostedAgentCapabilities | Format-Table PoolName, AgentName, Status, Status | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$home\desktop\hulu2.csv"
            
        }
#| Format-Table PoolName, AgentName, Status, Status | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath "$home\desktop\hulu2.csv"
    }
}

$SelfHostedAgentCapabilities| Select-Object PoolName, AgentName, Status, AgentVMname | Export-Csv -path .\Agents.csv -NoTypeInformation


