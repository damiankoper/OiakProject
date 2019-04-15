#include "../../catch/catch.hpp"
#include "../../../src/float/half/lib/half.h"
#include <cfenv>

using namespace floating;
using namespace floating::literal;

TEST_CASE("Multiplication 1", "")
{
    GIVEN("New Half objects")
    {
        Half a = 4.5_h;
        Half b = -3.0_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;

            THEN("value is correct")
            {
                Half expected = -13.5_h;
                REQUIRE((bool)(expected == result));
            }
            THEN("value is correct with float")
            {
                REQUIRE(result.toFloat() == 4.5f * -3.0f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 2 - times 0", "")
{
    GIVEN("New Half objects")
    {
        Half a = 4.5_h;
        Half b = 0_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;

            THEN("value should be 0")
            {
                REQUIRE(result.toFloat() == 0.0f);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 3 - times infinity", "")
{
    GIVEN("New Half objects")
    {
        Half a = 4.5_h;
        Half inf = Half(std::numeric_limits<float>::infinity());

        WHEN("multiplication is made")
        {
            Half result = a * inf;

            THEN("value should be infinity")
            {
                REQUIRE((bool)(result == inf));
            }
            THEN("reverse action gives same result")
            {
                Half reverse = inf * a;
                REQUIRE((bool)(inf * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 3 - times minus infinity", "")
{
    GIVEN("New Half objects")
    {
        Half a = -4.5_h;
        Half inf = Half(std::numeric_limits<float>::infinity());

        WHEN("multiplication is made")
        {
            Half result = a * inf;

            THEN("value should be -infinity")
            {
                REQUIRE((bool)(result == -inf));
            }
            THEN("reverse action gives same result")
            {
                Half reverse = inf * a;
                REQUIRE((bool)(inf * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 5", "")
{
    GIVEN("New Half objects")
    {
        Half a = 1.22_h;
        Half b = 1.45_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;
            Half expected = 1.768_h;

            THEN("value is correct")
            {
                REQUIRE((bool)(expected == result));
            }
            THEN("binary representation is correct")
            {
                REQUIRE(result.printBinary() == expected.printBinary());
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 6", "")
{
    GIVEN("New Half objects")
    {
        Half a = 111.11_h;
        Half b = 222.22_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;
            Half expected = 24660_h;

            THEN("value is correct")
            {
                REQUIRE((bool)(expected == result));
            }
            THEN("binary representation is correct")
            {

                REQUIRE(result.printBinary() == expected.printBinary());
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 7", "")
{
    GIVEN("New Half objects")
    {
        Half a = 0.4456_h;
        Half b = -2.346_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;
            Half expected = -1.045_h;
            THEN("value is correct with float")
            {
                REQUIRE(result.printBinary() == expected.printBinary());
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}
