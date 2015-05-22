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

test_available_move_pairs :-
  team_1(T),
  available_move_pairs(state(T, T, _), Pairs),
  write_pairs(Pairs).

write_pairs([]).
write_pairs([Pair|Pairs]) :-
  write(Pair), nl,
  write_pairs(Pairs).

test_search_tree :-
  team_1(T),
  write('tree depth: '),
  read(D),
  asserta(rot(searching)),
  create_tree(state(T,T,[[],[],[]]), D, Tree),
  retract(rot(searching)),
  write_tree(Tree, Outs),
  write(different_states_total:Outs), !.

write_tree(Tree, Outs) :-
  write_tree(Tree, 0, 0, Outs).

write_tree(tree(state(T1, T2, _), M1, M2, Subtrees), I, Oin, Oout) :-
  Oinside is Oin+1,
  tab(I), write(#), write((M1, M2)), nl,
  tab(I), write_tree_team(T1), nl,
  tab(I), write_tree_team(T2), nl,
  II is I+4,
  write_tree_subtrees(Subtrees, II, Oinside, Oout).

write_tree_team([]).
write_tree_team([Lead|Rest]) :-
  hp_percent(Lead, P),
  Lead = [Name|_],
  write(Name), write(' at '), ui_display_percent(P),
  ui_display_primary_condition(Lead), write('- '),
  write_tree_team(Rest).

write_tree_subtrees([],_, O, O).
write_tree_subtrees([St|Sts], I, Oin, Oout) :-
  write_tree(St, I, Oin, Oinside),
  write_tree_subtrees(Sts, I, Oinside, Oout).
