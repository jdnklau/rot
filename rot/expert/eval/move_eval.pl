%! rot_ask_message(+Ask, -Value, +Data, -Remaining_data).
% True if the first element of the Data list has the given functor Ask.
%
% Therefore the first entry in the list has to unify this piece of code
%     FirstData =.. [Ask|Value]
%
% The first element is then deleted from the list.
% @arg Ask The information to be asked for
% @arg Value The value the information holds
% @arg Data The data that contains the information
% @arg Remaining_data The data without the asked information
rot_ask_message(target(Ask), Value, [target(Data)|Rest], Rest) :-
  % ask for targeted information
  !, % don't back track to base case
  rot_ask_message(Ask, Value, [Data|Rest], Rest).
rot_ask_message(Ask, Value, [user(Message)|Rest], Rest) :-
  % with user frame
  !, % do not backtrack to base case
  rot_ask_message(Ask,Value,[Message|Rest],Rest).
rot_ask_message(Ask, Value, [Message|Rest], Rest) :-
  % base case
  atomic(Ask),
  Message =.. [Ask|Value].

%! rot_evaluate_move(+Player, +Move, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the outcomes of an executed move.
%
% Firstly handles possibilities, that the move may not be executed, like when the attacking
% pokemon is asleep or paralyzed. It also handles things like pokemon waking up.
%
% If nothing stops the move from comming to execution, rot_evaluate_move_execution/7 is called
% to further handle the data.
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_move(Who, Move, Attacker, Target, List, Res_attacker, Res_target) :-
  % check if the user sleeps
  primary_status_condition_category(Attacker, sleep),
  (
    % keeps sleeping
    rot_ask_message(sleeps,_,List,_),
    Res_attacker = Attacker,
    Res_target = Target
  ;
    % woke up
    rot_ask_message(woke_up,_,List,Move_list),
    set_primary_status_condition(Attacker,nil,New_attacker), % clear status condition
    rot_evaluate_move_execution(Who,Move,New_attacker,Target,Move_list,Res_attacker,Res_target)
  ).
rot_evaluate_move(Who, Move, Attacker, Target, List, Res_attacker, Res_target) :-
  % check if the user is paralyzed
  primary_status_condition_category(Attacker, paralysis),
  (
    % can not attack
    rot_ask_message(paralyzed,_,List,_),
    Res_attacker = Attacker,
    Res_target = Target
  ;
    % can attack
    rot_evaluate_move_execution(Who,Move,Attacker,Target,List,Res_attacker,Res_target)
  ).
rot_evaluate_move(Who, Move, Attacker, Target, List, Res_attacker, Res_target) :-
  % check if the user is frozen
  primary_status_condition_category(Attacker, freeze),
  (
    % keeps sleeping
    rot_ask_message(frozen,_,List,_),
    Res_attacker = Attacker,
    Res_target = Target
  ;
    % thaw up
    rot_ask_message(defrosted,_,List,Move_list),
    set_primary_status_condition(Attacker,nil,New_attacker), % clear status condition
    rot_evaluate_move_execution(Who,Move,New_attacker,Target,Move_list,Res_attacker,Res_target)
  ).
rot_evaluate_move(Who, Move, Attacker, Target, List, Res_attacker, Res_target) :-
  % base case
  rot_evaluate_move_execution(Who,Move,Attacker,Target,List,Res_attacker,Res_target).

%! rot_evaluate_move_execution(+Player, +Move, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the execution of a move.
%
% Distinguishes between status moves and offensive moves, calling
% rot_evaluate_status_move/7 or rot_evaluate_offensive_move/7 respectively.
%
% Also handles any events after the move usage that could lead to it failing its proper
% execution, like when the move misses or the target is protected.
%
% Furthermore the known move list of the player's pokemon will be adjusted using rot_evaluate_move_set/4
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_move_execution(Who, Move, Attacker, Target, List, New_attacker, New_target) :-
  rot_ask_message(move,[Move],List,Move_list), % pop move usage data
  \+ rot_ask_message(move_missed,_,Move_list,_),% move may not have missed from here on
  \+ rot_ask_message(effectiveness,[none],Move_list,_),% move may not have any effect on the target
  !,
  rot_evaluate_move_set(Who, Move, Attacker, UAttacker), % update attacker moveset
  move(Move,_,Catpow,_,_,_,_,_,_),
  (
    % distinguish between status moves and offensive moves
    Catpow = status,
    rot_evaluate_status_move(Who, Move, UAttacker, Target, Move_list, New_attacker, New_target)
  ;
    Catpow =.. [_,_],
    rot_evaluate_offensive_move(Who, Move, UAttacker, Target, Move_list, New_attacker, New_target)
  ).
rot_evaluate_move_execution(Who, Move, Attacker, Target, List, UAttacker, Target) :- % evaluates missed moves
  rot_evaluate_move_set(Who, Move, Attacker, UAttacker). % update attacker moveset

%! rot_evaluate_move_set(+Player, +Move, +Attacking_pokemon, -Evaluated_attacker).
% Evaluates the possible move set for a pokemon.
%
% Adds a used move to the move set of the player's pokemon.
% Skips evaluation for rot's pokemon, as rot's pokemon's sets are known to rot% @arg Player Either `rot` or `player`
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
rot_evaluate_move_set(player,Move,Attacker,New_attacker) :-
  % for player: update data
  rot_update_moves(Attacker,Move,New_attacker).
rot_evaluate_move_set(rot,_,A,A). % for rot: do nothing as set is known completely

%! rot_evaluate_offensive_move(+Player, +Move, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the execution of an offensive move.
%
% For moves used by the player, the player's attacking pokemon's offensive status value range
% gets evaluated further.
%
% For moves used by Rot itself, the player's defending pokemon's defensive status value range
% and it's hit point range are evaluated.
%
% rot_evaluate_move_effects/7 is called to further handle any effects caused by the move
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_offensive_move(player, Move, Attacker, Target, List, Result_attacker, Result_target) :-
  % evaluate generic move of player
  move(Move, _,_,_,_,_,_,_,Effects), % get move data to be used
  rot_evaluate_critical_move(player,Move,Attacker,Target,List,Attacker_crit,Target_crit,Crit_flag,Dmg_list),
  % get damage done
  rot_ask_message(target(damaged),[kp(Cur,Max)],Dmg_list,Damaged_list), % new hp frame contained in message
  rot_evaluate_fainting(player,Attacker_crit,Target_crit,Damaged_list,Player_pkm,Rot_pkm,Effect_list), % note the renaming of Attacker/Target to Player_pkm/Rot_pkm.
  hp_frame(Rot_pkm, kp(Old_cur,_)), % get old hp value
  % set up damage domain
  (
    % target fainted
    Cur is 0,
    Dmg #>= Old_cur - Cur % damage at least that high
  ;
    % target not fainted
    Cur > 0,
    Dmg #= Old_cur - Cur % damage is precisely known
  ),
  rot_evaluate_damage(player, Move, Dmg, Crit_flag, Player_pkm, Rot_pkm, New_player_pkm, New_rot_pkm),
  set_hp_frame(New_rot_pkm, kp(Cur,Max), Damaged_rot_pkm),
  % evaluate effects
  rot_evaluate_move_effects(player, Effects, New_player_pkm, Damaged_rot_pkm, Effect_list, Result_attacker, Result_target).
rot_evaluate_offensive_move(rot, Move, Attacker, Target, List, Result_attacker, Result_target) :-
  % evaluate generic move of rot
  move(Move, _,_,_,_,_,_,_,Effects), % get move data to be used
  rot_evaluate_critical_move(rot,Move,Attacker,Target,List,Attacker_crit,Target_crit,Crit_flag,Dmg_list),
  % get damage done
    % to play fair we extract the percentage to which the player pokemon was brought down
    % and do not use the real values contained in the message.
  rot_ask_message(target(damaged),[kp(Cur,Max)],Dmg_list,Damaged_list), % new hp frame contained in message
  rot_evaluate_fainting(rot,Attacker_crit,Target_crit,Damaged_list,Rot_pkm,Player_pkm,Effect_list), % note the renaming of Attacker/Target to Rot_pkm/Player_pkm.
  (
    % if the player's pokemon fainted by our move, we don't care to evaluate it's stats any further
    fainted(Player_pkm),
    Rot_pkm = Result_attacker,
    Player_pkm = Result_target
  ;
    \+ fainted(Player_pkm),
    P_variance in 0..1,
    % get new hp percent
    New_P in 0..100,
    New_P #= 100*Cur//Max + P_variance,
    hp_frame(Player_pkm, kp(Cur_l..Cur_h,Max_l..Max_h)), % get old hp value's domain maximum
    % get old hp percent
    Hp_max in Max_l..Max_h,
    Old_P_1 is 100*Cur_l//Max_l,
    Old_P_2 is 100*Cur_h//Max_h,
    Old_P_l is min(Old_P_1,Old_P_2),
    Old_P_h is max(Old_P_1,Old_P_2),
    Old_P in 0..100,
    Old_P in Old_P_l..Old_P_h,
    %Old_P is round(100*Cur_h/Max_h), % get old hp percent
    Dmg_P #= Old_P - New_P, % get damage percent
    Dmg_P #>= 0, % no negative damage
    % get domains
    % set up damage domain
    Dmg #= Hp_max * Dmg_P // 100 + P_variance, % domain should be pretty accurate
    rot_evaluate_damage(rot, Move, Dmg, Crit_flag, Rot_pkm, Player_pkm, New_rot_pkm, New_player_pkm), % evaluates defense / reduces Dmg domain even further
    % calculate hit points
    New_hp_max in Max_l..Max_h,
    (
      Dmg_P #= 0,! % no damage done
    ;
      Dmg #= New_hp_max * Dmg_P //100 % new maximum
    ),
    New_hp_cur #= New_P * New_hp_max // 100, % new current
    fd_dom(New_hp_max, Hp_max_dom),
    fd_dom(New_hp_cur, Hp_cur_dom),
    % update pokemon
    set_hp_frame(New_player_pkm, kp(Hp_cur_dom,Hp_max_dom), Damaged_player_pkm),
    % evaluate hit point ev/dv
    rot_evaluate_ev_dv(Damaged_player_pkm, Evaluated_player_pkm),
    % evaluate effects
    rot_evaluate_move_effects(rot, Effects, New_rot_pkm, Evaluated_player_pkm, Effect_list, Result_attacker, Result_target)
  ).

%! rot_evaluate_critical_move(+Player, +Move, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender, -Crit_flag, -Remaining_list).
%
% Takes critical hit information from the message list, evaluates it, and returns a critical hit flag.
%
% The flag may be either `critical(yes)` or `critical(no)`
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
% @arg Crit_flag Either `critical(yes)` or `critical(no)`
% @arg Remaining_list The message list without the critical hit message
rot_evaluate_critical_move(Who,Move,Attacker,Target,List,Attacker,Target,critical(Crit_flag),New_list) :-
  rot_ask_message(critical,[Crit_flag],List,New_list), !.
rot_evaluate_critical_move(Who,Move,Attacker,Target,List,Attacker,Target,critical(no),List).

%! rot_evaluate_fainting(+Player, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender, -Remaining_list).
%
% Marks a pokemon as fainted if a corresponding fainted message occurred.
% Does nothing otherwise.
%
% @arg Player Either `rot` or `player`
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
% @arg Remaining_list The message list without a leading fainted message
rot_evaluate_fainting(Who,Attacker,Target,List,Attacker,Res_target,Res_list) :-
  % target fainted
  rot_ask_message(target(fainted),_,List,Res_list),!,
  opponent(Who,Not_who),
  rot_flag_fainted(Not_who,Target,Res_target).
rot_evaluate_fainting(Who,Attacker,Target,List,Res_attacker,Target,Res_list) :-
  % user fainted
  rot_ask_message(fainted,_,List,Res_list),!,
  rot_flag_fainted(Who,Attacker,Res_attacker).
rot_evaluate_fainting(Who,Attacker,Target,List,Attacker,Target,List). % nobody fainted

rot_flag_fainted(Who, Pokemon, Fainted_pkm) :-
  rot_flag_fainted_hp(Who,Pokemon,Zero_hp_pkm),
  set_primary_status_condition(Zero_hp_pkm, fainted, Fainted_pkm).

rot_flag_fainted_hp(rot,Pokemon,Result) :-
  hp_frame(Pokemon, kp(_,Max)),
  set_hp_frame(Pokemon, kp(0,Max),Result).
rot_flag_fainted_hp(player,Pokemon,Result) :-
  hp_frame(Pokemon, kp(_,Max)),
  set_hp_frame(Pokemon, kp(0..0,Max),Result).

%! rot_evaluate_move_effects(+Player, +Effects, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the effects a move may cause.
%
% For each effect rot_evaluate_move_single_effect/7 is called.
%
% @arg Player Either `rot` or `player`
% @arg Effects A list of effects, that are evaluated consecutively
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_move_effects(_,[],A,T,_,A,T). % base case: no effects
rot_evaluate_move_effects(Who, [E|Es], Attacker, Target, List, Result_attacker, Result_target) :-
  % evaluate effects one after another
  rot_evaluate_move_single_effect(Who, E, Attacker, Target, List, New_attacker, New_target),
  rot_evaluate_move_effects(Who, Es, New_attacker, New_target, List, Result_attacker, Result_target).

%! rot_evaluate_move_single_effect(+Player, +Effect, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates a specific move effect
%
% @arg Player Either `rot` or `player`
% @arg Effect A single effect a move can cause
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_move_single_effect(_, ailment(A, _), User, Target, List, User, New_target) :-
  % possible primary status condition
  member(A, [burn,freeze,paralysis,poison]),
  member(target(ailment(A)),List),
  set_primary_status_condition(Target,A,New_target).
rot_evaluate_move_single_effect(_, ailment(bad-poison, _), User, Target, List, User, New_target) :-
  % possible ailment: bad poison
  member(target(ailment(bad-poison)),List),
  set_primary_status_condition(Target,poison(1),New_target).
rot_evaluate_move_single_effect(_, ailment(sleep,_,_),User,Target,List,User,New_target) :-
  % possible sleep infliction
  member(target(ailment(sleep)),List),
  set_primary_status_condition(Target,sleep(2,2),New_target). % TODO find good initial value
rot_evaluate_move_single_effect(Who, stats(user,_,Data),User,Target,List,New_user,Target) :-
  % user's status value increases (probably)
  rot_evaluate_move_status_increases(Who, Data, User, List, New_user).
rot_evaluate_move_single_effect(Who, stats(target,_,Data),User,Target,List,User,New_target) :-
  % target's status value increases (probably)
  opponent(Who,Not_who),
  rot_evaluate_move_status_increases(Not_who, Data, Target, List, New_target).
rot_evaluate_move_single_effect(Who, Recoil,User,Target,Fc_list,New_user,Target_fc) :-
  % recoil damage
  member(Recoil,[heal(_),drain(_)]),
  Recoil =.. [_,Value],
  Value < 0, % negative drain is recoil damage
  append(_,[recoil,damaged(Hp_frame)|_],List), % damage was dealt
  rot_evaluate_fainting(Who,User,Target,List,User_fc,Target_fc,Fc_list),
  rot_evaluate_new_hp_frame(Who,Hp_frame,User_fc,New_user).
rot_evaluate_move_single_effect(Who, drain(Value),User,Target,List,New_user,Target) :-
  % drained life
  Value >= 0,
  append(_,[drain,damaged(Hp_frame)|_],List), % damage was dealt
  rot_evaluate_new_hp_frame(Who,Hp_frame,User,New_user).
rot_evaluate_move_single_effect(Who, heal(Value),User,Target,List,New_user,Target) :-
  % healed life
  Value >= 0,
  append(_,[heal,damaged(Hp_frame)|_],List), % damage was dealt
  rot_evaluate_new_hp_frame(Who,Hp_frame,User,New_user).
% ignored/not evaluated effect clause:
rot_evaluate_move_single_effect(_,_,User,Target,_,User,Target).

%! rot_evaluate_new_hp_frame(+Player, +Hp_frame, +Pokemon, -Resulting_pokemon).
%
% Sets the hp frame of a given pokemon.
%
% This is intended to be used for effects causing the `damaged(kp(Current,Maximum))` message.
% For pokemon of the player, rather than substituting the hp frames, only the percentage from the
% new frame will be taken and the old frame will be altered to match this new percentage,
% allowing this predicate to work perfectly to alter the player's hit poins despite they are only known
% percentage wise.
%
% @arg Player Either `rot` or `player`
% @arg Hp_frame The new hp frame of the pokemon
% @arg Pokemon The pokemon data to be altered
% @arg Result_pokemon The altered pokemon data
rot_evaluate_new_hp_frame(rot,Hp_frame,Pokemon,Res_pokemon) :-
  % rot's pokemon got damaged
  set_hp_frame(Pokemon,Hp_frame,Res_pokemon).
rot_evaluate_new_hp_frame(player,kp(C,M),Pokemon,Res_pokemon) :-
  % players's pokemon got damaged
  P is round(100*C/M), % get percentage
  hp_frame(Pokemon, kp(_,Max_dom)), % get hp domain
  Hp_m in Max_dom,
  Hp_c #= Hp_m * P // 100,
  fd_dom(Hp_c,Cur_dom), % new current domain
  set_hp_frame(Pokemon,kp(Cur_dom,Max_dom),Res_pokemon).

%! rot_evaluate_status_increases(+Player, +Increases, +Pokemon, +Message_list, -Result_pokemon).
%
% Evaluates status value stage increases or decreases.
%
% The increases are given as a list of tuples of the form (Status_value_name, Increase_value).
% Status_value_name can be one of the following:
%   * attack
%   * defense
%   * special-attack
%   * special-defense
%   * speed
% Increase_value may be an integer in the range from -12 to 12
%
% @arg Player Either `rot` or `player`
% @arg Increases A list of status increases
% @arg Pokemon The pokemon data to be altered
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Result_pokemon The altered pokemon data
rot_evaluate_move_status_increases(_,[],P,_,P). % base case: nothing to iterate
rot_evaluate_move_status_increases(Who, [(Stat,Value)|Is], P, List, Result_p) :-
  % increase the given stat
  (
    % stat was altered
    (
      % no target frame
      member(stat_stage(stat(Stat),value(Value)),List)
    ;
      % target frame
      member(target(stat_stage(stat(Stat),value(Value))),List)
    ),
    increase_stat_stage(P, Stat, Value, New_p)
  ;
    % stat not altered
    New_p = P
  ),
  rot_evaluate_move_status_increases(Who,Is,New_p,List,Result_p).

%! rot_evaluate_status_move(+Player, +Move, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the execution of a status move.
%
% rot_evaluate_move_effects/7 is called to further handle any effects caused by the move
%
% @arg Player Either `rot` or `player`
% @arg Move The move being used
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_status_move(Who, Move, Attacker, Target, List, Res_attacker, Res_target) :-
  move(Move, _,_,_,_,_,_,_,Effects), % get move data to be used
  rot_evaluate_move_effects(Who, Effects, Attacker, Target, List, Res_attacker, Res_target).
