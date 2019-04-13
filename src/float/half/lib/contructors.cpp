#pragma GCC diagnostic ignored "-Wpointer-arith"
#include "half.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <string>
#include <cinttypes>
using namespace floating;
extern "C" void floatToHalf(float *, uint16_t *);

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
    initFromFloat((float)uLongLong);
}

void Half::initFromFloat(float f)
{
    floatToHalf(&f, &data.raw);
}
