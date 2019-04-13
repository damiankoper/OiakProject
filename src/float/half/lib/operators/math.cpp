#include "../half.h"
using namespace floating;

Half Half::operator-()
{
    return changeSign();
}

Half Half::operator+(const Half &s)
{
    return add(s);
}

Half Half::operator-(const Half &s)
{
    return subtract(s);
}

Half Half::operator*(const Half &s)
{
    return multiply(s);
}

Half Half::operator/(const Half &s)
{
    return divideBy(s);
}