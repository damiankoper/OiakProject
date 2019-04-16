#include "tester/tester.h"
#include "../float/single/lib/single.h"
#include "../float/half/lib/half.h"
#include <vector>
#include <limits>

using namespace std;
using namespace floating;
using namespace floating::literal;

template <typename T>
std::vector<T> createLinspace(T a, T b, size_t N)
{
    T h = (b - a) / static_cast<T>(N - 1);
    std::vector<T> xs(N);
    typename std::vector<T>::iterator x;
    T val;
    for (x = xs.begin(), val = a; x != xs.end(); ++x, val += h)
        *x = val;
    return xs;
}

int main(void)
{

    vector<float> linspace1 = createLinspace<float>(-100., 101., 10);

    Single s1 = Single(linspace1[0]);
    Single s2 = Single(linspace1[0]);
    int i = 0;
    int j = 0;

    Tester *tester = new Tester();
    tester->log = "Test ";
    tester
        ->setSameDataRepeats(100)
        ->setOverallRepeats(100)
        ->setTestedFn([&s1, &s2](Tester::TestEnv testenv) {
            Single s = s1 + s2;
        })
        ->afterSameDataSet([&i, &j, &s1, &s2, linspace1](Tester::TestEnv testenv) {
            if (j == linspace1.size() - 1)
            {
                j = 0;
                i++;
            }
            else
                j++;
            s1 = linspace1[i];
            s2 = linspace1[j];
        });

    tester->runAll();
    tester->writeLastToFile("src/performance/results/singleDiv.txt");
    return 0;
}
