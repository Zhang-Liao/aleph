% :- modeh(*,grandparent(+person,-person)).
% :- modeb(*,mother(+person,-person)).
% :- modeb(*,father(+person,-person)).

% :- determination(grandparent/2,father/2).
% :- determination(grandparent/2,mother/2).
% :- determination(grandparent/2,person/2).

:- set(construct_bottom, false).
:- set(refine, user).
% :- set(verbosity, 100).
:- set(search, ils).
% :- set(evalfn, accuracy).
% :- set(openlist, 1).

syn_member(X, [Y | _]) :- X == Y.
syn_member(X, [_ | Tl]) :- syn_member(X, Tl).

input_vars_aux([], []).

input_vars_aux([H|Tl], Vars) :-
    H == true, !,
    input_vars_aux(Tl, Vars).

input_vars_aux([H|Tl], [V|Vars]) :-
    H = grandparent(V, _), !,
    input_vars_aux(Tl, Vars).

input_vars_aux([H|Tl], [V|Vars]) :-
    body_pred(P),
    H =.. [P, _, V], !,
    input_vars_aux(Tl, Vars).

input_vars(List, Vars):-
    input_vars_aux(List, VarsDup),
    term_variables(VarsDup, Vars).

output_vars_aux([], []).

output_vars_aux([H|Tl], Vars) :-
    H = true, !,
    output_vars_aux(Tl, Vars).

output_vars_aux([H|Tl], [V|Vars]) :-
    H = grandparent(_, V), !,
    output_vars_aux(Tl, Vars).

output_vars_aux([H|Tl], [V|Vars]) :-
    body_pred(P),
    H =.. [P, _, V], !,
    output_vars_aux(Tl, Vars).

output_vars(List, Vars):-
    output_vars_aux(List, VarsDup),
    term_variables(VarsDup, Vars).

body_pred(mother).
body_pred(father).

refine(false, (grandparent(_, _) :- true)).

refine(grandparent(X, Y) :- Body1, Clause):-
    comma_list(Body1, Atoms),
    output_vars(Atoms, BodyOutputVars),
    member(Input, [X|BodyOutputVars]),
    member(Output, [Y,_Z]),
    body_pred(P),
    NewAtom =.. [P, Input, Output],
    not(syn_member(NewAtom, Atoms)),
    comma_list(Body2, [NewAtom| Atoms]),
    Clause = (grandparent(X, Y):- Body2).

% prune(grandparent(A, B) :- _) :- nonvar(A), nonvar(B).
% prune(grandparent(A, B)) :- nonvar(A), nonvar(B).
% prune(grandparent(_, bob)).

person(bob).
person(dad(bob)).
person(mum(bob)).
person(dad(dad(bob))).
person(dad(mum(bob))).
person(mum(dad(bob))).
person(mum(mum(bob))).

person(jo).
person(dad(jo)).
person(mum(jo)).
person(dad(dad(jo))).
person(dad(mum(jo))).
person(mum(dad(jo))).
person(mum(mum(jo))).

person(peter).
person(dad(peter)).
person(mum(peter)).
person(dad(dad(peter))).
person(dad(mum(peter))).
person(mum(dad(peter))).
person(mum(mum(peter))).

person(jane).
person(dad(jane)).
person(mum(jane)).
person(dad(dad(jane))).
person(dad(mum(jane))).
person(mum(dad(jane))).
person(mum(mum(jane))).

father(dad(X),X):-
   person(X).
mother(mum(X),X):-
   person(X).