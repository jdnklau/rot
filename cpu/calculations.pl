%! calculate_priorities(+Game_state, +Action_player, +Action_rot, -Priority_frame)
%
% Calculates the priority frame based on the actions priorities and th active pokemons
% speed. Called by process_by_priority/5
%
% @arg Game_state Current state of the game
% @arg Action_player The action choosen by the player
% @arg Action_player The action choosen by rot
% @arg Priority_frame The priority frame containing information about whoms action shall be executed first
% @see process_by_priority/5
calculate_priorities(state(Team_player, Team_rot, _), Action_player, Action_rot, priorities(Priority_player, Priority_rot)) :-
  calculate_priority(Team_player, Action_player, Priority_player),
  calculate_priority(Team_rot, Action_rot, Priority_rot).

%! calculate_priority(+Team, +Action, -Priority_tuple)
%
% Calculates the tuple (priority of action, speed stat of active pokemon).
%
% @arg Team The team of the player using the given action
% @arg Action Either the action used by the active pokemon of the given team or a switch
% @arg Priority_tuple A tuple containing information about the action priority and the user's speed
calculate_priority([Lead|_], switch(_), (6,Speed)) :-
  % a switch ha a fixed priority of 6
  attacking_speed_stat(Lead, Speed).
calculate_priority([Lead|_], Move, (Move_priority_by_prankster, Speed)) :-
  % the prankster ability increases the priority of status moves by 1
  move(Move, _,status,_,_, prio(Move_priority),_,_,_),
  ability(Lead, prankster),
  Move_priority_by_prankster is Move_priority + 1,
  attacking_speed_stat(Lead, Speed).
calculate_priority([Lead|_], Move, (Move_priority, Speed)) :-
  % base case: a damaging move
  move(Move, _,_,_,_, prio(Move_priority),_,_,_),
  attacking_speed_stat(Lead, Speed).

%! calculate_switch(+Team, +Team_mate, -Resulting_team)
%
% Switches the active pokemon of the given team with the given team mate
%
% @arg Team The team doing the switch
% @arg Team_mate Name of an unfainted pokemon contained in the given team who is not the active pokemon
% @arg Resulting_team The team after the switch was executed
calculate_switch([Lead|Team], Team_mate, Resulting_team) :-
  calculate_switch_acc(Lead, Team_mate, [], Team, Resulting_team).
calculate_switch_acc(L, M, Seen, [Top|Rest], [Top|Result]) :-
  Top = [M|_],
  append(Seen, [L|Rest], Result).
calculate_switch_acc(L, M, Seen, [Top|Rest], Result) :-
  Top \= [M|_],
  append(Seen, [Top], New_seen),
  calculate_switch_acc(L, M, New_seen, Rest, Result).

%! calculate_type_effectiveness(+Move_type, +Pokemon, -Effectivenes)
%
% Calculates the effectiveness factor of the given move type against the given
% pokemon
%
% @arg Move_type One of the 18 elemental types - type(Move_type) shall be true
% @arg Pokemon Data of the pokemon targeted by a move with given move type
% @arg Effectivenes The evaluated effectiveness factor as float
% @tbd Save the typing information of a pokemon in it's data structure
calculate_type_effectiveness(Type, [Name|_], E) :-
  pokemon(Name, Types, _,_),
  type_effectiveness(Type, Types, E). % calculates the effectiveness by a typing list

%! calculate_stab(+Pokemon, +Move_type, -Stab)
%
% Calculates the stab factor the given pokemon reaches with the given move type
%
% @arg Pokemon The pokemon data of the pokemon using an offensive move
% @arg Move_type The type of the offensive move used by the given pokemon
% @arg Stab The final stab factor, either 1, 1.5 or 2 if the users ability is adaptability
% @tbd optimize the code a little
calculate_stab(Pokemon, Type, 2) :-
  ability(Pokemon, adaptability),
  types(Pokemon, Types),
  stab(Type, Types, 1.5).
calculate_stab(Pokemon, Type, Stab) :-
  types(Pokemon, Types),
  stab(Type, Types, Stab).

%! calculate_increased_stat(+Stat_before, +Stat_stage, -Stat_value)
%
% @tbd rework
calculate_increased_stat(Stat_before, Stat_stage, Stat_value) :-
  stat_stage_factor(Stat_stage, F),
  Stat_value is floor(Stat_before * F).

%! calculate_damage(+Attacker_state, +Move, -Damage)
%
% Calculates the damage to be dealed by the given offensive move used by the attacker to
% the targed
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Move The move used by the attacker - can not be a status move
% @arg Damage the resulting damage
calculate_damage(state([Attacker|_], [Target|_], [Field_attacker, Field_target, Field_global]), Move, Damage) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _), % it is assumed taht the move is not a status move
  Move_catpow =.. [Move_category, Move_base_power], % get move category and base power
  calculate_stab(Attacker, Move_type, Stab),
  calculate_type_effectiveness(Move_type, Target, TE),
  critical_hit_multiplier(Attacker, Target, Field_target, Move, CM),
  calculate_base_damage(Attacker, Target, Field_global, Move_base_power, Move_type, Base_damage),
  calculate_attackers_atk(Attacker, Move_category, CM, Atk), % get relevant offensive stat
  calculate_targets_def(Target, Field_global, Move_category, CM, Def), % get relevant defensive stat
  calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, CM, F1), % special factor F1
  calculate_F2(Attacker, F2), % special factor F2
  calculate_F3(Attacker, Target, TE, F3), % special factor F3
  calculate_final_damage(Base_damage, Stab, Atk, Def, CM, F1, F2, F3, TE, Damage). % mix it all together

%! calculate_final_damage(+Base_damage, +Stab, +Attack_stat, +Defense_stat, +Critical_multiplier, +F1, +F2, +F3, +Type_effectiveness, -Final_damage)
%
% Calculates the damage according to the formula using the given factors.
% Should not be called directly. To get the damage dealed by a pokemon using a
% certain move calculate_damage/3 should be called instead.
%
% @arg Base_damage The base damage to be considered
% @arg Stab The stab factor to be considered
% @arg Attack_stat The offensive stat value to be considered
% @arg Defense_stat The defensive stat value to be considered
% @arg Critical_multiplier The critical hit multiplier to be considered
% @arg F1 The special factor F1 to be considered
% @arg F2 The special factor F2 to be considered
% @arg F3 The special factor F3 to be considered
% @arg Type_effectiveness The type effectiveness to be considered
% @arg Final_damage The resulting damage of the used formula after considering all given factors
% @see calculate_damage/3
calculate_final_damage(Base_damage, Stab, Atk, Def, Critical_multiplier,
  F1, F2, F3, Type_effectiveness, Final_damage) :-
  F1_damage is floor(floor(22 * Base_damage * Atk / (50 * Def)) * F1) + 2, % factor 22 as level 50 is assumed
  Critical_damage is floor(F1_damage * Critical_multiplier),
  F2_damage is floor(Critical_damage * F2),
  randomization_adjustment(RA), % between 0.85 and 1
  Randomized_damage is floor(F2_damage * RA),
  Stab_damage is floor(Randomized_damage * Stab),
  Type_damage is floor(Stab_damage * Type_effectiveness),
  Final_damage is floor(Type_damage * F3).

%! calculate_base_damage(+Attacker, +Target, +Field_global, +Move_base_power, +Move_type, -Base_damage)
%
% Calculates the base damage to be considered by the damage calculation.
% Should not be called manually. Instead it should be called by calculate_damage/3,
% a predicate ment to be used to calculate the damage to be dealed
%
% @arg Attacker Pokemon data of the attacking pokemon
% @arg Target Pokemon data of the defending pokemon
% @arg Field_global The field information of the global field (shared by both players)
% @arg Move_base_power The base power of the damaging move
% @arg Move_type The type information of the damaging move
% @arg Base_damage The resulting base damage
% @see calculate_damage/3
% @see calculate_final_damage/10
calculate_base_damage(Attacker, Target, Field_global, Move_base_power, Move_type, Base_damage) :-
% needs Helping Hand state (only relevant in Double, Multi, and Triple Battles, so no need here)
% needs Base power (defined by move)
% needs Item Multiplier (information by attacker's item)
% needs Charge state (information by attacker's status conditions)
% needs Mud Sport and Water Sport states (information by global field conditions)
  % needs move type, as Mud Sport and Water Sport depend on the move type (defined by move)
% needs attackers ability (information by attacker's ability)
% needs targets ability (information by target's ability)
  Base_damage is Move_base_power. % NFI

%! calculate_attackers_atk(+Attacker, +Move_category, +Critical_multiplier, -Final_atk)
%
% Calculates the attacker's relevant offensive stat value to be considered by the damage calculation.
% Should not be called manually. Instead it should be called by calculate_damage/3,
% a predicate ment to be used to calculate the damage to be dealed
%
% @arg Attacker Pokemon data of the attacking pokemon
% @arg Move_category The category of the damaging move
% @arg Critical_multiplier The critical hit multiplier
% @arg Final_atk The resulting offensive stat value to be used
% @see calculate_damage/3
% @see calculate_final_damage/10
calculate_attackers_atk(Attacker, Move_category, Critical_multiplier, Final_atk) :-
% needs attack stat (information by attacker)
  % needs category of move to distinguish what stats to use (defined by move)
% needs Critical multiplier
% needs Ability multiplier (information by attacker's ability)
% needs Item multiplier (information by attacker's item)
  atk_stat_by_category(Attacker, Move_category, Final_atk). % NFI

%! calculate_targets_def(+Target, +Field_global, Move_category, +Critical_multiplier, -Final_def)
%
% Calculates the target's relevant defensive stat value to be considered by the damage calculation.
% Should not be called manually. Instead it should be called by calculate_damage/3,
% a predicate ment to be used to calculate the damage to be dealed
%
% @arg Target Pokemon data of the defending pokemon
% @arg Field_global The field information of the global field (shared by both players)
% @arg Move_category The category the target has to defend against
% @arg Critical_multiplier The critical hit multiplier
% @arg Final_def The resulting defensive stat value to be used
% @see calculate_damage/3
% @see calculate_final_damage/10
calculate_targets_def(Target, Field_global, Move_category, Critical_multiplier, Final_def) :-
% needs defense stat (information by target)
  % needs category of move to distinguish what stats to use (defined by move)
% needs Critical multiplier
% needs Ability multiplier (information by target's ability)
% needs Item multiplier (information by target's item)
% needs Sand Storm state (information by global field conditions)
  % needs target's type as sand storm only increases the spd of rock type pokémon (information by target)
  % needs category of move as sand storm only increases special defense (defined by move)
  def_stat_by_category(Target, Move_category, Final_def). % NFI

%! calculate_F1(+Attacker, +Field_target, +Field_global, +Move_type, +Move_category, +Critical_multiplier, -F1)
%
% Calculates the factor F1 to be considered by the damage calculation.
% Should not be called manually. Instead it should be called by calculate_damage/3,
% a predicate ment to be used to calculate the damage to be dealed
%
% @arg Attacker Pokemon data of the attacking pokemon
% @arg Field_target The field information of the target's side
% @arg Field_global The field information of the global field (shared by both players)
% @arg Move_type The type information of the damaging move
% @arg Move_category The category of the damaging move
% @arg Critical_multiplier The critical hit multiplier
% @arg F1 The resulting factor
% @see calculate_damage/3
% @see calculate_final_damage/10
calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, Critical_multiplier, Final_F1) :-
% needs burn state of attacker (information by attacker)
% needs Reflect and Light Screen states (information by target's field conditions)
  % needs category of move to distinguish whether Reflect or Light Screen shall be used for calculation (defined by move)
  % needs Critical multiplier as a critical hit ignores both Reflect and Light Screen
% needs Sunny Day and Rain Dance states (information by global field conditions)
  % needs move type as the effect of Sunny Day and Rain Dance depend on the move type (defined by move)
% needs Flash Fire state (information by attacker)
  Final_F1 is 1. % NFI

%! calculate_F2(+Attacker, -F2)
%
% Calculates the factor F2 to be considered by the damage calculation.
% Should not be called manually. Instead it should be called by calculate_damage/3,
% a predicate ment to be used to calculate the damage to be dealed
%
% @arg Attacker Pokemon data of the attacking pokemon
% @arg F2 The resulting factor
% @see calculate_damage/3
% @see calculate_final_damage/10
calculate_F2(Attacker, Final_F2) :-
% needs attacker's item Life Orb or Metronome (information by attacker)
% needs Me First state (information by attacker)
  Final_F2 is 1.

%! calculate_F3(+Attacker, +Target, +Type_effectiveness, -F3)
%
% Calculates the factor F3 to be considered by the damage calculation.
% Should not be called manually. Instead it should be called by calculate_damage/3,
% a predicate ment to be used to calculate the damage to be dealed
%
% @arg Attacker Pokemon data of the attacking pokemon
% @arg Target Pokemon data of the defending pokemon
% @arg Type_effectiveness effectiveness of the damaging move against the target
% @arg F3 The resulting factor
% @see calculate_damage/3
% @see calculate_final_damage/10
calculate_F3(Attacker, Target, Type_effectiveness, Final_F3) :-
% needs target's ablility Solid Rock or Filter (information by target)
  % needs type effectiveness as Solid Rock or Filter depends on it
% needs attacker's item Expert Belt (information by attacker)
  % needs type effectiveness as Expert Belt depends on it
% needs attacker's ability Tinted Lens (information by attacker)
  % needs type effectiveness as Tinded Lens depends on it
% needs target's Damage Reduction Berry state (information by target)
  Final_F3 is 1.
