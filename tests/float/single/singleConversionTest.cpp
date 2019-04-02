#define CATCH_CONFIG_MAIN
#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
using namespace floating;
using namespace floating::literal;
TEST_CASE("Single init test", "")
{
    GIVEN("New Single object")
    {
        Single single = 12.5_s;

        WHEN("sign is changed")
        {
            single = -single;

            THEN("binary representation is correct")
            {
                REQUIRE(single.printBinary() == "1 | 10000010 | 10010000000000000000000");
            }

            THEN("value is correct")
            {
                Single expected = -12.5_s;
                REQUIRE((bool)(expected == single));
            }
        }
    }
}

TEST_CASE("Single conversion test", "")
{
    GIVEN("Single object")
    {
        Single single = 12.5_s;

        WHEN("assigned to float")
        {
            float actual = single;

            THEN("float has correct value")
            {
                float expected = 12.5;
                REQUIRE(actual == expected);
            }
        }

        WHEN("casted to float")
        {
            float actual = (float)single;

            THEN("float has correct value")
            {
                float expected = 12.5;
                REQUIRE(actual == expected);
            }
        }
    }
}

TEST_CASE("Single addition test", "")
{
    GIVEN("New Single objects")
    {
        Single a = 3.0_s;
        Single b = -4.5_s;
        Single sum;

        WHEN("addition is made")
        {
            sum = sum.uglyAddition(a, b);

            THEN("value is correct")
            {
                Single expected = -1.5_s;
                REQUIRE((bool)(expected == sum));
            }
        }
    }
}
