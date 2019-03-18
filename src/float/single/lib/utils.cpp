#include "single.h"
#include <iostream>
#include <bitset>
#include <string>
#include <cinttypes>
using namespace floating;

std::string Single::printBinary()
{
    return std::bitset<8>(d).to_string().substr(0, 1) + " | " + std::bitset<8>(d).to_string().substr(1, 7) + std::bitset<8>(c).to_string().substr(0, 1) + " | " + std::bitset<8>(c).to_string().substr(1, 7) + std::bitset<8>(b).to_string() + std::bitset<8>(a).to_string();
}
