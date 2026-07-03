@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ========================================
echo   星露谷助手 · 开发模式
echo ========================================
echo.

if exist .next (
  echo 清理旧缓存...
  rmdir /s /q .next 2>nul
)

where node >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Node.js，请先安装: https://nodejs.org
    pause
    exit /b 1
)

start "星露谷助手-服务器" cmd /k "cd /d %~dp0 && npm run dev -- -H 127.0.0.1 -p 3000"

echo 等待服务器启动（约 15 秒）...
timeout /t 15 /nobreak >nul

start http://127.0.0.1:3000

echo.
echo 首页:     http://127.0.0.1:3000
echo 动线规划: http://127.0.0.1:3000/planner
echo.
echo 【重要】不要关闭「星露谷助手-服务器」窗口！
echo 若仍打不开，请双击 start-prod.bat 用稳定模式
echo.
pause
