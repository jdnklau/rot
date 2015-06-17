%! move(Name, Type, Category, Accuracy, Power_points, Priority, Contact_information, Hits, Effects)
% @arg Name Name of the move
% @arg Type One of the 18 elemental types
% @arg Category Either `status` or `physical(Base_power)` or `special(Base_power)` where Base_power is an integer
% @arg Accuracy Accuracy of the move, has the form `acc(Probability)`
% @arg Power_points Power points of the move, has the form `pp(Integer)`
% @arg Priority Priority of the move, has the form `prio(P)` where P ranges from -7 to 7
% @arg Contact_information Information if move causes contact, either `contact` or `nocontact`
% @arg Hits Number of hits the move causes, either an integer or `between(Minimum, Maximum)`
% @arg Effects Either a list of effects inflicted by the move or `noeffect`
move('aerial ace', flying, physical(60), acc(always),pp(20), prio(0), contact, 1, noeffect).
move('air slash', flying, special(75), acc(95), pp(15), prio(0), nocontact, 1, [flinch(30)]).
move('aura sphere', fighting, special(80), acc(always), pp(20), prio(0), nocontact, 1, noeffect).
move(blizzard, ice, special(110), acc(70), pp(5), prio(0), nocontact, 1, [freeze(10)]).
move('body slam', normal, physical(85), acc(100), pp(15), prio(0), contact, 1, [paralyze(30)]).
move('brave bird', flying, physical(120), acc(100), pp(15), prio(0), contact, 1, [recoil(1/3)]).
move('brick break', fighting, physical(75), acc(100), pp(15), prio(0), contact, 1, [brickbreak]).
move(crunch, dark, physical(80), acc(100), pp(15), prio(0), contact, 1, [def(target, 20, -1)]).
move('dark pulse', dark, special(80), acc(100), pp(15), prio(0), nocontact, 1, [flinch(20)]).
move('dragon pulse', dragon, special(85), acc(100), pp(10), prio(0), nocontact, 1, noeffect).
move('double hit', normal, physical(35), acc(90), pp(10), prio(0), contact, 2, noeffect).
move('earth power', ground, special(90), acc(100), pp(10), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move(earthquake, ground, physical(100), acc(100), pp(10), prio(0), nocontact, 1, noeffect).
move('energy ball', grass, special(90), acc(100), pp(10), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move('fake out', normal, physical(40), acc(100), pp(10), prio(3), contact, 1, [flinch(100), need(just_in)]).
move('fire blast', fire, special(110), acc(85), pp(10), prio(0), nocontact, 1, [burn(30)]).
move(flamethrower, fire, special(90), acc(100), pp(15), prio(0), nocontact, 1, [burn(10)]).
move('flash cannon', steel, special(80), acc(100), pp(10), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move('focus blast', fighting, special(120), acc(70), pp(5), prio(0), nocontact, 1, [spd(target, 10, -1)]).
move('hydro pump', water, special(110), acc(80), pp(10), prio(0), nocontact, 1, noeffect).
move('ice beam', ice, special(90), acc(100), pp(10), prio(0), nocontact, 1, [freeze(10)]).
move('ice shard', ice, physical(40), acc(100), pp(30), prio(1), nocontact, 1, noeffect).
move('iron tail', steel, physical(100), acc(75), pp(15), prio(0), contact, 1, [def(target, 30, -1)]).
move('knock off', dark, physical(65), acc(100), pp(25), prio(0), contact, 1, [lose_item(target)]).
move('lava plume', fire, special(80), acc(100), pp(15), prio(0), nocontact, 1, [burn(30)]).
move('leaf storm', grass, special(130), acc(90), pp(5), prio(0), nocontact, 1, [spa(user, 100, -2)]).
move(moonblast, fairy, special(95), acc(100), pp(15), prio(0), nocontact, 1, [spa(target, 30, -1)]).
move(protect, normal, status, acc(always), pp(10), prio(0), nocontact, 1, [protect]).
move('rapid spin', normal, physical(20), acc(100), pp(40), prio(0), contact, 1, [spin]).
move('roost', flying, status, acc(always), pp(10), prio(0), nocontact, 1, [heal(50, percent), rooststate]).
move(scald, water, special(80), acc(100), pp(15), prio(0), nocontact, 1, [burn(30)]).
move('seed bomb', grass, physical(80), acc(100), pp(15), prio(0), nocontact, 1, noeffect).
move('sleep powder', grass, status, acc(75), pp(15), prio(0), nocontact, 1, [sleep(100)]).
move('sludge bomb', poison, special(90), acc(100), pp(10), prio(0), nocontact, 1, [poison(30)]).
move('sludge wave', poison, special(95), acc(100), pp(10), prio(0), nocontact, 1, [poison(10)]).
move(spikes, ground, status, acc(always), pp(20), prio(0), nocontact, 1, [spikes]).
move('stealth rock', rock, status, acc(always), pp(20), prio(0), nocontact, 1, [stealthrock]).
move(thunderbolt, electric, special(90), acc(100), pp(15), prio(0), nocontact, 1, [paralyze(10)]).
move(toxic, poison, status, acc(90), pp(10), prio(0), nocontact, 1, [toxin(100)]).
move('u-turn', bug, physical(70), acc(100), pp(20), prio(0), contact, 1, [switchuser]).
move('volt tackle', electric, physical(120), acc(100), pp(15), prio(0), contact, 1, [recoil(33), paralyze(10)]).
move(wish, normal, status, acc(always), pp(10), prio(0), nocontact, 1, [wish]).
