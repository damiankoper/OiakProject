#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <cinttypes>
using namespace floating;

extern "C" void addition(float *, float, float);
extern "C" void multiply(float *, float, float);
extern "C" void subtraction(float *, float, float);
extern "C" void squareroot(float *, float);

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

Single Single::singleAddition(Single a, Single b)
{

    Single result3;

    float x = b;
    float y = a;
    float z;

    addition(&z, y, x);

    result3 = z;

    return result3;
}

Single Single::singleSubtraction(Single a, Single b)
{

    Single result3;

    float x = a;
    float y = b;
    float z;

    subtraction(&z, y, x);

    result3 = z;

    return result3;
}

Single Single::singleMultiplication(Single a, Single b)
{

    Single result3;

    float x = b;
    float y = a;
    float z;

    multiply(&z, y, x);

    result3 = z;

    return result3;
}

Single Single::squareRoot()
{
    Single result = Single(*this);
    float x = result;
    float z;
    squareroot(&z, x);
    result = z;
    return result;
}