# Projekt FLP
#### Varianta: Kostra grafu
#### Vypracoval: Dominik Švač (xsvacd00)

## Preklad a spustenie

```
make - preloží sa program
./flp20-log - spustí sa program
```

### Vsutp
Program číta vstup zo stdin, kde sa očakáva, že uživateľ zadá graf, v ktorom chce nájsť všetky kostry grafu

Program spracováva riadky, ktoré sú v tvare:
```
<UzolA> <UzolB> 
```
Pričom jeden riadok znázornuje jednu cestu v grafe, ostatné riadky ignoruje.

Ignoruje:
* Hrany, ktoré majú začiatok aj koniec rovnaký ako (A A) alebo (B B)
* Hrany, ktoré už raz boli zadané
## Príklady vstupu a výstupu
### Vstup
```
A B
A C
C D
B D
```

### Výstup
```
A-B A-C C-D
A-B A-C B-D
A-B B-D C-D
A-C B-D C-D

```

## Čas pri určitých vstupoch
Čas sa meral pomocou príkazu time na pc s procesorom Intel(R) Core(TM) i5-8300H CPU @ 2.30GHz, čas je v sekundách

Súbory sú umiestnené v zložke ./tests 
* test1.in - 0.028s
* test2.in - 0.027s
* test3.in - 0.027s
* test4.in - 0.027s
* test5.in - 0.028s
* test6.in - 0.027s
* test7.in - 0.027s
* test8.in - 0.028s
* test9.in - 0.037s
* test10.in - 0.033s
* test11.in - 0.031s
* test12.in - 0.028s
* test13.in - 0.096s

## Automatické testy
Automatické testy sa spúštaju nasledovne:

```
./test.sh [program] [testy]
./test.sh flp20-log ./tests/ - spustia sa automatické testy
```
pričom parameter [program] je názor programu, ktorý sa bude testovať a [testy] je cesta ku položke, kde sú umiestené testy
