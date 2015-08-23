%! rot_evaluate_damage(+Player, +Move, +Damage_done, +Crit_flag, +Attacking_pokemon, +Defending_pokemon, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the damage done by an offensive move.
%
% For moves used by the player, the player's attacking pokemon's offensive status value range
% gets evaluated further.
%
% For moves used by Rot itself, the player's defending pokemon's defensive status value range
% is evaluated.
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Damage_done The damage the move has done - may be a domain
% @arg Crit_flag Either `critical(yes)` or `critical(no)`
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_damage(player, Move, Dmg, critical(Crit), Attacker, Target, Result_attacker, Target) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _), % it is assumed that the move is not a status move
  Move_catpow =.. [Move_category, Move_base_power], % get move category and base power
  % critical factor
  (
    Crit = yes,
    CM = 1.5
  ;
    Crit = no,
    CM = 1
  ),
  % get damage factors
  calculate_stab(Attacker, Move_type, Stab),
  calculate_type_effectiveness(Move_type, Target, TE),
  calculate_base_damage(Attacker, Target, Field_global, Move_base_power, Move_type, Base_damage),
  calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, CM, F1), % special factor F1
  calculate_F2(Attacker, F2), % special factor F2
  calculate_F3(Attacker, Target, TE, F3), % special factor F3
  % get fractions as the clpfd does not handle decimals - ugly work around
  decimal_to_fraction(F1, F1_N, F1_D),
  decimal_to_fraction(CM, CM_N, CM_D),
  decimal_to_fraction(F2, F2_N, F2_D),
  decimal_to_fraction(Stab, Stab_N, Stab_D),
  decimal_to_fraction(TE, TE_N, TE_D),
  decimal_to_fraction(F3, F3_N, F3_D),
  % get stats
  atk_stat_by_category(Attacker, Move_category, Atk_d), % attack stat of player pokemon
  def_stat_by_category(Target, Move_category, Def), % defense domain of rot pokemon
  Atk in Atk_d,
  % rebuild damage calculation
  RA in 85..100, % randomization adjustment
  Dmg #= (22 * Base_damage * Atk / (50 * Def) * F1_N/F1_D + 2)
          * CM_N/CM_D * F2_N/F2_D * RA/100 * Stab_N/Stab_D * TE_N/TE_D * F3_N/F3_D,
    % ^ adjusts Atk domain
  fd_dom(Atk, New_dom), % get new dom
  set_staged_atk_stat_by_category(Attacker, New_dom, Move_category, New_attacker),
  % figure attack ev/dv
  rot_evaluate_ev_dv(New_attacker, Result_attacker).
rot_evaluate_damage(rot, Move, Dmg, critical(Crit), Attacker, Target, Attacker, Result_target) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _), % it is assumed that the move is not a status move
  Move_catpow =.. [Move_category, Move_base_power], % get move category and base power
  % critical factor
  (
    Crit = yes,
    CM = 1.5
  ;
    Crit = no,
    CM = 1
  ),
  % get damage factors
  calculate_stab(Attacker, Move_type, Stab),
  calculate_type_effectiveness(Move_type, Target, TE),
  calculate_base_damage(Attacker, Target, Field_global, Move_base_power, Move_type, Base_damage),
  calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, CM, F1), % special factor F1
  calculate_F2(Attacker, F2), % special factor F2
  calculate_F3(Attacker, Target, TE, F3), % special factor F3
  % get fractions as the clpfd does not handle decimals - ugly work around
  decimal_to_fraction(F1, F1_N, F1_D),
  decimal_to_fraction(CM, CM_N, CM_D),
  decimal_to_fraction(F2, F2_N, F2_D),
  decimal_to_fraction(Stab, Stab_N, Stab_D),
  decimal_to_fraction(TE, TE_N, TE_D),
  decimal_to_fraction(F3, F3_N, F3_D),
  % get stats
  atk_stat_by_category(Attacker, Move_category, Atk), % attack stat of rot pokemon
  def_stat_by_category(Target, Move_category, Def_d), % defense domain of player pokemon
  Def in Def_d,
  % rebuild damage calculation
  RA in 85..100, % randomization adjustment
  Dmg #= (22 * Base_damage * Atk / (50 * Def) * F1_N/F1_D + 2)
          * CM_N/CM_D * F2_N/F2_D * RA/100 * Stab_N/Stab_D * TE_N/TE_D * F3_N/F3_D,
    % ^ adjusts Def and Dmg domain
  % assert new defense
  fd_dom(Def, New_def_dom),
  set_staged_def_stat_by_category(Target, New_def_dom, Move_category, New_target),
  % figure out ev/dv
  rot_evaluate_ev_dv(New_target, Result_target).
