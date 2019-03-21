#pragma GCC diagnostic ignored "-Wpointer-arith"
#include "single.h"
#include <cstring>
using namespace floating;

int Single::toInt()
{
    // TODO
    return 0;
}

float Single::toFloat()
{
    float result;
    // Little endian
    memcpy(((void *)&result), &a, 1);
    memcpy(((void *)&result) + 1, &b, 1);
    memcpy(((void *)&result) + 2, &c, 1);
    memcpy(((void *)&result) + 3, &d, 1);
    return result;
}

double Single::toDouble()
{
    // TODO
    return 0;
}