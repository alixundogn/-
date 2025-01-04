@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo ====== 每日追踪器 ======
echo.

:: 检查 Python
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 请安装 Python
    pause
    exit /b 1
)

:: 检查 Node.js
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 请安装 Node.js
    pause
    exit /b 1
)

:: 如果没有虚拟环境，创建一个
if not exist "venv" (
    echo 创建虚拟环境...
    python -m venv venv
)

:: 激活虚拟环境并安装后端依赖
echo 安装后端依赖...
call venv\Scripts\activate
python -m pip install --upgrade pip
pip install flask flask-cors requests werkzeug

:: 安装前端依赖
cd frontend
if not exist "node_modules" (
    echo 安装前端依赖...
    call npm install react-router-dom @ant-design/icons dayjs antd
)

:: 结束已有进程
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im python.exe >nul 2>&1
timeout /t 2 > nul

:: 启动后端
echo 启动后端...
cd ..
start "Backend" cmd /k "call venv\Scripts\activate && cd backend && python app.py"

:: 等待后端启动
timeout /t 3 > nul

:: 启动前端
echo 启动前端...
cd frontend
start "Frontend" cmd /k "set PORT=3001 && npm start"

echo.
echo 正在启动服务...
echo 后端: http://localhost:5000
echo 前端: http://localhost:3001
echo.
echo 请等待浏览器自动打开...
echo 如果浏览器没有自动打开，请手动访问 http://localhost:3001
echo.
echo 按任意键退出...
pause > nul 