#include "single.h"
#include <iostream>
#include <bitset>
#include <string>
#include <cinttypes>
using namespace floating;

std::string Single::printBinary()
{
    return std::bitset<8>(data.bytes[0]).to_string().substr(0, 1) + " | " + std::bitset<8>(data.bytes[0]).to_string().substr(1, 7) + std::bitset<8>(data.bytes[1]).to_string().substr(0, 1) + " | " + std::bitset<8>(data.bytes[1]).to_string().substr(1, 7) + std::bitset<8>(data.bytes[2]).to_string() + std::bitset<8>(data.bytes[3]).to_string();
}
