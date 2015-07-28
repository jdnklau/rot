% core of the system
% derives recommendations/solutions from knowledge base

%! rot_derive_team(-Team).
% Returns a from the observed pokemon data of the opponent's team derived team.
% @arg Team The derived team from the known opponent's pokemon data
% @see rot_derive_pokemon/1
rot_derive_team(Team_derived) :-
  rot(opponent_team(Team)), % get asserted team list
  maplist(rot_derive_pokemon, Team), % derive all pokemon
  findall(Pokemon, rot(derived(Pokemon)), Team_derived).

%! rot_derive_pokemon(+Name).
%
% Derives pokemon data from the observed data of the given pokemon.
%
% The data is derived from was is known of the pokemon and asserted as `rot(knows(Pokemon_data))`.
% Upon deriving the system selects fixed values for the ev and dv distribution depending on the remaining
% domains of the individual status values.
%
% The derived data will be asserted as `rot(derived(Data))`.
% This is because in a single battle turn there can only be an observation of one pokemon
% of the opponents team (the active one), thus only data of one pokemon may be updated.
% So rather than deriving the data for all of the opponent's pokemon again each turn it seems
% easier to just assert the data and thus having only to rederive the data of updated pokemon.
%
% If a pokemon needs to be rederived one must retract the derived data before calling this predicate
% as this predicate only derives data for not already derived pokemon to save some computing time.
%
% @arg Name The name of the pokemon
rot_derive_pokemon(Name) :-
  rot(derived([Name|_])),!. % if data already is derived we can skip this
rot_derive_pokemon(Name) :-
  rot(knows([Name|Data])), % get what's already known
  % acces data
  Data = [kp(Hp_cur_dom,Hp_max_dom), Moves,
        [Abilities, _, Types, Stat_stages, EV_DV],
        Item, Status_conditions],
  % usage information
  usage([Name|Data], Use), % special sweeper, physical tank, mixed wall, etc.
  rot_derive_ev_dv(EV_DV, Use, EV_DV_derived),
  % derive stats
  pokemon(Name,_,Base_stats,_), % get base stats
  set_up_stats(Base_stats, EV_DV_derived, Hp_derived, Stats_derived),
  rot_derive_moves(Moves, Moves_derived),
  % derive remaining hit points
  Hp_cur in Hp_cur_dom,
  fd_sup(Hp_cur, Hp_cur_sup),
  Hp_max in Hp_max_dom,
  fd_sup(Hp_max, Hp_max_sup),
  Hp_remaining_perc is Hp_cur_sup/Hp_max_sup, % get rough percentage
  Hp_cur_derived is floor(Hp_derived*Hp_remaining_perc),
  Abilities = [Ability_derived|_],
  % set up derived data
  Data_derived = [kp(Hp_cur_derived, Hp_derived), Moves_derived,
                  [Ability_derived, Stats_derived, Types, Stat_stages, EV_DV_derived],
                  Item, Status_conditions],
  asserta(rot(derived([Name|Data_derived]))), % assert as this does not to be recalculated in every single turn
  !. % red cut to prevent permanent backtracking to all the labeling possibilities of the ev and dv

%! rot_derive_ev_dv(+EV_DV_domain_data, +Pokemon_usage, -Derived_EV_DV_data).
% Derives a pokemons possible ev/dv distribution.
% This depends on the possible usage of the pokemon and it's possible EV and DV domains
% @arg EV_DV_domain_data The data of the possible domains for effort and determinant values
% @arg Pokemon_usage The role of the pokemon
% @arg Derived_EV_DV_data The resulting derived ev/dv distribution.
rot_derive_ev_dv(EV_DV, Use, EV_DV_derived) :-
  % access data
  EV_DV = ((Hp_e, Hp_d),(Atk_e, Atk_d),(Def_e, Def_d),(Spa_e,Spa_d),(Spd_e,Spd_d),(Spe_e,Spe_d)),
  % set up domains for ev - _ed suffix for (e)v (d)erived
  Hp_ed in Hp_e,
  Atk_ed in Atk_e,
  Def_ed in Def_e,
  Spa_ed in Spa_e,
  Spd_ed in Spd_e,
  Spe_ed in Spe_e,
  EV = [Hp_ed,Atk_ed,Def_ed,Spa_ed,Spd_ed,Spe_ed],
  sum(EV, #=<, 510), % sum of ev is =< 510
  labeling_ev(Use, Hp_ed, Atk_ed, Def_ed, Spa_ed, Spd_ed, Spe_ed),
  % set up domains for dv - _dd suffix for (d)v (d)erived
  Hp_dd in Hp_d,
  Atk_dd in Atk_d,
  Def_dd in Def_d,
  Spa_dd in Spa_d,
  Spd_dd in Spd_d,
  Spe_dd in Spe_d,
  DV = [Hp_dd, Atk_dd, Def_dd, Spa_dd, Spd_dd, Spe_dd],
  labeling([down],DV),
  % return changes
  EV_DV_derived = ((Hp_ed, Hp_dd),(Atk_ed, Atk_dd),(Def_ed, Def_dd),
                    (Spa_ed,Spa_dd),(Spd_ed,Spd_dd),(Spe_ed,Spe_dd)).

%! rot_derive_moves(+Assumed_moves, -Derived_moves).
% Get's rid of the uncertain/1 frame surrounding guessed but not yet observed moves.
% @arg Assumed_moves The move data directly from the observed pokemon data
% @arg Derived_moves The move data without any uncertainty frames
rot_derive_moves([],[]). % base case
rot_derive_moves([uncertain(Move)|Rest], [Move|Rest_derived]) :-
  % uncertain moves are assumed as certain
  rot_derive_moves(Rest,Rest_derived).
rot_derive_moves([Move|Rest],[Move,Rest_derived]) :-
  % certain moves are ... well, certain...
  rot_derive_moves(Rest, Rest_derived).
