:- dynamic rot/1.

read_rot_action(State, Move) :-
  rot_choose_action(State, Move).

read_rot_switch(State, Switch) :-
  rot_choose_switch(State, Switch).
