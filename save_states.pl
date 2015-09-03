%! set_save_state(+Game_state).
% Creates a backup of the current state of the game.
%
% The current state of the game and all data sasserted by Rot are saved to the
% file _save_.
%
% The data can be reloaded by calling load_save_state/1
% @arg Game_state The current state of the game to be saved.
set_save_state(State) :-
  % base case: rot is not searching
  \+ rot(searching),
  open('save', write, S), % open/create save file
  write(S,State),write(S,'.'),nl(S), % add current game state
  set_save_state_rot(S),
  close(S).
set_save_state(_) :-
  % do nothing if rot searches
  rot(searching).

set_save_state_rot(S) :-
  rot(X), % get rot/1 data
  write(S,rot(X)),write(S,'.'),nl(S), % write data to file
  fail. % failure driven loop
set_save_state_rot(_). % no more rot/1 data to write.

%! load_save_state(-Game_state).
% Reads the saved data from the _save_ file.
%
% Returns the saved game state and asserts all data previously asserted by Rot to the
% knowledge base. It is advised to call clear_rot/0 before calling load_save_state/1.
%
% To save a game state in the first place use set_save_state/1.
% @arg Game_state The saved state of the game.
load_save_state(State) :-
  open('save', read, S), % open save file
  read(S,State), % read game state
  load_save_state_rot(S), % read rot data
  close(S).

load_save_state_rot(S) :-
  read(S,rot(X)), % read data
  asserta(rot(X)), % assert data
  load_save_state_rot(S). % read next data
load_save_state_rot(_). % no more rot/1 data to read
