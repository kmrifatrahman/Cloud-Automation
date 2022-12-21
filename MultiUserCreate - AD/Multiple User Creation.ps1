#Get-ADOrganizationalUnite -Identity NAS -Filter *
#Get-ADOrganizationalUnit
#New-ADOrganizationalUnit -Name "kk" -Path "DC=vm,DC=local"

#Get-ADOrganizationalUnit -Filter * -Properties
#Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A


$User = Import-Csv 'C:\Users\Rifat\Desktop\Book1.csv'       #calling the csv file by initializing path which contain multiple users
Write-Host $User

foreach ($User in $User){

    #Calling user detail from csv file

$UserName = $User.UserName
$FirstName = $User.FirsName
$LastName = $User.LastName
$Password = $User.Password
$Ous = $User.Ous
$dnn = $FirstName+$LastName

#adding users following the detail in csv file

New-ADUser `
-SamAccountName $UserName `
-UserPrincipalName "$UserName@vm.local" `
-Name "$FirstName $LastName" `
-GivenName $FirstName `
-Surname $LastName `
-Enabled $true `
-DisplayName $dnn `
-AccountPassword (ConvertTo-SecureString -String $Password -AsPlainText -Force) `
-Path $Ous

}