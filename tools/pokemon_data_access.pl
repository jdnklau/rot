%! fainted(+Pokemon).
%
% True if te given pokemon has fainted
%
% @arg Pokemon The pokemon data of the pokemon in question
fainted([_,kp(0,_),_,_,_,[fainted|_]]).

%! primary_status_condition(+Pokemon, +Condition).
%! primary_status_condition(+Pokemon, -Condition).
%
% True if the given pokemon has the given primary status condition.
% Alternatively can be used to extract the primary status condition of the
% given pokemon.
% A primary status condition of `nil` equals no primary status condition
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Condition The primary status condition the given pokemon suffers
primary_status_condition([_,_,_,_,_,[toxin(_)|_]], poison).
  % toxin has to be treated differently internally but has to be displayed as poisoning
primary_status_condition([_,_,_,_,_,[Condition|_]], Condition) :-
  Condition \= toxin(_).

%! secondary_status_conditions(+Pokemon, -Conditions).
%
% Gives a list of the secondary status conditions the given pokemon is affected with
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Conditions A list of the secondary status conditions suffered
secondary_status_conditions([_,_,_,_,_,[_,Sec_conds,_]], Sec_conds).

%! secondary_status_condition(+Pokemon, +Condition).
%
% True if the given pokemon  is affected with the given secondary status condition
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Condition The secondary status condition the pokemon is affected with
secondary_status_condition(Pokemon, Condition) :-
  secondary_status_conditions(Pokemon, Sec_conds),
  member(Condition, Sec_conds).

%! hp_percent(+Pokemon, -Percentage).
%
% Gives the remaining hit point percentage of the given pokemon
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Percentage The hit point percentage
hp_percent([_, kp(Curr, Max)|_], P) :-
  P is Curr / Max * 100.

%! available_switches(+Team, -Available_switches).
%
% Gives a list of availale pokemon the active pokemon can be switched out with
%
% @arg Team The team in question
% @arg Available_switches List of switch(_) moves available to the given team
available_switches([_|Team], Available) :-
  available_switches_acc(Team, [], Available). % call accumulator
available_switches_acc([Pokemon|Rest], List, Available) :-
  \+ fainted(Pokemon), % unfainted pokemon are ready to go
  Pokemon = [Name|_],
  available_switches_acc(Rest, [switch(Name)|List], Available).
available_switches_acc([Pokemon|Rest], List, Available) :-
  fainted(Pokemon), % ignore fainted pokemon
  available_switches_acc(Rest, List, Available).
available_switches_acc([], Available, Available).

%! available_moves(+Team, -Available_moves)
%
% Gives a list of moves (including switches) available to the given team.
%
% @arg Team The team in question
% @arg Available_moves A list of moves available to the team
% @tbd Check for remaining power points
% @tbd Check for blocked moves
% @tbd Check for moves the active pokemon could be locked to
available_moves([Lead|Team], [M1, M2, M3, M4|Available_switches]) :-
  Lead = [_, _, Moves|_],
  Moves = [[M1,_], [M2,_], [M3,_], [M4,_]],
  available_switches([Lead|Team], Available_switches).

%! item(+Pokemon, +Item).
%! item(+Pokemon, -Item).
% True if the given pokemon holds the given item.
% Can be used to extract the item held.
% @arg Pokemon THe pokemon data of the pokemon in question
% @arg Item The item in question
item([_,_,_,_,Item,_], Item).

%! ability(+Pokemon, +Ability).
%! ability(+Pokemon, -Ability).
% True if the given pokemon has the give ability.
% Can be used to extract the pokemon's ability.
% @arg Pokemon THe pokemon data of the pokemon in question
% @arg Ability The ability in question
ability([_,_,_,[Ability|_],_,_], Ability).

%! types(+Pokemon, -Type_list).
% Gives the type list of the given pokemon.
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Type_list A list containing the types of the given pokemon
types([Name|_], Types) :-
  pokemon(Name, Types, _, _).

%! stats(+Pokemon, -Attack, -Defense, -Special_attac, -Special_defense, -Speed).
%
% Gives the stat values of the given pokemon.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Attack The attack stat
% @arg Defense The defense stat
% @arg Special_attack The special attack stat
% @arg Special_defense The special defense stat
% @arg Speed The speed stat
stats([_,_,_,[_,stats(Atk, Def, Spa, Spd, Spe),_,_],_,_], Atk, Def, Spa, Spd, Spe).

%! atk_stat_by_category(+Pokemon, +Category, -Attack_stat).
%
% Gives the corresponding attack stat to the given offensive category.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Category Either `physical` or `special`
% @arg Attack_stat Either the attack stat value or the special attack stat value
atk_stat_by_category(Pokemon, physical, Atk) :-
  stats(Pokemon, Atk, _, _, _, _).
atk_stat_by_category(Pokemon, special, Atk) :-
  stats(Pokemon, _, _, Atk, _, _).

%! def_stat_by_category(+Pokemon, +Category, -Defense_stat).
%
% Gives the corresponding defense stat to the given offensive category.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Category Either `physical` or `special`
% @arg Defense_stat Either the defense stat value or the special defense stat value
def_stat_by_category(Pokemon, physical, Def) :-
  stats(Pokemon, _, Def, _, _, _).
def_stat_by_category(Pokemon, special, Def) :-
  stats(Pokemon, _, _, _, Def, _).
