function Get-FunctionMap {
    param(
        [string] $Name
    )
    $script:FunctionMap.$Name
}