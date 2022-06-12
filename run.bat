::-----------------------------------------------------
:: Copyright:   XT Tech. Co., Ltd.
:: File:        run.bat
:: Author:      张海涛
:: Version:     1.0.0
:: Encode:      ANSI
:: Date:        2022-01-17
:: Description: 运行程序
::-----------------------------------------------------

:: 不显示命令字符串
::@echo off

:: 程序名称
set NAME=example

:: 程序类型:exe,dll,lib
set EXT=exe

:: 临时文件路径
set TMP=tmp

:: 目标文件路径
set OUT=

::-----------------------------------------------------
:: 读取配置文件

set DIR=%1

if "%DIR%" == "" (
    echo "don't set make.ini path"
    pause
    exit
)

::将\替换成空格
set DIR=%DIR:\= %

set INI=

SET ROOT=

set DELIMS=

setLocal EnableDelayedExpansion

::查找make.ini文件
for %%i in (%DIR%) do (
    set "INI=!INI!!DELIMS!%%i"
    set "DELIMS=\"
    if exist "!INI!\make.ini" (
        set "ROOT=!INI!"
        set "INI=!INI!\make.ini"
        goto break
    )
)

set NOT=1

:break

if "%NOT%" == "1" (
    echo "don't have %INI%"
    exit
)

for /f "tokens=1,2 delims==" %%a in (%INI%) do (
    set %%a=%%b
)

::-----------------------------------------------------
:: 目标类型:exe,dll,lib
if "%EXT%" neq "exe" (
    echo "dll,lib is not exe"
    pause
    exit
)

if exist "%ROOT%\%OUT%" (
    cd %ROOT%\%OUT%
) else (
    cd %OUT%
)

start %NAME%.exe
