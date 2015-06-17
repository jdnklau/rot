%! critical_hit_multiplier(+Attacker, +Target, +Field_target, +Move, -Multiplier)
%
% Calculates the critical hit multiplier multiplicated on top of the move's damage.
% Can be 1 if the move does not land a critical hit
%
% @arg Attacker Pokemon data of the attacking pokemon
% @arg Target Pokemon data of the defending pokemon
% @arg Field_target Field information of the target's exclusive side
% @arg Move The move used by the attacker against the target
% @arg Multiplier The resulting multiplier of the hit
critical_hit_multiplier(_, Target, _, _, 1):-
  % targets with the ability Battle Armor or Shell Armor never get hit criticaly
  ability(Target, Ability),
  member(Ability, ['battle armor', 'shell armor']),
  !. % red cut so that the ability has not to be tested again from the 2nd clause onward
critical_hit_multiplier(Attacker, Target, Field_target, Move, Final_critical_multiplier) :-
  % first calculate the critical stage of the attacker (integer from 0 to 4)
  crit_stage_increase_by_move(Move, Crit_attack), % category: move
  item(Attacker, Item), % get attacker's hold item
  crit_stage_increase_by_item(Attacker, Item, Crit_item), % category: item
  ability(Attacker, Ability), % get attacker's ability
  crit_stage_increase_by_ability(Ability, Crit_ability), % category: ability
  crit_stage_increase_by_secondary_condition(Attacker, Crit_condition), % category: secondary condition
  Crit_stage is Crit_attack + Crit_item + Crit_ability + Crit_condition,
  crit_hit_base_multiplier(Crit_stage, Critical_multiplier),
  crit_damage_increase_by_ability(Ability, Critical_multiplier, Final_critical_multiplier).

%! crit_stage_increase_by_move(+Move, -Stage_increase)
%
% Gets the increased critical hit stage by move.
% Moves with a high crit ratio result in a stage increase by 1, else 0
%
% @arg Move The move in question
% @arg Stage_increase The critical hit stage increase by the given move
crit_stage_increase_by_move(Move, 1) :-
  move(Move,_,_,_,_,_,_,_,Additional),
  member(high_crit_ratio, Additional).
crit_stage_increase_by_attack(_,0).

%! crit_stage_increase_by_item(+Pokemon, +Item, -Stage_increase)
%
% Gets the increased critical hit stage by the hold item.
% Some items give +1, some give for a specific pokemon +1, all other give +0
%
% @arg Pokemon The pokemon data of the attacking pokemon
% @arg Item The hold item of the attacking pokemon
% @arg Stage_increase The critical hit stage increase by the hold item
% @tbd Eventually optimize with cuts
crit_stage_increase_by_item(_, 'razor claw', 1).
crit_stage_increase_by_item(_, 'scope lens', 1).
crit_stage_increase_by_item(['farfetch\'d'|_], stick, 2).
crit_stage_increase_by_item(['farfetchd'|_], stick, 2). % depends on pokedex implementation
crit_stage_increase_by_item([chansey|_], 'lucky punch', 2).
crit_stage_increase_by_item(_,_,0). % no special item hold

%! crit_stage_increase_by_ability(+Ability, -Stage_increase)
%
% Gets the increased critical hit stage by ability.
% Ability _super lucky_ gives +1, else gives 0
%
% @arg Ability The ability in question
% @arg Stage_increase The critical hit stage increase by the given ability
crit_stage_increase_by_ability('super lucky', 1).
crit_stage_increase_by_ability(Ability, 0) :-
  Ability \= 'super lucky'.

%! crit_stage_increase_by_secondary_condition(+Pokemon, -Stage_increase)
%
% Gets the increased critical hit stage by secondary condition.
% Pokemon under the effect of _focus energy_ get +2, else 0
%
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Stage_increase The critical hit stage increase by secondary condition
crit_stage_increase_by_secondary_condition(Pokemon, 2) :-
  secondary_status_condition(Pokemon, focus_energy),
  !. % red cut so that the secondary condition has not to be tested again
crit_stage_increase_by_secondary_condition(_, 0).

%! crit_damage_increase_by_ability(+Ability, +Base_multiplier, -Damage_factor)
%
% Gets the damage factor of a hit depending on the users ability and the hit's base multiplier.
% A base multiplier of 1 is a non-critical hit, a base multiplier of 1.5 is a critical hit.
%
% @arg Ability The users ability
% @arg Base_multiplier The hit's base multiplier for criticals
% @arg Damage_factor The resulting critical hit factor
% @see crit_hit_base_multiplier/2
crit_damage_increase_by_ability(sniper, 1, 1). % sniper does nothing at non-crits
crit_damage_increase_by_ability(sniper, 1.5, 2.25). % sniper increases damage of crits
crit_damage_increase_by_ability(A,C,C) :- % no change of the base multiplier if the ability is not sniper
  A \= sniper.

%! crit_hit_base_multiplier(+Critical_hit_stage, -Multiplier)
%
% Decides on the given critical hit stage if the hit shall be a critical or not.
% The resulting multiplier of a non-crit is 1, and of a crit is 1.5
%
% @arg Critical_hit_stage The critical hit stage to be considered
% @arg Multiplier The resulting multiplier - either 1 or 1.5
crit_hit_base_multiplier(Stage, 1.5) :-
  move_hits_critical(Stage),
  !. % red cut as move hits critical is rng based and can not tested again whilest expecting the same result
crit_hit_base_multiplier(_, 1).
