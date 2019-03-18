#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <cinttypes>
using namespace floating;

Single Single::operator-()
{
    return changeSign();
}

bool Single::operator==(const Single &s)
{
    return s.a == a && s.b == b && s.c == c && s.d == d;
}

Single Single::abs()
{
    Single result = Single(*this);
    // Set number's 1st bit
    // dddd dddd AND 0111 1111
    result.d &= 0x7f;
    return result;
}

Single Single::changeSign()
{
    Single result = Single(*this);
    // Toggle number's 1st bit
    // dddd dddd XOR 1000 0000
    result.d ^= 0x80;
    return result;
}