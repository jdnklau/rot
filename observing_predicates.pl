fainted([_,kp(0,_),_,_,_,[fainted|_]]).

team_completely_fainted([]).
team_completely_fainted([Pokemon|Rest]) :-
  fainted(Pokemon),
  team_completely_fainted(Rest).

primary_status_condition([_,_,_,_,_,[toxin(_)|_]], poison).
primary_status_condition([_,_,_,_,_,[Condition|_]], Condition) :-
  Condition \= toxin(_).

hp_percent([_, kp(Curr, Max)|_], P) :-
  P is Curr / Max * 100.
