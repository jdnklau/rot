opponent(player, rot).
opponent(rot, player).

game_over(state(Player, _, _)) :-
  team_completely_fainted(Player),
  ui_display_win(rot).
game_over(state(_, Rot, _)) :-
  team_completely_fainted(Rot),
  ui_display_win(player).

target_fainted(state(_, [Lead|_], _)) :-
  fainted(Lead).
attacker_fainted(state([Lead|_], _, _)) :-
  fainted(Lead).

team_completely_fainted([]).
team_completely_fainted([Pokemon|Rest]) :-
  fainted(Pokemon),
  team_completely_fainted(Rest).

faster((Prio_a,_),(Prio_b,_)) :-
  Prio_a > Prio_b.
faster((Prio,Speed_a), (Prio,Speed_b)) :-
  Speed_a > Speed_b.
faster(Prio_data, Prio_data) :-
  random(0,2,0). % as priorities are the same flip a coin to decide who is faster

type_effectiveness(A, [T], E) :-
  typing(A, T, E).
type_effectiveness(A, [T], 1) :-
  \+ typing(A, T, _).
type_effectiveness(A, [T1, T2], E) :-
  type_effectiveness(A, [T1], E1),
  type_effectiveness(A, [T2], E2),
  E is E1*E2.

stab(T, Ts, 1.5) :- member(T, Ts).
stab(T, Ts, 1) :- \+ member(T, Ts).

translate_attacker_state(state(A, T, Field), player, state(A, T, Field)).
translate_attacker_state(state(T, A, [Field_t, Field_a, Field_g]), rot, state(A, T, [Field_a, Field_t, Field_g])).

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

% ensures that in a 2-5 hits move 2 and 3 hits are 33.33% likely
rng_to_hits(0,2).
rng_to_hits(1,2).
rng_to_hits(2,3).
rng_to_hits(3,3).
rng_to_hits(4,4).
rng_to_hits(5,5).
