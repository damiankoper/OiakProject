#include <functional>
#include <vector>
#include <string>
namespace floating
{
class Tester
{
public:
  struct TestEnv
  {
    int startElements = 0;
    int activeElements = 1;
  };

  struct TestResult : TestEnv
  {
    TestResult(){};
    TestResult(TestEnv const &t) : TestEnv(t){};
    long long int cycles;
  };

  Tester();
  TestEnv testEnv = TestEnv();

  Tester *setTestedFn(std::function<void(TestEnv &testEnv)> cb);

  Tester *beforeEach(std::function<void(TestEnv &testEnv)> cb);
  Tester *afterEach(std::function<void(TestEnv &testEnv)> cb);
  Tester *afterSameDataSet(std::function<void(TestEnv &testEnv)> cb);

  Tester *setSameDataRepeats(int i);
  Tester *setOverallRepeats(int i);

  Tester *writeLastToFile(std::string name);
  std::vector<TestResult> runAll();
  std::string log = "";

private:
  std::vector<TestResult> lastResults;

  std::function<void(TestEnv &testEnv)> testedFn = [](TestEnv &testEnv) {};
  std::function<void(TestEnv &testEnv)> beforeEachFn = [](TestEnv &testEnv) {};
  std::function<void(TestEnv &testEnv)> afterEachFn = [](TestEnv &testEnv) {};
  std::function<void(TestEnv &testEnv)> afterSameDataSetFn = [](TestEnv &testEnv) {};

  int sameDataRepeats = 1;
  int overallRepeats = 1;

  long long int runSingle();
  long long int runSingleData();
};
} // namespace floating