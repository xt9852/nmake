::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   make-start.bat
:: Description: ����nmake.bat���빤��
:: Author:      �ź���
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-02-06
:: History:     2022-02-06 �������ļ���
::-----------------------------------------------------

:: ����ʾ�����ַ���
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
