function Get-CurrentLevel {
    if ($Global:azResourceName) {
        "Resource"
    }
    elseif ($Global:azResourceGroup) {
        "ResourceGroup"
    }
    elseif ($Global:azSubscription) {
        "Subscription"
    }
    $null
}