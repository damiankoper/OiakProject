#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
#include <cfenv>

using namespace floating;
using namespace floating::literal;

TEST_CASE("Multiplication 1", "")
{
    GIVEN("New Single objects")
    {
        Single a = 4.5_s;
        Single b = -3.0_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value is correct")
            {
                Single expected = -13.5_s;
                REQUIRE((bool)(expected == result));
            }
            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 4.5f * -3.0f));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 2 - times 0", "")
{
    GIVEN("New Single objects")
    {
        Single a = 4.5_s;
        Single b = 0_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value should be 0")
            {
                REQUIRE((bool)(result == 0.0f));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 3 - times infinity", "")
{
    GIVEN("New Single objects")
    {
        Single a = 4.5_s;
        Single inf = Single(std::numeric_limits<float>::infinity());

        WHEN("multiplication is made")
        {
            Single result = a * inf;

            THEN("value should be infinity")
            {
                REQUIRE((bool)(result == inf));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = inf * a;
                REQUIRE((bool)(inf * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 3 - times minus infinity", "")
{
    GIVEN("New Single objects")
    {
        Single a = -4.5_s;
        Single inf = Single(std::numeric_limits<float>::infinity());

        WHEN("multiplication is made")
        {
            Single result = a * inf;

            THEN("value should be -infinity")
            {
                REQUIRE((bool)(result == -inf));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = inf * a;
                REQUIRE((bool)(inf * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 5", "")
{
    GIVEN("New Single objects")
    {
        Single a = 1.23_s;
        Single b = 1.45_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value is correct")
            {
                Single expected = 1.78350008_s;
                REQUIRE((bool)(expected == result));
            }
            THEN("value is correct with float")
            {
                REQUIRE((bool)(result == 1.23f * 1.45f));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 6", "")
{
    GIVEN("New Single objects")
    {
        Single a = 11111.11_s;
        Single b = 22222.22_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value is correct")
            {
                Single expected = 246913530.8642_s;
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
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}

TEST_CASE("Multiplication 7", "")
{
    GIVEN("New Single objects")
    {
        Single a = 0.445621_s;
        Single b = -2.34576_s;

        WHEN("multiplication is made")
        {
            Single result = a * b;

            THEN("value is correct with float")
            {
                int roundingMode = std::fegetround();
                std::fesetround(FE_TOWARDZERO); // Tu faktycznie widać zaokrąglanie
                REQUIRE(result.toFloat() == a.toFloat() * b.toFloat());
                std::fesetround(roundingMode);
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b * a;
                REQUIRE((bool)(b * a == result));
            }
        }
    }
}