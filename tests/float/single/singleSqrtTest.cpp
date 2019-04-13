#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
#include <cfenv>

using namespace floating;
using namespace floating::literal;

TEST_CASE("Square root 1", "")
{
    GIVEN("New Single objects")
    {
        Single a = 2.0_s;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Single expected = 1.41421356f;
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
    GIVEN("New Single objects")
    {
        Single a = 6.0_s;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Single expected = 2.44948959f;
                REQUIRE((bool)(expected == a));
            }
        }
    }
}

TEST_CASE("Square root 3", "")
{
    GIVEN("New Single objects")
    {
        Single a = 9.0_s;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Single expected = 3.0f;
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
