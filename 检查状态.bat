@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ===== 星露谷助手 · 诊断 =====
echo.

where node >nul 2>&1
if errorlevel 1 (
    echo [X] 未安装 Node.js — 请先安装 https://nodejs.org
) else (
    echo [OK] Node.js:
    node -v
)

if exist "node_modules\next\dist\bin\next" (
    echo [OK] 依赖已安装
) else (
    echo [X] 缺少依赖 — 在项目文件夹打开终端运行: npm install
)

if exist ".next\BUILD_ID" (
    echo [OK] 已编译
) else (
    echo [!] 未编译 — 需运行 start-prod.bat
)

netstat -ano | findstr ":3000" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo [X] 3000 端口无服务 ^(这就是打不开的原因^)
    echo.
    echo 解决: 双击「start-prod.bat」，保持窗口开着
) else (
    echo [OK] 3000 端口有服务
    powershell -NoProfile -Command "try { $r=Invoke-WebRequest -Uri 'http://127.0.0.1:3000' -UseBasicParsing -TimeoutSec 3; Write-Host '[OK] 网页可访问 HTTP' $r.StatusCode } catch { Write-Host '[X] 端口开着但网页报错:' $_.Exception.Message }"
    echo.
    echo 正在打开浏览器...
    start http://127.0.0.1:3000/
)

echo.
if exist "logs\start.log" (
    echo 最近日志 logs\start.log 最后 5 行:
    powershell -NoProfile -Command "Get-Content -Path 'logs\start.log' -Tail 5 -ErrorAction SilentlyContinue"
)
echo.
pause
