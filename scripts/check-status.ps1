$ErrorActionPreference = "Continue"

Write-Host "== Hermes + DeepSeek v4 + Telegram - Status ==" -ForegroundColor Cyan

Write-Host ""
Write-Host "-- Commands --" -ForegroundColor Yellow
Get-Command hermes -ErrorAction SilentlyContinue |
  Select-Object Name, Source | Format-Table -AutoSize

Write-Host "-- Processes --" -ForegroundColor Yellow
Get-Process | Where-Object { $_.ProcessName -match 'hermes|python' } |
  Select-Object ProcessName, Id, Path | Format-Table -AutoSize

Write-Host "-- Hermes Status --" -ForegroundColor Yellow
hermes status 2>&1

Write-Host ""
Write-Host "-- Gateway Status --" -ForegroundColor Yellow
hermes gateway status 2>&1

Write-Host ""
Write-Host "-- Model --" -ForegroundColor Yellow
$configPath = "C:\Users\Unknown\AppData\Local\hermes\config.yaml"
if (Test-Path $configPath) {
    $cfg = Get-Content $configPath -Raw
    if ($cfg -match 'default:\s*(\S+)') { Write-Host ("Model: " + $Matches[1]) -ForegroundColor Green }
    if ($cfg -match 'provider:\s*(\S+)') { Write-Host ("Provider: " + $Matches[1]) -ForegroundColor Green }
}

Write-Host ""
Write-Host "-- Telegram Token (Hermes .env) --" -ForegroundColor Yellow
$envPath = "C:\Users\Unknown\AppData\Local\hermes\.env"
if (Test-Path $envPath) {
    $hasTg = Select-String -Path $envPath -Pattern "^\s*TELEGRAM_BOT_TOKEN\s*=" -Quiet
    if ($hasTg) {
        Write-Host "TELEGRAM_BOT_TOKEN: configured" -ForegroundColor Green
    } else {
        Write-Host "TELEGRAM_BOT_TOKEN: NOT SET" -ForegroundColor Red
    }
    $hasDsk = Select-String -Path $envPath -Pattern "^\s*DEEPSEEK_API_KEY\s*=" -Quiet
    if ($hasDsk) {
        Write-Host "DEEPSEEK_API_KEY: configured" -ForegroundColor Green
    } else {
        Write-Host "DEEPSEEK_API_KEY: NOT SET" -ForegroundColor Red
    }
} else {
    Write-Host ("Hermes .env not found at: " + $envPath) -ForegroundColor Red
}
