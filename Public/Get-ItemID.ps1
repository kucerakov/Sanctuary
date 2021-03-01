Function Get-ItemID{
    [CmdletBinding()]
	param (
		# Item Name
		[Parameter(Mandatory = $true)]
		[string]
		$itemName
	)
	$itemDetails = Invoke-MySQLQuery -Query "SELECT * FROM items WHERE name = ""$itemName"""
    
    return $itemDetails.id
}

Export-ModuleMember -function Get-ItemID