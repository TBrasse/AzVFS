function Register-FunctionMap{
    param(
        [string] $Type,
        [scriptblock] $FunctionMap
    )
    $script:FunctionMap[$Type] = $FunctionMap
}