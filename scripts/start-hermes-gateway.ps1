$ErrorActionPreference = "Stop"

$hermesExe = (Get-Command hermes -ErrorAction Stop).Source
Write-Host "Starting Hermes gateway..." -ForegroundColor Cyan

& $hermesExe gateway run

