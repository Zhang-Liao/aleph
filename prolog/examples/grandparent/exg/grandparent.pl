:- use_module(library(aleph)).
:- aleph.

:- if(current_predicate(use_rendering/1)).
:- use_rendering(prolog).
:- endif.

:- modeh(*,gp(+person,-person)).
:- modeb(*,mom(+person,-person)).
:- modeb(*,dad(+person,-person)).

:- determination(gp/2, dad/2).
:- determination(gp/2, mom/2).

:-begin_bg.
mom(a, b).
mom(a, c).
mom(b, d).
dad(e, b).
dad(c, f).
dad(e, c).
:-end_bg.

:-begin_in_pos.
gp(a,d).
gp(e,d).
gp(a,f).
gp(e,f).
:-end_in_pos.

:-begin_in_neg.
gp(a,b).
gp(b,c).
gp(c,f).
gp(d,f).
:-end_in_neg.

% :- induce.