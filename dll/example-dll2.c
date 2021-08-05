//--------------------------
// charset:ANSI
//--------------------------

#include <stdio.h>
#include <stdlib.h>
#include "example-dll2.h"

__declspec(dllexport) int dll2_printf(int a, char *b)
{
    printf("this is dll2_printf arg_a:%d arg_b:%s\n", a, b);
    return a;
}
