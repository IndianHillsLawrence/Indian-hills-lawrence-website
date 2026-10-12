Website for Indian Hills Neighborhood Association Lawrence, Kansas

## Adding meeting documents

Agendas and minutes are published as PDFs so they look the same on every phone and computer.

| Document | Folder | File name |
|----------|--------|-----------|
| Agenda   | `docs/agenda/`  | `ihna-agenda-YYYY-MM-DD.pdf`  |
| Minutes  | `docs/minutes/` | `ihna-minutes-YYYY-MM-DD.pdf` |

Rules:

- The date is the meeting date, for example `ihna-minutes-2026-10-06.pdf`.
- Lowercase letters, hyphens only, no spaces.
- PDF only (export from Word or Google Docs; do not just rename the file), under 10 MB.
- Then link to the file from the meetings section of `index.html`.

A check named **Validate documents** runs on every pull request and blocks the merge if a file breaks these rules. The error message says what to fix. To run it yourself before pushing, from the repository folder in PowerShell: `powershell -ExecutionPolicy Bypass -File .\scripts\validate-docs.ps1`
