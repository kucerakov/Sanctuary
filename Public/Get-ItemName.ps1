Function Get-ItemName{
    [CmdletBinding()]
	param (

        # Item ID
		[Parameter(Mandatory = $true)]
		[int]
		$itemID
	)
	$itemDetails =  Invoke-MySQLQuery -Query "SELECT * FROM items WHERE id = $itemID"
    return $itemDetails.Name
}



Export-ModuleMember -Function Get-ItemName