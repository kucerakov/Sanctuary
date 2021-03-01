Function Add-TradeskillRecipe {
	[CmdletBinding()]
	param (
		# SQL Connection
		[Parameter(Mandatory = $true)]
		[object]
		$connection
	)
    
    clear
    Write-Warning "This commandlet will walk you through creating a new tradeskill recipe. If at any point you aren't confident how to answer, use CTRL+C to quit and nothing will be committed to the database."
    Write-Host "`n"
    Write-Warning "When adding your items, you can use name or item id. If using name, it must match EXACTLY so IDs are recommended. You can use the Get-ItemID commandlet to make things easier."
    Write-Host "`nFirst, let's add ingredients."
    $ingredientCount = Read-Host "How many UNIQUE ingredients are in your recipe?"
    $containerCount = Read-Host "How many containers can this recipe be completed in?"
    $creationCount = Read-Host "How many DIFFERENT items does this recipe create (including any items that are part of the recipe and then returned to the player)?"
    Write-Host "`nYour recipe is going to consist of:"
    Write-Host "- " $ingredientCount "ingredients"
    Write-Host "- Can be made in" $containerCount "containers"
    Write-Host "- Will create" $creationCount "new items for the player when successful"
    $continue = Read-Host "`nDoes this look correct? (Y/N)"
    switch($continue){
        'y' {continue}
        'n' {return}
        default {Write-Host "Response not recognized. Quitting..."; return}
    }

    # Array of ingredient item IDs
    $ingredientList = @()

    # Array of container item IDs
    $containerList = @()

    # Array of creation item IDs
    $createList = @()

    # Gather Ingredients
    for($i=1;$i -le $ingredientCount; $i++){
        $ingredient = Read-Host "Ingredient Item" $i
        if(Test-Numeric $ingredient){
            # Check to ensure the item exists
            $itemName = Get-ItemName $ingredient
            if($itemName.count -lt 1){Write-Host "$ingredient not found in items database. Quitting...";return}
            else{$ingredientList += $ingredient}
        }
        else{
            $ingredientItemID = Get-ItemID $ingredient
            switch($ingredientItemID){
                ($ingredientItemID.count -lt 1){Write-Host "$ingredient not found. Use Get-ItemID then try again. Quitting...";return}
                ($ingredientItemID.count -gt 1){Write-Host "There is more than one item named $ingredient. Use Get-ItemID then try again. Quitting...";return}
                default{$ingredientList += $ingredientItemID}
            }
        }
            
    }
    $ingredientList
}

Export-ModuleMember -Function Add-TradeskillRecipe