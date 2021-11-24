::-----------------------------------------------------
:: 调用nmake.exe使用makefile.nmake为配置编译工程
:: 此文件编码     ANSI
:: MSVC_ARCH_TYPE 架构x64/x64
:: MSVC_PATH_ROOT 编译工具路径,包含Kit,MSVC两目录,文件直接从VS2019中复制
:: SRC            源文件路径
:: TMP            临时文件路径
::-----------------------------------------------------
:: 不显示命令字符串
@echo off

set MSVC_ARCH_TYPE=x86
set MSVC_PATH_ROOT=D:\4.backup\coding\MSVC-2019

set SRC=..\src
set TMP=..\tmp

::-----------------------------------------------------
:: 编译工具路径

:: nmake.exe
set PATH_MSVC_BIN=%MSVC_PATH_ROOT%\MSVC\14.29.30037\bin\Hostx64\%MSVC_ARCH_TYPE%

:: vcruntime.h
set PATH_MSVC_INCLUDE=%MSVC_PATH_ROOT%\MSVC\14.29.30037\include

:: LIBCMT.lib
set PATH_MSVC_LIB=%MSVC_PATH_ROOT%\MSVC\14.29.30037\lib\%MSVC_ARCH_TYPE%

:: rc.exe
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

::-----------------------------------------------------
:: 执行命令

cd %~dp0

setLocal EnableDelayedExpansion

if "%PATH_SET%" neq "1" (
    set PATH_SET=1
    set PATH=%PATH%;%PATH_MSVC_BIN%;%PATH_KIT_BIN%
)

if not exist "%TMP%" (
    mkdir %TMP%
) else (
    del /q %TMP%\*
)

pushd %SRC%

for /f %%I in ('dir /s/b *.c *.cpp') do @(set "FILES_SRC=!FILES_SRC! %%I"&set "FILES_OBJ=!FILES_OBJ! %TMP%\%%~nI.obj")

popd

nmake /nologo /f .\makefile.nmake
