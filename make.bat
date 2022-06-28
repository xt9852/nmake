::-----------------------------------------------------
:: Copyright:   XT Tech. Co., Ltd.
:: File:        make.bat
:: Author:      �ź���
:: Version:     1.0.0
:: Encode:      ANSI
:: Date:        2022-01-17
:: Description: ����nmake.exe���빤��
::-----------------------------------------------------
:: ����MFC������Ҫ������Ĵ�����������
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
::----------debug--------
:: /JMC                  ֧�ֽ��ҵĴ������
:: /ZI                   ���á��༭��������������Ϣ
:: /Od                   �����Ż�
:: /RTC1                 ����ʱ���
::---------release-------
:: /Zi                   ���õ�����Ϣ
:: /O2                   ����ٶ�
:: /Oi                   �����ڲ�����
:: /GL                   ��������ʱ��������
:: /Gy                   �ָ�����������
::-----------------------------------------------------
:: ���Ӳ���
:: /LIBPATH:        lib�ļ�����·��
:: /MANIFEST        �����嵥
:: /NXCOMPAT        ����ִ�б���
:: /TLBID:1         ��ԴID
:: /INCREMENTAL:NO  ��������
:: /OPT:REF         ����
:: /LTCG:incrementalʹ�ÿ����������ɴ���
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
set SRC=.

:: ��Դ�����ļ�
set RES=

:: �ų����ļ�
set EXCLUDE=

:: ��ʱ�ļ�·��
set TMP=tmp

:: Ŀ���ļ�·��
set OUT=.

:: �������
set CF=

:: ���Ӳ���
set LF=gdi32.lib User32.lib Advapi32.lib Shell32.lib

::-----------------------------------------------------
:: ��ȡ�����ļ�make.ini

:: ���в���1
if "%1" == "" (
    echo "don't have param"
    pause
    exit
)

:: �������1
set DIR=%1

:: ��\�滻�ɿո�,��Ϊfor������\�ָ��ַ�
set DIR=%DIR:\= %

:: ��ʱ������չ
setLocal EnableDelayedExpansion

:: ����Ŀ¼����
for %%i in (%DIR%) do (
    set /a NUM+=1
)

:: ����ѭ��
for /L %%i in (%NUM%, -1, 1) do (
    set j=0
    set INI=
    set TOK=

    :: ƴ��·��
    for %%d in (%DIR%) do (
        set INI=!INI!!TOK!%%d
        set TOK=\
        set /a j+=1
        if "!j!" == "%%i" (
            :: forѭ���ڲ����б�ǩ
            rem ����make.ini�ļ�,ʹ��::�ᱨϵͳ�Ҳ���ָ��������
            if exist "!INI!\make.ini" (
                set ROOT=!INI!
                set INI=!INI!\make.ini
                goto find_make_ini
            )
        )
    )
)

:: û���ҵ�make.ini
echo "don't have make.ini"
pause
exit

:find_make_ini

:: ��ȡmake.ini,��=�ָ��ַ�,�����ñ���
for /f "tokens=1,2 delims==" %%a in (%INI%) do (
    set %%a=%%b
)

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
:: ����������

:: ����·��
set INCLUDE=/I"%PATH_MSVC_INCLUDE%" /I"%PATH_MSVC_INCLUDE_MFC%" ^
/I"%PATH_KITS_INCLUDE_UM%" /I"%PATH_KITS_INCLUDE_UCRT%" /I"%PATH_KITS_INCLUDE_SHARED%"

:: �������
set CF=%INCLUDE% /nologo /c /Gd /FC /W3 /WX /GS- /sdl- /EHsc- /Gm- /permissive- /Zc:wchar_t /Zc:inline /Zc:forScope ^
/fp:precise /diagnostics:column /errorReport:prompt /Fo:"$(ROOT)\$(TMP)/" /Fd:"$(ROOT)\$(TMP)/" /D"NMAKE" %CF%

:: ��������:debug,release
if "%DEBUG%" == "y" (
    set CF=%CF% /D"_DEBUG" /JMC /ZI /Od /RTC1
) else (
    set CF=%CF% /D"NDEBUG" /Zi /O2 /Oi /GL /Gy
)

:: ����ܹ�����:x64,x86
if "%ARCH%" == "x64" (
    set CF=%CF% /D"_WINDOWS" /D"_WIN64" /D"X64"
) else (
    set CF=%CF% /D"_WINDOWS" /D"_WIN32" /D"WIN32"
)

:: �ַ�������:mbcs,unicode,utf8
if "%CHARSET%" == "mbcs" (
    set CF=%CF% /D"_MBCS"
) else if "%CHARSET%" == "unicode" (
    set CF=%CF% /D"_UNICODE" /D"UNICODE"
) else (
    set CF=%CF% /D"_UNICODE" /D"UNICODE" /utf-8
)

:: ������Դ����
set RF=%INCLUDE% /nologo /fo"$(ROOT)\$(TMP)\$(NAME).res" "$(ROOT)\$(RES)"

::-----------------------------------------------------
:: ���ӳ������

:: ����·��
set LIBP=/LIBPATH:"%PATH_MSVC_LIB%" /LIBPATH:"%PATH_MSVC_LIB_MFC%" /LIBPATH:"%PATH_KITS_LIB_UM%" /LIBPATH:"%PATH_KITS_LIB_UCRT%"

:: ���Ӳ���
set LF=%LF% %LIBP% /nologo /MANIFEST /NXCOMPAT /ERRORREPORT:PROMPT /TLBID:1

:: ��������:debug,release
if "%DEBUG%" == "y" (
    set LF=%LF% /DEBUG /INCREMENTAL
) else (
    set LF=%LF% /INCREMENTAL:NO /OPT:REF /LTCG:incremental
)

:: Ŀ������:exe,dll,lib
if "%EXT%" == "exe" (
    set LF=%LF% /OUT:%TMP%\%NAME%.exe
) else if "%EXT%" == "dll" (
    set LF=%LF% /OUT:%TMP%\%NAME%.dll /DLL
) else if "%EXT%" == "lib" (
    set LF=/OUT:%TMP%\%NAME%.lib
    set TOOL_LNK=%TOOL_LIB%
) else (
    echo EXT=%EXT% error
    pause
    exit
)

::-----------------------------------------------------

:: �ƶ��ļ�
set MOV_SRC=%TMP%\%NAME%.%EXT%
set MOV_DST=%OUT%\%NAME%.%EXT%

:: �����Ŀ¼
if not exist "%ROOT%\%TMP%" (
    mkdir "%ROOT%\%TMP%"
) else (
    del /q "%ROOT%\%TMP%\*"
)

:: ���浱ǰĿ¼
set CD=%~dp0

:: Դ�����ļ�
set FILES_SRC=
set FILES_OBJ=

:: ���ԴĿ¼
for %%I in (%SRC%) do (
    if exist "%ROOT%\%%I" (
        cd "%ROOT%\%%I"
    ) else (
        cd "%%I"
    )

    :: ����Դ�ļ�
    for /f %%J in ('dir /s/b *.c *.cpp') do (
        :: �ų����ļ�
        echo %EXCLUDE% | findstr %%~nJ > nul && (
            echo "exclude %%J"
        ) || (
            set "FILES_SRC=!FILES_SRC! %%J"
            set "FILES_OBJ=!FILES_OBJ! %ROOT%\%TMP%\%%~nJ.obj"
        )
    )
)

:: ��Դ�ļ�
if "%RES%" neq "" (
    set FILES_OBJ=%FILES_OBJ% %ROOT%\%TMP%\%NAME%.res
    set REC=REC
)

:: ���Ŀ¼
if "%OUT%" neq "" (
    set MOV=MOV
)

:: ����makefile.nmake
echo all : %REC% OBJ BIN %MOV%^

REC : %ROOT%\$(RES)^

    $(TOOL_RC) %RF%^

OBJ : $(FILES_SRC)^

    $(TOOL_CC) $** $(CF)^

BIN : $(FILES_OBJ)^

    $(TOOL_LNK) $** $(LF)^

MOV :^

    move "%MOV_SRC%" "%MOV_DST%" >> "%ROOT%\%TMP%\makefile.nmake"

:: ��������Ŀ¼
cd %ROOT%

:: ����ϵͳ·��
set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KITS_BIN%

:: �������
nmake /nologo /f "%TMP%\makefile.nmake"

:: ������ͣ
if "%errorlevel%" == "0" (
    timeout /T 3
) else (
    pause
)
