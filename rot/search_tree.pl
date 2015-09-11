%! create_tree(+Depth, +Initial_game_state, -Tree).
% Creates a search tree of given depth.
%
% The tree has the given game state as its root and spans edges to subtrees
% revolving from the execution of a move pair (Player_move,Rot_move).
% Those subtrees are generated for all possible matches.
%
% The tree has the following structure:
%     `tree(Root_state, Nodes)`
%
% Nodes is a list, and each Node has the following structure:
%     `Move_rot:Player_Nodes`
% Where Player_nodes is also a list with elements looking like this:
%     `Move_player:Resulting_tree`
% Resulting tree is a tree again, corresponding to a game state resulting from
% the initial game state, after execution of Move_rot and Move_player.
%
% If `Nodes = []` the possessing subtree is a leaf.
%
% This design basically is intended to represent edges with the values
% (Move_rot, Move_player) and also to allow for quickly accessing all
% options the player has to counter a specific move of Rot.
% @arg Depth Indicates how deep the tree should be build.
% @arg Initial_game_state The current state of the game.
% @arg Tree The resulting search tree.
create_tree(0, State, tree(State, [])).
create_tree(Depth, State, tree(State, Nodes)) :-
  New_depth is Depth-1,
  create_nodes(New_depth, State, Nodes).

create_nodes(Depth, State, Nodes) :-
  State = state(Player, Rot, _),
  available_actions(Player, Actions_player),
  available_actions(Rot, Actions_rot),
  create_nodes_acc(Actions_rot, Actions_player, Depth, State, Nodes, []).

create_nodes_acc([Mr|Mrs], Mps, Depth, State, Nodes, Curr_nodes) :-
  create_nodes_by_rot_action(Mps, Mr, Depth, State, New_nodes),
  create_nodes_acc(Mrs, Mps, Depth, State, Nodes, [Mr:New_nodes|Curr_nodes]).
create_nodes_acc([],_,_,_,Nodes,Nodes).

create_nodes_by_rot_action([],_,_,_,[]).
create_nodes_by_rot_action([Mp|Mps], Mr, Depth, State, [Mp:Tree|Nodes]) :-
  process_turn(State, Mp, Mr, New_state),
  create_tree(Depth, New_state, Tree),
  !, % cut to eventually keep call stack clean
  % ^ as only the Tree from the create_tree/3 call is relevant we cut away all
  % choice points occured by the tree creation
  create_nodes_by_rot_action(Mps, Mr, Depth, State, Nodes).

%! search_tree(+Tree, -Actions).
% Searches a given tree for the best possible actions for both players.
%
% The Actions are a tuple (Player_action, Rot_action)
%
% One may partially bind the actions to ignore subtrees in the first layer.
% E.g. if `Player_action = switch(_)` only the subtrees get searched that are reachable
% from the tree root by using Action-tuples where the player's action was a switch
% in the first turn.
% @arg Tree The tree to search.
% @arg Actions The found actions.
search_tree(Tree, Actions) :-
  rot(active_instance(I)), % get active instance
  rot(instance(I, [Algo|_])), % get search algorithm
  search_tree(Tree, Algo, Actions).
search_tree(Tree, minmax, Actions) :-
  minmax_search(Tree, Actions).
