%! decimal_to_fraction(+Decimal, -Numerator, -Denominator).
% Splits a decimal into the numerator and denominator of it's representing fraction.
% @arg Decimal A decimal number, like 0.75
% @arg Numerator The numerator of the given decimal's fractional representation, like 3
% @arg Numerator The denominator of the given decimal's fractional representation, like 4
decimal_to_fraction(Dc, Nm, Dn) :-
  Nm rdiv Dn is rationalize(Dc), !.
decimal_to_fraction(Dc, Nm, 1) :-
  Nm is rationalize(Dc).

%! stat_stage_increase_message(+Stat_name, +Old_stat_stage, +Stage_increase, -Message_collection).
% Returns a message collection containing messages how a goven status value stage changed.
% @arg Stat_name The name of the status value stage
% @arg Old_stat_stage The old stage value of the stat
% @arg Stage_increase The amount the status stage has increased
% @arg Message_collection The message collection containing the messages about the status stage change
stat_stage_increase_message(Stat, 6, Inc, Msg) :-
  % maxed out
  Inc > 0,
  add_messages([target(stat_stage(stat(Stat),cannot(increase)))], [], Msg).
stat_stage_increase_message(Stat, -6, Inc, Msg) :-
  % minial stage
  Inc < 0,
  add_messages([target(stat_stage(stat(Stat),cannot(decrease)))], [], Msg).
stat_stage_increase_message(Stat, _, Increase, Msg) :-
  % base case
  add_messages([target(stat_stage(stat(Stat),value(Increase)))], [], Msg).

%! set_up_pokemon(+Name, +Nature, +Ability, +Move_list, +EV_DV_data, +Item, -Result)
%
% Sets up a pokemon by its wished attributes an translates it to the pokemon data structure
% used in the program.
%
% The EV and DV data is a six-tupel containing six tupels corresponding to the status values.
% Those tupels are of the form (Effort_value, Determinant_value).
% Effort values range from 0 to 252, but the sum of all six of them does not exceed 510.
% Determinant values range from 0 to 31 and are each independend of the other's base stat DV.
%
% @arg Name The name of the pokemon
% @arg Nature The nature of the pokemon
% @arg Ability The ability of the pokemon
% @arg Move_list A list of up to four moves the pokemon shall know
% @arg EV_DV_data Information about how the EV and DV of the pokemon are spent
% @arg Item the item to be hold
% @arg Result The resulting pokemon data
set_up_pokemon(Name, Nature, Ability, [M1, M2, M3, M4], EV_DV, Item, Result) :-
  set_up_move(M1, Move_1),
  set_up_move(M2, Move_2),
  set_up_move(M3, Move_3),
  set_up_move(M4, Move_4),
  Moves = [Move_1, Move_2, Move_3, Move_4],
  pokemon(Name, Types, Base_stats,_), % get base stats
  set_up_stats(Base_stats, EV_DV, Hp, Stats),
  apply_nature(Nature,Stats, Stats_nature),
  Result =
    [Name, kp(Hp, Hp), Moves,
      [Ability, Stats_nature, Types, stat_stages(0,0,0,0,0), EV_DV],
      Item, [nil, [], []]], !.

%! set_up_stats(+Base_stat_frame, +EV_DV_data, -HP, -Stat_frame).
% Calculates the resulting stat frame by base stats and ev/dv distribution
% @arg Base_stat_frame A stat/6 frame containing the base status values (including hit points)
% @arg EV_DV_data The ev/dv distribiution
% @arg HP The maximal hit points by the given base stats and ev/dv
% @arg Stat_frame a stat/5 frame containing the resulting status values (excluding hit points)
set_up_stats(Base_stats, EV_DV, Hp, Stats) :-
  Base_stats = stats(B_Hp, B_Atk, B_Def, B_Spa, B_Spd, B_Spe),
  EV_DV = (Hp_ed, Atk_ed, Def_ed, Spa_ed, Spd_ed, Spe_ed), % access ev/dv
  set_up_kp(B_Hp, Hp_ed, Hp),
  set_up_stat(B_Atk, Atk_ed, Atk),
  set_up_stat(B_Def, Def_ed, Def),
  set_up_stat(B_Spa, Spa_ed, Spa),
  set_up_stat(B_Spd, Spd_ed, Spd),
  set_up_stat(B_Spe, Spe_ed, Spe),
  Stats = stats(Atk,Def,Spa,Spd,Spe).% set up result

%! set_up_kp(+Base_value, +EV_DV_data, -Resulting_value)
% Calculate the correct stat value from the base value
% @arg Base_value The value of the pokemon's hp base stat
% @arg EV_DV_data A tupel of the form (EV, DV), where EV ranges from 0 to 252 and DV from 0 to 31
% @arg Resulting_value The actual value of the stat
set_up_kp(Base_value, (EV,DV), Stat_value) :-
  DV_and_EV is DV + EV//4,
  Stat_value is (2*Base_value + DV_and_EV + 100)//2 + 10.

%! set_up_stat(+Base_value, +EV_DV_data, -Resulting_value)
% Calculate the correct stat value from the base value
% @arg Base_value The value of the pokemon's hp base stat
% @arg EV_DV_data A tupel of the form (EV, DV), where EV ranges from 0 to 252 and DV from 0 to 31
% @arg Resulting_value The actual value of the stat
set_up_stat(Base_value, (EV,DV), Stat_value) :-
  DV_and_EV is DV + EV//4,
  Stat_value is (2*Base_value + DV_and_EV)//2 + 5.

apply_nature(_,Stats,Stats). % NYI

%! set_up_move(+Move_name, -Move_data)
%
% Translates the given move (by name) into a form used by the pokemon data structure
%
% @arg Move_name Name of the move
% @arg Move_data The move translated to the data format
set_up_move(Name, [Name,PP]) :-
  move(Name, _, _, _, pp(PP), _, _, _, _).
