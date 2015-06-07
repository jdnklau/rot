move_use_message(State, Who, Move, [user(uses(pokemon(Name), move(Move)))]) :-
  translate_attacker_state(State, Who, state([[Name|_]|_],_,_)).

set_up_pokemon(Name, Nature, Ability, [M1, M2, M3, M4], EV_DV, Item, Result) :-
  set_up_move(M1, Move_1),
  set_up_move(M2, Move_2),
  set_up_move(M3, Move_3),
  set_up_move(M4, Move_4),
  Moves = [Move_1, Move_2, Move_3, Move_4],
  pokemon(Name, _, stats(B_KP, B_Atk, B_Def, B_Spa, B_Spd, B_Ini),_),
  set_up_kp(B_KP, KP),
  set_up_stat(B_Atk, Raw_Atk),
  set_up_stat(B_Def, Raw_Def),
  set_up_stat(B_Spa, Raw_Spa),
  set_up_stat(B_Spd, Raw_Spd),
  set_up_stat(B_Ini, Raw_Ini),
  apply_nature(Nature,Raw_Atk, Raw_Def, Raw_Spa, Raw_Spd, Raw_Ini, Atk, Def, Spa, Spd, Ini),
  Result =
    [Name, kp(KP, KP), Moves,
      [Ability, stats(Atk, Def, Spa, Spd, Ini), stat_increases(0,0,0,0,0), EV_DV],
      Item, [nil, [nil, nil, nil], []]].

set_up_kp(Base_value, Stat_value) :-
  DV_and_EV is 0,
  Stat_value is (2*Base_value + DV_and_EV + 100)/2 + 10.

set_up_stat(Base_value, Stat_value) :-
  DV_and_EV is 0,
  Stat_value is (2*Base_value + DV_and_EV)/2 + 5.

apply_nature(_,Atk,Def,Spa,Spd,Ini,Atk,Def,Spa,Spd,Ini). % NYI

set_up_move(Name, [Name,PP]) :-
  move(Name, _, _, _, pp(PP), _, _, _, _).
