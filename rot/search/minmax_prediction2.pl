%! minmax_prediction2_search(+Search_tree, -Actions).
% Searches the given tree for the best actions of both players.
%
% This searches the tree with minmax. As Minmax follows the paranoid assumption
% the found player move is a move countering our best move.
% minmax_prediction turns it around to find the best move against Rot's prediction.
%
% Contrary to minmax_prediction2_search/2 this predicate does not cut
% the state in the root of the tree, but creates a new search tree of the swapped state
% of it.
%
% This is as - like aforementioned - the underlying minmax uses the paranoid assumption,
% but we now try to assume that the opponent gets fully predicted.
% Thus this algorithm tries to invert the paranoid assumption and assumes in its
% new search tree that it knows the opponents moves beforehand.
%
% NOTE that this comes with a tradeof of computation time:
% As this algorithm creates a second search tree it takes double the time for tree creation.
% As it double computates tree search (though the second tree is cut) it additionally takes
% 1/10 to 1/4 of the time to search the tree.
%
% The computation times above compare with the minmax_search/2 predicate.
%
% @arg Search_tree A search tree created with create_tree/3
% @arg Actions A tuple containing the best options for both players
minmax_prediction2_search(Tree, (Prediction,Action)) :-
  minmax_search(Tree, (Prediction,_)), % use minmax to predict player
  % manipulate tree
  Tree = tree(State,_),
  swap_attacker_state(State,Swap),
  create_tree(2,Swap,New_tree),
  minmax_search(New_tree, (Action,Prediction)). % use prediction to select counter move
