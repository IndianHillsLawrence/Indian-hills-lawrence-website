# Checks that every file under docs/ follows the Indian Hills file standard.
# Run locally from the repository root:  pwsh scripts/validate-docs.ps1
#                                        (or powershell -File scripts\validate-docs.ps1 on Windows)
$ErrorActionPreference = 'Stop'

$docs = 'docs'
$folders = @('agenda', 'minutes', 'bylaws', 'surveys', 'survey-cards', 'policies')
$maxBytes = 10MB
$problems = New-Object System.Collections.Generic.List[string]

$root = (Resolve-Path $docs).Path
$files = Get-ChildItem -Path $docs -Recurse -File | Where-Object { $_.Name -ne '.gitkeep' } | Sort-Object FullName

foreach ($file in $files) {
    $rel = $file.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
    $label = "docs/$rel"
    $parts = $rel.Split('/')

    if ($parts.Count -ne 2 -or $folders -cnotcontains $parts[0]) {
        $problems.Add("${label}: must be directly inside docs/agenda/, docs/minutes/, docs/bylaws/, docs/surveys/, or docs/policies/")
        continue
    }

    $folder = $parts[0]
    if ($folder -eq 'bylaws') {
        if ($parts[1] -cne 'ihna-proposed-bylaws-draft.pdf') {
            $problems.Add("${label}: bad file name. Use ihna-proposed-bylaws-draft.pdf")
            continue
        }
    } elseif ($folder -eq 'policies') {
        if ($parts[1] -cne 'ihna-email-listserv-policy-2026-11-03.pdf') {
            $problems.Add("${label}: bad file name. Use ihna-email-listserv-policy-YYYY-MM-DD.pdf")
            continue
        }
    } elseif ($folder -eq 'survey-cards') {
        $match = [regex]::Match($parts[1], '^ihna-survey-card-(front|back)-(\d{4})-(\d{2})-(\d{2})\.pdf$')
        if (-not $match.Success) {
            $problems.Add("${label}: bad file name. Use ihna-survey-card-front-YYYY-MM-DD.pdf or ihna-survey-card-back-YYYY-MM-DD.pdf")
            continue
        }

        try {
            [void][datetime]::new([int]$match.Groups[2].Value, [int]$match.Groups[3].Value, [int]$match.Groups[4].Value)
        } catch {
            $problems.Add("${label}: the date in the file name is not a real date")
        }
    } else {
        $match = [regex]::Match($parts[1], '^ihna-(agenda|minutes|survey-summary)-(\d{4})-(\d{2})-(\d{2})\.pdf$')
        if (-not $match.Success) {
            $documentType = if ($folder -eq 'surveys') { 'survey-summary' } else { $folder }
            $problems.Add("${label}: bad file name. Use ihna-$documentType-YYYY-MM-DD.pdf (lowercase, hyphens, no spaces, PDF only)")
            continue
        }

        $expectedFolder = if ($match.Groups[1].Value -eq 'survey-summary') { 'surveys' } else { $match.Groups[1].Value }
        if ($expectedFolder -ne $folder) {
            $problems.Add("${label}: a '$($match.Groups[1].Value)' file belongs in docs/$expectedFolder/")
        }

        try {
            [void][datetime]::new([int]$match.Groups[2].Value, [int]$match.Groups[3].Value, [int]$match.Groups[4].Value)
        } catch {
            $problems.Add("${label}: the date in the file name is not a real date")
        }
    }

    if ($file.Length -gt $maxBytes) {
        $problems.Add("${label}: larger than 10 MB, please compress the PDF")
    }

    $head = [System.IO.File]::ReadAllBytes($file.FullName) | Select-Object -First 5
    if ([System.Text.Encoding]::ASCII.GetString([byte[]]$head) -ne '%PDF-') {
        $problems.Add("${label}: not a real PDF (export it as a PDF instead of renaming)")
    }
}

if ($problems.Count -gt 0) {
    foreach ($p in $problems) { Write-Host "ERROR $p" }
    Write-Host "`n$($problems.Count) problem(s) found. See 'Adding meeting documents' in README.md."
    exit 1
}

Write-Host "OK: $($files.Count) file(s) in docs/ follow the standard."
