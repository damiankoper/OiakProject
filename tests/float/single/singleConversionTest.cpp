#define CATCH_CONFIG_MAIN
#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
using namespace floating;
using namespace floating::literal;
TEST_CASE("Single init test", "")
{
    GIVEN("New Single object")
    {
        Single single = 12.5_s;

        WHEN("sign is changed")
        {
            single = -single;

            THEN("binary representation is correct")
            {
                REQUIRE(single.printBinary() == "1 | 10000010 | 10010000000000000000000");
            }

            THEN("value is correct")
            {
                Single comp = -12.5_s;
                REQUIRE((bool)(comp == single));
            }
        }
    }
}