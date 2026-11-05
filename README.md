Website for Indian Hills Neighborhood Association Lawrence, Kansas

## Events calendar

The homepage `#calendar` section embeds the association's public Google Calendar. To add or change events, edit the calendar in Google Calendar; the website updates automatically. The calendar must stay shared as "Make available to public". To point the site at a different calendar, replace the `src=` calendar ID (URL-encoded, `@` as `%40`) in the `#calendar` section of `index.html`.

## Adding meeting documents

Meeting documents, survey summaries, and the proposed bylaws are published as PDFs so they look the same on every phone and computer.

| Document | Folder | File name |
|----------|--------|-----------|
| Agenda   | `docs/agenda/`  | `ihna-agenda-YYYY-MM-DD.pdf`  |
| Minutes  | `docs/minutes/` | `ihna-minutes-YYYY-MM-DD.pdf` |
| Proposed bylaws draft | `docs/bylaws/` | `ihna-proposed-bylaws-draft.pdf` |
| Survey summary | `docs/surveys/` | `ihna-survey-summary-YYYY-MM-DD.pdf` |

Rules:

- The date is the meeting date, for example `ihna-minutes-2026-10-06.pdf`.
- Lowercase letters, hyphens only, no spaces.
- PDF only (export from Word or Google Docs; do not just rename the file), under 10 MB.
- The proposed bylaws draft uses the fixed name `ihna-proposed-bylaws-draft.pdf`.
- Then link to the file from the relevant section of `index.html`.

A check named **Validate documents** runs on every pull request and blocks the merge if a file breaks these rules. The error message says what to fix. To run it yourself before pushing, from the repository folder in PowerShell: `powershell -ExecutionPolicy Bypass -File .\scripts\validate-docs.ps1`
