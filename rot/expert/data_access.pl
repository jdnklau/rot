%! rot_update_known_pokemon(+Instance, +Known_pokemon_data).
% Updates Rot's known pokemon data for the given pokemon.
%
% The pokemon to be updated is determined by the pokemon name contained in the
% given data.
% The predicate retracts eventually assertet data and then asserts the new data.
%
% This predicate can be used to assert known pokemon data in the first place,
% thus updating the empty data.
%
% As the data gets updated, eventually derived data for the pokemon will be
% retracted from the knowledge base.
%
% The in this way asserted data can be accessed by calling `rot(knows(Known_pokemon_data))`
%
% @arg Instance The identifier for the instance of Rot to work with
% @arg Known_pokemon_data The updated known pokemon data to be saved to the knowledge base
rot_update_known_pokemon(I,[Name|Data]) :-
  retractall(rot(I,knows([Name|_]))), % retract former data
  asserta(rot(I,knows([Name|Data]))), % assert new data
  retractall(rot(I,derived([Name|_]))). % retract derived data

%! rot_update_own_pokemon(+ Instance, +Pokemon_data).
% Updates Rot's own pokemon's data for the given pokemon.
%
% The pokemon to be updated is determined by the pokemon name contained in the
% given data.
% The predicate retracts eventually assertet data and then asserts the new data.
%
% This predicate can be used to assert known pokemon data in the first place,
% thus updating the empty data.
%
% The in this way asserted data can be accessed by calling `rot(has(Pokemon_data))`
%
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_data The updated known pokemon data to be saved to the knowledge base
rot_update_own_pokemon(I, [Name|Data]) :-
  retractall(rot(I, has([Name|_]))), % retract former data
  asserta(rot(I, has([Name|Data]))). % assert new data

%! rot_access_known_pokemon(+Instance, +Pokemon_name, -Known_pokemon_data).
% Returns the to Rot known data of the given pokemon.
% Fails if the pokemon is not known at all to Rot.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon
% @arg Known_pokemon_data The known pokemon data of the pokemon.
rot_access_known_pokemon(I, Name, [Name|Data]) :-
  rot(I, knows([Name|Data])).

%! rot_access_derived_pokemon(+Instance, +Pokemon_name, -Derived_pokemon_data).
% Returns the from Rot derived data of the given pokemon.
% Fails if the pokemon is not derived currently.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon
% @arg Derived_pokemon_data The derived pokemon data of the pokemon.
rot_access_derived_pokemon(I, Name, [Name|Data]) :-
  rot_derive_pokemon(I, Name), % make sure the pokemon is derived
  rot(I, derived([Name|Data])).

%! rot_clear_derived_pokemon(+Instance, +Pokemon_name).
% Clears the derived pokemon data of the given pokemon.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon.
rot_clear_derived_pokemon(I, Name) :-
  % retract derived data if existent
  retractall(rot(I, derived([Name|_]))).

%! rot_access_own_pokemon(+Pokemon_name, -Pokemon_data).
% Returns the pokemon data of Rot's given pokemon
% Fails if the pokemon is not in Rot's team.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon
% @arg Pokemon_data The pokemon data of the pokemon.
rot_access_own_pokemon(I, Name, [Name|Data]) :-
  rot(I, has([Name|Data])).

%! rot_set_own_active(+Pokemon_name).
% Adds the active pokemon of Rot as known data to the data base.
%
% Automatically applies to the active instance of Rot. For accessing another instance
% use rot_set_own_active/2
% @arg Pokemon_name The name of the pokemon
rot_set_own_active(P) :-
  rot(active_instance(I)),
  rot_set_own_active(I,P).

%! rot_set_own_active(+Instance, +Pokemon_name).
% Adds the active pokemon of Rot as known data to the data base.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon
rot_set_own_active(I,P) :-
  retractall(rot(I, own_active(_))), % clear old active pokemon
  asserta(rot(I, own_active(P))).

%! rot_get_own_active(+Instance, -Active_pokemon_name).
% Returns the active pokemon of Rot.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Active_pokemon_name The name of the active pokemon
rot_get_own_active(I,P) :-
  rot(I,own_active(P)).

%! rot_set_opponent_active(+Pokemon_name).
% Adds the active pokemon of Rot's opponent as known data to the data base.
%
% Automatically applies to the active instance of Rot. For accessing another instance
% use rot_set_opponent_active/2
% @arg Pokemon_name The name of the pokemon
rot_set_opponent_active(P) :-
  rot(active_instance(I)),
  rot_set_opponent_active(I,P).

%! rot_set_opponent_active(+Instance, +Pokemon_name).
% Adds the active pokemon of Rot's opponent as known data to the data base.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon
rot_set_opponent_active(I,P) :-
  retractall(rot(I,opponent_active(_))), % clear old active pokemon
  asserta(rot(I,opponent_active(P))).

%! rot_get_opponent_active(+Instance, -Active_pokemon_name).
% Returns the active pokemon of Rot's opponent.
% @arg Instance The identifier for the instance of Rot to work with
% @arg Active_pokemon_name The name of the active pokemon
rot_get_opponent_active(I,P) :-
  rot(I,opponent_active(P)).

%! rot_get_own_team(+Instance, +Team).
% Returns the team data of Rot's team
% @arg Instance The identifier for the instance of Rot to work with
% @arg Team Rot's team
rot_get_own_team(I,Team) :-
  rot(I,own_team(Ps)),
  findall([P|Data], (member(P,Ps),rot(I,has([P|Data]))), Team_intern),
  % set active pokemon of rot
  rot_get_own_active(I,Active),
  calculate_switch(Team_intern,Active,Team). % set active pokemon as lead (obviously)

%! rot_get_opponent_team(+Instance, +Team).
% Returns the team data of Rot's opponent's team
% @arg Instance The identifier for the instance of Rot to work with
% @arg Team Rot's opponent's team
rot_get_opponent_team(I,Team) :-
  rot_derive_team(I,Team_intern),
  % set active pokemon of the opponent
  rot_get_opponent_active(I,Active),
  calculate_switch(Team_intern,Active,Team). % set active pokemon as lead (obviously)

%! rot_set_last_actions(+Player, +Action, +Action_opponent).
% Asserts the last actions the battling players executed.
%
% To access uses rot_last_actions/2.
% @arg Player Either `player` or `rot`
% @arg Action The action executed by the given player
% @arg Action_opponent The action executed by the given player's opponent
rot_set_last_actions(rot,A1,A2) :-
  rot_set_last_actions(player,A2,A1).
rot_set_last_actions(player,A1,A2) :-
  rot(active_instance(I)),
  retractall(rot(I, last_actions(_,_))),
  asserta(rot(I, last_actions(A1,A2))).
