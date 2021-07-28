/* finds max distance and sum of distances from town 0 */
create_dist([],_,_,Max, Max, Sum, Sum):- !.
create_dist([0|Fr], I, N, Maxi, Max, Summa, Sum):-
     J is I+1,
     create_dist(Fr, J, N, Maxi, Max, Summa, Sum),!.
create_dist([F|Fr], I, N, Maxi, Max, Summa, Sum):-
     J is I+1, D is N-I,
     NSumma is Summa + F*D, NMaxi is max(D,Maxi),
     create_dist(Fr, J, N, NMaxi ,Max, NSumma, Sum),!.


/* case1: first time we find a car when the counter is on that */
/* case2: second time we find a car                          */
/* case3: we find a car in a pos>counter : if pos = counter + 1 then we
   just found the first car in the next town
   else if pos>counter+1, counter+1 has no car */

freqs([],I, N, A, [A|R]):-  Rest is N-I-1, length(R, Rest), maplist(=(0), R),!.
freqs([I|Carpos], I, N, A, Freqs):-
    NewA is A+1, freqs(Carpos, I, N, NewA, Freqs),!.
freqs([C|Carpos], I, N, A, [A,0|Freqs]):-
  C>I+1, NewI is I+2,
  freqs([C|Carpos], NewI, N, 0, Freqs),!.
freqs([C|Carpos], I, N, A, [A|Freqs]):-
  C is I+1,  NewI is I+1,
  freqs(Carpos, NewI, N, 1, Freqs),!.

find_next([],S,_,S).
find_next([0|R], S, I, Res):- New is I+1, find_next(R, S, New, Res),!.
find_next([T|_], _, I, I):-T>0, !.

solver([], _, _, _, _, (_, _),_,  (MIN,Target), MIN, Target).
solver([F|Fr], S,  Cars, I, N, (_,I), SUM, (MINI,B), MIN, Target):-
     NSUM is  SUM + Cars - N*F, find_next(Fr, S, I, T),
     (T \= S -> NMax is I-T + N ; NMax is I-T),
     Next is I+1,
    (NSUM < MINI, NSUM - NMax >= NMax -1 ->
     solver(Fr, S, Cars, Next, N, (NMax, T), NSUM, (NSUM,I), MIN, Target),!
    ;solver(Fr, S, Cars, Next, N, (NMax, T), NSUM, (MINI,B), MIN, Target)
    ).
solver([F|Fr], S, Cars, I, N, (Max,T), SUM, (MINI,B), MIN, Target):- I\=T,
  NMax is Max + 1, NSUM is SUM+ Cars - N*F, Next is I+1,
  (NSUM < MINI, NSUM - NMax >= NMax -1->
      solver(Fr, S, Cars, Next, N, (NMax, T), NSUM, (NSUM,I), MIN, Target),!
    ; solver(Fr, S, Cars, Next, N, (NMax, T), NSUM, (MINI,B), MIN, Target),!
  ).


read_file(File,N,C, Carpos):-
      open(File,read,Stream),
      read_line(Stream,[N,C]),
      read_line(Stream, Carpos),
      close(Stream).

read_line(Stream,List):-
        read_line_to_codes(Stream,Line),
        atom_codes(A,Line),
        atomic_list_concat(As,' ',A),
        maplist(atom_number,As,List).

round(File, M, C):-
   read_file(File, N, Cars, Carpos),
   msort(Carpos,[S|SCarpos]),
   freqs([S|SCarpos], 0, N , 0, [_|Fr]),
   create_dist(Fr, 1, N, 0, Max, 0, Sum), T is N-Max,
   (Sum - Max >= Max -1 ->  solver(Fr, S, Cars, 1, N, (Max,T), Sum, (Sum,0), M, C),!
   ; (P is N*Cars, solver(Fr, S, Cars, 1, N, (Max,T), Sum, (P,-1), M, C))
   ),!.
