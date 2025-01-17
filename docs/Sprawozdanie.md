
<div style="display:flex;justify-content:space-between"><span>CZ-TP-13</span> Wrocław, 16.05.2019r. </div>
<h1 style="text-align:center; border: none; margin-bottom: 50px">
    Organizacja i architektura komputerów
</h1>
<h1 style="text-align:center;  border: none; margin-bottom: 50px">
    Implementacja procedur obliczeń na liczbach zmiennoprzecinkowych za pomocą instrukcji stałoprzecinkowych.
</h1>

<h3 style="text-align:center">
Mateusz Gurski, 242089<br>
Damian Koper, 241292
</h3>
<hr>

## Cel projektu
Celem projektu była implementacja procedur obliczeń na liczbach zmiennoprzecinkowych połowicznej i&nbsp;pojedynczej precyzji za pomocą instrukcji stałoprzecinkowych.

### Ograniczenia
Jedynym ograniczeniem była długość słowa, ustalona na 8 bitów. Zadanie można interpretować, jako stworzenie biblioteki do programowej realizacji obliczeń zmiennoprzecinkowych, gdzie ograniczenie słowa do 8 bitów sygnalizuje, że może być ona użyta w mikrokontrolerach 8 bitowych, które naturalnie nie mają jednostki zmiennoprzecinkowej, a gdzie zachodzi potrzeba takich obliczeń.

## IEEE-754 - Single
Liczba w formacie pojedynczej precyzji reprezentowana jest przez następujący ciąg bitów:
```
znak           ułamek
x | xxxxxxxx | xxxxxxxxxxxxxxxxxxxxxxx
    wykładnik
```
Wykładnik zapisny jest z dodanym obciążeniem, co pozwala zachować ciągłość reprezentacji i ułatwia porównania. Dla formatu single obiążenie to wynosi *+127*. Jeśli wykładnik nie reprezentuje liczb zdenormalizowanych (wartość *0x00*), ułamek zawiera ukrytą jedynkę z przodu.
<div style="margin-bottom:200px"></div>

## IEEE-754 - Half
Liczba w formacie połowicznej precyzji reprezentowana jest przez następujący ciąg bitów:
```
znak        ułamek
x | xxxxx | xxxxxxxxxx
    wykładnik
```
Obciążenie dla formatu half wynosi *+15*. Jeśli wykładnik nie reprezentuje liczb zdenormalizowanych (wartość *0b00000*), ułamek zawiera ukrytą jedynkę z przodu.

## Procedury obliczeń

### Dodawanie, odejmowanie
Dodawanie i odejmowanie mogą być zaimplementowane jako jedna operacja, co wynika z zależności *A&#8209;B&nbsp;=&nbsp;A+(-B)*.
Jako, że implementowane dodawanie jest działaniem przemiennym, warto rozpatrywać zawsze jeden przypadek, gdzie *A <= B*. W przypadku kiedy *A > B* należy zamienić oba składniki miejscami.

Następnie trzeba wyrównać wykładnik mniejszej liczby. Wiemy, że *A <= B*, więc trzeba przesunąć bity mantysy B o `exp[A]-exp[B]` w lewo. Na tym etapie, znając utracone bity, możemy zaokrąglić otrzymaną liczbę.

Jeśli znaki obu składników są takie same, należy na mantysach wykonać operację dodawania z zachowaniem znaku wyniku, a jeśli różne, odejmowania razem z ustawieniem znaku wyniku na minus.

Po uzyskaniu wyniku trzeba go znormalizować przesuwając go w lewo lub w prawo jednocześnie zmniejszając lub zwiększając wykładnik wyniku, który początkowo ma wartośc `exp[A]`. Przy wynikach, dla których wartość nie mieści sie w przedziale wartości liczb pojedynczej precyzji należy pamiętać o ustawieniu w odpowiednich przypadkach wartości *0* i *inf*. Wartość *NaN* nie występuje jako wynik w przypadku tych operacji przy poprawnych składnikach.

### Mnożenie
Mnożąc liczby ustawiamy znak wyniku według zależności `sign[C] = sign[A] XOR sign[B]`. Następnie sprawdzamy, czy którykolwiek ze składników ma wartośc *0*. Jeśli tak, to zwracamy *0* z odpowiednim znakiem (jeśli chcemy mieć znakowane *0*). 

Wynikowy wykładnik otrzymamy poprzez dodanie wartości wykładników składników, pamiętając o odjęciu obiążenia, a następnie korygując go w procesie normalizacji. W celu normalizacji iloczynu mantys, wiedząc, że iloczyn liczb 24 bitowych zawsze da wynik maksymalnie 48 bitowy, możemy sprawdzić bit 48 wyniku tego działania. Jeśli ma on wartośc 1 oznacza to, że wartość jest za duża. Trzeba zwiększyć wykładnik i przesunąć mantysę w prawo. 

W przypadku, gdy wartość jest zbyt mała, trzeba sprawdzać bit 47 iloczynu, zmniejszać wykładnik i przesuwać mantysę w lewo, aż owy bit nie będzie miał wartości 1 lub wykładnik nie będzie równy `0x01` (dla Half `0b00001`) - w takim wypadku otrzymamy wynik zdenormalizowany. W przypadku wyniku zdenormalizowanego wykładnik reprezentowany jest jako `0x00` (dla Half `0b00000`).

Zaraz po wykonaniu mnożenia mantys, znając pozostałe bity wyniku, które zostaną utracone, możemy wykonać zaokrąglanie.
Tak jak w dodawaniu/odejmowaniu, w przypadku przekroczenia zakresu trzeba pamiętać o ustawieniu wartości *+/-inf*.

### Dzielenie
Dzielenie odbywa się na podobnej zasadzie co mnożenie.

W tym przypadku ważna jest początkowa walidacja liczb. Rozróżniamy przypadki, którym trzeba ustawić specjalne wartości:
* `A/0 = inf`
* `0/0 = NaN`

Aby uzyskać wykładnik trzeba odjąć od siebie wykładniki dzielnej i dzielnika, a następnie dodać obciążenie.
Interpretując mantysę jako liczbę w formacie *Q23* (dla Half *Q10*), stosując arytmetykę stałoprzecinkową, przesuwając bity dzielnej o 26 (dla Half o 13) w lewo, jako wynik dzielenia `frac[A]/frac[B]` otrzymamy liczbę w formacie *Q26* (dla Half *Q13*), co daje nam wymagane 23 (dla Half *Q10*) bity mantysy i trzy dodatkowe bity GRS. Przy czym bit S:
```
S = S | mod(frac[A]/frac[B]) != 0
```
uwzględnia bity reszty.

Normalizacja wyniku przebiega podobnie jak w przypadku mnożenia. Różni się tylko rozmiarem wyniku, a co za tym idzie pozcjami bitów, które świadczą o potrzebie normalizacji.

W przypadku przekroczenia zakresu trzeba pamiętać o ustawieniu wartości *+/-0*.

### Pierwiastek

Pierwiastkowanie możliwe jest tylko, gdy liczba jest dodatnia, więc obliczenia trzeba rozpocząć od sprawdzenia znaku. Następnie trzeba sprawdzić czy wykładnik jest parzysty – jeśli nie, zmniejszamy go o 1 odpowiednio skalując mantysę. Gdy wykładnik jest już parzysty, dzielimy go przez 2 i otrzymujemy w ten sposób wykładnik wyniku. Dzielenie wykładnika przez 2 można łatwo wykonać przesuwając wykładnik, od którego wcześniej odjęto obciążenie, o 1 w prawo.

Kolejnym krokiem jest spierwiastkowanie mantysy. Wykonujemy algorytm 
```
(2 * Qi * B + x) * x <= Ri
``` 
gdzie Qi – aktualny wynik, B – podstawa liczby (w tym przypadku 2), Ri – aktualna reszta, x - kolejny bit wyniku pierwiastkowania.

W przypadku pierwiastkowania liczb o podstawie 2, `x` równe jest 1 jeśli dla `x` równego 1 spełnione jest powyższe równanie, jeśli nie – `x` równe jest 0. Jeśli wykładnik był parzysty to mantysa razem z niejawną jedynką jest teraz postaci `1,x..x`, jeśli był nieparzysty to mantysa jest postaci `1x,x..x`, pierwszy krok algorytmu wykonywany jest więc poza pętlą dla `01` gdy wykładnik był parzysty lub dla `1x` gdy był nieparzysty. Pozostałe kroki algorytmu wykonywane są już w pętli.

## Implementacja
Procedury obliczeń realizuje stworzona biblioteka języka `C++`. Architektura projektu została zrealizowana w trzech częściach, gdzie każda korzysta z kolejnej:
```
Simple --> Single/Half --> Single/Half(C++)
```

### Simple
Część *Simple* realizuje obliczenia na liczbach stałoprzecinkowych odpowiedniej długości. Dla każdej z nich stworzone zostały funkcje operujące na liczbach różnej długości w celu optymalnego wykorzystania w zależności od potrzeb:
* Add 16/24/32/48b
* Sub 16/24/32/48b
* Div 16/32/64b
* Mul 16/32b
* ShiftL 16/24/32/48b
* ShiftR 16/24/32/48b
* HalfToFloat
* FloatToHalf
  
Do każdej z nich dostarczane są wskaźniki na dane, poprzez które również zwracany jest wynik.
HalfToFloat i FloatToHalf do konwersji wykorzystują rozszerzenie *F16C(SSE)* procesora i instrukcje `VCVTPS2PH` oraz `VCVTPH2PS`. Według ustaleń konwersja nie podlega ograniczeniu długości słowa 8 bit. Korzystanie z tych instrukcji w wyższych warstwach eliminuje całkowicie nałożone ograniczenie długości słowa. Używają one instrukcji operujących na liczbach 8 bitowych, wykorzystujących flagę przeniesienia oraz algorytmy m.in dzielenia nieodtwarzającego.

### Single/Half
Część *Single/Half* implementuje obliczenia na liczbach zmiennoprzecinkowych połowicznej i pojedynczej precyzji używając operacji *Simple*. Według opisanych wyżej procedur obliczeń, na poziomie asemblera zaimplementowane zostały operacje dodawania/odejmowania, mnożenia, dzielenia i pierwiastka. Do każdej z funkcji dostarczane są wskaźniki na dane, poprzez które również zwracany jest wynik.

### Single/Half (C++)
Produktem końcowym jest biblioteka napisana w języku `C++`. Stworzone zostały dwa typy `floating::Single` i `floating::Half` posiadające takie same API, a różniące się tylko rozmiarem pola danych, które stworzono za pomocą unii w celu uzyskania dostępu do danych w różnych interpretacjach.
<div style="height:60px;"></div>

```cpp
namespace floating
{
class Single
{
public:
  Single(){};
  Single(float f);
  Single(long double longDouble);
  Single(unsigned long long uLongLong);
  Single(const Single &s);

  operator int();
  operator float();
  operator double();

  int toInt();
  float toFloat();
  double toDouble();

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
  bool operator==(const Single &s);
  bool operator==(const float &f);

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

} // namespace floating
```
<div style="position:relative; top:-10px; margin-bottom:-10px; text-align:center">Listing 1.</div>

Użytko również dodane w `C++11` user-defined literals, które zdefiniowane w następujący sposób:

```cpp
namespace floating
{
    namespace literal
    {
    Single operator""_s(long double longDouble);
    Single operator""_s(unsigned long long uLongLong);
    } // namespace literal
} // namespace floating
```
<div style="position:relative; top:-10px; margin-bottom:-10px; text-align:center">Listing 2.</div>

umożliwiają tworzenie nowych obiektów w prosty spodób:
```cpp
using namespace floating::literal;
...
floating::Single s = 1.2543_s;
```
<div style="position:relative; top:-10px; margin-bottom:-10px; text-align:center">Listing 3.</div>

Typ `floating::Half` od typu `floating::Single` różni się jedynie mniejszą, wewnętrzną reprezentacją, oraz literałem `_h` zamiast `_s`.
```cpp
  /**
   *         sign        fraction
   * Format: b | bbbbb | bbaaaaaaaa
   *             exponent
   * Half in memory looks like:
   * [b       a       ]
   * [bytes[1]bytes[0]]
   */
  union Data {
    uint8_t bytes[2];
    uint16_t raw;
  };
```
<div style="position:relative; top:-10px; margin-bottom:-10px; text-align:center">Listing 4.</div>

<div style="margin-bottom: 200px;"></div>

## Testy i wydajność

### Proces tworzenia biblioteki
Podczas tworzenia kolejnych elementów biblioteki zastosowana została technika *Test-Driven Development*, również podczas tworzenia operacji *Simple*.
Poprzez napisany skrypt biblioteka, jak i testy, kompilowały się automatycznie po każdej zmianie kodu.
```sh
#!/bin/bash
{
    make ${1:-all}
} && {
    while inotifywait -r -e modify ${2:-src tests/float}; do 
        make ${1:-all}
    done
}
```
<div style="position:relative; top:-10px; margin-bottom:-10px; text-align:center">Listing 5.</div>

### Testy jednostkowe
Testy jednostkowe zostały stworzone wykorzystując framework `Catch2`. Osobno dla `floating::Single` i `floating::Half` został utworzony plik wykonywalny zawierający test każdej funkcji, które były rekompilowane i uruchamiane po każdej zmianie kodu. Środowisko *Visual Studio Code* poprzez swoje rozszerzenia integrujące `Catch2` pozwoliło na łatwe zarządzanie i wykonywanie testów.

### Testy wydajności
Testy wydajności odbyły się na maszynie z systemem *Ubuntu 18.4*, na procesorze Intel(R) Core(TM) i7-4770S CPU @ 3.10GHz podczas normalnego obciążenia systemu. Pliki wykonywalne były kompilowane w architekturze 32 bit i uruchamiane z możliwie najwyższym priorytetem (`niceness=-20`).
Obiekt klasy `floating::Tester` wielokrotnie wykonywał operację zdefiniowaną w przekazanej funkcji lambda (dla tych samych i różnych danych) i mierzył czas jej wykonania w cyklach pracy procesora za pomocą rozkazu `rdtsc`, który wymaga serializacji (`cpuid`):
```cpp
uint64_t rdtsc()
{
  unsigned int lo, hi;
  __asm__ __volatile__("xor %%eax, %%eax;"
                       "cpuid;"
                       "rdtsc;"
                       : "=a"(lo), "=d"(hi));
}
```
<div style="position:relative; top:-10px; margin-bottom:-10px; text-align:center">Listing 6.</div>

Testy każdej operacji dla argumentów z wygenerowanej przestrzeni liniowej zostały wykonany dla typów `floating::Single` i `floating::Half` oraz `float` w celu porównania do natywnej realizacji.

<div style="margin-bottom: 200px;"></div>

## Wyniki testów

### Wyniki ogólne

<div style="text-align:center">
  <img src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/tabelka.png?raw=true"/>
  <br>Tab 1. Średnie wyniki testu wydajności
  <div style="height:20px;"></div>
  <img src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/czas_wykonania.png?raw=true"/>
  <br>Rys. 1. Średnie wyniki testu wydajności
</div>

### Histogramy

Dla każdej z operacji Single zostały wygenerowane histogramy (rys. 2-5). Każdy z nich przedstawia rozkład czasu trwania operacji dla 1000 powtórzeń działania dla tych samych operandów. Dla każdej operacji występują sporadycznie wartości bardzo duże, które nie zostały uwzględnione na wykresach. 

Rozbieżność czasów dla tych samych operacji wynika z aktualnego obciążenia systemu operacyjnego, który zarządzając zadaniami, może przełączać kontekst pomiędzy procesami i obsługiwać przerwania. Sprawia to, że w rzeczywistości algorytmy, z punktu widzenia procesora, nie wykonują się jak jeden spójny ciąg instrukcji.

Dla operacji Half występują analogiczne rozbieżności.
<div style="text-align: center">
  <img style="max-width: 650px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/hadd2.png?raw=true"/>
  <br><div style="margin-bottom:10px">Rys. 2. Histogram na podstawie 1000 operacji dodawania (Single)</div><br>
</div>

<div style="text-align: center">
  <img style="max-width: 650px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/hmul2.png?raw=true"/>
  <br><div style="margin-bottom:10px">Rys. 3. Histogram na podstawie 1000 operacji mnożenia (Single)</div>
</div>

<div style="text-align: center">
  <img style="max-width: 650px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/hdiv2.png?raw=true"/>
  <br><div style="margin-bottom:10px">Rys. 4. Histogram na podstawie 1000 operacji dzielenia (Single)</div><br>
</div>

<div style="text-align: center">
  <img style="max-width: 650px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/hsqrt2.png?raw=true"/>
  <br><div style="margin-bottom:10px">Rys. 5. Histogram na podstawie 1000 operacji pierwiastkowania (Single)</div>
</div>
<div style="margin-bottom: 100px;"></div>

### Profilowanie
Profilowanie wykonane zostało przy użyciu *Callgrind* oraz *KCachegrind*. Na podstawie oszacowanych cykli oraz mapy wywoływanych w *KCachegrind*, udało się utworzyć wykresy reprezentujące rozkład kosztów, własnego oraz użytych w danej operacji funkcji *Simple*, w których wykonywane są operacje 8 bitowe.
#### Dodawanie

<div style="text-align:center">
  <img style="max-width:430px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/add.png?raw=true"/>
  <br>Rys. 6. Rozkład kosztów zagnieżdżonych funkcji operacji dodawania (Single)
</div>

Większość kosztów to przesunięcia, dwa najbardziej kosztowne spośród wywołań `simple_shiftR` i&nbsp;`simple_shiftL` to przesunięcia, których celem jest wyzerowanie bitów znaku i wykładnika, co da się w prosty sposób wykonać przy użyciu `AND` tak, jak zostało to wykonane w implementacji dodawania dla Half. Niestety dla implementacji w *Single* zostało to przeoczone podczas optymalizowania kodu. Drugie najbardziej kosztowne wywoływania przesunięć to skalowanie mantysy wynikowej po wykonaniu operacji dodawania lub odejmowania.

#### Mnożenie

<div style="text-align:center">
  <img style="max-width:430px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/mul.png?raw=true"/><br>Rys. 7. Rozkład kosztów zagnieżdżonych funkcji operacji mnożenia (Single)
</div>

W przypadku mnożenia, najbardziej kosztowne jest wymnożenie mantys. Drugą najbardziej kosztowną operacją jest przesunięcie wyniku mnożenia, który maksymalnie zajmuje 48 bitów o 16 bitów w prawo. To samo dałoby się osiągnąć znacznie optymalniej przepisując odpowiednio kolejne bajty.
<div style="margin-bottom: 50px;"></div>

#### Dzielenie

<div style="text-align:center; margin-top:-20px;">
  <img style="max-width:430px" src="https://github.com/damiankoper/OiakProject/blob/master/docs/charts/div.png?raw=true"/>
  <br>Rys. 8. Rozkład kosztów zagnieżdżonych funkcji operacji dzielenia (Single)
</div>

Operacja `simple_div` zajmuje większą część kosztów operacji dzielenia. Ograniczenie do użycia rejestrów 8 bitowych okazało się być w przypadku algorytmu dzielenia najbardziej kosztowne. 

Operacja `simple_div` w pierwszej wersji wykorzystywała algorytm dzielenia nieodtwarzającego. Później został on zamioniony na algorytm wykorzystujący iteratywną korekcję błędu[1], operujący na cyfrach liczby w bazie `2^256`, co pozwoliło wykorzystać dostępną 8 bitową operację dzielenia. Mimo zmiany algorytmu na pozornie szybszy, wydajność operacji nieznacznie się zmniejszyła.

#### Pierwiastek

<div style="text-align:center">
  <img style="max-width:430px" src="charts/sqrt.png?raw=true"/>
  <br>
  Rys. 9. Rozkład kosztów zagnieżdżonych funkcji operacji pierwiastkowania (Single)
</div>

Większość kosztów pierwiastka to przesunięcia, które wykonywane są w pętli podczas wykonywania algorytmu `(2 * Qi * B + x)x <= Ri`.

## Napotkane problemy
1. Brak możliwości porównania wydajności operacji z biblioteką `soft-float`. Kompilacja plików za pomocą `gcc` z flagą `-msoft-float` generuje błędy linkowania, ponieważ biblioteka `soft-float` domyślnie nie jest obecna w `libgcc`, a wszelkie próby kompilowania jej ze źródeł nie przyniosły żadnych efektów.
2. Z niezidentyfikowanych przyczyn kompilacja z optymalizacją `-O1`, `-O2`, `-O3` generuje błędy.

<div style="margin-bottom: 200px;"></div>

## Wnioski

Poprawnie napisana i w całości przetestowana biblioteka realizująca obliczenia zmiennoprzecinkowe, która nie korzysta ze sprzętowego wspomagania tych obliczeń, jest niezastąpiona na urządzeniach bez owego wspomagania. Tworząc kod w języku asembler dla kluczowych jej elementów, ograniczamy się do obsługi jednej platformy. Kod tworzony na wyższych warstwach abstrakcji języka ma dużą zaletę, jaką jest przenośność, ponieważ to od kompilatora tego języka zależy, jaką postać kodu maszynowego wygeneruje, co pozwala na proces kompilacji tego samego kodu na różne platformy. 

Spełnienie ograniczenia długości słowa 8 bit wymagało jednak stworzenia większej części kodu w języku asembler, ponieważ *GCC* nie pozwala na kompilację, której wynik spełniałby to ograniczenie. Podchodząc do problemu jeszcze raz, można pokusić się o stworzenie i kompilację kodu w środowisku, gdzie do testów zostałby użyty 8 bitowy mikrokontroler lub jego symulator.

Analizując opisane i przetestowane operacje i ich składowe widać, że największy narzut czasowy stanowią te, które znoszą ograniczenie długości słowa - *Simple*. Można zatem stwierdzić, że długość słowa i szybkość wykonywania na nim najprostszych operacji w dużym stopniu stanowi o szybkości działania złożonych algorytmów - w tym przypadku obliczeń na liczbach zmiennoprzecinkowych. 

Kluczowym elementem poprawiającym wydajność jest również, prócz stworzenia prostych funkcji ogólnego przeznaczenia, dostosowanie ich odpowiedników do poszczególnych algorytmów w celu uniknięcia wykonywania nadmiarowej liczby kroków.

#### Repozytorium
https://github.com/damiankoper/OiakProject

#### Sprawozdanie
https://github.com/damiankoper/OiakProject/blob/master/docs/Sprawozdanie.pdf

## Literatura
1. Algorytm dzielenia <br>- http://justinparrtech.com/JustinParr-Tech/an-algorithm-for-arbitrary-precision-integer-division/
2. Arytmetyka stałej precyzji - http://x86asm.net/articles/fixed-point-arithmetic-and-tricks/
3. Biblioteka soft-fp - https://github.com/lattera/glibc/tree/master/soft-fp
4. Opis operacji na liczbach zmiennoprzecinkowych <br>-  http://www.rfwireless-world.com/Tutorials/floating-point-tutorial.html