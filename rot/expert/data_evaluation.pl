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
%% evaluate the player
rot_evaluate_message_list(player, A1, A2, [move(Move)|List]) :-
  % observing a move of the opponent's pokemon
  rot_update_moves(A1,Move), % add the move to the known moves
  rot_evaluate_move(player, Move, A1, A2, List, Remaining_list), % eval this move
  rot_evaluate_message_list(player, A1, A2, List). % eval rest
rot_evaluate_message_list(Who,A1,A2,[_|List]) :-
  % skip messages that do not get evaluated
  rot_evaluate_message_list(Who,A1,A2,List).

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
    Crit = critical(yes),
    write(found(crit)),nl
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

rot_evaluate_damage(Who, Move, Dmg, critical(Crit), A1, A2) :-
  % get pokemon data
  rot_get_pokemon_data(Who, A1, Attacker), % attacking pokemon
  opponent(Who, Not_who), % get opposing player
  rot_get_pokemon_data(Not_who, A2, Target), % defending pokemon
  % critical factor
  (
    Crit = yes,
    CM = 1.5
    ;
    Crit = no,
    CM = 1
  ),
  % get damage factors
  move(Move, Move_type, Move_catpow, _, _, _, _, _, _), % it is assumed that the move is not a status move
  Move_catpow =.. [Move_category, Move_base_power], % get move category and base power
  calculate_stab(Attacker, Move_type, Stab),
  calculate_type_effectiveness(Move_type, Target, TE),
  calculate_base_damage(Attacker, Target, Field_global, Move_base_power, Move_type, Base_damage),
  calculate_F1(Attacker, Field_target, Field_global, Move_type, Move_category, CM, F1), % special factor F1
  calculate_F2(Attacker, F2), % special factor F2
  calculate_F3(Attacker, Target, TE, F3), % special factor F3
  % break damage down (divide the factors off)
  Raw_dmg is Dmg / F3 / TE / Stab / F2,% remaining: 22 * BaseDamage * AtkDefCoef * F1 FIXME ignoring the +2 part of formula
  Atk_def_coef is Raw_dmg / F1 / Base_damage / 22,
  rot_evaluate_attack_stat(Move_category, A1, A2, Atk_def_coef).

%! rot_evaluate_attack_stack(+Category, +Attacking_pokemon_name, +Defending_pokemon_name, +Coefficient).
%
% Recalculates the attacking pokemon's offensive status value, depending on the
% given damage category.
%
% The calculation uses the given coefficient, as it is assumed the coefficient
% is of the form `attackers offensive stat / 50 * defenders defense stat`.
% This is inline with the damage calculation formula.
%
% As Rot has full access to it's own pokemon data, the predicate assumes that the
% attacking pokemon is from the player's team.
%
% @arg Category The damage category for the offensive stat to be recalculated; either `special` or `physical`
% @arg Attacking_pokemon_name The name of the player's pokemon which attack stat shall be evaluated
% @arg Defending_pokemon_name The name of Rot's pokemon
% @arg Coefficient An attack/defense coefficient as mentioned in the predicate descritpion.
rot_evaluate_attack_stat(Category, A1, A2, ADC) :-
  rot_known_pokemon_data(A1, Pkm_player), % get player pokemon
  rot_has_pokemon_data(A2, Pkm_rot), % get rot pokemon
  % get stats
  def_stat_by_category(Pkm_rot, Category, Def), % rot def stat
  atk_stat_by_category(Pkm_player, Category, Atk_dom), % player atk stat domain
  % figure attack stat out
  Atk in Atk_dom, % at least the stat is in the old known domain
  Assumed_atk is ceil(ADC * 50 * Def),
  Assumed_low is floor(Assumed_atk*0.85), % take randomization adjustment into account
  Assumed_high is floor(Assumed_atk/0.85), % take randomization adjustment into account
  Atk in Assumed_low..Assumed_high, % the stat is also in the just calculated range
  fd_dom(Atk, New_dom), % get new dom
  write(old(Atk_dom)-new(New_dom)),nl, % TODO delete this line
  set_atk_stat_by_category(Pkm_player, New_dom, Category, New_pkm_player),
  rot_update_known_pokemon(New_pkm_player), % alter asserted data
  % figure attack ev/dv
  rot_evaluate_ev_dv(A1).

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
  hp_frame(Pokemon, kp(Hp_curr_d,Hp_d)),
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
  rot_evaluate_stat(Atk_b,Atk,Atk_ed,Atk_dd),
  rot_evaluate_stat(Def_b,Def,Def_ed,Def_dd),
  rot_evaluate_stat(Spa_b,Spa,Spa_ed,Spa_dd),
  rot_evaluate_stat(Spd_b,Spd,Spd_ed,Spd_dd),
  rot_evaluate_stat(Spe_b,Spe,Spe_ed,Spe_dd),
  % get new domains - ev
  fd_dom(Hp_ed, Hp_ned), % FIXME Add hp calculations
  fd_dom(Atk_ed,Atk_ned),
  fd_dom(Def_ed,Def_ned),
  fd_dom(Spa_ed,Spa_ned),
  fd_dom(Spd_ed,Spd_ned),
  fd_dom(Spe_ed,Spe_ned),
  % get new domains - dv
  fd_dom(Hp_ed, Hp_ndd), % FIXME Add hp calculations
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

%! rot_evaluate_stat(+Base_stat,+Status_value,+EV,+DV).
%
% Connects the given constraint domain variables by the status value formula, thus
% reducing the domains of the given variables even further.
%
% Not to be used for the pokemons hit points
%
% @arg Base_stat The stat's base value
% @arg Status_value A constraind variable in the possible range of status values
% @arg EV A constraind variable in the possible range of ev
% @arg DV A constraind variable in the possible range of dv
rot_evaluate_stat(Base,Stat,EV,DV) :-
  % just set a another constraint
  Stat #= (2*Base + DV + EV/4)/2 + 5.
