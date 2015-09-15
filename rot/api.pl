:- dynamic rot/1.
:- dynamic rot/2.

%! read_rot_action(+State, -Action).
% Lets Rot start his heuristics to choose an action for the next turn.
%
% As of current implementation Rot uses it's own derives game state instead of
% using the given one
% @arg Game_state The current state of the game - *ignored*
% @arg Action The action rot has choosen
read_rot_action(_, Action) :-
  rot_get_game_state(State),
  rot_choose_action(State, Action).

%! rot_choose_switch(+State, -Switch).
% Lets Rot start his heuristics to choose a switch for the next turn.
% @arg Game_state The current state of the game
% @arg Action The action rot has choosen
read_rot_switch(State, Switch) :-
  rot_choose_switch(State, Switch).

%! rot_clear.
% Clears all asserted rot/1 and rot/2 predicates
rot_clear :-
  retractall(rot(_)),
  retractall(rot(_,_)).

%! rot_clear(+Instance).
% Clears all asserted data corresponding to a specific instance of Rot.
% @arg Instance The identifier for the instance of Rot to clear.
rot_clear(I) :-
  retractall(rot(instance(I, _))),
  retractall(rot(I,_)).

%! rot_create_instance(+Identifier, +Player_team_list, +Rot_team_data).
%
% Initializes a new instance of Rot's system.
% This instance will be set as new active instance.
%
% This predicate just calls rot_create_instance/4 with a default search algorithm.
% At this point the default algorithm is `minmax`.
%
% Please see rot_create_instance/4 for full information.
%
% @arg Identifier Identifies the created instance, allowing to access it easily
% @arg Player_team_list List of the opponent's pokemon's names
% @arg Rot_team_data The team data of Rot's team
% @see rot_init_team/1
% @see rot_init_pokemon/1
% @see rot_derive_pokemon/1
% @see rot_create_instance/4
rot_create_instance(I, Team_player, Team_rot) :-
  % NOTE: if the default algorithm gets changed, please note it in the PlDoc comment
  rot_create_instance(I, minmax, Team_player, Team_rot).

%! rot_create_instance(+Identifier, +Search_algorithm, +Player_team_list, +Rot_team_data).
%
% Initializes a new instance of Rot's system.
% This instance will be set as new active instance.
%
% The given search algorithm is used by read_rot_action/2 to search the action
% with the best possible outcome calculated.
% It may be one of the following:
%   * `minmax`: A basic minmax algorithm
%   * more to be added
%
% The pokemon names in the given player's team list serve to create a first idea of how this pokemon
% could be played. See rot_init_pokemon/1 for more information.
%
% Further more the observed pokemon data gets derived and asserted again by
% rot_derive_pokemon/1
%
% The given team data for Rot's team are assumed to be fully setup.
%
% To access the data later on, there are the following possibilities:
%   1. rot_known_pokemon_data/2 to access the known data of a specific pokemon of Rot's opponent
%   2. rot_derived_pokemon_data/2 to access the derived data of a specific pokemon of Rot's opponent
%   3. rot_has_pokemon_data/2 to access a specific pokemon of Rot
%   4. rot_get_pokemon_data/3 to access dynamically a pokemon from either team
%   5. *most important:* rot_get_game_state/1 to access the current state of the game as Rot thinks it is
% @arg Identifier Identifies the created instance, allowing to access it easily
% @arg Search_algorithm Atom to specify what algorithm should be used for Rot's tree search
% @arg Player_team_list List of the opponent's pokemon's names
% @arg Rot_team_data The team data of Rot's team
% @see rot_init_team/1
% @see rot_init_pokemon/1
% @see rot_derive_pokemon/1
rot_create_instance(I, Algo, Team_player, Team_rot) :-
  rot_clear(I), % clear eventually remaining asserts
  asserta(rot(instance(I, [Algo]))), % assert given instance as one of the instances created
  rot_set_active_instance(I), % set new instance as active one
  rot_init_opponent(I,Team_player), % initialize team
  rot_derive_team(I,_), % assert derived data of all pokemon
  rot_init_self(I,Team_rot). % assert own team data

%! rot_set_active_instance(+Instance).
% Sets the active instance of Rot.
%
% The active instance ist the instance Rot works with.
% @arg Instance The identifier of the instance to set as active one.
rot_set_active_instance(I) :-
  retractall(rot(active_instance(_))),
  asserta(rot(active_instance(I))).

%! rot_get_game_state(-Game_state).
% Returns Rot's assumed game state.
% @arg Game_state The state of the game rot assumes.
rot_get_game_state(state(Player,Rot,[[],[],[]])) :-
  rot(active_instance(I)), % get active instance of Rot
  % get player team
  rot_get_opponent_team(I,Player),
  % get rot team
  rot_get_own_team(I,Rot).


%! rot_known_pokemon_data(+Pokemon_name, -Known_pokemon_data).
% Returns the to Rot known data of the given pokemon.
% Fails if the pokemon is not known at all to Rot.
% @arg Pokemon_name The name of the pokemon
% @arg Known_pokemon_data The known pokemon data of the pokemon.
rot_known_pokemon_data(Name, Data) :-
  rot(active_instance(I)), % get active instance of Rot
  rot_access_known_pokemon(I,Name, Data).

%! rot_derived_pokemon_data(+Pokemon_name, -Derived_pokemon_data).
% Returns the from Rot derived data of the given pokemon.
% @arg Pokemon_name The name of the pokemon
% @arg Derived_pokemon_data The derived pokemon data of the pokemon.
rot_derived_pokemon_data(Name, Data) :-
  rot(active_instance(I)), % get active instance of Rot
  rot_access_derived_pokemon(I,Name, Data).

%! rot_has_pokemon_data(+Pokemon_name, -Pokemon_data).
% Returns the pokemon data of Rot's given pokemon
% Fails if the pokemon is not in Rot's team.
% @arg Pokemon_name The name of the pokemon
% @arg Pokemon_data The pokemon data of the pokemon.
rot_has_pokemon_data(Name, Data) :-
  rot(active_instance(I)), % get active instance of Rot
  rot_access_own_pokemon(I,Name, Data).

%! rot_get_pokemon_data(+Player, +Pokemon_name, -Pokemon_data).
% Returns the pokemon data of the given player's pokemon.
%
% In case the given player is rot, this is the same as calling rot_has_pokemon_data/2.
% If it is the player (Rot's opponent) it is the same as calling rot_known_pokemon_data/2.
%
% @arg Player The player owning the given pokemon, either `rot` or `player`
% @arg Pokemon_name The name of the pokemon
% @arg Pokemon_data The pokemon data of the pokemon.
rot_get_pokemon_data(rot,Name,Data) :-
  rot_has_pokemon_data(Name,Data).
rot_get_pokemon_data(player,Name,Data) :-
  rot_known_pokemon_data(Name,Data).

%! rot_set_pokemon_data(+Player, +Pokemon_data).
% Sets the asserted pokemon data to the given data. The former data will be retracted.
%
% The pokemon data to be overriden is determined by the pokemon name contained in the new, given data.
% @arg Player The player owning the given pokemon, either `rot` or `player`
% @arg Pokemon_data The pokemon data of the pokemon.
rot_set_pokemon_data(rot,Data) :-
  rot(active_instance(I)), % get active instance of Rot
  rot_update_own_pokemon(I,Data).
rot_set_pokemon_data(player,Data) :-
  rot(active_instance(I)), % get active instance of Rot
  rot_update_known_pokemon(I,Data).

%! rot_transmit_message_frames(+First_frame, +Second_frame).
% Transmits two message frames to Rot, so it can evaluate the outcomes of an action.
%
% This is to be used for message frames semantically fitting together,
% e.g. the choosen moves of both players or both end of turn results.
%
% If you only got one message frame and have no second to pair it up with, use rot_transmit_message_frame/1
% @arg First_frame The first frame occurring
% @arg Second_frame The second frame occurring
rot_transmit_message_frames(_,_) :-
  % do nothing when in Rot's search algorithm
  rot(searching),!.
rot_transmit_message_frames(F1,F2) :-
  % only refering to the evaluating predicate to keep the api file clean and easier to maintain
  rot_evaluate_message_frames(F1,F2),
  !. % cut to eventually keep call stack clean

%! rot_transmit_message_frame(+Frame).
% Transmits a message frame to Rot, so it can evaluate the outcomes of an action.
%
% This is to be used for a single message frame.
% If you got two frames that semantically fit together, use rot_transmit_message_frames/2 instead.
%
% @arg Frame The message frame to be transmitted
rot_transmit_message_frame(_) :-
  % do nothing when in Rot's search algorithm
  rot(searching),!.
rot_transmit_message_frame(F1) :-
  % only refering to the evaluating predicate to keep the api file clean and easier to maintain
  rot_evaluate_message_frame(F1),
  !. % cut to eventually keep call stack clean

%! rot_last_actions(-Action_player, -Action_rot).
% Returns the last actions of both players Rot tracked.
%
% @arg Action_player The last action Rot's opponent executed
% @arg Action_rot The last action Rot executed
rot_last_actions(A1,A2) :-
  rot(active_instance(I)),
  rot(I, last_actions(A1,A2)).
