#Requires -Version 7.4
#Requires -Modules @{ ModuleName = 'Pode'; ModuleVersion = '2.14.0'; MaximumVersion = '2.999.999' }

<#
.SYNOPSIS
Starts MultiverSIS, the Multiverse Student Information System.

.DESCRIPTION
A tiny web API written in PowerShell with the Pode module. It stores students
in a JSON file, requires an API key, and serves a live dashboard in your browser.

It contains zero real students. Please keep it that way.

Leave it running in its own terminal. Every request shows up in the log below the banner.

.PARAMETER Port
The port to listen on. Defaults to 8080.

.PARAMETER Reset
Puts the database back to the four starter students.

.EXAMPLE
./server/Start-MultiverSIS.ps1

.EXAMPLE
./server/Start-MultiverSIS.ps1 -Reset
#>
[CmdletBinding()]
param(
    [int] $Port = 8080,
    [switch] $Reset
)

$dataDir       = Join-Path $PSScriptRoot 'data'
$dbPath        = Join-Path $dataDir 'multiversis.json'
$keyPath       = Join-Path $dataDir 'apikey.txt'
$dashboardPath = Join-Path $PSScriptRoot 'public/index.html'
$seedPath      = Join-Path $PSScriptRoot 'seed.json'
$null = New-Item -ItemType Directory -Path $dataDir -Force

if ($Reset -or -not (Test-Path $dbPath)) {
    Copy-Item -Path $seedPath -Destination $dbPath -Force
}

# The server keeps its own copy of the key so it can check requests. Your scripts should not. (See Act 4.)
if (-not (Test-Path $keyPath)) {
    'mvs_' + [Convert]::ToHexString([Security.Cryptography.RandomNumberGenerator]::GetBytes(16)).ToLower() |
        Set-Content -Path $keyPath -NoNewline
}
$apiKey = (Get-Content -Path $keyPath -Raw).Trim()

# Load the database. Lists (instead of arrays) so we can add to them.
$db = Get-Content -Path $dbPath -Raw | ConvertFrom-Json -AsHashtable
$db.Students = [System.Collections.Generic.List[object]]@($db.Students)

Write-Host ''
Write-Host '  MultiverSIS: the Multiverse Student Information System' -ForegroundColor Green
Write-Host "  Dashboard : http://localhost:$Port"
Write-Host "  API key   : $apiKey" -ForegroundColor Yellow
Write-Host "  Store it  : Set-Secret -Name MultiverSIS -Secret '$apiKey'" -ForegroundColor DarkGray
Write-Host '  Stop      : Ctrl+C' -ForegroundColor DarkGray
Write-Host ''

Start-PodeServer -Threads 2 {
    Add-PodeEndpoint -Address localhost -Port $Port -Protocol Http
    New-PodeLogTerminalMethod | Enable-PodeLogRequestType

    # State is shared by every request. Requests run on separate threads, so changes happen inside Lock-PodeObject.
    Set-PodeState -Name ApiKey -Value $apiKey | Out-Null
    Set-PodeState -Name DbPath -Value $dbPath | Out-Null
    Set-PodeState -Name Db -Value $db | Out-Null

    # --- The bouncer: every /api/ request needs the right key in the X-API-Key header ---
    Add-PodeMiddleware -Name 'ApiKey' -ScriptBlock {
        if ($WebEvent.Path -notlike '/api/*') { return $true }

        $key = Get-PodeHeader -Name 'X-API-Key'
        if (-not $key) {
            Write-PodeJsonResponse -StatusCode 401 -Value @{ error = 'Missing API key. Send it in the X-API-Key header.' }
            return $false
        }
        if ($key -cne (Get-PodeState -Name ApiKey)) {
            Write-PodeJsonResponse -StatusCode 403 -Value @{ error = 'Your API key is from the wrong dimension.' }
            return $false
        }
        return $true
    }

    # --- Dashboard (no API key: it only listens on localhost. Never do this with real student data.) ---
    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Write-PodeFileResponse -Path $using:dashboardPath -ContentType 'text/html'
    }

    Add-PodeRoute -Method Get -Path '/dashboard/data' -ScriptBlock {
        $data = Lock-PodeObject -Return -ScriptBlock {
            $db = Get-PodeState -Name Db
            @{ students = @($db.Students) } | ConvertTo-Json -Depth 5 -Compress
        }
        Write-PodeTextResponse -Value $data -ContentType 'application/json'
    }

    # The dashboard's "Reset demo data" button: back to the starter students, same as -Reset.
    # (No API key, like the dashboard itself. Fine for a fake SIS on localhost; never for a real one.)
    Add-PodeRoute -Method Post -Path '/dashboard/reset' -ScriptBlock {
        $seed = $using:seedPath
        $count = Lock-PodeObject -Return -ScriptBlock {
            $fresh = Get-Content -Path $seed -Raw | ConvertFrom-Json -AsHashtable
            $fresh.Students = [System.Collections.Generic.List[object]]@($fresh.Students)
            Set-PodeState -Name Db -Value $fresh | Out-Null
            $fresh | ConvertTo-Json -Depth 5 | Set-Content -Path (Get-PodeState -Name DbPath)
            $fresh.Students.Count
        }
        Write-PodeJsonResponse -Value @{ reset = $true; students = $count }
    }

    Add-PodeRoute -Method Get -Path '/health' -ScriptBlock {
        Write-PodeJsonResponse -Value @{ status = 'ok'; dimension = 'C-137' }
    }

    # --- About: a cheap way for clients to check their key works ---
    Add-PodeRoute -Method Get -Path '/api/v1/about' -ScriptBlock {
        $about = Lock-PodeObject -Return -ScriptBlock {
            $db = Get-PodeState -Name Db
            [ordered]@{
                System      = 'MultiverSIS'
                Version     = '1.0'
                Dimension   = 'C-137'
                Students    = $db.Students.Count
            }
        }
        Write-PodeJsonResponse -Value $about
    }

    # --- Students ---
    Add-PodeRoute -Method Get -Path '/api/v1/students' -ScriptBlock {
        $q = $WebEvent.Query
        $json = Lock-PodeObject -Return -ScriptBlock {
            $students = (Get-PodeState -Name Db).Students | Where-Object {
                (-not $q['name']     -or "$($_.FirstName) $($_.LastName)" -match [regex]::Escape($q['name'])) -and
                (-not $q['school']   -or $_.School -eq $q['school']) -and
                (-not $q['grade']    -or $_.Grade -eq $q['grade']) -and
                (-not $q['status']   -or $_.EnrollmentStatus -eq $q['status'])
            }
            ConvertTo-Json -InputObject @($students) -Depth 5 -Compress
        }
        Write-PodeTextResponse -Value $json -ContentType 'application/json'
    }

    Add-PodeRoute -Method Get -Path '/api/v1/students/:id' -ScriptBlock {
        $id = [int]$WebEvent.Parameters['id']
        $student = Lock-PodeObject -Return -ScriptBlock {
            (Get-PodeState -Name Db).Students | Where-Object { $_.StudentId -eq $id }
        }
        if (-not $student) {
            Write-PodeJsonResponse -StatusCode 404 -Value @{ error = "There is no student $id in this dimension." }
            return
        }
        Write-PodeJsonResponse -Value $student
    }

    Add-PodeRoute -Method Post -Path '/api/v1/students' -ScriptBlock {
        $in = $WebEvent.Data
        if (-not $in.FirstName) {
            Write-PodeJsonResponse -StatusCode 400 -Value @{ error = 'FirstName is required.' }
            return
        }

        $result = Lock-PodeObject -Return -ScriptBlock {
            $db = Get-PodeState -Name Db
            if ($in.SourceId -and ($db.Students | Where-Object { $_.SourceId -eq $in.SourceId })) {
                return @{ Code = 409; Body = @{ error = "A student with SourceId $($in.SourceId) already exists. No clones allowed." } }
            }

            $student = [ordered]@{
                StudentId        = $db.NextStudentId
                FirstName        = $in.FirstName
                LastName         = "$($in.LastName)"
                PreferredName    = $in.PreferredName
                Grade            = $in.Grade
                School           = $in.School ? $in.School : 'Unknown Dimension'
                Program          = $in.Program ? $in.Program : 'General Education'
                EnrollmentStatus = $in.EnrollmentStatus ? $in.EnrollmentStatus : 'Active'
                AttendanceDays   = [int]$in.AttendanceDays
                Species          = $in.Species
                Gender           = $in.Gender
                LastSeen         = $in.LastSeen
                Notes            = $in.Notes
                SourceId         = $in.SourceId
                Photo            = $in.Photo
                Created          = (Get-Date).ToString('o')
            }
            $db.NextStudentId++
            $db.Students.Add($student)
            $db | ConvertTo-Json -Depth 5 | Set-Content -Path (Get-PodeState -Name DbPath)
            @{ Code = 201; Body = $student }
        }
        Write-PodeJsonResponse -StatusCode $result.Code -Value $result.Body
    }

    Add-PodeRoute -Method Patch -Path '/api/v1/students/:id' -ScriptBlock {
        $id = [int]$WebEvent.Parameters['id']
        $in = $WebEvent.Data
        $result = Lock-PodeObject -Return -ScriptBlock {
            $db = Get-PodeState -Name Db
            $student = $db.Students | Where-Object { $_.StudentId -eq $id }
            if (-not $student) { return @{ Code = 404; Body = @{ error = "There is no student $id in this dimension." } } }

            foreach ($field in 'FirstName', 'LastName', 'PreferredName', 'Grade', 'School', 'Program', 'EnrollmentStatus', 'AttendanceDays', 'Notes') {
                if ($null -ne $in.$field) { $student[$field] = $in.$field }
            }
            $db | ConvertTo-Json -Depth 5 | Set-Content -Path (Get-PodeState -Name DbPath)
            @{ Code = 200; Body = $student }
        }
        Write-PodeJsonResponse -StatusCode $result.Code -Value $result.Body
    }

    Add-PodeRoute -Method Delete -Path '/api/v1/students/:id' -ScriptBlock {
        $id = [int]$WebEvent.Parameters['id']
        $result = Lock-PodeObject -Return -ScriptBlock {
            $db = Get-PodeState -Name Db
            $student = $db.Students | Where-Object { $_.StudentId -eq $id }
            if (-not $student) { return @{ Code = 404; Body = @{ error = "There is no student $id in this dimension." } } }
            [void]$db.Students.Remove($student)
            $db | ConvertTo-Json -Depth 5 | Set-Content -Path (Get-PodeState -Name DbPath)
            @{ Code = 200; Body = @{ deleted = $id; message = "Student $id has been sent to another dimension." } }
        }
        Write-PodeJsonResponse -StatusCode $result.Code -Value $result.Body
    }

    Add-PodeRoute -Method Get -Path '/api/v1/schools' -ScriptBlock {
        $json = Lock-PodeObject -Return -ScriptBlock {
            $schools = (Get-PodeState -Name Db).Students |
                Group-Object { $_.School } |
                Sort-Object Name |
                ForEach-Object { [ordered]@{ Name = $_.Name; Students = $_.Count } }
            ConvertTo-Json -InputObject @($schools) -Depth 3 -Compress
        }
        Write-PodeTextResponse -Value $json -ContentType 'application/json'
    }
}
