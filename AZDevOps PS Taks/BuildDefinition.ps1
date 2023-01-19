function BuildDefinition{
    Param
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
}
# BuildDefinition