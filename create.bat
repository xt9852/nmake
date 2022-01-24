::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   make.bat
:: Description: 调用nmake.exe编译工程
:: Author:      张海涛
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-01-24
:: History:     2022-01-24 创建此文件。
::-----------------------------------------------------

:: 不显示命令字符串
@echo off

:: 程序架构
set MSVC_ARCH_TYPE=x86

:: 编译工具路径
set MSVC_PATH_ROOT=D:\4.backup\coding\VS2022

:: 程序名称
set NAME=example

:: 程序类型:exe,dll,lib
set EXT=exe

:: 是否调试:y,n
set DEBUG=n

:: 字符集:mbcs,unicode,utf8
set CHARSET=utf8

:: 源文件路径
set SRC=..\src

:: 目标文件路径
set OUT=..\tmp

:: 临时文件路径
set TMP=..\tmp

:: 资源描述文件
set FILE_RC=..\res\example.rc

:: 编译参数
set CFLAGS=/I".." /I"..\res"

:: 链接参数
set LFLAGS=User32.lib Ws2_32.lib gdi32.lib


:MENU
mode con cols=50 lines=18
color 2F
cls
echo        菜单选项
echo    0.程序架构(%MSVC_ARCH_TYPE%)
echo    1.编译工具路径(%MSVC_PATH_ROOT%)
echo    2.程序名称(%NAME%)
echo    3.程序类型(%EXT%)
echo    4.是否调试(%DEBUG%)
echo    5.字符集(%CHARSET%)
echo    6.源文件路径(%SRC%)
echo    7.目标文件路径(%OUT%)
echo    8.临时文件路径(%TMP%)
echo    9.资源描述文件(%FILE_RC%)
echo    a.编译参数(%CFLAGS%)
echo    b.链接参数(%LFLAGS%)
echo    c.编译程序
echo.
set /p i= 输入数字按回车：
if "%i%"=="0" goto MSVC_ARCH_TYPE
if "%i%"=="1" goto MSVC_PATH_ROOT
if "%i%"=="2" goto NAME
if "%i%"=="3" goto EXT
if "%i%"=="4" goto DEBUG
if "%i%"=="5" goto CHARSET
if "%i%"=="6" goto SRC
if "%i%"=="7" goto OUT
if "%i%"=="8" goto TMP
if "%i%"=="9" goto FILE_RC
if "%i%"=="a" goto CFLAGS
if "%i%"=="b" goto LFLAGS
if "%i%"=="c" goto MAKE
echo    选择无效,请重新输入
ping -n 2 127.1>nul 
goto MENU

:MSVC_ARCH_TYPE
cls
echo        程序架构(%MSVC_ARCH_TYPE%)
echo    1.x86
echo    2.x64
echo    3.退出
echo.
set /p i= 输入数字按回车：
if "%i%"=="1" set MSVC_ARCH_TYPE=x86& Goto MSVC_ARCH_TYPE
if "%i%"=="2" set MSVC_ARCH_TYPE=x64& Goto MSVC_ARCH_TYPE
if "%i%"=="3" goto MENU
echo    选择无效,请重新输入
ping -n 2 127.1>nul 
goto MSVC_ARCH_TYPE

:MSVC_PATH_ROOT
set /p MSVC_PATH_ROOT= 编译工具路径:
goto MENU

:NAME
set /p NAME= 程序名称:
goto MENU

:EXT
cls
echo        程序类型(%EXT%)
echo    1.lib
echo    2.dll
echo    3.exe
echo    4.退出
echo.
set /p i= 输入数字按回车：
if "%i%"=="1" set EXT=lib& Goto EXT
if "%i%"=="2" set EXT=dll& Goto EXT
if "%i%"=="3" set EXT=exe& Goto EXT
if "%i%"=="4" goto MENU
echo    选择无效,请重新输入
ping -n 2 127.1>nul 
goto EXT

:DEBUG
cls
echo        是否调试(%DEBUG%)
echo    1.是
echo    2.否
echo    3.退出
echo.
set /p i= 输入数字按回车：
if "%i%"=="1" set DEBUG=y& Goto DEBUG
if "%i%"=="2" set DEBUG=n& Goto DEBUG
if "%i%"=="3" goto MENU
echo    选择无效,请重新输入
ping -n 2 127.1>nul 
goto DEBUG

:CHARSET
cls
echo        字符集(%EXT%)
echo    1.utf8
echo    2.mbcs
echo    3.unicode
echo    4.退出
echo.
set /p i= 输入数字按回车：
if "%i%"=="1" set CHARSET=utf8& Goto CHARSET
if "%i%"=="2" set CHARSET=mbcs& Goto CHARSET
if "%i%"=="3" set CHARSET=unicode& Goto CHARSET
if "%i%"=="4" goto MENU
echo    选择无效,请重新输入
ping -n 2 127.1>nul 
goto CHARSET

:SRC
set /p SRC= 源文件路径:
goto MENU

:OUT
set /p OUT= 目标文件路径:
goto MENU

:TMP
set /p TMP= 临时文件路径:
goto MENU

:FILE_RC
set /p FILE_RC= 资源描述文件:
goto MENU

:CFLAGS
set /p CFLAGS= 编译参数:
goto MENU

:LFLAGS
set /p LFLAGS= 链接参数:
goto MENU

:MAKE
pause
goto MENU
