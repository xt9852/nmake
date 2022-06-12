::-----------------------------------------------------
:: Copyright:   XT Tech. Co., Ltd.
:: File:        run.bat
:: Author:      �ź���
:: Version:     1.0.0
:: Encode:      ANSI
:: Date:        2022-01-17
:: Description: ���г���
::-----------------------------------------------------

:: ����ʾ�����ַ���
::@echo off

:: ��������
set NAME=example

:: ��������:exe,dll,lib
set EXT=exe

:: ��ʱ�ļ�·��
set TMP=tmp

:: Ŀ���ļ�·��
set OUT=

::-----------------------------------------------------
:: ��ȡ�����ļ�

set DIR=%1

if "%DIR%" == "" (
    echo "don't set make.ini path"
    pause
    exit
)

::��\�滻�ɿո�
set DIR=%DIR:\= %

set INI=

SET ROOT=

set DELIMS=

setLocal EnableDelayedExpansion

::����make.ini�ļ�
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
:: Ŀ������:exe,dll,lib
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
