team_1([P1,P2,P3]) :-
  set_up_pokemon(venusaur, _, chlorophyll,
    [earthquake, sludge-wave, energy-ball, toxic],
    _, noitem, P1),
  set_up_pokemon(charizard, _, 'solar power',
    [flamethrower, air-slash, brave-bird, roost],
    _, noitem, P2),
  set_up_pokemon(blastoise, _, 'rain dish',
    [scald, rapid-spin, aura-sphere, flash-cannon],
    _, noitem, P3).

team_rot([P1, P2, P3, P4, P5, P6]) :-
  set_up_pokemon(pikachu, _, static,
    [volt-tackle, iron-tail, brick-break, fake-out],
    _, 'light ball', P1),
  set_up_pokemon(lapras, _, 'water absorb',
    [hydro-pump, ice-beam, thunderbolt, ice-shard],
    _, 'sitrus berry', P2),
  set_up_pokemon(snorlax, _, 'thick fat',
    [body-slam, crunch, earthquake, seed-bomb],
    _, quick-claw, P3),
  set_up_pokemon(venusaur, _, overgrow,
    [leaf-storm, sleep-powder, sludge-bomb, earthquake],
    _, 'white herb', P4),
  set_up_pokemon(charizard, _, blaze,
    [fire-blast, air-slash, focus-blast, dragon-pulse],
    _, 'focus sash', P5),
  set_up_pokemon(blastoise, _, torrent,
    [ice-beam, hydro-pump, blizzard, focus-blast],
    _, 'choice scarf', P6).
