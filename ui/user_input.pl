ui_display_move_prompt :-
  write('choose your move:'), nl.

ui_display_switch_prompt :-
  write('choose a pokemon to switch in:'), nl.

read_player_move(State, Move_player) :-
  read(Move_player),
  State = state(Team_player, _, _),
  validate_player_move(Team_player, Move_player).
read_player_move(T, M) :- % prepare for loop
  read_player_move(T,M).

read_player_switch(state(Team_player, _, _), Switch) :-
  read(Switch),
  validate_player_switch(Team_player, Switch).
read_player_switch(T, S) :-
  read_player_switch(T, S).

validate_player_move(_, run).
validate_player_move(_, help) :- !,
  ui_display_help, fail.
validate_player_move(Team, info(Team_member)) :-
  member([Team_member|Rest], Team), !,
  ui_display_info([Team_member|Rest], you), fail.
validate_player_move(Team, info(Team_member)) :-
  \+ member([Team_member|_], Team), !,
  ui_display_error(not_in_team, Team_member), fail.
validate_player_move(Team, switch(Team_mate)) :- !,
  validate_player_switch(Team, switch(Team_mate)).
validate_player_move([[_,_,Moves|_]|_], Move_choosen) :-
  member([Move_choosen,_], Moves).
validate_player_move([[Active_pokemon,_,Moves|_]|_], Move_choosen) :-
  \+ member([Move_choosen,_], Moves),
  Move_choosen \= switch(_),
  ui_display_error(wrong_move, Active_pokemon, Move_choosen), fail.

validate_player_switch([[Active_pokemon|_]|_], switch(Active_pokemon)) :-
  ui_display_error(already_fighting, Active_pokemon), nl, fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  member([Name|Data], Team_pokemon),
  \+ fainted([Name|Data]).
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  member([Name|Data], Team_pokemon),
  fainted([Name|Data]),
  ui_display_error(already_fainted, Name), fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  \+ member([Name,_,_,_,_,_], Team_pokemon),
  ui_display_error(not_in_team, Name), fail.
validate_player_switch(_, help) :-
  ui_display_help_switch, fail.
validate_player_switch(_, Command) :-
  Command \= switch(_),
  ui_display_error(wrong_command, Command),
  ui_display_help_switch, fail.
