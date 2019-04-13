#include "../half.h"
using namespace floating::literal;
using namespace floating;

Half literal::operator""_h(long double longDouble)
{

    return Half(longDouble);
}

Half literal::operator""_h(unsigned long long uLongLong)
{
    return Half(uLongLong);
}
