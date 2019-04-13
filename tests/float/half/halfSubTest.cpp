#include "../../catch/catch.hpp"
#include "../../../src/float/half/lib/half.h"
using namespace floating;
using namespace floating::literal;

/**
 * Subtraction is basically addition with changed sign, no more tests required 
 */

TEST_CASE("Subtraction 1", "")
{
    GIVEN("New Half objects")
    {
        Half a = -5.0_h;
        Half b = 3.0_h;

        WHEN("subtraction is made")
        {
            Half result = b.subtract(a);

            THEN("value is correct")
            {
                Half expected = -8.0_h;
                REQUIRE((bool)(expected == result));
            }

            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == -8.0f));
            }
        }
    }
}