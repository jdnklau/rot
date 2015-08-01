%! rot_evaluate_message_list(+Player, +Active_pokemon_player, +Active_pokemon_opponent, +Message_list).
%
% Let's rot evaluate a list of messages occured in battle.
% By this rot collects his informaion about the player's team pokemon.
%
% The list of messages can be retrieved from a message frame by get_message_frame_list/2.
%
% The 1st, 2nd, and 3rd arguments are part of the message frame meta data,
% and thus are retrievable by message_frame_meta_data/5.
%
% @arg Player The corresponding player; either `rot` or `player`
% @arg Active_pokemon_player The active pokemon's name of the given player
% @arg Active_pokemon_opponent The active pokemon's name of the given player's opponent
% @arg Message_list List of occured messages.
rot_evaluate_message_list(_,_,_,[]). % base case: empty list, nothing to evaluate
%% evaluate the player
rot_evaluate_message_list(player, A1, A2, [move(Move)|List]) :-
  % observing a move of the opponent's pokemon
  rot_update_moves(A1,Move), % add the move to the known moves
%  rot_evaluate_player_move(Move, A1, A2, List, Remaining_list), % eval this move
  rot_evaluate_message_list(player, A1, A2, List). % eval rest
rot_evaluate_message_list(Who,A1,A2,[_|List]) :-
  % skip messages that do not get evaluated
  rot_evaluate_message_list(Who,A1,A2,List).
