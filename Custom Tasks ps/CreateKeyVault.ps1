#Connect-AzAccounat
#Get-AzSubscription
#Select-AzSubscription -SubscriptionName 'Rifat_Rahman' //// change subscription selecting name
New-AzResourceGroup -Name "RG" -Location "eastus"

# creating keyvault using powershell command 
New-AzKeyVault -Name "hulu007k" -ResourceGroupName "RG" -Location "EastUS" 

#Changing permission of keyvault to access secrest key 
Set-AzKeyVaultAccessPolicy -VaultName "hulu007k" -UserPrincipalName "rifat_rahman@nidaansystems.com" -PermissionsToSecrets get,set,delete

$vaultname = 'hulu007k'
$secretvalue = ConvertTo-SecureString "hVFkk965BuUv" -AsPlainText -Force #valiable secret key value
[string]$nameKey = 'TestKey' #name of the secret key

Write-Host $secretvalue

#push $secretvalue to keyvault 
Set-AzKeyVaultSecret -VaultName $vaultname -Name $nameKey -SecretValue $secretvalue

