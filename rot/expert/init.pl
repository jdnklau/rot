%! rot_init_opponent(+Instance, +Team_list).
% Initializes the opponents team..
% Asserts the given team as rot(opponent_team(Team_list)) for quick reference.
% Constructed pokemon data are additionally asserted as rot(knows(Pokemon)).
% @arg Instance The identifier for the instance of Rot to work with
% @arg Team_list List of pokemon names building a team.
rot_init_opponent(I,Team) :-
  rot_init_opponent_(I,Team),
  asserta(rot(I,opponent_team(Team))), % assert team
  Team = [Active|_],
  rot_set_opponent_active(I,Active).
rot_init_opponent_(I,[P|Ps]) :-
  rot_init_pokemon(I,P),
  rot_init_opponent_(I,Ps).
rot_init_opponent_(_,[]).

%! rot_init_self(+Instance, +Team_data).
%
% Rot asserts its own team to its knowledge base.
%
% The data of each pokemon are accessible by calling rot(has(Pokemon_data)).
%
% @arg Instance The identifier for the instance of Rot to work with
% @arg Team_data The already setup team data of Rot's team
rot_init_self(I,Team) :-
  rot_init_self_(I,Team),
  team_list(Team,Ps), % get team of only names
  asserta(rot(I,own_team(Ps))), % assert team as quick reference
  Ps = [Active|_],
  rot_set_own_active(I,Active). % set active pokemon
rot_init_self_(I,[P|Ps]) :-
  rot_init_own_pokemon(I,P),
  rot_init_self_(I,Ps).
rot_init_self_(_,[]).

%! rot_init_own_pokemon(+Instance, +Pokemon).
% Asserts the given pokemon data.
% Accessible by calling rot(has(Pokemon)).
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon The pokemon data to be asserted
rot_init_own_pokemon(I,P) :-
  asserta(rot(I,has(P))).

%! rot_init_pokemon(+Instance, +Pokemon_name).
%
% Guesses the set of a given pokemon without further input
% The assumed results are asserted as rot(knows(Pokemon_data)).
%
% The status values as Hit Point, Attack, Defense, etc are asserted as finite domains.
% Each domain marks the range the corresponding stat has it's value.
%
% The EV and DV also are saved as domains ranging from 0 to 252 or from 0 to 31 respectively.
% The sum of all EV can not exceed 510.
%
% @arg Instance The identifier for the instance of Rot to work with
% @arg Pokemon_name The name of the pokemon.
rot_init_pokemon(I,Pokemon) :-
  % set up the pokemon data
  P = [Pokemon, kp(HP,HP), Moves,
        [Abilities, Stats, Types, stat_stages(0,0,0,0,0), EV_DV],
        noitem, [nil,[],[]]],
  % unify remaining vars
  pokemon(Pokemon, Types, Base_stats, Abilities), % Types/Abilites
  rot_init_pokemon_stats(Base_stats, HP, Stats, EV_DV), % stats/ev/dv
  rot_init_pokemon_moves(P, Moves),
  % assert the pokemon
  rot_update_known_pokemon(I,P).

%! rot_init_pokemon_stats(+Base_stat_frame, -Hit_points, -Stat_frame, -EV_DV_data).
% Returns domains of status values depending on the given base stats
% @arg Base_stat_frame A stat frame containing the base status values of a pokemon
% @arg Hit_points the maximal hit points domain depending on the base stats
% @arg Stat_frame a status value frame containing domains for all status values but hit points
% @arg EV_DV_data A data pack containing domains for the status values EV and DV
rot_init_pokemon_stats(Base_stat_frame, HP, Stat_frame, EV_DV) :-
  Base_stat_frame = stats(HP_b, Atk_b, Def_b, Spa_b, Spd_b, Spe_b), %access base stats
  % set hp values
  set_up_kp(HP_b, (0,0), HP_inf), % infimum of domain
  set_up_kp(HP_b, (252,31), HP_sup), % supremum of domain
  % set remaining status values' domain's upper and lower bounds
  set_up_stat(Atk_b, (0,0), Atk_inf), % attack
  set_up_stat(Atk_b, (252,31), Atk_sup),
  set_up_stat(Def_b, (0,0), Def_inf), % defense
  set_up_stat(Def_b, (252,31), Def_sup),
  set_up_stat(Spa_b, (0,0), Spa_inf), % special attack
  set_up_stat(Spa_b, (252,31), Spa_sup),
  set_up_stat(Spd_b, (0,0), Spd_inf), % special defense
  set_up_stat(Spd_b, (252,31), Spd_sup),
  set_up_stat(Spe_b, (0,0), Spe_inf), % speed
  set_up_stat(Spe_b, (252,31), Spe_sup),
  % set up stat frame
  HP = HP_inf..HP_sup,
  Stat_frame = stats(Atk_inf..Atk_sup, Def_inf..Def_sup,
                      Spa_inf..Spa_sup, Spd_inf..Spd_sup, Spe_inf..Spe_sup),
  % set up ev/dv data
  Gen_evdv = (0..252, 0..31), % generic ev/dv domain tupel
  EV_DV = (Gen_evdv, Gen_evdv, Gen_evdv, Gen_evdv, Gen_evdv, Gen_evdv).


%! rot_init_pokemon_moves(+Pokemon, -Move_data).
% Guesses moves of a pokemon by taking it's stats into account.
% @arg Pokemon The pokemon data of the pokemon in question (may be obviously missing moves)
% @arg Move_data The data of the calculated moves
rot_init_pokemon_moves(Pokemon, Moves) :-
  types(Pokemon,Ts),
  rot_init_pokemon_moves_acc(Pokemon,Ts,[],[],Moves).
% accumulator stops at 4 moves
% it selects the strongest move of a given type in the type list (2nd arg) available to the pokemon (1st arg)
% if the typelist is empty it selects an additional type to increase the type coverage granted by the moves
rot_init_pokemon_moves_acc(_,_,_,Moves,Moves) :-
  % has 4 moves
  length(Moves,4), !.
rot_init_pokemon_moves_acc(Pokemon,[],Types_used,Moves_found,Moves) :-
  % get a move for coverage
  rot_init_pokemon_moves_coverage_type(Types_used,T),
  rot_init_pokemon_moves_acc(Pokemon,[T],Types_used,Moves_found,Moves).
rot_init_pokemon_moves_acc(Pokemon,[T|Ts],Types_used,Moves_found,Moves) :-
  % find the strongest move of the wanted type
  pokemon_name(Pokemon,Name),
  findall((M,R), (can_learn(Name,M),move(M,T,_,_,_,_,_,_,_),
                  rot_init_pokemon_moves_rated_power(Pokemon,M,R)), Ms),
  Ms \= [], % no such move learned? thats... to bad
  sort(2,@>,Ms,[(Move,_)|_]),
  % get pp
  move(Move,_,_,_,pp(PP),_,_,_,_),
  rot_init_pokemon_moves_acc(Pokemon,Ts,[T|Types_used],[uncertain([Move,PP])|Moves_found],Moves).

%! rot_init_pokemon_moves_rated_power(+Known_pokemon_data, +Move, -Rating).
% Rates a move choice for a given pokemon by it's base power. Fails for status moves
% @arg Known_pokemon_data The pokemon data of the pokemon in question (may be obviously missing moves)
% @arg Move The name of the move in question
% @arg Rating An integer based on certain factors to give a rough idea how strong the move is
rot_init_pokemon_moves_rated_power(Pokemon, Move, Rating) :-
  move(Move,T,CP,acc(Acc),pp(PP),_,_,_,_),
  CP =.. [Cat,Pow],
  number(Pow),
  atk_stat_by_category(Pokemon,Cat,_..Atk),
  calculate_stab(Pokemon,T,Stab),
  (Acc = always,Acc_value=100 ; Acc_value=Acc),
  Rating is Pow*Atk*Acc_value*min(PP,10)*Stab, !.

rot_init_pokemon_moves_coverage_type(Ts, Cov) :-
  findall(T,(type(T),\+member(T,Ts)),Rs), % get list of all remaining types
  rot_init_pokemon_moves_coverage_type_acc(Ts,Rs,[],Cov).
% the accumulator collects every result (3rd arg) of the coverage amount
% every type od the remainign type list (2nd arg) gets added to the existing type list (1st arg)
% and propagates through all possibilities. The best result will be returned (4th arg)
rot_init_pokemon_moves_coverage_type_acc(Ts,[R|Rs],Values,Cov) :-
  findall(P, (pokemon(P,PTs,_,_),once((member(T,[R|Ts]),type_effectiveness(T,PTs,E),E>1))), Ps), % get pokemon that get hit very effectively
  length(Ps,L), % amount of very effectively hit pokemon
  rot_init_pokemon_moves_coverage_type_acc(Ts,Rs,[(R,L)|Values],Cov).
rot_init_pokemon_moves_coverage_type_acc(_,[],Values,Cov) :-
  sort(2,@>=,Values,Sorted_values),
  member((Cov,_),Sorted_values).

%! rot_init_ev_dv_vars(+EV_DV_domain_data_frame, -EV_DV_domain_vars_frame).
% Takes the ev/dv domains given and returns finite domain variables matching the data.
%
% The form for both the frames is a 6-tuple, having tuples as data. Those tuples are
% of the form (EV, DV) and come in the following semantic order:
%   1. hit points
%   2. attack
%   3. defense
%   4. special attack
%   5. special defense
%   6. speed
% @arg EV_DV_domain_data_frame An ev/dv frame containing the value's domains
% @arg EV_DV_domain_vars_frame An ev/dv frame containing vars tied to the given domains
rot_init_ev_dv_vars(EV_DV, EV_DV_vars) :-
  EV_DV = ((Hp_e, Hp_d),(Atk_e, Atk_d),(Def_e, Def_d),(Spa_e,Spa_d),(Spd_e,Spd_d),(Spe_e,Spe_d)),
  % set up domains for ev - _ed suffix for (e)v (d)omain
  Hp_ed in Hp_e,
  Atk_ed in Atk_e,
  Def_ed in Def_e,
  Spa_ed in Spa_e,
  Spd_ed in Spd_e,
  Spe_ed in Spe_e,
  EV = [Hp_ed,Atk_ed,Def_ed,Spa_ed,Spd_ed,Spe_ed],
  sum(EV, #=<, 510), % sum of ev is =< 510
  % set up domains for dv - _dd suffix for (d)v (d)omain
  Hp_dd in Hp_d,
  Atk_dd in Atk_d,
  Def_dd in Def_d,
  Spa_dd in Spa_d,
  Spd_dd in Spd_d,
  Spe_dd in Spe_d,
  EV_DV_vars = ((Hp_ed, Hp_dd),(Atk_ed, Atk_dd),(Def_ed, Def_dd),
                    (Spa_ed,Spa_dd),(Spd_ed,Spd_dd),(Spe_ed,Spe_dd)).
