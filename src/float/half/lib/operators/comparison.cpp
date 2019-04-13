#include "../half.h"
using namespace floating;
extern "C" void floatToHalf(const float *, int16_t *);

bool Half::operator==(const Half &s)
{
    return data.raw == s.data.raw;
}

bool Half::operator==(const float &f)
{
    int16_t raw;
    floatToHalf(&f, &raw);
    return data.raw == raw;
}
