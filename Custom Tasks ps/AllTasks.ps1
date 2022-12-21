Import-Module ActiveDirectory


#$pw = "root@123" ##Hardcode password

###Auto generate PW

$uc =  ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".tochararray() | sort {Get-Random})
$lc = ("abcdefghijklmnopqrstuvwxyz".tochararray() | sort {Get-Random})
$Ch = ("!@#$%^*&*".ToCharArray()| sort {Get-Random})
$No = ("1234567890*".ToCharArray() | sort {Get-Random})


$All = Get-Random -Count 16 -InputObject ($uc+$lc+$Ch+$No+$uc+$lc+$Ch+$No)
$pw = $All -join("")


$Statement = "
1 to get users of AD;
2 to add New user;
3 to reset pw;
4 to Add Group;
5 to Add member to group
"
##Statement of Which tasks to choose



Write-Host = $Statement #Printing the statements

#param (
#   [parameter(Mandatory=$True)][string] $TaskNo # Taking inputs for tasks as number
#   )
$TaskNo = Read-Host ("Enter Task Number ")



function GetUsers{
Get-ADUser `
-Filter * `
-Properties samAccountName | select samAccountName


} #Get User list function no. 1


Function AutoMail{

$pwsd = "Jh0hfg1pXtep"
$from = "rifat@fronturetech.com"
$to = "mdear_ali@nidaansystems.com"

Send-MailMessage `
-SmtpServer "smtp.zoho.com" `
-Port 587 `
-From $from `
-To $to `
-Subject "Account Creation." `
-Body ("- This is an auto generated Mail -
Please Do not reply to this mail.
Your Account Has been created Successfully.
User name : "+$n+
"
Password : "+$pw) -UseSsl `
-Credential `
(New-Object -TypeName System.Management.Automation.PSCredential `
-ArgumentList $from, (ConvertTo-SecureString $pwsd -AsPlainText -Force))

 
} #Sending Message mail | Automail function.




Function AddUser{

$n = Read-Host ("Enter User Name ")


New-ADUser `
-Name $n `
-AccountPassword (ConvertTo-SecureString -AsPlainText $pw -Force) `
-Enabled $true 

AutoMail
GetUsers

} #add new user, Automate notificationmail, function no. 2




Function ResetPW{
Get-ADUser -Filter * `
-Properties samAccountName | select samAccountName

param (
    [parameter(Mandatory=$True)][string] $UserN #Intput name to reset

      )

Set-ADAccountPassword $UserN -Reset
} #reset pw function no.3





Function GroupADD{
param (
    [parameter(Mandatory=$True)][string] $GroupName

      )


 ###For Addeing the Created User to a specific Group###


New-ADGroup $GroupName

Write-Host ("The new group "+$GroupName+(" added Successfully"))

}#4 to Add New Group






Function GroupM{
param (
    [parameter(Mandatory=$True)][string] $GroupName,
    [parameter(Mandatory=$True)][string] $UserName

      )



Add-ADGroupMember `
-Identity $GroupName `
-Members $UserName

Write-Host ("User "+$UserName+" Has been added to "+$GroupName+" Group")

} # 5 For Addeing the Created User to a specific Group

if ( $TaskNo -eq 1 )
{
GetUsers
}

if ($TaskNo -eq 2)
{
AddUser
}

if ($TaskNo -eq 3)
{
ResetPW
}

if ($TaskNo -eq 4)
{
GroupADD
}

if ($TaskNo -eq 5)
{
GroupM
}




# execution of functions using if statements based on users choice of execution
