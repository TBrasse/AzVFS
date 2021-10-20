$Global:FunctionMap = @{}

function Get-FunctionMap {
    param(
        [string] $Name
    )

    $FunctionMap.$Name

    # switch ($Name) {
    #     "Aspera" { Get-AsperaFunctionMap }
    #     Default {
    #         Write-Error "Not supported Function Type $Name"
    #     }
    # }
}