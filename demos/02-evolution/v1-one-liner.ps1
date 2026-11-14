# v1: The one-liner.
# Works great. Once. For you. Until you need the other 87 Ricks.

(Invoke-RestMethod 'https://rickandmortyapi.com/api/character/?name=rick').results | Select-Object name, status, species
