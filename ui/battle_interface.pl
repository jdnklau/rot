%! ui_display_battle_start(+Team_player, +Team_rot)
% Displays both teams and the help dialog
% @arg Team_player The player's team
% @arg Tea_rot Rot's team
ui_display_battle_start(Player, Rot) :-
  write('rot has challenged you to battle'), nl,nl,
  write('your team: '), ui_display_team_list(Player), nl,
  write('rot\'s team: '), ui_display_team_list(Rot), nl,
  ui_display_help.

%! ui_display_team_list(+Team)
% Displays a List of the pokemon's names
% @arg Team The team to display
ui_display_team_list([[Name|_]]) :-
  write(Name), tab(1).
ui_display_team_list([[Name|_]|Rest]) :-
  write(Name), write(', '),
  ui_display_team_list(Rest).

%! ui_display(+Game_state)
% Displays the battle screen based on the current game state
% @arg Game_state Current state of the game
ui_display(state(Player, Rot, _)) :-
  ui_display_rot(Rot), nl,
  ui_display_player(Player).

%! ui_display_rot(+Team)
% Displays the team information and the active pokemon of Rot
% @arg Team Rot's team
ui_display_rot([Active|Team]) :-
  ui_display_rot_team([Active|Team]),
  ui_display_rot_active(Active). % display active pokemon last so it competes visually with the players acitve one

%! ui_display_rot_team(+Team).
% Displays the team of Rot in form of pokeballs.
% This is the display one could be used to by the core series games as the pokemon
% of the enemy team are displayed as pokeballs. The style of display indicates
% if a pokemon maybe suffers a primary status condition (@) or has fainted (X)
% @arg Team Rot's team
ui_display_rot_team([]) :- nl.
ui_display_rot_team([To_display|Rest]) :-
  fainted(To_display),
  !, % red cut #1
  write('X'), % indicates a fainted pokemon
  ui_display_rot_team(Rest).
ui_display_rot_team([To_display|Rest]) :-
  primary_status_condition(To_display, nil),
  !, % red cut #2
  write('O'),
  ui_display_rot_team(Rest).
ui_display_rot_team([_|Rest]) :-
  %\+ fainted(To_display), % red cut #1 prevents this line
  %\+ primary_status_condition(To_display, nil), % red cut #2 prevents this line
  write('@'),
  ui_display_rot_team(Rest).

%! ui_display_rot_active(+Pokemon)
% Display rot's active pokemon
% @arg Pokemon The active pokemons pokemon data
ui_display_rot_active(Active) :-
  ui_display_info_short(Active, rot).

%! ui_display_player(+Team)
% Displays the player's team.
% @arg Team The player's team
ui_display_player([Active|Team]) :-
  ui_display_info(Active, player),
  write('team:'), nl,
  ui_display_player_team(Team).

%! ui_display_player_team(+Team).
% Displays the players team pokemon as a list with some information.
% Their hp percentage and primary status condition are displayed alongside with their names.
% Intended to display the non-active pokemon of the player's team
% @arg Team The player's team
ui_display_player_team([]).
ui_display_player_team([Pokemon|Rest]) :-
  Pokemon = [Name, kp(Curr, Max)|_], % split information of the pokemon to be displayed
  tab(2), write(Name), write(' at '), ui_display_percent(fraction(Curr, Max)), % name and hit points
  ui_display_primary_condition(Pokemon), nl, % primary status condition
  ui_display_player_team(Rest).

%! ui_display_fraction(+Numerator, +Denominator).
% Displays a fraction on the console line.
ui_display_fraction(Numerator, Denominator) :-
  write(Numerator), write('/'), write(Denominator), tab(1).

%! ui_display_percent(+Percentage).
% Display a percentage.
% @arg Percentage Either a number from 0 to 100 or data of the form `fraction(Numerator, Denominator)`
ui_display_percent(fraction(Numerator, Denominator)) :-
  P is Numerator/Denominator * 100, % calculate the percentage of the fraction
  ui_display_percent(P).
ui_display_percent(P) :-
  number(P), % make sure the input is a number
  Perc is round(P),
  write(Perc), write('% ').

%! ui_display_owner(+Name)
% Displays the given owner in parentheses
% @arg Name Name of the owner to be displayed
ui_display_owner(Who) :-
  write('('), write(Who), write(') ').

%! ui_display_pokemon_with_owner(+Pokemon_name, +Pokemon_owner).
% Display a pokemon alongside with its owner
ui_display_pokemon_with_owner(Name, Who) :-
  write(Name), tab(1), ui_display_owner(Who).

%! ui_display_primary_condition(+Pokemon).
% Displays the primary status condition of a pokemon.
% Does nothing if the condition is `nil`
% @arg Pokemon The pokemon data of the pokemon in question
ui_display_primary_condition(Pokemon) :-
  primary_status_condition_category(Pokemon, nil). % no condition
ui_display_primary_condition(Pokemon) :-
  primary_status_condition_category(Pokemon, Condition),
  Condition \= nil,
  write('<'), write(Condition), write('> ').

%! ui_display_info_short(+Pokemon, +Owner).
% Display the given Pokemon with its owners name in a short info frame.
% Additionally its hp percentage and its primary status cndition may be displayed.
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Owner Either `player` or `rot`
ui_display_info_short(Active, Who) :-
  Active = [Name|_],
  hp_percent(Active, P),
  ui_display_percent(P),
  write(Name), tab(1), ui_display_primary_condition(Active), ui_display_owner(Who).

%! ui_display_info(+Pokemon, +Owner).
% Display an info frame of the given pokemon.
% The display consists of:
%   * a ui_display_info_short/2 call
%   * precise information about the pokemons current and maximal hit points
%   * a list of the moves the pokemon knows alongside with their remaining power points
% @arg Pokemon The pokemon data of the pokemon in question
% @arg Owner Either `player` or `rot`
ui_display_info(Pokemon, Who) :-
  ui_display_info_short(Pokemon, Who), nl,
  Pokemon = [_, kp(Curr, Max), Moves|_],
  tab(2), write('at '), ui_display_fraction(Curr, Max), write('hp'), nl,
  write('moves:'),nl,
  % display struggle if it is the only move to use
  (
    available_moves([Pokemon],[struggle]),!,
    ui_display_moves([[struggle,1]])
  ;
    ui_display_moves(Moves)
  ).

%! ui_display_moves(+Move_data_list).
% Displays information about the given moves.
% @arg Move_data_list List of the move data extracted from a pokemon's pokemon data
ui_display_moves([]).
ui_display_moves([[Move, PP_left]|Rest]) :-
  move(Move, Type, Catpow, acc(Accuracy), pp(PP_max), _, _, _, _), % get data not saved in the given structure
  tab(2), write(Move), write(' - '),
  ui_display_fraction(PP_left, PP_max), write('pp, '),
  write(Type), write(' type, '),
  ui_display_moves_catpow(Catpow),
  ui_display_moves_accuracy(Accuracy), nl,
  ui_display_moves(Rest).

%! ui_display_moves_catpow(+Category_information).
% Display a moves category and - in case of an offensive category - its base power
% @arg Category_information The information about a moves category and base power
ui_display_moves_catpow(status) :-
  write(status), write(', ').
ui_display_moves_catpow(Catpow) :-
  Catpow =.. [Category, Power],
  write(Category), write(', power: '), write(Power), write(', ').

%! ui_display_moves_accuracy(Percentage).
% Displays an accuracy label with the given percentage.
% Intended to display accuracy information of a move.
% @arg Percentage The moves accuracy - can be a non-numeric term
ui_display_moves_accuracy(Accuracy) :-
  number(Accuracy),
  write('accuracy: '), ui_display_percent(Accuracy).
ui_display_moves_accuracy(Accuracy) :-
  \+ number(Accuracy), % not a percentage
  write('accuracy: - '). % accuracy is determined differently then a fixed percentage

%! ui_display_win(+Winner).
% Displays a win dialog.
% @arg Winner The player who has won - either `player` or `rot`
ui_display_win(Who) :-
  write(Who), write(' has won the battle'), nl.

%! ui_display_help.
% Display a help dialog.
% The dialog lists all possible commands
ui_display_help :-
  nl,
  write('> for a specific move type the move name'), nl,
  tab(2), write('example: volt-tackle.'),nl,
  ui_display_help_switch,
  write('> for information about a specific team partner type info(partner-name)'), nl,
  tab(2), write('example: info(poliwrath)'), nl,
  write('> for displaying this help again type: help.'), nl,
  write('> you can always end the battle by typing: run.'), nl, nl,
  write('>>> as shown in the examples all choices have to end with a . (full stop)'), nl, nl.

%! ui_display_help_switch.
% Display a help dialog specifically ment for switching a pokemon out.
% @see ui_display_help/0
ui_display_help_switch :-
  write('> for switching to a partner type switch(partner-name)'), nl,
  tab(2), write('example: switch(pikachu).'),nl.

%! ui_display_run.
% Display a messages taht the player has run from the battle.
ui_display_run :-
  tab(2), write('you escaped safely').
