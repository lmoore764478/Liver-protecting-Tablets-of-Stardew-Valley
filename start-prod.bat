@echo off
chcp 65001 >nul
cd /d "%~dp0"
title 星露谷助手 - 请勿关闭

set "LOG=%~dp0logs\start.log"
if not exist "%~dp0logs" mkdir "%~dp0logs"
echo ===== %date% %time% ===== > "%LOG%"

echo.
echo  ========================================
echo    星露谷助手
echo  ========================================
echo.
echo  网页地址: http://127.0.0.1:3000
echo  【本黑色窗口必须保持打开】
echo.

where node >nul 2>&1
if errorlevel 1 (
    echo [X] 未安装 Node.js  https://nodejs.org
    pause
    exit /b 1
)

echo [1/3] 清理端口...
for /f "tokens=5" %%p in ('netstat -ano 2^>nul ^| findstr ":3000" ^| findstr "LISTENING"') do taskkill /F /PID %%p >nul 2>&1
timeout /t 1 /nobreak >nul

echo [2/3] 编译网页（约30秒）...
call npm run build >> "%LOG%" 2>&1
if errorlevel 1 (
    echo [X] 编译失败，日志: logs\start.log
    powershell -NoProfile -Command "Get-Content '%LOG%' -Tail 12"
    pause
    exit /b 1
)
echo       完成

echo [3/3] 启动中，浏览器稍后自动打开...
start "" /min "%~dp0_wait-and-open.bat"

call npx --yes serve@14 out -l 3000 --no-clipboard

echo.
echo 已停止。再用请重新双击本文件，或双击「双击启动.vbs」
pause
