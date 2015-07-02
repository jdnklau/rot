:- dynamic rot/1.

%! read_rot_action(+State, -Action).
% Let's Rot start his heuristics to choose an action for the next turn.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
read_rot_action(State, Action) :-
  rot_choose_action(State, Action).

%! rot_choose_switch(+State, -Switch).
% Let's Rot start his heuristics to choose a switch for the next turn.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
read_rot_switch(State, Switch) :-
  rot_choose_switch(State, Switch).
