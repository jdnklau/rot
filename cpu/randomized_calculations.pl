rng_succeeds(always).
rng_succeeds(100).
rng_succeeds(P) :-
  random(0, 101, R),
  R =< P.


successful_hits(_, Hits, Hits) :-
  integer(Hits).
successful_hits(Attacker, between(_,Hits), Hits) :-
  ability(Attacker, 'skill link').
successful_hits(_, between(2,5), Hits) :-
  random(0,6,R),
  rng_to_hits(R, Hits).

randomization_adjustment(0.85). % NFI

move_hits(Acc) :-
  rng_succeeds(Acc).

move_hits_critical(Stage) :-
  Stage >= 3.
move_hits_critical(Stage) :-
  Upper_bound is 16 / (2*(Stage+1)),
  random(0,Upper_bound,0).
