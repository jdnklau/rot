%! ui_display_messages(+Message_frame).
% Displays the messages of the given message frame.
% @arg Message_frame The message frame to be displayed.
ui_display_messages(_) :-
  % suppress message output while rot creates his search tree
  rot(searching).
ui_display_messages(Frame) :-
  % no messages to display
  empty_message_frame(Frame),!.
ui_display_messages(Frame) :-
  \+ rot(searching),
  message_frame_meta_data(Frame, Who, Action, Pokemon_who, Pokemon_opp), % get the frame's meta data
  get_message_frame_list(Frame, Messages), % get the frames messages
  ui_display_message_list(Who,Action,Pokemon_who,Pokemon_opp, Messages), nl.

%! ui_display_message_list(+Player, +Action, +Active_pokemon_player, Active_pokemon_opponent, +Message_list).
% Displays the messages of the given message list.
% @arg Player Either `player` or `rot`; indicating to whom the messages correspond to
% @arg Action The action causing the messages frame's messages
% @arg Active_pokemon_player The active pokemon's name of the given player
% @arg Active_pokemon_opponent The active pokemon's name of the given player's opponent
% @arg Message_list The message list to be displayed.
ui_display_message_list(_,_,_,_, []). % no messages
ui_display_message_list(Who,Ac,A1,A2, [Message|Messages]) :-
  % printing the stack in reverse (bottom element shall be printed first)
  ui_display_single_targeted_message(Who,Ac,A1,A2, Message), % print message
  nl,
  ui_display_message_list(Who,Ac,A1,A2, Messages). % print remaining messages

%! ui_display_single_targeted_message(+Player, +Action, +Active_pokemon_player, +Active_pokemon_opponent, +Message).
% Displays the given message dependent on eventually targeting frames attached to it.
% If Message unifies with user(Msg) or has no targeting frame attached to it, the message is displayed normaly.
% If Message unifies with target(Msg) it will be displayed from the opposing player's point of view
% The message itself will be displayed by calling ui_display_single_message/2
% @arg Player Either `player` or `rot`; indicating to whom the message corresponds to
% @arg Action The action causing the messages frame's messages
% @arg Active_pokemon_player The active pokemon's name of the given player
% @arg Active_pokemon_opponent The active pokemon's name of the given player's opponent
% @arg Message The message to be displayed
% @see ui_display_single_message/2
ui_display_single_targeted_message(Who,_,A1,_, user(Message)) :-
  % just display
  ui_display_single_message(Who,A1, Message).
ui_display_single_targeted_message(Who,_,_,A2, target(Message)) :-
  % swap corresponding player
  opponent(Who, Not_who),
  ui_display_single_message(Not_who,A2, Message).
ui_display_single_targeted_message(Who,_,A1,_, Message) :-
  % base case: no wrapper, just display
  ui_display_single_message(Who,A1, Message).

%! ui_display_single_message(+Player, +Pokemon, +Message).
% Displays the given message.
% @arg Player Either `player` or `rot`; indicating to whom the message correspond to
% @arg Pokemon The name of the given player's active pokemon to which the message relates.
% @arg Message The message to be displayed
ui_display_single_message(Who, Out, switch(In)) :-
  % for pokemon being switched out
  write(Who), write(' withdrew '), write(Out),
  write(' and send '), write(In), write(' into battle').
ui_display_single_message(_, _, move_missed) :-
  % missing moves
  tab(2), write('but it missed').
ui_display_single_message(Who, Name, damaged(kp(Curr, Max))) :-
  % pokemon being damaged
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('is now at '), ui_display_percent(fraction(Curr, Max)).
ui_display_single_message(Who, Name, move(Move)) :-
  % pokemon using moves
  ui_display_pokemon_with_owner(Name, Who),
  write('uses '), write(Move).
ui_display_single_message(_,_, effectiveness(none)) :-
  % moves having no effect
  tab(2), write('it has no effect').
ui_display_single_message(_,_, effectiveness(not)) :-
  % moves having little effect
  tab(2), write('it was not very effective').
ui_display_single_message(_,_, effectiveness(very)) :-
  % moves having greater effect
  tab(2), write('it was very effective').
ui_display_single_message(_,_, critical(yes)) :-
  % moves lands a crittical hit
  tab(2), write('critical hit!').
ui_display_single_message(Who, Name, stat_stage(stat(Stat), cannot(Direction))) :-
  % status value stage can not increase/decrease
  member(Direction,[increase,decrease]), % make sure it is one of those
  tab(2), write(Stat), write(' stat of '),
  ui_display_pokemon_with_owner(Name, Who),
  write('can not '), write(Direction), write(' any further').
ui_display_single_message(Who, Name, stat_stage(stat(Stat), value(Value))) :-
  % status value stage increase
  Value > 0,
  tab(2), write(Stat), write(' stat of '),
  ui_display_pokemon_with_owner(Name, Who),
  write('increased by '), write(Value).
ui_display_single_message(Who, Name, stat_stage(stat(Stat), value(Value))) :-
  % status value stage decrease
  Value < 0,
  Value_inv is -1*Value, % inverted value for displaying reasons
  tab(2), write(Stat), write(' stat of '),
  ui_display_pokemon_with_owner(Name, Who),
  write('decreased by '), write(Value_inv).
ui_display_single_message(Who, Name, fainted) :-
  % pokemon fainted
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('has fainted').
ui_display_single_message(Who, Name, ailment(Ailment)) :-
  % suffering a new status condition
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('now suffers '), write(Ailment).
ui_display_single_message(Who, Name, paralyzed) :-
  % pokemon can not attack due to paralysis
  ui_display_pokemon_with_owner(Name, Who), write('is paralyzed').
ui_display_single_message(Who, Name, sleeps) :-
  % pokemon can not attack due to sleep
  ui_display_pokemon_with_owner(Name, Who), write('sleeps zzzZZZ').
ui_display_single_message(Who, Name, woke_up) :-
  % pokemon woke up from sleep
  ui_display_pokemon_with_owner(Name, Who), write('woke up').
ui_display_single_message(Who, Name, frozen) :-
  % pokemon can not attack due to freeze
  ui_display_pokemon_with_owner(Name, Who), write('is frozen').
ui_display_single_message(Who, Name, defrosted) :-
  % pokemon defrostet from freeze
  ui_display_pokemon_with_owner(Name, Who), write('defrosted').
ui_display_single_message(Who, Name, burns) :-
  % pokemon suffers from burn
  ui_display_pokemon_with_owner(Name, Who), write('burns').
ui_display_single_message(Who, Name, poisoned) :-
  % pokemon suffers from poison
  ui_display_pokemon_with_owner(Name, Who), write('is poisoned').
ui_display_single_message(Who, Name, drain) :-
  % pokemon drains life from the target
  tab(2), ui_display_pokemon_with_owner(Name, Who), write('drained some life').
ui_display_single_message(Who, Name, recoil) :-
  % pokemon suffers recoil damage
  tab(2), ui_display_pokemon_with_owner(Name, Who), write('suffers recoil damage').
ui_display_single_message(_,_, system(type(T), category(C), data(D))) :-
  % system message
  tab(2), write('>>> '), write(T-C:D).
ui_display_single_message(_, Message) :-
  % for unknown messages
  tab(4), write(('>>> unknown message occured: ', Message)).
