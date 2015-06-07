ui_display_messages(msg(_, [])).
ui_display_messages(msg(_, _)) :-
  rot(searching).
ui_display_messages(msg(Who, Messages)) :-
  \+ rot(searching),
  Messages \= [],
  ui_display_message_stack(Who, Messages), nl.

ui_display_message_stack(_, []).
ui_display_message_stack(Who, [Message|Messages]) :-
  ui_display_message_stack(Who, Messages),
  ui_display_single_targeted_message(Who, Message), nl.

ui_display_single_targeted_message(Who, user(Message)) :-
  ui_display_single_message(Who, Message).
ui_display_single_targeted_message(Who, target(Message)) :-
  opponent(Who, Not_who),
  ui_display_single_targeted_message(Not_who, Message).
ui_display_single_targeted_message(Who, Message) :-
  ui_display_single_message(Who, Message).

ui_display_single_message(Who, switch(from(Out), to(In))) :-
  write(Who), write(' withdrew '), write(Out),
  write(' and send '), write(In), write(' into battle').
ui_display_single_message(_, move_missed) :-
  tab(2), write('but it missed').
ui_display_single_message(Who, damaged(pokemon(Name), kp(Curr, Max))) :-
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('is now at '), ui_display_percent(fraction(Curr, Max)).
ui_display_single_message(Who, uses(pokemon(Name), move(Move))) :-
  ui_display_pokemon_with_owner(Name, Who),
  write('uses '), write(Move).
ui_display_single_message(_, no_effect) :-
  tab(2), write('it has no effect').
ui_display_single_message(Who, fainted(Name)) :-
  tab(2), ui_display_pokemon_with_owner(Name, Who),
  write('has fainted').
% for unknown messages:
ui_display_single_message(_, Message) :-
  tab(4), write(('>>> unknown message occured: ', Message, '<<<')).
