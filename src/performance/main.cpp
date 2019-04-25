#include <sys/resource.h>
#include "single/tests.h"
#include "half/tests.h"
#include "floating/tests.h"
int main(void)
{
    setpriority(PRIO_PROCESS, PRIO_PROCESS, -20);

    floatingTests::_float::testAdd();
    floatingTests::_float::testMul();
    floatingTests::_float::testDiv();
    floatingTests::_float::testSqrt();

    floatingTests::single::testAdd();
    floatingTests::single::testMul();

    floatingTests::single::testDiv();
    floatingTests::single::testSqrt();

    floatingTests::half::testAdd();
    floatingTests::half::testMul();
    floatingTests::half::testDiv();
    floatingTests::half::testSqrt();

    return 0;
}
