process_round(Game_state, Move_player, Move_rot, Result_state) :-
  calculate_priorities(Game_state, Move_player, Move_rot, Priority_data),
  process_by_priority(Game_state, Move_player, Move_rot, Priority_data, Result_state).


process_by_priority(State, Move_player, Move_rot, priorities(Prio_player, Prio_rot), Result_state) :-
  faster(Prio_player, Prio_rot),
  process_moves(State, Move_player, Move_rot, player, New_state),
  process_ends_of_round(New_state, player, Result_state).
process_by_priority(State, Move_player, Move_rot, _, Result_state) :-
  process_moves(State, Move_rot, Move_player, rot, New_state),
  process_ends_of_round(New_state, rot, Result_state).


process_ends_of_round(State, Who_first, Result_state) :-
  process_end_of_round(State, Who_first, New_state, Messages_first),
  ui_display_messages(Messages_first),
  opponent(Who_first, Who_second),
  process_end_of_round(New_state, Who_second, Result_state, Messages_second),
  ui_display_messages(Messages_second).

process_end_of_round(State, Who, Result_state, msg(Who, Messages)) :-
  translate_attacker_state(State, Who, State_attacker),
  process_fainted_check(State_attacker, Who, New_state_attacker, Messages),
  translate_attacker_state(New_state_attacker, Who, Result_state).

process_fainted_check(state([Lead|Team], Target, Field), Who, Result_state, Messages) :-
  fainted(Lead),
  process_fainted_routine(state([Lead|Team], Target, Field), Who, Result_state, Messages).
process_fainted_check(State, _, State, []). % NFI


process_moves(State, Move_first, Move_second, Who_first, Result_state) :-
  process_move(State, Move_first, Who_first, New_state, Messages_first),
  ui_display_messages(Messages_first),
  opponent(Who_first, Who_second),
  process_move(New_state, Move_second, Who_second, Result_state, Messages_second),
  ui_display_messages(Messages_second).

process_move(State, switch(Team_member), Who, Result_state, msg(Who, Messages)) :-
  translate_attacker_state(State, Who, State_attacker),
  process_switch(State_attacker, Team_member, New_state_attacker, Messages),
  translate_attacker_state(New_state_attacker, Who, Result_state).
process_move(State, _, Who, Result_state, msg(Who, Messages)) :-
  translate_attacker_state(State, Who, State_attacker),
  attacker_fainted(State_attacker),
  process_fainted_routine(State_attacker, Who, Result_state_attacker, Messages),
  translate_attacker_state(Result_state_attacker, Who, Result_state).
process_move(State, Move, Who, Result_state, msg(Who, Message)) :-
  move(Move, _, status, acc(Accuracy), _,_,_,_,_),
  move_hits(Accuracy),
  move_use_message(State, Who, Move, Message),
  Result_state = State. % NYI: status moves
process_move(State, Move, Who, Result_state, msg(Who, Messages)) :-
  move(Move, _, Category, acc(Accuracy), _,_,Contact,Possible_hits,Additional),
  Category =.. [_,_],
  move_hits(Accuracy),
  translate_attacker_state(State, Who, State_attacker), % translate state so that attacker team comes first
  State_attacker = state(Attacker, _, _),
  move_use_message(State, Who, Move, Msg_uses),
  successful_hits(Attacker, Possible_hits, Hits),
  calculate_damage(State_attacker, Move, Damage),
  process_hits(State_attacker, Damage, Contact, Additional, Hits, New_state_attacker, Msg_hits),
  fainted_messages(New_state_attacker, Msg_fainted),
  append(Msg_hits, Msg_uses, Messages1),
  append(Msg_fainted, Messages1, Messages),
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate back
process_move(State, Move, Who, State, msg(Who, Messages)) :-
  move_use_message(State, Who, Move, Msg_uses),
  Messages = [move_missed | Msg_uses].

process_switch(state(Team_attacker, Team_target, Field), Team_member,
  state(New_team_attacker, Team_target, Field), Messages) :-
  Team_attacker = [[Out|_]|_],
  calculate_switch(Team_attacker, Team_member, New_team_attacker),
  Messages = [switch(from(Out), to(Team_member))].

process_forced_switch(State_attacker, player, Result_state_attacker, Messages) :-
  \+ rot(searching),
  ui_display_switch_prompt,
  read_player_switch(State_attacker, Switch),
  Switch = switch(Team_member),
  process_switch(State_attacker, Team_member, Result_state_attacker, Messages).
process_forced_switch(State_attacker, player, Result_state_attacker, Messages) :-
  rot(searching),
  read_rot_switch(State_attacker, switch(Switch)),
  process_switch(State_attacker, Switch, Result_state_attacker, Messages).
process_forced_switch(State_attacker, rot, Result_state_attacker, Messages) :-
  translate_attacker_state(State_attacker, rot, State),
  read_rot_switch(State, switch(Switch)),
  process_switch(State_attacker, Switch, Result_state_attacker, Messages).

process_hits(State, Damage, Contact, Effects, 1, Result_state, Messages) :-
  process_single_hit(State, Damage, Contact, Effects, Result_state, Messages).
process_hits(State, Damage, Contact, Effects, Hits, Result_state, Messages) :-
  process_single_hit(State, Damage, Contact, Effects, New_state, Messages1),
  Remaining_hits is Hits - 1,
  process_hits(New_state, Damage, Contact, Effects, Remaining_hits, Result_state, Messages2),
  append(Messages2, Messages1, Messages).

process_single_hit(State, Damage, Contact, Effects, Result_state, Messages) :-
  \+ target_fainted(State),
  process_damage(State, Damage, Damaged_state, Msg_damage),
  process_contact(Damaged_state, Contact, Contact_state, Msg_contact),
  append(Msg_contact, Msg_damage, Messages1),
  process_additional_effects(Contact_state, Effects, Result_state, Msg_effects),
  append(Msg_effects, Messages1, Messages).
process_single_hit(State, _, _, _, State, []) :-
  target_fainted(State).

process_damage(State, 0, State, [no_effect]).
process_damage(state(Team_attacker, [Target|Team_target], Field), Damage,
  state(Team_attacker, [Result_target|Team_target], Field), [damaged(target(Name), kp(New_curr, Max))]) :-
  Target = [Name, kp(Curr, Max)|Rest_data],
  New_curr is max(0, min(Max, Curr - Damage)), % the minimum is required as healing is just negative damage
  New_target = [Name, kp(New_curr, Max)|Rest_data],
  process_fainting(New_target, Result_target).

process_contact(State, nocontact, State, []). % nothing to do here
process_contact(State, contact, State, []). % NYI

process_additional_effects(State, _, State, []). % NYI

process_fainting([Name, kp(0,Max), Moves, Status_data, Item, [_|Status_rest]],
  [Name, kp(0,Max), Moves, Status_data, Item, [fainted|Status_rest]]).
process_fainting([Name, kp(Curr, Max)|Rest], [Name, kp(Curr, Max)|Rest]) :-
  Curr > 0.

process_fainted_routine(State, _, State, []) :-
  State = state(Attacker, _, _),
  team_completely_fainted(Attacker).
process_fainted_routine(State_attacker, Who, Result_state_attacker, Messages) :-
  State_attacker = state(Attacker, _, _),
  \+ team_completely_fainted(Attacker),
  process_forced_switch(State_attacker, Who, Result_state_attacker, Messages).
