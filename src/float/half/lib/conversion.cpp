#pragma GCC diagnostic ignored "-Wpointer-arith"
#include "half.h"
#include <cstring>
using namespace floating;

extern "C" void halfToFloat(uint16_t *, float *);

int Half::toInt()
{
    return (int)toFloat();
}

float Half::toFloat()
{
    float f;
    halfToFloat(&data.raw, &f);
    return f;
}

double Half::toDouble()
{
    return (double)toFloat();
}
