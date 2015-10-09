rate_advanced(state(Player,Rot,_), (R_player, R_rot)) :-
  rate_adv(Player, Rot, R_player),
  rate_adv(Rot, Player, R_rot),!.

rate_adv([Act|Team], [Act_opp|_], R) :-
  rate_adv_speed(Act,Act_opp, R_spe),
  rate_adv_dmg(Act,Act_opp, R_dmg),
  rate_adv_team([Act|Team], R_team),
  R is floor(R_spe+R_dmg+R_team).

rate_adv_speed(A1, A2, 50) :-
  % plus points if faster
  stats(A1,_,_,_,_,S1),
  stats(A2,_,_,_,_,S2),
  S1 > S2, !.
rate_adv_speed(_,_,0).

rate_adv_dmg(A1, A2, R) :-
  available_moves([A1], Ms),
  rate_adv_dmg_acc(Ms, A1, A2, 0, R).
% accumulator
rate_adv_dmg_acc([M|Ms], A1, A2, X, R) :-
  move(M,_,status,_,_,_,_,_,_),!,
  rate_adv_dmg_acc(Ms, A1, A2, X, R).
rate_adv_dmg_acc([M|Ms], A1, A2, X, R) :-
  move(M,Type,Catpow,_,_,_,_,_,_),
  Catpow=..[Cat|Base_power],
  calculate_type_effectiveness(Type,A2,TE),
  calculate_stab(A1,Type,Stab),
  atk_stat_by_category(A1,Cat,Atk),
  def_stat_by_category(A2,Cat,Def),
  Pseudo_dmg is 22*Base_power*Atk/(50*Def)*TE*Stab/1,
  hp_frame(A2, kp(Cur,_)),
  P_value is 100 - max(Cur - Pseudo_dmg, 0),
  XX is (max(X,P_value)),
  rate_adv_dmg_acc(Ms, A1, A2, XX, R).
rate_adv_dmg_acc([], _, _, X, R) :-
  R = X. % eventually adjust

rate_adv_team(Team, R) :-
  rate_adv_team_acc(Team, 0, R).
% accumulator
rate_adv_team_acc([P|Ps], X, R) :-
  hp_percent(P, Perc),
  rate_adv_ailment(P, AR),
  XX is X + Perc*AR,
  rate_adv_team_acc(Ps, XX, R).
rate_adv_team_acc([], X, R) :-
  R = X/6. % eventually adjust

rate_adv_ailment(P, 1) :-
  primary_status_condition_category(P, nil).
rate_adv_ailment(P, 0) :-
  primary_status_condition_category(P, fainted).
rate_adv_ailment(P, 0.5) :-
  primary_status_condition_category(P, burn),
  stats(P, Atk, _, Spa, _, _),
  Atk > Spa, !.
rate_adv_ailment(P, 0.4) :-
  primary_status_condition_category(P, sleep).
rate_adv_ailment(P, 0.3) :-
  primary_status_condition_category(P, freeze).
rate_adv_ailment(P, 0.6) :-
  primary_status_condition_category(P, paralysis).
rate_adv_ailment(_, 0.75).
