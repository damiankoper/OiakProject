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
                REQUIRE((bool)(result == 4.5f * -3.0f));
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
                REQUIRE((bool)(result == 0.0f));
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
        Half a = 1.23_h;
        Half b = 1.45_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;

            THEN("value is correct")
            {
                Half expected = 1.78350008_h;
                REQUIRE((bool)(expected == result));
            }
            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 1.23f * 1.45f));
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
        Half a = 11111.11_h;
        Half b = 22222.22_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;

            THEN("value is correct")
            {
                Half expected = 246913530.8642_h;
                REQUIRE((bool)(expected == result));
            }
            THEN("value is correct with float")
            {
                int roundingMode = std::fegetround();
                std::fesetround(FE_TOWARDZERO); // Tu faktycznie widać zaokrąglanie
                REQUIRE(result.toFloat() == a.toFloat() * b.toFloat());
                std::fesetround(roundingMode);
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
        Half a = 0.445621_h;
        Half b = -2.34576_h;

        WHEN("multiplication is made")
        {
            Half result = a * b;

            THEN("value is correct with float")
            {
                int roundingMode = std::fegetround();
                std::fesetround(FE_TOWARDZERO); // Tu faktycznie widać zaokrąglanie
                REQUIRE(result.toFloat() == a.toFloat() * b.toFloat());
                std::fesetround(roundingMode);
            }
            THEN("reverse action gives same result")
            {
                Half reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}
