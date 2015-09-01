%! rot_update_known_pokemon(+Known_pokemon_data).
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
% @arg Known_pokemon_data The updated known pokemon data to be saved to the knowledge base
rot_update_known_pokemon([Name|Data]) :-
  retractall(rot(knows([Name|_]))), % retract former data
  asserta(rot(knows([Name|Data]))), % assert new data
  retractall(rot(derived([Name|_]))). % retract derived data

%! rot_update_own_pokemon(+Pokemon_data).
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
% @arg Pokemon_data The updated known pokemon data to be saved to the knowledge base
rot_update_own_pokemon([Name|Data]) :-
  retractall(rot(has([Name|_]))), % retract former data
  asserta(rot(has([Name|Data]))). % assert new data

%! rot_access_known_pokemon(+Pokemon_name, -Known_pokemon_data).
% Returns the to Rot known data of the given pokemon.
% Fails if the pokemon is not known at all to Rot.
% @arg Pokemon_name The name of the pokemon
% @arg Known_pokemon_data The known pokemon data of the pokemon.
rot_access_known_pokemon(Name, [Name|Data]) :-
  rot(knows([Name|Data])).

%! rot_access_derived_pokemon(+Pokemon_name, -Derived_pokemon_data).
% Returns the from Rot derived data of the given pokemon.
% Fails if the pokemon is not derived currently.
% @arg Pokemon_name The name of the pokemon
% @arg Derived_pokemon_data The derived pokemon data of the pokemon.
rot_access_derived_pokemon(Name, [Name|Data]) :-
  rot_derive_pokemon(Name), % make sure the pokemon is derived
  rot(derived([Name|Data])).

%! rot_clear_derived_pokemon(+Pokemon_name).
% Clears the derived pokemon data of the given pokemon.
% @arg Pokemon_name The name of the pokemon.
rot_clear_derived_pokemon(Name) :-
  % retract derived data if existent
  retractall(rot(derived([Name|_]))).

%! rot_access_own_pokemon(+Pokemon_name, -Pokemon_data).
% Returns the pokemon data of Rot's given pokemon
% Fails if the pokemon is not in Rot's team.
% @arg Pokemon_name The name of the pokemon
% @arg Pokemon_data The pokemon data of the pokemon.
rot_access_own_pokemon(Name, [Name|Data]) :-
  rot(has([Name|Data])).

%! rot_set_own_active(+Pokemon_name).
% Adds the active pokemon of Rot as known data to the data base.
% @arg Pokemon_name The name of the pokemon
rot_set_own_active(P) :-
  retractall(rot(own_active(_))), % clear old active pokemon
  asserta(rot(own_active(P))).

%! rot_get_own_active(-Active_pokemon_name).
% Returns the active pokemon of Rot.
% @arg Active_pokemon_name The name of the active pokemon
rot_get_own_active(P) :-
  rot(own_active(P)).

%! rot_set_opponent_active(+Pokemon_name).
% Adds the active pokemon of Rot's opponent as known data to the data base.
% @arg Pokemon_name The name of the pokemon
rot_set_opponent_active(P) :-
  retractall(rot(opponent_active(_))), % clear old active pokemon
  asserta(rot(opponent_active(Active))).

%! rot_get_opponent_active(-Active_pokemon_name).
% Returns the active pokemon of Rot's opponent.
% @arg Active_pokemon_name The name of the active pokemon
rot_get_opponent_active(P) :-
  rot(opponent_active(P)).

%! rot_get_own_team(+Team).
% Returns the team data of Rot's team
% @arg Team Rot's team
rot_get_own_team(Team) :-
  rot(own_team(Ps)),
  findall([P|Data], (member(P,Ps),rot(has([P|Data]))), Team_intern),
  % set active pokemon of rot
  rot_get_own_active(Active),
  calculate_switch(Team_intern,Active,Team). % set active pokemon as lead (obviously)

%! rot_get_opponent_team(+Team).
% Returns the team data of Rot's opponent's team
% @arg Team Rot's opponent's team
rot_get_opponent_team(Team) :-
  rot_derive_team(Team_intern),
  % set active pokemon of the opponent
  rot_get_opponent_active(Active),
  calculate_switch(Team_intern,Active,Team). % set active pokemon as lead (obviously)
