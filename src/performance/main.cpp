#include "tester/tester.h"
#include "../float/single/lib/single.h"

using namespace floating;
using namespace floating::literal;

int main(void)
{
    Tester *tester = new Tester();
    tester->log = "Test ";
    tester
        ->setSameDataRepeats(1000000)
        ->setOverallRepeats(100)
        ->setTestedFn([](Tester::TestEnv testenv) {
            123_s + 1234_s;
        });

    tester->runAll();
    return 0;
}
