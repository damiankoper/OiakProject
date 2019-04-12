#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
using namespace floating;
using namespace floating::literal;

TEST_CASE("Subtraction 1", "")
{
    GIVEN("New Single objects")
    {
        Single a = -5.0_s;
        Single b = 3.0_s;

        WHEN("subtraction is made")
        {
            Single result = b.subtract(a);

            THEN("value is correct")
            {
                Single expected = -8.0_s;
                REQUIRE((bool)(expected == result));
            }

            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == -8.0f));
            }
        }
    }
}