$hermesExe = (Get-Command hermes -ErrorAction Stop).Source
$workDir   = "C:\Users\Unknown\AppData\Local\hermes"
$logFile   = "C:\Users\Unknown\Documents\Projects\Hermes + DeepSeek v4 + Telegram\logs\gateway-restart.log"

$null = New-Item -ItemType Directory -Force (Split-Path $logFile) -ErrorAction SilentlyContinue

Set-Location $workDir

# При старте — выполнить все пропущенные cron задачи (если компьютер был выключен в плановое время)
$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content $logFile "$ts  [STARTUP] Running missed cron jobs..."
& $hermesExe cron tick 2>&1 | ForEach-Object { Add-Content $logFile "$ts  [CRON] $_" }
Add-Content $logFile "$ts  [STARTUP] Cron tick done. Starting gateway loop."

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
