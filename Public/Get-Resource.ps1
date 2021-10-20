function Get-Resource {
    param(
        [string] $Subscription,
        [string] $ResourceGroupFilter,
        [string] $ResourceType,
        [string] $ResourceFilter
    )
    Select-AzSubscription -Subscription $Subscription
    $rgs = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -match $ResourceGroupFilter }
    $resources = $rgs | ForEach-Object { Get-AzResource -ResourceGroupName $_.ResourceGroupName -ResourceType $ResourceType }
    $resources | Where-Object { $_.Name -match $ResourceFilter }
}
