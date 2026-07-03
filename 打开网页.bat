@echo off
chcp 65001 >nul
cd /d "%~dp0"

powershell -NoProfile -Command "try { $r=Invoke-WebRequest -Uri 'http://127.0.0.1:3000' -UseBasicParsing -TimeoutSec 3; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo.
    echo [X] 服务器没在运行，所以网页打不开
    echo.
    echo 请先双击「start-prod.bat」，等窗口里出现 Ready 或「编译完成」
    echo 并且【不要关闭】那个黑色窗口
    echo.
    pause
    exit /b 1
)

echo [OK] 正在打开 http://127.0.0.1:3000
start http://127.0.0.1:3000/
timeout /t 3 >nul
