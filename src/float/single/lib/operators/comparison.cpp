#include "../single.h"
using namespace floating;

bool Single::operator==(const Single &s)
{
    return data.raw == s.data.raw;
}

bool Single::operator==(const float &f)
{
    return data.f == f;
}
