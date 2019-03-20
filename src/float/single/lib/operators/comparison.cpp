#include "../single.h"
using namespace floating;

bool Single::operator==(const Single &s)
{
    return s.a == a && s.b == b && s.c == c && s.d == d;
}
