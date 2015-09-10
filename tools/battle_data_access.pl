%! opponent(+Player_1, +Player_2).
%! opponent(+Player_1, -Player_2).
%! opponent(-Player_1, +Player_2).
%
% True if the given two players are the opposing players _player_ and _rot_
%
% @arg Player_1 Either `player` or `rot`
% @arg Player_2 Either `rot` or `player`
opponent(player, rot).
opponent(rot, player).

%! team_list(+Team, -Team_list).
% Returns a list containing all the pokemon's names of a given team
% @arg Team The pokemon team
% @arg Team_list A list of the team pokemon's names
team_list([], []). % base case: empty team
team_list([P|Ps], [N|Ns]) :-
  % get names from team pokemon
  pokemon_name(P,N),
  team_list(Ps,Ns).

%! game_over(+Game_state).
%
% True if the game is over and either rot or the player has won.
% Favours rot if both teams have fainted completely
%
% @arg Game_state The current state of the game
game_over(state(Player, _, _)) :-
  team_completely_fainted(Player),
  ui_display_win(rot),
  log_win(rot).
game_over(state(_, Rot, _)) :-
  team_completely_fainted(Rot),
  ui_display_win(player),
  log_win(player).

%! attacker_fainted(Attacker_state)
%
% True if the active pokemon of the attacking player has fainted
%
% @arg Attacker_state The current game state from the attackers point of view
attacker_fainted(state([Lead|_], _, _)) :-
  fainted(Lead).

%! attacker_team_fainted(Attacker_state)
%
% True if the attacking player's team has fainted completely
%
% @arg Attacker_state The current game state from the attackers point of view
attacker_team_fainted(state(Team, _, _)) :-
  team_completely_fainted(Team).

%! target_fainted(Attacker_state)
%
% True if the active pokemon of the defending player has fainted
%
% @arg Attacker_state The current game state from the attackers point of view
target_fainted(state(_, [Lead|_], _)) :-
  fainted(Lead).

%! target_team_fainted(Attacker_state)
%
% True if the target player's team has fainted completely
%
% @arg Attacker_state The current game state from the attackers point of view
target_team_fainted(state(_, Team, _)) :-
  team_completely_fainted(Team).

%! team_completely_fainted(+Team)
%
% True if there is no unfainted pokemon in the given team left
%
% @arg Team The team to be checked
team_completely_fainted([]). % empty teams are completely defeated
team_completely_fainted([Pokemon|Rest]) :-
  fainted(Pokemon),
  team_completely_fainted(Rest). % check rest

%! faster(Priority_1, Priority_2)
%
% True if the first given priority data hav a greater priority as the second one
%
% @arg Priority_1 Priority tuple of the form (move priority, users speed stat)
% @arg Priority_2 Priority tuple of the form (move priority, users speed stat)
faster((Prio_a,_),(Prio_b,_)) :-
  Prio_a > Prio_b.
faster((Prio,Speed_a), (Prio,Speed_b)) :-
  Speed_a > Speed_b.
faster(Prio_data, Prio_data) :-
  random(0,2,0). % as priorities are the same flip a coin to decide who is faster

%! type_effectiveness(+Attacking_type, +Defending_type_list, -Effectiveness)
%
% Gets the effectiveness factor of the attacking type against the defending types
%
% @arg Attacking_type The type of the offensive move
% @arg Defending_type_list The type list of the defending pokemon
% @arg Effectiveness The numeric factor to be multiplied in the damage calculation
type_effectiveness(A, [T], E) :-
  typing(A, T, E).
type_effectiveness(A, [T], 1) :-
  \+ typing(A, T, _). % as no special effectiveness exists it has a regular effectiveness of 1
type_effectiveness(A, [T1, T2], E) :-
  type_effectiveness(A, [T1], E1),
  type_effectiveness(A, [T2], E2),
  E is E1*E2.

%! very_effective_hit(+Pokemon, +Move_type).
% True if the given pokemon gets hit very effective by a move of the given type.
very_effective_hit(Pokemon, Type) :-
  types(Pokemon, Types),
  type_effectiveness(Type, Types, E),
  E > 1.

%! not_very_effective_hit(+Pokemon, +Move_type).
% True if the given pokemon gets hit not very effective by a move of the given type.
not_very_effective_hit(Pokemon, Type) :-
  types(Pokemon, Types),
  type_effectiveness(Type, Types, E),
  E < 1.

%! stab(+Pokemon_data, +Move_type).
%! stab(+Pokemon_data, -Move_type).
%
% True if the given pokemon has STAB for the given move type.
% May be used to return move types the pokemon has STAB for.
%
% To calculate the STAB factor, use calculate_stab/3 instead.
%
% @arg Pokemon The pokemon data of the pokemon in question.
% @arg Move_type The elemental type of the move
% @see calculate_stab/3
stab(Pokemon, Type) :-
  types(Pokemon, Types),
  member(Type,Types).

%! move_has_effect(+Move, +Target_pokemon).
% True if the given move has effect on the target pokemon.
% @arg Move The move in question
% @arg Target_pokemon The pokemon data of the pokemon being targeted by the move.
move_has_effect(Move, Target) :-
  % move is effective by type
  move(Move,T,_,_,_,_,_,_,_), % get type
  calculate_type_effectiveness(T,Target,TE),
  TE > 0.
% TODO: implement more clauses
% Missing is for example a check if a move only inflicty a primary status condition
% and if so, this condition is inflictable.

%! translate_attacker_state(+Game_state, +Attacker, -Attacker_state).
%! translate_attacker_state(+Attacker_state, +Attacker, -Game_state).
%! translate_attacker_state(-Game_state, +Attacker, +Attacker_state).
%! translate_attacker_state(-Attacker_state, +Attacker, +Game_state).
%
% Translates a valid game state to a valid attacker state.
% In the attacker state the attacking player is guaranteed to be the first player mentioned in
% the state information. For example Rot's attacker stater lists him fist instead of second
% as it would be in a regular game state
% To translate the attacker state back to a game state the predicate can be called again
% with the very same attacker given
%
% @arg Game_state The current state of the game
% @arg Attacker Either `player` or `rot`
% @arg Attacker_state The current state of the game from the attackers point of view
translate_attacker_state(state(A, T, Field), player, state(A, T, Field)).
translate_attacker_state(state(T, A, [Field_t, Field_a, Field_g]), rot, state(A, T, [Field_a, Field_t, Field_g])).

%! swap_attacker_state(+Attacker_state, -Swapped_state).
% Swaps attacker and target teams in the attacker game state.
% Same as `translate_attacker_state(Attacker_state, rot, Swapped_state)`.
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Swapped_state The current state of the game from the defender's point of view
% @see translate_attacker_state/3
swap_attacker_state(State, Swap) :-
  translate_attacker_state(State, rot, Swap).

%! stat_stage_factor(+Stat_stage, -Factor)
%
% Gives the multiplier corresponding to the given stat stage.
%
% The factor is given in the format Numerator/Denominator, allowing one to call
% `stat_stage_factor(Stage, N/D)`.
% This is as some of these factors are fractions, but some calculations demand pure integers.
%
% @arg Stat_stage An integer from -6 to 6
% @arg Factor The factor depending on the stat increase or decrease
stat_stage_factor(6, 4/1). % 4
stat_stage_factor(5, 7/2). % 3.5
stat_stage_factor(4, 3/1). % 3
stat_stage_factor(3, 5/2). % 2.5
stat_stage_factor(2, 2/1). % 2
stat_stage_factor(1, 3/2). % 1.5
stat_stage_factor(0, 1/1). % 1
stat_stage_factor(-1, 2/3). % 0.666..
stat_stage_factor(-2, 1/2). % 0.5
stat_stage_factor(-3, 2/5). % 0.4
stat_stage_factor(-4, 1/3). % 0.333..
stat_stage_factor(-5, 2/7). % 0.286..
stat_stage_factor(-6, 1/4). % 0.25

%! increased_stat(+Raw_stat, +Stat_stage, -Result_stat).
%
% Calculates the value of a battle stat by it's raw value and status stage increase.
%
% Works with clpfd domains as raw stat
%
% @arg Raw_stat The basic stat value
% @arg Stat_stage The stat stage increase - an integer within range from -6 to 6
% @arg Result_stat The resulting status value
increased_stat(Raw, Stage, Stat_l..Stat_h) :-
  % handle clpfd domains
  Raw = Raw_l..Raw_h, !, % unifies
  stat_stage_factor(Stage, Factor), % get factor
  Stat_l is floor(Raw_l * Factor),
  Stat_h is floor(Raw_h * Factor).
increased_stat(Raw, Stage, Stat) :-
  stat_stage_factor(Stage, Factor),
  Stat is floor(Raw*Factor).

%! move_has_flag(+Move,+Flag).
% True if the given move has the given flag set in it's data
% @arg Move The move in question
% @arg Flag The flag in question
move_has_flag(Move,Flag) :-
  move(Move,_,_,_,_,_,Flags,_,_),!,
  member(Flag, Flags).

%! attacking_pokemon(+Attacker_state, -Attacking_pokemon).
% Returns the active pokemon of the attacking player.
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Attacking_pokemon The active pokemon of the attacker's team.
% @see attacking_pokemon/2
attacking_pokemon(state([Pokemon|_],_,_), Pokemon).

%! attacking_pokemon(+Attacker_state, -Attacking_pokemon, -Attacking_name).
% The same as attacking_pokemon/2 but additionally gives back the attacking pokemons name
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Attacking_pokemon The active pokemon of the attacker's team.
% @arg Attacking_name The active pokemon's name.
% @see attacking_pokemon/2
% @see pokemon_name/2
attacking_pokemon(state([Pokemon|_],_,_), Pokemon, Name) :-
  pokemon_name(Pokemon, Name).

%! set_attacking_pokemon(+Attacker_state, +New_pokemon, -Result_state).
% Alters the active pokemon of the attacking player.
% Be cautions as this completely overrides the currently active pokemon.
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg New_pokemon The new active pokemon's data
% @arg Result_state The resulting state of the game
set_attacking_pokemon(state([_|Team],Target,Field), Pokemon, state([Pokemon|Team],Target,Field)).

%! defending_pokemon(+Attacker_state, -Defending_pokemon).
% Returns the active pokemon of the defending player.
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Defending_pokemon The active pokemon of the target's team.
defending_pokemon(state(_,[Pokemon|_],_), Pokemon).

%! defending_pokemon(+Attacker_state, -Defending_pokemon, -Defending_name).
% The same as defending_pokemon/2 but additionally gives back the defending pokemons name
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg Defending_pokemon The active pokemon of the attacker's team.
% @arg Defending_name The active pokemon's name.
% @see defending_pokemon/2
% @see pokemon_name/2
defending_pokemon(state(_,[Pokemon|_],_), Pokemon, Name) :-
  pokemon_name(Pokemon, Name).

%! set_defending_pokemon(+Attacker_state, +New_pokemon, -Result_state).
% Alters the active pokemon of the defending player.
% Be cautions as this completely overrides the currently active pokemon.
% @arg Attacker_state The current state of the game from the attacker's point of view
% @arg New_pokemon The new active pokemon's data
% @arg Result_state The resulting state of the game
set_defending_pokemon(state(Attacker,[_|Team],Field), Pokemon, state(Attacker,[Pokemon|Team],Field)).
