::-----------------------------------------------------
:: ����nmake.exe���빤��
:: ���ļ�����     ANSI
::-----------------------------------------------------

:: ����ʾ�����ַ���
@echo off

:: ����ܹ�
set MSVC_ARCH_TYPE=x86

:: ���빤�̸�·��
set MSVC_PATH_ROOT=D:\4.backup\coding\MSVC-2019

::-----------------------------------------------------

:: ��������
set NAME=example

:: ��������:exe,dll,lib
set EXT=exe

:: �Ƿ�ɵ���:y,n
set DEBUG=y

:: �ַ���:mbcs,unicode
set CHARSET=mbcs

:: Դ�ļ�·��
set SRC=..\src

:: Ŀ���ļ�·��
set OUT=..\tmp

:: ��ʱ�ļ�·��
set TMP=..\tmp

:: ��Դ�����ļ�
set FILE_RC=..\res\example.rc

:: �������
set CFLAGS=/I".."

:: ���Ӳ���
set LFLAGS=User32.lib Ws2_32.lib gdi32.lib

::-----------------------------------------------------
:: ���빤��

set TOOL_CC=cl.exe
set TOOL_ML=ml.exe
set TOOL_RC=rc.exe
set TOOL_LIB=lib.exe
set TOOL_LNK=link.exe
set PATH_MSVC_BIN=%MSVC_PATH_ROOT%\MSVC\14.29.30037\bin\Hostx64\%MSVC_ARCH_TYPE%
set PATH_MSVC_INCLUDE=%MSVC_PATH_ROOT%\MSVC\14.29.30037\include
set PATH_MSVC_LIB=%MSVC_PATH_ROOT%\MSVC\14.29.30037\lib\%MSVC_ARCH_TYPE%
set PATH_KIT_BIN=%MSVC_PATH_ROOT%\Kit\bin\10.0.19041.0\%MSVC_ARCH_TYPE%
set PATH_KIT_INCLUDE_UM=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\um
set PATH_KIT_INCLUDE_UCRT=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\ucrt
set PATH_KIT_INCLUDE_SHARED=%MSVC_PATH_ROOT%\Kit\Include\10.0.19041.0\shared
set PATH_KIT_LIB_UM=%MSVC_PATH_ROOT%\Kit\Lib\10.0.19041.0\um\%MSVC_ARCH_TYPE%
set PATH_KIT_LIB_UCRT=%MSVC_PATH_ROOT%\Kit\Lib\10.0.19041.0\ucrt\%MSVC_ARCH_TYPE%

::-----------------------------------------------------
:: �������
:: /c                    ֻ����,������
:: /Gd                   ����Լ��:_cdecl
:: /GS                   ���ð�ȫ���
:: /W3                   ����ȼ�3
:: /WX-                  ��������Ϊ����
:: /FC                   ʹ������·��
:: /EHsc                 ����C++�쳣
:: /sdl                  ����SDL���
:: /Gm-                  ͣ����С��������
:: /nologo               ����ʾ��Ȩ��Ϣ
:: /permissive-          ����ģʽ
:: /Zc:wchar_t           ��wchar_t��Ϊ����
:: /Zc:inline            �Ƴ�δ���ô��������
:: /Zc:forScope          forѭ����Χ���
:: /fp:precise           ����ģ��:����
:: /diagnostics:column   ��ϸ�ʽ:��
:: /errorReport:prompt   ���󱨸�:������ʾ
:: /Fo:"$(TMP)/"         ���·��
:: /Fd:"$(TMP)/"         vc***.pdb·��
:: /D "_WINDOWS"
::-----------------------debug-----
:: /JMC                  ֧�ֽ��ҵĴ������
:: /ZI                   ���á��༭��������������Ϣ
:: /Od                   �����Ż�
:: /RTC1                 ����ʱ���
::-----------------------release-----
:: /Zi                   ���õ�����Ϣ
:: /O2                   ����ٶ�
:: /Oi                   �����ڲ�����
:: /GL                   ��������ʱ��������
:: /Gy                   �ָ�����������

:: �������� 
set INCLUDE=/I"%PATH_MSVC_INCLUDE%" /I"%PATH_KIT_INCLUDE_UM%" /I"%PATH_KIT_INCLUDE_UCRT%" /I"%PATH_KIT_INCLUDE_SHARED%"
set CFLAGS=%CFLAGS% /nologo /c /Gd /GS /W3 /WX /FC /sdl /EHsc /sdl /Gm- /permissive- ^
/Zc:wchar_t /Zc:inline /Zc:forScope ^
/fp:precise /diagnostics:column /errorReport:prompt ^
/Fo:"$(TMP)/" /Fd:"$(TMP)/" /D"_WINDOWS"

:: ��������:debug,release
if "%DEBUG%" == "y" (
    set CFLAGS=%CFLAGS% %INCLUDE% /D"_DEBUG" /JMC /ZI /Od /RTC1
) else (
    set CFLAGS=%CFLAGS% %INCLUDE% /D"NDEBUG" /Zi /O2 /Oi /GL /Gy
)

:: ����ܹ�����:x64,x86
if "%MSVC_ARCH_TYPE%" == "x64" (
    set CFLAGS=%CFLAGS% /D"_WIN64" /D"X64"
) else (
    set CFLAGS=%CFLAGS% /D"_WIN32" /D"WIN32"
)

:: �ַ�������:mbcs,unicode
if "$(CHARSET)" == "mbcs" (
    set CFLAGS=%CFLAGS% /D"_MBCS"
) else (
    set CFLAGS=%CFLAGS% /D"_UNICODE" /D"UNICODE"
)

::-----------------------------------------------------
:: ���Ӳ���
set LIBPATH=/LIBPATH:"%PATH_MSVC_LIB%" /LIBPATH:"%PATH_KIT_LIB_UM%" /LIBPATH:"%PATH_KIT_LIB_UCRT%"
set LFLAGS=%LFLAGS% /MANIFEST /NXCOMPAT /ERRORREPORT:PROMPT /TLBID:1

:: ��������:debug,release
if "%DEBUG%" == "y" (
    set LFLAGS=%LFLAGS% %LIBPATH% /DEBUG /INCREMENTAL
) else (
    set LFLAGS=%LFLAGS% %LIBPATH% /INCREMENTAL:NO /OPT:REF /LTCG:incremental /SAFESEH
)

:: Ŀ������:exe,dll,lib
if "%EXT%" == "exe" (
    set LFLAGS=%LFLAGS% /OUT:%OUT%\%NAME%.exe
) else if "%EXT%" == "dll" (
    set LFLAGS=%LFLAGS% /OUT:%OUT%\%NAME%.dll /DLL
) else if "%EXT%" == "lib" (
    set LFLAGS=/OUT:%OUT%\%NAME%.lib
    set TOOL_LNK=%TOOL_LIB%
) else (
    echo EXT=%EXT% error
    pause
    exit
)

::-----------------------------------------------------

:: ����˽ű��ļ�����Ŀ¼
cd "%~dp0"

:: �����Ŀ¼
if not exist "%TMP%" (mkdir "%TMP%") else (del /q "%TMP%\*")

::  �����ӳٱ���,Ҫ�� pushd "%SRC%" ֮ǰ
setLocal EnableDelayedExpansion

:: ����Դ�ļ�Ŀ¼
pushd "%SRC%"

:: ���
set FILES_SRC=
set FILES_OBJ=

:: ����Դ�ļ�
for /f %%I in ('dir /s/b *.c *.cpp') do (set "FILES_SRC=!FILES_SRC! %%I"&set "FILES_OBJ=!FILES_OBJ! %TMP%\%%~nI.obj")

:: ��Դ�ļ�
if "%FILE_RC%" neq "" (
    set FILES_OBJ=%FILES_OBJ% %TMP%\%NAME%.res
)

:: �ص�ԭĿ¼
popd

:: ����PATH
if "%PATH_SET%" neq "1" (
    set PATH_SET=1
    set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KIT_BIN%
)

:: ����makefile
echo all : REC OBJ BIN> "%TMP%\makefile.nmake"
echo REC : $(FILE_RC)>> "%TMP%\makefile.nmake"
echo     @if "$(FILE_RC)" NEQ "" ($(TOOL_RC) /fo"$(TMP)\$(NAME).res" "$(FILE_RC)")>> "%TMP%\makefile.nmake"
echo OBJ : $(FILES_SRC)>> "%TMP%\makefile.nmake"
echo     $(TOOL_CC) $** $(CFLAGS)>> "%TMP%\makefile.nmake"
echo BIN : $(FILES_OBJ)>> "%TMP%\makefile.nmake"
echo     $(TOOL_LNK) $** $(LFLAGS)>> "%TMP%\makefile.nmake"

:: �������
nmake /nologo /f "%TMP%\makefile.nmake"
