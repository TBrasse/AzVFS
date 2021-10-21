function Get-AsperaFunctionMap {
    {
        param(
            [string] $Path
        )
        $fragments = $Path -replace ("/", "\") -replace ("\\\\", "\") -split ("\\")
        switch -Regex ($Path) {
            "^\\(?<Type>Aspera)\\?$" {
                $null = Select-AzSubscription -Subscription "e4dda59f-0d6e-43c7-9bd9-504195044086"
                $resourceGroups = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -match "RG.*Aspera.*" }
                $resourceGroups | Select-Object -ExpandProperty Location -Unique
            }
            "^\\Aspera\\(?<Region>\w+)\\?$" {
                $null = Select-AzSubscription -Subscription "e4dda59f-0d6e-43c7-9bd9-504195044086"
                $resources = Get-AzResource -ResourceGroupName "RG-$($Matches.Region)-*-Aspera-*"
                $resources | Select-Object -Property Name, ResourceType
            }
            "^\\Aspera\\(?<Region>\w+)\\(?<Resource>[\w,-]+)\\?$" {
                $null = Select-AzSubscription -Subscription "e4dda59f-0d6e-43c7-9bd9-504195044086"
                $resource = Get-AzResource -ResourceGroupName "RG-$($Matches.Region)-*-Aspera-*" -Name $Matches.Resource
                $resource | Resolve-Resource
            }
            "^\\Aspera\\(?<Region>\w+)\\vm\\?$" {
                $null = Select-AzSubscription -Subscription "e4dda59f-0d6e-43c7-9bd9-504195044086"
                Get-AzVm -ResourceGroupName "RG-$($Matches.Region)-*-Aspera-Compute" | Select-Object -Property Name, Tags -ExpandProperty HardwareProfile
            }
            "^\\Aspera\\(?<Region>\w+)\\kv\\?$" {
                $null = Select-AzSubscription -Subscription "e4dda59f-0d6e-43c7-9bd9-504195044086"
                Get-AzKeyVaultSecret -VaultName "kv-R1-$($Matches.Region)dev" | Select-Object -Property Name
            }
            "^\\Aspera\\(?<Region>\w+)\\kv\\(?<Secret>.*)$" {
                $null = Select-AzSubscription -Subscription "e4dda59f-0d6e-43c7-9bd9-504195044086"
                Get-AzKeyVaultSecret -VaultName "kv-R1-$($Matches.Region)dev" -Name $($Matches.Secret) -AsPlainText
            }
        }
    }
}