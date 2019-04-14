#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
#include <cfenv>

using namespace floating;
using namespace floating::literal;

TEST_CASE("Division 1", "")
{
    GIVEN("New Single objects")
    {
        Single a = 5.0_s;
        Single b = 2.0_s;

        WHEN("division is made")
        {
            Single result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 5.0f / 2.0f));
            }
        }
    }
}

TEST_CASE("Division 2", "")
{
    GIVEN("New Single objects")
    {
        Single a = -10.5_s;
        Single b = -6.0_s;

        WHEN("division is made")
        {
            Single result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == -10.5f / -6.0f));
            }
        }
    }
}

TEST_CASE("Division 3, when divident - 0", "")
{
    GIVEN("New Single objects")
    {
        Single a = 0.0_s;
        Single b = -6.0_s;

        WHEN("division is made")
        {
            Single result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 0.0f / -6.0f));
            }
        }
    }
}

TEST_CASE("Division 4, when divisor - 0", "")
{
    GIVEN("New Single objects")
    {
        Single a = 25.666_s;
        Single b = 0.0_s;

        WHEN("division is made")
        {
            Single result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 25.666f / 0.0f));
            }
        }
    }
}

TEST_CASE("Division 5", "")
{
    GIVEN("New Single objects")
    {
        Single a = -3.447_s;
        Single b = 1.2543_s;

        WHEN("division is made")
        {
            Single result = a / b;

            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == -3.447f / 1.2543f);
            }
        }
    }
}