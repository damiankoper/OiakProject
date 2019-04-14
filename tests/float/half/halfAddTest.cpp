#include "../../catch/catch.hpp"
#include "../../../src/float/half/lib/half.h"
#include <limits>
#include <cfenv>
using namespace floating;
using namespace floating::literal;

TEST_CASE("Addition 1", "")
{
    GIVEN("New Half objects")
    {
        Half a = 3.0_h;
        Half b = -4.5_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct")
            {
                Half expected = -1.5_h;
                REQUIRE((bool)(expected == sum));
            }
            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == -1.5f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 2", "")
{
    GIVEN("New Half objects")
    {
        Half a = 0.25_h;
        Half b = 0.003_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 0.25f + 0.003f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 3 - infinity", "")
{
    GIVEN("New Half objects")
    {
        Half a = Half(std::numeric_limits<float>::max());
        Half b = Half(std::numeric_limits<float>::max());
        Half inf = Half(std::numeric_limits<float>::infinity());
        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value should be infinity")
            {
                REQUIRE((bool)(sum == inf));
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 4 - minus infinity", "")
{
    GIVEN("New Half objects")
    {
        Half a = -Half(std::numeric_limits<float>::max());
        Half b = -Half(std::numeric_limits<float>::max());
        Half inf = Half(std::numeric_limits<float>::infinity());
        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value should be minus infinity")
            {
                REQUIRE((bool)(sum == -inf));
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 5", "")
{
    GIVEN("New Half objects")
    {
        Half a = 0.123_h;
        Half b = 0.123_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 0.123f + 0.123f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 6", "")
{
    GIVEN("New Half objects")
    {
        Half a = 2137.1337_h;
        Half b = 20456.666_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 22593.7997f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 7", "")
{
    GIVEN("New Half objects")
    {
        Half a = 21337.1337_h;
        Half b = 20456.666_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 21337.1337f + 20456.666f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 8", "")
{
    GIVEN("New Half objects")
    {
        Half a = 2.111_h;
        Half b = 2.666_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 4.777f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 9", "")
{
    GIVEN("New Half objects")
    {
        Half a = 2_h;
        Half b = 2.1_h;

        WHEN("addition is made")
        {
            Half sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 4.1f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}