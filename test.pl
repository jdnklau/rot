test_alot(0,_) :-
  !, % never backtrack
  write(n=0),write('\a'),nl.
test_alot(N,Goal) :-
  write(n=N),nl,
  call(Goal),!,
  NN is N-1,
  test_alot(NN,Goal).

test_ui_rot :-
  team_1(T),
  ui_display_rot(T).

test_ui_player :-
  team_1(T),
  ui_display_player(T).

test_ui :-
  team_1(T),
  ui_display(state(T, T, _)).

test_pp :-
  team_1(T),
  T = [P1|Ps],
  P1 = [Name,HP,[[M1,_]|Rest_moves]|Rest],
  P2 = [Name,HP,[[M1,0]|Rest_moves]|Rest],
  T2 = [P2|Ps],
  start_battle(T2,T).

test_struggle :-
  team_1(T),
  T = [P1|Ps],
  P1 = [Name,HP,[[M1,_],[M2,_],[M3,_],[M4,_]]|Rest],
  P2 = [Name,HP,[[M1,0],[M2,0],[M3,0],[M4,0]]|Rest],
  T2 = [P2|Ps],
  start_battle(T2,T).

test_battle_small :-
  team_1(T),
  write(team_loaded),nl,
  start_battle(T,T).

test_battle :-
  team_rot(T),
  write(team_loaded),nl,
  start_battle(T,T).

test_rot_battle :-
  test_rot_battle(minmax, simple, minmax, advanced).
test_rot_battle(A1,R1,A2,R2) :-
  team_rot(T),
  start_rot_battle(T,A1,R1,T,A2,R2).

test_rot_battle_small :-
  test_rot_battle_small(minmax_prediction, simple, minmax, simple).
test_rot_battle_small(A1,R1,A2,R2) :-
  team_1(T),
  start_rot_battle(T,A1,R1,T,A2,R2).

test_save_state :-
  rot_clear,
  load_save_state(State),
  run_battle(State),
  rot_clear.

test_turn :-
  team_rot(T),
  State = state(T,T,_),
  available_actions(T,[A|_]),
  ui_display(State),
  process_turn(State,A,A,Result),
  ui_display(Result).

test_available_actions :-
  team_rot(T),
  available_actions(T, A),
  write(A).

test_tree :-
  write('tree depth: '),
  read(D),
  test_tree(D).
test_tree(D) :-
  team_rot(T),
  asserta(rot(searching)),
  create_tree(D, state(T,T,[[],[],[]]), _Tree),
  retract(rot(searching)),
  write('tree created'),nl.

test_skipped_tree :-
  team_rot(T),
  asserta(rot(searching)),
  create_tree(2, state(T,T,[[],[],[]]), [], [switch(lapras), switch(snorlax)], _Tree),
  retract(rot(searching)),
  write('tree created'),nl.


test_tree_search :-
  team_rot(T),
  write('tree depth: '),
  read(D),
  team_list(T,Tlist),
  asserta(rot(searching)),
  create_tree(D, state(T,T,[[],[],[]]), Tree),
  retract(rot(searching)),
  write('tree created'),nl,
  %write_tree(Tree, 0), nl,
  rot_create_instance(rot,Tlist,T),
  search_tree(Tree, Moves),
  rot_clear,
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

test_evolutions :-
  evolves_to(P1,P2),
  test_pokemon_name(P1),
  test_pokemon_name(P2),
  fail.
test_evolutions.

test_pokemon_name(Name) :-
  (pokemon(Name,_,_,_) ; write('unknown '),write(Name),nl),!.
