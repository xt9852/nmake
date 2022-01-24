::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   make.bat
:: Description: ����nmake.exe���빤��
:: Author:      �ź���
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-01-24
:: History:     2022-01-24 �������ļ���
::-----------------------------------------------------

:: ����ʾ�����ַ���
@echo off

:: ����ܹ�
set MSVC_ARCH_TYPE=x86

:: ���빤��·��
set MSVC_PATH_ROOT=D:\4.backup\coding\VS2022

:: ��������
set NAME=example

:: ��������:exe,dll,lib
set EXT=exe

:: �Ƿ����:y,n
set DEBUG=n

:: �ַ���:mbcs,unicode,utf8
set CHARSET=utf8

:: Դ�ļ�·��
set SRC=..\src

:: Ŀ���ļ�·��
set OUT=..\tmp

:: ��ʱ�ļ�·��
set TMP=..\tmp

:: ��Դ�����ļ�
set FILE_RC=..\res\example.rc

:: �������
set CFLAGS=/I".." /I"..\res"

:: ���Ӳ���
set LFLAGS=User32.lib Ws2_32.lib gdi32.lib


:MENU
mode con cols=50 lines=18
color 2F
cls
echo        �˵�ѡ��
echo    0.����ܹ�(%MSVC_ARCH_TYPE%)
echo    1.���빤��·��(%MSVC_PATH_ROOT%)
echo    2.��������(%NAME%)
echo    3.��������(%EXT%)
echo    4.�Ƿ����(%DEBUG%)
echo    5.�ַ���(%CHARSET%)
echo    6.Դ�ļ�·��(%SRC%)
echo    7.Ŀ���ļ�·��(%OUT%)
echo    8.��ʱ�ļ�·��(%TMP%)
echo    9.��Դ�����ļ�(%FILE_RC%)
echo    a.�������(%CFLAGS%)
echo    b.���Ӳ���(%LFLAGS%)
echo    c.�������
echo.
set /p i= �������ְ��س���
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
echo    ѡ����Ч,����������
ping -n 2 127.1>nul 
goto MENU

:MSVC_ARCH_TYPE
cls
echo        ����ܹ�(%MSVC_ARCH_TYPE%)
echo    1.x86
echo    2.x64
echo    3.�˳�
echo.
set /p i= �������ְ��س���
if "%i%"=="1" set MSVC_ARCH_TYPE=x86& Goto MSVC_ARCH_TYPE
if "%i%"=="2" set MSVC_ARCH_TYPE=x64& Goto MSVC_ARCH_TYPE
if "%i%"=="3" goto MENU
echo    ѡ����Ч,����������
ping -n 2 127.1>nul 
goto MSVC_ARCH_TYPE

:MSVC_PATH_ROOT
set /p MSVC_PATH_ROOT= ���빤��·��:
goto MENU

:NAME
set /p NAME= ��������:
goto MENU

:EXT
cls
echo        ��������(%EXT%)
echo    1.lib
echo    2.dll
echo    3.exe
echo    4.�˳�
echo.
set /p i= �������ְ��س���
if "%i%"=="1" set EXT=lib& Goto EXT
if "%i%"=="2" set EXT=dll& Goto EXT
if "%i%"=="3" set EXT=exe& Goto EXT
if "%i%"=="4" goto MENU
echo    ѡ����Ч,����������
ping -n 2 127.1>nul 
goto EXT

:DEBUG
cls
echo        �Ƿ����(%DEBUG%)
echo    1.��
echo    2.��
echo    3.�˳�
echo.
set /p i= �������ְ��س���
if "%i%"=="1" set DEBUG=y& Goto DEBUG
if "%i%"=="2" set DEBUG=n& Goto DEBUG
if "%i%"=="3" goto MENU
echo    ѡ����Ч,����������
ping -n 2 127.1>nul 
goto DEBUG

:CHARSET
cls
echo        �ַ���(%EXT%)
echo    1.utf8
echo    2.mbcs
echo    3.unicode
echo    4.�˳�
echo.
set /p i= �������ְ��س���
if "%i%"=="1" set CHARSET=utf8& Goto CHARSET
if "%i%"=="2" set CHARSET=mbcs& Goto CHARSET
if "%i%"=="3" set CHARSET=unicode& Goto CHARSET
if "%i%"=="4" goto MENU
echo    ѡ����Ч,����������
ping -n 2 127.1>nul 
goto CHARSET

:SRC
set /p SRC= Դ�ļ�·��:
goto MENU

:OUT
set /p OUT= Ŀ���ļ�·��:
goto MENU

:TMP
set /p TMP= ��ʱ�ļ�·��:
goto MENU

:FILE_RC
set /p FILE_RC= ��Դ�����ļ�:
goto MENU

:CFLAGS
set /p CFLAGS= �������:
goto MENU

:LFLAGS
set /p LFLAGS= ���Ӳ���:
goto MENU

:MAKE
pause
goto MENU
