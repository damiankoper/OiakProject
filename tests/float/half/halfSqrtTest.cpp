#include "../../catch/catch.hpp"
#include "../../../src/float/half/lib/half.h"
#include <cfenv>

using namespace floating;
using namespace floating::literal;

TEST_CASE("Square root 1", "")
{
    GIVEN("New Half objects")
    {
        Half a = 2.0_h;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Half expected = 1.41421356f;
                REQUIRE((bool)(expected == a));
            }

            // TODO: rounding mode
            THEN("value is correct with float")
            {
                float expected = std::sqrt(2);
                REQUIRE((bool)(a == expected));
            }
        }
    }
}

TEST_CASE("Square root 2", "")
{
    GIVEN("New Half objects")
    {
        Half a = 6.0_h;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Half expected = 2.44948959f;
                REQUIRE((bool)(expected == a));
            }
        }
    }
}

TEST_CASE("Square root 3", "")
{
    GIVEN("New Half objects")
    {
        Half a = 9.0_h;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Half expected = 3.0_h;
                REQUIRE((bool)(expected == a));
            }

            // TODO: rounding mode
            THEN("value is correct with float")
            {
                float expected = std::sqrt(9);
                REQUIRE((bool)(a == expected));
            }
        }
    }
}
