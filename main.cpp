#include <iostream>
extern "C" void my_abs_f(float*, float);
extern "C" void my_mul_f(float*, float, float);

int main()
{
	float a = -42.18;
	float b = 1.5f;
	float y;
	my_abs_f(&y, a);
	std::cout << "abs(" << a << ") = " << y << std::endl;

	a = -2.f;
	my_mul_f(&y, a, b);
	std::cout << a << " * " << b << " = " << y << std::endl;
}
