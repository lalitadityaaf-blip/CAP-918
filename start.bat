@echo off
title PG Manager Launcher
setlocal enabledelayedexpansion

echo ===================================================
echo             Starting PG Manager App
echo ===================================================
echo.

rem Locate project directory
set "BASE_DIR=%~dp0"
if exist "%BASE_DIR%package.json" (
    set "APP_DIR=%BASE_DIR%"
    set "SCRIPTS_DIR=%BASE_DIR%scripts"
) else if exist "%BASE_DIR%pg-manager\package.json" (
    set "APP_DIR=%BASE_DIR%pg-manager"
    set "SCRIPTS_DIR=%BASE_DIR%scripts"
) else if exist "%BASE_DIR%..\pg-manager\package.json" (
    set "APP_DIR=%BASE_DIR%..\pg-manager"
    set "SCRIPTS_DIR=%BASE_DIR%..\scripts"
) else if exist "%BASE_DIR%..\package.json" (
    set "APP_DIR=%BASE_DIR%..\"
    set "SCRIPTS_DIR=%BASE_DIR%..\scripts"
) else (
    echo [ERROR] Could not find package.json!
    pause
    exit /b 1
)

rem Check Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH!
    echo Please install Node.js from https://nodejs.org
    pause
    exit /b 1
)

cd /d "%APP_DIR%"

rem Check dependencies
if not exist "node_modules\" (
    echo [INFO] Dependencies not found. Installing node packages...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install npm dependencies.
        pause
        exit /b 1
    )
)

rem Check Docker Desktop for optional backend
where docker >nul 2>nul
if %errorlevel% equ 0 (
    docker info >nul 2>nul
    if %errorlevel% equ 0 (
        echo [INFO] Docker detected and running. Starting Supabase backend...
        if exist "%SCRIPTS_DIR%\start-backend.ps1" (
            powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPTS_DIR%\start-backend.ps1"
        )
    ) else (
        echo [INFO] Docker Desktop is installed but not running.
        echo [INFO] Starting in standalone DEMO mode with local offline data...
    )
) else (
    echo [INFO] Docker not found. Starting in standalone DEMO mode with local offline data...
)

echo.
echo [INFO] Launching PG Manager dev server at http://localhost:4200 ...
echo [INFO] Your default browser will open automatically.
echo [INFO] Press Ctrl+C in this window anytime to stop the server.
echo.

call npx ng serve --host localhost --port 4200 --open

if %errorlevel% neq 0 (
    echo [ERROR] Server stopped with an error.
    pause
)
