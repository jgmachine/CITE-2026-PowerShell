# MultiverSIS: client module for the Multiverse Student Information System.

# Set by Connect-MultiverSIS. Lives in memory for this session only.
$script:Connection = $null

foreach ($file in Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1", "$PSScriptRoot/Public/*.ps1") {
    . $file.FullName
}

# Four properties or fewer means PowerShell shows a table by default.
Update-TypeData -TypeName 'MultiverSIS.Student' -DefaultDisplayPropertySet StudentId, FirstName, LastName, School -Force
