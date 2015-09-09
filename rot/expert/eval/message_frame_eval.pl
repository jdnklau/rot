%! rot_evaluate_message_frames(+Message_frame_first, +Message_frame_second).
%
% Evaluates two message frames in respective order.
%
% If the frames are move useage frames the player's pokemon's speed stat get's
% properly adjusted.
%
% @arg Message_frame_first The first message frame to be evaluated
% @arg Message_frame_second The second message frame to be evaluated
rot_evaluate_message_frames(Frame_first, Frame_second) :-
  rot_evaluate_speed_by_message_frames(Frame_first, Frame_second),
  rot_evaluate_message_frame(Frame_first),
  rot_evaluate_message_frame(Frame_second).

%! rot_evaluate_message_frame(+Message_frame).
%
% Let's Rot evaluate a message frame to collect information about the battle and thus
% constructing/updating the known pokemon data of the player's team pokemon.
%
% @arg Message_frame The message frame to be evaluated
rot_evaluate_message_frame(Frame) :-
  % skip empty message frames
  empty_message_frame(Frame),!.
rot_evaluate_message_frame(Frame) :-
  % evaluate switches
  message_frame_meta_data(Frame, Who, Switch_action, Out_name, Opp_name), % get action
  % test if it is an action involving only a switch
  member(Switch_action, [switch(_),fainted_check]), % all viable actions leading to switches
  get_message_frame_list(Frame, List), % get list of messages
  member(switch(In_name),List),
  % get pokemon data
  rot_get_pokemon_data(Who, In_name, In),
  rot_get_pokemon_data(Who, Out_name, Out),
  opponent(Who, Not_who),
  rot_get_pokemon_data(Not_who, Opp_name, Opp),
  % do the switch
  rot_evaluate_switch(Who, Out, In, Opp, List, New_out, New_in, New_opp),
  % save data
  rot_set_pokemon_data(Who,New_out),
  rot_set_pokemon_data(Who,New_in),
  rot_set_pokemon_data(Not_who,New_opp).
rot_evaluate_message_frame(Frame) :-
  % evaluate moves
  message_frame_meta_data(Frame, Who, Move, A1, A2), % get move
  move(Move,_,_,_,_,_,_,_,_),
  get_message_frame_list(Frame, Move_list), % get list of messages
  % get pokemon data
  opponent(Who,Not_who),
  rot_get_pokemon_data(Who,A1,Attacker),
  rot_get_pokemon_data(Not_who,A2,Target),
  rot_evaluate_move(Who, Move, Attacker, Target, Move_list, New_attacker, New_target),
  % update data
  rot_set_pokemon_data(Who, New_attacker),
  rot_set_pokemon_data(Not_who, New_target).
rot_evaluate_message_frame(Frame) :-
  % evaluate end of turn
  message_frame_meta_data(Frame, Who, end_of_turn, A1, A2), % get action
  get_message_frame_list(Frame,List),
  % get pokemon data
  opponent(Who,Not_who),
  rot_get_pokemon_data(Who,A1,Attacker),
  rot_get_pokemon_data(Not_who,A2,Target),
  rot_evaluate_end_of_turn(Who,Attacker,Target,List,New_attacker,New_target),
  % update data
  rot_set_pokemon_data(Who, New_attacker),
  rot_set_pokemon_data(Not_who, New_target).
