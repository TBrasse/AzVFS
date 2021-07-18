function Set-FileCash {
    param(
        [string] $CashName,
        [object] $CashValue
    )
    $path = "$PSScriptRoot\$CashName-Cash.json"
    if (-not(Test-Path -Path $path)) {
        $null = New-Item -Path $path
    }
    $jsonContent = $CashValue | ConvertTo-Json -Depth 10
    Set-Content -Path $path -Value $jsonContent
}