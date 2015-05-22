calculate_priorities(state(Team_player, Team_rot, _), Move_player, Move_rot,
  priorities(Priority_player, Priority_rot)) :-
  calculate_priority(Team_player, Move_player, Priority_player),
  calculate_priority(Team_rot, Move_rot, Priority_rot).

calculate_priority([Lead|_], switch(_), (6,Speed)) :-
  stats(Lead,_,_,_,_,Speed).
calculate_priority([Lead|_], Move, (Move_priority_by_prankster, Speed)) :-
  move(Move, _,status,_,_, prio(Move_priority),_,_,_),
  ability(Lead, prankster),
  Move_priority_by_prankster is Move_priority + 1,
  stats(Lead,_,_,_,_,Speed).
calculate_priority([Lead|_], Move, (Move_priority, Speed)) :-
  move(Move, _,_,_,_, prio(Move_priority),_,_,_),
  stats(Lead,_,_,_,_,Speed).

calculate_switch([Lead|Team], Team_mate, Resulting_team) :-
  calculate_switch_acc(Lead, Team_mate, [], Team, Resulting_team).
calculate_switch_acc(L, M, Seen, [Top|Rest], [Top|Result]) :-
  Top = [M|_],
  append(Seen, [L|Rest], Result).
calculate_switch_acc(L, M, Seen, [Top|Rest], Result) :-
  Top \= [M|_],
  append(Seen, [Top], New_seen),
  calculate_switch_acc(L, M, New_seen, Rest, Result).


calculate_type_effectiveness(Type, [Name|_], E) :-
  pokemon(Name, Types, _,_),
  type_effectiveness(Type, Types, E).


calculate_stab([Name|_], Type, Stab) :-
  pokemon(Name, Types, _, _),
  stab(Type, Types, Stab).

calculate_increased_stat(Stat_before, Stat_stage, Stat_value) :-
  stat_stage_factor(Stat_stage, F),
  Stat_value is floor(Stat_before * F).


calculate_damage(state([Attacker|_], [Target|_], [Field_attacker, Field_target, Field_global]), Move, Damage) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _),
  Move_catpow =.. [Move_category, Move_base_power],
  calculate_stab(Attacker, Move_type, Stab),
  calculate_type_effectiveness(Move_type, Target, TE),
  critical_hit_multiplier(Attacker, Target, Field_target, Move, CM),
  calculate_base_damage(Attacker, Target, Field_global, Move_base_power, Move_type, Base_damage),
  calculate_attackers_atk(Attacker, Move_category, CM, Atk),
  calculate_targets_def(Target, Field_global, Move_category, CM, Def),
  calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, CM, F1),
  calculate_F2(Attacker, F2),
  calculate_F3(Attacker, Target, TE, F3),
  calculate_final_damage(Base_damage, Stab, Atk, Def, CM, F1, F2, F3,
    Stab, TE, Damage).

calculate_final_damage(Base_damage, Stab, Atk, Def, Critical_multiplier,
  F1, F2, F3, Stab_multiplier, Type_effectiveness, Final_damage) :-
  F1_damage is floor(floor(22 * Base_damage * Atk / (50 * Def)) * F1) + 2,
  Critical_damage is floor(F1_damage * Critical_multiplier),
  F2_damage is floor(Critical_damage * F2),
  randomization_adjustment(RA),
  Randomized_damage is floor(F2_damage * RA),
  Stab_damage is floor(Randomized_damage * Stab),
  Type_damage is floor(Stab_damage * Type_effectiveness),
  Final_damage is floor(Type_damage * F3).

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

calculate_attackers_atk(Attacker, Move_category, Critical_multiplier, Final_atk) :-
% needs attack stat (information by attacker)
  % needs category of move to distinguish what stats to use (defined by move)
% needs Critical multiplier
% needs Ability multiplier (information by attacker's ability)
% needs Item multiplier (information by attacker's item)
  atk_stat_by_category(Attacker, Move_category, Final_atk). % NFI

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

calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, Critical_multiplier, Final_F1) :-
% needs burn state of attacker (information by attacker)
% needs Reflect and Light Screen states (information by target's field conditions)
  % needs category of move to distinguish whether Reflect or Light Screen shall be used for calculation (defined by move)
  % needs Critical multiplier as a critical hit ignores both Reflect and Light Screen
% needs Sunny Day and Rain Dance states (information by global field conditions)
  % needs move type as the effect of Sunny Day and Rain Dance depend on the move type (defined by move)
% needs Flash Fire state (information by attacker)
  Final_F1 is 1. % NFI

calculate_F2(Attacker, Final_F2) :-
% needs attacker's item Life Orb or Metronome (information by attacker)
% needs Me First state (information by attacker)
  Final_F2 is 1.

calculate_F3(Attacker, Target, Type_effectiveness, Final_F3) :-
% needs target's ablility Solid Rock or Filter (information by target)
  % needs type effectiveness as Solid Rock or Filter depends on it
% needs attacker's item Expert Belt (information by attacker)
  % needs type effectiveness as Expert Belt depends on it
% needs attacker's ability Tinted Lens (information by attacker)
  % needs type effectiveness as Tinded Lens depends on it
% needs target's Damage Reduction Berry state (information by target)
  Final_F3 is 1.
