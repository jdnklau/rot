rate_advantage(state(Team_player, Team_rot, _), Rating) :-
  rate_advantage_team(Team_player, Team_rot, R_player),
  rate_advantage_team(Team_rot, Team_player, R_rot),
  Rating is R_player - R_rot.

rate_advantage_team([P|Ps], Opp_team, R) :-
  rate_advantage_team_acc(Opp_team, P, 0, R).

rate_advantage_team_acc([O|Os], P, Advs, R) :-
  \+ fainted(P),
  hp_percent(P, Hp_p),
  hp_percent(O, Hp_o),
  rate_adv_ailment_factor(P, F_p),
  rate_adv_ailment_factor(O, F_o),
  (
    Hp_p * F_p > 1.2 * Hp_o * F_o
  ;
    stats(O, _, Def_o, _, Spd_o, _),
    stats(P, Atk_p, _, Spa_p, _, _),
    (
      Atk_p > Spa_p,
      1.3* Atk_p > Def_o % semi accounting for STAB
    ;
      1.3* Spa_p > Spd_o
    ),
    rate_advantage_type_eff(P,O)
  ),!,
  AA is Advs+1,
  rate_advantage_team_acc(Os, P, AA, R).
rate_advantage_team_acc([_|Os], P, Advs, R) :-
  rate_advantage_team_acc(Os,P,Advs,R).
rate_advantage_team_acc([],_,R,R).

rate_advantage_type_eff(P, O) :-
  types(P,T_p),
  types(O,T_o),
  rate_advantage_type_eff_acc(T_p, T_o).
rate_advantage_type_eff_acc([T|Ts], Opp_ts) :-
  calculate_type_effectiveness(T, Opp_ts, E),
  E > 1,!.
rate_advantage_type_eff_acc([T|Ts], Opp_ts) :-
  rate_advantage_type_eff_acc(Ts, Opp_ts).
