function Resolve-AzPath {
    param(
        [string] $Path
    )

    $functionMap = if ($Path -match "^\\(?<Type>\w+)\\*") {
        Get-FunctionMap -Name $Matches.Type
    }
    else {
        Write-Error "Invalid Path: $Path"
        {}
    }

    if ($null -ne $functionMap) {
        $functionMap.Invoke($Path)
    }
    else {
        Write-Error "Not Supported Path $Path"
    }

}
Set-Alias -Name "az:" -Value "Resolve-AzPath"