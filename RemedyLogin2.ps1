# Open ie
$url = "your url here"
$username="your user name here"
$password="your pass word here"


#Login to remedy

$ie = New-Object -ComObject InternetExplorer.Application
$ie.Visible = $true
$ie.navigate($url);
$sw = @'
[DllImport("user32.dll")]
public static extern int ShowWindow(int hwnd, int nCmdShow);
'@
$type = Add-Type -Name ShowWindow2 -MemberDefinition $sw -Language CSharpVersion3 -Namespace Utils -PassThru
$type::ShowWindow($ie.hwnd, 3) # 3 = maximize
while ($ie.Busy -eq $true)
{
	Start-Sleep -Milliseconds 1000;
}

# if you use this script with another web app, you must find the "ElementId" inside the HTML

$ie.Document.getElementById("username-id").value = $username
$ie.Document.getElementByID("pwd-id").value=$password
$ie.Document.getElementById("login").Click();