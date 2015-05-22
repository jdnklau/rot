critical_hit_multiplier(_, Target, _, _, 1):-
  % targets with the ability Battle Armor or Shell Armor never get hit criticaly
  ability(Target, Ability),
  member(Ability, ['battle armor', 'shell armor']).
critical_hit_multiplier(Attacker, Target, Field_target, Move, Final_critical_multiplier) :- % NFI
  crit_stage_increase_by_attack(Move, Crit_attack),
  item(Attacker, Item),
  crit_stage_increase_by_item(Attacker, Item, Crit_item),
  ability(Attacker, Ability),
  crit_stage_increase_by_ability(Ability, Crit_ability),
  crit_stage_increase_by_attacker_state(Attacker, Crit_state),
  Crit_stage is Crit_attack + Crit_item + Crit_ability + Crit_state,
  crit_hit_multiplier(Crit_stage, Critical_multiplier),
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

crit_hit_multiplier(Stage, 1.5) :-
  move_hits_critical(Stage).
crit_hit_multiplier(_, 1).
