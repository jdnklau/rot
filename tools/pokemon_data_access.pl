%! fainted(+Pokemon).
% True if te given pokemon has fainted
% @arg Pokemon The pokemon data of the pokemon in question
fainted([_,kp(0,_),_,_,_,[fainted|_]]).

%! pokemon_name(+Pokemon, -Name).
% Reads and returns the pokemon's name from its pokemon data
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Name The pokemon's name
pokemon_name([Name|_],Name).

%! primary_status_condition(+Pokemon, +Condition).
%! primary_status_condition(+Pokemon, -Condition).
%
% True if the given pokemon has the given primary status condition.
% Alternatively can be used to extract the primary status condition of the
% given pokemon.
% A primary status condition of `nil` equals no primary status condition
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Condition The primary status condition the given pokemon suffers
primary_status_condition([_,_,_,_,_,[toxin(_)|_]], poison).
  % toxin has to be treated differently internally but has to be displayed as poisoning
primary_status_condition([_,_,_,_,_,[Condition|_]], Condition) :-
  Condition \= toxin(_).

%! inflict_primary_status_condition(+Attacker_state, +Condition, +Probability, -Result_state).
%
% Attempts to inflict a given primary status condition to the target pokemon.
% - Pokemon already suffering a primary status condition can not be inflicted, neither do fainted ones.
% - Fire pokemon can not be burned.
% - Electro pokemon can not be paralyzed
% - Ice pokemon can not be frozen
%
% @arg Attacker_state The game state from the attackers point of view
% @arg Condition One of the primary status conditions
% @arg Probability The probability the given condition will be applied
% @arg Result_state The resulting attacker state
inflict_primary_status_condition(State, _, Probability, State, []) :-
  % case: ailment is not inflicted due to rng saying so
  % this predicate is designed to fail if the rng succeeds as the clauses below
  % are ment to handle a situation the rng already has passed.
  % (this design choice is due to how the code was designed before)
  \+ rng_succeeds(Probability).
inflict_primary_status_condition(State, _, _, State, []) :-
  % already has a primary status condition
  State = state(_,[Pokemon|_],_),
  primary_status_condition(Pokemon, Curr_cond),
  Curr_cond \= nil.
inflict_primary_status_condition(State, burn, _, State, []) :-
  % fire pokemon can not be burned
  State = state(_,[Pokemon|_],_),
  has_type(Pokemon, fire).
inflict_primary_status_condition(State, paralyze, _, State, []) :-
  % electro pokemon can not be paralyzed
  State = state(_,[Pokemon|_],_),
  has_type(Pokemon, electro).
inflict_primary_status_condition(State, freeze, _, State, []) :-
  % ice pokemon can not be frozen
  State = state(_,[Pokemon|_],_),
  has_type(Pokemon, ice).
inflict_primary_status_condition(State, Poison, _, State, []) :-
  % poison type pokemon can not be poisoned
  member(Poison, [poison, toxin]),
  State = state(_,[Pokemon|_],_),
  has_type(Pokemon, poison).
inflict_primary_status_condition(State, toxin, _, Result, Messages) :-
  % toxin needs to carry information about the number of turns the pokemon suffers it already as it grows stronger
  inflict_primary_status_condition(State, toxin(1), 0, Result, Messages). % base case can handle this
inflict_primary_status_condition(State, Cond, _, Result, [target(ailment(pokemon(Name), suffers(Cond)))]) :-
  % base case
  State = state(Attacker,[Pokemon|Team],Field),
  Pokemon = [Name|_],
  primary_status_condition(Pokemon, nil),
  set_primary_status_condition(Pokemon, Cond, Result_pokemon),
  Result = state(Attacker,[Result_pokemon|Team],Field).

%! set_primary_status_condition(+Pokemon, +Condition, -Result_pokemon).
%
% Sets the pokemons primary status condition to the given status condition.
% This predicate does not check whether the condition can be inflicted to the
% pokemon or not.
% For a battle use inflict_primary_status_condition/3 instead.
%
% @arg Pokemon The pokemon data of the pokemon to get the status condition
% @arg Condition One of the primary status conditions
% @arg Result_pokemon The resulting pokemon data
% @see inflict_primary_status_condition/3
set_primary_status_condition([Name,Health,Moves,Stats,Item,[_|Sec_conds]], Condition,
  [Name,Health,Moves,Stats,Item,[Condition|Sec_conds]]).

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

%! available_actions(+Team, -Available_actions).
%
% Gives a list of available actions (moves switches) the owner of the team can use.
%
% @arg Team The team in question
% @arg Available_actionss A list of actions available to the team
available_actions(Team, Available) :-
  available_moves(Team, Available_moves), % moves
  available_switches(Team, Available_switches), % switches
  append(Available_moves, Available_switches, Available). % moves and switches together

%! available_switches(+Team, -Available_switches).
%
% Gives a list of availale pokemon the active pokemon can be switched out with
%
% @arg Team The team in question
% @arg Available_switches List of switch(_) actions available to the given team
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
% Gives a list of moves available to the given team.
%
% @arg Team The team in question
% @arg Available_moves A list of moves available to the team
% @tbd Check for remaining power points
% @tbd Check for blocked moves
% @tbd Check for moves the active pokemon could be locked to
available_moves([Lead|_], [M1, M2, M3, M4]) :-
  Lead = [_, _, Moves|_],
  Moves = [[M1,_], [M2,_], [M3,_], [M4,_]].

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
types([_,_,_,[_,_,Types|_]|_], Types).

%! has_type(+Pokemon, +Type).
% True if the given pokemon has (maybe not exclusively) the given type
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Type One of the elementary types used in pokemon
has_type(Pokemon, Type) :-
  types(Pokemon, Types),
  member(Type, Types).

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
stats([_,_,_,[_,stats(Atk, Def, Spa, Spd, Spe)|_]|_], Atk, Def, Spa, Spd, Spe).

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

%! attacking_speed_stat(+Pokemon, -Speed_stat).
%
% Gives the pokemon's attacking speed based on it's speed stat and his primary status condition.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Speed_stat The resulting speed
attacking_speed_stat(Pokemon, AS) :-
  % is the pokemon paralyzed and has the quick feet ability its speed is increased
  primary_status_condition(Pokemon, paralysis),
  ability(Pokemon, 'quick feet'),
  stats(Pokemon,_,_,_,_,Speed),
  AS is floor(Speed * 1.5).
attacking_speed_stat(Pokemon, AS) :-
  % paralysis reduces speed by 75% if the user has not the ability quick feet
  primary_status_condition(Pokemon, paralisis),
  not ability(Pokemon, 'quick feet'),
  stats(Pokemon,_,_,_,_,Speed),
  AS is floor(Speed * 0.25).
attacking_speed_stat(Pokemon, AS) :-
  % base case
  stats(Pokemon,_,_,_,_,AS).
