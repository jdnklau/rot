:- use_module(library(random)).
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- [test, teams, save_states].
:- [database/movedex,
    database/natures,
    database/pokedex/pokemon_forms,
    database/pokedex/pokemon_species,
    database/pokedex/pokemon_stats,
    database/typechart,
    database/learndex,
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
:- [tools/adt/queue].
:- [rot/api,
    rot/ai,
    rot/search_tree].
:- [rot/expert/init,
    rot/expert/data_access,
    rot/expert/inference_engine,
    rot/expert/knowledge_base,
    rot/expert/eval/message_frame_eval,
    rot/expert/eval/stats_eval,
    rot/expert/eval/move_eval,
    rot/expert/eval/end_of_turn_eval,
    rot/expert/eval/damage_eval,
    rot/expert/eval/switch_eval].

%%%

start_battle(Team_player, Team_rot) :-
  team_list(Team_player, List_player),
  rot_initialize(List_player, Team_rot),
  State = state(Team_player, Team_rot, [[],[],[]]),
  ui_display_battle_start(Team_player, Team_rot),
  run_battle(State),
  rot_clear, !.

run_battle(State) :-
  ui_display(State),
  read_player_action(State, Action_player),
  (
    Action_player = run, ui_display_run, ! ;
    read_rot_action(State, Action_rot),nl,
    process_turn(State, Action_player, Action_rot, New_state),
    !, % cut to eventually keep call stack clean
    (
      game_over(New_state) ;
      set_save_state(New_state),
      run_battle(New_state)
    )
  ).
