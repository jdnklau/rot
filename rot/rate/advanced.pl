rate_advanced(state(Player,Rot,_), Rating) :-
  rate_adv(Player, Rot, R_player),
  rate_adv(Rot, Player, R_rot),!,
  Rating is R_player-R_rot.

rate_adv(Ts, Os, Rate) :-
  rate_adv_team(Ts, Tr_sim),
  rate_adv_team(Os, Or_sim),
  Rate is Tr_sim-Or_sim.

rate_adv_ailment_factor(P, 1) :-
  primary_status_condition_category(P, nil).
rate_adv_ailment_factor(P, 0.6) :-
  primary_status_condition_category(P, paralysis).
rate_adv_ailment_factor(P, F) :-
  primary_status_condition_category(P, burn),
  stats(P,Atk,_,Spa,_,_),
  (
    Atk > Spa,!,
    F is 0.4
  ;
    F is 0.8
  ).
rate_adv_ailment_factor(P, 0.1) :-
  primary_status_condition_category(P, freeze).
rate_adv_ailment_factor(P, 0.2) :-
  primary_status_condition_category(P, sleep).
rate_adv_ailment_factor(_, 0.8). % other

rate_adv_team(Team, R) :-
  rate_adv_team_acc(Team,0,R).
%accumulator
rate_adv_team_acc([T|Ts],X,R) :-
  hp_percent(T,P),
  rate_adv_ailment_factor(T,F),
  XX is floor(X+P*F),
  rate_adv_team_acc(Ts,XX,R).
rate_adv_team_acc([],R,R).
