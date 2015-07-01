%! ui_display_input_error(+Error_ID, +Pokemon, +Move).
%
% Displays an error message depending on the given error id.
% These errors are ment to be used on wrong user input and not to display internal
% issues.
%
% Available error identifiers (being all prolog atoms) are:
% - not_in_team
% - already_fighting
% - already_fainted
% - wrong_command
% - wrong_move
%
% @arg Error_ID One of the error identifying prolog atoms listed in the predicate description
% @arg Pokemon The name of either the pokemon using the move or the pokemon being switched to
% @arg Move The move the player wants to execute
ui_display_input_error(not_in_team, Pokemon, _) :-
  tab(2), write('there is no '), write(Pokemon), write(' in your team'), nl.
ui_display_input_error(already_fighting, Pokemon, _) :-
  tab(2), write(Pokemon), write(' is already fighting'), nl.
ui_display_input_error(already_fainted, Pokemon, _) :-
  tab(2), write(Pokemon), write(' has already fainted'), nl.
ui_display_input_error(wrong_command, _, Command) :-
  tab(2), write(Command), write(' is not a valid command here'), nl.
ui_display_input_error(wrong_move, Pokemon, Move) :-
  tab(2), write(Pokemon), write(' does not know how to '), write(Move), nl.
