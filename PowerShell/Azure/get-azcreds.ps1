
# Calling this File will Display the Get-Credential GUI and pass the pscredential object back to the main script

#function Show-InputForm() {
    [CmdletBinding()]
    [OutputType([pscredential])]
    param ()
                $credential = Get-Credential -Message "Please Enter the Account Credentials"
                $username   = $credential.Username
                $password   = $credential.GetNetworkCredential().Password
                $credential

                #$username 
                #$password
#            }
#$obj = Show-InputForm
#$obj[1]
