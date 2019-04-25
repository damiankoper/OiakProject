# Blabla

* Nie można dac z O1-O3 bo wali błędami i czasy zerowe wychodzą
* Dodałem `cpuid` przed rdtsc, żeby zserializować wykonanie, trochę polepszyło pomiary
* Okazuje się, że soft-float nie działał i nie jest on domyślnie dodany do domyślnej wersji libgcc, a nie chcę bawić się w rekompilację tego
* Testowana na procesorze Intel(R) Core(TM) i7-4770S CPU @ 3.10GHz, 32bit podczas normalnego obciążenia systemu