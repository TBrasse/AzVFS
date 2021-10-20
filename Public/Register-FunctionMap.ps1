function Register-FunctionMap{
    param(
        [string] $Type,
        [scriptblock] $FunctionMap
    )
    $Global:FunctionMap["Aspera"] = $FunctionMap
}