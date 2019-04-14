#include "half.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <cinttypes>
using namespace floating;

extern "C" void half_add(uint16_t *, uint16_t, uint16_t);
extern "C" void half_mul(uint16_t *, uint16_t, uint16_t);
extern "C" void half_hub(uint16_t *, uint16_t, uint16_t);
extern "C" void half_sqrt(uint16_t *, uint16_t);
extern "C" void half_div(uint16_t *, uint16_t, uint16_t);

Half Half::abs()
{
    Half result = Half(*this);
    // Set number's 1st bit
    // bbbb bbbb AND 0111 1111
    result.data.bytes[1] &= 0x7f;
    return result;
}

Half Half::changeSign()
{
    Half result = Half(*this);
    // Toggle number's 1st bit
    // bbbb bbbb XOR 1000 0000
    result.data.bytes[1] ^= 0x80;
    return result;
}

Half Half::add(Half component)
{

    Half result = Half();
    half_add(&result.data.raw, data.raw, component.data.raw);
    return result;
}

Half Half::subtract(Half subtrahend)
{
    Half result = Half();
    half_add(&result.data.raw, changeSign().data.raw, subtrahend.data.raw);
    return result;
}

Half Half::multiply(Half multiplier)
{

    Half result = Half();
    half_mul(&result.data.raw, data.raw, multiplier.data.raw);
    return result;
}

Half Half::divideBy(Half divisor)
{
    Half result = Half();
    half_div(&result.data.raw, data.raw, divisor.data.raw);
    return result;
}

Half Half::sqrt()
{
    Half result = Half();
    half_sqrt(&result.data.raw, data.raw);
    return result;
}
