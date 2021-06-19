function Get-FileCash {
    param(
        [string] $CashName
    )

    $path = "$PSScriptRoot\$CashName-Cash.json"
    if(Test-Path $path){
        $cashContent = Get-Content -Path $path | ConvertFrom-Json -AsHashtable
        if (-not$cashContent) {
            @{}
        }
        $cashContent.Cash | Select-Object -Property $cashContent.Headers
    }
}