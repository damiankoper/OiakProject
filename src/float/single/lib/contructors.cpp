#pragma GCC diagnostic ignored "-Wpointer-arith"
#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <string>
#include <cinttypes>
using namespace floating;

Single::Single(const Single &s)
{
    data.raw = s.data.raw;
}

Single::Single(float f)
{
    initFromFloat(f);
}

// Used by defined literals
Single::Single(long double longDouble)
{
    initFromFloat((float)longDouble);
}

// Used by defined literals
Single::Single(unsigned long long uLongLong)
{
    data.f = (float)uLongLong;
}

void Single::initFromFloat(float f)
{
    data.f = f;
}
