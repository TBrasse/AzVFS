Class AzResources : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $context = Get-AzContext
        $validValues = @("..", "ls", "pull")
        if (-not $context) {
            throw "no az context"
        }
        elseif (-not $Global:azSubscription) {
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
    if (get-azcontext) {
        $path = "az:\"
    }
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
    if (-not $Command){
        Write-Path
    }elseif ($Command -eq "pull"){
        Write-Path
        if ($Global:azResourceName) {
            $cash = Get-AzResource -ResourceGroupName $Global:azResourceGroup -ResourceName $Global:azResourceName | Select-Hashtable -Property Name,ResourceType,Location,Tags
            $cash | Set-FileCash -CashName "$Global:azResourceName-$($Global:azResourceGroup)" -Headers Name,ResourceType,Location,Tags
        }
        elseif ($Global:azResourceGroup) {
            $cash = (Get-AzResource -ResourceGroupName $Global:azresourcegroup) | Select-Hashtable -Property Name,ResourceType,Location,Tags
            $cash | Set-FileCash -CashName "Resources-$($Global:azResourceGroup)" -Headers Name,ResourceType,Location,Tags
        }
        elseif ($Global:azSubscription) {
            $cash = Get-AzResourceGroup | Select-Hashtable -Property ResourceGroupName,Location,Tags
            $cash | Set-FileCash -CashName "ResourceGroups-$($Global:azSubscription)" -Headers ResourceGroupName,Location,Tags
        }
        else {
            $cash = Get-AzSubscription | Select-Hashtable -Property Name,TenantId
            $cash | Set-FileCash -CashName "Subscriptions" -Headers Name,TenantId
        }
    }elseif ($Command -eq "..") {
        if ($Global:azResourceName) {
            $Global:azResourceName = $null
        }
        elseif ($Global:azResourceGroup) {
            $Global:azResourceGroup = $null
        }
        elseif ($Global:azSubscription) {
            $Global:azSubscription = $null
        }
        Write-Path
    } elseif ($Command -eq "ls") {
        Write-Path
        if ($Global:azResourceName) {
            Get-FileCash -CashName "$Global:azResourceName-$($Global:azResourceGroup)"
        }
        elseif ($Global:azResourceGroup) {
            Get-FileCash -CashName "Resources-$($Global:azResourceGroup)"
        }
        elseif ($Global:azSubscription) {
            Get-FileCash -CashName "ResourceGroups-$($Global:azSubscription)"
        }
        else {
            Get-FileCash -CashName "Subscriptions"
        }
    } else {
        if (-not $Global:azSubscription) {
            $null = Select-AzSubscription -SubscriptionName $Command -ErrorAction Stop
            $Global:azSubscription = $Command
        }
        elseif (-not $Global:azResourceGroup) {
            $Global:azResourceGroup = $Command
        }
        elseif (-not $Global:azResourceName) {
            $Global:azResourceName = (Get-AzResource -ResourceGroupName $Global:azresourcegroup -Name $Command).Name
        }
        else {
            Get-AzResource -ResourceGroupName $Global:azResourceGroup -Name $Global:azResourceName
        }
        Write-Path
    }
}

Set-Alias -Name acd -Value Set-AzLocation