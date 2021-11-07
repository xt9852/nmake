::-----------------------------------------------------
:: ����nmake.exeʹ��makefile.nmakeΪ���ñ��빤��
::-----------------------------------------------------
:: MSVC_ARCH_TYPE �ܹ�x64/x64
:: MSVC_PATH_ROOT ���빤��·��,����Kit,MSVC��Ŀ¼,�ļ�ֱ�Ӵ�VS2019�и���
::-----------------------------------------------------

@set MSVC_ARCH_TYPE=x86
@set MSVC_PATH_ROOT=D:\4.backup\coding\MSVC-2019

@set SRC=..
@set TMP=.\tmp

::-----------------------------------------------------
:: MSVCĿ¼�ṹ

:: nmake.exe
@set PATH_MSVC_BIN=%MSVC_PATH_ROOT%\MSVC\14.29.30037\bin\Hostx64\%MSVC_ARCH_TYPE%

:: vcruntime.h
@set PATH_MSVC_INCLUDE=%MSVC_PATH_ROOT%\MSVC\14.29.30037\include

:: LIBCMT.lib
@set PATH_MSVC_LIB=%MSVC_PATH_ROOT%\MSVC\14.29.30037\lib\%MSVC_ARCH_TYPE%

::-----------------------------------------------------
:: KITĿ¼�ṹ

:: rc.exe
@set PATH_KIT_BIN=%MSVC_PATH_ROOT%\Kit\bin\10.0.19041.0\%MSVC_ARCH_TYPE%

:: Winsock2.h->winapifamily.h
@set PATH_KIT_INCLUDE_UM=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\um

:: stdio.h->corecrt.h->vcruntime.h
@set PATH_KIT_INCLUDE_UCRT=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\ucrt

:: winapifamily.h
@set PATH_KIT_INCLUDE_SHARED=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\shared

:: uuid.lib
@set PATH_KIT_LIB_UM=%MSVC_PATH_ROOT%\Kit\Lib\10.0.19041.0\um\%MSVC_ARCH_TYPE%

:: libucrt.lib
@set PATH_KIT_LIB_UCRT=%MSVC_PATH_ROOT%\Kit\Lib\10.0.19041.0\ucrt\%MSVC_ARCH_TYPE%


::-----------------------------------------------------
:: ����PATH,Ϊnmake

@set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KIT_BIN%

::-----------------------------------------------------
:: ɾ����ʱ�ļ�

@cd %SRC%
@del /Q %TMP%\*

::-----------------------------------------------------
:: �õ�Դ�ļ�

:: �ӳٱ���
@setlocal enabledelayedexpansion
@for /f %%I in ('dir /s/b *.c *.cpp') do @(set "FILES_SRC=!FILES_SRC! %%I"&set "FILES_OBJ=!FILES_OBJ! %TMP_DIR%\%%~nI.obj")

::-----------------------------------------------------
:: �������

@nmake /nologo /f .\makefile.nmake\makefile.nmake
pause
