@echo off
chcp 65001 >nul
cd /d "%~dp0"

set /a N=0
:LOOP
set /a N+=1
if %N% GTR 60 goto FAIL

powershell -NoProfile -Command "try { $r=Invoke-WebRequest -Uri 'http://127.0.0.1:3000' -UseBasicParsing -TimeoutSec 2; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    timeout /t 1 /nobreak >nul
    goto LOOP
)

start http://127.0.0.1:3000/
exit /b 0

:FAIL
msg * "浏览器未自动打开。请手动在地址栏输入: http://127.0.0.1:3000"
exit /b 1
