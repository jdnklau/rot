move('aerial ace', flying, physical(60), acc(always),pp(20), prio(0), contact, 1, noeffect).
move('air slash', flying, special(75), acc(95), pp(15), prio(0), nocontact, 1, [flinch(30)]).
move('aura sphere', fighting, special(80), acc(always), pp(20), prio(0), nocontact, 1, noeffect).
move('brave bird', flying, physical(120), acc(100), pp(15), prio(0), contact, 1, [recoil(33)]).
move('dark pulse', dark, special(80), acc(100), pp(15), prio(0), nocontact, 1, [flinch(20)]).
move('dragon pulse', dragon, special(85), acc(100), pp(10), prio(0), nocontact, 1, noeffect).
move('double hit', normal, physical(35), acc(90), pp(10), prio(0), contact, 2, noeffect).
move('earth power', ground, special(90), acc(100), pp(10), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move(earthquake, ground, physical(100), acc(100), pp(10), prio(0), nocontact, 1, noeffect).
move('energy ball', grass, special(90), acc(100), pp(10), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move('fake out', normal, physical(40), acc(100), pp(10), prio(3), contact, 1, [flinch(100), need(just_in)]).
move(flamethrower, fire, special(90), acc(100), pp(15), prio(0), nocontact, 1, [burn(10)]).
move('flash cannon', steel, special(80), acc(100), pp(10), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move('knock off', dark, physical(65), acc(100), pp(25), prio(0), contact, 1, [lose_item(target)]).
move('lava plume', fire, special(80), acc(100), pp(15), prio(0), nocontact, 1, [burn(30)]).
move(moonblast, fairy, special(95), acc(100), pp(15), prio(0), nocontact, 1, [spa(target, 30, -1)]).
move(protect, normal, status, acc(always), pp(10), prio(0), nocontact, 1, [protect]).
move('rapid spin', normal, physical(20), acc(100), pp(40), prio(0), contact, 1, [spin]).
move('roost', flying, status, acc(always), pp(10), prio(0), nocontact, 1, [heal(50, percent), rooststate]).
move(scald, water, special(80), acc(100), pp(15), prio(0), nocontact, 1, [burn(30)]).
move('sludge wave', poison, special(95), acc(100), pp(10), prio(0), nocontact, 1, [poison(10)]).
move(spikes, ground, status, acc(always), pp(20), prio(0), nocontact, 1, [spikes]).
move('stealth rock', rock, status, acc(always), pp(20), prio(0), nocontact, 1, [stealthrock]).
move(toxic, poison, status, acc(90), pp(10), prio(0), nocontact, 1, [toxin(100)]).
move('u-turn', bug, physical(70), acc(100), pp(20), prio(0), contact, 1, [switchuser]).
move(wish, normal, status, acc(always), pp(10), prio(0), nocontact, 1, [wish]).
