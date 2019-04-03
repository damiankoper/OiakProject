#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
using namespace floating;
using namespace floating::literal;

TEST_CASE("Single addition test", "")
{
    GIVEN("New Single objects")
    {
        Single a = 3.0_s;
        Single b = -4.5_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct")
            {
                Single expected = -1.5_s;
                REQUIRE((bool)(expected == sum));
            }

            THEN("value is correct with float")
            {
                REQUIRE((bool)(sum == -1.5f));
            }

            // TODO: fix
            /* THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            } */
        }
    }
}