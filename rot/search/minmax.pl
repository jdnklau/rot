%! minmax_search(+Search_tree, -Actions).
% Searches the given tree for the best actions of both players.
%
% This utilizes the minmax search algorithm.
%
% The Actions-tuple has the form (Best_player_action, Best_rot_action)
%
% @arg Search_tree A search tree created with create_tree/3
% @arg Actions A tuple containing the best options for both players
minmax_search(tree(_, Nodes), Actions) :-
  minmax_search_nodes(Nodes, Actions, _).

minmax_search_nodes(Nodes, Actions, Rating) :-
  minmax_search_nodes_acc(Nodes, Actions, Rating, []).

minmax_search_nodes_acc([Mr:Player_states|Nodes], Actions, Rating, All_outcomes) :-
  minmax_search_player_states(Player_states, Action_player, Rating_player),
  minmax_search_nodes_acc(Nodes, Actions, Rating, [(Mr, Action_player, Rating_player)|All_outcomes]).
minmax_search_nodes_acc([], Actions, Rating, All_outcomes) :-
  minmax_maximize_rot(All_outcomes, Actions, Rating).

minmax_search_player_states(Player_states, Action_player, Rating) :-
  minmax_search_player_states_acc(Player_states, Action_player, Rating, []).

minmax_search_player_states_acc([Mp:Tree|States], Action, Rating, All_outcomes) :-
  minmax_rate_tree(Tree, Tree_rating),
  minmax_search_player_states_acc(States, Action, Rating, [(Mp, Tree_rating)|All_outcomes]).
minmax_search_player_states_acc([], Action, Rating, All_outcomes) :-
  minmax_maximize_player(All_outcomes, Action, Rating).

minmax_rate_tree(tree(State, []), Rating) :-
  rate(State, Rating).
minmax_rate_tree(tree(_, Nodes), Rating) :-
  minmax_search_nodes(Nodes, _, Rating).

minmax_maximize_player([First|Data], Action, Rating) :-
  minmax_maximize_player_acc(Data, Action, Rating, First).
minmax_maximize_player_acc([(Top_action, Top_rating)|Data], Action, Rating, (_, Best_rating)) :-
  better_rating(Top_rating, Best_rating, player),
  minmax_maximize_player_acc(Data, Action, Rating, (Top_action, Top_rating)).
minmax_maximize_player_acc([(_, Top_rating)|Data], Action, Rating, (Best_action, Best_rating)) :-
  \+ better_rating(Top_rating, Best_rating, player),
  minmax_maximize_player_acc(Data, Action, Rating, (Best_action, Best_rating)).
minmax_maximize_player_acc([], Action, Rating, (Action, Rating)).

minmax_maximize_rot([First|Data], Actions, Rating) :-
  minmax_maximize_rot_acc(Data, Actions, Rating, First).
minmax_maximize_rot_acc([(Top_mr, Top_mp, Top_ra)|Data], Actions, Rating, (_, _, Best_ra)) :-
  better_rating(Top_ra, Best_ra, rot),
  minmax_maximize_rot_acc(Data, Actions, Rating, (Top_mr, Top_mp, Top_ra)).
minmax_maximize_rot_acc([(_, _, Top_ra)|Data], Actions, Rating, (Best_mr, Best_mp, Best_ra)) :-
  \+ better_rating(Top_ra, Best_ra, rot),
  minmax_maximize_rot_acc(Data, Actions, Rating, (Best_mr, Best_mp, Best_ra)).
minmax_maximize_rot_acc([], (Action_player, Action_rot), Rating, (Action_rot, Action_player, Rating)).
