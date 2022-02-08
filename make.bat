::-----------------------------------------------------
:: Copyright:   2022, XT Tech. Co., Ltd.
:: File name:   make.bat
:: Description: ����nmake.exe���빤��
:: Author:      �ź���
:: Version:     0.0.0.1
:: Code:        ANSI
:: Date:        2022-01-17
:: History:     2022-01-17 �������ļ���
::-----------------------------------------------------

:: ����ʾ�����ַ���
@echo off

:: ��������
set NAME=example

:: ��������:exe,dll,lib
set EXT=exe

:: ����ܹ�:x86,x64
set ARCH=x86

:: �Ƿ����:y,n
set DEBUG=n

:: �ַ���:mbcs,unicode,utf8
set CHARSET=utf8

:: Դ�ļ�·��
set SRC=..\src\

:: Ŀ���ļ�·��
set OUT=..\tmp

:: ��ʱ�ļ�·��
set TMP=..\tmp

:: ��Դ�����ļ�
set FILE_RC=..\res\main.rc

:: �������
set CFLAGS=/I"..\res"

:: ���Ӳ���
set LFLAGS=gdi32.lib User32.lib Advapi32.lib Shell32.lib

::-----------------------------------------------------
:: ���빤��

set TOOL_CC=cl.exe
set TOOL_ML=ml.exe
set TOOL_RC=rc.exe
set TOOL_LIB=lib.exe
set TOOL_LNK=link.exe
set MSVC_PATH_ROOT=D:\4.backup\coding\VS2022
set PATH_MSVC_BIN=%MSVC_PATH_ROOT%\MSVC\14.30.30705\bin\Hostx64\%ARCH%
set PATH_MSVC_INCLUDE=%MSVC_PATH_ROOT%\MSVC\14.30.30705\include
set PATH_MSVC_INCLUDE_MFC=%MSVC_PATH_ROOT%\MSVC\14.30.30705\atlmfc\include
set PATH_MSVC_LIB=%MSVC_PATH_ROOT%\MSVC\14.30.30705\lib\%ARCH%
set PATH_MSVC_LIB_MFC=%MSVC_PATH_ROOT%\MSVC\14.30.30705\atlmfc\lib\%ARCH%
set PATH_KITS_BIN=%MSVC_PATH_ROOT%\Windows Kits\10.0.22000.0\bin\%ARCH%
set PATH_KITS_INCLUDE_UM=%MSVC_PATH_ROOT%\Windows Kits\10.0.22000.0\Include\um
set PATH_KITS_INCLUDE_UCRT=%MSVC_PATH_ROOT%\Windows Kits\10.0.22000.0\Include\ucrt
set PATH_KITS_INCLUDE_SHARED=%MSVC_PATH_ROOT%\Windows Kits\10.0.22000.0\Include\shared
set PATH_KITS_LIB_UM=%MSVC_PATH_ROOT%\Windows Kits\10.0.22000.0\Lib\um\%ARCH%
set PATH_KITS_LIB_UCRT=%MSVC_PATH_ROOT%\Windows Kits\10.0.22000.0\Lib\ucrt\%ARCH%

::-----------------------------------------------------
:: ����MFC������Ҫ������Ĵ�����³�����
:: #ifdef NMAKE
::  // ������Microsoft Visual Studio\2022\VC\Tools\MSVC\14.30.30705\atlmfc\src\mfc\winmain.cpp
::  int AFXAPI AfxWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
::      _In_ LPTSTR lpCmdLine, int nCmdShow)
::  {
::      ASSERT(hPrevInstance == NULL);
::
::      int nReturnCode = -1;
::      CWinThread* pThread = AfxGetThread();
::      CWinApp* pApp = AfxGetApp();
::
::      // AFX internal initialization
::      if (!AfxWinInit(hInstance, hPrevInstance, lpCmdLine, nCmdShow))
::          goto InitFailure;
::
::      // App global initializations (rare)
::      if (pApp != NULL && !pApp->InitApplication())
::          goto InitFailure;
::
::      // Perform specific initializations
::      if (!pThread->InitInstance())
::      {
::          if (pThread->m_pMainWnd != NULL)
::          {
::              TRACE(traceAppMsg, 0, "Warning: Destroying non-NULL m_pMainWnd\n");
::              pThread->m_pMainWnd->DestroyWindow();
::          }
::          nReturnCode = pThread->ExitInstance();
::          goto InitFailure;
::      }
::      nReturnCode = pThread->Run();
::
::  InitFailure:
::  #ifdef _DEBUG
::      // Check for missing AfxLockTempMap calls
::      if (AfxGetModuleThreadState()->m_nTempMapLock != 0)
::      {
::          TRACE(traceAppMsg, 0, "Warning: Temp map lock count non-zero (%ld).\n",
::              AfxGetModuleThreadState()->m_nTempMapLock);
::      }
::      AfxLockTempMaps();
::      AfxUnlockTempMaps(-1);
::  #endif
::
::      AfxWinTerm();
::      return nReturnCode;
::  }
::
::  // ������Microsoft Visual Studio\2022\VC\Tools\MSVC\14.30.30705\atlmfc\src\mfc\appmodule.cpp
::  extern "C" int WINAPI
::  _tWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
::      _In_ LPTSTR lpCmdLine, int nCmdShow)
::  #pragma warning(suppress: 4985)
::  {
::      // call shared/exported WinMain
::      return AfxWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
::  }
:: #endif
::-----------------------------------------------------
:: �������
:: /c                    ֻ����,������
:: /Gd                   ����Լ��:_cdecl
:: /W3                   ����ȼ�3
:: /WX                   ��������Ϊ����
:: /FC                   ʹ������·��
:: /GS                   ���ð�ȫ���
:: /sdl                  ����SDL���
:: /EHsc                 ����C++�쳣
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
:: /utf-8                UTF8����
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

:: ����·��
set INCLUDE=/I"%PATH_MSVC_INCLUDE%" ^
/I"%PATH_MSVC_INCLUDE_MFC%" ^
/I"%PATH_KITS_INCLUDE_UM%" ^
/I"%PATH_KITS_INCLUDE_UCRT%" ^
/I"%PATH_KITS_INCLUDE_SHARED%"

:: �������
set CFLAGS=%INCLUDE% %CFLAGS% ^
/nologo /c /Gd /FC /W3 /WX ^
/GS- /sdl- /EHsc- /Gm- /permissive- ^
/Zc:wchar_t /Zc:inline /Zc:forScope ^
/fp:precise /diagnostics:column /errorReport:prompt ^
/Fo:"$(TMP)/" /Fd:"$(TMP)/" /D"NMAKE"

:: ��������:debug,release
if "%DEBUG%" == "y" (
    set CFLAGS=%CFLAGS% /D"_DEBUG" /JMC /ZI /Od /RTC1
) else (
    set CFLAGS=%CFLAGS% /D"NDEBUG" /Zi /O2 /Oi /GL /Gy
)

:: ����ܹ�����:x64,x86
if "%ARCH%" == "x64" (
    set CFLAGS=%CFLAGS% /D"_WIN64" /D"X64"
) else (
    set CFLAGS=%CFLAGS% /D"_WIN32" /D"WIN32"
)

:: �ַ�������:mbcs,unicode,utf8
if "%CHARSET%" == "mbcs" (
    set CFLAGS=%CFLAGS% /D"_MBCS"
) else if "%CHARSET%" == "unicode" (
    set CFLAGS=%CFLAGS% /D"_UNICODE" /D"UNICODE"
) else (
    set CFLAGS=%CFLAGS% /D"_UNICODE" /D"UNICODE" /utf-8
)

:: ������Դ
set RFLAGS=%INCLUDE% /nologo /fo"$(TMP)\$(NAME).res" "$(FILE_RC)"

::-----------------------------------------------------
:: ���Ӳ���
:: /LIBPATH:        lib�ļ�����·��
:: /MANIFEST        �����嵥
:: /NXCOMPAT        ����ִ�б���
:: /TLBID:1         ��ԴID
:: /INCREMENTAL:NO  ��������
:: /OPT:REF         ����
:: /LTCG:incrementalʹ�ÿ����������ɴ���

:: ����·��
set LIBPATH=/LIBPATH:"%PATH_MSVC_LIB%" ^
/LIBPATH:"%PATH_MSVC_LIB_MFC%" ^
/LIBPATH:"%PATH_KITS_LIB_UM%" ^
/LIBPATH:"%PATH_KITS_LIB_UCRT%"

:: ���Ӳ���
set LFLAGS=%LFLAGS% %LIBPATH% /nologo /MANIFEST /NXCOMPAT /ERRORREPORT:PROMPT /TLBID:1

:: ��������:debug,release
if "%DEBUG%" == "y" (
    set LFLAGS=%LFLAGS% /DEBUG /INCREMENTAL
) else (
    set LFLAGS=%LFLAGS% /INCREMENTAL:NO /OPT:REF /LTCG:incremental
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
if not exist "%TMP%" (
    mkdir "%TMP%"
) else (
    del /q "%TMP%\*"
)

::  �����ӳٱ���,Ҫ�� pushd "%SRC%" ֮ǰ
setLocal EnableDelayedExpansion

:: ����Դ�ļ�Ŀ¼
pushd "%SRC%"

:: ���
set FILES_SRC=
set FILES_OBJ=

:: ����Դ�ļ�
for /f %%I in ('dir /s/b *.c *.cpp') do (
    set "FILES_SRC=!FILES_SRC! %%I"
    set "FILES_OBJ=!FILES_OBJ! %TMP%\%%~nI.obj"
)

:: ��Դ�ļ�
if "%FILE_RC%" neq "" (
    set FILES_OBJ=%FILES_OBJ% %TMP%\%NAME%.res
)

:: �ص�ԭĿ¼
popd

:: ����ϵͳ����
set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KITS_BIN%

:: ��Դ
if "%FILE_RC%" neq "" (
    set REC=REC
)

:: ����makefile.nmake
echo all : %REC% OBJ BIN^

REC : $(FILE_RC)^

    $(TOOL_RC) %RFLAGS%^

OBJ : $(FILES_SRC)^

    $(TOOL_CC) $** $(CFLAGS)^

BIN : $(FILES_OBJ)^

    $(TOOL_LNK) $** $(LFLAGS) >> "%TMP%\makefile.nmake"

:: �������
nmake /nologo /f "%TMP%\makefile.nmake"

:: ������ͣ
if "%errorlevel%" neq "0" (
    pause
)
