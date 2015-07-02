create_tree(State, 0, tree(State, [])).
create_tree(State, Depth, tree(State, Nodes)) :-
  New_depth is Depth-1,
  create_nodes(State, New_depth, Nodes).

create_nodes(State, Depth, Nodes) :-
  State = state(Player, Rot, _),
  available_actions(Player, Actions_player),
  available_actions(Rot, Actions_rot),
  create_nodes_acc(State, Depth, Nodes, Actions_player, Actions_rot, []).

create_nodes_acc(State, Depth, Nodes, Mps, [Mr|Mrs], Curr_nodes) :-
  create_nodes_by_rot_action(State, Depth, Mr, Mps, New_nodes),
  create_nodes_acc(State, Depth, Nodes, Mps, Mrs, [Mr:New_nodes|Curr_nodes]).
create_nodes_acc(_,_,Nodes, _, [], Nodes).

create_nodes_by_rot_action(_,_,_,[],[]).
create_nodes_by_rot_action(State, Depth, Mr, [Mp|Mps], [Mp:Tree|Nodes]) :-
  process_turn(State, Mp, Mr, New_state),
  create_tree(New_state, Depth, Tree),
  create_nodes_by_rot_action(State, Depth, Mr, Mps, Nodes).


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


search_tree(tree(_, Nodes), Actions) :-
  search_nodes(Nodes, Actions, _).

search_nodes(Nodes, Actions, Rating) :-
  search_nodes_acc(Nodes, Actions, Rating, []).

search_nodes_acc([Mr:Player_states|Nodes], Actions, Rating, All_outcomes) :-
  search_player_states(Player_states, Action_player, Rating_player),
  search_nodes_acc(Nodes, Actions, Rating, [(Mr, Action_player, Rating_player)|All_outcomes]).
search_nodes_acc([], Actions, Rating, All_outcomes) :-
  maximize_rot(All_outcomes, Actions, Rating).

search_player_states(Player_states, Action_player, Rating) :-
  search_player_states_acc(Player_states, Action_player, Rating, []).

search_player_states_acc([Mp:Tree|States], Action, Rating, All_outcomes) :-
  rate_tree(Tree, Tree_rating),
  search_player_states_acc(States, Action, Rating, [(Mp, Tree_rating)|All_outcomes]).
search_player_states_acc([], Action, Rating, All_outcomes) :-
  maximize_player(All_outcomes, Action, Rating).

rate_tree(tree(State, []), Rating) :-
  rate(State, Rating).
rate_tree(tree(_, Nodes), Rating) :-
  search_nodes(Nodes, _, Rating).

maximize_player([First|Data], Action, Rating) :-
  maximize_player_acc(Data, Action, Rating, First).
maximize_player_acc([(Top_action, Top_rating)|Data], Action, Rating, (_, Best_rating)) :-
  better_rating(Top_rating, Best_rating, player),
  maximize_player_acc(Data, Action, Rating, (Top_action, Top_rating)).
maximize_player_acc([(_, Top_rating)|Data], Action, Rating, (Best_action, Best_rating)) :-
  \+ better_rating(Top_rating, Best_rating, player),
  maximize_player_acc(Data, Action, Rating, (Best_action, Best_rating)).
maximize_player_acc([], Action, Rating, (Action, Rating)).

maximize_rot([First|Data], Actions, Rating) :-
  maximize_rot_acc(Data, Actions, Rating, First).
maximize_rot_acc([(Top_mr, Top_mp, Top_ra)|Data], Actions, Rating, (_, _, Best_ra)) :-
  better_rating(Top_ra, Best_ra, rot),
  maximize_rot_acc(Data, Actions, Rating, (Top_mr, Top_mp, Top_ra)).
maximize_rot_acc([(_, _, Top_ra)|Data], Actions, Rating, (Best_mr, Best_mp, Best_ra)) :-
  \+ better_rating(Top_ra, Best_ra, rot),
  maximize_rot_acc(Data, Actions, Rating, (Best_mr, Best_mp, Best_ra)).
maximize_rot_acc([], (Action_player, Action_rot), Rating, (Action_rot, Action_player, Rating)).


better_rating((R11, R12), (R21, R22), player) :-
  A is R11-R12,
  B is R21-R22,
  A>B.
better_rating((R11, R12), (R21, R22), rot) :-
  A is R12-R11,
  B is R22-R21,
  A>B.
