::-----------------------------------------------------
:: 调用nmake.exe编译工程
:: 此文件编码     ANSI
::-----------------------------------------------------

:: 不显示命令字符串
@echo off

:: 程序架构
set MSVC_ARCH_TYPE=x86

:: 编译工程根路径
set MSVC_PATH_ROOT=D:\4.backup\coding\MSVC-2019

::-----------------------------------------------------

:: 程序名称
set NAME=example

:: 程序类型:exe,dll,lib
set EXT=exe

:: 是否可调试:y,n
set DEBUG=y

:: 字符集:mbcs,unicode
set CHARSET=mbcs

:: 源文件路径
set SRC=..\src

:: 目标文件路径
set OUT=..\tmp

:: 临时文件路径
set TMP=..\tmp

:: 资源描述文件
set FILE_RC=..\res\example.rc

:: 编译参数
set CFLAGS=/I".."

:: 链接参数
set LFLAGS=User32.lib Ws2_32.lib gdi32.lib

::-----------------------------------------------------
:: 编译工具

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
:: 编译参数
:: /c                    只编译,不链接
:: /Gd                   调用约定:_cdecl
:: /GS                   启用安全检查
:: /W3                   警告等级3
:: /WX-                  将警告视为错误
:: /FC                   使用完整路径
:: /EHsc                 启用C++异常
:: /sdl                  启用SDL检查
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

:: 公共参数 
set INCLUDE=/I"%PATH_MSVC_INCLUDE%" /I"%PATH_KIT_INCLUDE_UM%" /I"%PATH_KIT_INCLUDE_UCRT%" /I"%PATH_KIT_INCLUDE_SHARED%"
set CFLAGS=%CFLAGS% /nologo /c /Gd /GS /W3 /WX /FC /sdl /EHsc /sdl /Gm- /permissive- ^
/Zc:wchar_t /Zc:inline /Zc:forScope ^
/fp:precise /diagnostics:column /errorReport:prompt ^
/Fo:"$(TMP)/" /Fd:"$(TMP)/" /D"_WINDOWS"

:: 构建类型:debug,release
if "%DEBUG%" == "y" (
    set CFLAGS=%CFLAGS% %INCLUDE% /D"_DEBUG" /JMC /ZI /Od /RTC1
) else (
    set CFLAGS=%CFLAGS% %INCLUDE% /D"NDEBUG" /Zi /O2 /Oi /GL /Gy
)

:: 程序架构类型:x64,x86
if "%MSVC_ARCH_TYPE%" == "x64" (
    set CFLAGS=%CFLAGS% /D"_WIN64" /D"X64"
) else (
    set CFLAGS=%CFLAGS% /D"_WIN32" /D"WIN32"
)

:: 字符集类型:mbcs,unicode
if "$(CHARSET)" == "mbcs" (
    set CFLAGS=%CFLAGS% /D"_MBCS"
) else (
    set CFLAGS=%CFLAGS% /D"_UNICODE" /D"UNICODE"
)

::-----------------------------------------------------
:: 连接参数
set LIBPATH=/LIBPATH:"%PATH_MSVC_LIB%" /LIBPATH:"%PATH_KIT_LIB_UM%" /LIBPATH:"%PATH_KIT_LIB_UCRT%"
set LFLAGS=%LFLAGS% /MANIFEST /NXCOMPAT /ERRORREPORT:PROMPT /TLBID:1

:: 构建类型:debug,release
if "%DEBUG%" == "y" (
    set LFLAGS=%LFLAGS% %LIBPATH% /DEBUG /INCREMENTAL
) else (
    set LFLAGS=%LFLAGS% %LIBPATH% /INCREMENTAL:NO /OPT:REF /LTCG:incremental /SAFESEH
)

:: 目标类型:exe,dll,lib
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

:: 进入此脚本文件所在目录
cd "%~dp0"

:: 检查临目录
if not exist "%TMP%" (mkdir "%TMP%") else (del /q "%TMP%\*")

::  设置延迟变量,要在 pushd "%SRC%" 之前
setLocal EnableDelayedExpansion

:: 进入源文件目录
pushd "%SRC%"

:: 清空
set FILES_SRC=
set FILES_OBJ=

:: 查找源文件
for /f %%I in ('dir /s/b *.c *.cpp') do (set "FILES_SRC=!FILES_SRC! %%I"&set "FILES_OBJ=!FILES_OBJ! %TMP%\%%~nI.obj")

:: 资源文件
if "%FILE_RC%" neq "" (
    set FILES_OBJ=%FILES_OBJ% %TMP%\%NAME%.res
)

:: 回到原目录
popd

:: 设置PATH
if "%PATH_SET%" neq "1" (
    set PATH_SET=1
    set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KIT_BIN%
)

:: 生成makefile
echo all : REC OBJ BIN> "%TMP%\makefile.nmake"
echo REC : $(FILE_RC)>> "%TMP%\makefile.nmake"
echo     @if "$(FILE_RC)" NEQ "" ($(TOOL_RC) /fo"$(TMP)\$(NAME).res" "$(FILE_RC)")>> "%TMP%\makefile.nmake"
echo OBJ : $(FILES_SRC)>> "%TMP%\makefile.nmake"
echo     $(TOOL_CC) $** $(CFLAGS)>> "%TMP%\makefile.nmake"
echo BIN : $(FILES_OBJ)>> "%TMP%\makefile.nmake"
echo     $(TOOL_LNK) $** $(LFLAGS)>> "%TMP%\makefile.nmake"

:: 编译程序
nmake /nologo /f "%TMP%\makefile.nmake"
