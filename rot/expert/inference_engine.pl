% core of the system
% derives recommendations/solutions from knowledge base

%! derive_team(-Team).
% Returns a from the known pokemon data of the opponent's team derived team.
% @arg Team The derived team from the known opponent's pokemon data
derive_team(Team_derived) :-
  rot(opponent_team(Team)), % get asserted team
  findall(P_d, (member(P, Team), derive_pokemon(P,P_d)),Team_derived).

%! derive_pokemon(+Name, -Derived_pokemon_data).
% Returns the derived pokemon data of an opponent's pokemon.
% @arg Name The name of the pokemon
% @arg Derived_pokemon_data The from the known data derived pokemon data
derive_pokemon(Name, [Name|Data_derived]) :-
  rot(knows([Name|Data])), % get what's already known
  % acces data
  Data = [kp(Hp_cur_dom,Hp_max_dom), Moves,
        [Abilities, _, Types, Stat_stages, EV_DV],
        Item, Status_conditions],
  % usage information
  usage([Name|Data], Use), % special sweeper, physical tank, mixed wall, etc.
  derive_ev_dv(EV_DV, Use, EV_DV_derived),
  % derive stats
  pokemon(Name,_,Base_stats,_), % get base stats
  set_up_stats(Base_stats, EV_DV_derived, Hp_derived, Stats_derived),
  derive_moves(Moves, Moves_derived),
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
  !. % red cut to prevent permanent backtracking to all the labeling possibilities of the ev and dv

%! derive_ev_dv(+EV_DV_domain_data, +Pokemon_usage, -Derived_EV_DV_data).
% Derives a pokemons possible ev/dv distribution.
% This depends on the possible usage of the pokemon and it's possible EV and DV domains
% @arg EV_DV_domain_data The data of the possible domains for effort and determinant values
% @arg Pokemon_usage The role of the pokemon
% @arg Derived_EV_DV_data The resulting derived ev/dv distribution.
derive_ev_dv(EV_DV, Use, EV_DV_derived) :-
  % access data
  EV_DV = ((Hp_e, Hp_d),(Atk_e, Atk_d),(Def_e, Def_d),(Spa_e,Spa_d),(Spd_e,Spd_d),(Spe_e,Spe_d)),
  % set up domains for ev - _ed suffix for (e)v (d)erived
  EV = [Hp_ed,Atk_ed,Def_ed,Spa_ed,Spd_ed,Spe_ed],
  Hp_ed in Hp_e,
  Atk_ed in Atk_e,
  Def_ed in Def_e,
  Spa_ed in Spa_e,
  Spd_ed in Spd_e,
  Spe_ed in Spe_e,
  sum(EV, #=<, 510), % sum of ev is =< 510
  labeling_ev(Use, Hp_ed, Atk_ed, Def_ed, Spa_ed, Spd_ed, Spe_ed),
  % set up domains for dv - _dd suffix for (d)v (d)erived
  DV = [Hp_dd, Atk_dd, Def_dd, Spa_dd, Spd_dd, Spe_dd],
  Hp_dd in Hp_d,
  Atk_dd in Atk_d,
  Def_dd in Def_d,
  Spa_dd in Spa_d,
  Spd_dd in Spd_d,
  Spe_dd in Spe_d,
  labeling([down],DV),
  % return changes
  EV_DV_derived = ((Hp_ed, Hp_dd),(Atk_ed, Atk_dd),(Def_ed, Def_dd),
                    (Spa_ed,Spa_dd),(Spd_ed,Spd_dd),(Spe_ed,Spe_dd)).

%! derive_moves(+Assumed_moves, -Derived_moves).
% Get's rid of the uncertain/1 frame surrounding guessed but not yet observed moves.
% @arg Assumed_moves The move data directly from the constructed pokemon data
% @arg Derived_moves The move data without any uncertainty frames
derive_moves([],[]). % base case
derive_moves([uncertain(Move)|Rest], [Move|Rest_derived]) :-
  % uncertain moves are assumed as certain
  derive_moves(Rest,Rest_derived).
derive_moves([Move|Rest],[Move,Rest_derived]) :-
  % certain moves are ... well, certain...
  derive_moves(Rest, Rest_derived).
