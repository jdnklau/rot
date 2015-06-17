fainted([_,kp(0,_),_,_,_,[fainted|_]]).

primary_status_condition([_,_,_,_,_,[toxin(_)|_]], poison).
primary_status_condition([_,_,_,_,_,[Condition|_]], Condition) :-
  Condition \= toxin(_).

secondary_status_conditions([_,_,_,_,_,[_,Sec_conds,_]], Sec_conds).

secondary_status_condition(Pokemon, Condition) :-
  secondary_status_conditions(Pokemon, Sec_conds),
  member(Condition, Sec_conds).

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

item([_,_,_,_,Item,_], Item).

ability([_,_,_,[Ability|_],_,_], Ability).

stats([_,_,_,[_,stats(Atk, Def, Spa, Spd, Spe),_,_],_,_], Atk, Def, Spa, Spd, Spe).
atk_stat_by_category(Pokemon, physical, Atk) :-
  stats(Pokemon, Atk, _, _, _, _).
atk_stat_by_category(Pokemon, special, Atk) :-
  stats(Pokemon, _, _, Atk, _, _).
def_stat_by_category(Pokemon, physical, Def) :-
  stats(Pokemon, _, Def, _, _, _).
def_stat_by_category(Pokemon, special, Def) :-
  stats(Pokemon, _, _, _, Def, _).
