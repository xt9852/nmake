::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   make-start.bat
:: Description: 调用nmake.bat编译工程
:: Author:      张海涛
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-02-06
:: History:     2022-02-06 创建此文件。
::-----------------------------------------------------

:: 不显示命令字符串
@echo off

set PAT=%~d1%~p1

set MAKE=%PAT%make.bat

if exist "%MAKE%" (
    call %MAKE%
    exit
)

set MAKE=%PAT%nmake\make.bat

if exist "%MAKE%" (
    call %MAKE%
    exit
)

set MAKE=%PAT%..\nmake\make.bat

if exist "%MAKE%" (
    call %MAKE%
    exit
)

echo Don't find make.bat
pause
exit
