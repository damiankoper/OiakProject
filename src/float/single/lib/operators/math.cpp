#include "../single.h"
using namespace floating;

Single Single::operator-()
{
    return changeSign();
}

Single Single::operator+(const Single &s)
{
    return add(s);
}

Single Single::operator-(const Single &s)
{
    return subtract(s);
}

Single Single::operator*(const Single &s)
{
    return multiply(s);
}

Single Single::operator/(const Single &s)
{
    return divideBy(s);
}