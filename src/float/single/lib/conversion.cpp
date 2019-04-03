#pragma GCC diagnostic ignored "-Wpointer-arith"
#include "single.h"
#include <cstring>
using namespace floating;

int Single::toInt()
{
    return (int)data.f;
}

float Single::toFloat()
{
    return data.f;
}

double Single::toDouble()
{
    return (double)data.f;
}