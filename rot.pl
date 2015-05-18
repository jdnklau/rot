rot_choose_move(state(_, [[_,_,Moves|_]|_],_), Move) :-
  rot_choose_random(Moves, [Move,_]).

rot_choose_switch(state(_, Team, _), switch(Name)) :-
  available_switches(Team, Available),
  rot_choose_random(Available, [Name|_]).

available_switches([_|Team], Available) :-
  available_switches_acc(Team, [], Available).
available_switches_acc([Pokemon|Rest], List, Available) :-
  \+ fainted(Pokemon),
  available_switches_acc(Rest, [Pokemon|List], Available).
available_switches_acc([Pokemon|Rest], List, Available) :-
  fainted(Pokemon),
  available_switches_acc(Rest, List, Available).
available_switches_acc([], Available, Available).

rot_choose_random([], _) :-
  write(' >>> error in rot.pl: rot_choose_random needs a non empty list <<<'), nl.
rot_choose_random(List, Choice) :-
  length(List, L),
  L > 0,
  random(0, L, R),
  rot_choose_random_acc(List, R, Choice).
rot_choose_random_acc([H|_], 0, H).
rot_choose_random_acc([_|T], R, C) :-
  R > 0,
  NR is R-1,
  rot_choose_random_acc(T, NR, C).
