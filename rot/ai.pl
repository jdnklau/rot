rot_choose_move(state(_, Team,_), Move) :-
  available_moves(Team, Moves),
  rot_choose_random(Moves, Move).

rot_choose_switch(state(_, Team, _), Switch) :-
  available_switches(Team, Available),
  rot_choose_random(Available, Switch).

rot_choose_random(X, _) :-
  var(X),
  write(' >>> error in rot.pl: rot_choose_random needs a non empty list but received an unbound variable <<<'), nl.
rot_choose_random([], _) :-
  write(' >>> error in rot.pl: rot_choose_random needs a non empty list but received an empty list <<<'), nl.
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
