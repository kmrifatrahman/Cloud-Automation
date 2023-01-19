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
$ServiceConnection.subscriptionId #| Format-Table subscriptionId
# $ServiceConnection #| Format-Table subscriptions, subscriptionId, ServiceConn, isShared, isReady       
Export-ModuleMember -Function ServiceConnection
}

# ServiceConnection