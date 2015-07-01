ui_display_error(not_in_team, Pokemon) :-
  tab(2), write('there is no '), write(Pokemon), write(' in your team'), nl.
ui_display_input_error(already_fighting, Pokemon, _) :-
  tab(2), write(Pokemon), write(' is already fighting'), nl.
ui_display_input_error(already_fainted, Pokemon, _) :-
  tab(2), write(Pokemon), write(' has already fainted'), nl.
ui_display_input_error(wrong_command, Command, _) :-
  tab(2), write(Command), write(' is not a valid command here'), nl.
ui_display_input_error(wrong_move, Pokemon, Move) :-
  tab(2), write(Pokemon), write(' does not know how to '), write(Move), nl.
