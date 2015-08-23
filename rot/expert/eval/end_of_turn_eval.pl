%! rot_evaluate_end_of_turn(+Player, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the outcomes of the end of turn routine.
%
% This includes such things as damage by primary status conditions, like burn, or
% damage by weather effects, like sand storm.
%
% @arg Player Either `rot` or `player`
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_end_of_turn(Who,P1,P2,List,Res_P1,Res_P2) :-
  rot_evaluate_end_of_turn_damage(Who,P1,P2,List,Damaged_P1,Damages_P2,Damaged_list),
  rot_evaluate_end_of_turn_switch(Who,Damaged_P1,Damages_P2,Damaged_list,Res_P1,Res_P2,_).

%! rot_evaluate_end_of_turn_damage(+Player, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the damage or healing done at the end of turn.
%
% @arg Player Either `rot` or `player`
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_end_of_turn_damage(Who,P1,P2,List,Res_P1,Res_P2,Res_list) :-
  rot_evaluate_primary_status_condition_damage(Who,P1,P2,List,Res_P1,Res_P2,Res_list).

%! rot_evaluate_primary_status_condition_damage(+Player, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% Evaluates the damage caused by burn, poison or bad poison
%
% @arg Player Either `rot` or `player`
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_primary_status_condition_damage(Who,P1,P2,List,Res_P1,Res_P2,Res_list) :-
  % burn
  primary_status_condition(P1,burn),
  rot_ask_message(burns,_,List,Burns_list),
  rot_ask_message(damaged,[Hp_frame],Burns_list,Burned_list),
  rot_evaluate_new_hp_frame(Who,P1,Hp_frame,New_p1), % apply damage
  rot_evaluate_fainting(Who,New_p1,P2,Burned_list,Res_P1,Res_P2,Res_list). % check if fainted
rot_evaluate_primary_status_condition_damage(Who,P1,P2,List,Res_P1,Res_P2,Res_list) :-
  % poison
  primary_status_condition(P1,poison),
  rot_ask_message(poisoned,_,List,Poisons_list),
  rot_ask_message(damaged,[Hp_frame],Burns_list,Poisoned_list),
  rot_evaluate_new_hp_frame(Who,P1,Hp_frame,New_p1), % apply damage
  rot_evaluate_fainting(Who,New_p1,P2,Poisoned_list,Res_P1,Res_P2,Res_list). % check if fainted
rot_evaluate_primary_status_condition_damage(Who,P1,P2,List,P1,P2,List). % base case: no condition

%! rot_evaluate_end_of_turn_switch(+Player, +Attacking_pokemon, +Defending_pokemon, +Message_list, -Evaluated_attacker, -Evaluated_defender).
%
% TODO Alter the end of turn switch behavior in general
%
% @arg Player Either `rot` or `player`
% @arg Attacking_pokemon The data of the attacking pokemon
% @arg Defending_pokemon The data of the defending pokemon
% @arg Message_list A list of messages, retrieved from the move corresponding message frame
% @arg Evaluated_attacker The evaluated data of the attacking pokemon
% @arg Evaluated_defender The evaluated data of the defending pokemon
rot_evaluate_end_of_turn_switch(Who,P1,P2,List,Res_P1,Res_P2,Res_list) :-
  % evaluate a switch
  rot_ask_message(switch,[In_name],List,Res_list),!,
  rot_get_pokemon_data(Who,In_name,In),
  rot_evaluate_switch(Who, P1, In, P2, List, Res_P1, New_in, Res_P2),
  rot_set_pokemon_data(Who,New_in). % update pokemon data of third pokemon
rot_evaluate_end_of_turn_switch(Who,P1,P2,List,P1,P2,List). % base case: no switch
