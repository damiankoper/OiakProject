#include "../half.h"
using namespace floating;

Half::operator int()
{
    return toInt();
}

Half::operator float()
{
    return toFloat();
}

Half::operator double()
{
    return toDouble();
}
