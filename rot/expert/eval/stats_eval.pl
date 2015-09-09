%! rot_evaluate_ev_dv(+Pokemon, -Evaluated_pokemon).
%
% Recalculates the ev/dv of the given pokemon to match the possible status value ranges.
%
% There are two assumptions to this predicate.
%
% First, the given pokemon data is assumed to relate to the player's pokemon.
% As Rot has access to it's own pokemon data in total (which would not make any sense otherwise),
% there is no need for Rot to evaluate it's own pokemon's ev/dv data
%
% Second, as the ev/dv are calculated depending on the possible status value ranges
% this predicate obviously can't evalute the ev/dv, if the status value ranges were not
% altered in the first place. So before calling this, make sure to take a good guess about
% the player's pokemon's status value ranges.
%
% @arg Pokemon The known pokemon data to be altered with pre-altered status value ranges
% @arg Evaluated_pokemon The pokemon data with evaluated ev/dv values
rot_evaluate_ev_dv(Pokemon, New_pokemon) :-
  % access ev/dv data
  ev_dv_data(Pokemon, EV_DV),
  % set up ev/dv domains
  rot_init_ev_dv_vars(EV_DV, EV_DV_vars),
  EV_DV_vars = ((Hp_ed, Hp_dd),(Atk_ed, Atk_dd),(Def_ed, Def_dd),(Spa_ed,Spa_dd),(Spd_ed,Spd_dd),(Spe_ed,Spe_dd)),
  % get status value domains
  hp_frame(Pokemon, kp(_,Hp_d)),
  raw_stats(Pokemon, Atk_d, Def_d, Spa_d, Spd_d, Spe_d),
  % status value constraint vars
  Hp in Hp_d,
  Atk in Atk_d,
  Def in Def_d,
  Spa in Spa_d,
  Spd in Spd_d,
  Spe in Spe_d,
  % get base values
  pokemon_name(Pokemon,Name),
  pokemon(Name,_,stats(Hp_b,Atk_b,Def_b,Spa_b,Spd_b,Spe_b),_),
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
  set_ev_dv_data(Pokemon,New_ev_dv_domains,New_pokemon).

%! rot_evaluate_hp_stat(+Base_value,+Maximal_value,+EV,+DV).
% Connects the given constraint domain variables by the hit point status value formula,
% thus reducing the domain of the given variables even further.
% @arg Base_value The hit point's base value
% @arg Maximal_value A constraint variable in the possible range of maximal hit points
% @arg EV A constraint variable in the possible range of ev
% @arg DV A constraint variable in the possible range of dv
rot_evaluate_hp_stat(Base, Stat, EV, DV) :-
  % use formula
  Stat #= (2*Base + DV + EV//4 + 100)//2 + 10.

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
  Stat #= (2*Base + DV + EV//4)//2 + 5.

%! rot_evaluate_speed_by_message_frames(+Message_frame_first, +Message_frame_second).
%
% If the message frames' corresponding actions relate to moves with same priority
% the speed stat of Rot's opponent's active pokemon will be evaluated.
%
% @arg Message_frame_first The message frame caused by the faster player.
% @arg Message_frame_first The message frame caused by the slower player.
rot_evaluate_speed_by_message_frames(F1,F2) :-
  % get data from frames
  message_frame_meta_data(F1,Who_first,Ac_first,P_first,P_second),
  message_frame_meta_data(F2,Who_second,Ac_second,_,_),
  % get pokemon data
  rot_get_pokemon_data(Who_first,P_first,Pokemon_first),
  rot_get_pokemon_data(Who_second,P_second,Pokemon_second),
  % evaluate
  rot_evaluate_speed(Who_first, Pokemon_first, Pokemon_second, Ac_first, Ac_second, New_first, New_second),
  % set new data
  rot_set_pokemon_data(Who_first, New_first),
  rot_set_pokemon_data(Who_second, New_second).
rot_evaluate_speed_by_message_frames(_,_). % case if no comparisson is possible

%! rot_evaluate_speed(+Faster_player, +Faster_pokemon, +Slower_pokemon, +Faster_action, +Slower_action, -Result_faster_pokemon, -Result_slower_pokemon).
%
% Evaluates the speed stat of Rot's opponent's pokemon.
%
% The speed stat's domain of the opponent's pokemon will be reduced to be greater or equal than
% Rot's pokemon's speed stat if the opponent is faster, or to be less or equal respectively.
%
% This works only for moves with the same base priority.
% If at least on action is not a move or the given actions do not have the same base priority
% the evaluation will be skipped.
%
% @arg Faster_player The player acting first; either `rot` or `player`
% @arg Faster_pokemon The pokemon data of the faster pokemon
% @arg Slower_pokemon The pokemon data of the slower pokemon
% @arg Faster_action The action executed first
% @arg slower_action The action executed last
% @arg Result_faster_pokemon The resulting pokemon data of the faster pokemon.
% @arg Result_slower_pokemon The resulting pokemon data of the slower pokemon.
rot_evaluate_speed(player, First, Second, Ac1, Ac2, Result_first, Second) :-
  % only evaluate for moves with same priority
  move(Ac1,_,_,_,_,Prio,_,_,_),
  move(Ac2,_,_,_,_,Prio,_,_,_),
  !,
  % get speed domains
  stats(First,_,_,_,_,Spe_1_d),
  stats(Second,_,_,_,_,Spe_2),
  Spe_1 in Spe_1_d,
  % compare speed stats
  Spe_1 #>= Spe_2,
  % set new domain
  fd_dom(Spe_1, New_dom),
  set_staged_stat(First, New_dom, speed, New_first),
  rot_evaluate_ev_dv(New_first, Result_first).
rot_evaluate_speed(rot, First, Second, Ac1, Ac2, First, Result_second) :-
  % only evaluate for moves with same priority
  move(Ac1,_,_,_,_,Prio,_,_,_),
  move(Ac2,_,_,_,_,Prio,_,_,_),
  !,
  % get speed domains
  stats(First,_,_,_,_,Spe_1),
  stats(Second,_,_,_,_,Spe_2_d),
  Spe_2 in Spe_2_d,
  % compare speed stats
  Spe_1 #>= Spe_2,
  % set new domain
  fd_dom(Spe_2, New_dom),
  set_staged_stat(Second, New_dom, speed, New_second),
  rot_evaluate_ev_dv(New_second, Result_second).
rot_evaluate_speed(_,First,Second,_,_,First,Second). % backup case if no comparisson can be done.
