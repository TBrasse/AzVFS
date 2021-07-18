Class AzResources : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $validValues = @("..", "ls", "pull")
        if (-not $Global:azSubscription) {
            return [string[]] $validValues + (Get-FileCash -CashName "Subscriptions").Name
        }
        elseif (-not $Global:azResourceGroup) {
            return [string[]] $validValues + (Get-FileCash -CashName "ResourceGroups-$($Global:azSubscription)").ResourceGroupName
        }
        elseif (-not $Global:azResourceName) {
            return [string[]] $validValues + (Get-FileCash -CashName "Resources-$($Global:azResourceGroup)").Name
        }
        else {
            return $validValues
        }
    }
}

function Write-Path {
    $path = "az:\"
    if ($Global:azSubscription) {
        $path += "$Global:azSubscription\"
    }
    if ($Global:azResourceGroup) {
        $path += "$Global:azResourceGroup\"
    }
    if ($Global:azResourceName) {
        $path += "$Global:azResourceName\"
    }
    Write-Output $path
}

function Set-AzLocation {
    param(
        [ValidateSet([AzResources])]
        [string] $Command
    )
    if (-not $Command) {
        Write-Path
    }
    elseif ($Command -eq "pull") {
        Write-Path
        switch (Get-CurrentLevel) {
            "Resource" {
                $cash = Get-AzResource -ResourceGroupName $Global:azResourceGroup -ResourceName $Global:azResourceName | Select-Hashtable -Property Name, ResourceType, Location, Tags
                $cash | Set-FileCash -CashName "$Global:azResourceName-$($Global:azResourceGroup)"
                break;
            }
            "ResourceGroup" {
                $cash = (Get-AzResource -ResourceGroupName $Global:azresourcegroup) | Select-Hashtable -Property Name, ResourceType, Location, Tags
                $cash | Set-FileCash -CashName "Resources-$($Global:azResourceGroup)"
                break;
            }
            "Subscription" {
                $cash = Get-AzResourceGroup | Select-Hashtable -Property ResourceGroupName, Location, Tags
                $cash | Set-FileCash -CashName "ResourceGroups-$($Global:azSubscription)"
                break;
            }
            $null {
                $null = Connect-AzAccount
                $subscriptons = Get-AzSubscription | Select-Hashtable -Property Name, TenantId
                Set-FileCash -CashName "Subscriptions" -CashValue $subscriptons
                $tenants = get-aztenant | Select-Object -Property Id, Name
                Set-FileCash -CashName "Tenants" -CashValue $tenants
            }
        }
    }
    elseif ($Command -eq "..") {
        switch (Get-CurrentLevel) {
            "Resource" { $Global:azResourceName = $null;break}
            "ResourceGroup" { $Global:azResourceGroup = $null;break }
            "Subscription" {
                $Global:azSubscription = $null
                $null = Disconnect-AzAccount
                break
            }
        }
        Write-Path
    }
    elseif ($Command -eq "ls") {
        Write-Path
        switch (Get-CurrentLevel) {
            "Resource" { Get-FileCash -CashName "$Global:azResourceName-$($Global:azResourceGroup)";break }
            "ResourceGroup" { Get-FileCash -CashName "Resources-$($Global:azResourceGroup)";break }
            "Subscription" { Get-FileCash -CashName "ResourceGroups-$($Global:azSubscription)";break }
            $null {
                $tenants = Get-FileCash -CashName "Tenants"
                $subscriptons = Get-FileCash -CashName "Subscriptions"
                $subscriptons | ForEach-Object {
                    $subs = $_
                    $subs.TenantName = ($tenants | Where-Object { $_.Id -eq $subs.TenantId }).Name
                }
                $subscriptons | Select-Object -Property Name, TenantName
            }
        }
    }
    else {
        switch (Get-CurrentLevel) {
            "ResourceGroup" { $Global:azResourceName = (Get-AzResource -ResourceGroupName $Global:azresourcegroup -Name $Command).Name;break }
            "Subscription" { $Global:azResourceGroup = $Command;break }
            $null {
                $null = Select-AzSubscription -SubscriptionName $Command -ErrorAction Stop
                $Global:azSubscription = $Command
            }
        }
        Write-Path
    }
}