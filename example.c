//--------------------------
// charset:UTF8
//--------------------------
#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <Winsock2.h>
#include <WS2tcpip.h>
#include <tlhelp32.h>
#include <tchar.h>
#include "dll\example-dll1.h"
#include "dll\example-dll2.h"


SOCKET http_connect_server(const char *host, int port)
{
    SOCKET s = 0;
    struct sockaddr_in address;

    memset(&address, 0, sizeof(address));

    address.sin_family = AF_INET;
    address.sin_port = htons((unsigned short)port);

    WSADATA wsa;
    WSAStartup(MAKEWORD(1, 1), &wsa);

    if ((s = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        return -1;
    }

    //address.sin_addr.s_addr = inet_addr(host);
    InetPtonA(AF_INET, host, &address.sin_addr.s_addr);

    // 设置接收和发送超时
    struct timeval timeout = { 15, 0 };
    setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, (const char *)&timeout, sizeof(timeout));
    setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (const char *)&timeout, sizeof(timeout));

    if (connect(s, (struct sockaddr*) &address, sizeof(address)) == -1)
    {
        closesocket(s);
        return -3;
    }

    return s;
}

int http_send_get(SOCKET sock, const char *host, int port, const char *path)
{
    int len;
    char buf[1024];

    len = sprintf_s(buf, sizeof(buf) - 1,
        "GET %s HTTP/1.1\r\n"
        "Host: %s:%d\r\n"
        "Connection: close\r\n"
        "\r\n",
        path, host, port);

    return (len != send(sock, buf, len, 0));
}

int network_test()
{
    int len;
    int port = 80;
    char *addr = "220.181.38.149"; //www.baidu.com
    char *path = "/";
    char info[512];
    char buff[512];
    SOCKET sock;

    sprintf_s(info, sizeof(info) - 1, "%s:%d%s", addr, port, path);

    sock = http_connect_server(addr, port);

    if (sock <= 0)
    {
        printf_s("connect fail %s\n", info);
        return -1;
    }

    printf("connect ok %s\n", info);

    if (0 != http_send_get(sock, addr, port, path))
    {
        closesocket(sock);
        printf("send data head fail %s\n", info);
        return -2;
    }

    printf("send ok\n");

    len = recv(sock, buff, sizeof(buff) - 1, 0);

    closesocket(sock);

    if (len <= 0)
    {
        printf("sock data fail %s\n", info);
        return -3;
    }

    buff[len] = '\0';

    printf("recv ok\n%s", buff);

    if (0 != strncmp(buff, "HTTP/1.1 200 OK", 15))
    {
        printf("get data stats fail %s\n", info);
        return -4;
    }

    return 0;
}

DWORD get_proc_id(TCHAR *process_name)
{
    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(pe32);

    HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

    BOOL ret = Process32First(snap, &pe32);

    while (ret)
    {
        if (0 == _tcscmp(pe32.szExeFile, process_name))
        {
            return pe32.th32ProcessID;
        }

        ret = Process32Next(snap, &pe32);
    }

    return 0;
}

struct handle_data {
    HWND handle;
    unsigned long process_id;
};

BOOL IsMainWindow(HWND handle)
{
    return GetWindow(handle, GW_OWNER) == (HWND)0 && IsWindowVisible(handle);
}

BOOL CALLBACK EnumWindowsCallback(HWND handle, LPARAM lParam)
{
    struct handle_data *data = (struct handle_data*)lParam;

    unsigned long process_id = 0;
    GetWindowThreadProcessId(handle, &process_id);

    if (data->process_id != process_id || !IsMainWindow(handle))
    {
        return TRUE;
    }

    data->handle = handle;
    return FALSE;
}

HWND FindMainWindow(unsigned long process_id)
{
    struct handle_data data = { 0, process_id };
    EnumWindows(EnumWindowsCallback, (LPARAM)&data);
    return data.handle;
}

int main1(int argc, char *argv[])
{
    printf("\n\n--0-----------------------------------\n");
    printf("date:%s time:%s\n", __DATE__, __TIME__);

    network_test();

    printf("--1-----------------------------------\n");

    TCHAR *proc_name = _T("example.exe");

    int pid = get_proc_id(proc_name);

    printf("current pid:%d\n", pid);

    printf("--2-----------------------------------\n");

    STARTUPINFO si;
    memset(&si, 0, sizeof(STARTUPINFO));
    si.cb = sizeof(STARTUPINFO);
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_SHOW;

    PROCESS_INFORMATION pi;

    TCHAR *proc_name_new = _T("c:\\windows\\notepad.exe");

    CreateProcess(proc_name_new, NULL, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);

    printf("start cmd.exe pid:%d 3s kill\n", pi.dwProcessId);

    printf("--3-----------------------------------\n");

    Sleep(3000);

    HWND hproc = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pi.dwProcessId);

    TerminateProcess(hproc, 0);

    printf("--4-----------------------------------\n");

    TCHAR *name = _T("example.dll");

    _tprintf(_T("loadlibrary %s...\n"), name);

    HMODULE dll = LoadLibrary(name);

    if (NULL == dll)
    {
        _tprintf(_T("loadlibrary %s fail\n"), name);
        _getch();
        return 0;
    }

    _tprintf(_T("loadlibrary %s ok\n"), name);

    DLL1_PRINTF func = (DLL1_PRINTF)GetProcAddress(dll, "dll1_printf");

    if (NULL == func)
    {
        printf("GetProcAddress dll_printf fail\n");
        _getch();
        return 0;
    }

    printf("call dll_printf(1234, \"abce\")\n");

    func(1234, "abce");

    FreeLibrary(dll);

    printf("--5-----------------------------------\n");

    _getch();
    return 0;
}

//-------------------------------------------------------------------
#include <windows.h>

#define IDI_GREEN 108


//定义窗口回调函数
LRESULT CALLBACK WinProc(
    HWND hwnd,      // handle to window
    UINT uMsg,      // message identifier
    WPARAM wParam,  // first message parameter
    LPARAM lParam   // second message parameter
    )
{
    switch(uMsg)
    {
    case WM_CHAR:
        TCHAR info[20];
        _stprintf_s(info, sizeof(info)/sizeof(TCHAR), _T("char code is %d"), (int)wParam);
        MessageBox(hwnd, info, _T("char"), 0);
        break;
    case WM_LBUTTONDOWN:
        MessageBox(hwnd, _T("mouse clicked"), _T("message"),0);
        HDC hdc = GetDC(hwnd);
        TextOut(hdc, 0, 50, _T("WM_LBUTTONDOWN"), (int)lstrlen(_T("WM_LBUTTONDOWN")));
        ReleaseDC(hwnd,hdc);
        break;
    case WM_PAINT:
        TCHAR txt[64];

#ifdef _WIN64
        _tcscpy_s(txt, sizeof(txt)/sizeof(TCHAR), _T("_WIN64 "));
#else
        _tcscpy_s(txt, sizeof(txt)/sizeof(TCHAR), _T("_WIN32 "));
#endif

#ifdef _DEBUG
        _tcscat_s(txt, sizeof(txt)/sizeof(TCHAR), _T("_DEBUG "));
#else
        _tcscat_s(txt, sizeof(txt)/sizeof(TCHAR), _T("NDEBUG "));
#endif

#ifdef _MBCS
        _tcscat_s(txt, sizeof(txt)/sizeof(TCHAR), _T("_MBCS "));
#else
        _tcscat_s(txt, sizeof(txt)/sizeof(TCHAR), _T("_UNICODE "));
#endif
    
        PAINTSTRUCT ps;
        HDC hDC = BeginPaint(hwnd,&ps);
        TextOut(hDC, 0, 0, txt, (int)lstrlen(txt));
        EndPaint(hwnd, &ps);
        break;
    case WM_CLOSE:
        if(IDYES == MessageBox(hwnd, _T("是否真的退出？"), _T("信息"), MB_YESNO))
        {
            DestroyWindow(hwnd);
        }
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProc(hwnd,uMsg,wParam,lParam);
    }
    return 0;
}

int WINAPI WinMain(
    HINSTANCE hInstance,      // handle to current instance
    HINSTANCE hPrevInstance,  // handle to previous instance
    LPSTR lpCmdLine,          // command line
    int nCmdShow              // show state
    )
{
    // 设计一个窗口类
    WNDCLASS wndcls;
    wndcls.cbClsExtra = 0;
    wndcls.cbWndExtra = 0;
    wndcls.hInstance = hInstance;
    wndcls.lpfnWndProc = WinProc;
    wndcls.lpszClassName = _T("FirstWindowApp");
    wndcls.lpszMenuName = NULL;
    wndcls.style = CS_HREDRAW | CS_VREDRAW;
    wndcls.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_GREEN));
    wndcls.hCursor = LoadCursor(NULL, IDC_CROSS);
    wndcls.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
    RegisterClass(&wndcls);

    // 创建窗口，并保存成功创建窗口后返回的句柄
    HWND hwnd = CreateWindow(wndcls.lpszClassName, // 类名
                             _T("example"),        // 窗口名
                             WS_OVERLAPPEDWINDOW,
                             CW_USEDEFAULT,
                             CW_USEDEFAULT,
                             600, 400,
                             NULL, NULL,
                             hInstance, NULL);

    // 显示及更新窗口
    ShowWindow(hwnd,SW_SHOWNORMAL);

    UpdateWindow(hwnd);

    //定义消息结构体，开始消息循环
    MSG msg;
    while(GetMessage(&msg,NULL,0,0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return (int)msg.wParam;
}