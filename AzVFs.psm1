$public = Get-ChildItem  -Path "$PSScriptRoot\Public" -Filter "*.ps1"

$public | Import-Module
$public.BaseName | Export-ModuleMember