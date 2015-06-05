% types
type(normal).
type(fighting).
type(flying).
type(poison).
type(ground).
type(rock).
type(bug).
type(ghost).
type(steel).
type(fire).
type(water).
type(grass).
type(electric).
type(psychic).
type(ice).
type(dragon).
type(dark).
type(fairy).

% type effects
typing(normal, rock, 0.5).
typing(normal, ghost, 0).
typing(normal, steel, 0.5).
typing(fighting, normal, 2).
typing(fighting, flying, 0.5).
typing(fighting, poison, 0.5).
typing(fighting, rock, 2).
typing(fighting, bug, 0.5).
typing(fighting, ghost, 0).
typing(fighting, steel, 2).
typing(fighting, psychic, 0.5).
typing(fighting, ice, 2).
typing(fighting, dark, 2).
typing(fighting, fairy, 0.5).
typing(flying, fighting, 2).
typing(flying, rock, 0.5).
typing(flying, bug, 2).
typing(flying, steel, 0.5).
typing(flying, grass, 2).
typing(flying, electric, 0.5).
typing(poison, poison, 0.5).
typing(poison, ground, 0.5).
typing(poison, rock, 0.5).
typing(poison, ghost, 0.5).
typing(poison, steel, 0).
typing(poison, grass, 2).
typing(poison, fairy, 2).
typing(ground, flying, 0).
typing(ground, poison, 2).
typing(ground, rock, 2).
typing(ground, bug, 0.5).
typing(ground, steel, 2).
typing(ground, fire, 2).
typing(ground, grass, 0.5).
typing(ground, electric, 2).
typing(rock, fighting, 0.5).
typing(rock, flying, 2).
typing(rock, ground, 0.5).
typing(rock, bug, 2).
typing(rock, steel, 0.5).
typing(rock, fire, 2).
typing(rock, ice, 2).
typing(bug, fighting, 0.5).
typing(bug, flying, 0.5).
typing(bug, poison, 0.5).
typing(bug, ghost, 0.5).
typing(bug, steel, 0.5).
typing(bug, fire, 0.5).
typing(bug, grass, 2).
typing(bug, psychic, 2).
typing(bug, dark, 2).
typing(bug, fairy, 0.5).
typing(ghost, normal, 0).
typing(ghost, ghost, 2).
typing(ghost, psychic, 2).
typing(ghost, dark, 0.5).
typing(steel, rock, 2).
typing(steel, steel, 0.5).
typing(steel, fire, 0.5).
typing(steel, water, 0.5).
typing(steel, electric, 0.5).
typing(steel, ice, 2).
typing(steel, fairy, 2).
typing(fire, rock, 0.5).
typing(fire, bug, 2).
typing(fire, steel, 2).
typing(fire, fire, 0.5).
typing(fire, water, 0.5).
typing(fire, grass, 2).
typing(fire, ice, 2).
typing(fire, dragon, 0.5).
typing(water, ground, 2).
typing(water, rock, 2).
typing(water, fire, 2).
typing(water, water, 0.5).
typing(water, grass, 0.5).
typing(water, dragon, 0.5).
typing(grass, flying, 0.5).
typing(grass, poison, 0.5).
typing(grass, ground, 2).
typing(grass, rock, 2).
typing(grass, bug, 0.5).
typing(grass, steel, 0.5).
typing(grass, fire, 0.5).
typing(grass, water, 2).
typing(grass, grass, 0.5).
typing(grass, dragon, 0.5).
typing(electric, flying, 2).
typing(electric, ground, 0).
typing(electric, water, 2).
typing(electric, grass, 0.5).
typing(electric, electric, 0.5).
typing(electric, dragon, 0.5).
typing(psychic, fighting, 2).
typing(psychic, poison, 2).
typing(psychic, steel, 0.5).
typing(psychic, psychic, 0.5).
typing(psychic, dark, 0).
typing(ice, flying, 2).
typing(ice, ground, 2).
typing(ice, steel, 0.5).
typing(ice, fire, 0.5).
typing(ice, water, 0.5).
typing(ice, grass, 2).
typing(ice, ice, 0.5).
typing(ice, dragon, 2).
typing(dragon, steel, 0.5).
typing(dragon, dragon, 2).
typing(dragon, fairy, 0).
typing(dark, fighting, 0.5).
typing(dark, ghost, 2).
typing(dark, psychic, 2).
typing(dark, dark, 0.5).
typing(dark, fairy, 0.5).
typing(fairy, fighting, 2).
typing(fairy, poison, 0.5).
typing(fairy, steel, 0.5).
typing(fairy, fire, 0.5).
typing(fairy, dragon, 2).
typing(fairy, dark, 2).
typing(_, nil, 1).
