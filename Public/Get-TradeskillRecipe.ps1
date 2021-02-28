Function Get-TradeskillRecipe {
	[CmdletBinding()]
	param (
		# SQL Connection
		[Parameter(Mandatory = $true)]
		[PSTypeName("SQLConnection")]
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
		Write-Host "$itemName Requires:"
		foreach ($ingredient in $ingredients){
			if ($ingredient.iscontainer -neq 1){
				$ingredientId = $ingredient.item_id
				$ingredientDetails = Select-MySQL -Connection $connection -table "items" -where "id = $ingredientId"
				Write-Host "- $ingredientDetails.Name"
			}
			else{
				Write-Host "Combined in container:"
				foreach($ingredient in $ingredients){
					if($ingredient.iscontainer -eq 1){
						$ingredientId = $ingredient.item_id
						$ingredientDetails = Select-MySQL -Connection $connection -table "items" -where "id = $ingredientId"
						Write-Host "- $ingredientDetails.Name"
					}
				}
				
			}
		}

	}
	
}