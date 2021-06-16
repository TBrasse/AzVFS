function Get-FileCash {
    param(
        [string] $CashName
    )

    $path = "$PSScriptRoot\$CashName-Cash.json"
    $cashContent = Get-Content -Path $path | ConvertFrom-Json -AsHashtable
    if (-not$cashContent) {
        @{}
    }
    $cashContent
}