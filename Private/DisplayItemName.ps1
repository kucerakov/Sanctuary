Function DisplayItemName{
    [CmdletBinding()]
	param (
		# Array of items
		[Parameter(Mandatory = $true)]
		[int]
		$itemID
	)
    $itemID = $item.item_id
	$itemDetails = Select-MySQL -Connection $connection -table "items" -where "id = $itemID"
    return $itemDetails.Name
}

Export-ModuleMember -Function DisplayItemName