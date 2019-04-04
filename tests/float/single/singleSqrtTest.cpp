#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
using namespace floating;
using namespace floating::literal;

TEST_CASE("Square root 1", "")
{
    GIVEN("New Single objects")
    {
        Single a = 5.0_s;
        WHEN("square root is made")
        {
            a = a.sqrt();

            THEN("value is correct more or less")
            {
                Single expected = 2.23606777f;
                REQUIRE((bool)(expected == a));
            }

            // TODO: rounding mode
            /* THEN("value is correct with float")
            {
                float expected = std::sqrt(5);
                REQUIRE((bool)(a == expected));
            } */
        }
    }
}