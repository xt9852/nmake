::-----------------------------------
:: ����nmake.exe�������
:: 
:: �ַ�����:ANSI
:: MSVC_ARCH_TYPE �ܹ�λ��:x64/x64
:: MSVC_PATH_ROOT VC��������Ŀ¼
::-----------------------------------

set MSVC_ARCH_TYPE=x86
set MSVC_PATH_ROOT=D:\4.backup\coding\MSVC-2019

::-----------------------------------
:: VCĿ¼�ṹ
::-----------------------------------

set PATH_MSVC_BIN=%MSVC_PATH_ROOT%\MSVC\14.29.30037\bin\Hostx64\%MSVC_ARCH_TYPE%

:: vcruntime.h
set PATH_MSVC_INCLUDE=%MSVC_PATH_ROOT%\MSVC\14.29.30037\include

:: LIBCMT.lib
set PATH_MSVC_LIB=%MSVC_PATH_ROOT%\MSVC\14.29.30037\lib\%MSVC_ARCH_TYPE%

::-----------------------------------
:: KITĿ¼�ṹ
::-----------------------------------

set PATH_KIT_BIN=%MSVC_PATH_ROOT%\Kit\bin\10.0.19041.0\%MSVC_ARCH_TYPE%

:: Winsock2.h->winapifamily.h
set PATH_KIT_INCLUDE_UM=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\um

:: stdio.h->corecrt.h->vcruntime.h
set PATH_KIT_INCLUDE_UCRT=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\ucrt

:: winapifamily.h
set PATH_KIT_INCLUDE_SHARED=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\shared

:: uuid.lib
set PATH_KIT_LIB_UM=%MSVC_PATH_ROOT%\Kit\Lib\10.0.19041.0\um\%MSVC_ARCH_TYPE%

:: libucrt.lib
set PATH_KIT_LIB_UCRT=%MSVC_PATH_ROOT%\Kit\Lib\10.0.19041.0\ucrt\%MSVC_ARCH_TYPE%


::-----------------------------------
:: ����PATH,Ϊnmake
::-----------------------------------
set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KIT_BIN%

::-----------------------------------
:: �������
::-----------------------------------

del /Q .\tmp\*
rmdir /Q .\tmp

nmake /nologo /f .\makefile.nmake

::-----------------------------------
:: ����ʧ����ͣ
::-----------------------------------

::if %errorlevel% neq 0 ( pause )

pause