ui_display(state(Player, Rot, _)) :-
  ui_display_rot(Rot), nl,
  ui_display_player(Player).

ui_display_rot([Active|Team]) :-
  ui_display_rot_team([Active|Team]),
  ui_display_rot_active(Active).

ui_display_rot_team([]) :- nl.
ui_display_rot_team([To_display|Rest]) :-
  fainted(To_display),
  write('X'),
  ui_display_rot_team(Rest).
ui_display_rot_team([To_display|Rest]) :-
  primary_status_condition(To_display, nil),
  write('O'),
  ui_display_rot_team(Rest).
ui_display_rot_team([To_display|Rest]) :-
  \+ fainted(To_display),
  \+ primary_status_condition(To_display, nil),
  write('@'),
  ui_display_rot_team(Rest).

ui_display_rot_active(Active) :-
  ui_display_info_short(Active, rot).

ui_display_player([Active|Team]) :-
  ui_display_info(Active, you),
  write('team:'), nl,
  ui_display_player_team(Team).

ui_display_player_team([]).
ui_display_player_team([Pokemon|Rest]) :-
  Pokemon = [Name, kp(Curr, Max)|_],
  tab(2), write(Name), write(' at '), ui_display_percent(fraction(Curr, Max)),
  ui_display_primary_condition(Pokemon), nl,
  ui_display_player_team(Rest).

ui_display_fraction(Numerator, Denominator) :-
  write(Numerator), write('/'), write(Denominator), tab(1).

ui_display_percent(fraction(Numerator, Denominator)) :-
  P is Numerator/Denominator * 100,
  ui_display_percent(P).
ui_display_percent(P) :-
  number(P),
  Perc is round(P),
  write(Perc), write('% ').

ui_display_owner(Who) :-
  write('('), write(Who), write(') ').

ui_display_primary_condition(Pokemon) :-
  primary_status_condition(Pokemon, nil).
ui_display_primary_condition(Pokemon) :-
  primary_status_condition(Pokemon, Condition),
  Condition \= nil,
  write('<'), write(Condition), write('> ').

ui_display_info_short(Active, Who) :-
  Active = [Name, kp(KP_curr, KP_max)|_],
  ui_display_percent(fraction(KP_curr, KP_max)),
  write(Name), tab(1), ui_display_primary_condition(Active), ui_display_owner(Who).

ui_display_info(Pokemon, Who) :-
  ui_display_info_short(Pokemon, Who), nl,
  Pokemon = [_, kp(Curr, Max), Moves|_],
  tab(2), write('at '), ui_display_fraction(Curr, Max), write('hp'), nl,
  write('moves:'),nl,
  ui_display_moves(Moves).

ui_display_moves([]).
ui_display_moves([[Move, PP_left]|Rest]) :-
  move(Move, Type, Catpow, acc(Accuracy), pp(PP_max), _, _, _, _),
  tab(2), write(Move), write(' - '),
  ui_display_fraction(PP_left, PP_max), write('pp, '),
  write(Type), write(' type, '),
  ui_display_moves_catpow(Catpow),
  ui_display_moves_accuracy(Accuracy), nl,
  ui_display_moves(Rest).

ui_display_moves_catpow(status) :-
  write(status), write(', ').
ui_display_moves_catpow(Catpow) :-
  Catpow =.. [Category, Power],
  write(Category), write(', power: '), write(Power), write(', ').

ui_display_moves_accuracy(Accuracy) :-
  number(Accuracy),
  write('accuracy: '), ui_display_percent(Accuracy).
ui_display_moves_accuracy(Accuracy) :-
  \+ number(Accuracy),
  write('accuracy: - ').

ui_display_help :-
  nl,
  write('> for a specific move type the move name between a pair of \' (apostrophe)'), nl,
  tab(2), write('example: \'tackle\'.'),nl,
  write('> for switching to a partner type switch(\'partner name here\')'), nl,
  tab(2), write('example: switch(\'pikachu\').'),nl,
  write('> for information about a specific team partner type info(\'partner name here\')'), nl,
  tab(2), write('example: info(\'poliwrath\')'), nl,
  write('> you can always end the battle by typing: run.'), nl, nl,
  write('>>> as shown in the examples all choices have to end with a . (full stop)'), nl, nl.

ui_display_move_prompt :-
  write('choose your move:'), nl.

ui_display_run :-
  tab(2), write('you escaped safely').

ui_display_error(not_in_team, Pokemon) :-
  tab(2), write('there is no '), write(Pokemon), write(' in your team'), nl.
ui_display_error(already_fighting, Pokemon) :-
  tab(2), write(Pokemon), write(' is already fighting'), nl.
ui_display_error(wrong_move, Pokemon, Move) :-
  tab(2), write(Pokemon), write(' does not know how to '), write(Move), nl.
