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

body_pred(mother).
body_pred(father).


refine(aleph_false, (grandparent(_, _) :- true)).
    % print('grandparent'), nl.

% refine(grandparent(X, Y), (mother())) :-
%     print('grandparent'), nl.

refine(grandparent(X, Y) :- Body1, Clause):-
    % print('mother'), nl,
    comma_list(Body1, Atoms),
    % print(atoms(Atoms)), nl,
    % input_vars(Atoms, BodyInputVars),
    % print(bodyInputVars(BodyInputVars)), nl,
    output_vars(Atoms, BodyOutputVars),
    member(Input, [X|BodyOutputVars]),
    % print(bodyOutputVars(BodyOutputVars)), nl,
    member(Output, [Y,_Z]),
    body_pred(P),
    NewAtom =.. [P, Input, Output],
    not(syn_member(NewAtom, Atoms)),
    % print(not(member(NewAtom, Atoms))), nl, nl,
    comma_list(Body2, [NewAtom| Atoms]),
    Clause = (grandparent(X, Y):- Body2).
    % print('add mother'), nl,
    % print(Clause), nl, nl.

:-end_bg.