#include "../../catch/catch.hpp"
#include "../../../src/float/half/lib/half.h"
#include <cfenv>

using namespace floating;
using namespace floating::literal;

TEST_CASE("Division 1", "")
{
    GIVEN("New Half objects")
    {
        Half a = 5.0_h;
        Half b = 2.0_h;

        WHEN("division is made")
        {
            Half result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == 5.0f / 2.0f);
            }
            THEN("a and b are untouched")
            {
                REQUIRE((bool)(a == 5.0_h));
                REQUIRE((bool)(b == 2.0_h));
            }
        }
    }
}

TEST_CASE("Division 2", "")
{
    GIVEN("New Half objects")
    {
        Half a = -10.25_h;
        Half b = 2.32_h;

        WHEN("division is made")
        {
            Half result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == -10.25f / 2.32f);
            }
        }
    }
}

TEST_CASE("Division 3", "")
{
    GIVEN("New Half objects")
    {
        Half a = -10.5_h;
        Half b = -6.0_h;

        WHEN("division is made")
        {
            Half result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == -10.5f / -6.0f);
            }
        }
    }
}

TEST_CASE("Division 4, when divident - 0", "")
{
    GIVEN("New Half objects")
    {
        Half a = 0.0_h;
        Half b = -6.0_h;

        WHEN("division is made")
        {
            Half result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == 0.0f / -6.0f);
            }
        }
    }
}

TEST_CASE("Division 5, when divisor - 0", "")
{
    GIVEN("New Half objects")
    {
        Half a = 25.666_h;
        Half b = 0.0_h;

        WHEN("division is made")
        {
            Half result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == 25.666f / 0.0f);
            }
        }
    }
}