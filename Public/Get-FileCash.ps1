function Get-FileCash {
    param(
        [string] $CashName
    )

    $path = "$PSScriptRoot\$CashName-Cash.json"
    if(Test-Path $path){
        Get-Content -Path $path | ConvertFrom-Json -AsHashtable
    }else{
        @{}
    }
}