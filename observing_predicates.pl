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


available_switches([_|Team], Available) :-
  available_switches_acc(Team, [], Available).
available_switches_acc([Pokemon|Rest], List, Available) :-
  \+ fainted(Pokemon),
  Pokemon = [Name|_],
  available_switches_acc(Rest, [switch(Name)|List], Available).
available_switches_acc([Pokemon|Rest], List, Available) :-
  fainted(Pokemon),
  available_switches_acc(Rest, List, Available).
available_switches_acc([], Available, Available).

available_moves([Lead|Team], [M1, M2, M3, M4|Available_switches]) :-
  Lead = [_, _, Moves|_],
  Moves = [[M1,_], [M2,_], [M3,_], [M4,_]],
  available_switches([Lead|Team], Available_switches).
