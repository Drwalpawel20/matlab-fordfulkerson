# 🌊 MATLAB Ford-Fulkerson

Implementacja algorytmu **Forda-Fulkersona** do wyznaczania maksymalnego przepływu w sieci, napisana w MATLAB-ie, z krokową wizualizacją działania. Ścieżki powiększające są wyszukiwane przeszukiwaniem wszerz (BFS), więc projekt jest w praktyce realizacją wariantu **Edmondsa-Karpa**. Każdy krok algorytmu (przeszukiwanie grafu, wybrana ścieżka, aktualny przepływ) jest rysowany na wykresie, dzięki czemu program dobrze nadaje się do nauki i prezentacji.

![MATLAB](https://img.shields.io/badge/MATLAB-R2019b%2B-orange?logo=mathworks&logoColor=white)
![Algorithm](https://img.shields.io/badge/algorithm-Ford--Fulkerson%20%2F%20Edmonds--Karp-blue)
![Status](https://img.shields.io/badge/status-gotowy-brightgreen)

## Spis treści

- [Funkcje](#funkcje)
- [Jak działa algorytm](#jak-działa-algorytm)
- [Wymagania](#wymagania)
- [Instalacja](#instalacja)
- [Użycie](#użycie)
- [Struktura repozytorium](#struktura-repozytorium)
- [Szczegóły implementacji](#szczegóły-implementacji)
- [Złożoność](#złożoność)
- [Dalszy rozwój](#dalszy-rozwój)
- [Autor](#autor)

## Funkcje

- Obliczanie maksymalnego przepływu między źródłem a ujściem w grafie skierowanym z pojemnościami krawędzi
- Budowa grafu resztkowego w każdej iteracji (krawędzie do przodu i krawędzie wsteczne)
- Wyszukiwanie ścieżek powiększających algorytmem BFS
- Zapis wszystkich znalezionych ścieżek wraz z przepływem przez każdą z nich
- Wizualizacja krok po kroku: graf początkowy, eksploracja BFS, kolejne ścieżki, wynik końcowy
- Graf reprezentowany macierzą sąsiedztwa (macierz pojemności)

## Jak działa algorytm

1. Zacznij od zerowego przepływu w każdej krawędzi.
2. Zbuduj graf resztkowy: dla każdej krawędzi `u → v` pozostała pojemność to `c(u,v) − f(u,v)`, a dodatkowo powstaje krawędź wsteczna `v → u` o pojemności równej bieżącemu przepływowi `f(u,v)`.
3. Znajdź w grafie resztkowym najkrótszą ścieżkę ze źródła do ujścia (BFS).
4. Jeśli ścieżki nie ma, algorytm kończy się, a suma przepływów jest maksymalnym przepływem.
5. W przeciwnym razie przepchnij przez ścieżkę przepływ równy jej wąskiemu gardłu (minimalnej pozostałej pojemności), zaktualizuj przepływy i wróć do kroku 2.

## Wymagania

- MATLAB R2019b lub nowszy (kod używa `isvalid`, `struct`, wykresów w obiekcie `axes`)
- Nie są wymagane dodatkowe toolboxy w głównej części algorytmu

## Instalacja

```bash
git clone https://github.com/Drwalpawel20/matlab-fordfulkerson.git
cd matlab-fordfulkerson
```

Następnie otwórz folder w MATLAB-ie i dodaj go do ścieżki:

```matlab
addpath(pwd)
```

> 📝 **Ważne:** MATLAB wymaga, aby nazwa pliku odpowiadała nazwie funkcji. Pliki oznaczone w nazwie końcówką ` (1)` (np. `runFordFulkerson (1).m`) przed uruchomieniem zmień na `runFordFulkerson.m`, `visualizeGraph.m` i `fordFulkersonGUI.m`. Plik `bfs (1).m` jest zbędną kopią `bfs.m`.

## Użycie

### Przykład z kodu

Graf zapisujemy jako macierz pojemności, gdzie `graph(u,v)` to pojemność krawędzi z `u` do `v`. Poniższy przykład to klasyczna sieć z podręcznika algorytmów, w której maksymalny przepływ wynosi **23**.

```matlab
% Macierz pojemności (6 wierzchołków: 1 = źródło, 6 = ujście)
graph = zeros(6);
graph(1,2) = 16;  graph(1,3) = 13;
graph(2,3) = 10;  graph(2,4) = 12;
graph(3,2) = 4;   graph(3,5) = 14;
graph(4,3) = 9;   graph(4,6) = 20;
graph(5,4) = 7;   graph(5,6) = 4;

% Osie, na których będzie rysowana wizualizacja
fig = figure;
ax  = axes(fig);

[maxFlow, allPaths] = runFordFulkerson(graph, 1, 6, ax);

fprintf('Maksymalny przepływ: %d\n', maxFlow);
```

### Wartości zwracane

| Zmienna | Opis |
|---|---|
| `maxFlow` | maksymalny przepływ od źródła do ujścia |
| `allPaths` | tablica struktur z polami `path` (kolejne wierzchołki ścieżki) i `flow` (przepływ przez ścieżkę) |

### Interfejs graficzny

Repozytorium zawiera też plik `fordFulkersonGUI.m` z interfejsem graficznym. Uruchom go poleceniem:

```matlab
fordFulkersonGUI
```

## Struktura repozytorium

```
matlab-fordfulkerson/
├── runFordFulkerson.m   # główna pętla algorytmu: graf resztkowy, aktualizacja przepływów
├── bfs.m                # BFS w grafie resztkowym, zwraca ścieżkę i jej wąskie gardło
├── getPath.m            # odtwarzanie ścieżki z tablicy poprzedników
├── visualizeGraph.m     # rysowanie grafu, ścieżek i przepływów
├── fordFulkersonGUI.m   # interfejs graficzny
└── README.md
```

## Szczegóły implementacji

- **`runFordFulkerson(graph, source, sink, ax)`** przechowuje macierz przepływów `flowGraph`, w każdej iteracji buduje graf resztkowy i wywołuje `bfs`. Po znalezieniu ścieżki aktualizuje przepływy: zwiększa je na krawędziach do przodu, a na krawędziach wstecznych zmniejsza. Pętla jest ograniczona do 100 iteracji jako zabezpieczenie.
- **`bfs(graph, source, sink, ax)`** utrzymuje kolejkę, tablicę poprzedników `parent` oraz tablicę `minFlow` z minimalną pojemnością na drodze do każdego wierzchołka. Dzięki temu wąskie gardło ścieżki jest znane od razu po dotarciu do ujścia.
- **`getPath(parent, source, sink)`** odtwarza ścieżkę od ujścia do źródła według poprzedników.
- **`visualizeGraph`** odpowiada za animację. Między krokami stosowane są krótkie pauzy (`pause`), aby przebieg algorytmu był czytelny.

## Złożoność

Ponieważ ścieżki szukane są przez BFS, algorytm działa jak Edmonds-Karp:

| | |
|---|---|
| Liczba powiększeń | `O(V·E)` |
| Czas | `O(V·E²)` |
| Pamięć | `O(V²)` (macierz sąsiedztwa) |

## Dalszy rozwój

- [ ] Wczytywanie grafu z pliku (CSV / macierz sąsiedztwa)
- [ ] Wyznaczanie minimalnego przekroju (min-cut) na podstawie ostatniego grafu resztkowego
- [ ] Zamiana ręcznego ograniczenia 100 iteracji na dowolnie duży limit lub jego brak
- [ ] Testy jednostkowe (`matlab.unittest`) na znanych sieciach
- [ ] Zrzuty ekranu lub GIF z przebiegu algorytmu w README
- [ ] Porównanie z wbudowaną funkcją `maxflow` z MATLAB-a

## Autor

**Paweł** – [@Drwalpawel20](https://github.com/Drwalpawel20)

## Licencja

Projekt udostępniony bez określonej licencji. Aby umożliwić innym korzystanie z kodu, dodaj plik `LICENSE` (np. MIT).
