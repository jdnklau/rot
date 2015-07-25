% if/then rules
% representation of expertise

%! usage(+Pokemon, -Usage).
%
% Calculates a possible usage of the given pokemon.
% The usage returned has the form `Category-Class`.
%
% `Class` may be one of the following:
%   * sweeper, an offensive and fast pokemon
%   * wall, a very defensive pokemon
%   * tank, an offensive pokemon with defensive capabilities, but slow
%   * unique, a pokemon with a not classified role
% `Category` may be one of the following:
%   * physical
%   * special
%   * mixed (has both physical and special benefits)
%
% E.g. a special-sweeper does special damage and thus has high special attack
% and a physical-wall can take physical damage easily,
% but does not necessarily cause physical damage itself.
%
% @arg Pokemon The constructed pokemon data of the pokemon in question
% @arg Usage The usage class of the pokemon (see description)
usage(Pokemon, Usage) :-
  potential_usage(Pokemon, Usage),
  proper_trained_stats(Pokemon, Usage).
usage(Pokemon, Usage) :-
  % this clause is meant to catch unique ev distributions
  % that means ev distributions not suitable according to the evaluation of the pokemon
  % as the first clause checks if the ev distribution matches a suitable usage
  %   and this clause is only called if the ev distribution does not fit any suitable usage
  %   it is safe to assume that the system already was able to reduce certain ev domains.
  % with that assumtion it is also safe to say that proper_trained_stats/2 would not
  %   just assign the first usage mentioned in it's first clause but rather make a guess
  %   dependend on what the system actually was able to observe,
  %   thus guessing usage independend from the base stats.
  proper_trained_stats(Pokemon, Usage),
  \+ potential_usage(Pokemon, Usage). % suppresses double output


%! proper_trained_stats(+Pokemon, +Usage).
% True if the given constructed pokemon data allow a certain usage.
% This means the possible effort value distribution allows high values for Those
% stats needed for a specific usage, e.g. a sweeper has a high offensive value
% @arg Pokemon The constructed pokemon data of the pokemon in question.
% @arg Usage The role of the pokemon
% @see usage/2
proper_trained_stats(Pokemon, special-sweeper) :-
  ev_data(Pokemon, _,_,_,Spa_d,_,Spe_d), % returns even domains!
  % special sweeper has it's special attack and speed trained
  trained_stat(Spa_d),
  trained_stat(Spe_d).
proper_trained_stats(Pokemon, physical-sweeper) :-
  ev_data(Pokemon, _,Atk_d,_,_,_,Spe_d), % returns even domains!
  % physical sweeper has it's attack and speed trained
  trained_stat(Atk_d),
  trained_stat(Spe_d).
proper_trained_stats(Pokemon, special-wall) :-
  ev_data(Pokemon, Hp_d,_,_,_,Spd_d,_), % returns even domains!
  % special wall has it's special defense and hit points trained
  trained_stat(Spd_d),
  trained_stat(Hp_d).
proper_trained_stats(Pokemon, physical-wall) :-
  ev_data(Pokemon, Hp_d,_,Def_d,_,_,_), % returns even domains!
  % physical wall has it's defense and hit points trained
  trained_stat(Def_d),
  trained_stat(Hp_d).

%! potential_usage(+Pokemon, -Usage).
% Returns a possible usage of the pokemon.
% Note that theoretically every usage is possible for every pokemon,
% but practically some roles for some pokemon do not work well.
% This predicate only returns those usages making a little sense as they harmonize
% with what the pokemon has serious potential for.
% @arg Pokemon The constructed pokemon data of the pokemon in question.
% @arg Usage The role of the pokemon
potential_usage(Pokemon, Usage) :-
  pokemon_name(Pokemon,Name),
  pokemon(Name,_,Stats,_), % access base stats
  guess_usage_by_base_stats(Stats, Usage).

%! guess_usage_by_base_stats(+Base_stat_frame, -Usage).
% Returns a possible usage of the pokemon that seems judgeing on it's base stats suitable for it.
% @arg Base_stat_frame A stats/6 frame containing the base status values of a pokemon
% @arg Usage The role of the pokemon
guess_usage_by_base_stats(stats(_,Atk,Def,Spa,Spd,_),physical-sweeper) :-
  stats_among_highest([Atk], [Spa,Def,Spd]).
guess_usage_by_base_stats(stats(_,Atk,Def,Spa,Spd,_),special-sweeper) :-
  stats_among_highest([Spa], [Atk,Def,Spd]).
guess_usage_by_base_stats(stats(_,Atk,Def,Spa,Spd,_),physical-wall) :-
  stats_among_highest([Def], [Atk,Spd,Spa]).
guess_usage_by_base_stats(stats(_,Atk,Def,Spa,Spd,_),special-wall) :-
  stats_among_highest([Spd], [Atk,Def,Spa]).

%! stats_among_highest(+Stats_to_check, +Stats_to_compare_with).
% True if the given stats are higher or nearly as high as other stats.
% Each stat to check is compared with each stat of the second argument's list of stats.
% If the stat is higher as at least 88% of each of all the stats it gets compared with
% it is taken as among the highest stats, but not necessarily *the* highest.
% @arg Stats_to_check List of status values to be checked whether they are among the highest or not.
% @arg Stats_to_compare_with List of status values the status values to check with are compared with.
stats_among_highest([_],[]). % base case
stats_among_highest([Stat],[Other|Others]) :-
  % checking single stat vs group of stats
  Stat >= Other * 0.88, % we allow a range of 12 %
  stats_among_highest([Stat], Others). % try other stats
stats_among_highest([Stat|Stats],Others) :-
  % checking multiple stats
  Others \= [],
  Stats \= [],
  stats_among_highest([Stat],Others),!, % check first stat
  stats_among_highest(Stats,Others). % check remaining stats

%! trained_stat(+Stat_ev_domain).
% True if the given effort value domain still allows values higher than a certain threshold.
% This indicates that the system can not rule out that the given domains corresponding
% effort value is high (maybe even capped to 252).
% This predicate is only to be used for effort value stat domains as it makes little
% to no sense to use it for any other domain but a domain `0..252` or smaller.
% @arg Stat_ev_domain A domain 0.252 or smaller
trained_stat(Domain) :-
  Stat in Domain,
  fd_sup(Stat, Sup),
  Sup >= 200. % ev >= 200 indicates that this stat may be trained

%! labeling_ev(+Usage, ?Hp, ?Attack, ?Defense, ?Special_attack, ?Special_defense, ?Speed).
% Sets values to the given finit domain variables depending on the given pokemon usage.
% This is intended for giving a generic ev split for a pokemon depending on it's usage,
% thus it is assumed that:
%   * the variables have a finite domain of 0..252 or smaller
%   * the variables are constrained to have a total sum of 510 or lower
% @arg Usage The role of a pokemon
% @arg Hp A variable in the domain of possible hit point effort values
% @arg Attack A variable in the domain of possible attack effort values
% @arg Defense A variable in the domain of possible defense effort values
% @arg Special_attack A variable in the domain of possible special attack effort values
% @arg Special_defense A variable in the domain of possible special defense effort values
% @arg Speed A variable in the domain of possible speed effort values
labeling_ev(special-sweeper,Hp,_,_,Spa,_,Spe) :-
  labeling([down],[Spa,Spe,Hp]).
labeling_ev(physical-sweeper,Hp,Atk,_,_,_,Spe) :-
  labeling([down],[Atk,Spe,Hp]).
labeling_ev(special-wall,Hp,_,Def,_,Spd,_) :-
  labeling([down],[Spd,Hp,Def]).
labeling_ev(physical-wall,Hp,_,Def,_,Spd,_) :-
  labeling([down],[Def,Hp,Spd]).
