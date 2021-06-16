function Set-FileCash {
    param(
        [string] $CashName,
        [hashtable] $CashValue
    )

    $path = "$PSScriptRoot\$CashName-Cash.json"
    if (-not(Test-Path -Path $path)) {
        New-Item -Path $path
    }

    $cashContent = Get-Content -Path $path | ConvertFrom-Json -AsHashtable
    if (-not$cashContent) {
        $cashContent = @{}
    }
    foreach ($newCashItem in $CashValue.GetEnumerator()) {
        $cashContent[$newCashItem.Name] = $newCashItem.Value
    }

    Set-Content -Path $path -Value ($cashContent | ConvertTo-Json)
}