:- dynamic rot/1.

%! read_rot_action(+State, -Action).
% Let's Rot start his heuristics to choose an action for the next turn.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
read_rot_action(State, Action) :-
  rot_choose_action(State, Action).

%! rot_choose_switch(+State, -Switch).
% Let's Rot start his heuristics to choose a switch for the next turn.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
read_rot_switch(State, Switch) :-
  rot_choose_switch(State, Switch).

%! rot_clear.
% Clears all asserted rot/1 predicates
rot_clear :-
  retractall(rot(_)).

%! rot_initialize(+Team_list).
%
% Initializes Rot's system.
%
% The pokemon names in the given list serve to create a first idea of how this pokemon
% could be played. See rot_init_pokemon/1 for more information.
%
% Further more the observed pokemon data gets derived and asserted again by
% rot_derive_pokemon/1
%
% TODO: add how to retrieve the data
% @arg Team_list List of the opponent's pokemon's names
% @see rot_init_team/1
% @see rot_init_pokemon/1
% @see rot_derive_pokemon/1
rot_initialize(Team) :-
  rot_init_team(Team), % initialize team
  rot_derive_team(_). % assert derived data of all pokemon
