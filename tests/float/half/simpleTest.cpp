#include "../../catch/catch.hpp"
#include <cinttypes>
extern "C" void floatToHalf(float *, int16_t *);
extern "C" void halfToFloat(int16_t *, float *);
extern "C" void simple_add_16(int16_t *, int16_t *);
extern "C" void simple_sub_16(int16_t *, int16_t *);
extern "C" void simple_mul_16(int16_t *, int16_t *);
extern "C" void simple_div_16(int16_t *, int16_t *);
extern "C" void simple_shiftR_16(int16_t *, int8_t);
extern "C" void simple_shiftL_16(int16_t *, int8_t);
extern "C" void simple_shiftL_32(int16_t *, int8_t);

TEST_CASE("Float to Half test", "")
{
    GIVEN("Float")
    {
        float fl = 2.0f;
        int16_t raw = 0;

        WHEN("conversion is made")
        {
            floatToHalf(&fl, &raw);
            THEN("value is correct")
            {
                REQUIRE(raw == 0x4000);
            }
        }
    }

    GIVEN("Float")
    {
        float fl = 2.625f;
        int16_t raw = 0;

        WHEN("conversion is made")
        {
            floatToHalf(&fl, &raw);
            THEN("value is correct")
            {
                REQUIRE(raw == 0b0100000101000000);
            }
        }
    }
}

TEST_CASE("Half to Float test", "")
{
    GIVEN("Float")
    {
        int16_t raw = 0x4000;
        float fl = 0;

        WHEN("conversion is made")
        {
            halfToFloat(&raw, &fl);
            THEN("value is correct")
            {
                REQUIRE(fl == 2.0f);
            }
        }
    }
    GIVEN("Float")
    {
        int16_t raw = 0b0100000101000000;
        float fl = 0;

        WHEN("conversion is made")
        {
            halfToFloat(&raw, &fl);
            THEN("value is correct")
            {
                REQUIRE(fl == 2.625f);
            }
        }
    }
}

TEST_CASE("Simple add test", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 255;
        int16_t b = 255;
        WHEN("addition is made")
        {
            simple_add_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 510);
            }
        }
    }
    GIVEN("Raw uint16")
    {
        int16_t a = 510;
        int16_t b = -255;
        WHEN("addition is made")
        {
            simple_add_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 255);
            }
        }
    }
}

TEST_CASE("Simple sub test", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 255;
        int16_t b = 255;
        WHEN("subtraction is made")
        {
            simple_sub_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0);
            }
        }
    }
    GIVEN("Raw uint16")
    {
        int16_t a = 27936;
        int16_t b = 28902;
        WHEN("subtraction is made")
        {
            simple_sub_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == -966);
            }
        }
    }
    GIVEN("Raw uint16")
    {
        int16_t a = 12387;
        int16_t b = -8943;
        WHEN("subtraction is made")
        {
            simple_sub_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 21330);
            }
        }
    }
}

TEST_CASE("Simple shiftR test", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 0x00f0;
        WHEN("shift right is made")
        {
            simple_shiftR_16(&a, 4);
            THEN("value is correct")
            {
                REQUIRE(a == 0x000f);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 0xf000;
        WHEN("shift right is made")
        {
            simple_shiftR_16(&a, 8);
            THEN("value is correct")
            {
                REQUIRE(a == 0x00f0);
            }
        }
    }
}

TEST_CASE("Simple shiftL test", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 0x00f0;
        WHEN("shift right is made")
        {
            simple_shiftL_16(&a, 4);
            THEN("value is correct")
            {
                REQUIRE(a == 0x0f00);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 0xf000;
        WHEN("shift left is made")
        {
            simple_shiftL_16(&a, 8);
            THEN("value is correct")
            {
                REQUIRE(a == 0x0000);
            }
        }
    }
}

// simple_mul resturns result in a:b, 'a' is higher part
TEST_CASE("Simple mul test", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 127;
        int16_t b = 127;
        WHEN("multiplication is made")
        {
            simple_mul_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0);
                REQUIRE(b == 16129);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 1023;
        int16_t b = 1023;
        WHEN("multiplication is made")
        {
            simple_mul_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 15);
                REQUIRE((uint16_t)b == 63489);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 0x8000;
        int16_t b = 0x8000;
        WHEN("multiplication is made")
        {
            simple_mul_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0x4000);
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 0x1234;
        int16_t b = 0x1234;
        WHEN("crazy multiplication is made")
        {
            simple_mul_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0x014B);
                REQUIRE(b == 0x5A90);
            }
        }
    }
}

TEST_CASE("Simple div test", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 0b1000000000;
        int16_t b = 0b1000000000;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 1);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 0b0010010000;
        int16_t b = 0b0010010000;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 1);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 16;
        int16_t b = 5;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 3);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 1);
            }
        }
    }
    GIVEN("Raw uint16")
    {
        int16_t a = 10000;
        int16_t b = 100;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 100);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 0);
            }
        }
    }
    GIVEN("Raw uint16")
    {
        int16_t a = 123;
        int16_t b = 3;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 41);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 125;
        int16_t b = 3;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 41);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 2);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 12347;
        int16_t b = 3;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 4115);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 2);
            }
        }
    }

    GIVEN("Raw uint16")
    {
        int16_t a = 7999;
        int16_t b = 1236;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 6);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 583);
            }
        }
    }
    GIVEN("Raw uint16")
    {
        int16_t a = 126;
        int16_t b = 799;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 0);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 126);
            }
        }
    }
}
TEST_CASE("Simple div test 1", "")
{
    GIVEN("Raw uint16")
    {
        int16_t a = 125;
        int16_t b = 3;
        WHEN("division is made")
        {
            simple_div_16(&a, &b);
            THEN("quotient is correct")
            {
                REQUIRE(a == 41);
            }
            THEN("reminder is correct")
            {
                REQUIRE(b == 2);
            }
        }
    }
}