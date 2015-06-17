%! rng_succeeds(+Probability)
%
% Randomly true for the given probability. NOT PURELY LOGICAL
%
% @arg Probability The given probability as percentage that indicates how often this predicate succeeds
rng_succeeds(always).
rng_succeeds(100).
rng_succeeds(P) :-
  random(0, 101, R),
  R =< P.

%! successful_hits(+Attacker, +Possible_number_of_hits, -Successfull_number_of_hits)
%
% Calculates eventually by RNG how many hits a move will land.
% On a fixed number of hits this fixed number will be returned.
% On a variable number of hits the RNG will decide how many hits actually will be successfull
%
% @arg Attacker The attacking pokemon's pokemon data
% @arg Possible_number_of_hits Number of hits possible, either an integer or `between(Minimum, Maximum)`
% @arg Successfull_number_of_hits Number of granted successfull hits
successful_hits(_, Hits, Hits) :-
  integer(Hits).
successful_hits(Attacker, between(_,Hits), Hits) :-
  ability(Attacker, 'skill link'). % skill link always lets the user hit the maximal amount of possible hits
successful_hits(_, between(2,5), Hits) :-
  random(0,6,R),
  rng_to_hits(R, Hits).

%! randomization_adjustment(-Random_factor)
%
% Gives the randomization adjustement used by the damage calculation within range of 0.85 to 1
%
% @arg Random_factor The resulting randomization adjustement to be multiplicated with the damage to be done
randomization_adjustment(RA) :-
  random(85, 101, R), % an integer from 85 to 100
  RA is R/100. % a float from 0.85 to 1

%! move_hits(+Accuracy)
%
% True if a certain move will hit depending on the given accuracy
%
% @arg Accuracy Percentage of how often a certain move hits successfully
move_hits(Acc) :-
  rng_succeeds(Acc).

%! move_hits_critical(+Critical_hit_stage)
%
% True if a certain move will hit critically depending on the given critical hit
% stage.
%
% @arg Critical_hit_stage The critical hit stage of the user
move_hits_critical(0) :-
  !, % green cut
  rng_succeeds(6.25).
move_hits_critical(1) :-
  !, % green cut
  rng_succeeds(12.5).
move_hits_critical(2) :-
  !, % green cut
  rng_succeeds(50).
move_hits_critical(Stage) :-
  Stage >= 3, % from stage 3 on onward all hits are critical hits
  rng_succeeds(100).
