using namespace System.Net



# Input bindings are passed in via param block.

param($Request, $TriggerMetadata)


# Write to the Azure Functions log stream.

Write-Host "PowerShell HTTP trigger function processed a request."


# Interact with query parameters or the body of the request.

#$username = 'elitesvc'

#$pwd = 'Elite12345678'

$url = 'http://google.com/'

$req = [system.Net.WebRequest]::Create($url)

#$req.Credentials = New-Object System.Net.NetworkCredential($username, $pwd, $domain);
#$req.Credentials = New-Object System.Net.NetworkCredential($username, $pwd);

$result=''

try {

    $res = $req.GetResponse()

    $result = $res.StatusCode

}

catch [System.Net.WebException] {


   # $body = $_.Exception
}

#$result = $res.StatusCode
#$body = $result

$body = "Status Code: $result"

# Associate values to output bindings by calling 'Push-OutputBinding'.

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{

    StatusCode = [HttpStatusCode]::OK

    Body = $body

})