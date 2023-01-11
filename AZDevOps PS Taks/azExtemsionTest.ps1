# az devops login --organization https://dev.azure.com/hulu007k #login to az devOps
# Token:'zlvptx5cfvn4ehwc7nyipmbrczmjy2cmboksowi723i5yrfun6ca'
# az config set extension.use_dynamic_install=yes_without_prompt
# az extension add --name azure-devops

#list of available pools
az pipelines pool list --out table

#list of available agent  under specified pool
az pipelines agent list --pool-id 12 --out table 

#list of available pipeline under specified project
az pipelines runs list --project appGateWayTest --out table

#all pipeline within the project under the organization
az pipelines runs list --organization https://dev.azure.com/hulu007k --project appGateWayTest --out table

az pipelines pool show --org https://dev.azure.com/hulu007k --pool-id 12 --out table

az pipelines agent show --org https://dev.azure.com/hulu007k --pool-id 12 --agent-id 14 --out table


Install-Module -Name VSTeam




