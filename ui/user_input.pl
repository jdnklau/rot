%! ui_display_move_prompt.
% Prompts the player to enter a move for this turn.
ui_display_move_prompt :-
  write('choose your move:'), nl.

%! ui_display_switch_prompt(+Team).
% Prompts the player to choose a pokemon to switch to and lists the players team.
% @arg Team The player's team
ui_display_switch_prompt(Team) :-
  write('choose a pokemon to switch in:'), nl,
  ui_display_player_team(Team).

%! read_player_move(+Game_state, -Move).
% Prompts the player to enter a move, reads player input and validates it.
% The input/validate process is repeated until the player entered a valid move.
% @arg Game_state The current state of the game
% @arg Move A valid move the player entered.
read_player_move(State, Move_player) :-
  ui_display_move_prompt, %prompt player
  repeat, % we need to loop as long as the validation fails
  read(Move_player),
  State = state(Team_player, _, _),
  validate_player_move(Team_player, Move_player).

%! read_player_switch(+Game_state, -Switch).
% Prompts the player to enter a switch, reads player input and validates it.
% The input/validate process is repeated until the player entered a valid switch.
% @arg Game_state The current state of the game
% @arg Move A valid move the player entered.
read_player_switch(state(Team_player, _, _), Switch) :-
  ui_display_switch_prompt(Team_player), % prompt player
  repeat, % we need to loop as long as the validation fails
  read(Switch),
  validate_player_switch(Team_player, Switch).

%! validate_player_move(+Team, +Move).
% True if the given move can be executed by the player.
% Valid moves are:
% - run
% - switch(Pokemon) as long
%   - Pokemon is in the team
%   - Pokemon is not the active pokemon
%   - Pokemon has not yet fainted
% - one of the four moves of the pokemon as long as the move has pp left
% Alternatively one can enter the following moves:
% - help, this displays the command overview
% - info(Pokemon), this displays the information of a specific team pokemon
%   - Pokemon has to be in the team
% The use of invalid commands (this includes the alternatives above) results in
% this predicate failing with a proper error message.
%
% @arg Team The player's team
% @arg Move The player's choosen move
% @see validate_player_switch/2
validate_player_move(_, run). % ends the battle
validate_player_move(_, help) :- !, % red cut
  % display help
  ui_display_help, fail.
validate_player_move(Team, info(Team_member)) :-
  % display team member information
  member([Team_member|Rest], Team), !, % red cut
  ui_display_info([Team_member|Rest], you), fail.
validate_player_move(_Team, info(Team_member)) :- !, % red cut
  % information about a non-existent team member
  %\+ member([Team_member|_], Team), !, % member/2 check already in the clause above
  ui_display_input_error(not_in_team, Team_member, info(Team_member)), fail.
validate_player_move(Team, switch(Team_mate)) :- !,
  % switch team mate (has it's own predicate)
  validate_player_switch(Team, switch(Team_mate)).
validate_player_move([[_,_,Moves|_]|_], Move_choosen) :-
  % pokemon move
  member([Move_choosen,_], Moves), !.
validate_player_move([[Active_pokemon,_,_Moves|_]|_], Move_choosen) :-
  % to the active pokemon unknown move
  %\+ member([Move_choosen,_], Moves), % member/2 check already in the clause above
  Move_choosen \= switch(_),
  ui_display_input_error(wrong_move, Active_pokemon, Move_choosen), fail.

%! validate_player_switch(+Team, +Pokemon).
% True if the given switch can be executed by the player.
% A switch is valid if:
%   - Pokemon is in the team
%   - Pokemon is not the active pokemon
%   - Pokemon has not yet fainted
% Alternatively one can enter the following commands:
% - help, this displays the command overview
% - info(Pokemon), this displays the information of a specific team pokemon
%   - Pokemon has to be in the team
% The use of invalid commands (this includes the alternatives above) results in
% this predicate failing with a proper error message.
%
% @arg Team The player's team
% @arg Switch The pokemon name of the pokemon the player wants to switch to
validate_player_switch(Team, info(Pokemon)) :- !, % red cut
  % display information
  validate_player_move(Team, info(Pokemon)).
validate_player_switch(_, help) :-
  % display help
  !, ui_display_help_switch, fail.
validate_player_switch([[Active_pokemon|_]|_], switch(Active_pokemon)) :-
  % switch to active pokemon
  ui_display_input_error(already_fighting, Active_pokemon, switch(Active_pokemon)), fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  % valid switch
  Name \= Active_pokemon,
  member([Name|Data], Team_pokemon),
  \+ fainted([Name|Data]).
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  % switch to fainted pokemon
  Name \= Active_pokemon,
  member([Name|Data], Team_pokemon),
  fainted([Name|Data]),!, % red cut
  ui_display_input_error(already_fainted, Name, switch(Name)), fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  % switch to non-existing pokemon
  Name \= Active_pokemon,
  \+ member([Name,_,_,_,_,_], Team_pokemon),!,% red cut
  ui_display_input_error(not_in_team, Name, switch(Name)), fail.
validate_player_switch(_, Command) :-
  % wrong command
  Command \= switch(_),
  ui_display_input_error(wrong_command, nil, Command),
  ui_display_help_switch, fail.
