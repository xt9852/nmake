::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   run.bat
:: Description: ����nmake.bat���빤��
:: Author:      �ź���
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-02-06
:: History:     2022-02-06 �������ļ���
::-----------------------------------------------------

:: ����ʾ�����ַ���
@echo off

:: ��������:exe,dll,lib
set EXT=exe

:: Ŀ���ļ�·��
set OUT=.\

:: ��ʱ�ļ�·��
set TMP=.\tmp

::-----------------------------------------------------
:: ��ȡ�����ļ�

set INI=%1\make.ini

if exist "%INI%" (
    for /f "tokens=1,2 delims==" %%a in (%INI%) do (
        set %%a=%%b
    )
)

::-----------------------------------------------------
:: Ŀ������:exe,dll,lib
if "%EXT%" neq "exe" (
    echo "dll,lib is not exe"
    pause
    exit
)

cd %1

start %OUT%\%NAME%.exe
