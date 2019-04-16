#include "../tester/tester.h"
#include "../../float/half/lib/half.h"
#include "../tester/utils.h"
#include "tests.h"
#include <vector>
#include <limits>
#include <string>

using namespace std;
using namespace floating;
using namespace floatingTests;

std::string pathHalf = "src/performance/results/half";

void half::testAdd()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    Half h1, h2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test half addition: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(10000)
        ->beforeSameDataSet([&i, &j, &h1, &h2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            h1 = linspace1[i];
            h2 = linspace1[j];
            testenv.activeElements = h1.printBinary();
            testenv.startElements = h2.printBinary();
        })
        ->setTestedFn([&h1, &h2](Tester::TestEnv testenv) {
            Half h = h1 + h2;
        });
    tester->runAll();
    tester->writeLastToFile(pathHalf + "/halfAdd.txt");
}

void half::testMul()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    Half h1, h2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test half multiplication: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(10000)
        ->beforeSameDataSet([&i, &j, &h1, &h2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            h1 = linspace1[i];
            h2 = linspace1[j];
            testenv.activeElements = h1.printBinary();
            testenv.startElements = h2.printBinary();
        })
        ->setTestedFn([&h1, &h2](Tester::TestEnv testenv) {
            Half h = h1 * h2;
        });
    tester->runAll();
    tester->writeLastToFile(pathHalf + "/halfMul.txt");
}

void half::testDiv()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    Half h1, h2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test half division: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(10000)
        ->beforeSameDataSet([&i, &j, &h1, &h2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            h1 = linspace1[i];
            h2 = linspace1[j];
            testenv.activeElements = h1.printBinary();
            testenv.startElements = h2.printBinary();
        })
        ->setTestedFn([&h1, &h2](Tester::TestEnv testenv) {
            Half h = h1 / h2;
        });
    tester->runAll();
    tester->writeLastToFile(pathHalf + "/halfDiv.txt");
}

void half::testSqrt()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(0., 101000., 100);

    Half h1;
    int i = -1;
    Tester *tester = new Tester("Test half sqrt: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(100)
        ->beforeSameDataSet([&i, &h1, linspace1](Tester::TestEnv &testenv) {
            i++;
            h1 = linspace1[i];
            testenv.activeElements = h1.printBinary();
        })
        ->setTestedFn([&h1](Tester::TestEnv testenv) {
            Half h = h1.sqrt();
        });
    tester->runAll();
    tester->writeLastToFile(pathHalf + "/halfSqrt.txt");
}