#include "../../catch/catch.hpp"
#include "../../../src/float/single/lib/single.h"
#include <limits>
#include <cfenv>
using namespace floating;
using namespace floating::literal;

TEST_CASE("Addition 1", "")
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
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 2", "")
{
    GIVEN("New Single objects")
    {
        Single a = 0.25_s;
        Single b = 0.003_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE((bool)(sum == 0.25f + 0.003f));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 3 - infinity", "")
{
    GIVEN("New Single objects")
    {
        Single a = Single(std::numeric_limits<float>::max());
        Single b = Single(std::numeric_limits<float>::max());
        Single inf = Single(std::numeric_limits<float>::infinity());
        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value should be infinity")
            {
                REQUIRE((bool)(sum == inf));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 4 - minus infinity", "")
{
    GIVEN("New Single objects")
    {
        Single a = -Single(std::numeric_limits<float>::max());
        Single b = -Single(std::numeric_limits<float>::max());
        Single inf = Single(std::numeric_limits<float>::infinity());
        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value should be minus infinity")
            {
                REQUIRE((bool)(sum == -inf));
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 5", "")
{
    GIVEN("New Single objects")
    {
        Single a = 0.123_s;
        Single b = 0.123_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 0.123f + 0.123f);
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 6", "")
{
    GIVEN("New Single objects")
    {
        Single a = 2137.1337_s;
        Single b = 20456.666_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 2137.1337f + 20456.666f);
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 7", "")
{
    GIVEN("New Single objects")
    {
        Single a = 21337.1337_s;
        Single b = 20456.666_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 21337.1337f + 20456.666f);
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 8", "")
{
    GIVEN("New Single objects")
    {
        Single a = 2.111_s;
        Single b = 2.666_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 4.777f);
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}

TEST_CASE("Addition 9", "")
{
    GIVEN("New Single objects")
    {
        Single a = 2_s;
        Single b = 2.1_s;

        WHEN("addition is made")
        {
            Single sum = a + b;

            THEN("value is correct with float")
            {
                REQUIRE(sum.toFloat() == 4.1f);
            }
            THEN("reverse action gives same result")
            {
                Single reverse = b + a;
                REQUIRE((bool)(b + a == sum));
            }
        }
    }
}