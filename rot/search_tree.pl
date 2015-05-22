create_tree(State, Depth, Tree) :-
  create_tree(State, Depth, nil, nil, Tree).

create_tree(State, 0, M1, M2, tree(State, M1, M2, [])).
create_tree(State, _, M1, M2, tree(State, M1, M2, [])) :-
  game_over(State).
create_tree(State, Depth, M1, M2, tree(State, M1, M2, Subtree)) :-
  Depth > 0,
  New_depth is Depth - 1,
  available_move_pairs(State, Pairs),

create_subtree(_, [], _, []).
create_subtree(State, [(M1, M2)|Pairs], Depth, [New_branch|Branches]) :-
  process_round(State, M1, M2, New_state),
  create_tree(New_state, Depth, M1, M2, New_branch),
  create_subtree(State, Pairs, Depth, Branches).


available_move_pairs(state(T1, T2, _), Pairs) :-
  available_moves(T1, M1),
  available_moves(T2, M2),
  available_move_pairs_acc(M1, M2, M2, Pairs).
available_move_pairs_acc([], _, _, []).
available_move_pairs_acc([_|M1s], [], M2s, Pairs) :-
  available_move_pairs_acc(M1s, M2s, M2s, Pairs).
available_move_pairs_acc([M1|M1s], [M2|M2s], M2s_safed, [(M1,M2)|Pairs]) :-
  available_move_pairs_acc([M1|M1s], M2s, M2s_safed, Pairs).

