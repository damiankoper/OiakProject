#include <cinttypes>
#include <string>
namespace floating
{

class Single
{
public:
  /**
   * Contructors
   */
  Single(){};
  Single(long double longDouble);
  Single(unsigned long long uLongLong);
  Single(const Single &s);
  Single(uint8_t a, uint8_t b, uint8_t c, uint8_t d)
      : a(a), b(b), c(c), d(d){};

  /**
   * Math
   * More to come...
   */
  Single operator-();
  Single abs();
  Single changeSign();

  bool operator==(const Single &s);

  /**
   * Utils, debug, etc.
   */
  std::string printBinary();
  std::string printExponent(bool binary = false);
  std::string printFraction(bool binary = false);

private:
  /**
   *         sign           fraction
   * Format: d | dddddddc | cccccccbbbbbbbbaaaaaaaa
   *             exponent
   */
  uint8_t d = 0, c = 0, b = 0, a = 0;
};

namespace literal
{
Single operator""_s(long double longDouble);
Single operator""_s(unsigned long long uLongLong);
} // namespace literal

} // namespace floating