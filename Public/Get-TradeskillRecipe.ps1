Function Get-TradeskillRecipe {
	[CmdletBinding()]
	param (
		# Item Name
		[Parameter(Mandatory = $true)]
		[string]
		$itemName
	)

    # Initialize arrays
    $creationList= @()
    $ingredientList = @()
    $containerlist = @()

	# Get SQL row
	$tsRecipes = Invoke-MySQLQuery -Query "SELECT * FROM tradeskill_recipe WHERE name = ""$itemName"""
    #$tsRecipes = Select-MySQL -Connection $connection -table "tradeskill_recipe" -where "name = '$itemName'"
	if ($tsRecipes -eq $null){
		Write-Error "<$itemName> not found in tradeskill_recipe table."
		return
	}

	# Get items needed for recipe, there could be more than one way to make it
	foreach ($tsRecipe in $tsRecipes){
		$recipeID = $tsRecipe.ID
        $ingredients = Invoke-MySQLQuery -Query "SELECT * FROM tradeskill_recipe_entries WHERE recipe_id = ""$recipeID"""
		#$ingredients = Select-MySQL -Connection $connection -table "tradeskill_recipe_entries" -where "recipe_id = $recipeID"
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
        Write-Host (Get-ItemName $item.item_id) "x" $item.componentCount
    }

    # Container List
    Write-Host "`nCan be combined in:"
    Write-Host "-------------------"
    foreach($item in $containerList){
        Write-Host (Get-ItemName $item.item_id)
    }

    # Items created list
    Write-Host "`nUpon success, player receives:"
    Write-Host "------------------------------"
    foreach($item in $creationList){
        Write-Host (Get-ItemName $item.item_id) "x" $item.successCount
    }

}

Export-ModuleMember -Function Get-TradeskillRecipe