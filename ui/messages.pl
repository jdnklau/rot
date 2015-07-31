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
  message_frame_owner(Frame, Who), % get corresponding player
  get_message_frame_list(Frame, Messages), % get the frames messages
  ui_display_message_list(Who, Messages), nl.

%! ui_display_message_list(+Player, +Message_list).
% Displays the messages of the given message list.
% @arg Player Either `player` or `rot`; indicating to whom the messages correspond to
% @arg Message_list The message list to be displayed.
ui_display_message_list(_, []). % no messages
ui_display_message_list(Who, [Message|Messages]) :-
  % printing the stack in reverse (bottom element shall be printed first)
  ui_display_single_targeted_message(Who, Message), % print message
  nl,
  ui_display_message_list(Who, Messages). % print remaining messages

%! ui_display_single_targeted_message(+Player, +Message).
% Displays the given message dependent on eventually targeting frames attached to it.
% If Message unifies with user(Msg) or has no targeting frame attached to it, the message is displayed normaly.
% If Message unifies with target(Msg) it will be displayed from the opposing player's point of view
% The message itself will be displayed by calling ui_display_single_message/2
% @arg Player Either `player` or `rot`; indicating to whom the message correspond to
% @arg Message The message to be displayed
% @see ui_display_single_message/2
ui_display_single_targeted_message(Who, user(Message)) :-
  % just display
  ui_display_single_message(Who, Message).
ui_display_single_targeted_message(Who, target(Message)) :-
  % swap corresponding player
  opponent(Who, Not_who),
  ui_display_single_targeted_message(Not_who, Message).
ui_display_single_targeted_message(Who, Message) :-
  % just display
  ui_display_single_message(Who, Message).

%! ui_display_single_message(+Player, +Message).
% Displays the given message.
% @arg Player Either `player` or `rot`; indicating to whom the message correspond to
% @arg Message The message to be displayed
ui_display_single_message(Who, switch(from(Out), to(In))) :-
  % for pokemon being switched out
  write(Who), write(' withdrew '), write(Out),
  write(' and send '), write(In), write(' into battle').
ui_display_single_message(_, move_missed) :-
  % missing moves
  tab(2), write('but it missed').
ui_display_single_message(Who, damaged(pokemon(Name), kp(Curr, Max))) :-
  % pokemon being damaged
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('is now at '), ui_display_percent(fraction(Curr, Max)).
ui_display_single_message(Who, uses(pokemon(Name), move(Move))) :-
  % pokemon using moves
  ui_display_pokemon_with_owner(Name, Who),
  write('uses '), write(Move).
ui_display_single_message(_, no_effect) :-
  % moves having no effect
  tab(2), write('it has no effect').
ui_display_single_message(_, effectiveness(not)) :-
  % moves having little effect
  tab(2), write('it was not very effective').
ui_display_single_message(_, effectiveness(very)) :-
  % moves having greater effect
  tab(2), write('it was very effective').
ui_display_single_message(_, critical) :-
  % moves lands a crittical hit
  tab(2), write('critical hit!').
ui_display_single_message(Who, stat_stage(pokemon(Name), stat(Stat), cannot(Direction))) :-
  % status value stage can not increase/decrease
  member(Direction,[increase,decrease]), % make sure it is one of those
  tab(2), write(Stat), write(' stat of '),
  ui_display_pokemon_with_owner(Name, Who),
  write('can not '), write(Direction), write(' any further').
ui_display_single_message(Who, stat_stage(pokemon(Name), stat(Stat), value(Value))) :-
  % status value stage increase
  Value > 0,
  tab(2), write(Stat), write(' stat of '),
  ui_display_pokemon_with_owner(Name, Who),
  write('increased by '), write(Value).
ui_display_single_message(Who, stat_stage(pokemon(Name), stat(Stat), value(Value))) :-
  % status value stage decrease
  Value < 0,
  Value_inv is -1*Value, % inverted value for dispaying reasons
  tab(2), write(Stat), write(' stat of '),
  ui_display_pokemon_with_owner(Name, Who),
  write('decreased by '), write(Value_inv).
ui_display_single_message(Who, fainted(Name)) :-
  % pokemon fainted
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('has fainted').
ui_display_single_message(Who, ailment(pokemon(Name), suffers(Ailment))) :-
  % suffering a new status condition
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('now suffers '), write(Ailment).
ui_display_single_message(Who, paralyzed(Pokemon)) :-
  % pokemon can not attack due to paralysis
  ui_display_pokemon_with_owner(Pokemon, Who), write('is paralyzed').
ui_display_single_message(Who, sleeps(Pokemon)) :-
  % pokemon can not attack due to sleep
  ui_display_pokemon_with_owner(Pokemon, Who), write('sleeps zzzZZZ').
ui_display_single_message(Who, woke_up(Pokemon)) :-
  % pokemon woke up from sleep
  ui_display_pokemon_with_owner(Pokemon, Who), write('woke up').
ui_display_single_message(Who, frozen(Pokemon)) :-
  % pokemon can not attack due to freeze
  ui_display_pokemon_with_owner(Pokemon, Who), write('is frozen').
ui_display_single_message(Who, defrosted(Pokemon)) :-
  % pokemon defrostet from freeze
  ui_display_pokemon_with_owner(Pokemon, Who), write('defrosted').
ui_display_single_message(Who, burns(Pokemon)) :-
  % pokemon suffers from burn
  ui_display_pokemon_with_owner(Pokemon, Who), write('burns').
ui_display_single_message(Who, poisoned(Pokemon)) :-
  % pokemon suffers from poison
  ui_display_pokemon_with_owner(Pokemon, Who), write('is poisoned').
ui_display_single_message(Who, drain(Pokemon)) :-
  % pokemon drains life from the target
  tab(2), ui_display_pokemon_with_owner(Pokemon, Who), write('drained some life').
ui_display_single_message(Who, recoil(Pokemon)) :-
  % pokemon suffers recoil damage
  tab(2), ui_display_pokemon_with_owner(Pokemon, Who), write('suffers recoil damage').
ui_display_single_message(_, system(type(T), category(C), data(D))) :-
  % system message
  tab(2), write('>>> '), write(T-C:D).
ui_display_single_message(_, Message) :-
  % for unknown messages
  tab(4), write(('>>> unknown message occured: ', Message, '<<<')).
