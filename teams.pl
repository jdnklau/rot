team_1([P1,P2,P3]) :-
  set_up_pokemon(venusaur, _, chlorophyll,
    [earthquake, 'sludge wave', 'energy ball', toxic],
    _, noitem, P1),
  set_up_pokemon(charizard, _, 'solar power',
    [flamethrower, 'air slash', 'brave bird', roost],
    _, noitem, P2),
  set_up_pokemon(blastoise, _, 'rain dish',
    [scald, 'rapid spin', 'aura sphere', 'flash cannon'],
    _, noitem, P3).
