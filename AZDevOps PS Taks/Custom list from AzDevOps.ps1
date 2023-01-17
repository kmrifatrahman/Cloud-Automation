param (
    [string] $organisation = 'hulu007k',
    [string] $personalAccessToken = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca'
)


$result=@()

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$project = Invoke-RestMethod `
            -Uri "https://dev.azure.com/$organisation/_apis/projects?api-version=6.0" `
            -Method Get `
            -Headers $headers

$projectNames = $project.value.name




Write-Host '################### all pipelines ######################'

$projectNames | Foreach-Object {
    $projectid = $_

    $pipe = Invoke-RestMethod `
                -Uri "https://dev.azure.com/$organisation/$projectid/_apis/pipelines?api-version=6.0-preview.1" `
                -Method Get `
                -Headers $headers 

$pipe.value |Format-Table -Property name, links, url, id, _links, folder
} 



Write-Host '############### all pools ##################'

$poolPipe = Invoke-RestMethod `
                -Uri "https://dev.azure.com/$organisation/_apis/distributedtask/pools?api-version=6.0" `
                -Method get `
                -Headers $headers 

$poolPipe.value.name | Sort-Object -Property autoProvision |Format-Table -Property name, createdOn, autoProvision, id, isHosted, isLegacy
# | Sort-Object -Property autoProvision |Format-Table -Property name, createdOn, autoProvision, id, poolType, scope
# $result += New-Object -TypeName PSObject -Property @{
#     
    
#     }

# $result