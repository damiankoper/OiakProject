#include "../../catch/catch.hpp"
#include <cinttypes>
#include <iostream>

extern "C" void simple_add_32(int32_t *, int32_t *);
extern "C" void simple_sub_32(int32_t *, int32_t *);
extern "C" void simple_mul_32(int32_t *, int32_t *);
extern "C" void simple_div_32(int32_t *, int32_t *);
extern "C" void simple_shiftR_32(int32_t *, int8_t);
extern "C" void simple_shiftL_32(int32_t *, int8_t);
extern "C" void simple_shiftL_64(int32_t *, int8_t);

TEST_CASE("Simple add test", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 255;
        int32_t b = 255;
        WHEN("addition is made")
        {
            simple_add_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 510);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 510;
        int32_t b = -255;
        WHEN("addition is made")
        {
            simple_add_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 255);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 4562;
        int32_t b = -204389;
        WHEN("addition is made")
        {
            simple_add_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == -199827);
            }
        }
    }
}

TEST_CASE("Simple sub test", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 255;
        int32_t b = 255;
        WHEN("subtraction is made")
        {
            simple_sub_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 678432;
        int32_t b = 78843;
        WHEN("subtraction is made")
        {
            simple_sub_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 599589);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 12387;
        int32_t b = -8943;
        WHEN("subtraction is made")
        {
            simple_sub_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 21330);
            }
        }
    }
}

TEST_CASE("Simple shiftR test", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 0x000000f0;
        WHEN("shift right is made")
        {
            simple_shiftR_32(&a, 4);
            THEN("value is correct")
            {
                REQUIRE(a == 0x0000000f);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 0xf0000000;
        WHEN("shift right is made")
        {
            simple_shiftR_32(&a, 8);
            THEN("value is correct")
            {
                REQUIRE(a == 0x00f00000);
            }
        }
    }
}

TEST_CASE("Simple shiftL test", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 0x000000f0;
        WHEN("shift right is made")
        {
            simple_shiftL_32(&a, 4);
            THEN("value is correct")
            {
                REQUIRE(a == 0x00000f00);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 0xf0000000;
        WHEN("shift left is made")
        {
            simple_shiftL_32(&a, 8);
            THEN("value is correct")
            {
                REQUIRE(a == 0x00000000);
            }
        }
    }
}

// simple_mul_32 resturns result in a:b, 'a' is higher part
TEST_CASE("Simple mul test", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 255;
        int32_t b = 255;
        WHEN("multiplication is made")
        {
            simple_mul_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0);
                REQUIRE(b == 65025);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 1023;
        int32_t b = 1023;
        WHEN("multiplication is made")
        {
            simple_mul_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0);
                REQUIRE(b == 1046529);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 0x80000;
        int32_t b = 0x80000;
        WHEN("multiplication is made")
        {
            simple_mul_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0x40);
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 0x1234567;
        int32_t b = 0x1234567;
        WHEN("crazy multiplication is made")
        {
            simple_mul_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0x14B66);
                REQUIRE(b == 0xDAFAAF71);
            }
        }
    }
}

TEST_CASE("Simple div test", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 0b100000000000000000000000;
        int32_t b = 0b100000000000000000000000;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 1);
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 0b000000000000000010010000;
        int32_t b = 0b000000000000000010010000;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 1);
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 16;
        int32_t b = 5;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 3);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 1);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 100000000;
        int32_t b = 100;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 1000000);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 0);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 123;
        int32_t b = 3;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 41);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 0);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 125;
        int32_t b = 3;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 41);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 2);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 123457;
        int32_t b = 3;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 41152);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 1);
            }
        }
    }

    GIVEN("Raw uint32")
    {
        int32_t a = 7999999;
        int32_t b = 123456;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 64);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 98815);
            }
        }
    }
    GIVEN("Raw uint32")
    {
        int32_t a = 123456;
        int32_t b = 7999999;
        WHEN("division is made")
        {
            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 0);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 123456);
            }
        }
    }
}
TEST_CASE("Simple div test 1", "")
{
    GIVEN("Raw uint32")
    {
        int32_t a = 125;
        int32_t b = 3;
        WHEN("division is made")
        {

            simple_div_32(&a, &b);
            THEN("value is correct")
            {
                REQUIRE(a == 41);
            }
            THEN("value is correct")
            {
                REQUIRE(b == 2);
            }
        }
    }
}