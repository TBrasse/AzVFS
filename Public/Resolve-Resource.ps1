function Resolve-Resource {
    param(
        [Parameter(ValueFromPipeline)]
        [Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.PSResource] $Resource
    )
    process {
        switch ($Resource.ResourceType) {
            "Microsoft.Network/loadBalancers" { $Resource | Get-AzLoadBalancer }
            "Microsoft.Compute/virtualMachines" { $Resource | Get-AzVm }
            Default {
                Write-Error "Not handled type $($Resource.ResourceType)"
            }
        }
    }
}