param (
    [string] $organisation = 'hulu007k',
    [string] $personalAccessToken = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca'
)

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$result = Invoke-RestMethod -Uri "https://dev.azure.com/$organisation/_apis/projects?api-version=6.0" -Method Get -Headers $headers

$projectNames = $result.value.name

Write-Host '################### all pipelines ######################'

$projectNames | Foreach-Object {
    $project = $_

    $result = Invoke-RestMethod -Uri "https://dev.azure.com/$organisation/$project/_apis/pipelines?api-version=6.0-preview.1" -Method Get -Headers $headers 

    $result.value |Format-Table -Property name, links, url, id, _links, folder
} 
Write-Host '############### all pools ##################'

$PoolsResult = Invoke-RestMethod -Uri "https://dev.azure.com/$organisation/_apis/distributedtask/pools?api-version=6.0" -Method get -Headers $headers 
$PoolsResult.value | Sort-Object -Property autoProvision |Format-Table -Property name, createdOn, autoProvision, id, poolType, scope, owner
# | Sort-Object -Property autoProvision |Format-Table -Property name, createdOn, autoProvision, id, poolType, scope
