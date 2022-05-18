::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   run.bat
:: Description: 调用nmake.bat编译工程
:: Author:      张海涛
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-02-06
:: History:     2022-02-06 创建此文件。
::-----------------------------------------------------

:: 不显示命令字符串
@echo off

:: 程序类型:exe,dll,lib
set EXT=exe

:: 目标文件路径
set OUT=.\

:: 临时文件路径
set TMP=.\tmp

::-----------------------------------------------------
:: 读取配置文件

set INI=%1\make.ini

if exist "%INI%" (
    for /f "tokens=1,2 delims==" %%a in (%INI%) do (
        set %%a=%%b
    )
)

::-----------------------------------------------------
:: 目标类型:exe,dll,lib
if "%EXT%" neq "exe" (
    echo "dll,lib is not exe"
    pause
    exit
)

cd %1

start %OUT%\%NAME%.exe
