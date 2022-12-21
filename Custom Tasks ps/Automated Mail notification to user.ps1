$pw = "Jh0hfg1pXtep"    #PAssword 
$from = "rifat@fronturetech.com"    #email address of admin 
$to = "kmrifatrahman@gmail.com"     #Destination email

#Script to automated mail notification/Email Message

Send-MailMessage `
-SmtpServer "smtp.zoho.com" `
-Port 587 `
-From $from `
-To $to `
-Subject "Account Creation" `
-Body ("This is your password "+"$pw") `
-UseSsl `
-Credential (New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $from, (ConvertTo-SecureString `
-String $pw -AsPlainText `
-Force)) 