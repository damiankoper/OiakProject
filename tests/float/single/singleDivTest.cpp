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
        Single a = -10.25_s;
        Single b = 2.32_s;

        WHEN("division is made")
        {
            Single result = a / b;

            THEN("value is correct with float")
            {
                int roundingMode = std::fegetround();
                std::fesetround(FE_TOWARDZERO);
                REQUIRE(result.toFloat() == -10.25f / 2.32f);
                std::fesetround(roundingMode);
            }
        }
    }
}

TEST_CASE("Division 3", "")
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

TEST_CASE("Division 4, Gdy dzielna - 0", "")
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

TEST_CASE("Division 5, Gdy dzielnik - 0", "")
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