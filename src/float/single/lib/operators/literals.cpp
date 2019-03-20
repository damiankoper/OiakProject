#include "../single.h"
using namespace floating::literal;
using namespace floating;

Single literal::operator""_s(long double longDouble)
{

    return Single(longDouble);
}

Single literal::operator""_s(unsigned long long uLongLong)
{
    return Single(uLongLong);
}
