$private = Get-ChildItem -Path "$PSScriptRoot\Private" -Filter "*.ps1"
$public = Get-ChildItem  -Path "$PSScriptRoot\Public" -Filter "*.ps1"

$private | Import-Module
$public | Import-Module
$public.BaseName | Export-ModuleMember