::-----------------------------------------------------
:: Copyright:   XT Tech. Co., Ltd.
:: File:        make.bat
:: Author:      张海涛
:: Version:     1.0.0
:: Encode:      ANSI
:: Date:        2022-01-17
:: Description: 调用nmake.exe编译工程
::-----------------------------------------------------

:: 不显示命令字符串
@echo off

:: 程序名称
set NAME=example

:: 程序类型:exe,dll,lib
set EXT=exe

:: 程序架构:x86,x64
set ARCH=x86

:: 是否调试:y,n
set DEBUG=n

:: 字符集:mbcs,unicode,utf8
set CHARSET=utf8

:: 源文件路径
set SRC=.

:: 资源描述文件
set RES=

:: 排除的文件
set EXCLUDE=

:: 临时文件路径
set TMP=tmp

:: 目标文件路径
set OUT=

:: 编译参数
set CFLAGS=

:: 链接参数
set LFLAGS=gdi32.lib User32.lib Advapi32.lib Shell32.lib

::-----------------------------------------------------
:: 读取配置文件make.ini

set DIR=%1

if "%DIR%" == "" (
    echo "don't set make.ini path"
    pause
    exit
)

::将\替换成空格
set DIR=%DIR:\= %

set INI=

SET ROOT=

set DELIMS=

setLocal EnableDelayedExpansion

::查找make.ini文件
for %%i in (%DIR%) do (
    set "INI=!INI!!DELIMS!%%i"
    set "DELIMS=\"
    if exist "!INI!\make.ini" (
        set "ROOT=!INI!"
        set "INI=!INI!\make.ini"
        goto break
    )
)

:break

if not exist "%INI%" (
    echo "don't have %INI%"
    pause
    exit
)

for /f "tokens=1,2 delims==" %%a in (%INI%) do (
    set %%a=%%b
)

::-----------------------------------------------------
:: 编译工具

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
:: 编译MFC程序需要将下面的代码加入代码中
:: #ifdef NMAKE
::  // 来自于Microsoft Visual Studio\2022\VC\Tools\MSVC\14.30.30705\atlmfc\src\mfc\winmain.cpp
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
::  // 来自于Microsoft Visual Studio\2022\VC\Tools\MSVC\14.30.30705\atlmfc\src\mfc\appmodule.cpp
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
:: 编译参数
:: /c                    只编译,不链接
:: /Gd                   调用约定:_cdecl
:: /W3                   警告等级3
:: /WX                   将警告视为错误
:: /FC                   使用完整路径
:: /GS                   启用安全检查
:: /sdl                  启用SDL检查
:: /EHsc                 启用C++异常
:: /Gm-                  停用最小重新生成
:: /nologo               不显示版权信息
:: /permissive-          符合模式
:: /Zc:wchar_t           将wchar_t视为类型
:: /Zc:inline            移除未引用代码和数据
:: /Zc:forScope          for循环范围检查
:: /fp:precise           浮点模型:精度
:: /diagnostics:column   诊断格式:列
:: /errorReport:prompt   错误报告:立即提示
:: /Fo:"$(TMP)/"         输出路径
:: /Fd:"$(TMP)/"         vc***.pdb路径
:: /D "_WINDOWS"
:: /utf-8                UTF8编译
::-----------------------debug-----
:: /JMC                  支持仅我的代码调试
:: /ZI                   启用“编辑并继续”调试信息
:: /Od                   禁用优化
:: /RTC1                 运行时检查
::-----------------------release-----
:: /Zi                   启用调试信息
:: /O2                   最大化速度
:: /Oi                   启用内部函数
:: /GL                   启用链接时代码生成
:: /Gy                   分隔链接器函数

:: 包含路径
set INCLUDE=/I"%PATH_MSVC_INCLUDE%" ^
/I"%PATH_MSVC_INCLUDE_MFC%" ^
/I"%PATH_KITS_INCLUDE_UM%" ^
/I"%PATH_KITS_INCLUDE_UCRT%" ^
/I"%PATH_KITS_INCLUDE_SHARED%"

:: 编译代码参数
set CFLAGS=%INCLUDE% %CFLAGS% ^
/nologo /c /Gd /FC /W3 /WX ^
/GS- /sdl- /EHsc- /Gm- /permissive- ^
/Zc:wchar_t /Zc:inline /Zc:forScope ^
/fp:precise /diagnostics:column /errorReport:prompt ^
/Fo:"$(ROOT)\$(TMP)/" /Fd:"$(ROOT)\$(TMP)/" /D"NMAKE"

:: 构建类型:debug,release
if "%DEBUG%" == "y" (
    set CFLAGS=%CFLAGS% /D"_DEBUG" /JMC /ZI /Od /RTC1
) else (
    set CFLAGS=%CFLAGS% /D"NDEBUG" /Zi /O2 /Oi /GL /Gy
)

:: 程序架构类型:x64,x86
if "%ARCH%" == "x64" (
    set CFLAGS=%CFLAGS% /D"_WINDOWS" /D"_WIN64" /D"X64"
) else (
    set CFLAGS=%CFLAGS% /D"_WINDOWS" /D"_WIN32" /D"WIN32"
)

:: 字符集类型:mbcs,unicode,utf8
if "%CHARSET%" == "mbcs" (
    set CFLAGS=%CFLAGS% /D"_MBCS"
) else if "%CHARSET%" == "unicode" (
    set CFLAGS=%CFLAGS% /D"_UNICODE" /D"UNICODE"
) else (
    set CFLAGS=%CFLAGS% /D"_UNICODE" /D"UNICODE" /utf-8
)

::-----------------------------------------------------
:: 编译资源参数
set RFLAGS=%INCLUDE% /nologo /fo"$(ROOT)\$(TMP)\$(NAME).res" "$(ROOT)\$(RES)"

::-----------------------------------------------------
:: 连接参数说明
:: /LIBPATH:        lib文件包在路径
:: /MANIFEST        生成清单
:: /NXCOMPAT        数据执行保护
:: /TLBID:1         资源ID
:: /INCREMENTAL:NO  增量连接
:: /OPT:REF         引用
:: /LTCG:incremental使用快速连接生成代码

:: 包含路径
set LIBPATH=/LIBPATH:"%PATH_MSVC_LIB%" ^
/LIBPATH:"%PATH_MSVC_LIB_MFC%" ^
/LIBPATH:"%PATH_KITS_LIB_UM%" ^
/LIBPATH:"%PATH_KITS_LIB_UCRT%"

:: 连接参数
set LFLAGS=%LFLAGS% %LIBPATH% /nologo /MANIFEST /NXCOMPAT /ERRORREPORT:PROMPT /TLBID:1

:: 构建类型:debug,release
if "%DEBUG%" == "y" (
    set LFLAGS=%LFLAGS% /DEBUG /INCREMENTAL
) else (
    set LFLAGS=%LFLAGS% /INCREMENTAL:NO /OPT:REF /LTCG:incremental
)

:: 目标类型:exe,dll,lib
if "%EXT%" == "exe" (
    set LFLAGS=%LFLAGS% /OUT:%TMP%\%NAME%.exe
) else if "%EXT%" == "dll" (
    set LFLAGS=%LFLAGS% /OUT:%TMP%\%NAME%.dll /DLL
) else if "%EXT%" == "lib" (
    set LFLAGS=/OUT:%OUT%\%NAME%.lib
    set TOOL_LNK=%TOOL_LIB%
) else (
    echo EXT=%EXT% error
    pause
    exit
)

::-----------------------------------------------------

:: 移动文件
set MOV_SRC=%TMP%\%NAME%.%EXT%
set MOV_DST=%OUT%\%NAME%.%EXT%

:: 检查临目录
if not exist "%ROOT%\%TMP%" (
    mkdir "%ROOT%\%TMP%"
) else (
    del /q "%ROOT%\%TMP%\*"
)

:: 保存当前目录
set CD=%~dp0

:: 源代码文件
set FILES_SRC=
set FILES_OBJ=

:: 多个源目录
for %%I in (%SRC%) do (
    if exist "%ROOT%\%%I" (
        cd "%ROOT%\%%I"
    ) else (
        cd "%%I"
    )

    :: 查找源文件
    for /f %%J in ('dir /s/b *.c *.cpp') do (
        set "FILES_SRC=!FILES_SRC! %%J"

        echo %EXCLUDE% | findstr %%~nJ > nul && (
            echo "exclude %%J"
        ) || (
            set "FILES_OBJ=!FILES_OBJ! %ROOT%\%TMP%\%%~nJ.obj"
        )
    )
)

:: 资源文件
if "%RES%" neq "" (
    set FILES_OBJ=%FILES_OBJ% %ROOT%\%TMP%\%NAME%.res
    set REC=REC
)

:: 输出目录
if "%OUT%" neq "" (
    set MOV=MOV
)

:: 生成makefile.nmake
echo all : %REC% OBJ BIN %MOV%^

REC : %ROOT%\$(RES)^

    $(TOOL_RC) %RFLAGS%^

OBJ : $(FILES_SRC)^

    $(TOOL_CC) $** $(CFLAGS)^

BIN : $(FILES_OBJ)^

    $(TOOL_LNK) $** $(LFLAGS)^

MOV :^

    move "%MOV_SRC%" "%MOV_DST%" >> "%ROOT%\%TMP%\makefile.nmake"

cd %ROOT%

:: 设置系统路径
set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KITS_BIN%

:: 编译程序
nmake /nologo /f "%TMP%\makefile.nmake"

cd %CD%

:: 错误暂停
if "%errorlevel%" neq "0" (
    pause
)
