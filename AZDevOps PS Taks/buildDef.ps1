Param
(
    [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
    [string]$Organization = 'hulu007k',
    [string]$project = 'appGateWayTest'
    # [string]$dfID = 47

)
$table =@()


$hulu = @(
    $poolPipe = Invoke-RestMethod `
    -Uri "https://dev.azure.com/$($organisation)/_apis/distributedtask/pools?api-version=6.0" `
    -Method get `
    -Headers $headers
$Capabilities = $shac.systemCapabilities.'Agent.ComputerName' # | Get-Member | where {$_.MemberType -eq 'NoteProperty'}
$vm = Get-AzVM
)

 $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
 $UriOrganization = "https://dev.azure.com/$($Organization)/$($project)"
 #$dfapi = "/_apis/build/definitions/$($dfID)?api-version=6.0"

 $defUri = $UriOrganization + "/_apis/build/definitions?api-version=6.0"
 $defResult = Invoke-RestMethod `
                -Uri $defUri `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader 



foreach($def in $defResult.value){

 $UriPools = $UriOrganization + "/_apis/build/definitions/$($def.Id)?api-version=6.0"
 $PoolsResult = Invoke-RestMethod `
                -Uri $UriPools `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader

foreach($v in $PoolsResult){

    $table += New-Object -TypeName PSObject -Property @{
        ProjectName=$v.project.name
        Pipelines = $v.name
        ConnectedagentPool = $v.queue.name
        PoolLink = $v.queue.url
        AgentVM = $Capabilities
        Availablepool = $poolPipe.value.name
        Availablevm = $vm.Name 
        vmHostedRegion = $vm.Location
        

        
    }

}



}

$table | Select-Object -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool | Out-String.Trim('') |Export-csv .\tutu.csv -NoTypeInformation

# | Select-Object -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool | Export-csv .\tutu.csv -NoTypeInformation

# | Format-Table -Property ProjectName, Pipelines, ConnectedagentPool, PoolLink, AgentVM, Availablevm, vmHostedRegion, Availablepool