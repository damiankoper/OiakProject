#define CATCH_CONFIG_MAIN
#include "../../catch/catch.hpp"
#include "../../../src/float/half/lib/half.h"
#include <cmath>

using namespace floating;
using namespace floating::literal;
TEST_CASE("Init", "")
{
    GIVEN("New Half object")
    {
        Half half = 12.5_h;

        WHEN("sign is changed")
        {
            half = -half;

            THEN("binary representation is correct")
            {
                REQUIRE(half.printBinary() == "1 | 10010 | 1001000000");
            }

            THEN("value is correct")
            {
                Half expected = -12.5_h;
                REQUIRE((bool)(expected == half));
            }
        }
    }
}

TEST_CASE("Conversion", "")
{
    GIVEN("Half object")
    {
        Half half = 12.5_h;

        WHEN("assigned to float")
        {
            float actual = half;

            THEN("float has correct value")
            {
                float expected = 12.5;
                REQUIRE(actual == expected);
            }
        }

        WHEN("casted to float")
        {
            float actual = (float)half;

            THEN("float has correct value")
            {
                float expected = 12.5;
                REQUIRE(actual == expected);
            }
        }
    }
}