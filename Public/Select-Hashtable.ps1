function Select-Hashtable{
    param(
        [Parameter(ValueFromPipeline)]
        [object] $InputObject,
        [string[]] $Property
    )

    begin{
        $itemsCollection = [System.Collections.ArrayList]::new()
    }

    process{
        $itemHashTable = @{}
        foreach($item in $Property){
            $member = Get-Member -Name $item -InputObject $InputObject -MemberType Property
            $itemHashTable[$member.Name] = $InputObject.($member.Name)
        }
        $null = $itemsCollection.Add($itemHashTable)
    }
    
    end{
        $itemsCollection
    }
}