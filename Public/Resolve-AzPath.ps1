function Resolve-AzPath {
    param(
        [string] $Path
    )

    $functionMap = if ($Path -match "^\\(?<Type>\w+)\\*") {
        Get-FunctionMap -Name $Matches.Type
    }
    else {
        Write-Error "Not supported Path: $Path"
        {}
    }

    if ($null -ne $functionMap) {
        $functionMap.Invoke($Path)
    }
    else {
        Write-Error "Not Supported Function Path $Path"
    }

}
Set-Alias -Name "azvfs" -Value "Resolve-AzPath" -Option AllScope