:- modeh(*,grandparent(+person,-person)).
:- modeb(*,mother(+person,-person)).
:- modeb(*,father(+person,-person)).

:- determination(grandparent/2,father/2).
:- determination(grandparent/2,parent/2).
:- determination(grandparent/2,mother/2).
:- aleph_set(construct_bottom, false).
:- aleph_set(refine, auto).

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
:-end_bg.