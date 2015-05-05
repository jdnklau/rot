team_one([P1,P2,P3]) :-
  P1 = [venusaur, kp(100, 100), [[earthquake,20], ['sludge wave',20], ['energy ball',20], [toxic,20]],_Stats1,noitem,[]],
  P2 = [charizard, kp(100, 100), [[flamethrower,20], ['air slash',20], [roost,20], ['brave bird',20]],_Stats2,noitem,[]],
  P3 = [blastoise, kp(100, 100), [[scald,20], ['rapid spin',20], ['aura sphere',20], ['flash canon',20]],_Stats3,noitem,[]].

team_1([P1,P2,P3]) :-
  set_up_pokemon(venusaur, _, chlorophyll,
    [earthquake, 'sludge wave', 'energy ball', toxic],
    _, noitem, P1),
  set_up_pokemon(charizard, _, 'solar power',
    [flamethrower, 'air slash', 'brave bird', roost],
    _, noitem, P2),
  set_up_pokemon(blastoise, _, 'rain dish',
    [scald, 'rapid spin', 'aura sphere', 'flash canon'],
    _, noitem, P3).
