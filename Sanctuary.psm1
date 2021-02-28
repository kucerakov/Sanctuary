New-Variable -Name ModuleRoot -value $PSScriptRoot -Option ReadOnly
$Public = @(Get-ChildItem -Path $ModuleRoot\Public -include *.ps1 -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $ModuleRoot\Private -include *.ps1 -Recurse -ErrorAction SilentlyContinue)

foreach ($import in @($Public + $Private)){
    try {
        . $Import.FullName
    } catch{
        Write-Error -Message "Failed to import fuction $($Import.BaseName): $_"
    }
}

foreach ($publicFunction in $Public) {
    Export-ModuleMember -Function $publicFunction.BaseName
}
