//--------------------------
// charset:ANSI
//--------------------------

#include <stdio.h>
#include <stdlib.h>

__declspec(dllexport) int dll1_printf(int a, char *b)
{
    printf("this is dll1_printf arg_a:%d arg_b:%s\n", a, b);
    return a;
}