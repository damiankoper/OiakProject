#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <cinttypes>
using namespace floating;

extern "C" void addition(float *, float, float);

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

Single Single::uglyAddition(Single a, Single b)
{

    Single result3;

    float x = b;
    float y = a;
    float z;

    addition(&z, y, x);

    result3 = z;

    return result3;
}