Import-Module ActiveDirectory


#$pw = "root@123" ##Hardcode password

###Auto generate PW

$uc =  ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".tochararray() | sort {Get-Random})
$lc = ("abcdefghijklmnopqrstuvwxyz".tochararray() | sort {Get-Random})
$Ch = ("!@#$%^*".ToCharArray()| sort {Get-Random})
$No = ("1234567890*".ToCharArray() | sort {Get-Random})


$All = Get-Random -Count 10 -InputObject ($uc+$lc+$Ch+$No)
$pw = $All -join("")
$pw


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
$to = "anik@fronturetech.com"

Send-MailMessage `
-SmtpServer "smtp.zoho.com" `
-Port 587 `
-From $from `
-To $to `
-Subject "Account Creation" `
-Body ("Your Account Has been created Successfully.
User name "+$n+
"Password "+$pw) -UseSsl `
-Credential (New-Object -TypeName System.Management.Automation.PSCredential `
-ArgumentList $from, (ConvertTo-SecureString -String $pwsd -AsPlainText -Force)) 

}




Function AddUser{

param (
    [parameter(Mandatory=$True)][string] $n  #Intput Name

      )

New-ADUser `
-Name $n `
-AccountPassword (ConvertTo-SecureString -AsPlainText $pw -Force) `
-Enabled $true 

Get-ADUser `
-Filter * `
-Properties samAccountName | select samAccountName

AutoMail

} #add new user, Automate notificationmail, function no. 2


if ($TaskNo -eq 2)
{
AddUser
}