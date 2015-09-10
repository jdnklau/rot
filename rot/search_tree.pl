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

search_tree(Tree, Action) :-
  rot(active_instance(I)), % get active instance
  rot(instance(I, [Algo|_])), % get search algorithm
  search_tree(Tree, Algo, Action).
search_tree(Tree, minmax, Action) :-
  minmax_search(Tree, Action).
