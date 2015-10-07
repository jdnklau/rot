rate(State, R) :-
  rot(active_instance(I)),
  rot(instance(I, [_,Rate])),
  rate(State,Rate,R).
rate(State,simple,R) :-
  rate_simple(State,R).
rate(State,advanced,R) :-
  rate_advanced(State, R).

rate_simple(state(Player, Rot, _), (Rating_p, Rating_r)) :-
  rate_simple_team(Player, Rating_p),
  rate_simple_team(Rot, Rating_r).

rate_simple_team(Team, Rating) :-
  rate_simple_team_acc(Team, Rating, 0, 0).
rate_simple_team_acc([Top|Rest], Rating, Num, Curr_p) :-
  New_num is Num+1,
  hp_percent(Top, Next_p),
  New_p is Curr_p+Next_p,
  rate_simple_team_acc(Rest, Rating, New_num, New_p).
rate_simple_team_acc([], Rating, Num, P) :-
  Rating is P / Num.

better_rating((R11, R12), (R21, R22), player) :-
  A is R11-R12,
  B is R21-R22,
  A>B.
better_rating((R11, R12), (R21, R22), rot) :-
  A is R12-R11,
  B is R22-R21,
  A>B.
