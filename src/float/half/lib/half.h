#include <cinttypes>
#include <string>

namespace floating
{

class Half
{
public:
  /**
   * Contructors
   */
  Half(){};
  Half(float f);
  Half(long double longDouble);
  Half(unsigned long long uLongLong);
  Half(const Half &s);

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
  Half operator-();
  Half operator+(const Half &s);
  Half operator-(const Half &s);
  Half operator*(const Half &s);
  Half operator/(const Half &s);

  Half abs();
  Half changeSign();

  Half add(Half component);
  Half multiply(Half multiplier);
  Half subtract(Half subtrahend);
  Half divideBy(Half divisor); // TODO: implement this

  Half sqrt();
  /**
   * Comparison operators
   */
  bool operator==(const Half &s);
  bool operator==(const float &f);

  /**
   * Utils, debug, etc.
   */
  std::string printBinary();
  std::string printExponent(bool binary = false);
  std::string printFraction(bool binary = false);

private:
  /**
   *         sign        fraction
   * Format: b | bbbbb | bbaaaaaaaa
   *             exponent
   * Float in memory looks like:
   * [b       a       ]
   * [bytes[1]bytes[0]]
   */
  union Data {
    uint8_t bytes[2];
    uint16_t raw;
  };
  Data data;

  void initFromFloat(float);
};

namespace literal
{
Half operator""_h(long double longDouble);
Half operator""_h(unsigned long long uLongLong);
} // namespace literal

} // namespace floating