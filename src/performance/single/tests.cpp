#include "../tester/tester.h"
#include "../../float/single/lib/single.h"
#include "../../float/half/lib/half.h"
#include "../tester/utils.h"
#include "tests.h"
#include <vector>
#include <limits>
#include <string>

using namespace std;
using namespace floating;
using namespace floatingTests;

std::string pathSingle = "src/performance/results/single";

void single::testAdd()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    Single s1, s2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test single addition: ");
    tester
        ->setSameDataRepeats(1000)
        ->setOverallRepeats(1000)
        ->beforeSameDataSet([&i, &j, &s1, &s2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            s1 = linspace1[i];
            s2 = linspace1[j];
            testenv.activeElements = s1.printBinary();
            testenv.startElements = s2.printBinary();
        })
        ->setTestedFn([&s1, &s2](Tester::TestEnv testenv) {
            Single s = s1 + s2;
        })
        ->writeEveryToFile();
    tester->runAll();
    tester->writeLastToFile(pathSingle + "/singleAdd.txt");
    delete tester;
}

void single::testMul()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    Single s1, s2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test single multiplication: ");
    tester
        ->setSameDataRepeats(1000)
        ->setOverallRepeats(1000)
        ->beforeSameDataSet([&i, &j, &s1, &s2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            s1 = linspace1[i];
            s2 = linspace1[j];
            testenv.activeElements = s1.printBinary();
            testenv.startElements = s2.printBinary();
        })
        ->setTestedFn([&s1, &s2](Tester::TestEnv testenv) {
            Single s = s1 * s2;
        })
        ->writeEveryToFile();
    tester->runAll();
    tester->writeLastToFile(pathSingle + "/singleMul.txt");
    delete tester;
}

void single::testDiv()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(-100000., 101000., 100);

    Single s1, s2;
    int i = 0, j = -1;
    Tester *tester = new Tester("Test single division: ");
    tester
        ->setSameDataRepeats(1000)
        ->setOverallRepeats(1000)
        ->beforeSameDataSet([&i, &j, &s1, &s2, linspace1](Tester::TestEnv &testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            s1 = linspace1[i];
            s2 = linspace1[j];
            testenv.activeElements = s1.printBinary();
            testenv.startElements = s2.printBinary();
        })
        ->setTestedFn([&s1, &s2](Tester::TestEnv testenv) {
            Single s = s1 / s2;
        })
        ->writeEveryToFile();
    tester->runAll();
    tester->writeLastToFile(pathSingle + "/singleDiv.txt");
    delete tester;
}

void single::testSqrt()
{
    vector<float>
        linspace1 = utils::createLinspace<float>(0., 101000., 100);

    Single s1;
    int i = -1;
    Tester *tester = new Tester("Test single sqrt: ");
    tester
        ->setSameDataRepeats(1000)
        ->setOverallRepeats(100)
        ->beforeSameDataSet([&i, &s1, linspace1](Tester::TestEnv &testenv) {
            i++;
            s1 = linspace1[i];
            testenv.startElements = s1.printBinary();
            testenv.activeElements = s1.sqrt().printBinary();
        })
        ->setTestedFn([&s1](Tester::TestEnv testenv) {
            Single s = s1.sqrt();
        })
        ->writeEveryToFile();
    tester->runAll();
    tester->writeLastToFile(pathSingle + "/singleSqrt.txt");
    delete tester;
}