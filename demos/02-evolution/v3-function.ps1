# v3: The function.
# A parameter instead of a hardcoded name. It outputs objects, and the caller decides what to do with them.
# (Export to CSV? Filter? Count? Not this function's problem anymore.)

function Get-RMCharacter {
    param($Name)

    $url = "https://rickandmortyapi.com/api/character/?name=$Name"
    while ($url) {
        $page = Invoke-RestMethod $url
        $page.results
        $url = $page.info.next
    }
}
