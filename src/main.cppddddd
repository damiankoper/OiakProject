#include <iostream>
#include "float/single/lib/single.h"
extern "C" void single_abs(float *, float);
extern "C" void single_multiply(float *, float, float);
using namespace floating;
using namespace floating::literal;
int main()
{
	Single s = -12.5_s; // works as -(12.5_s)
	s = s.abs();
	s.printBinary();

	/* float a = -42.18;
	float b = 1.5f;
	float y;
	single_abs(&y, a);
	std::cout << "abs(" << a << ") = " << y << std::endl;

	a = -2.f;
	single_multiply(&y, a, b);
	std::cout << a << " * " << b << " = " << y << std::endl; */
}
