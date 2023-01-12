Param
(
    [string]$PAT = 'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca',
    [string]$Organization = 'hulu007k',
    [string]$project = 'appGateWayTest'

)

 $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
 $UriOrganization = "https://dev.azure.com/$($Organization)/$($project)"

 $UriPools = $UriOrganization + '/_apis/build/definitions/47?api-version=6.0'
 $PoolsResult = Invoke-RestMethod `
                -Uri $UriPools `
                -Method get `
                -Headers $AzureDevOpsAuthenicationHeader 

 $PoolsResult.queue                 # queue name = agent pool name






#| ConvertTo-Csv | Out-File -FilePath "$home\desktop\yuiop.csv"
