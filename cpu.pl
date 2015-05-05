:- use_module(library(random)).

calculate_damage(Base_dmg,Atk,Def,F1,Damage) :-
  AtkDef is Atk / (50*Def),
  Damage is 22*Base_dmg * AtkDef * F1 + 2.

calculate_base_damage([_,_KP,_,_,_Item,_], _Move_name, Base_power, Base_power). % NFI

process([A|Team_A], Move_A, [B|Team_B], Move_B, Field, Result_A, Result_B, Result_field) :-
  calculate_priority(A, Move_A, Prio_A, B, Move_B, Prio_B),
  process_by_priority([A|Team_A], Move_A, Prio_A,[B|Team_B], Move_B, Prio_B, Field, Result_A, Result_B, Result_field),
  nl, !.

calculate_priority(A, Move_A, Prio_A, B, Move_B, Prio_B) :-
  calculate_single_priority(A, Move_A, Prio_A),
  calculate_single_priority(B, Move_B, Prio_B).

calculate_single_priority(A, switch(_), (6,Init)) :-
  stats(A,_,_,_,_,Init).
calculate_single_priority(A, Move, (Prio,Init)) :-
  stats(A,_,_,_,_,Init),
  move(Move, _,_,_,_,prio(Prio),_).

stats(Pokemon, Atk, Def, Spa, Spd, Ini) :-
  Pokemon = [_,_,_,[_,stats(Atk_raw,Def_raw,Spa_raw,Spd_raw,Ini_raw),stat_increases(Atk_stage, Def_stage, Spa_stage, Spd_stage, Ini_stage)],_,_],
  calculate_increased_stat(Atk_raw, Atk_stage, Atk),
  calculate_increased_stat(Def_raw, Def_stage, Def),
  calculate_increased_stat(Spa_raw, Spa_stage, Spa),
  calculate_increased_stat(Spd_raw, Spd_stage, Spd),
  calculate_increased_stat(Ini_raw, Ini_stage, Ini).

calculate_increased_stat(Stat_before, Stat_stage, Stat_value) :-
  stat_stage_factor(Stat_stage, F),
  Stat_value is ceil(Stat_before * F).

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

process_by_priority(TA, MA, (PrA,_), TB, MB, (PrB,_), F, RA, RB, RF) :-
  PrA > PrB,
  process_moves(TA, MA, you, TB, MB, rot, F, RA, RB, RF).
process_by_priority(TA, MA, (PrA,_), TB, MB, (PrB,_), F, RA, RB, RF) :-
  PrA < PrB,
  process_moves(TB, MB, rot, TA, MA, you, F, RB, RA, RF).
process_by_priority(TA, MA, (Pr,IniA), TB, MB, (Pr,IniB), F, RA, RB, RF) :-
  IniA > IniB,
  process_moves(TA, MA, you, TB, MB, rot, F, RA, RB, RF).
process_by_priority(TA, MA, (Pr,IniA), TB, MB, (Pr,IniB), F, RA, RB, RF) :-
  IniA < IniB,
  process_moves(TB, MB, rot, TA, MA, you, F, RB, RA, RF).
process_by_priority(TA, MA, (Pr,Ini), TB, MB, (Pr,Ini), F, RA, RB, RF) :-
  random(1,3,Rnd),
  (
    (Rnd = 1, process_moves(TA, MA, you, TB, MB, rot, F, RA, RB, RF))
    ;
    process_moves(TB, MB, rot, TA, MA, you, F, RB, RA, RF)
  ).

process_moves(TA, MA, Who_A, TB, MB, Who_B, F, RA, RB, RF) :-
  process_single_move(TA, MA, Who_A, TB, F, NA, NB, NF),
  process_single_move(NB, MB, Who_B, NA, NF, RB, RA, RF).

process_single_move([[A|A_data]|Team_A], switch(Team_mate), Who, Team_B, Field, Result_A, Team_B, Field) :-
  ui_switching(A, Team_mate, Who),nl,
  process_switch([[A|A_data]|Team_A], Team_mate, Result_A).
process_single_move([A|Team_A], Move,Who,Team_B,Field, Result_A, Result_B, Result_Field) :-
  move(Move, _, status, acc(Acc), _,_,Effects),
  A = [Name_A|_],
  ui_uses_move(Name_A, Who, Move), nl,
  move_hits(Acc),!,
  process_move_effects([A|Team_A], Team_B, Field, Effects, 0, Result_A, Result_B, Result_Field).
process_single_move([A|Team_A], Move, Who, Team_B, Field, Result_A, Result_B, Result_Field) :-
  move(Move, Type, Power, acc(Acc), _,_,Effects), Power \= status,
  A = [Name_A|_],
  ui_uses_move(Name_A, Who, Move), nl,
  move_hits(Acc),!,
  process_move_damage([A|Team_A], Who, Team_B, Move, Power, Type, New_A, New_B, Damage_dealt),
  process_move_effects(New_A, New_B, Field, Effects, Damage_dealt, Result_A, Result_B, Result_Field).
process_single_move(Team_A, _, _,Team_B, Field, Team_A, Team_B, Field).

move_hits(always).
move_hits(100).
move_hits(Acc) :-
  random(0, 101, R),
  R =< Acc.
move_hits(_) :-
  ui_move_misses, nl, fail.

process_move_damage([A|Team_A], Who, [B|Team_B], Move_name, Power, Type, [A|Team_A], [New_B|Team_B], Damage_dealt) :-
  calculate_stab(A, Type, Stab),
  calculate_type_effectiveness(Type, B, Effectiveness),
  get_randomization_adjustment(R),
  get_damage_relevant_stats(Power, A, B, Atk, Def, Base_power),
  calculate_base_damage(A, Move_name, Base_power, Base_damage),
  calculate_damage(Base_damage, Atk, Def, 1, Damage),
  Damage_dealt is ceil(ceil(ceil(Damage * R) * Stab) * Effectiveness),
  opposite_player(Who, Who_opp),
  do_damage(B, Who_opp, Damage_dealt, New_B).

get_damage_relevant_stats(physical(Base_power), A, B, Atk, Def, Base_power) :-
  stats(A, Atk, _, _, _, _),
  stats(B, _, Def, _, _, _).
get_damage_relevant_stats(special(Base_power), A, B, Atk, Def, Base_power) :-
  stats(A, _, _, Atk, _, _),
  stats(B, _, _, _, Def, _).

calculate_stab([Name|_], Type, Stab) :-
  pokemon(Name, Types, _, _),
  stab(Type, Types, Stab).

stab(T, Ts, 1.5) :- member(T, Ts).
stab(T, Ts, 1) :- \+ member(T, Ts).

calculate_type_effectiveness(Type, [Name|_], E) :-
  pokemon(Name, Types, _,_),
  type_effectiveness(Type, Types, E),
  print_effectiveness_message(E).

type_effectiveness(A, [T], E) :-
  typing(A, T, E).
type_effectiveness(A, [T], 1) :-
  \+ typing(A, T, _).
type_effectiveness(A, [T1, T2], E) :-
  type_effectiveness(A, [T1], E1),
  type_effectiveness(A, [T2], E2),
  E is E1*E2.

get_randomization_adjustment(0.85). % NFI

do_damage([Name, kp(KP_old,KP_max)|Rest_data], Who, Dmg, [Name, kp(KP_new, KP_max)|Rest_data]) :-
  KP_result is KP_old - Dmg,
  KP_new is max(KP_result, 0),
  ui_hp_changed(Name, Who, kp(KP_new, KP_max)), nl.

process_move_effects(Team_A, Team_B, Field, _, _, Team_A, Team_B, Field). % NYI

process_switch([A|Team_A], Mate, Result) :-
  process_switch_acc(A, Mate, [], Team_A, Result).
process_switch_acc(A, Mate, Seen_list, [[Mate|Mate_data]|Rest], [[Mate|Mate_data]|Result]) :-
  append(Seen_list, [A|Rest], Result).
process_switch_acc(A, Mate, Seen_list, [Top|Rest], Result) :-
  Top \= [Mate|_],
  append(Seen_list, [Top], New_seen_list),
  process_switch_acc(A, Mate, New_seen_list, Rest, Result).
