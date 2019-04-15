#include "tester.h"
#include <functional>
#include <iostream>
#include <fstream>
#include <cinttypes>
using namespace floating;

uint64_t rdtsc()
{
    unsigned int lo, hi;
    __asm__ __volatile__("rdtsc"
                         : "=a"(lo), "=d"(hi));
    return ((uint64_t)hi << 32) | lo;
}

Tester::Tester()
{
}

Tester *Tester::setTestedFn(std::function<void(TestEnv &testEnv)> cb)
{
    testedFn = cb;
    return this;
}

Tester *Tester::beforeEach(std::function<void(TestEnv &testEnv)> cb)
{
    beforeEachFn = cb;
    return this;
}

Tester *Tester::afterEach(std::function<void(TestEnv &testEnv)> cb)
{
    afterEachFn = cb;
    return this;
}

Tester *Tester::afterSameDataSet(std::function<void(TestEnv &testEnv)> cb)
{
    afterSameDataSetFn = cb;
    return this;
}

Tester *Tester::setSameDataRepeats(int i)
{
    sameDataRepeats = i;
    return this;
}

Tester *Tester::setOverallRepeats(int i)
{
    overallRepeats = i;
    return this;
}

long long int Tester::runSingle()
{
    beforeEachFn(testEnv);

    uint64_t t1, t2;
    if (testedFn != NULL)
    {
        t2 = rdtsc();
        t2 = rdtsc() - t2;

        t1 = rdtsc();
        testedFn(testEnv);
        t1 = rdtsc() - t1;
        t1 -= t2;
    }

    afterEachFn(testEnv);
    return t1;
}

long long int Tester::runSingleData()
{
    long long int sum = 0;
    for (int i = 0; i < sameDataRepeats; i++)
    {
        sum += runSingle();
    }

    afterSameDataSetFn(testEnv);

    double avg = sum / sameDataRepeats;
    std::cout << log << avg << std::endl;
    return avg;
}

std::vector<Tester::TestResult> Tester::runAll()
{
    std::vector<Tester::TestResult> vec = std::vector<Tester::TestResult>();
    for (int i = 0; i < overallRepeats; i++)
    {
        Tester::TestResult result = TestResult(testEnv);
        result.cycles = runSingleData();
        vec.push_back(result);
    }
    lastResults = vec;
    return vec;
}

Tester *Tester::writeLastToFile(std::string name)
{
    std::ofstream myfile;
    myfile.open(name);
    for (auto testResult : lastResults)
    {
        myfile << testResult.startElements << ",";
        myfile << testResult.activeElements << ",";
        myfile << testResult.cycles << ",";
        myfile << std::endl;
    }

    myfile.close();
    return this;
}
