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
% :- modeh(*,grandparent(+person,-person)).
% :- modeh(*,parent(+person,-person)).

% :- modeb(*,mother(+person,-person)).
% :- modeb(*,father(+person,-person)).
% :- modeb(*,parent(+person,-person)).

% :- determination(grandparent/2,father/2).
% :- determination(grandparent/2,parent/2).
% :- determination(grandparent/2,mother/2).

:-dynamic grandparent/2.
:-begin_bg.
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

input_vars_aux([], []).

input_vars_aux([H|Tl], Vars) :-
    H == true, !,
    input_vars_aux(Tl, Vars).

input_vars_aux([H|Tl], [V|Vars]) :-
    H = grandparent(V, _), !,
    input_vars_aux(Tl, Vars).

input_vars_aux([H|Tl], [V|Vars]) :-
    H = father(V, _), !,
    input_vars_aux(Tl, Vars).
input_vars_aux([H|Tl], [V|Vars]) :-
    H = mother(V, _), !,
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
    H = father(_, V), !,
    output_vars_aux(Tl, Vars).
output_vars_aux([H|Tl], [V|Vars]) :-
    H = mother(_, V), !,
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
    member(Output, [Y,Z]),
    body_pred(P),
    NewAtom =.. [P, Input, Output],
    % print(P), nl,
    comma_list(Body2, [NewAtom| Atoms]),
    Clause = (grandparent(X, Y):- Body2).
    % print('add mother'), nl,
    % print(Clause), nl, nl.

% refine(grandparent(X, Y) :- Body1, Clause):-
    % print('father'), nl,
    % comma_list(Body1, Atoms),
    % output_vars(Atoms, BodyOutputVars),
    % input_vars(Atoms, BodyInputVars),
    % member(Input, [X|BodyOutputVars]),
    % member(Output, [Y,Z]),
    % P =.. [father, Input, Output],
    % comma_list(Body2, [P| Atoms]),
    % Clause = (grandparent(X, Y):- Body2).

:-end_bg.
:-begin_in_pos.

grandparent(dad(dad(bob)),bob).
grandparent(dad(mum(bob)),bob).
grandparent(mum(dad(bob)),bob).
grandparent(mum(mum(bob)),bob).
grandparent(dad(dad(jo)),jo).
grandparent(dad(mum(jo)),jo).
grandparent(mum(dad(jo)),jo).
grandparent(mum(mum(jo)),jo).
grandparent(dad(dad(peter)),peter).
grandparent(dad(mum(peter)),peter).
grandparent(mum(dad(peter)),peter).
grandparent(mum(mum(peter)),peter).
grandparent(dad(dad(jane)),jane).
grandparent(dad(mum(jane)),jane).
grandparent(mum(dad(jane)),jane).
grandparent(mum(mum(jane)),jane).
:-end_in_pos.
:-begin_in_neg.
grandparent(bob,bob).
grandparent(bob,dad(bob)).
grandparent(bob,mum(bob)).
grandparent(bob,dad(dad(bob))).
grandparent(bob,dad(mum(bob))).
grandparent(bob,mum(dad(bob))).
grandparent(bob,mum(mum(bob))).
grandparent(bob,jo).
grandparent(bob,dad(jo)).
grandparent(bob,mum(jo)).
grandparent(bob,dad(dad(jo))).
grandparent(bob,dad(mum(jo))).
grandparent(bob,mum(dad(jo))).
grandparent(bob,mum(mum(jo))).
grandparent(bob,peter).
grandparent(bob,dad(peter)).
grandparent(bob,mum(peter)).
grandparent(bob,dad(dad(peter))).
grandparent(bob,dad(mum(peter))).
grandparent(bob,mum(dad(peter))).
grandparent(bob,mum(mum(peter))).
grandparent(bob,jane).
grandparent(bob,dad(jane)).
grandparent(bob,mum(jane)).
grandparent(bob,dad(dad(jane))).
grandparent(bob,dad(mum(jane))).
grandparent(bob,mum(dad(jane))).
grandparent(bob,mum(mum(jane))).
grandparent(dad(bob),bob).
grandparent(dad(bob),dad(bob)).
grandparent(dad(bob),mum(bob)).
grandparent(dad(bob),dad(dad(bob))).
grandparent(dad(bob),dad(mum(bob))).
grandparent(dad(bob),mum(dad(bob))).
grandparent(dad(bob),mum(mum(bob))).
grandparent(dad(bob),jo).
grandparent(dad(bob),dad(jo)).
grandparent(dad(bob),mum(jo)).
grandparent(dad(bob),dad(dad(jo))).
grandparent(dad(bob),dad(mum(jo))).
grandparent(dad(bob),mum(dad(jo))).
grandparent(dad(bob),mum(mum(jo))).
grandparent(dad(bob),peter).
grandparent(dad(bob),dad(peter)).
grandparent(dad(bob),mum(peter)).
grandparent(dad(bob),dad(dad(peter))).
grandparent(dad(bob),dad(mum(peter))).
grandparent(dad(bob),mum(dad(peter))).
grandparent(dad(bob),mum(mum(peter))).
grandparent(dad(bob),jane).
grandparent(dad(bob),dad(jane)).
grandparent(dad(bob),mum(jane)).
grandparent(dad(bob),dad(dad(jane))).
grandparent(dad(bob),dad(mum(jane))).
grandparent(dad(bob),mum(dad(jane))).
grandparent(dad(bob),mum(mum(jane))).
grandparent(mum(bob),bob).
grandparent(mum(bob),dad(bob)).
grandparent(mum(bob),mum(bob)).
grandparent(mum(bob),dad(dad(bob))).
grandparent(mum(bob),dad(mum(bob))).
grandparent(mum(bob),mum(dad(bob))).
grandparent(mum(bob),mum(mum(bob))).
grandparent(mum(bob),jo).
grandparent(mum(bob),dad(jo)).
grandparent(mum(bob),mum(jo)).
grandparent(mum(bob),dad(dad(jo))).
grandparent(mum(bob),dad(mum(jo))).
grandparent(mum(bob),mum(dad(jo))).
grandparent(mum(bob),mum(mum(jo))).
grandparent(mum(bob),peter).
grandparent(mum(bob),dad(peter)).
grandparent(mum(bob),mum(peter)).
grandparent(mum(bob),dad(dad(peter))).
grandparent(mum(bob),dad(mum(peter))).
grandparent(mum(bob),mum(dad(peter))).
grandparent(mum(bob),mum(mum(peter))).
grandparent(mum(bob),jane).
grandparent(mum(bob),dad(jane)).
grandparent(mum(bob),mum(jane)).
grandparent(mum(bob),dad(dad(jane))).
grandparent(mum(bob),dad(mum(jane))).
grandparent(mum(bob),mum(dad(jane))).
grandparent(mum(bob),mum(mum(jane))).
grandparent(dad(dad(bob)),dad(bob)).
grandparent(dad(dad(bob)),mum(bob)).
grandparent(dad(dad(bob)),dad(dad(bob))).
grandparent(dad(dad(bob)),dad(mum(bob))).
grandparent(dad(dad(bob)),mum(dad(bob))).
grandparent(dad(dad(bob)),mum(mum(bob))).
grandparent(dad(dad(bob)),jo).
grandparent(dad(dad(bob)),dad(jo)).
grandparent(dad(dad(bob)),mum(jo)).
grandparent(dad(dad(bob)),dad(dad(jo))).
grandparent(dad(dad(bob)),dad(mum(jo))).
grandparent(dad(dad(bob)),mum(dad(jo))).
grandparent(dad(dad(bob)),mum(mum(jo))).
grandparent(dad(dad(bob)),peter).
grandparent(dad(dad(bob)),dad(peter)).
grandparent(dad(dad(bob)),mum(peter)).
grandparent(dad(dad(bob)),dad(dad(peter))).
grandparent(dad(dad(bob)),dad(mum(peter))).
grandparent(dad(dad(bob)),mum(dad(peter))).
grandparent(dad(dad(bob)),mum(mum(peter))).
grandparent(dad(dad(bob)),jane).
grandparent(dad(dad(bob)),dad(jane)).
grandparent(dad(dad(bob)),mum(jane)).
grandparent(dad(dad(bob)),dad(dad(jane))).
grandparent(dad(dad(bob)),dad(mum(jane))).
grandparent(dad(dad(bob)),mum(dad(jane))).
grandparent(dad(dad(bob)),mum(mum(jane))).
grandparent(dad(mum(bob)),dad(bob)).
grandparent(dad(mum(bob)),mum(bob)).
grandparent(dad(mum(bob)),dad(dad(bob))).
grandparent(dad(mum(bob)),dad(mum(bob))).
grandparent(dad(mum(bob)),mum(dad(bob))).
grandparent(dad(mum(bob)),mum(mum(bob))).
grandparent(dad(mum(bob)),jo).
grandparent(dad(mum(bob)),dad(jo)).
grandparent(dad(mum(bob)),mum(jo)).
grandparent(dad(mum(bob)),dad(dad(jo))).
grandparent(dad(mum(bob)),dad(mum(jo))).
grandparent(dad(mum(bob)),mum(dad(jo))).
grandparent(dad(mum(bob)),mum(mum(jo))).
grandparent(dad(mum(bob)),peter).
grandparent(dad(mum(bob)),dad(peter)).
grandparent(dad(mum(bob)),mum(peter)).
grandparent(dad(mum(bob)),dad(dad(peter))).
grandparent(dad(mum(bob)),dad(mum(peter))).
grandparent(dad(mum(bob)),mum(dad(peter))).
grandparent(dad(mum(bob)),mum(mum(peter))).
grandparent(dad(mum(bob)),jane).
grandparent(dad(mum(bob)),dad(jane)).
grandparent(dad(mum(bob)),mum(jane)).
grandparent(dad(mum(bob)),dad(dad(jane))).
grandparent(dad(mum(bob)),dad(mum(jane))).
grandparent(dad(mum(bob)),mum(dad(jane))).
grandparent(dad(mum(bob)),mum(mum(jane))).
grandparent(mum(dad(bob)),dad(bob)).
grandparent(mum(dad(bob)),mum(bob)).
grandparent(mum(dad(bob)),dad(dad(bob))).
grandparent(mum(dad(bob)),dad(mum(bob))).
grandparent(mum(dad(bob)),mum(dad(bob))).
grandparent(mum(dad(bob)),mum(mum(bob))).
grandparent(mum(dad(bob)),jo).
grandparent(mum(dad(bob)),dad(jo)).
grandparent(mum(dad(bob)),mum(jo)).
grandparent(mum(dad(bob)),dad(dad(jo))).
grandparent(mum(dad(bob)),dad(mum(jo))).
grandparent(mum(dad(bob)),mum(dad(jo))).
grandparent(mum(dad(bob)),mum(mum(jo))).
grandparent(mum(dad(bob)),peter).
grandparent(mum(dad(bob)),dad(peter)).
grandparent(mum(dad(bob)),mum(peter)).
grandparent(mum(dad(bob)),dad(dad(peter))).
grandparent(mum(dad(bob)),dad(mum(peter))).
grandparent(mum(dad(bob)),mum(dad(peter))).
grandparent(mum(dad(bob)),mum(mum(peter))).
grandparent(mum(dad(bob)),jane).
grandparent(mum(dad(bob)),dad(jane)).
grandparent(mum(dad(bob)),mum(jane)).
grandparent(mum(dad(bob)),dad(dad(jane))).
grandparent(mum(dad(bob)),dad(mum(jane))).
grandparent(mum(dad(bob)),mum(dad(jane))).
grandparent(mum(dad(bob)),mum(mum(jane))).
grandparent(mum(mum(bob)),dad(bob)).
grandparent(mum(mum(bob)),mum(bob)).
grandparent(mum(mum(bob)),dad(dad(bob))).
grandparent(mum(mum(bob)),dad(mum(bob))).
grandparent(mum(mum(bob)),mum(dad(bob))).
grandparent(mum(mum(bob)),mum(mum(bob))).
grandparent(mum(mum(bob)),jo).
grandparent(mum(mum(bob)),dad(jo)).
grandparent(mum(mum(bob)),mum(jo)).
grandparent(mum(mum(bob)),dad(dad(jo))).
grandparent(mum(mum(bob)),dad(mum(jo))).
grandparent(mum(mum(bob)),mum(dad(jo))).
grandparent(mum(mum(bob)),mum(mum(jo))).
grandparent(mum(mum(bob)),peter).
grandparent(mum(mum(bob)),dad(peter)).
grandparent(mum(mum(bob)),mum(peter)).
grandparent(mum(mum(bob)),dad(dad(peter))).
grandparent(mum(mum(bob)),dad(mum(peter))).
grandparent(mum(mum(bob)),mum(dad(peter))).
grandparent(mum(mum(bob)),mum(mum(peter))).
grandparent(mum(mum(bob)),jane).
grandparent(mum(mum(bob)),dad(jane)).
grandparent(mum(mum(bob)),mum(jane)).
grandparent(mum(mum(bob)),dad(dad(jane))).
grandparent(mum(mum(bob)),dad(mum(jane))).
grandparent(mum(mum(bob)),mum(dad(jane))).
grandparent(mum(mum(bob)),mum(mum(jane))).
grandparent(jo,bob).
grandparent(jo,dad(bob)).
grandparent(jo,mum(bob)).
grandparent(jo,dad(dad(bob))).
grandparent(jo,dad(mum(bob))).
grandparent(jo,mum(dad(bob))).
grandparent(jo,mum(mum(bob))).
grandparent(jo,jo).
grandparent(jo,dad(jo)).
grandparent(jo,mum(jo)).
grandparent(jo,dad(dad(jo))).
grandparent(jo,dad(mum(jo))).
grandparent(jo,mum(dad(jo))).
grandparent(jo,mum(mum(jo))).
grandparent(jo,peter).
grandparent(jo,dad(peter)).
grandparent(jo,mum(peter)).
grandparent(jo,dad(dad(peter))).
grandparent(jo,dad(mum(peter))).
grandparent(jo,mum(dad(peter))).
grandparent(jo,mum(mum(peter))).
grandparent(jo,jane).
grandparent(jo,dad(jane)).
grandparent(jo,mum(jane)).
grandparent(jo,dad(dad(jane))).
grandparent(jo,dad(mum(jane))).
grandparent(jo,mum(dad(jane))).
grandparent(jo,mum(mum(jane))).
grandparent(dad(jo),bob).
grandparent(dad(jo),dad(bob)).
grandparent(dad(jo),mum(bob)).
grandparent(dad(jo),dad(dad(bob))).
grandparent(dad(jo),dad(mum(bob))).
grandparent(dad(jo),mum(dad(bob))).
grandparent(dad(jo),mum(mum(bob))).
grandparent(dad(jo),jo).
grandparent(dad(jo),dad(jo)).
grandparent(dad(jo),mum(jo)).
grandparent(dad(jo),dad(dad(jo))).
grandparent(dad(jo),dad(mum(jo))).
grandparent(dad(jo),mum(dad(jo))).
grandparent(dad(jo),mum(mum(jo))).
grandparent(dad(jo),peter).
grandparent(dad(jo),dad(peter)).
grandparent(dad(jo),mum(peter)).
grandparent(dad(jo),dad(dad(peter))).
grandparent(dad(jo),dad(mum(peter))).
grandparent(dad(jo),mum(dad(peter))).
grandparent(dad(jo),mum(mum(peter))).
grandparent(dad(jo),jane).
grandparent(dad(jo),dad(jane)).
grandparent(dad(jo),mum(jane)).
grandparent(dad(jo),dad(dad(jane))).
grandparent(dad(jo),dad(mum(jane))).
grandparent(dad(jo),mum(dad(jane))).
grandparent(dad(jo),mum(mum(jane))).
grandparent(mum(jo),bob).
grandparent(mum(jo),dad(bob)).
grandparent(mum(jo),mum(bob)).
grandparent(mum(jo),dad(dad(bob))).
grandparent(mum(jo),dad(mum(bob))).
grandparent(mum(jo),mum(dad(bob))).
grandparent(mum(jo),mum(mum(bob))).
grandparent(mum(jo),jo).
grandparent(mum(jo),dad(jo)).
grandparent(mum(jo),mum(jo)).
grandparent(mum(jo),dad(dad(jo))).
grandparent(mum(jo),dad(mum(jo))).
grandparent(mum(jo),mum(dad(jo))).
grandparent(mum(jo),mum(mum(jo))).
grandparent(mum(jo),peter).
grandparent(mum(jo),dad(peter)).
grandparent(mum(jo),mum(peter)).
grandparent(mum(jo),dad(dad(peter))).
grandparent(mum(jo),dad(mum(peter))).
grandparent(mum(jo),mum(dad(peter))).
grandparent(mum(jo),mum(mum(peter))).
grandparent(mum(jo),jane).
grandparent(mum(jo),dad(jane)).
grandparent(mum(jo),mum(jane)).
grandparent(mum(jo),dad(dad(jane))).
grandparent(mum(jo),dad(mum(jane))).
grandparent(mum(jo),mum(dad(jane))).
grandparent(mum(jo),mum(mum(jane))).
grandparent(dad(dad(jo)),bob).
grandparent(dad(dad(jo)),dad(bob)).
grandparent(dad(dad(jo)),mum(bob)).
grandparent(dad(dad(jo)),dad(dad(bob))).
grandparent(dad(dad(jo)),dad(mum(bob))).
grandparent(dad(dad(jo)),mum(dad(bob))).
grandparent(dad(dad(jo)),mum(mum(bob))).
grandparent(dad(dad(jo)),dad(jo)).
grandparent(dad(dad(jo)),mum(jo)).
grandparent(dad(dad(jo)),dad(dad(jo))).
grandparent(dad(dad(jo)),dad(mum(jo))).
grandparent(dad(dad(jo)),mum(dad(jo))).
grandparent(dad(dad(jo)),mum(mum(jo))).
grandparent(dad(dad(jo)),peter).
grandparent(dad(dad(jo)),dad(peter)).
grandparent(dad(dad(jo)),mum(peter)).
grandparent(dad(dad(jo)),dad(dad(peter))).
grandparent(dad(dad(jo)),dad(mum(peter))).
grandparent(dad(dad(jo)),mum(dad(peter))).
grandparent(dad(dad(jo)),mum(mum(peter))).
grandparent(dad(dad(jo)),jane).
grandparent(dad(dad(jo)),dad(jane)).
grandparent(dad(dad(jo)),mum(jane)).
grandparent(dad(dad(jo)),dad(dad(jane))).
grandparent(dad(dad(jo)),dad(mum(jane))).
grandparent(dad(dad(jo)),mum(dad(jane))).
grandparent(dad(dad(jo)),mum(mum(jane))).
grandparent(dad(mum(jo)),bob).
grandparent(dad(mum(jo)),dad(bob)).
grandparent(dad(mum(jo)),mum(bob)).
grandparent(dad(mum(jo)),dad(dad(bob))).
grandparent(dad(mum(jo)),dad(mum(bob))).
grandparent(dad(mum(jo)),mum(dad(bob))).
grandparent(dad(mum(jo)),mum(mum(bob))).
grandparent(dad(mum(jo)),dad(jo)).
grandparent(dad(mum(jo)),mum(jo)).
grandparent(dad(mum(jo)),dad(dad(jo))).
grandparent(dad(mum(jo)),dad(mum(jo))).
grandparent(dad(mum(jo)),mum(dad(jo))).
grandparent(dad(mum(jo)),mum(mum(jo))).
grandparent(dad(mum(jo)),peter).
grandparent(dad(mum(jo)),dad(peter)).
grandparent(dad(mum(jo)),mum(peter)).
grandparent(dad(mum(jo)),dad(dad(peter))).
grandparent(dad(mum(jo)),dad(mum(peter))).
grandparent(dad(mum(jo)),mum(dad(peter))).
grandparent(dad(mum(jo)),mum(mum(peter))).
grandparent(dad(mum(jo)),jane).
grandparent(dad(mum(jo)),dad(jane)).
grandparent(dad(mum(jo)),mum(jane)).
grandparent(dad(mum(jo)),dad(dad(jane))).
grandparent(dad(mum(jo)),dad(mum(jane))).
grandparent(dad(mum(jo)),mum(dad(jane))).
grandparent(dad(mum(jo)),mum(mum(jane))).
grandparent(mum(dad(jo)),bob).
grandparent(mum(dad(jo)),dad(bob)).
grandparent(mum(dad(jo)),mum(bob)).
grandparent(mum(dad(jo)),dad(dad(bob))).
grandparent(mum(dad(jo)),dad(mum(bob))).
grandparent(mum(dad(jo)),mum(dad(bob))).
grandparent(mum(dad(jo)),mum(mum(bob))).
grandparent(mum(dad(jo)),dad(jo)).
grandparent(mum(dad(jo)),mum(jo)).
grandparent(mum(dad(jo)),dad(dad(jo))).
grandparent(mum(dad(jo)),dad(mum(jo))).
grandparent(mum(dad(jo)),mum(dad(jo))).
grandparent(mum(dad(jo)),mum(mum(jo))).
grandparent(mum(dad(jo)),peter).
grandparent(mum(dad(jo)),dad(peter)).
grandparent(mum(dad(jo)),mum(peter)).
grandparent(mum(dad(jo)),dad(dad(peter))).
grandparent(mum(dad(jo)),dad(mum(peter))).
grandparent(mum(dad(jo)),mum(dad(peter))).
grandparent(mum(dad(jo)),mum(mum(peter))).
grandparent(mum(dad(jo)),jane).
grandparent(mum(dad(jo)),dad(jane)).
grandparent(mum(dad(jo)),mum(jane)).
grandparent(mum(dad(jo)),dad(dad(jane))).
grandparent(mum(dad(jo)),dad(mum(jane))).
grandparent(mum(dad(jo)),mum(dad(jane))).
grandparent(mum(dad(jo)),mum(mum(jane))).
grandparent(mum(mum(jo)),bob).
grandparent(mum(mum(jo)),dad(bob)).
grandparent(mum(mum(jo)),mum(bob)).
grandparent(mum(mum(jo)),dad(dad(bob))).
grandparent(mum(mum(jo)),dad(mum(bob))).
grandparent(mum(mum(jo)),mum(dad(bob))).
grandparent(mum(mum(jo)),mum(mum(bob))).
grandparent(mum(mum(jo)),dad(jo)).
grandparent(mum(mum(jo)),mum(jo)).
grandparent(mum(mum(jo)),dad(dad(jo))).
grandparent(mum(mum(jo)),dad(mum(jo))).
grandparent(mum(mum(jo)),mum(dad(jo))).
grandparent(mum(mum(jo)),mum(mum(jo))).
grandparent(mum(mum(jo)),peter).
grandparent(mum(mum(jo)),dad(peter)).
grandparent(mum(mum(jo)),mum(peter)).
grandparent(mum(mum(jo)),dad(dad(peter))).
grandparent(mum(mum(jo)),dad(mum(peter))).
grandparent(mum(mum(jo)),mum(dad(peter))).
grandparent(mum(mum(jo)),mum(mum(peter))).
grandparent(mum(mum(jo)),jane).
grandparent(mum(mum(jo)),dad(jane)).
grandparent(mum(mum(jo)),mum(jane)).
grandparent(mum(mum(jo)),dad(dad(jane))).
grandparent(mum(mum(jo)),dad(mum(jane))).
grandparent(mum(mum(jo)),mum(dad(jane))).
grandparent(mum(mum(jo)),mum(mum(jane))).
grandparent(peter,bob).
grandparent(peter,dad(bob)).
grandparent(peter,mum(bob)).
grandparent(peter,dad(dad(bob))).
grandparent(peter,dad(mum(bob))).
grandparent(peter,mum(dad(bob))).
grandparent(peter,mum(mum(bob))).
grandparent(peter,jo).
grandparent(peter,dad(jo)).
grandparent(peter,mum(jo)).
grandparent(peter,dad(dad(jo))).
grandparent(peter,dad(mum(jo))).
grandparent(peter,mum(dad(jo))).
grandparent(peter,mum(mum(jo))).
grandparent(peter,peter).
grandparent(peter,dad(peter)).
grandparent(peter,mum(peter)).
grandparent(peter,dad(dad(peter))).
grandparent(peter,dad(mum(peter))).
grandparent(peter,mum(dad(peter))).
grandparent(peter,mum(mum(peter))).
grandparent(peter,jane).
grandparent(peter,dad(jane)).
grandparent(peter,mum(jane)).
grandparent(peter,dad(dad(jane))).
grandparent(peter,dad(mum(jane))).
grandparent(peter,mum(dad(jane))).
grandparent(peter,mum(mum(jane))).
grandparent(dad(peter),bob).
grandparent(dad(peter),dad(bob)).
grandparent(dad(peter),mum(bob)).
grandparent(dad(peter),dad(dad(bob))).
grandparent(dad(peter),dad(mum(bob))).
grandparent(dad(peter),mum(dad(bob))).
grandparent(dad(peter),mum(mum(bob))).
grandparent(dad(peter),jo).
grandparent(dad(peter),dad(jo)).
grandparent(dad(peter),mum(jo)).
grandparent(dad(peter),dad(dad(jo))).
grandparent(dad(peter),dad(mum(jo))).
grandparent(dad(peter),mum(dad(jo))).
grandparent(dad(peter),mum(mum(jo))).
grandparent(dad(peter),peter).
grandparent(dad(peter),dad(peter)).
grandparent(dad(peter),mum(peter)).
grandparent(dad(peter),dad(dad(peter))).
grandparent(dad(peter),dad(mum(peter))).
grandparent(dad(peter),mum(dad(peter))).
grandparent(dad(peter),mum(mum(peter))).
grandparent(dad(peter),jane).
grandparent(dad(peter),dad(jane)).
grandparent(dad(peter),mum(jane)).
grandparent(dad(peter),dad(dad(jane))).
grandparent(dad(peter),dad(mum(jane))).
grandparent(dad(peter),mum(dad(jane))).
grandparent(dad(peter),mum(mum(jane))).
grandparent(mum(peter),bob).
grandparent(mum(peter),dad(bob)).
grandparent(mum(peter),mum(bob)).
grandparent(mum(peter),dad(dad(bob))).
grandparent(mum(peter),dad(mum(bob))).
grandparent(mum(peter),mum(dad(bob))).
grandparent(mum(peter),mum(mum(bob))).
grandparent(mum(peter),jo).
grandparent(mum(peter),dad(jo)).
grandparent(mum(peter),mum(jo)).
grandparent(mum(peter),dad(dad(jo))).
grandparent(mum(peter),dad(mum(jo))).
grandparent(mum(peter),mum(dad(jo))).
grandparent(mum(peter),mum(mum(jo))).
grandparent(mum(peter),peter).
grandparent(mum(peter),dad(peter)).
grandparent(mum(peter),mum(peter)).
grandparent(mum(peter),dad(dad(peter))).
grandparent(mum(peter),dad(mum(peter))).
grandparent(mum(peter),mum(dad(peter))).
grandparent(mum(peter),mum(mum(peter))).
grandparent(mum(peter),jane).
grandparent(mum(peter),dad(jane)).
grandparent(mum(peter),mum(jane)).
grandparent(mum(peter),dad(dad(jane))).
grandparent(mum(peter),dad(mum(jane))).
grandparent(mum(peter),mum(dad(jane))).
grandparent(mum(peter),mum(mum(jane))).
grandparent(dad(dad(peter)),bob).
grandparent(dad(dad(peter)),dad(bob)).
grandparent(dad(dad(peter)),mum(bob)).
grandparent(dad(dad(peter)),dad(dad(bob))).
grandparent(dad(dad(peter)),dad(mum(bob))).
grandparent(dad(dad(peter)),mum(dad(bob))).
grandparent(dad(dad(peter)),mum(mum(bob))).
grandparent(dad(dad(peter)),jo).
grandparent(dad(dad(peter)),dad(jo)).
grandparent(dad(dad(peter)),mum(jo)).
grandparent(dad(dad(peter)),dad(dad(jo))).
grandparent(dad(dad(peter)),dad(mum(jo))).
grandparent(dad(dad(peter)),mum(dad(jo))).
grandparent(dad(dad(peter)),mum(mum(jo))).
grandparent(dad(dad(peter)),dad(peter)).
grandparent(dad(dad(peter)),mum(peter)).
grandparent(dad(dad(peter)),dad(dad(peter))).
grandparent(dad(dad(peter)),dad(mum(peter))).
grandparent(dad(dad(peter)),mum(dad(peter))).
grandparent(dad(dad(peter)),mum(mum(peter))).
grandparent(dad(dad(peter)),jane).
grandparent(dad(dad(peter)),dad(jane)).
grandparent(dad(dad(peter)),mum(jane)).
grandparent(dad(dad(peter)),dad(dad(jane))).
grandparent(dad(dad(peter)),dad(mum(jane))).
grandparent(dad(dad(peter)),mum(dad(jane))).
grandparent(dad(dad(peter)),mum(mum(jane))).
grandparent(dad(mum(peter)),bob).
grandparent(dad(mum(peter)),dad(bob)).
grandparent(dad(mum(peter)),mum(bob)).
grandparent(dad(mum(peter)),dad(dad(bob))).
grandparent(dad(mum(peter)),dad(mum(bob))).
grandparent(dad(mum(peter)),mum(dad(bob))).
grandparent(dad(mum(peter)),mum(mum(bob))).
grandparent(dad(mum(peter)),jo).
grandparent(dad(mum(peter)),dad(jo)).
grandparent(dad(mum(peter)),mum(jo)).
grandparent(dad(mum(peter)),dad(dad(jo))).
grandparent(dad(mum(peter)),dad(mum(jo))).
grandparent(dad(mum(peter)),mum(dad(jo))).
grandparent(dad(mum(peter)),mum(mum(jo))).
grandparent(dad(mum(peter)),dad(peter)).
grandparent(dad(mum(peter)),mum(peter)).
grandparent(dad(mum(peter)),dad(dad(peter))).
grandparent(dad(mum(peter)),dad(mum(peter))).
grandparent(dad(mum(peter)),mum(dad(peter))).
grandparent(dad(mum(peter)),mum(mum(peter))).
grandparent(dad(mum(peter)),jane).
grandparent(dad(mum(peter)),dad(jane)).
grandparent(dad(mum(peter)),mum(jane)).
grandparent(dad(mum(peter)),dad(dad(jane))).
grandparent(dad(mum(peter)),dad(mum(jane))).
grandparent(dad(mum(peter)),mum(dad(jane))).
grandparent(dad(mum(peter)),mum(mum(jane))).
grandparent(mum(dad(peter)),bob).
grandparent(mum(dad(peter)),dad(bob)).
grandparent(mum(dad(peter)),mum(bob)).
grandparent(mum(dad(peter)),dad(dad(bob))).
grandparent(mum(dad(peter)),dad(mum(bob))).
grandparent(mum(dad(peter)),mum(dad(bob))).
grandparent(mum(dad(peter)),mum(mum(bob))).
grandparent(mum(dad(peter)),jo).
grandparent(mum(dad(peter)),dad(jo)).
grandparent(mum(dad(peter)),mum(jo)).
grandparent(mum(dad(peter)),dad(dad(jo))).
grandparent(mum(dad(peter)),dad(mum(jo))).
grandparent(mum(dad(peter)),mum(dad(jo))).
grandparent(mum(dad(peter)),mum(mum(jo))).
grandparent(mum(dad(peter)),dad(peter)).
grandparent(mum(dad(peter)),mum(peter)).
grandparent(mum(dad(peter)),dad(dad(peter))).
grandparent(mum(dad(peter)),dad(mum(peter))).
grandparent(mum(dad(peter)),mum(dad(peter))).
grandparent(mum(dad(peter)),mum(mum(peter))).
grandparent(mum(dad(peter)),jane).
grandparent(mum(dad(peter)),dad(jane)).
grandparent(mum(dad(peter)),mum(jane)).
grandparent(mum(dad(peter)),dad(dad(jane))).
grandparent(mum(dad(peter)),dad(mum(jane))).
grandparent(mum(dad(peter)),mum(dad(jane))).
grandparent(mum(dad(peter)),mum(mum(jane))).
grandparent(mum(mum(peter)),bob).
grandparent(mum(mum(peter)),dad(bob)).
grandparent(mum(mum(peter)),mum(bob)).
grandparent(mum(mum(peter)),dad(dad(bob))).
grandparent(mum(mum(peter)),dad(mum(bob))).
grandparent(mum(mum(peter)),mum(dad(bob))).
grandparent(mum(mum(peter)),mum(mum(bob))).
grandparent(mum(mum(peter)),jo).
grandparent(mum(mum(peter)),dad(jo)).
grandparent(mum(mum(peter)),mum(jo)).
grandparent(mum(mum(peter)),dad(dad(jo))).
grandparent(mum(mum(peter)),dad(mum(jo))).
grandparent(mum(mum(peter)),mum(dad(jo))).
grandparent(mum(mum(peter)),mum(mum(jo))).
grandparent(mum(mum(peter)),dad(peter)).
grandparent(mum(mum(peter)),mum(peter)).
grandparent(mum(mum(peter)),dad(dad(peter))).
grandparent(mum(mum(peter)),dad(mum(peter))).
grandparent(mum(mum(peter)),mum(dad(peter))).
grandparent(mum(mum(peter)),mum(mum(peter))).
grandparent(mum(mum(peter)),jane).
grandparent(mum(mum(peter)),dad(jane)).
grandparent(mum(mum(peter)),mum(jane)).
grandparent(mum(mum(peter)),dad(dad(jane))).
grandparent(mum(mum(peter)),dad(mum(jane))).
grandparent(mum(mum(peter)),mum(dad(jane))).
grandparent(mum(mum(peter)),mum(mum(jane))).
grandparent(jane,bob).
grandparent(jane,dad(bob)).
grandparent(jane,mum(bob)).
grandparent(jane,dad(dad(bob))).
grandparent(jane,dad(mum(bob))).
grandparent(jane,mum(dad(bob))).
grandparent(jane,mum(mum(bob))).
grandparent(jane,jo).
grandparent(jane,dad(jo)).
grandparent(jane,mum(jo)).
grandparent(jane,dad(dad(jo))).
grandparent(jane,dad(mum(jo))).
grandparent(jane,mum(dad(jo))).
grandparent(jane,mum(mum(jo))).
grandparent(jane,peter).
grandparent(jane,dad(peter)).
grandparent(jane,mum(peter)).
grandparent(jane,dad(dad(peter))).
grandparent(jane,dad(mum(peter))).
grandparent(jane,mum(dad(peter))).
grandparent(jane,mum(mum(peter))).
grandparent(jane,jane).
grandparent(jane,dad(jane)).
grandparent(jane,mum(jane)).
grandparent(jane,dad(dad(jane))).
grandparent(jane,dad(mum(jane))).
grandparent(jane,mum(dad(jane))).
grandparent(jane,mum(mum(jane))).
grandparent(dad(jane),bob).
grandparent(dad(jane),dad(bob)).
grandparent(dad(jane),mum(bob)).
grandparent(dad(jane),dad(dad(bob))).
grandparent(dad(jane),dad(mum(bob))).
grandparent(dad(jane),mum(dad(bob))).
grandparent(dad(jane),mum(mum(bob))).
grandparent(dad(jane),jo).
grandparent(dad(jane),dad(jo)).
grandparent(dad(jane),mum(jo)).
grandparent(dad(jane),dad(dad(jo))).
grandparent(dad(jane),dad(mum(jo))).
grandparent(dad(jane),mum(dad(jo))).
grandparent(dad(jane),mum(mum(jo))).
grandparent(dad(jane),peter).
grandparent(dad(jane),dad(peter)).
grandparent(dad(jane),mum(peter)).
grandparent(dad(jane),dad(dad(peter))).
grandparent(dad(jane),dad(mum(peter))).
grandparent(dad(jane),mum(dad(peter))).
grandparent(dad(jane),mum(mum(peter))).
grandparent(dad(jane),jane).
grandparent(dad(jane),dad(jane)).
grandparent(dad(jane),mum(jane)).
grandparent(dad(jane),dad(dad(jane))).
grandparent(dad(jane),dad(mum(jane))).
grandparent(dad(jane),mum(dad(jane))).
grandparent(dad(jane),mum(mum(jane))).
grandparent(mum(jane),bob).
grandparent(mum(jane),dad(bob)).
grandparent(mum(jane),mum(bob)).
grandparent(mum(jane),dad(dad(bob))).
grandparent(mum(jane),dad(mum(bob))).
grandparent(mum(jane),mum(dad(bob))).
grandparent(mum(jane),mum(mum(bob))).
grandparent(mum(jane),jo).
grandparent(mum(jane),dad(jo)).
grandparent(mum(jane),mum(jo)).
grandparent(mum(jane),dad(dad(jo))).
grandparent(mum(jane),dad(mum(jo))).
grandparent(mum(jane),mum(dad(jo))).
grandparent(mum(jane),mum(mum(jo))).
grandparent(mum(jane),peter).
grandparent(mum(jane),dad(peter)).
grandparent(mum(jane),mum(peter)).
grandparent(mum(jane),dad(dad(peter))).
grandparent(mum(jane),dad(mum(peter))).
grandparent(mum(jane),mum(dad(peter))).
grandparent(mum(jane),mum(mum(peter))).
grandparent(mum(jane),jane).
grandparent(mum(jane),dad(jane)).
grandparent(mum(jane),mum(jane)).
grandparent(mum(jane),dad(dad(jane))).
grandparent(mum(jane),dad(mum(jane))).
grandparent(mum(jane),mum(dad(jane))).
grandparent(mum(jane),mum(mum(jane))).
grandparent(dad(dad(jane)),bob).
grandparent(dad(dad(jane)),dad(bob)).
grandparent(dad(dad(jane)),mum(bob)).
grandparent(dad(dad(jane)),dad(dad(bob))).
grandparent(dad(dad(jane)),dad(mum(bob))).
grandparent(dad(dad(jane)),mum(dad(bob))).
grandparent(dad(dad(jane)),mum(mum(bob))).
grandparent(dad(dad(jane)),jo).
grandparent(dad(dad(jane)),dad(jo)).
grandparent(dad(dad(jane)),mum(jo)).
grandparent(dad(dad(jane)),dad(dad(jo))).
grandparent(dad(dad(jane)),dad(mum(jo))).
grandparent(dad(dad(jane)),mum(dad(jo))).
grandparent(dad(dad(jane)),mum(mum(jo))).
grandparent(dad(dad(jane)),peter).
grandparent(dad(dad(jane)),dad(peter)).
grandparent(dad(dad(jane)),mum(peter)).
grandparent(dad(dad(jane)),dad(dad(peter))).
grandparent(dad(dad(jane)),dad(mum(peter))).
grandparent(dad(dad(jane)),mum(dad(peter))).
grandparent(dad(dad(jane)),mum(mum(peter))).
grandparent(dad(dad(jane)),dad(jane)).
grandparent(dad(dad(jane)),mum(jane)).
grandparent(dad(dad(jane)),dad(dad(jane))).
grandparent(dad(dad(jane)),dad(mum(jane))).
grandparent(dad(dad(jane)),mum(dad(jane))).
grandparent(dad(dad(jane)),mum(mum(jane))).
grandparent(dad(mum(jane)),bob).
grandparent(dad(mum(jane)),dad(bob)).
grandparent(dad(mum(jane)),mum(bob)).
grandparent(dad(mum(jane)),dad(dad(bob))).
grandparent(dad(mum(jane)),dad(mum(bob))).
grandparent(dad(mum(jane)),mum(dad(bob))).
grandparent(dad(mum(jane)),mum(mum(bob))).
grandparent(dad(mum(jane)),jo).
grandparent(dad(mum(jane)),dad(jo)).
grandparent(dad(mum(jane)),mum(jo)).
grandparent(dad(mum(jane)),dad(dad(jo))).
grandparent(dad(mum(jane)),dad(mum(jo))).
grandparent(dad(mum(jane)),mum(dad(jo))).
grandparent(dad(mum(jane)),mum(mum(jo))).
grandparent(dad(mum(jane)),peter).
grandparent(dad(mum(jane)),dad(peter)).
grandparent(dad(mum(jane)),mum(peter)).
grandparent(dad(mum(jane)),dad(dad(peter))).
grandparent(dad(mum(jane)),dad(mum(peter))).
grandparent(dad(mum(jane)),mum(dad(peter))).
grandparent(dad(mum(jane)),mum(mum(peter))).
grandparent(dad(mum(jane)),dad(jane)).
grandparent(dad(mum(jane)),mum(jane)).
grandparent(dad(mum(jane)),dad(dad(jane))).
grandparent(dad(mum(jane)),dad(mum(jane))).
grandparent(dad(mum(jane)),mum(dad(jane))).
grandparent(dad(mum(jane)),mum(mum(jane))).
grandparent(mum(dad(jane)),bob).
grandparent(mum(dad(jane)),dad(bob)).
grandparent(mum(dad(jane)),mum(bob)).
grandparent(mum(dad(jane)),dad(dad(bob))).
grandparent(mum(dad(jane)),dad(mum(bob))).
grandparent(mum(dad(jane)),mum(dad(bob))).
grandparent(mum(dad(jane)),mum(mum(bob))).
grandparent(mum(dad(jane)),jo).
grandparent(mum(dad(jane)),dad(jo)).
grandparent(mum(dad(jane)),mum(jo)).
grandparent(mum(dad(jane)),dad(dad(jo))).
grandparent(mum(dad(jane)),dad(mum(jo))).
grandparent(mum(dad(jane)),mum(dad(jo))).
grandparent(mum(dad(jane)),mum(mum(jo))).
grandparent(mum(dad(jane)),peter).
grandparent(mum(dad(jane)),dad(peter)).
grandparent(mum(dad(jane)),mum(peter)).
grandparent(mum(dad(jane)),dad(dad(peter))).
grandparent(mum(dad(jane)),dad(mum(peter))).
grandparent(mum(dad(jane)),mum(dad(peter))).
grandparent(mum(dad(jane)),mum(mum(peter))).
grandparent(mum(dad(jane)),dad(jane)).
grandparent(mum(dad(jane)),mum(jane)).
grandparent(mum(dad(jane)),dad(dad(jane))).
grandparent(mum(dad(jane)),dad(mum(jane))).
grandparent(mum(dad(jane)),mum(dad(jane))).
grandparent(mum(dad(jane)),mum(mum(jane))).
grandparent(mum(mum(jane)),bob).
grandparent(mum(mum(jane)),dad(bob)).
grandparent(mum(mum(jane)),mum(bob)).
grandparent(mum(mum(jane)),dad(dad(bob))).
grandparent(mum(mum(jane)),dad(mum(bob))).
grandparent(mum(mum(jane)),mum(dad(bob))).
grandparent(mum(mum(jane)),mum(mum(bob))).
grandparent(mum(mum(jane)),jo).
grandparent(mum(mum(jane)),dad(jo)).
grandparent(mum(mum(jane)),mum(jo)).
grandparent(mum(mum(jane)),dad(dad(jo))).
grandparent(mum(mum(jane)),dad(mum(jo))).
grandparent(mum(mum(jane)),mum(dad(jo))).
grandparent(mum(mum(jane)),mum(mum(jo))).
grandparent(mum(mum(jane)),peter).
grandparent(mum(mum(jane)),dad(peter)).
grandparent(mum(mum(jane)),mum(peter)).
grandparent(mum(mum(jane)),dad(dad(peter))).
grandparent(mum(mum(jane)),dad(mum(peter))).
grandparent(mum(mum(jane)),mum(dad(peter))).
grandparent(mum(mum(jane)),mum(mum(peter))).
grandparent(mum(mum(jane)),dad(jane)).
grandparent(mum(mum(jane)),mum(jane)).
grandparent(mum(mum(jane)),dad(dad(jane))).
grandparent(mum(mum(jane)),dad(mum(jane))).
grandparent(mum(mum(jane)),mum(dad(jane))).
grandparent(mum(mum(jane)),mum(mum(jane))).
:-end_in_neg.

