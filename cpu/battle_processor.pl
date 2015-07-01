%! process_round(+Game_state, +Move_player, +Move_rot, -Result_state).
%
% Processes a single round of the game by executing the given moves choosen by
% the player and Rot, and thus altering the current state of the game.
%
% @arg Game_state The current state of the game
% @arg Move_player The move the player has choosen to be executed this round
% @arg Move_rot The move Rot has choosen to be executed this round
% @arg Result_state The resulting state of the game after executing both moves
process_round(Game_state, Move_player, Move_rot, Result_state) :-
  calculate_priorities(Game_state, Move_player, Move_rot, Priority_data),
  process_by_priority(Game_state, Move_player, Move_rot, Priority_data, Result_state).

%! process_by_priority(+Game_state, +Move_player, +Move_rot, +Priority_frame, -Result_state).
%
% Processes a single round of the game by executing the given moves choosen by
% the player and Rot depending on the priority of those moves. The move with
% the higher priority is obviously executed first.
% The priority frame is given by a call of calculate_priorities/4
%
% @arg Game_state The current state of the game
% @arg Move_player The move the player has choosen to be executed this round
% @arg Move_rot The move Rot has choosen to be executed this round
% @arg Priority_frame A frame containing the priorities of both players given by a call of calculate_priorities/4
% @arg Result_state The resulting state of the game after executing both moves
% @see calculate_priorities/4
process_by_priority(State, Move_player, Move_rot, priorities(Prio_player, Prio_rot), Result_state) :-
  faster(Prio_player, Prio_rot), % succeds if player is faster
  !, % red cut to suppress useage of 2nd clause where Rot would be faster
  process_moves(State, Move_player, Move_rot, player, New_state),
  process_ends_of_round(New_state, player, Result_state).
process_by_priority(State, Move_player, Move_rot, _, Result_state) :-
  % as faster/2 in 1st clause has failed, Rot's move has higher priority
  process_moves(State, Move_rot, Move_player, rot, New_state),
  process_ends_of_round(New_state, rot, Result_state).

%! process_ends_of_round(+Game_state, +Who_first, -Result_state).
%
% Calls process_end_of_round/4 for both players in order of their priorities.
% Also prints out the corresponding message frames.
%
% @arg Game_state The current state of the game
% @arg Who_first Either `player` or `rot` to show who has higher priority this round
% @arg Result_state The resulting state of the game after executing the end of this round for both players
% @see process_end_of_round/4
process_ends_of_round(State, Who_first, Result_state) :-
  process_end_of_round(State, Who_first, New_state, Message_stack_first), % end of round for faster player
  message_frame(Who_first, Message_stack_first, Message_frame_first), % create the message frame of the faster player
  ui_display_messages(Message_frame_first), % print message frame
  opponent(Who_first, Who_second), % get the slower player by name
  process_end_of_round(New_state, Who_second, Result_state, Message_stack_second), % end of round for slower player
  message_frame(Who_second, Message_stack_second, Message_frame_second), % create the message frame of the slower player
  ui_display_messages(Message_frame_second). % print message frame

%! process_end_of_round(+Game_state, +Who, -Result_state, -Message_stack).
%
% Processes the end of the current round for the given player and calculates regular
% damage and healing from hold items and status conditions
%
% @arg Game_state The current state of the game
% @arg Who Either `player` or `rot`
% @arg Result_state The resulting state of the game after executing the end of this round for the given player
% @arg Message_stack Stack of messages occured whilst processing
% @tbd Everything
process_end_of_round(State, Who, Result_state, Messages) :-
  translate_attacker_state(State, Who, State_attacker),
  process_fainted_check(State_attacker, Who, New_state_attacker, Messages),
  translate_attacker_state(New_state_attacker, Who, Result_state).

%! process_fainted_check(+Game_state, +Who, -Result_state, -Message_stack).
%
% TODO
%
% @arg Game_state The current state of the game
% @arg Who Either `player` or `rot`
% @arg Result_state The resulting state of the game after executing the check for the given player
% @arg Message_stack Stack of messages occured whilst processing
% @tbd Change implementation of fainting
process_fainted_check(state([Lead|Team], Target, Field), Who, Result_state, Messages) :-
  fainted(Lead), % lead has fainted
  !, % red cut to omit `not fainted(lead)` check in 2nd predicate
  process_fainted_routine(state([Lead|Team], Target, Field), Who, Result_state, Messages).
process_fainted_check(State, _, State, []). % Lead has not fainted, so the game state does not change

%! process_moves(+Game_state, +Move_first, +Move_second, +Who_first, -Result_state).
%
% Calls process_move/5 for both players in order of their priorities.
% Also prints out the corresponding message frames.
%
% @arg Game_state The current state of the game
% @arg Move_first The move to be executed first
% @arg Move_second The move to be executed second
% @arg Who_first Either `player` or `rot` to show who has higher priority this round
% @arg Result_state The resulting state of the game after executing the end of this round for both players
% @see process_move/5
process_moves(State, Move_first, Move_second, Who_first, Result_state) :-
  process_move(State, Move_first, Who_first, New_state, Message_stack_first),
  message_frame(Who_first, Message_stack_first, Message_frame_first),
  ui_display_messages(Message_frame_first), % print message stack of faster player
  opponent(Who_first, Who_second), % get the slower player by name
  process_move(New_state, Move_second, Who_second, Result_state, Message_stack_second),
  message_frame(Who_second, Message_stack_second, Message_frame_second),
  ui_display_messages(Message_frame_second). % print message stack of slower player

%! process_move(+Game_state, +Move, +Attacking_player, -Result_state, -Message_stack).
%
% Processes a given move depending of the given attacking player
%
% @arg Game_state The current state of the game
% @arg Move The move to be executed
% @arg Attacking_player The player who executes the given move; either `player` or `rot`.
% @arg Result_state The resulting state of the game after executing the given move
% @arg Message_stack Stack of messages occured whilst processing
% @tbd alter the handling of status and damagng moves so they can handled together
% @tbd add check if a move has any effect in the first place
process_move(State, switch(Team_member), Who, Result_state, Messages) :-
  % move chosen: a switch
  translate_attacker_state(State, Who, State_attacker), % translate state to attacker state
  process_switch(State_attacker, Team_member, New_state_attacker, Messages), % process the switch
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate result back
process_move(State, _, Who, Result_state, Messages) :-
  % attacking pokemon has fainted before it could attack
  translate_attacker_state(State, Who, State_attacker), % translate to attacker state
  attacker_fainted(State_attacker), % active pokemon of attacker has fainted
  process_fainted_routine(State_attacker, Who, Result_state_attacker, Messages),
  translate_attacker_state(Result_state_attacker, Who, Result_state). % translate result back
process_move(State, Move, Who, Result_state, Messages) :-
  % move chosen: status move
  % NYI
  move(Move, _, status, acc(Accuracy), _,_,_,_,_),
  move_hits(Accuracy),
  move_use_message(State, Who, Move, Messages),
  Result_state = State. % NYI: status moves
process_move(State, Move, Who, Result_state, Messages) :-
  % move chosen: damaging move
  move(Move, _, Category, acc(Accuracy), _,_,Flags,Possible_hits,Additional),
  Category =.. [_,_],
  move_hits(Accuracy),
  translate_attacker_state(State, Who, State_attacker), % translate to attacker state
  State_attacker = state(Attacker, _, _),
  move_use_message(State, Who, Move, Msg_uses),
  successful_hits(Attacker, Possible_hits, Hits),
  calculate_damage(State_attacker, Move, Damage),
  process_hits(State_attacker, Damage, Flags, Additional, Hits, New_state_attacker, Msg_hits),
  push_message_stack(Msg_uses, Msg_hits, Messages),
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate result back
process_move(State, Move, Who, State, Messages) :-
  % move has missed
  move_use_message(State, Who, Move, Msg_uses),
  Messages = [user(move_missed) | Msg_uses].

%! process_switch(+Attacker_state, +Team_mate, +Result_state, -Message_stack).
%
% Switches the active pokemon for a given team mate.
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Team_mate A non active team pokemon to be switched with the active one
% @arg Result_state The resulting attacker state of the game after the switch
% @arg Message_stack Stack of messages occured whilst processing
% @tbd entry hazards
% @tbd mark pokemon whom just came into battle
process_switch(state(Team_attacker, Team_target, Field), Team_mate, state(New_team_attacker, Team_target, Field), Messages) :-
  calculate_switch(Team_attacker, Team_mate, New_team_attacker),
  Team_attacker = [[Out|_]|_], % extract name of active pokemon
  Messages = [user(switch(from(Out), to(Team_mate)))]. % only message on the message stack

%! process_forced_switch(+Attacker_state, +Who, +Result_state, -Message_stack).
%
% Forces the given player to switch out his active pokemon whether it has fainted or by
% the effect of a status move.
%   * `player` is prompted to enter a team mate to switch in.
%   * `rot` chooses the team mate by his heuristic
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Who The player forced to switch his active pokemon out; either `player` or `rot`
% @arg Result_state The resulting attacker state of the game after the switch
% @arg Message_stack Stack of messages occured whilst processing
% @see process_switch/4
process_forced_switch(State_attacker, player, Result_state_attacker, Messages) :-
  % forced to switch: player
  \+ rot(searching), % predicate was not called by rot's heuristic, so the player gets prompted
  State_attacker = state([_|Player_team],_,_),
  read_player_switch(State_attacker, Switch),
  Switch = switch(Team_member),
  process_switch(State_attacker, Team_member, Result_state_attacker, Messages).
process_forced_switch(State_attacker, player, Result_state_attacker, Messages) :-
  % forced to switch: player
  rot(searching), % predicate was called by rot's heuristic, so rot uses his heuristic for the player instead
  read_rot_switch(State_attacker, switch(Switch)), % call heuristic
  process_switch(State_attacker, Switch, Result_state_attacker, Messages). % switch
process_forced_switch(State_attacker, rot, Result_state_attacker, Messages) :-
  % forced to switch: rot
  translate_attacker_state(State_attacker, rot, State), % swap attacker and target teams as `read_rot_switch` expects player to be the first team
  read_rot_switch(State, switch(Switch)), %read rot's switch choice
  process_switch(State_attacker, Switch, Result_state_attacker, Messages). % switch


%! process_hits(+Attacker_state, +Damage, +Flags, +Effects, +Quantity, -Result_state, -Message_stack).
%
% Processes the given damage to the target of the attacker state in given quantity.
% For each consecutive hit process_single_hit/6 is called.
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Damage The damage to be done by each consecutive hit
% @arg Flags Flags set for the move
% @arg Effects Additional effects caused by the move, e.g. status conditions
% @arg Quantity Number of hits to be done
% @arg Result_state The resulting attacker state of the game after the hits
% @arg Message_stack Stack of messages occured whilst processing
% @see process_single_hit/6
% @tbd Stop if one side has fainted
process_hits(State, Damage, Flags, Effects, 1, Result_state, Messages) :-
  % one hit left
  process_single_hit(State, Damage, Flags, Effects, Result_state, Messages).
process_hits(State, Damage, Flags, Effects, Hits, Result_state, Messages) :-
  % more than one hit left
  process_single_hit(State, Damage, Flags, Effects, New_state, Messages1), % process a hit
  Remaining_hits is Hits - 1,
  process_hits(New_state, Damage, Flags, Effects, Remaining_hits, Result_state, Messages2), % process remaining hits
  push_message_stack(Messages2, Messages1, Messages). % push messages onto the stack

%! process_single_hit(+Attacker_state, +Damage, +Flags, +Effects, -Result_state, -Message_stack).
%
% Processes the given damage to the target of the attacker state and call routines
% to handle possible effects caused by contact or the move itself
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Damage The damage to be done
% @arg Flags Flags set for the move, e.g. contact
% @arg Effects Additional effects caused by the move, e.g. status conditions
% @arg Result_state The resulting attacker state of the game after the hit
% @arg Message_stack Stack of messages occured whilst processing
process_single_hit(State, Damage, Flags, Effects, Result_state, Messages) :-
  \+ target_fainted(State), % there is a target to be damaged
  process_damage(State, Damage, Damaged_state, Msg_damage),
  process_contact(Damaged_state, Flags, Contact_state, Msg_contact),
  push_message_stack(Msg_contact, Msg_damage, Messages1), % push messages
  process_additional_effects(Contact_state, Effects, Result_state, Msg_effects),
  push_message_stack(Msg_effects, Messages1, Messages). % push messages
process_single_hit(State, _, _, _, State, []) :- % no damage if targed has fainted
  target_fainted(State).

%! process_damage(+Attacker_state, +Damage, -Result_state, -Message_stack).
%
% Processes the given damage to the target of the attacker state
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Damage The damage to be done
% @arg Result_state The resulting attacker state of the game after the damage was executed
% @arg Message_stack Stack of messages occured whilst processing
% @tbd Moves having no effect shall be treated differently in the future
process_damage(State, 0, State, [user(no_effect)]).
process_damage(state(Team_attacker, [Target|Team_target], Field), Damage, state(Team_attacker, [Result_target|Team_target], Field), Messages) :-
  Target = [Name, kp(Curr, Max)|Rest_data], % get target name, current and maximal hp
  New_curr is max(0, min(Max, Curr - Damage)), % the minimum is required as healing is just negative damage
  Msg1 = [target(damaged(pokemon(Name), kp(New_curr, Max)))], % create message stack
  New_target = [Name, kp(New_curr, Max)|Rest_data], % alter target
  (New_curr is 0 -> Msg2 = [target(fainted(Name))] ; Msg2 = []), % create push stack
  push_message_stack(Msg2, Msg1, Messages), % push push stack to the message stack
  process_fainting(New_target, Result_target).

%! process_contact(+Attacker_state, +Flags, -Result_state, -Message_stack).
%
% Processes effects on contact
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Flags Flags set for the move; e.g. contact
% @arg Result_state The resulting attacker state of the game after the contact was executed
% @arg Message_stack Stack of messages occured whilst processing
% @tbd processing contact
process_contact(State, Flags, State, []) :-
  \+ member(contact,Flags). % nothing to do here as contact flag was not set
process_contact(State, Flags, State, []). % NYI

%! process_additional_effects(+Attacker_state, +Effects, -Result_state, -Message_stack).
%
% Processes effects of a move
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Effects Additional effects caused by the move, e.g. status conditions
% @arg Result_state The resulting attacker state of the game after the effects were executed
% @arg Message_stack Stack of messages occured whilst processing
% @tbd processing effects
process_additional_effects(State, _, State, []). % NYI

%! process_fainting(+Pokemon, -Pokemon_fainted).
%
% Sets the primary status condition of a given pokemon with 0 hp remaining to `fainted`.
% Does nothing if there are more than 0 hp remaining
%
% @arg Pokemon The Pokemon to faint eventually
% @arg Result The given pokemon with proper fainted contidion
process_fainting([Name, kp(0,Max), Moves, Status_data, Item, [_|Status_rest]],
  [Name, kp(0,Max), Moves, Status_data, Item, [fainted|Status_rest]]).
process_fainting([Name, kp(Curr, Max)|Rest], [Name, kp(Curr, Max)|Rest]) :-
  Curr > 0.

%! process_fainted_routine(+Attacker_state, +Who, -Result_state, -Message_stack).
%
% Forces the given player to switch his fainted active pokemon if there are unfainted
% team mates left. Does nothing otherwise as the given player has lost the game
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Who The player whos view the attacker state is based on
% @arg Result_state The resulting attacker state of the game after processing
% @arg Message_stack Stack of messages occured whilst processing
process_fainted_routine(State, _, State, []) :-
  State = state(Attacker, _, _),
  team_completely_fainted(Attacker).
process_fainted_routine(State_attacker, Who, Result_state_attacker, Messages) :-
  State_attacker = state(Attacker, _, _),
  \+ team_completely_fainted(Attacker),
  process_forced_switch(State_attacker, Who, Result_state_attacker, Messages).
