<#
	.Description
		Import-StoredCreds is designed to securely store and read a password for a user from a local file on the machine
	.Synopsis
		Import-StoredCreds is  designed to securely store and read a password for a user from a local file on the machine and was
		written specifically with UCS and VMware environments in mind. It first checks the username of the user who launched the 
		function. It then either pulls a password file previously created or prompts the user to enter a password to encrypt and store.
		When using the password, it reads the file and converts the password from a 2048-bit hashed string to plain-text. 
		Work is underway to change that conversion to SecureString.
	.Example
		Import-StoredCreds -username brebrigg
		Calls the function passing the username "brebrigg" as the argument for parameter "username"
	.Example
		Import-StoredCreds brebrigg
		Same as above. The -username is the only parameter and explicit specification is not necessary.
	.Input
		[string]
	.Notes
		Name: Import-StoredCreds
		Author(s): Jade Lester (jadleste@cisco.com) and Bren Briggs (bbriggs@milestonepowered.com)
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$UserName
)
If ($UserName -eq $null){
	Do {
		$UserName = Read-Host "Please Supply username for login"
	}
	Until ($UserName -ne $null)
}
# Enter location for all credential files. If statement verifies directory exists
# and creates directory if it does not.
$fileroot = "C:\scripts\credentials\"
If ((Test-Path -path $fileroot) -ne $True){
	New-Item $fileroot -type directory
}

# Checks to see if the User has the unique credential files and prompts to create them if they do not
$user_cred_filepath = $fileroot + $UserName + "_credentials.txt" 
if (!(Test-Path -Path $user_cred_filepath)){
	Write-Host "Your credentials file for access with this username do not seem to exist..."
	Write-Host ""
	Write-Host " Please enter you credentials now; it is displayed and stored securely..."
	read-host -assecurestring | convertfrom-securestring `
| 	out-file -FilePath $user_cred_filepath
}
else {
	Write-Host "Your credential file was found; proceeding..."
}

$READ_PASS_FILE = get-content $user_cred_filepath | convertto-securestring
$CONVERT_PASSWORD = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($READ_PASS_FILE)
$PASSWORD = [System.Runtime.InteropServices.Marshal]::ptrToStringAuto($CONVERT_PASSWORD)