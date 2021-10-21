function Resolve-Resource {
    param(
        [Parameter(ValueFromPipeline)]
        [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResource] $Resource
    )
    process {
        switch ($Resource.ResourceType) {
            "Microsoft.Network/networkSecurityGroups" { $Resource | Get-AzNetworkSecurityGroup }
            "Microsoft.Network/trafficmanagerprofiles" { $Resource | Get-AzTrafficManagerProfile }
            "Microsoft.Network/networkInterfaces" { $Resource | Get-AzNetworkInterface }
            "Microsoft.Network/publicIPAddresses" { $Resource | Get-AzPublicIpAddress }
            "Microsoft.KeyVault/vaults" { $Resource | ForEach-Object { Get-AzKeyVault -VaultName $_.Name -ResourceGroupName $_.ResourceGroupName } }
            "Microsoft.Network/loadBalancers" { $Resource | Get-AzLoadBalancer }
            "Microsoft.Compute/virtualMachines" { $Resource | Get-AzVm }
            Default {
                $Resource
                Write-Error "Not supported type $($Resource.ResourceType)"
            }
        }
    }
}