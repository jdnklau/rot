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

test_available :-
  team_1(T),
  available_moves(T, A),
  write(A).

test_search_tree :-
  team_1(T),
  write('tree depth: '),
  read(D),
  asserta(rot(searching)),
  create_tree(state(T,T,[[],[],[]]), D, Tree),
  retract(rot(searching)),
  %write_tree(Tree, 0), nl,
  search_tree(Tree, Moves),
  write(expected:Moves), nl.

write_tree(tree(State, Nodes), I) :-
  State = state(Player, Rot, _),
  tab(I),write_tree_team(Player),nl,
  tab(I),write_tree_team(Rot),nl,
  II is I+4,
  write_tree_nodes(Nodes, II).

write_tree_nodes([],_).
write_tree_nodes([Mr:Nodes_by_player|Nodes], I) :-
  write_tree_nodes_by_player(Mr, Nodes_by_player, I),
  write_tree_nodes(Nodes, I).

write_tree_nodes_by_player(_,[],_).
write_tree_nodes_by_player(Mr, [Mp:Tree|Nodes], I) :-
  tab(I), write((#, Mp, Mr)), nl,
  write_tree(Tree, I),
  write_tree_nodes_by_player(Mr, Nodes, I).

write_tree_team([]).
write_tree_team([Lead|Rest]) :-
  hp_percent(Lead, P),
  Lead = [Name|_],
  write(Name), write(' at '), ui_display_percent(P),
  ui_display_primary_condition(Lead), write('- '),
  write_tree_team(Rest).
