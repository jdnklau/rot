:- [teams, ui, observing_predicates, setup].
:- ['database/movedex',
    'database/pokedex'].

test_ui_rot :-
  team_1(T),
  ui_display_rot(T).

test_ui_player :-
  team_1(T),
  ui_display_player(T).

test_ui :-
  team_1(T),
  ui_display(state(T, T, _)).

test_battle :-
  team_1(T),
  start_battle(T,T).
