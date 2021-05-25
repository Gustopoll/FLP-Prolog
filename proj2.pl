/** FLP 2. projekt: Kostra grafu **/
/** Vypracoval: Dominik Švač (xsvacd00) **/

/* ukladajú sa tu načítané cesty zo vsupu */
:- dynamic path/2.

/* pomocný predekát na ukladanie podgrafov, ktoré sa už vypísali */
:- dynamic iwashere/1.


/** Načítanie vstupu **/
/***********************/
/***********************/

/** cte radky ze standardniho vstupu, konci na LF nebo EOF */
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).

/** testuje znak na EOF nebo LF */
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).

read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).

/***********************/
/***********************/

/** získa n-tý znak z poľa **/
get_nth_char([],_,_) :- !, false.
get_nth_char([_|T],N,Out) :-
    NN is N-1,
    NN > 0, !, get_nth_char(T,NN,Out).
get_nth_char([H|_],N,H) :-
    NN is N-1,
    NN == 0, !.


/** kontrola vstupu **/
/* riadok musí byť v tvare [A-Z] [A-Z], pričom jeden riadok odpevedá jednej hrane vstpuného grafu */
/* hrany, ktoré už raz boli zadané sa igonrujú a  takisto sa ignorujú hrany, ktoré idú sami do seba ako (A A) alebo (B B) */
/* zároveň sa vložía všetky hrany do predikátu path/2 */
check_lines([]).
check_lines([H|T]) :-
    get_nth_char(H,1,First), First @>= 'A', First @=< 'Z',
    get_nth_char(H,2,Second), Second == ' ',
    get_nth_char(H,3,Third), Third @>= 'A', Third @=< 'Z',
    not(get_nth_char(H,4,_)),
    First \= Third,
    \+ path(First,Third),
    \+ path(Third,First),
    assert(path(First,Third)),
    check_lines(T).
check_lines([_|T]) :- check_lines(T).


/** spojí dve premenné, či už pole alebo prvok do pola **/
concatenate(A,B,L) :- not(is_list(A)), not(is_list(B)), !, L = [A,B].
concatenate(A,B,L) :- not(is_list(A)),!, L = [A|B].
concatenate(A,B,L) :- not(is_list(B)),!, L = [B|A].
concatenate([],X,X) :- !.
concatenate([X|S],Z,[X|L]) :- concatenate(S,Z,L).

/** do L vloží všetky uzly z grafu **/
allNode(L) :- setof(Y,X^path(X,Y),V), setof(Y,X^path(Y,X),E), concatenate(V,E,LL), sort(LL,L).

/** nájde všetkých susedov L uzla X **/
neighbour(X,L) :- findall(Y,path(X,Y),V), findall(Y,path(Y,X),E),!, concatenate(V,E,LL), sort(LL,L).
neighbour(X,L) :- findall(Y,path(Y,X),E), findall(Y,path(X,Y),V),!, concatenate(V,E,LL), sort(LL,L).

/** nájde všetky uzly, do ktorých sa dá dostať z počiatočného uzlu X **/
allNeighbourNode([],Close,Close) :- !, true.
allNeighbourNode([H|T],Close,Result) :- 
    !, neighbour(H,New_neighbour),
    concatenate(H,Close,Final), concatenate(T,New_neighbour,Sn), sort(Sn,StillN), subtract(StillN,Close,StillNot),
    allNeighbourNode(StillNot,Final,Result).

allNeighbourNode(X,Close,Result) :- 
    neighbour(X,New_neighbour),
    concatenate(X,Close,Fin), sort(Fin,Final),
    allNeighbourNode(New_neighbour,Final,Result).

/** porovná dve polia či sú rovnaké **/
same(L1,L2) :-
    sort(L1,L1Sorted), sort(L2,L2Sorted),
    !, maplist(=,L1Sorted,L2Sorted).

/** kontrola či je graf spojitý **/
testContinuousGraph :-
    path(X,_),
    !, allNeighbourNode(X,[],Out),
    allNode(All),
    same(Out,All).

/** kontrola hrán **/
test(_,[]) :- !, fail.
test(X,[A:_|_]) :- A == X, !.
test(X,[_:B|_]) :- B == X, !.
test(X,[_|T]) :- test(X,T).

/** test, či sa dá použiť hrana (X-Y), Close obsahuje už vložené hrany **/
test(_,_,Close) :- Close == [], !.
test(X,Y,Close) :- \+ test(X,Close), test(Y,Close), !.
test(X,Y,Close) :- \+ test(Y,Close), test(X,Close), !.

/** nájde jeden podgraf zadanej dĺžky**/
skeletOne(L,Tmp,Result) :-
    LL is L-1, L \= 0,
    path(X,Y),
    test(X,Y,Tmp),
    skeletOne(LL,[X:Y|Tmp],Result).

skeletOne(0,Result,Result).

/** vypíše jeden riadok (jeden podgraf) **/
writeOneLine([A:B|[]]) :- !, write(A), write('-'),write(B), write_ln('').
writeOneLine([A:B|T]) :- write(A), write('-'),write(B), write(' '), writeOneLine(T).

/** vypíše všetky podgrafy dĺžky (počet uzlov -1), zároven sa kontroluje dupicita **/
skelet :-
    allNode(All), length(All,Ln), Len is Ln-1, 
    skeletOne(Len,[],Result), sort(Result,SortedResult),
    findall(X,iwashere(X),L), \+ member(SortedResult,L),
    assert(iwashere(SortedResult)), writeOneLine(SortedResult), false.

skelet :- retract(iwashere(_)), false.
skelet.

cleanPath :- retract(path(_,_)), false.
cleanPath. 

/**MAIN**/
start :-
    prompt(_, ''),
    read_lines(LL),
    check_lines(LL),
    !, testContinuousGraph,
    skelet,
    cleanPath,
    !, fail.
