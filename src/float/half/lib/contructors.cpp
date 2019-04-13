#pragma GCC diagnostic ignored "-Wpointer-arith"
#include "half.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <string>
#include <cinttypes>
using namespace floating;

Half::Half(const Half &s)
{
    data.raw = s.data.raw;
}

Half::Half(float f)
{
    initFromFloat(f);
}

// Used by defined literals
Half::Half(long double longDouble)
{
    initFromFloat((float)longDouble);
}

// Used by defined literals
Half::Half(unsigned long long uLongLong)
{
    //TODO conversion VCVTPS2PS
    data.raw = 0;
}

void Half::initFromFloat(float f)
{
    //TODO conversion VCVTPS2PS
    data.raw = 0;
}
