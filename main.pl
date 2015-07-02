:- [test, teams].
:- [database/movedex,
    database/natures,
    database/pokedex,
    database/typechart,
    database/evolutions].
:- [cpu/battle_processor,
    cpu/calculations,
    cpu/critical_hits,
    cpu/randomized_calculations].
:- [ui/battle_interface,
    ui/error,
    ui/messages,
    ui/user_input].
:- [tools/battle_data_access,
    tools/pokemon_data_access,
    tools/setups,
    tools/message_handling].
:- [rot/interface,
    rot/ai,
    rot/search_tree].
:- use_module(library(random)).

%%%

start_battle(Team_player, Team_rot) :-
  State = state(Team_player, Team_rot, [[],[],[]]),
  ui_display_battle_start(Team_player, Team_rot),
  run_battle(State), !.

run_battle(State) :-
  ui_display(State),
  read_player_action(State, Action_player),
  (
    Action_player = run, ui_display_run, ! ;
    read_rot_action(State, Action_rot),nl,
    process_turn(State, Action_player, Action_rot, New_state),
    (
      game_over(New_state) ;
      run_battle(New_state)
    )
  ).
