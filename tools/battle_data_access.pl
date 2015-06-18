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

%! game_over(+Game_state)
%
% True if the game is over and either rot or the player has won
% Favours rot if both teams as fainted completely
%
% @arg Game_state The current state of the game
game_over(state(Player, _, _)) :-
  team_completely_fainted(Player),
  ui_display_win(rot).
game_over(state(_, Rot, _)) :-
  team_completely_fainted(Rot),
  ui_display_win(player).

%! attacker_fainted(Attacker_state)
%
% True if the active pokemon of the attacking player has fainted
%
% @arg Attacker_state The current game state from the attackers point of view
attacker_fainted(state([Lead|_], _, _)) :-
  fainted(Lead).

%! target_fainted(Attacker_state)
%
% True if the active pokemon of the defending player has fainted
%
% @arg Attacker_state The current game state from the attackers point of view
target_fainted(state(_, [Lead|_], _)) :-
  fainted(Lead).

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

%! stab(+Move_type, +Users_type_list, -Stab_factor)
%
% Gets the stab factor of the move depending on the users types
%
% @arg Move_type The elemental type of the move
% @arg Users_type_list The elemental type list of the move user
% @arg Stab_factor The resulting factor, either 1 or 1.5
stab(T, Ts, 1.5) :- member(T, Ts).
stab(T, Ts, 1) :- \+ member(T, Ts).

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

%! stat_stage_factor(Stat_stage, Factor)
%
% Gives the multiplier corresponding to the given stat stage
%
% @arg Stat_stage An integer from -6 to 6
% @arg Factor The factor depending on the stat increase or decrease
stat_stage_factor(6, 4).
stat_stage_factor(5, 3.5).
stat_stage_factor(4, 3).
stat_stage_factor(3, 2.5).
stat_stage_factor(2, 2).
stat_stage_factor(1, 1.5).
stat_stage_factor(0, 1).
stat_stage_factor(-1, (2/3)).
stat_stage_factor(-2, 0.5).
stat_stage_factor(-3, 0.4).
stat_stage_factor(-4, (1/3)).
stat_stage_factor(-5, (2/7)).
stat_stage_factor(-6, 0.25).

%! rng_to_hits(Random_number, Hits)
%
% Used to determine how often a move with 2 to 5 hits hits.
%
% @arg Random_number An integer from 0 to 6
% @arg Hits An integer from 2 to 5 indicating how many successful hits are to be calculated
% @see successful_hits
rng_to_hits(0,2).
rng_to_hits(1,2).
rng_to_hits(2,3).
rng_to_hits(3,3).
rng_to_hits(4,4).
rng_to_hits(5,5).
