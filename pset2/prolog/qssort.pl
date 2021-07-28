/* inserts element in the end of the Queue */
insert_last(A,[],[A]).
insert_last(H, [QH|QREST], [QH|Res]):- insert_last(H,QREST, Res).

sorted([_]).
sorted([A,B|R]):- (=<(A,B)), sorted([B|R]),!.


move(([H|Qrest], Snow),'Q',(Qrest,[H|Snow])).
move((Qnow,[H|Srest]),'S',(Qnew,Srest)):- insert_last(H,Qnow,Qnew).

read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, N),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

solver(Q, 0, [],_):- sorted(Q),!.
solver(Qinit, X, Sinit,[Move|_]):-
    mod(X, 2) \= 0 -> fail
    ;move((Qinit,Sinit),Move,(Qnew,[])),
    sorted(Qnew),!.

solver(Qinit, _, Sinit, [Move|Path]):-
    move((Qinit,Sinit),Move,(Qnew,Snew)),
    length(Path,X),
    solver(Qnew, X, Snew,Path),!.

qssort(File,Answer):- read_input(File,_,Qinit),sorted(Qinit), Answer = 'empty',!.
qssort(File,Answer):- read_input(File, _, Qinit), solver(Qinit, _, [],Best),!,
atomics_to_string(Best, Answer).
