max(A, B, A):- >=(A, B),!.
max(A, B, B):- B>A,!.

transform(X, Hosp, Y):- Y is X*(-1) - Hosp.

/*Dn is a counter for the prefix sum I just computed
 *Dnew holds the length of prefix sum that satisfied our condition
 */
summa([],_, _, A, A, []):- !.
summa([H|Rest], SUM, D, _, A, [N|R]):- N is SUM + H, N>0, Dn is D+1,
    summa(Rest,  N, Dn,  Dn, A, R),!.

summa([H|Rest], SUM, D, Dnew,  A, [N|R]):-N is SUM + H, Dn is D+1,
    summa(Rest, N ,Dn, Dnew, A,  R),!.

min(A,B,A):- \+A>B,!.
min(A,B,B):- B<A,!.

leftmin([_,B],[C,X]):- min(B,C,X).
leftmin([_,T|R],[A,B|C]):- min(T,A,B), leftmin([T|R], [B|C]).

/* rightmax(prefix[], rightmax[]) */
rightmax([A,B],[C,B]):- max(A,B,C).
rightmax([A,B|C], [D,Q|E]):-rightmax([B|C],[Q|E]),
 max(Q,A,D),!.

max_delta([],_,_,_,M,M).
max_delta(_,[],_,_,M,M).

max_delta([R|RIGHT], [L|LEFT], I, J, D, Delta):-
    L<R, DIF is J-I, Jnew is J+1,
    max(D, DIF, Dnew), max_delta(RIGHT, [L|LEFT], I, Jnew, Dnew, Delta), !.

max_delta([R|RIGHT], [_|LEFT],I, J, D, Delta):- Inew is I+1,
    max_delta([R|RIGHT], LEFT, Inew, J, D, Delta),!.

 read_input(File, N, K, C) :-
     open(File, read, Stream),
     read_line(Stream, [N,K]),
     read_line(Stream, C).

 read_line(Stream, L) :-
     read_line_to_codes(Stream, Line),
     atom_codes(Atom, Line),
     atomic_list_concat(Atoms, ' ', Atom),
     maplist(atom_number, Atoms, L).

 longest(File, LONGEST):-  read_input(File, N, K, INPUT), length(X,N), maplist(=(K),X),
  maplist(transform,INPUT,X,T), summa(T, 0, 0, 0, D, [P|PREF]),rightmax([P|PREF], RIGHT),
  max_delta(RIGHT, [P|PREF], 0, 0, D, LONGEST),!.
