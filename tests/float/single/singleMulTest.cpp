#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
using namespace floating;
using namespace floating::literal;

TEST_CASE("Multiplication 1", "")
{
    GIVEN("New Single objects")
    {
        Single a = 4.5_s;
        Single b = -3.0_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value is correct")
            {
                Single expected = -13.5_s;
                REQUIRE((bool)(expected == result));
            }
            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 4.5f * -3.0f));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 2 - times 0", "")
{
    GIVEN("New Single objects")
    {
        Single a = 4.5_s;
        Single b = 0_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value should be 0")
            {
                REQUIRE((bool)(result == 0.0f));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}