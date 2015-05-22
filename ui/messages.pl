ui_display_messages(msg(_, [])).
ui_display_messages(msg(_, _)) :-
  rot(searching).
ui_display_messages(msg(Who, Messages)) :-
  \+ rot(searching),
  Messages \= [],
  ui_display_messages(Who, Messages), nl.

ui_display_messages(_, []).
ui_display_messages(Who, [switch(from(Out), to(In))|Rest]) :-
  ui_display_messages(Who, Rest),
  write(Who), write(' withdrew '), write(Out),
  write(' and send '), write(In), write(' into battle'), nl.
ui_display_messages(Who, [move_missed|Rest]) :-
  ui_display_messages(Who, Rest),
  tab(2), write('but it missed'), nl.
ui_display_messages(Who, [damaged(target(Name), kp(Curr, Max))|Rest]) :-
  ui_display_messages(Who, Rest),
  opponent(Who, Not_who),
  tab(2), ui_display_pokemon_with_owner(Name, Not_who),
  write('is now at '), ui_display_percent(fraction(Curr, Max)), nl.
ui_display_messages(Who, [uses(attacker(Name), move(Move))|Rest]) :-
  ui_display_messages(Who, Rest),
  ui_display_pokemon_with_owner(Name, Who),
  write('uses '), write(Move), nl.
ui_display_messages(Who, [no_effect|Rest]) :-
  ui_display_messages(Who, Rest),
  tab(2), write('it has no effect'), nl.
ui_display_messages(Who, [fainted(target(Name))|Rest]) :-
  ui_display_messages(Who, Rest),
  opponent(Who, Not_who),
  tab(2), ui_display_pokemon_with_owner(Name, Not_who),
  write('has fainted'), nl.
% for unknown messages:
ui_display_messages(Who, [Message|Rest]) :-
  ui_display_messages(Who, Rest),
  tab(4), write('unknown message: '), write(Message), nl.
