#include "single.h"
#include <iostream>
#include <bitset>
#include <cstring>
#include <cinttypes>
using namespace floating;

Single Single::abs()
{
    Single result = Single(*this);
    // Set number's 1st bit
    // dddd dddd AND 0111 1111
    result.d &= 0x7f;
    return result;
}

Single Single::changeSign()
{
    Single result = Single(*this);
    // Toggle number's 1st bit
    // dddd dddd XOR 1000 0000
    result.d ^= 0x80;
    return result;
}

Single Single::uglyAddition()
{
    Single result = Single(*this);

    Single result2 = Single(*this);

    uint8_t exponent = result.d;

    uint8_t exponent2 = result2.d;

    if (result.c >= 128)
    {

        exponent = (exponent << 1) + 1;
    }
    else
    {
        exponent = exponent << 1;
    }

    if (result2.c >= 128)
    {
        exponent2 = (exponent2 << 1) + 1;
    }
    else
    {
        exponent2 = exponent2 << 1;
    }

    uint8_t shifts = 0;

    if (exponent > exponent2)
    {

        while (exponent != exponent2)
        {

            exponent2 += 1;
            shifts++;
        }
    }
    else
    {

        while (exponent2 > exponent)
        {

            exponent += 1;
            shifts++;
        }
    }

    bool carry = false;

    uint8_t A = result.a, B = result.b;
    uint8_t C = (result.c << 1);
    C = C >> 1;
    C += 128;

    shift_right(&A, &B, &C, result.c, result.b, result.a);

    while (shifts > 0)
    {

        /* if (C % 2 != 0)
        {

            C = (C >> 1);

            carry = true;
        }
        else
        {
            C = (C >> 1);

            carry = false;
        }

        if (B % 2 != 0)
        {
            if (carry == 1)
            {

                B = (B >> 1) + 128;
            }
            else
            {

                B = (B >> 1);
            }

            carry = true;
        }
        else
        {
            if (carry == 1)
            {

                B = (B >> 1) + 128;
            }
            else
            {

                B = (B >> 1);
            }

            carry = false;
        }

        if (A % 2 != 0)
        {
            if (carry == 1)
            {

                A = (A >> 1) + 128;
            }
            else
            {

                A = (A >> 1);
            }

            carry = true;
        }
        else
        {
            if (carry == 1)
            {

                A = (A >> 1) + 128;
            }
            else
            {

                A = (A >> 1);
            }

            carry = false;
        }
        carry = false;
        shifts--;
        */

        shift_right(&result.c, &result.b, &result.a, result.c, result.b, result.a);
    }

    uint8_t A_2 = result2.a, B_2 = result2.b;

    uint8_t C_2 = (result2.c << 1);
    C_2 = (C_2 >> 1) + 128;

    uint8_t wynik_a = 0, wynik_b = 0, wynik_c = 0, wynik_d = 0;

    wynik_a = A + A_2;

    if (A + A_2 >= 255)
    {
        carry = true;
    }
    else
    {
        carry = false;
    }

    if (carry == 1)
    {

        if (B + B_2 >= 255)
        {
            wynik_b = B + B_2 + 1;
            carry = true;
        }
        else
        {
            wynik_b = B + B_2 + 1;
            carry = false;
        }
    }
    else
    {

        if (B + B_2 >= 255)
        {
            wynik_b = B + B_2;
            carry = true;
        }
        else
        {
            wynik_b = B + B_2;
            carry = false;
        }
    }

    if (carry == 1)
    {

        if (C + C_2 >= 255)
        {
            wynik_c = C + C_2 + 1;
            carry = true;
        }
        else
        {
            wynik_c = C + C_2 + 1;
            carry = false;
        }
    }
    else
    {

        if (C + C_2 >= 255)
        {
            wynik_c = C + C_2;
            carry = true;
        }
        else
        {
            wynik_c = C + C_2;
            carry = false;
        }
    }

    //przesuniecie :(

    if (carry == 1)
    {
        exponent += 1;

        if (wynik_c % 2 != 0)
        {

            wynik_c = (wynik_c >> 1);

            carry = true;
        }
        else
        {
            wynik_c = (wynik_c >> 1);

            carry = false;
        }

        if (exponent % 2 != 0)
        {
            wynik_c += 128;
        }

        if (wynik_b % 2 != 0)
        {
            if (carry == 1)
            {

                wynik_b = (wynik_b >> 1) + 128;
            }
            else
            {

                wynik_b = (wynik_b >> 1);
            }

            carry = true;
        }
        else
        {
            if (carry == 1)
            {

                wynik_b = (wynik_b >> 1) + 128;
            }
            else
            {

                wynik_b = (wynik_b >> 1);
            }

            carry = false;
        }

        if (wynik_a % 2 != 0)
        {
            if (carry == 1)
            {

                wynik_a = (wynik_a >> 1) + 128;
            }
            else
            {

                wynik_a = (wynik_a >> 1);
            }

            carry = true;
        }
        else
        {
            if (carry == 1)
            {

                wynik_a = (wynik_a >> 1) + 128;
            }
            else
            {

                wynik_a = (wynik_a >> 1);
            }

            carry = false;
        }
        carry = false;
    }

    result.a = wynik_a;
    result.b = wynik_b;

    result.c = wynik_c;

    //tylko dodatnie. potem ujemne :(

    wynik_d = exponent >> 1;

    result.d = wynik_d;

    return result;
}