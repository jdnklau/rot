:- [test, ui, setup, rot, cpu].
:- ['database/movedex.pl',
    'database/natures.pl',
    'database/pokedex.pl',
    'database/typechart.pl'].

test :-
  team_1(T),
  run_battle(T,T), !.


%%%


run_battle(Team_A, Team_B) :-
  print_teams(Team_A, Team_B),
  read_player_move(Team_A, Move_player),
  read_enemy_move(Team_A, Team_B, Move_enemy),nl,
  (
    Move_player = run, ui_run_away, ! ;
    process(Team_A, Move_player, Team_B, Move_enemy, [nil,nil,nil], New_A, New_B, _New_Field),
    run_battle(New_A, New_B)).

read_enemy_move(Team_player, Team_rot, Move) :-
  rot_choose_move(Team_player, Team_rot, Move).

read_player_move(Team_A, Move_player) :-
  ui_choose_move_prompt,
  read(Move_player),
  validate_player_move(Team_A, Move_player).
read_player_move(T, M) :- % prepare for loop
  read_player_move(T,M).

validate_player_move(_, run).
validate_player_move(_, help) :- !,
  print_help_message, fail.
validate_player_move(Team, switch(Team_mate)) :-
  validate_player_switch(Team, switch(Team_mate)).
validate_player_move([[_,_,Moves,_,_,_]|_], Move_choosen) :-
  member([Move_choosen,_], Moves).
validate_player_move([[Active_pokemon,_,Moves,_,_,_]|_], Move_choosen) :-
  \+ member([Move_choosen,_], Moves),
  Move_choosen \= switch(_),
  ui_move_unknown(Active_pokemon, Move_choosen),
  nl, fail.

validate_player_switch([[Active_pokemon,_,_,_,_,_]|_], switch(Active_pokemon)) :-
  ui_already_fighting(Active_pokemon), nl, fail.
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  member([Name,_,_,_,_,_], Team_pokemon).
validate_player_switch([[Active_pokemon,_,_,_,_,_]|Team_pokemon], switch(Name)) :-
  Name \= Active_pokemon,
  \+ member([Name,_,_,_,_,_], Team_pokemon),
  ui_no_such_team_member(Name), nl, fail.
