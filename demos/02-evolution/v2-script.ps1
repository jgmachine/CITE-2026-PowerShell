# v2: The script.
# Gets every page now. Also: hardcoded name, hardcoded path, and output only a human can read.
# Works on my machine. (It doesn't even work on this machine. That's a Windows path.)

$name = 'rick'
$url = "https://rickandmortyapi.com/api/character/?name=$name"
$all = @()

while ($url) {
    $page = Invoke-RestMethod $url
    $all += $page.results
    $url = $page.info.next
}

Write-Host "Found $($all.Count) characters named $name"
$all | Select-Object name, status, species | Export-Csv 'C:\Users\me\Desktop\ricks_FINAL_v2.csv'
