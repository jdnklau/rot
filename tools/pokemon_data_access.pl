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
primary_status_condition([_,_,_,_,_,[Condition|_]], Condition).

%! primary_status_condition_category(+Pokemon, +Condition).
%! primary_status_condition_category(+Pokemon, -Condition).
%
% True if the given pokemon has the given primary status condition by category.
% Alternatively can be used to extract the primary status condition category of the
% given pokemon.
%
% The possible categories are:
%   * burn
%   * freeze
%   * paralysis
%   * poison
%   * bad-poison
%   * sleep
%   * nil (no ailment)
%
% This is ment to be a quick reference to the pokemon's primary status condition
% in situations where it is of no interest what internal data comes along with the ailment.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Condition The primary status condition category the given pokemon suffers
primary_status_condition_category(Pokemon, bad-poison) :-
  % bad-poison has to be treated differently internally
  primary_status_condition(Pokemon, poison(_)).
primary_status_condition_category(Pokemon, sleep) :-
  % sleep comes along with a counter to be get rid of in the category display
  primary_status_condition(Pokemon, sleep(_,_)).
primary_status_condition_category(Pokemon, Condition) :-
  % base case
  primary_status_condition(Pokemon, Condition),
  Condition \= bad-poison(_),
  Condition \= sleep(_,_).

%! inflict_primary_status_condition(+Attacker_state, +Condition, +Probability, -Result_state, -Message_collection).
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
% @arg Message_collection Collection of messages occured whilst processing
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
  member(Poison, [poison, bad-poison]),
  State = state(_,[Pokemon|_],_),
  has_type(Pokemon, poison).
inflict_primary_status_condition(State, bad-poison, _, Result, Messages) :-
  % bad-poison needs to carry information about the number of turns the pokemon suffers it already as it grows stronger
  inflict_primary_status_condition(State, poison(1), always, Result, Messages). % base case can handle this
inflict_primary_status_condition(State, Cond, _, Result, Msg) :-
  % base case
  State = state(Attacker,[Pokemon|Team],Field),
  Pokemon = [Name|_],
  primary_status_condition(Pokemon, nil),
  set_primary_status_condition(Pokemon, Cond, Result_pokemon),
  primary_status_condition_category(Result_pokemon, Cond_cat),
  add_messages([target(ailment(Cond_cat))], [], Msg), % set up message
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

%! hp_frame(+Pokemon, -HP_frame).
%
% Returns the hp frame of the given pokemon.
% The frame is of the form `kp(Current_hp, Max_hp)`
% @arg Pokemon The pokemon data of the pokemon in question
% @arg HP_frame The HP frame
hp_frame([_,HP|_], HP).

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

%! raw_stats(+Pokemon, -Attack, -Defense, -Special_attack, -Special_defense, -Speed).
%
% Returns the raw status values of the given pokemon.
% Does not take eventual status increases or decreases into account.
% For more battle relevant stats use stats/6.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Attack The attack stat
% @arg Defense The defense stat
% @arg Special_attack The special attack stat
% @arg Special_defense The special defense stat
% @arg Speed The speed stat
% @see stats/6
raw_stats([_,_,_,[_,stats(Atk, Def, Spa, Spd, Spe)|_]|_], Atk, Def, Spa, Spd, Spe).

%! stats(+Pokemon, -Attack, -Defense, -Special_attack, -Special_defense, -Speed).
%
% Returns the status values of the given pokemon.
% Intended to use in battle as it takes status increases into account.
% For the raw stats without accounting of stat increases use raw_stats/6.
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Attack The attack stat
% @arg Defense The defense stat
% @arg Special_attack The special attack stat
% @arg Special_defense The special defense stat
% @arg Speed The speed stat
% @see raw_stats/6
stats(Pokemon, Atk, Def, Spa, Spd, Spe) :-
  raw_stats(Pokemon, Atk_r, Def_r, Spa_r, Spd_r, Spe_r), % raw data
  stat_stages(Pokemon, Atk_i, Def_i, Spa_i, Spd_i, Spe_i), % stat stages
  % get battle stats
  increased_stat(Atk_r, Atk_i, Atk),
  increased_stat(Def_r, Def_i, Def),
  increased_stat(Spa_r, Spa_i, Spa),
  increased_stat(Spd_r, Spd_i, Spd),
  increased_stat(Spe_r, Spe_i, Spe).

%! stat_stages(+Pokemon, -Attack, -Defense, -Special_attack, -Special_defense, -Speed).
%
% Returns all the status value stages, each in range from -6 to 6.
% To access a specific stat stage use stat_stage/3
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Attack The attack stat stage
% @arg Defense The defense stat stage
% @arg Special_attack The special attack stat stage
% @arg Special_defense The special defense stat stage
% @arg Speed The speed stat stage
stat_stages([_,_,_,[_,_,_,stat_stages(Atk,Def,Spa,Spd,Spe)|_]|_], Atk, Def, Spa, Spd, Spe).

%! stat_stage(+Pokemon, +Stat_name, -Stat_stage).
% Returns a specific status value stage.
% To access all stat stages easily use stat_stages/6.
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Stat_name The name of the status value stage to return
% @arg Stat_stage An integer within the range from -6 to 6 representing the status value stage
stat_stage(Pokemon, attack, Stage) :-
  stat_stages(Pokemon, Stage,_,_,_,_).
stat_stage(Pokemon, defense, Stage) :-
  stat_stages(Pokemon, _,Stage,_,_,_).
stat_stage(Pokemon, special-attack, Stage) :-
  stat_stages(Pokemon, _,_,Stage,_,_).
stat_stage(Pokemon, special-defense, Stage) :-
  stat_stages(Pokemon, _,_,_,Stage,_).
stat_stage(Pokemon, speed, Stage) :-
  stat_stages(Pokemon, _,_,_,_,Stage).

%! increase_stat_stage(+Pokemon, +Stat_name, +Stage_increase, -Result_pokemon).
% Increases the given pokemons status value stage by the given number.
% The status value stage can not be lower than -6 nor higher than +6.
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Stat_name The name of the status value stage to increase
% @arg Stage_increase The amount the status value stage will be increased (may be negative)
% @arg Result_pokemon The resulting pokemon data
increase_stat_stage(Pokemon, Stat_name, Stage_increase, Result_pokemon) :-
  % get stat stage frame
  Pokemon = [Name,Hp, Moves, [Ability,Stats,Types,Increases|Rest1]|Rest2],
  % increase correspinding stat
  increase_stat_stage_frame(Increases, Stat_name, Stage_increase, Result_increases),
  % save result
  Result_pokemon = [Name,Hp,Moves,[Ability,Stats,Types,Result_increases|Rest1]|Rest2].

%! increase_stat_stage_frame(+Stat_stage_frame, +Stat_name, +Stage_increase, -Result_frame).
% Increases the given status value stage frame's status value stage by the given number.
% The status value stage can not be lower than -6 nor higher than +6.
% @arg Stat_stage_frame The frame which has du be increased - of the form stat_stages(Attack, Defense, Special_attack, Special_defense, Speed)
% @arg Stat_name The name of the status value stage to increase
% @arg Stage_increase The amount the status value stage will be increased (may be negative)
% @arg Result_frame The resulting status value stage frame
increase_stat_stage_frame(stat_stages(A,D,Sa,Sd,Sp), attack, Inc, stat_stages(A_i,D,Sa,Sd,Sp)) :-
  A_i is max(-6, min(6, A+Inc)). % needs to be in range -6 to 6
increase_stat_stage_frame(stat_stages(A,D,Sa,Sd,Sp), defense, Inc, stat_stages(A,D_i,Sa,Sd,Sp)) :-
  D_i is max(-6, min(6, D+Inc)). % needs to be in range -6 to 6
increase_stat_stage_frame(stat_stages(A,D,Sa,Sd,Sp), special-attack, Inc, stat_stages(A,D,Sa_i,Sd,Sp)) :-
  Sa_i is max(-6, min(6, Sa+Inc)). % needs to be in range -6 to 6
increase_stat_stage_frame(stat_stages(A,D,Sa,Sd,Sp), special-defense, Inc, stat_stages(A,D,Sa,Sd_i,Sp)) :-
  Sd_i is max(-6, min(6, Sd+Inc)). % needs to be in range -6 to 6
increase_stat_stage_frame(stat_stages(A,D,Sa,Sd,Sp), speed, Inc, stat_stages(A,D,Sa,Sd,Sp_i)) :-
  Sp_i is max(-6, min(6, Sp+Inc)). % needs to be in range -6 to 6

%! clear_stat_stages(+Pokemon, -Result_pokemon).
% Sets the status value stages of the given pokemon to 0.
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Result_pokemon The resulting pokemon data
clear_stat_stages(Pokemon, Result_pokemon) :-
  % get pokemon data
  Pokemon = [Name,Hp, Moves, [Ability,Stats,Types,_|Rest1]|Rest2],
  % save result with cleared stat stages
  Result_pokemon = [Name,Hp,Moves,[Ability,Stats,Types,stat_stages(0,0,0,0,0)|Rest1]|Rest2].

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
  primary_status_condition(Pokemon, paralysis),
  \+ ability(Pokemon, 'quick feet'),
  stats(Pokemon,_,_,_,_,Speed),
  AS is floor(Speed * 0.25).
attacking_speed_stat(Pokemon, AS) :-
  % base case
  stats(Pokemon,_,_,_,_,AS).

%! ev_dv_data(+Pokemon, -EV_DV_data).
% Returns the ev/dv data of the given pokemon.
% The data has the format of a six-tupel corresponding to the six base stats.
% Each value of this six-tupel is a tupel itself of the form (EV, DV) for the corresponding stat.
% @arg Pokemon The pokemon data of the pokemon in question.
% @arg EV_DV_data The EV and DV data of the pokemon.
ev_dv_data([_,_,_,[_,_,_,_,EV_DV|_]|_], EV_DV).

%! ev_data(+Pokemon, -HP_ev, -Attack_ev, -Defense_ev, -Special_attack_ev, -Special_defense_ev, -Speed_ev).
% Returns the effort values of the given pokemon.
% @arg Pokemon The pokemon data of the pokemon in question.
% @arg HP_ev The hit point's effort value
% @arg Attack_ev The attacks's effort value
% @arg Defense_ev The defense's effort value
% @arg Special_attack_ev The special attack's effort value
% @arg Special_defense_ev The special defense's effort value
% @arg Speed_ev The speed's effort value
ev_data(Pokemon, HP, Atk, Def, Spa, Spd, Spe) :-
  ev_dv_data(Pokemon, ((HP,_), (Atk,_), (Def,_), (Spa,_), (Spd,_), (Spe,_))).
