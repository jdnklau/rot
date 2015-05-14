process_round(Game_state, Move_player, Move_rot, New_state) :-
  calculate_priorities(Game_state, Move_player, Move_rot, Priority_data),
  process_by_priority(Game_state, Move_player, Move_rot, Priority_data, New_state).


process_by_priority(State, Move_player, Move_rot, priorities(Prio_player, Prio_rot), Result_state) :-
  faster(Prio_player, Prio_rot),
  process_moves(State, Move_player, Move_rot, player, Result_state).
process_by_priority(State, Move_player, Move_rot, _, Result_state) :-
  process_moves(State, Move_rot, Move_player, rot, Result_state).


process_moves(State, Move_first, Move_second, Who_first, Result_state) :-
  process_move(State, Move_first, Who_first, New_state),
  opponent(Who_first, Who_second),
  process_move(New_state, Move_second, Who_second, Result_state).

process_move(State, Move, Who, Result_state) :-
  move(Move, _, status, acc(Accuracy), _,_,_,_,_),
  move_hits(Accuracy),
  Result_state = State. % NYI: status attacks
process_move(State, Move, Who, Result_state) :-
  move(Move, _, Category, acc(Accuracy), _,_,Contact,Possible_hits,Additional),
  Category =.. [_,_],
  move_hits(Accuracy),
  translate_attacker_state(State, Who, State_attacker), % translate state so that attacker team comes first
  State_attacker = state(Attacker, _, _),
  successful_hits(Attacker, Possible_hits, Hits),
  calculate_damage(State_attacker, Move, Damage),
  process_hits(State_attacker, Damage, Contact, Additional, Hits, New_state_attacker),
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate back

process_hits(State, Damage, Contact, Effects, 1, Result_state) :-
  process_single_hit(State, Damage, Contact, Effects, Result_state).
process_hits(State, Damage, Contact, Effects, Hits, Result_state) :-
  process_single_hit(State, Damage, Contact, Effects, New_state),
  Remaining_hits is Hits - 1,
  process_hits(New_state, Damage, Contact, Effects, Remaining_hits, Result_state).

process_single_hit(State, Damage, Contact, Effects, Result_state) :-
  process_damage(State, Damage, Damaged_state),
  process_contact(Damaged_state, Contact, Contact_state),
  process_additional_effects(Contact_state, Effects, Result_state).

process_damage(state(Team_attacker, [Target|Team_target], Field), Damage,
  state(Team_attacker, [New_target|Team_target], Field)) :-
  write('damage done: '), write(Damage), nl,
  Target = [Name, kp(Curr, Max)|Rest_data],
  New_curr is max(0, min(Max, Curr - Damage)), % the minimum is required as healing is just negative damage
  New_target = [Name, kp(New_curr, Max)|Rest_data].

process_contact(State, nocontact, State). % nothing to do here
process_contact(State, contact, State). % NYI

process_additional_effects(State, _, State). % NYI

translate_attacker_state(state(A, T, Field), player, state(A, T, Field)).
translate_attacker_state(state(T, A, [Field_t, Field_a, Field_g]), rot, state(A, T, [Field_a, Field_t, Field_g])).

opponent(player, rot).
opponent(rot, player).
