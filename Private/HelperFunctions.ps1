function Test-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}

Export-ModuleMember -function Test-Numeric