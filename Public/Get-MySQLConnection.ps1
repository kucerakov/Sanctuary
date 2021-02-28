Function Get-MySQLConnection {
	#$server = Read-Host "Enter the server IP/Hostname"
	#$port = Read-Host "Enter what port to connect to"
	#$database = Read-Host "Enter the database name"
	#$username = Read-Host "Enter your username"
	#$password = Read-Host "Enter your password"
	#$connection = Connect-MySQL -user $username -password $password -Database $database -server $server -port $port
	$connection = Connect-MySQL -user root -password eqemu -Database peq -server localhost -port 3306
	return $connection
}

Export-ModuleMember -Function Get-MySQLConnection