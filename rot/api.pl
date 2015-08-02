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

%! rot_clear_derived_pokemon(+Pokemon_name).
% Clears the derived pokemon data of the given pokemon.
% @arg Pokemon_name The name of the pokemon.
rot_clear_derived_pokemon(Name) :-
  % retract derived data if existent
  retractall(rot(derived([Name|_]))).

%! rot_initialize(+Player_team_list, +Rot_team_data).
%
% Initializes Rot's system.
%
% The pokemon names in the given player's team list serve to create a first idea of how this pokemon
% could be played. See rot_init_pokemon/1 for more information.
%
% Further more the observed pokemon data gets derived and asserted again by
% rot_derive_pokemon/1
%
% The given team data for Rot's team are assumed to be fully setup.
%
% TODO: add how to retrieve the data
% @arg Player_team_list List of the opponent's pokemon's names
% @arg Rot_team_data The team data of Rot's team
% @see rot_init_team/1
% @see rot_init_pokemon/1
% @see rot_derive_pokemon/1
rot_initialize(Team, Team_rot) :-
  rot_init_team(Team), % initialize team
  rot_derive_team(_), % assert derived data of all pokemon
  rot_init_self(Team_rot). % assert own team data

%! rot_known_pokemon_data(+Pokemon_name, -Known_pokemon_data).
% Returns the to Rot known data of the given pokemon.
% Fails if the pokemon is not known at all to Rot.
% @arg Pokemon_name The name of the pokemon
% @arg Known_pokemon_data The known pokemon data of the pokemon.
rot_known_pokemon_data(Name, [Name|Data]) :-
  rot(knows([Name|Data])).

%! rot_derived_pokemon_data(+Pokemon_name, -Derived_pokemon_data).
% Returns the from Rot derived data of the given pokemon.
% Fails if the pokemon is not derived currently.
% @arg Pokemon_name The name of the pokemon
% @arg Derived_pokemon_data The derived pokemon data of the pokemon.
rot_derived_pokemon_data(Name, [Name|Data]) :-
  rot(derived([Name|Data])).

%! rot_evaluate_message_frame(+Message_frame).
%
% Let's Rot evaluate a message frame to collect information about the battle and thus
% constructing/updating the known pokemon data of the player's team pokemon.
%
% @arg Message_frame The message frame to be evaluated
rot_evaluate_message_frame(_) :-
  % do nothing as rot is in its heuristic
  rot(searching).
rot_evaluate_message_frame(Frame) :-
  % evaluate frame
  \+ rot(searching),
  get_message_frame_list(Frame, List), % get list of messages
  message_frame_meta_data(Frame, Who, _, A1, A2), % get meta data
  rot_evaluate_message_list(Who, A1, A2, List).
