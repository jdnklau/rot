%! rot_evaluate_message_list(+Player, +Active_pokemon_player, +Active_pokemon_opponent, +Message_list).
%
% Let's rot evaluate a list of messages occured in battle.
% By this rot collects his informaion about the player's team pokemon.
%
% The list of messages can be retrieved from a message frame by get_message_frame_list/2.
%
% The 1st, 2nd, and 3rd arguments are part of the message frame meta data,
% and thus are retrievable by message_frame_meta_data/5.
%
% @arg Player The corresponding player; either `rot` or `player`
% @arg Active_pokemon_player The active pokemon's name of the given player
% @arg Active_pokemon_opponent The active pokemon's name of the given player's opponent
% @arg Message_list List of occured messages.
rot_evaluate_message_list(_,_,_,[]). % base case: empty list, nothing to evaluate
% general move observation
rot_evaluate_message_list(player, A1, A2, [move(Move)|List]) :-
  % observing a move of the opponent's pokemon
  rot_update_moves(A1,Move), % add the move to the known moves
  rot_evaluate_move(player, Move, A1, A2, List, Remaining_list), % eval this move
  rot_evaluate_message_list(player, A1, A2, Remaining_list). % eval rest
rot_evaluate_message_list(rot, A1, A2, [move(Move)|List]) :-
  % observe targeted player pokemon's defense
  rot_evaluate_move(rot, Move, A1, A2, List, Remaining_list), % eval this move
  rot_evaluate_message_list(rot, A1, A2, Remaining_list). % eval rest
rot_evaluate_message_list(Who, A1, A2, [Message|List]) :-
  % observe unrelated messages individually
  (
    % target message
    Message = target(Msg),
    opponent(Who, Who_opp),
    rot_get_pokemon_data(Who_opp,A2,Data),
    rot_evaluate_single_message(Who_opp, Data, Msg)
    ;
    rot_get_pokemon_data(Who, A1, Data),
    rot_evaluate_single_message(Who, Data, Message)
  ),
  rot_evaluate_message_list(Who,A1,A2,List). % remaining messages
rot_evaluate_message_list(Who,A1,A2,[_|List]) :-
  % skip messages that do not get evaluated
  rot_evaluate_message_list(Who,A1,A2,List).

rot_evaluate_single_message(Who,Pokemon,stat_stage(stat(S), value(V))) :-
  % attacking pokemon's status stages got changed
  increase_stat_stage(Pokemon, S, V, New_pokemon),
  rot_set_pokemon_data(Who, New_pokemon).
rot_evaluate_single_message(Who,Pokemon,ailment(A)) :-
  % primary status ailment: paralysis, burn, freeze or poison
  member(A, [paralysis,burn,poison,freeze]),
  set_primary_status_condition(Pokemon,A,New_pokemon),
  rot_set_pokemon_data(Who,New_pokemon).
rot_evaluate_single_message(Who,Pokemon,ailment(sleep)) :-
  % primary status ailment: sleep
  set_primary_status_condition(Pokemon,sleep(2,2),New_pokemon), % TODO figure out a usefull value for this
  rot_set_pokemon_data(Who,New_pokemon).
rot_evaluate_single_message(Who,Pokemon,woke_up) :-
  % pokemon woke up
  set_primary_status_condition(Pokemon,nil,New_pokemon),
  rot_set_pokemon_data(Who,New_pokemon).
rot_evaluate_single_message(Who,Pokemon,defrosted) :-
  % pokemon defrosted
  set_primary_status_condition(Pokemon,nil,New_pokemon),
  rot_set_pokemon_data(Who,New_pokemon).
rot_evaluate_single_message(rot,Pokemon,damaged(kp(C,M))) :-
  % rot's pokemon got damaged
  set_hp_frame(Pokemon,kp(C,M),New_pokemon),
  rot_update_own_pokemon(New_pokemon).
rot_evaluate_single_message(player,Pokemon,damaged(kp(C,M))) :-
  % players's pokemon got damaged
  P is round(100*C/M), % get percentage
  hp_frame(Pokemon, kp(_,Max_dom)), % get hp domain
  Hp_m in Max_dom,
  Hp_c #= Hp_m * P / 100,
  fd_dom(Hp_c,Cur_dom), % new current domain
  set_hp_frame(Pokemon,kp(Cur_dom,Max_dom),New_pokemon),
  rot_update_known_pokemon(New_pokemon).
rot_evaluate_single_message(Who,Pokemon,fainted) :-
  % pokemon fainted
  set_primary_status_condition(Pokemon,fainted,New_pokemon),
  rot_set_pokemon_data(Who,New_pokemon).
rot_evaluate_single_message(player,_,switch(Pokemon)) :-
  % change player active pokemon
  retractall(rot(opponent_active(_))),
  asserta(rot(opponent_active(Pokemon))).
rot_evaluate_single_message(rot,_,switch(Pokemon)) :-
  % change rot active pokemon
  retractall(rot(own_active(_))),
  asserta(rot(own_active(Pokemon))).
rot_evaluate_single_message(_,_,_). % not a message that gets evaluated

%! rot_evaluate_move(+Player, +Move, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Remaining_message_list).
%
% Evaluates the outcomes of an executed move.
%
% For moves used by the player, the player's attacking pokemon's offensive status value range
% gets evaluated further.
%
% For moves used by Rot itself, the player's defending pokemon's defensive status value range
% and it's hit point range are evaluated.
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The name of the attacking pokemon
% @arg Defending_pokemon The name of the defending pokemon
rot_evaluate_move(player, Move, A1, A2, List, Remaining_list) :-
  % split messages from list
  (
    % critical
    List = [critical(yes),target(damaged(kp(C,M)))|Remaining_list],
    Crit = critical(yes)
    ;
    % non-critical
    List = [target(damaged(kp(C,M)))|Remaining_list],
    Crit = critical(no)
  ),
  rot_has_pokemon_data(A2, Rot_pkm), % get pokemon data of rot
  hp_frame(Rot_pkm, kp(Old_C,_)), % get old hp value
  Dmg is Old_C - C, % get damage
  rot_evaluate_damage(player, Move, Dmg, Crit, A1, A2),
  set_hp_frame(Rot_pkm, kp(C,M), New_rot_pkm),
  rot_update_own_pokemon(New_rot_pkm).
rot_evaluate_move(rot, Move, A1, A2, List, Remaining_list) :-
  % split messages from list
  (
    % critical
    List = [critical(yes),target(damaged(kp(C,M)))|Remaining_list],
    Crit = critical(yes)
    ;
    % non-critical
    List = [target(damaged(kp(C,M)))|Remaining_list],
    Crit = critical(no)
  ),
  % to play fair we extract the percentage to which the player pokemon was brought down
  % and do not use the real values contained in the message.
  New_P is round(100*C/M), % get new hp percent
  rot_known_pokemon_data(A2, Player_pkm), % get pokemon data of player
  hp_frame(Player_pkm, kp(Cur_l..Cur_h,Max_l..Max_h)), % get old hp value's domain maximum
  Old_P is round(100*Cur_h/Max_h), % get old hp percent
  Dmg_P is Old_P - New_P, % get damage percent
  % get domains
  Hp_max in Max_l..Max_h,
  Dmg #= Hp_max * Dmg_P / 100, % get damage domain
  rot_evaluate_damage(rot, Move, Dmg, Crit, A1, A2), % evaluates defense / reduces Dmg domain even further
  % calculate hit points
  Variance in -1..1,
  New_hp_max in Max_l..Max_h,
  New_hp_max #= Dmg * 100 / Dmg_P + Variance, % new maximum
  New_hp_cur #= New_P * New_hp_max / 100, % new current
  fd_dom(New_hp_max, Hp_max_dom),
  fd_dom(New_hp_cur, Hp_cur_dom),
  % update pokemon
  rot_known_pokemon_data(A2, Player_pkm_eval), % get data again, as it was updated in rot_evaluate_damage
  set_hp_frame(Player_pkm_eval, kp(Hp_cur_dom,Hp_max_dom), New_player_pkm),
  rot_update_known_pokemon(New_player_pkm), % save changes
  % evaluate hit point ev/dv
  rot_evaluate_ev_dv(A2).

rot_evaluate_damage(player, Move, Dmg, critical(Crit), A1, A2) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _), % it is assumed that the move is not a status move
  Move_catpow =.. [Move_category, Move_base_power], % get move category and base power
  % get pokemon data
  rot_known_pokemon_data(A1, Attacker), % attacking pokemon
  rot_has_pokemon_data(A2, Target), % defending pokemon
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
  atk_stat_by_category(Attacker, Category, Atk_d), % attack stat of player pokemon
  def_stat_by_category(Target, Category, Def), % defense domain of rot pokemon
  Atk in Atk_d,
  % rebuild damage calculation
  RA in 85..100, % randomization adjustment
  Dmg #= (22 * Base_damage * Atk / (50 * Def) * F1_N/F1_D + 2)
          * CM_N/CM_D * F2_N/F2_D * RA/100 * Stab_N/Stab_D * TE_N/TE_D * F3_N/F3_D,
    % ^ adjusts Atk domain
  fd_dom(Atk, New_dom), % get new dom
  set_atk_stat_by_category(Attacker, New_dom, Category, New_attacker),
  rot_update_known_pokemon(New_attacker), % alter asserted data
  % figure attack ev/dv
  rot_evaluate_ev_dv(A1).
rot_evaluate_damage(rot, Move, Dmg, critical(Crit), A1, A2) :-
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _), % it is assumed that the move is not a status move
  Move_catpow =.. [Move_category, Move_base_power], % get move category and base power
  % get pokemon data
  rot_has_pokemon_data(A1, Attacker), % attacking pokemon
  rot_known_pokemon_data(A2, Target), % defending pokemon
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
  atk_stat_by_category(Attacker, Category, Atk), % attack stat of rot pokemon
  def_stat_by_category(Target, Category, Def_d), % defense domain of player pokemon
  Def in Def_d,
  % rebuild damage calculation
  RA in 85..100, % randomization adjustment
  Dmg #= (22 * Base_damage * Atk / (50 * Def) * F1_N/F1_D + 2)
          * CM_N/CM_D * F2_N/F2_D * RA/100 * Stab_N/Stab_D * TE_N/TE_D * F3_N/F3_D,
    % ^ adjusts Def and Dmg domain
  % assert new defense
  fd_dom(Def, New_def_dom),
  set_def_stat_by_category(Target, New_def_dom, Category, New_target),
  rot_update_known_pokemon(New_target),
  % figure out ev/dv
  rot_evaluate_ev_dv(A2).


%! rot_evaluate_ev_dv(+Pokemon_name).
%
% Recalculates the ev/dv of the given pokemon to match the possible status value ranges.
% The recalculated ev/dv are then used to update the known pokemon data.
%
% There are two assumptions to this predicate.
%
% First, the given pokemon name is assumed to relate to the player's pokemon.
% As Rot has access to it's own pokemon data in total (which would not make any sense otherwise),
% there is no need for Rot to evaluate it's own pokemon's ev/dv data
%
% Second, as the ev/dv are calculated depending on the possible status value ranges
% this predicate obviously can't evalute the ev/dv, if the status value ranges were not
% altered in the first place. So before calling this, make sure to take a good guess about
% the player's pokemon's status value ranges.
%
% @arg Pokemon_name The name of a pokemon in the player's team.
% @tbd Add HP calculations
rot_evaluate_ev_dv(A1) :-
  % access ev/dv data
  rot_known_pokemon_data(A1, Pokemon), % get pokemon
  ev_dv_data(Pokemon, EV_DV),
  % set up ev/dv domains
  rot_init_ev_dv_vars(EV_DV, EV_DV_vars),
  EV_DV_vars = ((Hp_ed, Hp_dd),(Atk_ed, Atk_dd),(Def_ed, Def_dd),(Spa_ed,Spa_dd),(Spd_ed,Spd_dd),(Spe_ed,Spe_dd)),
  % get status value domains
  hp_frame(Pokemon, kp(_,Hp_d)),
  stats(Pokemon, Atk_d, Def_d, Spa_d, Spd_d, Spe_d),
  % status value constraint vars
  Hp in Hp_d,
  Atk in Atk_d,
  Def in Def_d,
  Spa in Spa_d,
  Spd in Spd_d,
  Spe in Spe_d,
  % get base values
  pokemon(A1,_,stats(Hp_b,Atk_b,Def_b,Spa_b,Spd_b,Spe_b),_),
  % evaluate stats
  rot_evaluate_hp_stat(Hp_b,Hp,Hp_ed,Hp_dd),
  rot_evaluate_stat(Atk_b,Atk,Atk_ed,Atk_dd),
  rot_evaluate_stat(Def_b,Def,Def_ed,Def_dd),
  rot_evaluate_stat(Spa_b,Spa,Spa_ed,Spa_dd),
  rot_evaluate_stat(Spd_b,Spd,Spd_ed,Spd_dd),
  rot_evaluate_stat(Spe_b,Spe,Spe_ed,Spe_dd),
  % get new domains - ev
  fd_dom(Hp_ed, Hp_ned),
  fd_dom(Atk_ed,Atk_ned),
  fd_dom(Def_ed,Def_ned),
  fd_dom(Spa_ed,Spa_ned),
  fd_dom(Spd_ed,Spd_ned),
  fd_dom(Spe_ed,Spe_ned),
  % get new domains - dv
  fd_dom(Hp_dd, Hp_ndd),
  fd_dom(Atk_dd,Atk_ndd),
  fd_dom(Def_dd,Def_ndd),
  fd_dom(Spa_dd,Spa_ndd),
  fd_dom(Spd_dd,Spd_ndd),
  fd_dom(Spe_dd,Spe_ndd),
  % set data
  New_ev_dv_domains = ((Hp_ned, Hp_ndd),(Atk_ned, Atk_ndd),(Def_ned, Def_ndd),
                        (Spa_ned,Spa_ndd),(Spd_ned,Spd_ndd),(Spe_ned,Spe_ndd)),
  set_ev_dv_data(Pokemon,New_ev_dv_domains,New_pokemon),
  rot_update_known_pokemon(New_pokemon).

%! rot_evaluate_hp_stat(+Base_value,+Maximal_value,+EV,+DV).
% Connects the given constraint domain variables by the hit point status value formula,
% thus reducing the domain of the given variables even further.
% @arg Base_value The hit point's base value
% @arg Maximal_value A constraint variable in the possible range of maximal hit points
% @arg EV A constraint variable in the possible range of ev
% @arg DV A constraint variable in the possible range of dv
rot_evaluate_hp_stat(Base, Stat, EV, DV) :-
  % use formula
  Stat #= (2*Base + DV + EV/4 + 100)/2 + 10.

%! rot_evaluate_stat(+Base_value,+Status_value,+EV,+DV).
%
% Connects the given constraint domain variables by the status value formula, thus
% reducing the domains of the given variables even further.
%
% Not to be used for the pokemons hit points
%
% @arg Base_value The stat's base value
% @arg Status_value A constraint variable in the possible range of status values
% @arg EV A constraint variable in the possible range of ev
% @arg DV A constraint variable in the possible range of dv
rot_evaluate_stat(Base,Stat,EV,DV) :-
  % just set a another constraint
  Stat #= (2*Base + DV + EV/4)/2 + 5.
