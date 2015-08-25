%! process_turn(+Game_state, +Action_player, +Action_rot, -Result_state).
%
% Processes a single turn of the game by executing the given actions choosen by
% the player and Rot, and thus altering the current state of the game.
%
% @arg Game_state The current state of the game
% @arg Action_player The action the player has choosen to be executed this turn
% @arg Action_rot The action Rot has choosen to be executed this turn
% @arg Result_state The resulting state of the game after executing both actions
process_turn(Game_state, Action_player, Action_rot, Result_state) :-
  calculate_priorities(Game_state, Action_player, Action_rot, Priority_data),
  process_by_priority(Game_state, Action_player, Action_rot, Priority_data, Result_state).

%! process_by_priority(+Game_state, +Action_player, +Action_rot, +Priority_frame, -Result_state).
%
% Processes a single turn of the game by executing the given actions choosen by
% the player and Rot depending on the priority of those actions. The action with
% the higher priority is obviously executed first.
% The priority frame is given by a call of calculate_priorities/4
%
% @arg Game_state The current state of the game
% @arg Action_player The action the player has choosen to be executed this turn
% @arg Action_rot The action Rot has choosen to be executed this turn
% @arg Priority_frame A frame containing the priorities of both players given by a call of calculate_priorities/4
% @arg Result_state The resulting state of the game after executing both actions
% @see calculate_priorities/4
process_by_priority(State, Action_player, Action_rot, priorities(Prio_player, Prio_rot), Result_state) :-
  faster(Prio_player, Prio_rot), % succeds if player is faster
  !, % red cut to suppress useage of 2nd clause where Rot would be faster
  process_actions(State, Action_player, Action_rot, player, New_state),
  process_ends_of_turn(New_state, player, End_of_turn_state),
  process_fainted_checks(End_of_turn_state, player, Result_state).
process_by_priority(State, Action_player, Action_rot, _, Result_state) :-
  % as faster/2 in 1st clause has failed, Rot's action has higher priority
  process_actions(State, Action_rot, Action_player, rot, New_state),
  process_ends_of_turn(New_state, rot, End_of_turn_state),
  process_fainted_checks(End_of_turn_state, rot, Result_state).

%! process_ends_of_turn(+Game_state, +Who_first, -Result_state).
%
% Calls process_end_of_turn/4 for both players in order of their priorities.
% Also prints out the corresponding message frames.
%
% @arg Game_state The current state of the game
% @arg Who_first Either `player` or `rot` to show who has higher priority this turn
% @arg Result_state The resulting state of the game after executing the end of this turn for both players
% @see process_end_of_turn/4
process_ends_of_turn(State, Who_first, Result_state) :-
  process_end_of_turn(State, Who_first, New_state, Message_collection_first), % end of turn for faster player
  create_message_frame(State, Who_first, end_of_turn, Message_collection_first, Message_frame_first), % create the message frame of the faster player
  ui_display_messages(Message_frame_first), % print message frame
  opponent(Who_first, Who_second), % get the slower player by name
  process_end_of_turn(New_state, Who_second, Result_state, Message_collection_second), % end of turn for slower player
  create_message_frame(New_state,Who_second, end_of_turn,Message_collection_second, Message_frame_second), % create the message frame of the slower player
  ui_display_messages(Message_frame_second). % print message frame

%! process_end_of_turn(+Game_state, +Who, -Result_state, -Message_collection).
%
% Processes the end of the current turn for the given player and calculates regular
% damage and healing from hold items and status conditions
%
% @arg Game_state The current state of the game
% @arg Who Either `player` or `rot`
% @arg Result_state The resulting state of the game after executing the end of this turn for the given player
% @arg Message_collection Collection of messages occured whilst processing
process_end_of_turn(State, Who, Result_state, Messages) :-
  translate_attacker_state(State, Who, State_attacker), % translate state
  process_end_of_turn_damage(State_attacker, New_state_attacker, Msg_dmg), % do damage to be dealt at the end of every turn
  add_messages(Msg_dmg, [], Messages), % create message collection
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate back

%! process_end_of_turn_damage(+Attacker_state, -Result_state, -Message_collection).
%
% Processes the damage occuring at the end of a turn, e.g. primary status conditons like burn
% or field conditions like sand storm.
%
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Result_state The resulting state of the game after executing the end turn damage for the given player
% @arg Message_collection Collection of messages occured whilst processing
process_end_of_turn_damage(State, New_state, Messages) :-
  process_end_of_turn_primary_status_damage(State, New_state, Messages).

%! process_end_of_turn_primary_status_damage(+Attacker_state, -Result_state, -Message_collection).
%
% Processes the damage occuring at the end of a turn caused by primary status conditons like burn.
%
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Result_state The resulting state of the game after executing the end turn damage for the given player
% @arg Message_collection Collection of messages occured whilst processing
process_end_of_turn_primary_status_damage(State, Result_state, Messages) :-
  % pokemon burns or is poisoned
  attacking_pokemon(State, Pokemon),
  primary_status_condition(Pokemon, Cond),
  member(Cond, [burn, poison]),
  % set up ailment message
  (
    % pokemon burns
    Cond = burn,
    add_messages([burns], [], Msg_ail)
    ;
    % pokemon is poisoned
    Cond = poison,
    add_messages([poisoned], [], Msg_ail)
  ),
  % do ailment damage
  swap_attacker_state(State, Swap_state), % swap state to inflict the damage
  process_damage_by_percent_max(Swap_state, 12.5, _, New_swap_state, Msg_dmg_opp), % 1/8 of total hp
  swap_attacker_state(New_swap_state, Result_state), % swap back
  messages_of_opposing_view(Msg_dmg_opp, Msg_dmg), % also swap messages
  add_messages(Msg_dmg, Msg_ail, Messages). % add damage message
process_end_of_turn_primary_status_damage(State, Result_state, Messages) :-
  % pokemon suffers bad-poison
  attacking_pokemon(State, Pokemon),
  primary_status_condition(Pokemon, poison(Turn)),
  % increase the turn counter
  New_turn is Turn+1,
  set_primary_status_condition(Pokemon, poison(New_turn), New_pokemon),
  set_attacking_pokemon(State, New_pokemon, New_state), % save to state
  % calculate damage based on old turn count
  swap_attacker_state(New_state, Swap_state), % swap state to inflict the damage
  Damage is Turn * 6.25, % damage raises each turn
  process_damage_by_percent_max(Swap_state, Damage, _, New_swap_state, Msg_dmg_opp),
  swap_attacker_state(New_swap_state, Result_state), % swap back
  messages_of_opposing_view(Msg_dmg_opp, Msg_dmg), % also swap messages
  % set up messages
  add_messages([poisoned],[],Msg_poi),
  add_messages(Msg_dmg, Msg_poi, Messages).
process_end_of_turn_primary_status_damage(State, State, []) :-
  % base case
  attacking_pokemon(State, Pokemon),
  primary_status_condition_category(Pokemon, Cond),
  \+ member(Cond,[burn,poison]).

%! process_fainted_checks(+Game_state, +Who_first, -Result_state).
%
% Checks for active but fainted pokemon and forces their corresponding player to switch them out.
%
% As due to entry hazards the newly switched in pokemon could instantly faint also,
% this check will be looped until both players either have an unfainted, active pokemon
% to use in the next turn, or one player has no pokemon left and loses.
%
% @arg Game_state The current state of the game
% @arg Who_first Either `player` or `rot` to show who has higher priority this turn
% @arg Result_state The resulting state of the game after executing the end of this turn for both players
% @see process_end_of_turn/4
process_fainted_checks(State, Who_first, Result_state) :-
  process_fainted_check(State, Who_first, New_state, Message_collection_first),
  create_message_frame(State, Who_first, fainted_check, Message_collection_first, Message_frame_first), % create the message frame of the faster player
  ui_display_messages(Message_frame_first), % print message frame
  opponent(Who_first, Who_second), % get the slower player by name
  process_fainted_check(New_state, Who_second, Newer_state, Message_collection_second), % end of turn for slower player
  create_message_frame(New_state,Who_second, fainted_check,Message_collection_second, Message_frame_second), % create the message frame of the slower player
  ui_display_messages(Message_frame_second), % print message frame
  process_fainted_checks_loop(Newer_state, Who_first, Result_state).

process_fainted_checks_loop(State, Who_first, Result_state) :-
  % repeat fainted check if the player's new active pokemon has already fainted again (due to entry hazards e.g.)
  attacker_fainted(State),
  \+ attacker_team_fainted(State),!, % check if any switch is actually needed
  process_fainted_checks(State, Who_first, Result_state).
process_fainted_checks_loop(State, Who_first, Result_state) :-
  % repeat fainted check if Rot's new active pokemon has already fainted again (due to entry hazards e.g.)
  target_fainted(State),
  \+ target_team_fainted(State),!, % check if any switch is actually needed
  process_fainted_checks(State, Who_first, Result_state).
process_fainted_checks_loop(State, _, State). % base case

%! process_fainted_check(+Game_state, +Who, -Result_state, -Message_collection).
%
% Forces the given player to switch out a fainted active pokemon.
%
% If the active pokemon has not fainted yet, nothing happens
%
% @arg Game_state The current state of the game
% @arg Who Either `player` or `rot`
% @arg Result_state The resulting state of the game after executing the check for the given player
% @arg Message_collection Collection of messages occured whilst processing
% @tbd Change implementation of fainting
process_fainted_check(State, Who, Result_state, Messages) :-
  % case: active pokemon has fainted
  translate_attacker_state(State,Who,Attacker_state),
  attacker_fainted(Attacker_state),
  !, % red cut to omit `not fainted(lead)` check in 2nd predicate
  process_fainted_routine(Attacker_state, Who, New_attacker_state, Messages),
  translate_attacker_state(New_attacker_state, Who, Result_state). % translate back
process_fainted_check(State, _, State, []). % Lead has not fainted, so the game state does not change

%! process_actions(+Game_state, +Action_first, +Action_second, +Who_first, -Result_state).
%
% Calls process_action/5 for both players in order of their priorities.
% Also prints out the corresponding message frames.
%
% @arg Game_state The current state of the game
% @arg Action_first The action to be executed first
% @arg Action_second The action to be executed second
% @arg Who_first Either `player` or `rot` to show who has higher priority this turn
% @arg Result_state The resulting state of the game after executing the end of this turn for both players
% @see process_action/5
process_actions(State, Action_first, Action_second, Who_first, Result_state) :-
  process_action(State, Action_first, Who_first, New_state, Message_collection_first),
  create_message_frame(State,Who_first,Action_first,Message_collection_first, Message_frame_first),
  ui_display_messages(Message_frame_first), % print messages of faster player
  opponent(Who_first, Who_second), % get the slower player by name
  process_action(New_state, Action_second, Who_second, Result_state, Message_collection_second),
  create_message_frame(New_state,Who_second,Action_second, Message_collection_second, Message_frame_second),
  ui_display_messages(Message_frame_second). % print message s of slower player

%! process_action(+Game_state, +Action, +Attacking_player, -Result_state, -Message_collection).
%
% Processes a given action depending on the given attacking player
%
% @arg Game_state The current state of the game
% @arg Action The action to be executed
% @arg Attacking_player The player who executes the given action; either `player` or `rot`.
% @arg Result_state The resulting state of the game after executing the given action
% @arg Message_collection Collection of messages occured whilst processing
process_action(State, switch(Team_member), Who, Result_state, Messages) :-
  % action chosen: a switch
  translate_attacker_state(State, Who, State_attacker), % translate state to attacker state
  process_switch(State_attacker, Team_member, New_state_attacker, Messages), % process the switch
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate result back
process_action(State, _, Who, State, Messages) :-
  % attacking pokemon has fainted before it could attack
  translate_attacker_state(State, Who, State_attacker), % translate to attacker state
  attacker_fainted(State_attacker). % active pokemon of attacker has fainted
process_action(State, _, Who, State, Messages) :-
  % target pokemon has fainted before it could be attacked
  translate_attacker_state(State, Who, State_attacker), % translate to attacker state
  target_fainted(State_attacker).
process_action(State, Move, Who, Result_state, Messages) :-
  % (base case) action chosen: a move
  move(Move, _,_,_,_,_,_,_,_),
  translate_attacker_state(State, Who, State_attacker), % translate to attacker state
  process_move_routine(State_attacker, Move, New_state_attacker, Messages),
  translate_attacker_state(New_state_attacker, Who, Result_state). % translate result back

%! process_move_routine(+Attacker_state, +Move, -Result_state, -Message_collection)
process_move_routine(State, _, State, Messages) :-
  % case: pokemon suffers paralysis
  attacking_pokemon(State,Pokemon),
  primary_status_condition(Pokemon, paralysis),
  rng_succeeds(75),  % 25 % the pokemon can not attack this turn
  add_messages([paralyzed],[],Messages).
process_move_routine(State, Move, Result_state, Messages) :-
  % case: pokemon suffers sleep
  State = state([Pokemon|Team],Target,Field),
  primary_status_condition(Pokemon, sleep(Remaining,Max)),
  New_remaining is Remaining-1,
  (
    % counter of remaining sleep turns reaches 0 -> pokemon wakes up
    New_remaining = 0,
    add_messages([woke_up], [], Msg_woke), % woke up message
    % clear sleep state of pokemon
    set_primary_status_condition(Pokemon, nil, New_pokemon),
    % process pokemons move
    process_move_routine(state([New_pokemon|Team],Target,Field), Move, Result_state, Msg_move), % base case executes move
    add_messages(Msg_move, Msg_woke, Messages)
    ;
    % pokemon does not wake up yet
    set_primary_status_condition(Pokemon, sleep(New_remaining, Max), New_pokemon),
    Result_state = state([New_pokemon|Team], Target, Field), % alter state
    add_messages([sleeps],[],Messages)
  ).
process_move_routine(State, Move, Result_state, Messages) :-
  % case: pokemon suffers freeze
  State = state([Pokemon|Team],Target,Field),
  primary_status_condition(Pokemon, freeze),
  pokemon_name(Pokemon, Name),
  (
    % frozen pokemon have a 20% chance per turn to defrost
    rng_succeeds(20), % pokemon defrosts
    add_messages([defrosted(Name)], [], Msg_defrost),
    % clear freeze state of pokemon
    set_primary_status_condition(Pokemon, nil, New_pokemon),
    % process move
    process_move_routine(state([New_pokemon|Team],Target,Field), Move, Result_state, Msg_move), % base case executes move
    add_messages(Msg_move, Msg_defrost, Messages)
    ;
    % pokemon does not wake up yet
    Result_state = State,
    add_messages([frozen],[],Messages)
  ).
process_move_routine(State, Move, Result_state, Messages) :-
  % base case
  move(Move, _,_,acc(Accuracy),_,_,_,_,_), % get accuracy
  add_messages([move(Move)],[],Msg_uses), % message that this move is used
  ( % test whether the move hits or not
    move_hits(Accuracy),
    process_move(State, Move, Result_state, Msg_move),
    add_messages(Msg_move, Msg_uses, Messages)
    ; % case the move does not hit
    add_messages([user(move_missed)], Msg_uses, Messages),
    State = Result_state % the state does not change
  ).

%! process_move(+Attacker_state, +Move, -Result_state, -Message_collection).
%
% Processes a given move depending on the given attacking player
%
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Move The move to be executed
% @arg Result_state The resulting state of the game after executing the given action
% @arg Message_collection Collection of messages occured whilst processing
process_move(State, Move, Result_state, Messages) :-
  % status move
  move(Move, _, status, _, _,_,Flags,_,Effects),
  process_move_effects(State,Flags,Effects,0,Result_state,Messages).
process_move(State, Move, Result_state, Messages) :-
  % base case: damaging move
  move(Move, _, Category, _, _,_,Flags,Possible_hits,Effects),
  Category =.. [_,_],
  State = state([Attacker|_],_,_),
  successful_hits(Attacker, Possible_hits, Hits),
  calculate_damage(State, Move, Damage, E_tag, C_tag),
  process_hits(State, Damage, Flags, Effects, Hits, Result_state, Msg_hits),
  % set up messages
  (
    % crit
    C_tag = critical(yes),
    add_messages([C_tag],[],Msg_c1)
    ;
    Msg_c1 = [] % no crit, empty collection
  ),
  add_messages(Msg_hits, Msg_c1, Msg_c2),
  (
    % effectiveness
    E_tag \= effectiveness(normal),
    add_messages([E_tag], Msg_c2, Messages)
    ;
    % normal effective
    Msg_c2 = Messages
  ).

%! process_switch(+Attacker_state, +Team_mate, +Result_state, -Message_collection).
%
% Switches the active pokemon for a given team mate.
% As a pokemon is switched out the following actions take place:
%   * status value stages are set back to 0
%   * more to come
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Team_mate A non active team pokemon to be switched with the active one
% @arg Result_state The resulting attacker state of the game after the switch
% @arg Message_collection Collection of messages occured whilst processing
% @tbd entry hazards
% @tbd mark pokemon whom just came into battle
process_switch(state([Attacker|Team_attacker], Team_target, Field), Team_mate, state(New_team_attacker, Team_target, Field), Messages) :-
  clear_stat_stages(Attacker, New_attacker), % clear status value stages
  calculate_switch([New_attacker|Team_attacker], Team_mate, New_team_attacker),
  add_messages([switch(Team_mate)], [], Messages). % only message

%! process_forced_switch(+Attacker_state, +Who, +Result_state, -Message_collection).
%
% Forces the given player to switch out his active pokemon whether it has fainted or by
% the effect of a status move.
%   * `player` is prompted to enter a team mate to switch in.
%   * `rot` chooses the team mate by his heuristic
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Who The player forced to switch his active pokemon out; either `player` or `rot`
% @arg Result_state The resulting attacker state of the game after the switch
% @arg Message_collection Collection of messages occured whilst processing
% @see process_switch/4
process_forced_switch(State_attacker, player, Result_state_attacker, Messages) :-
  % forced to switch: player
  \+ rot(searching), % predicate was not called by rot's heuristic, so the player gets prompted
  read_player_switch(State_attacker, Switch),
  Switch = switch(Team_member),
  process_switch(State_attacker, Team_member, Result_state_attacker, Messages).
process_forced_switch(State_attacker, player, Result_state_attacker, Messages) :-
  % forced to switch: player, called by rot's heuristic
  rot(searching), % predicate was called by rot's heuristic, so rot uses his heuristic for the player instead
  % as we will use rot's heuristic to choose the player's switch we need to
  % put rot's team in 2nd place in so read_rot_switch/2 thinks it is rot's team.
  swap_attacker_state(State_attacker, State), % swap player team to 2nd place in state
  read_rot_switch(State, switch(Switch)), % call heuristic
  process_switch(State_attacker, Switch, Result_state_attacker, Messages). % switch
process_forced_switch(State_attacker, rot, Result_state_attacker, Messages) :-
  % forced to switch: rot
  translate_attacker_state(State_attacker, rot, State), % swap attacker and target teams as `read_rot_switch` expects player to be the first team
  read_rot_switch(State, switch(Switch)), %read rot's switch choice
  process_switch(State_attacker, Switch, Result_state_attacker, Messages). % switch


%! process_hits(+Attacker_state, +Damage, +Flags, +Effects, +Quantity, -Result_state, -Message_collection).
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
% @arg Message_collection Collection of messages occured whilst processing
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
  add_messages(Messages1, Messages2, Messages). % add messages

%! process_single_hit(+Attacker_state, +Damage, +Flags, +Effects, -Result_state, -Message_collection).
%
% Processes the given damage to the target of the attacker state and call routines
% to handle possible effects caused by contact or the move itself
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Damage The damage to be done
% @arg Flags Flags set for the move, e.g. contact
% @arg Effects Additional effects caused by the move, e.g. status conditions
% @arg Result_state The resulting attacker state of the game after the hit
% @arg Message_collection Collection of messages occured whilst processing
process_single_hit(State, Damage, Flags, Effects, Result_state, Messages) :-
  \+ target_fainted(State), % there is a target to be damaged
  process_damage(State, Damage, Damage_done, Damaged_state, Msg_damage),
  process_contact(Damaged_state, Flags, Contact_state, Msg_contact),
  add_messages(Msg_contact, Msg_damage, Messages1), % add messages
  process_move_effects(Contact_state, Flags, Effects, Damage_done, Result_state, Msg_effects),
  add_messages(Msg_effects, Messages1, Messages). % add messages
process_single_hit(State, _, _, _, State, []) :- % no damage if targed has fainted
  target_fainted(State).

%! process_damage(+Attacker_state, +Damage, -Damage_done, -Result_state, -Message_collection).
%
% Processes the given damage to the target of the attacker state
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Damage The damage to be done
% @arg Damage_done The actual damage inflicted (may be lower than the initial damage to be done)
% @arg Result_state The resulting attacker state of the game after the damage was executed
% @arg Message_collection Collection of messages occured whilst processing
% @tbd Moves having no effect shall be treated differently in the future
process_damage(State, 0, 0, State, [effectiveness(none)]).
process_damage(State, Damage, Damage_done, Result_state, Messages) :-
  defending_pokemon(State, Target), % get target
  Target = [Name, kp(Curr, Max)|Rest_data], % get hp frame, name
  New_curr is max(0, min(Max, Curr - Damage)), % the minimum is required as healing is just negative damage
  Damage_done is Curr-New_curr, % the damage amount dealt
  add_messages([target(damaged(kp(New_curr, Max)))], [], Msg_damaged), % create message collection
  New_target = [Name, kp(New_curr, Max)|Rest_data], % alter target
  % check for fainting
  (
    % new hp are 0, pokemon has fainted
    New_curr is 0,
    add_messages([target(fainted)], Msg_damaged, Messages),
    process_fainting(New_target, Result_target)
    ;
    % pokemon has not fainted yet
    New_curr > 0,
    Messages = Msg_damaged, % keep messages
    New_target = Result_target
  ),
  % set damaged target
  set_defending_pokemon(State, Result_target, Result_state).

%! process_damage_by_percent_max(+Attacker_state, +Percent, -Damage_done, -Result_state, -Message_collection).
%
% Processes the given percentage as damage to the target, using target's maximum hit points as 100%
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Percent The percentage of damage to be done
% @arg Damage_done The actual damage inflicted (may be lower than the initial damage to be done)
% @arg Result_state The resulting attacker state of the game after the damage was executed
% @arg Message_collection Collection of messages occured whilst processing
process_damage_by_percent_max(State, 0, 0, State, []).
process_damage_by_percent_max(State, Percent, Damage_done, Result_state, Messages) :-
  P is Percent/100, % break to decimal representation
  defending_pokemon(State, Pokemon),
  hp_frame(Pokemon, kp(_,Max)),
  Damage is max(1,floor(Max*P)), % do at least 1 damage
  process_damage(State, Damage, Damage_done, Result_state, Messages).

%! process_damage_by_percent_current(+Attacker_state, +Percent, -Damage_done, -Result_state, -Message_collection).
%
% Processes the given percentage as damage to the target, using target's current hit points as 100%
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Percent The percentage of damage to be done
% @arg Damage_done The actual damage inflicted (may be lower than the initial damage to be done)
% @arg Result_state The resulting attacker state of the game after the damage was executed
% @arg Message_collection Collection of messages occured whilst processing
process_damage_by_percent_current(State, 0, 0, State, []).
process_damage_by_percent_current(State, Percent, Damage_done, Result_state, Messages) :-
  P is Percent/100, % break to decimal representation
  defending_pokemon(State, Pokemon),
  hp_frame(Pokemon, kp(Curr,_)),
  Damage is max(1,floor(Curr*P)), % do at least 1 damage
  process_damage(State, Damage, Damage_done, Result_state, Messages).

%! process_contact(+Attacker_state, +Flags, -Result_state, -Message_collection).
%
% Processes effects on contact
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Flags Flags set for the move; e.g. contact
% @arg Result_state The resulting attacker state of the game after the contact was executed
% @arg Message_collection Collection of messages occured whilst processing
% @tbd processing contact
process_contact(State, Flags, State, []) :-
  \+ member(contact,Flags). % nothing to do here as contact flag was not set
process_contact(State, Flags, State, []). % NYI

%! process_move_effects(+Attacker_state, +Flags, +Effects, +Damage_done, -Result_state, -Message_collection).
%
% Processes effects of a move.
% Calls process_single_move_effect/5 for every individual effect
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Flags The moves flags
% @arg Effects Additional effects caused by the move, e.g. status conditions
% @arg Damage_done The damage the move has done in its last hit
% @arg Result_state The resulting attacker state of the game after the effects were executed
% @arg Message_collection Collection of messages occured whilst processing
% @see process_single_move_effect/5
process_move_effects(State, _, [], _, State, []). % base case
process_move_effects(State, Flags, [E|Es], DD, Result_state, Messages) :-
  process_single_move_effect(State, E, DD, New_state, Msg_eff), % process a certain effect
  process_move_effects(New_state, Flags, Es, DD, Result_state, Msg_effs), % remaining effects
  add_messages(Msg_effs, Msg_eff, Messages). % no tail recursion

%! process_single_move_effect(+Attacker_state, +Effect, +Damage_done, -Result_state, -Message_collection).
%
% Processes a certain effect caused by a move.
% This predicate is called by process_move_effects/6.
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Effect The effect to be processed, e.g. a primary status ailment
% @arg Damage_done The damage the move has done in its last hit
% @arg Result_state The resulting attacker state of the game after the effects were executed
% @arg Message_collection Collection of messages occured whilst processing
% @see process_move_effects/6
process_single_move_effect(State, Ailment, _, Result_state, Messages) :-
  % status ailments
  Ailment =.. [ailment|Ailment_data], !,
  process_ailment_infliction(State, Ailment_data, Result_state, Messages).
process_single_move_effect(State, drain(Percent), DD, Result_state, Messages) :-
  % heals for a percentage of the damage done
  Reversed_heal is 0 - floor(DD * (Percent/100)), % heal is expressed as negative damage
  swap_attacker_state(State, Swapped_state), % swap attacker/target to use process_damage/5 properly
  process_damage(Swapped_state, Reversed_heal, _, New_swapped_state, Msg_heal_opp), % negative damage is healing
  swap_attacker_state(New_swapped_state, Result_state), % swap back
  messages_of_opposing_view(Msg_heal_opp, Msg_heal), % also swap messages
  % decide on drain message
  attacking_pokemon(Result_state, _, Name),
  (
    Reversed_heal =< 0, % Heal >= 0
    add_messages([drain],[],Msg_drain)
    ;
    % Heal < 0, so actually it did damage
    add_messages([recoil],[],Msg_drain) % recoil is negative drain
  ),
  add_messages(Msg_heal, Msg_drain, Messages).
process_single_move_effect(State, stats(Target, Prob, Increase_list), _, Result_state, Messages) :-
  % status stage increases
  rng_succeeds(Prob), % probability needs to succeed
  (
    % choose right target
    Target = target,
    process_stat_stage_increases(State, Increase_list, Result_state, Messages)
    ;
    % target is the user
    Target = user,
    swap_attacker_state(State, Swap_state), % target of the increases is the target in the attacker state
    process_stat_stage_increases(Swap_state, Increase_list, Result_swap_state, Messages_opp),
    messages_of_opposing_view(Messages_opp, Messages), % swap messages
    swap_attacker_state(Result_swap_state, Result_state) % swap state back
  )
  ;
  % rng did not succeed, thus no stat stages get increased
  Messages = [],
  Result_state = State.
process_single_move_effect(State, E, _, State, Messages) :-
  % NFI
  add_messages([system(type(unsupported), category(effect), data(E))], [], Messages).

%! process_ailment_infliction(+Attacker_state, +Ailment_data, -Result_state, -Message_collection).
%
% Tries to inflict a given ailment to the target pokemon.
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Ailment_data Data about the ailment containing the ailment itself, a probability for it an maybe a limit in turns
% @arg Result_state The resulting attacker state of the game after the ailment was executed
% @arg Message_collection Collection of messages occured whilst processing
process_ailment_infliction(State, [Ailment, Prob], Result, Messages) :-
  member(Ailment, [burn, freeze, paralysis, poison, bad-poison]), % the only ailments without a turn limit
  inflict_primary_status_condition(State, Ailment, Prob, Result, Messages).
process_ailment_infliction(State, [sleep, Prob, Turn_limit], Result, Messages) :-
  % sleep is the only primary status condition having a limit in turns
  rng_range(Turn_limit, R), % sleep gets a counter to be counted down. On reaching 0 the pokemon wakes up again
  inflict_primary_status_condition(State, sleep(R,R), Prob, Result, Messages).
process_ailment_infliction(State, Data, State, Messages) :-
  % NFI
  add_messages([system(type(unsupported),category(ailment),data(Data))], [], Messages).

%! process_stat_stage_increases(+Attacer_state, +List_of_increases, -Result_state, -Message_collection).
%
% Processes a list of status value stage increases on the target pokemon.
% The status value stage increases have to be tupels of the form (Stat_name, Increase)
% where Stat_name unifies with one of the following:
%   * attack
%   * defense
%   * special-attack
%   * special-defense
%   * speed
% Increase is any integer, though it is sufficient if the values are within range
% from -12 to +12, as those are the lowest and highest values a status value stage increase could go.
% E.g. as status value stages themselves range from -6 to 6 an attack stage of -6
% can at max raise by +12 as (-6)+12 = 6 and the attack stage (as other stages) can not exceed +6.
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg List_of_increases List of tupels of the form (Stat_name, Increase)
% @arg Result_state The resulting attacker state of the game
% @arg Message_collection Collection of messages occured whilst processing
process_stat_stage_increases(State,[],State,[]).
process_stat_stage_increases(State, [(Stat,Inc)|Incs], Result_state, Messages) :-
  process_single_stat_stage_increase(State, Stat, Inc, New_state, Msg_stage),
  process_stat_stage_increases(New_state, Incs, Result_state, Msg_stages),
  add_messages(Msg_stages, Msg_stage, Messages). % no tail recursion

%! process_single_stat_stage_increase(+Attacer_state, +Stat_name, +Increase_value, -Result_state, -Message_collection).
%
% Processes a single status value stage increase on the target pokemon.
% The status value stage increases have to be tupels of the form (Stat_name, Increase)
% where Stat_name unifies with one of the following:
%   * attack
%   * defense
%   * special-attack
%   * special-defense
%   * speed
% Increase is any integer, though it is sufficient if the values are within range
% from -12 to +12, as those are the lowest and highest values a status value stage increase could go.
% E.g. as status value stages themselves range from -6 to 6 an attack stage of -6
% can at max raise by +12 as (-6)+12 = 6 and the attack stage (as other stages) can not exceed +6.
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Stat_name Name of the status value stage to increase
% @arg Increase_value Value the status stage shall be increased by
% @arg Result_state The resulting attacker state of the game
% @arg Message_collection Collection of messages occured whilst processing
process_single_stat_stage_increase(State, Stat, Increase, Result_state, Messages) :-
  defending_pokemon(State, Pokemon), % get pokemon
  stat_stage(Pokemon, Stat, Old_stage), % old stat stage for message creation
  increase_stat_stage(Pokemon, Stat, Increase, New_pokemon), % increase
  set_defending_pokemon(State, New_pokemon, Result_state),
  stat_stage_increase_message(Stat, Old_stage, Increase, Messages).

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

%! process_fainted_routine(+Attacker_state, +Who, -Result_state, -Message_collection).
%
% Forces the given player to switch his fainted active pokemon if there are unfainted
% team mates left. Does nothing otherwise as the given player has lost the game
%
% @arg Attacker_state The current state of the game from attacker point of view
% @arg Who The player whos view the attacker state is based on
% @arg Result_state The resulting attacker state of the game after processing
% @arg Message_collection Collection of messages occured whilst processing
process_fainted_routine(State, _, State, []) :-
  State = state(Attacker, _, _),
  team_completely_fainted(Attacker).
process_fainted_routine(State_attacker, Who, Result_state_attacker, Messages) :-
  State_attacker = state(Attacker, _, _),
  \+ team_completely_fainted(Attacker),
  process_forced_switch(State_attacker, Who, Result_state_attacker, Messages).
