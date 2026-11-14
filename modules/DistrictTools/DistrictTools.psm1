# DistrictTools: the glue between systems. This is where your district's rules live.

# The "vendor" says Alive/Dead/unknown. Our SIS says Active/Withdrawn/Unknown.
$script:StatusMap = @{
    Alive   = 'Active'
    Dead    = 'Withdrawn'
    unknown = 'Unknown'
}

# Grade placement, as determined by the Central Finite Curve (character ID mod 14).
$script:Grades = 'TK', 'K', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'

# Species -> program. Anything not listed lands in General Education.
$script:Programs = @{
    Alien                   = 'Interdimensional Exchange'
    Robot                   = 'CTE: Robotics'
    Animal                  = 'Agriculture Science'
    'Mythological Creature' = 'Theater Arts'
    Cronenberg              = 'Independent Study'
    Disease                 = "Nurse's Office"
    unknown                 = 'Pending Placement'
}

# Records we don't bring into the SIS. If one of these appears in a character's name,
# origin, location, or type, ConvertTo-SISStudent skips that character. The vendor's data
# comes from an adult cartoon; a student information system gets shown to a room.
$script:ExcludedWords = @(
    'Fascist', 'Hitler', 'Abradolf', 'Slaveowner'
    'Butthole', 'in Butt', 'Fart', 'shiter'
    'Boobed', 'Booby', 'Boobie', 'Boobloosian', 'Nipple', 'Vagina', 'Dicknose', 'Pussifer', 'Testicle', 'Scrot', 'Genital', 'Taint Washer'
    'Slut', 'Sperm', 'Sexy', 'Incest', 'Gonorrhea', 'Non-Gasm', 'Men Can See it All'
)

foreach ($file in Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1") {
    . $file.FullName
}

Update-TypeData -TypeName 'DistrictTools.StudentRecord' -DefaultDisplayPropertySet FirstName, LastName, Grade, School -Force
