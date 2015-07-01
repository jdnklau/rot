ui_display_move_prompt :-
  write('choose your move:'), nl.

ui_display_switch_prompt(Team) :-
  write('choose a pokemon to switch in:'), nl,
  ui_display_player_team(Team).

read_player_move(State, Move_player) :-
  ui_display_move_prompt,
  repeat,
  read(Move_player),
  State = state(Team_player, _, _),
  validate_player_move(Team_player, Move_player).

read_player_switch(state(Team_player, _, _), Switch) :-
  ui_display_switch_prompt(Team_player),
  repeat,
  read(Switch),
  validate_player_switch(Team_player, Switch).

validate_player_move(_, run).
validate_player_move(_, help) :- !,
  ui_display_help, fail.
validate_player_move(Team, info(Team_member)) :-
  member([Team_member|Rest], Team), !,
  ui_display_info([Team_member|Rest], you), fail.
validate_player_move(Team, info(Team_member)) :-
  \+ member([Team_member|_], Team), !,
  ui_display_input_error(not_in_team, Team_member, info(Team_member)), fail.
validate_player_move(Team, switch(Team_mate)) :- !,
  validate_player_switch(Team, switch(Team_mate)).
validate_player_move([[_,_,Moves|_]|_], Move_choosen) :-
  member([Move_choosen,_], Moves).
validate_player_move([[Active_pokemon,_,Moves|_]|_], Move_choosen) :-
  \+ member([Move_choosen,_], Moves),
  Move_choosen \= switch(_),
  ui_display_input_error(wrong_move, Active_pokemon, Move_choosen), fail.

validate_player_switch([[Active_pokemon|_]|_], switch(Active_pokemon)) :-
  ui_display_input_error(already_fighting, Active_pokemon, switch(Active_pokemon)), fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  member([Name|Data], Team_pokemon),
  \+ fainted([Name|Data]).
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  member([Name|Data], Team_pokemon),
  fainted([Name|Data]),
  ui_display_input_error(already_fainted, Name, switch(Name)), fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  \+ member([Name,_,_,_,_,_], Team_pokemon),
  ui_display_input_error(not_in_team, Name, switch(Name)), fail.
validate_player_switch(_, help) :-
  ui_display_help_switch, fail.
validate_player_switch(_, Command) :-
  Command \= switch(_),
  ui_display_input_error(wrong_command, nil, Command),
  ui_display_help_switch, fail.
