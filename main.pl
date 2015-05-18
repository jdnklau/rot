:- [test, teams, ui, setup, rot, battle_processor, calculations, observing_predicates].
:- ['database/movedex',
    'database/natures',
    'database/pokedex',
    'database/typechart'].
:- use_module(library(random)).

%%%

start_battle(Team_player, Team_rot) :-
  State = state(Team_player, Team_rot, [[],[],[]]),
  ui_display_battle_start(Team_player, Team_rot),
  run_battle(State), !.

run_battle(State) :-
  ui_display(State),
  ui_display_move_prompt,
  read_player_move(State, Move_player),
  read_rot_move(State, Move_rot),nl,
  (
    Move_player = run, ui_display_run, ! ;
    process_round(State, Move_player, Move_rot, New_state),
    (
      game_over(New_state) ;
      run_battle(New_state)
    )
  ).


game_over(state(Player, _, _)) :-
  team_completely_fainted(Player),
  ui_display_win(rot).
game_over(state(_, Rot, _)) :-
  team_completely_fainted(Rot),
  ui_display_win(player).


read_rot_move(State, Move) :-
  rot_choose_move(State, Move).

read_rot_switch(State, Switch) :-
  rot_choose_switch(State, Switch).

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
