#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <cinttypes>
using namespace floating;

extern "C" void single_add(uint32_t *, uint32_t, uint32_t);
extern "C" void single_mul(uint32_t *, uint32_t, uint32_t);
extern "C" void single_sub(uint32_t *, uint32_t, uint32_t);
extern "C" void single_squareRoot(uint32_t *, uint32_t);

Single Single::abs()
{
    Single result = Single(*this);
    // Set number's 1st bit
    // dddd dddd AND 0111 1111
    result.data.bytes[0] &= 0x7f;
    return result;
}

Single Single::changeSign()
{
    Single result = Single(*this);
    // Toggle number's 1st bit
    // dddd dddd XOR 1000 0000
    result.data.bytes[0] ^= 0x80;
    return result;
}

Single Single::add(Single component)
{

    Single result = Single();
    single_add(&result.data.raw, data.raw, component.data.raw);
    return result;
}

Single Single::multiply(Single multiplier)
{

    Single result = Single();
    single_mul(&result.data.raw, data.raw, multiplier.data.raw);
    return result;
}

Single Single::subtract(Single subtrahend)
{
    Single result = Single();
    single_sub(&result.data.raw, data.raw, subtrahend.data.raw);
    return result;
}

Single Single::sqrt()
{
    Single result = Single();
    single_squareRoot(&result.data.raw, data.raw);
    return result;
}