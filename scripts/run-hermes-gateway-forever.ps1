$hermesExe = (Get-Command hermes -ErrorAction Stop).Source
$workDir   = "C:\Users\Unknown\AppData\Local\hermes"
$logFile   = "C:\Users\Unknown\Documents\Projects\Hermes + DeepSeek v4 + Telegram\logs\gateway-restart.log"

$null = New-Item -ItemType Directory -Force (Split-Path $logFile) -ErrorAction SilentlyContinue

Set-Location $workDir

while ($true) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $status = & $hermesExe gateway status 2>&1
    if ($status -match "process running") {
        Start-Sleep -Seconds 30
        continue
    }

    Add-Content $logFile "$ts  [START] Launching hermes gateway"

    & $hermesExe gateway run 2>&1
    $exitCode = $LASTEXITCODE

    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $logFile "$ts  [EXIT]  Gateway exited (code $exitCode). Restarting in 10s..."
    Start-Sleep -Seconds 10
}
