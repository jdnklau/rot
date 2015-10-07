%! rng_succeeds(+Probability)
%
% Randomly true for the given probability. NOT PURELY LOGICAL
%
% @arg Probability The given probability as percentage that indicates how often this predicate succeeds
rng_succeeds(always).
rng_succeeds(100).
rng_succeeds(P) :-
  % in rot's heuristic - probabilities above a certain threshold shall always succeed
  rot(searching),!,
  P > 50.
rng_succeeds(P) :-
  % base case: normal battle probability check
  random(0, 101, R),
  R =< P.

%! rng_range(+Integer_range, -Number).
% Returns an integer from the interval [Lower_bound, Upper_bound].
% The given range has to be from the form between(L,U) where
% L (lower bound) is the lowest possible and U (upper bound) is the highest possible outcome
% @arg Number_range A frame specifying the range to be considered
% @arg Number An integer from the interval [Lower_bound, Upper_bound]
rng_range(between(X,X),X) :- !. % highest value = lowest value, so there is only one possible outcome
rng_range(between(L,U),X) :-
  % in rot's heuristic: take the average
  rot(searching),
  X is (U+L)//2.
rng_range(between(L,U), N) :-
  \+ rot(searching),
  UU is U+1, % increase so U is included in the range by the random/3 call below
  random(L,UU,N).

%! successful_hits(+Attacker, +Possible_number_of_hits, -Successful_number_of_hits)
%
% Calculates eventually by RNG how many hits a move will land.
% On a fixed number of hits this fixed number will be returned.
% On a variable number of hits the RNG will decide how many hits actually will be successful
%
% @arg Attacker The attacking pokemon's pokemon data
% @arg Possible_number_of_hits Number of hits possible, either an integer or `between(Minimum, Maximum)`
% @arg Successful_number_of_hits Number of granted successful hits
successful_hits(_, Hits, Hits) :-
  integer(Hits).
successful_hits(Attacker, between(_,Hits), Hits) :-
  ability(Attacker, 'skill link'). % skill link always lets the user hit the maximal amount of possible hits
successful_hits(_, between(2,5), Hits) :-
  rng_range(between(0,5),R),
  rng_to_hits(R, Hits).

%! rng_to_hits(Random_number, Hits)
%
% Used to determine how often a move with 2 to 5 hits hits.
% Necessary as the probability for either 2 or 3 hits is higher as for 4 or 5 hits
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

%! randomization_adjustment(-Random_factor)
%
% Gives the randomization adjustement used by the damage calculation within range of 0.85 to 1
%
% @arg Random_factor The resulting randomization adjustement to be multiplicated with the damage to be done
randomization_adjustment(RA) :-
  rng_range(between(85,100), R), % an integer from 85 to 100
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
