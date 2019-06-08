#include "tester.h"
#include <functional>
#include <iostream>
#include <fstream>
#include <cinttypes>
using namespace floating;

uint64_t rdtsc()
{
    unsigned int lo, hi;
    __asm__ __volatile__(
        "pusha;"
        "xor %%eax, %%eax;"
        "cpuid;"
        "popa;"
        "rdtsc;"
        : "=a"(lo), "=d"(hi));
    return ((uint64_t)hi << 32) | lo;
}

Tester::Tester(std::string log)
{
    this->log = log;
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

Tester *Tester::beforeSameDataSet(std::function<void(TestEnv &testEnv)> cb)
{
    beforeSameDataSetFn = cb;
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

    uint64_t perfTime, rawLatency;
    if (testedFn != NULL)
    {
        rawLatency = rdtsc();
        rawLatency = rdtsc() - rawLatency;

        perfTime = rdtsc();
        testedFn(testEnv);
        perfTime = rdtsc() - perfTime;
        perfTime -= rawLatency;
    }

    afterEachFn(testEnv);
    return perfTime;
}

long long int Tester::runSingleData()
{

    long long int sum = 0, t = 0;
    for (int i = 0; i < sameDataRepeats; i++)
    {
        t = runSingle();
        sum += t;
        if (writeEveryTest)
        {
            Tester::TestResult result = TestResult(testEnv);
            result.cycles = t;
            lastResults.push_back(result);
        }
    }

    double avg = sum / sameDataRepeats;
    std::cout << log << avg << std::endl;
    return avg;
}

std::vector<Tester::TestResult> Tester::runAll()
{
    for (int i = 0; i < overallRepeats; i++)
    {
        beforeSameDataSetFn(testEnv);

        Tester::TestResult result = TestResult(testEnv);
        result.cycles = runSingleData();
        lastResults.push_back(result);

        afterSameDataSetFn(testEnv);
    }
    return lastResults;
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

Tester *Tester::writeEveryToFile()
{
    writeEveryTest = true;
}