#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <string>
#include <cinttypes>
using namespace floating;

Single::Single(const Single &s)
{
    a = s.a;
    b = s.b;
    c = s.c;
    d = s.d;
}

// Used by defined literals
Single::Single(long double longDouble)
{
    // TODO: do this manually
    float castedFloat = (double)longDouble;

    // Little endian
    memcpy(&a, ((void *)&castedFloat), 1);
    memcpy(&b, ((void *)&castedFloat) + 1, 1);
    memcpy(&c, ((void *)&castedFloat) + 2, 1);
    memcpy(&d, ((void *)&castedFloat) + 3, 1);
    printBinary();
}

// Used by defined literals
Single::Single(unsigned long long uLongLong)
{
    // TODO: make it work
    std::cout << uLongLong << std::endl;
}