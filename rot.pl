rot_choose_move(_Team_player, [[_,_,Moves|_]|_], Move) :-
  random(0,4,R),
  random_choose_move(Moves, R, Move).
random_choose_move([[Move,_]|_], 0, Move).
random_choose_move([_|Rest], R, Move) :-
  NR is R-1,
  random_choose_move(Rest, NR, Move).
