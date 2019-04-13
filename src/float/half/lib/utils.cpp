#include "half.h"
#include <iostream>
#include <bitset>
#include <string>
#include <cinttypes>
using namespace floating;

std::string Half::printBinary()
{
    return std::bitset<8>(data.bytes[1]).to_string().substr(0, 1) + " | " + std::bitset<8>(data.bytes[1]).to_string().substr(1, 5) + " | " + std::bitset<8>(data.bytes[1]).to_string().substr(6, 8) + std::bitset<8>(data.bytes[0]).to_string();
}
