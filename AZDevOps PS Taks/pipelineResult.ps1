function pipelineResult{
#     param (
#     [string] $Organization = 'hulu007k',
#     [string] $PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca'
# )

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$result = Invoke-RestMethod `
            -Uri "https://dev.azure.com/$Organization/_apis/projects?api-version=6.0" `
            -Method Get -Headers $headers

$projectNames = $result.value.name

$projectNames | ForEach-Object {
     $project = $_

    $pipelineResult = Invoke-RestMethod `
                -Uri "https://dev.azure.com/$Organization/$project/_apis/pipelines?api-version=6.0-preview.1" `
                -Method Get -Headers $headers
$pipelineResult.value
}


# Export-ModuleMember -Function pipelineResult

}

