%! minmax_prediction_search(+Search_tree, -Actions).
% Searches the given tree for the best actions of both players.
%
% This searches the tree with minmax. As Minmax follows the paranoid assumption
% the found player move is a move countering our best move.
% minmax_prediction turns it around to find the best move against Rot's prediction.
%
% NOTE that this results in an additional 1/9 to 1/4 of computation time to the regular
% minmax.
%
% @arg Search_tree A search tree created with create_tree/3
% @arg Actions A tuple containing the best options for both players
minmax_prediction_search(Tree, (Prediction,Action)) :-
  minmax_search(Tree, (Prediction,_)), % use minmax to predict player
  cut_tree(Tree,Prediction,_,Cut_tree),
  minmax_search(Cut_tree, (Prediction,Action)). % use prediction to select counter move
