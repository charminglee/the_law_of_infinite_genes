@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cls

set "CD=%~dp0"
if "%CD:~-1%"=="\" set "CD=%CD:~0,-1%"

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command Start-Process cmd -Verb RunAs -ArgumentList '/k cd /d "%CD%" ^&^& setup.bat'
    exit /b
)

set "SRC=%CD%\src"
for /d %%A in ("!SRC!\*") do (
    set "PROJECT_NAME=%%~nxA"
    set "PROJ=!SRC!\!PROJECT_NAME!"
    goto NEXT
)

:NEXT
set /p DST="请输入 UGCProjects 文件夹路径："
if "%DST%"=="" goto END
set DST=%DST:"=%
set "DST=%DST%\%PROJECT_NAME%"
if exist "%DST%" (
    echo 已存在同名项目："%DST%"
    goto END
)

echo 正在创建链接...
mklink /D "%DST%" "%PROJ%"

if %errorlevel% equ 0 (
    echo 成功！
) else (
    echo 创建链接时出错！
)

:END
echo.
pause