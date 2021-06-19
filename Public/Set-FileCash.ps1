function Set-FileCash {
    param(
        [string] $CashName,
        [Parameter(ValueFromPipeline)]
        [hashtable] $CashValue,
        [string[]] $Headers
    )

    begin{
        $path = "$PSScriptRoot\$CashName-Cash.json"
        if (-not(Test-Path -Path $path)) {
            $null = New-Item -Path $path
        }

        $cashContent = Get-Content -Path $path | ConvertFrom-Json -AsHashtable
        if (-not $cashContent) {
            $cashContent = [System.Collections.ArrayList]::new()
        }

        $resultObject = [PSCustomObject]@{
            Headers = $Headers
            Cash = $cashContent
        }
    }

    process{
        $null = $cashContent.Add($CashValue)
    }
    
    end{
        $null = Set-Content -Path $path -Value ($resultObject | ConvertTo-Json -Depth 10)
    }
}