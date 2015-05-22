:- dynamic rot/1.

read_rot_move(State, Move) :-
  rot_choose_move(State, Move).

read_rot_switch(State, Switch) :-
  rot_choose_switch(State, Switch).
