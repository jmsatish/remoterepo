$SqlServer = "localhost"
$SqlDBName = "AdventureWorks2016"
 
Add-Type -Path "C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
 
$SqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server($SqlServer)
 
# get all of the current logins and their types
$SqlServer.Logins |
    Select-Object Name, LoginType, Parent
 
# create a new login by prompting for new credentials
$NewLoginCredentials = Get-Credential -Message "Enter credentials for the new login"
$NewLogin = New-Object Microsoft.SqlServer.Management.Smo.Login($SqlServer, $NewLoginCredentials.UserName)
$NewLogin.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
$NewLogin.Create($NewLoginCredentials.Password)
 
# create a new database user for the newly created login
$NewUser = New-Object Microsoft.SqlServer.Management.Smo.User($SqlServer.Databases[$SqlDBName], $NewLoginCredentials.UserName)
$NewUser.Login = $NewLoginCredentials.UserName
$NewUser.Create()
$NewUser.AddToRole("db_datareader")
