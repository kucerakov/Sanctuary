Function Get-TradeskillRecipe {
	[CmdletBinding()]
	param (
		# SQL Connection
		[Parameter(Mandatory = $true)]
		[object]
		$connection,

		# Item Name
		[Parameter(Mandatory = $true)]
		[string]
		$itemName
	)

	# Extra check to ensure a connection was passed in
	if ($connection -eq $null){
			Write-Error "Must pass in SQL Connection. Run $connection = Get-SQLConnection and pass in $connection to this function."
			return
	}


    # Initialize arrays
    $creationList= @()
    $ingredientList = @()
    $containerlist = @()

	# Get SQL row
	$tsRecipes = Select-MySQL -Connection $connection -table "tradeskill_recipe" -where "name = '$itemName'"
	if ($tsRecipes -eq $null){
		Write-Error "<$itemName> not found in tradeskill_recipe table."
		return
	}

	# Get items needed for recipe, there could be more than one way to make it
	foreach ($tsRecipe in $tsRecipes){
		$recipeID = $tsRecipe.ID
		$ingredients = Select-MySQL -Connection $connection -table "tradeskill_recipe_entries" -where "recipe_id = $recipeID"
		# Show user items
		Write-Host "Tradeskill Recipe for" $itemName ":"
		foreach ($ingredient in $ingredients){
			if ($ingredient.successcount -gt 0){
			    $creationList += $ingredient
			}
            if ($ingredient.componentcount -gt 0){
                $ingredientList += $ingredient
            }
			if ($ingredient.iscontainer -eq 1){
                $containerlist += $ingredient
            }
        }
    }

    # Ingredient List
    Write-Host "`nIngredients:"
    Write-Host "------------"
    foreach($item in $ingredientList){
        Write-Host (DisplayItemName $item.item_id) "x" $item.componentCount
    }

    # Container List
    Write-Host "`nCan be combined in:"
    Write-Host "-------------------"
    foreach($item in $containerList){
        Write-Host (DisplayItemName $item.item_id)
    }

    # Items created list
    Write-Host "`nUpon success, player receives:"
    Write-Host "------------------------------"
    foreach($item in $creationList){
        Write-Host (DisplayItemName $item.item_id) "x" $item.successCount
    }

}

Export-ModuleMember -Function Get-TradeskillRecipe