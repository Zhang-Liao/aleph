/*
To run do 'induce'
*/
/** <examples>
?- induce(Program).
*/
:- use_module(library(aleph)).
:- use_module(library(dialect/xsb/setof)).

:- if(current_predicate(use_rendering/1)).
:- use_rendering(prolog).
:- endif.
:- aleph.
:- aleph_set(construct_bottom, false).
:- aleph_set(refine, user).

:-begin_bg.
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

refine(aleph_false, (grandparent(_, _) :- true)).

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

:-end_bg.