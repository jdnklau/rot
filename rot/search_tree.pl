create_tree(State, 0, tree(State, [])).
create_tree(State, Depth, tree(State, Nodes)) :-
  New_depth is Depth-1,
  create_nodes(State, New_depth, Nodes).

create_nodes(State, Depth, Nodes) :-
  State = state(Player, Rot, _),
  available_moves(Player, Moves_player),
  available_moves(Rot, Moves_rot),
  create_nodes_acc(State, Depth, Nodes, Moves_player, Moves_rot, []).

create_nodes_acc(State, Depth, Nodes, Mps, [Mr|Mrs], Curr_nodes) :-
  create_nodes_by_rot_move(State, Depth, Mr, Mps, New_nodes),
  create_nodes_acc(State, Depth, Nodes, Mps, Mrs, [Mr:New_nodes|Curr_nodes]).
create_nodes_acc(_,_,Nodes, _, [], Nodes).

create_nodes_by_rot_move(_,_,_,[],[]).
create_nodes_by_rot_move(State, Depth, Mr, [Mp|Mps], [Mp:Tree|Nodes]) :-
  process_turn(State, Mp, Mr, New_state),
  create_tree(New_state, Depth, Tree),
  create_nodes_by_rot_move(State, Depth, Mr, Mps, Nodes).


rate(state(Player, Rot, _), (Rating_p, Rating_r)) :-
  rate_team(Player, Rating_p),
  rate_team(Rot, Rating_r).

rate_team(Team, Rating) :-
  rate_team_acc(Team, Rating, 0, 0).
rate_team_acc([Top|Rest], Rating, Num, Curr_p) :-
  New_num is Num+1,
  hp_percent(Top, Next_p),
  New_p is Curr_p+Next_p,
  rate_team_acc(Rest, Rating, New_num, New_p).
rate_team_acc([], Rating, Num, P) :-
  Rating is P / Num.


search_tree(tree(_, Nodes), Moves) :-
  search_nodes(Nodes, Moves, _).

search_nodes(Nodes, Moves, Rating) :-
  search_nodes_acc(Nodes, Moves, Rating, []).

search_nodes_acc([Mr:Player_states|Nodes], Moves, Rating, All_outcomes) :-
  search_player_states(Player_states, Move_player, Rating_player),
  search_nodes_acc(Nodes, Moves, Rating, [(Mr, Move_player, Rating_player)|All_outcomes]).
search_nodes_acc([], Moves, Rating, All_outcomes) :-
  maximize_rot(All_outcomes, Moves, Rating).

search_player_states(Player_states, Move_player, Rating) :-
  search_player_states_acc(Player_states, Move_player, Rating, []).

search_player_states_acc([Mp:Tree|States], Move, Rating, All_outcomes) :-
  rate_tree(Tree, Tree_rating),
  search_player_states_acc(States, Move, Rating, [(Mp, Tree_rating)|All_outcomes]).
search_player_states_acc([], Move, Rating, All_outcomes) :-
  maximize_player(All_outcomes, Move, Rating).

rate_tree(tree(State, []), Rating) :-
  rate(State, Rating).
rate_tree(tree(_, Nodes), Rating) :-
  search_nodes(Nodes, _, Rating).

maximize_player([First|Data], Move, Rating) :-
  maximize_player_acc(Data, Move, Rating, First).
maximize_player_acc([(Top_move, Top_rating)|Data], Move, Rating, (_, Best_rating)) :-
  better_rating(Top_rating, Best_rating, player),
  maximize_player_acc(Data, Move, Rating, (Top_move, Top_rating)).
maximize_player_acc([(_, Top_rating)|Data], Move, Rating, (Best_move, Best_rating)) :-
  \+ better_rating(Top_rating, Best_rating, player),
  maximize_player_acc(Data, Move, Rating, (Best_move, Best_rating)).
maximize_player_acc([], Move, Rating, (Move, Rating)).

maximize_rot([First|Data], Moves, Rating) :-
  maximize_rot_acc(Data, Moves, Rating, First).
maximize_rot_acc([(Top_mr, Top_mp, Top_ra)|Data], Moves, Rating, (_, _, Best_ra)) :-
  better_rating(Top_ra, Best_ra, rot),
  maximize_rot_acc(Data, Moves, Rating, (Top_mr, Top_mp, Top_ra)).
maximize_rot_acc([(_, _, Top_ra)|Data], Moves, Rating, (Best_mr, Best_mp, Best_ra)) :-
  \+ better_rating(Top_ra, Best_ra, rot),
  maximize_rot_acc(Data, Moves, Rating, (Best_mr, Best_mp, Best_ra)).
maximize_rot_acc([], (Move_player, Move_rot), Rating, (Move_rot, Move_player, Rating)).


better_rating((R11, R12), (R21, R22), player) :-
  A is R11-R12,
  B is R21-R22,
  A>B.
better_rating((R11, R12), (R21, R22), rot) :-
  A is R12-R11,
  B is R22-R21,
  A>B.
