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