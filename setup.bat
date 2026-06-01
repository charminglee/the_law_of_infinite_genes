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

echo 正在创建项目链接...
mklink /D "%DST%" "%PROJ%"

if %errorlevel% equ 0 (
    echo 成功！
) else (
    echo 创建项目链接时出错！
)

:: ========== 新增：在当前目录创建指向 Content\LuaHelper 的软链接 ==========
:: 计算目标路径：%DST%\..\Content\LuaHelper
for %%I in ("%DST%") do set "PARENT=%%~dpI"
set "PARENT=%PARENT:~0,-1%"
set "TARGET=%PARENT%\..\Content\LuaHelper"

:: 设定链接名称（可根据需要修改，这里固定为 LuaHelper）
set "LINK_NAME=LuaHelper"
set "LINK_PATH=%CD%\%LINK_NAME%"

:: 检查链接是否已存在
if exist "%LINK_PATH%" (
    echo 当前目录下已存在 %LINK_NAME%，跳过创建。
) else (
    echo 正在创建软链接...
    mklink /D "%LINK_PATH%" "%TARGET%"
    if %errorlevel% equ 0 (
        echo 软链接创建成功！
    ) else (
        echo 软链接创建失败，请检查目标路径是否有效。
    )
)
:: ==================================================
:END
echo.
pause