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

faster((Prio_a,_),(Prio_b,_)) :-
  Prio_a > Prio_b.
faster((Prio,Speed_a), (Prio,Speed_b)) :-
  Speed_a > Speed_b.
faster(Prio_data, Prio_data) :-
  random(0,2,0). % as priorities are the same flip a coin to decide who is faster

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

type_effectiveness(A, [T], E) :-
  typing(A, T, E).
type_effectiveness(A, [T], 1) :-
  \+ typing(A, T, _).
type_effectiveness(A, [T1, T2], E) :-
  type_effectiveness(A, [T1], E1),
  type_effectiveness(A, [T2], E2),
  E is E1*E2.


calculate_stab([Name|_], Type, Stab) :-
  pokemon(Name, Types, _, _),
  stab(Type, Types, Stab).

stab(T, Ts, 1.5) :- member(T, Ts).
stab(T, Ts, 1) :- \+ member(T, Ts).


calculate_increased_stat(Stat_before, Stat_stage, Stat_value) :-
  stat_stage_factor(Stat_stage, F),
  Stat_value is floor(Stat_before * F).

stat_stage_factor(6, 4).
stat_stage_factor(5, 3.5).
stat_stage_factor(4, 3).
stat_stage_factor(3, 2.5).
stat_stage_factor(2, 2).
stat_stage_factor(1, 1.5).
stat_stage_factor(0, 1).
stat_stage_factor(-1, (2/3)).
stat_stage_factor(-2, 0.5).
stat_stage_factor(-3, 0.4).
stat_stage_factor(-4, (1/3)).
stat_stage_factor(-5, (2/7)).
stat_stage_factor(-6, 0.25).


calculate_damage(state([Attacker|_], [Target|_], [Field_attacker, Field_target, Field_global]), Move, Damage) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _),
  Move_catpow =.. [Move_category, Move_base_power],
  calculate_stab(Attacker, Move_type, Stab),
  calculate_type_effectiveness(Move_type, Target, TE),
  get_critical_hit_multiplier(Attacker, Target, Field_target, Move, CM),
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
  get_randomization_adjustment(RA),
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


successful_hits(_, Hits, Hits) :-
  integer(Hits).
successful_hits(Attacker, between(_,Hits), Hits) :-
  ability(Attacker, 'skill link').
successful_hits(Attacker, between(2,5), Hits) :-
  random(0,6,R),
  rng_to_hits(R, Hits).

% ensures that in a 2-5 hits move 2 and 3 hits are 33.33% likely
rng_to_hits(0,2).
rng_to_hits(1,2).
rng_to_hits(2,3).
rng_to_hits(3,3).
rng_to_hits(4,4).
rng_to_hits(5,5).


get_randomization_adjustment(0.85). % NFI


get_critical_hit_multiplier(_, Target, _, _, 1):-
  % targets with the ability Battle Armor or Shell Armor never get hit criticaly
  ability(Target, Ability),
  member(Ability, ['battle armor', 'shell armor']).
get_critical_hit_multiplier(Attacker, Target, Field_target, Move, Final_critical_multiplier) :- % NFI
  crit_stage_increase_by_attack(Move, Crit_attack),
  item(Attacker, Item),
  crit_stage_increase_by_item(Attacker, Item, Crit_item),
  ability(Attacker, Ability),
  crit_stage_increase_by_ability(Ability, Crit_ability),
  crit_stage_increase_by_attacker_state(Attacker, Crit_state),
  Crit_stage is Crit_attack + Crit_item + Crit_ability + Crit_state,
  critical_hit_multiplier(Crit_stage, Critical_multiplier),
  crit_damage_increase_by_ability(Ability, Critical_multiplier, Final_critical_multiplier).

crit_stage_increase_by_attack(Move, 1) :-
  move(Move,_,_,_,_,_,_,_,Additional),
  member(high_crit_ratio, Additional).
crit_stage_increase_by_attack(_,0).

crit_stage_increase_by_item(_, 'razor claw', 1).
crit_stage_increase_by_item(_, 'scope lens', 1).
crit_stage_increase_by_item(['farfetch\'d'|_], stick, 2).
crit_stage_increase_by_item([chansey|_], 'lucky punch', 2).
crit_stage_increase_by_item(_,_,0).

crit_stage_increase_by_ability('super lucky', 1).
crit_stage_increase_by_ability(Ability, 0) :-
  Ability \= 'super lucky'.

crit_stage_increase_by_attacker_state([_,_,_,_,_,[_,Sec_cond,_]], 2) :-
  Sec_cond = [_,_,focus_energy|_].
crit_stage_increase_by_attacker_state([_,_,_,_,_,[_,Sec_cond,_]], 0) :-
  Sec_cond \= [_,_,focus_energy|_].

crit_damage_increase_by_ability(sniper, 1, 1).
crit_damage_increase_by_ability(sniper, 1.5, 2.25).
crit_damage_increase_by_ability(A,C,C) :-
  A \= sniper.

critical_hit_multiplier(Stage, 1.5) :-
  move_hits_critical(Stage).
critical_hit_multiplier(_, 1).

move_hits_critical(Stage) :-
  Stage >= 3.
move_hits_critical(Stage) :-
  Upper_bound is 16 / (2*(Stage+1)),
  random(0,Upper_bound,0).


move_hits(always).
move_hits(100).
move_hits(Acc) :-
  random(0, 101, R),
  R =< Acc.


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
