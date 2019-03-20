#include "../single.h"
using namespace floating;

Single::operator int()
{
    return toInt();
}

Single::operator float()
{
    return toFloat();
}

Single::operator double()
{
    return toDouble();
}
