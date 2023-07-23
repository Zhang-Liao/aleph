:- modeh(*,grandparent(+person,-person)).
:- modeb(*,mother(+person,-person)).
:- modeb(*,father(+person,-person)).

:- determination(grandparent/2,father/2).
:- determination(grandparent/2,parent/2).
:- determination(grandparent/2,mother/2).
:- aleph_set(construct_bottom, false).
:- aleph_set(refine, auto).