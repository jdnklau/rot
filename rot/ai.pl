%! rot_choose_action(+State, -Action).
% Let's Rot start his heuristics to choose an action for the next turn.
% Called by read_rot_action/2 as that is the ment API predicate, so use that instead.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
% @see read_rot_action/2
rot_choose_action(State, Move) :-
  write('rot chooses action'),nl,
  asserta(rot(searching)), % rot(searching) allows usage of the game cpu as it allows different behaviour where it is needed
  create_tree(State,2, Tree), % the integer is giving the depth of the search tree
  search_tree(Tree, (Player_move,Move)),
  write('rot has choosen'),nl,
  write('rot\'s prediction: your choosen action is '), write(Player_move),nl,
  retractall(rot(searching)).

%! rot_choose_switch(+State, -Switch).
% Let's Rot start his heuristics to choose a switch for the next turn.
% Called by read_rot_switch/2 as that is the ment API predicate, so use that instead.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
% @see read_rot_search/2
rot_choose_switch(state(_, Team, _), Switch) :-
  available_switches(Team, Available),
  rot_choose_random(Available, Switch).

%! rot_choose_random(+List, -Choice).
% To be deleted in future
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
