$tmp = "adf.bicep"

New-AzResourceGroupDeployment `
    -ResourceGroupName 'adf_rft' `
    -TemplateFile $tmp