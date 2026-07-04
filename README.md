# Implementacja w Verilogu: kodu Hamminga (38, 32) oraz kodu Hadamarda (8, 3)

## Pierwszy program – implementacja kodu Hamminga (38, 32)

### 1. Moduł (Enkoder / Encoder)
Koduje 32-bitowe wiadomości na słowa kodowe poprzez obliczenie 6 bitów parzystości i umieszczenie ich na pozycjach będących potęgami dwójki. Pozostałe pozycje są wypełniane bitami informacyjnymi wiadomości początkowej.

### 2. Moduł (Dekoder / Decoder)
Wczytuje 38-bitowe słowa kodowe opuszczające enkoder, przy czym we wszystkich słowach kodowych najmniej znaczący bit (LSB) zostaje zanegowany operacją XOR. Następnie obliczane są bity syndromu, a detekcja i korekcja błędów odbywa się przy użyciu tablicy `blad_poz`, która składa się ze wszystkich (6) obliczonych bitów syndromu. Na końcu tego modułu wyprowadzane są poprawione 38-bitowe słowa kodowe oraz zdekodowane 32-bitowe wiadomości.

### 3. Moduł (Testbench)
Wykonuje wszystkie funkcjonalności z poprzednich modułów przez liczbę iteracji określoną w pętli `for`. Wszystkie sygnały są zapisywane do pliku `wyniki_hamming.vcd`. Sygnały można odczytać za pomocą programu GTKWave.

---

## Drugi program – implementacja kodu Hadamarda (8, 3)

### 1. Moduł (Enkoder / Encoder)
Koduje 3-bitowe wiadomości na 8-bitowe słowa kodowe poprzez mnożenie XOR wierszy macierzy generatora przez 3-bitowe wiadomości.

### 2. Moduł (Dekoder / Decoder)
Zlicza odległość Hamminga między 8-bitowymi słowami kodowymi z błędem jednobitowym a wierszami macierzy słów kodowych. Wiersz, dla którego różnica jest najmniejsza, stanowi poprawione, wyjściowe 8-bitowe słowo kodowe.

### 3. Moduł (Testbench)
Wykonuje wszystkie funkcjonalności z poprzednich modułów przez liczbę iteracji określoną w pętli `for`. Wszystkie sygnały są zapisywane do pliku `wyniki_hadamard.vcd`. Sygnały można odczytać za pomocą programu GTKWave.
