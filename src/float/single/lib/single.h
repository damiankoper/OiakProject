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
  Single(float f);
  Single(long double longDouble);
  Single(unsigned long long uLongLong);
  Single(const Single &s);

  /**
  * Conversions
  */
  operator int();
  operator float();
  operator double();

  int toInt();
  float toFloat();
  double toDouble();

  /**
   * Math
   */
  Single operator-();
  Single operator+(const Single &s);
  Single operator-(const Single &s);
  Single operator*(const Single &s);
  Single operator/(const Single &s);

  Single abs();
  Single changeSign();

  Single add(Single component);
  Single multiply(Single multiplier);
  Single subtract(Single subtrahend);
  Single divideBy(Single divisor);

  Single sqrt();
  /**
   * Comparison operators
   */
  bool operator==(const Single &s);
  bool operator==(const float &f);

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
   * Float in memory looks like:
   * [d       c       b       a       ]
   * [bytes[3]bytes[2]bytes[1]bytes[0]]
   */
  union Data {
    uint8_t bytes[4];
    uint32_t raw;
    float f;
  };
  Data data;

  void initFromFloat(float);
};

namespace literal
{
Single operator""_s(long double longDouble);
Single operator""_s(unsigned long long uLongLong);
} // namespace literal

} // namespace floating