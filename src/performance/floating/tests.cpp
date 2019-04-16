#include "../tester/tester.h"
#include "../tester/utils.h"
#include "tests.h"
#include <vector>
#include <limits>
#include <string>
#include <cmath>
using namespace std;
using namespace floating;
using namespace floatingTests;

std::string pathFloat = "src/performance/results/float";

void _float::testAdd()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    float f1, f2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test float addition: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(10000)
        ->beforeSameDataSet([&i, &j, &f1, &f2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            f1 = linspace1[i];
            f2 = linspace1[j];
            testenv.activeElements = to_string(f1);
            testenv.startElements = to_string(f2);
        })
        ->setTestedFn([&f1, &f2](Tester::TestEnv testenv) {
            float f = f1 + f2;
        });
    tester->runAll();
    tester->writeLastToFile(pathFloat + "/floatAdd.txt");
}

void _float::testMul()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    float f1, f2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test float multiplication: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(10000)
        ->beforeSameDataSet([&i, &j, &f1, &f2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            f1 = linspace1[i];
            f2 = linspace1[j];
            testenv.activeElements = to_string(f2);
            testenv.startElements = to_string(f2);
        })
        ->setTestedFn([&f1, &f2](Tester::TestEnv testenv) {
            float f = f1 * f2;
        });
    tester->runAll();
    tester->writeLastToFile(pathFloat + "/floatMul.txt");
}

void _float::testDiv()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    float f1, f2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test float division: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(10000)
        ->beforeSameDataSet([&i, &j, &f1, &f2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            f1 = linspace1[i];
            f2 = linspace1[j];
            testenv.activeElements = to_string(f2);
            testenv.startElements = to_string(f2);
        })
        ->setTestedFn([&f1, &f2](Tester::TestEnv testenv) {
            float f = f1 / f2;
        });
    tester->runAll();
    tester->writeLastToFile(pathFloat + "/floatDiv.txt");
}

void _float::testSqrt()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(0., 101000., 100);

    float f1;
    int i = -1;
    Tester *tester = new Tester("Test float sqrt: ");
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(100)
        ->beforeSameDataSet([&i, &f1, linspace1](Tester::TestEnv &testenv) {
            i++;
            f1 = linspace1[i];
            testenv.activeElements = to_string(f1);
        })
        ->setTestedFn([&f1](Tester::TestEnv testenv) {
            float f = sqrt(f1);
        });
    tester->runAll();
    tester->writeLastToFile(pathFloat + "/floatSqrt.txt");
}