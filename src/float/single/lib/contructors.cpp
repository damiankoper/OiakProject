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

Single::Single(float f)
{
    initFromFloat(f);
}

// Used by defined literals
Single::Single(long double longDouble)
{
    // TODO: covnert to float manually

    initFromFloat((float)longDouble);
}

// Used by defined literals
Single::Single(unsigned long long uLongLong)
{
    // TODO: make it work
    std::cout << uLongLong << std::endl;
}

void Single::initFromFloat(float f)
{
    // Little endian
    memcpy(&a, ((void *)&f), 1);
    memcpy(&b, ((void *)&f) + 1, 1);
    memcpy(&c, ((void *)&f) + 2, 1);
    memcpy(&d, ((void *)&f) + 3, 1);
}