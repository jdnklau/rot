%! move(Name, Type, Category, Accuracy, Power_points, Priority, Flags, Hits, Effects)
% @arg Name Name of the move
% @arg Type One of the 18 elemental types
% @arg Category Either `status` or `physical(Base_power)` or `special(Base_power)` where `Base_power` is an integer
% @arg Accuracy Accuracy of the move, has the form `acc(Probability)`
% @arg Power_points Power points of the move, has the form `pp(Integer)`
% @arg Priority Priority of the move, has the form `prio(P)` where P ranges from -7 to 7
% @arg Flags A list of flags set for this move
% @arg Hits Number of hits the move causes, either an integer or `between(Minimum, Maximum)`
% @arg Effects A list of effects inflicted by the move (may be empty)
move(pound,normal,physical(40),acc(100),pp(35),prio(0),[contact,protect,mirror],1,[]).
move(karate-chop,fighting,physical(50),acc(100),pp(25),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(double-slap,normal,physical(15),acc(85),pp(10),prio(0),[contact,protect,mirror],between(2,5),[]).
move(comet-punch,normal,physical(18),acc(85),pp(15),prio(0),[contact,protect,mirror,punch],between(2,5),[]).
move(mega-punch,normal,physical(80),acc(85),pp(20),prio(0),[contact,protect,mirror,punch],1,[]).
move(pay-day,normal,physical(40),acc(100),pp(20),prio(0),[protect,mirror],1,[]).
move(fire-punch,fire,physical(75),acc(100),pp(15),prio(0),[contact,protect,mirror,punch],1,[ailment(burn,10)]).
move(ice-punch,ice,physical(75),acc(100),pp(15),prio(0),[contact,protect,mirror,punch],1,[ailment(freeze,10)]).
move(thunder-punch,electric,physical(75),acc(100),pp(15),prio(0),[contact,protect,mirror,punch],1,[ailment(paralysis,10)]).
move(scratch,normal,physical(40),acc(100),pp(35),prio(0),[contact,protect,mirror],1,[]).
move(vice-grip,normal,physical(55),acc(100),pp(30),prio(0),[contact,protect,mirror],1,[]).
move(guillotine,normal,physical(ohko),acc(30),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(razor-wind,normal,special(80),acc(100),pp(10),prio(0),[high-crit,charge,protect,mirror],1,[]).
move(swords-dance,normal,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (attack,2)])]).
move(cut,normal,physical(50),acc(95),pp(30),prio(0),[contact,protect,mirror],1,[]).
move(gust,flying,special(40),acc(100),pp(35),prio(0),[protect,mirror],1,[]).
move(wing-attack,flying,physical(60),acc(100),pp(35),prio(0),[contact,protect,mirror],1,[]).
move(whirlwind,normal,status,acc(always),pp(20),prio(-6),[reflectable,mirror,authentic],1,[forceswitch(target)]).
move(fly,flying,physical(90),acc(95),pp(15),prio(0),[contact,charge,protect,mirror,gravity],1,[]).
move(bind,normal,physical(15),acc(85),pp(20),prio(0),[contact,protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(slam,normal,physical(80),acc(75),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(vine-whip,grass,physical(45),acc(100),pp(25),prio(0),[contact,protect,mirror],1,[]).
move(stomp,normal,physical(65),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(double-kick,fighting,physical(30),acc(100),pp(30),prio(0),[contact,protect,mirror],2,[]).
move(mega-kick,normal,physical(120),acc(75),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(jump-kick,fighting,physical(100),acc(95),pp(10),prio(0),[contact,protect,mirror,gravity],1,[]).
move(rolling-kick,fighting,physical(60),acc(85),pp(15),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(sand-attack,ground,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (accuracy,-1)])]).
move(headbutt,normal,physical(70),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(horn-attack,normal,physical(65),acc(100),pp(25),prio(0),[contact,protect,mirror],1,[]).
move(fury-attack,normal,physical(15),acc(85),pp(20),prio(0),[contact,protect,mirror],between(2,5),[]).
move(horn-drill,normal,physical(ohko),acc(30),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(tackle,normal,physical(50),acc(100),pp(35),prio(0),[contact,protect,mirror],1,[]).
move(body-slam,normal,physical(85),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[ailment(paralysis,30)]).
move(wrap,normal,physical(15),acc(90),pp(20),prio(0),[contact,protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(take-down,normal,physical(90),acc(85),pp(20),prio(0),[contact,protect,mirror],1,[drain(-25)]).
move(thrash,normal,physical(120),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(double-edge,normal,physical(120),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[drain(-33)]).
move(tail-whip,normal,status,acc(100),pp(30),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (defense,-1)])]).
move(poison-sting,poison,physical(15),acc(100),pp(35),prio(0),[protect,mirror],1,[ailment(poison,30)]).
move(twineedle,bug,physical(25),acc(100),pp(20),prio(0),[protect,mirror],2,[ailment(poison,20)]).
move(pin-missile,bug,physical(25),acc(95),pp(20),prio(0),[protect,mirror],between(2,5),[]).
move(leer,normal,status,acc(100),pp(30),prio(0),[protect,reflectable,mirror],1,[stats(target,100,[ (defense,-1)])]).
move(bite,dark,physical(60),acc(100),pp(25),prio(0),[contact,protect,mirror,bite],1,[flinch(30)]).
move(growl,normal,status,acc(100),pp(40),prio(0),[protect,reflectable,mirror,sound,authentic],1,[stats(target,always,[ (attack,-1)])]).
move(roar,normal,status,acc(always),pp(20),prio(-6),[reflectable,mirror,sound,authentic],1,[forceswitch(target)]).
move(sing,normal,status,acc(55),pp(15),prio(0),[protect,reflectable,mirror,sound,authentic],1,[ailment(sleep,always,between(2,4))]).
move(supersonic,normal,status,acc(55),pp(20),prio(0),[protect,reflectable,mirror,sound,authentic],1,[ailment(confusion,always,between(2,5))]).
move(sonic-boom,normal,special(variable),acc(90),pp(20),prio(0),[protect,mirror],1,[]).
move(disable,normal,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror,authentic],1,[unique]).
move(acid,poison,special(40),acc(100),pp(30),prio(0),[protect,mirror],1,[stats(target,10,[ (special-defense,-1)])]).
move(ember,fire,special(40),acc(100),pp(25),prio(0),[protect,mirror],1,[ailment(burn,10)]).
move(flamethrower,fire,special(90),acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(burn,10)]).
move(mist,ice,status,acc(always),pp(30),prio(0),[snatch],1,[field]).
move(water-gun,water,special(40),acc(100),pp(25),prio(0),[protect,mirror],1,[]).
move(hydro-pump,water,special(110),acc(80),pp(5),prio(0),[protect,mirror],1,[]).
move(surf,water,special(90),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(ice-beam,ice,special(90),acc(100),pp(10),prio(0),[protect,mirror],1,[ailment(freeze,10)]).
move(blizzard,ice,special(110),acc(70),pp(5),prio(0),[protect,mirror],1,[ailment(freeze,10)]).
move(psybeam,psychic,special(65),acc(100),pp(20),prio(0),[protect,mirror],1,[ailment(confusion,10,between(2,5))]).
move(bubble-beam,water,special(65),acc(100),pp(20),prio(0),[protect,mirror],1,[stats(target,10,[ (speed,-1)])]).
move(aurora-beam,ice,special(65),acc(100),pp(20),prio(0),[protect,mirror],1,[stats(target,10,[ (attack,-1)])]).
move(hyper-beam,normal,special(150),acc(90),pp(5),prio(0),[recharge,protect,mirror],1,[]).
move(peck,flying,physical(35),acc(100),pp(35),prio(0),[contact,protect,mirror],1,[]).
move(drill-peck,flying,physical(80),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(submission,fighting,physical(80),acc(80),pp(20),prio(0),[contact,protect,mirror],1,[drain(-25)]).
move(low-kick,fighting,physical(variable),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(counter,fighting,physical(variable),acc(100),pp(20),prio(-5),[contact,protect],1,[]).
move(seismic-toss,fighting,physical(variable),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(strength,normal,physical(80),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(absorb,grass,special(20),acc(100),pp(25),prio(0),[protect,mirror,heal],1,[drain(50)]).
move(mega-drain,grass,special(40),acc(100),pp(15),prio(0),[protect,mirror,heal],1,[drain(50)]).
move(leech-seed,grass,status,acc(90),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(leech-seed,always)]).
move(growth,normal,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (special-attack,1)])]).
move(razor-leaf,grass,physical(55),acc(95),pp(25),prio(0),[high-crit,protect,mirror],1,[]).
move(solar-beam,grass,special(120),acc(100),pp(10),prio(0),[charge,protect,mirror],1,[]).
move(poison-powder,poison,status,acc(75),pp(35),prio(0),[protect,reflectable,mirror,powder],1,[ailment(poison,always)]).
move(stun-spore,grass,status,acc(75),pp(30),prio(0),[protect,reflectable,mirror,powder],1,[ailment(paralysis,always)]).
move(sleep-powder,grass,status,acc(75),pp(15),prio(0),[protect,reflectable,mirror,powder],1,[ailment(sleep,always,between(2,4))]).
move(petal-dance,grass,special(120),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(string-shot,bug,status,acc(95),pp(40),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (speed,-2)])]).
move(dragon-rage,dragon,special(variable),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(fire-spin,fire,special(35),acc(85),pp(15),prio(0),[protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(thunder-shock,electric,special(40),acc(100),pp(30),prio(0),[protect,mirror],1,[ailment(paralysis,10)]).
move(thunderbolt,electric,special(90),acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(paralysis,10)]).
move(thunder-wave,electric,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[ailment(paralysis,always)]).
move(thunder,electric,special(110),acc(70),pp(10),prio(0),[protect,mirror],1,[ailment(paralysis,30)]).
move(rock-throw,rock,physical(50),acc(90),pp(15),prio(0),[protect,mirror],1,[]).
move(earthquake,ground,physical(100),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(fissure,ground,physical(ohko),acc(30),pp(5),prio(0),[protect,mirror],1,[]).
move(dig,ground,physical(80),acc(100),pp(10),prio(0),[contact,charge,protect,mirror],1,[]).
move(toxic,poison,status,acc(90),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(bad-poison,always)]).
move(confusion,psychic,special(50),acc(100),pp(25),prio(0),[protect,mirror],1,[ailment(confusion,10,between(2,5))]).
move(psychic,psychic,special(90),acc(100),pp(10),prio(0),[protect,mirror],1,[stats(target,10,[ (special-defense,-1)])]).
move(hypnosis,psychic,status,acc(60),pp(20),prio(0),[protect,reflectable,mirror],1,[ailment(sleep,always,between(2,4))]).
move(meditate,psychic,status,acc(always),pp(40),prio(0),[snatch],1,[stats(user,always,[ (attack,1)])]).
move(agility,psychic,status,acc(always),pp(30),prio(0),[snatch],1,[stats(user,always,[ (speed,2)])]).
move(quick-attack,normal,physical(40),acc(100),pp(30),prio(1),[contact,protect,mirror],1,[]).
move(rage,normal,physical(20),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(teleport,psychic,status,acc(always),pp(20),prio(0),[],1,[unique]).
move(night-shade,ghost,special(variable),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(mimic,normal,status,acc(always),pp(10),prio(0),[protect,authentic],1,[unique]).
move(screech,normal,status,acc(85),pp(40),prio(0),[protect,reflectable,mirror,sound,authentic],1,[stats(target,always,[ (defense,-2)])]).
move(double-team,normal,status,acc(always),pp(15),prio(0),[snatch],1,[stats(user,always,[ (evasion,1)])]).
move(recover,normal,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(50)]).
move(harden,normal,status,acc(always),pp(30),prio(0),[snatch],1,[stats(user,always,[ (defense,1)])]).
move(minimize,normal,status,acc(always),pp(10),prio(0),[snatch],1,[stats(user,always,[ (evasion,2)])]).
move(smokescreen,normal,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (accuracy,-1)])]).
move(confuse-ray,ghost,status,acc(100),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(confusion,always,between(2,5))]).
move(withdraw,water,status,acc(always),pp(40),prio(0),[snatch],1,[stats(user,always,[ (defense,1)])]).
move(defense-curl,normal,status,acc(always),pp(40),prio(0),[snatch],1,[stats(user,always,[ (defense,1)])]).
move(barrier,psychic,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (defense,2)])]).
move(light-screen,psychic,status,acc(always),pp(30),prio(0),[snatch],1,[field]).
move(haze,ice,status,acc(always),pp(30),prio(0),[authentic],1,[field]).
move(reflect,psychic,status,acc(always),pp(20),prio(0),[snatch],1,[field]).
move(focus-energy,normal,status,acc(always),pp(30),prio(0),[snatch],1,[unique]).
move(bide,normal,physical(variable),acc(always),pp(10),prio(1),[contact,protect],1,[]).
move(metronome,normal,status,acc(always),pp(10),prio(0),[],1,[unique]).
move(mirror-move,flying,status,acc(always),pp(20),prio(0),[],1,[unique]).
move(self-destruct,normal,physical(200),acc(100),pp(5),prio(0),[protect,mirror],1,[]).
move(egg-bomb,normal,physical(100),acc(75),pp(10),prio(0),[protect,mirror,ballistics],1,[]).
move(lick,ghost,physical(30),acc(100),pp(30),prio(0),[contact,protect,mirror],1,[ailment(paralysis,30)]).
move(smog,poison,special(30),acc(70),pp(20),prio(0),[protect,mirror],1,[ailment(poison,40)]).
move(sludge,poison,special(65),acc(100),pp(20),prio(0),[protect,mirror],1,[ailment(poison,30)]).
move(bone-club,ground,physical(65),acc(85),pp(20),prio(0),[protect,mirror],1,[flinch(10)]).
move(fire-blast,fire,special(110),acc(85),pp(5),prio(0),[protect,mirror],1,[ailment(burn,10)]).
move(waterfall,water,physical(80),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[flinch(20)]).
move(clamp,water,physical(35),acc(85),pp(15),prio(0),[contact,protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(swift,normal,special(60),acc(always),pp(20),prio(0),[protect,mirror],1,[]).
move(skull-bash,normal,physical(130),acc(100),pp(10),prio(0),[contact,charge,protect,mirror],1,[]).
move(spike-cannon,normal,physical(20),acc(100),pp(15),prio(0),[protect,mirror],between(2,5),[]).
move(constrict,normal,physical(10),acc(100),pp(35),prio(0),[contact,protect,mirror],1,[stats(target,10,[ (speed,-1)])]).
move(amnesia,psychic,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (special-defense,2)])]).
move(kinesis,psychic,status,acc(80),pp(15),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (accuracy,-1)])]).
move(soft-boiled,normal,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(50)]).
move(high-jump-kick,fighting,physical(130),acc(90),pp(10),prio(0),[contact,protect,mirror,gravity],1,[]).
move(glare,normal,status,acc(100),pp(30),prio(0),[protect,reflectable,mirror],1,[ailment(paralysis,always)]).
move(dream-eater,psychic,special(100),acc(100),pp(15),prio(0),[protect,mirror,heal],1,[drain(50)]).
move(poison-gas,poison,status,acc(90),pp(40),prio(0),[protect,reflectable,mirror],1,[ailment(poison,always)]).
move(barrage,normal,physical(15),acc(85),pp(20),prio(0),[protect,mirror,ballistics],between(2,5),[]).
move(leech-life,bug,physical(20),acc(100),pp(15),prio(0),[contact,protect,mirror,heal],1,[drain(50)]).
move(lovely-kiss,normal,status,acc(75),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(sleep,always,between(2,4))]).
move(sky-attack,flying,physical(140),acc(90),pp(5),prio(0),[high-crit,charge,protect,mirror],1,[flinch(30)]).
move(transform,normal,status,acc(always),pp(10),prio(0),[],1,[unique]).
move(bubble,water,special(40),acc(100),pp(30),prio(0),[protect,mirror],1,[stats(target,10,[ (speed,-1)])]).
move(dizzy-punch,normal,physical(70),acc(100),pp(10),prio(0),[contact,protect,mirror,punch],1,[ailment(confusion,20,between(2,5))]).
move(spore,grass,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror,powder],1,[ailment(sleep,always,between(2,4))]).
move(flash,normal,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (accuracy,-1)])]).
move(psywave,psychic,special(variable),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(splash,normal,status,acc(always),pp(40),prio(0),[gravity],1,[unique]).
move(acid-armor,poison,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (defense,2)])]).
move(crabhammer,water,physical(100),acc(90),pp(10),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(explosion,normal,physical(250),acc(100),pp(5),prio(0),[protect,mirror],1,[]).
move(fury-swipes,normal,physical(18),acc(80),pp(15),prio(0),[contact,protect,mirror],between(2,5),[]).
move(bonemerang,ground,physical(50),acc(90),pp(10),prio(0),[protect,mirror],2,[]).
move(rest,psychic,status,acc(always),pp(10),prio(0),[snatch,heal],1,[unique]).
move(rock-slide,rock,physical(75),acc(90),pp(10),prio(0),[protect,mirror],1,[flinch(30)]).
move(hyper-fang,normal,physical(80),acc(90),pp(15),prio(0),[contact,protect,mirror],1,[flinch(10)]).
move(sharpen,normal,status,acc(always),pp(30),prio(0),[snatch],1,[stats(user,always,[ (attack,1)])]).
move(conversion,normal,status,acc(always),pp(30),prio(0),[snatch],1,[unique]).
move(tri-attack,normal,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[ailment(unknown,20)]).
move(super-fang,normal,physical(variable),acc(90),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(slash,normal,physical(70),acc(100),pp(20),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(substitute,normal,status,acc(always),pp(10),prio(0),[snatch],1,[unique]).
move(struggle,normal,physical(50),acc(always),pp(nil),prio(0),[contact,protect],1,[heal(-25)]).
move(sketch,normal,status,acc(always),pp(1),prio(0),[authentic],1,[unique]).
move(triple-kick,fighting,physical(10),acc(90),pp(10),prio(0),[contact,protect,mirror],3,[]).
move(thief,dark,physical(60),acc(100),pp(25),prio(0),[contact,protect,mirror],1,[]).
move(spider-web,bug,status,acc(always),pp(10),prio(0),[protect,reflectable,mirror],1,[unique]).
move(mind-reader,normal,status,acc(always),pp(5),prio(0),[protect,mirror],1,[unique]).
move(nightmare,ghost,status,acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(nightmare,always)]).
move(flame-wheel,fire,physical(60),acc(100),pp(25),prio(0),[contact,protect,mirror,defrost],1,[ailment(burn,10)]).
move(snore,normal,special(50),acc(100),pp(15),prio(0),[protect,mirror,sound,authentic],1,[flinch(30)]).
move(curse,ghost,status,acc(always),pp(10),prio(0),[authentic],1,[unique]).
move(flail,normal,physical(variable),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(conversion-2,normal,status,acc(always),pp(30),prio(0),[authentic],1,[unique]).
move(aeroblast,flying,special(100),acc(95),pp(5),prio(0),[high-crit,protect,mirror],1,[]).
move(cotton-spore,grass,status,acc(100),pp(40),prio(0),[protect,reflectable,mirror,powder],1,[stats(target,always,[ (speed,-2)])]).
move(reversal,fighting,physical(variable),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(spite,ghost,status,acc(100),pp(10),prio(0),[protect,reflectable,mirror,authentic],1,[unique]).
move(powder-snow,ice,special(40),acc(100),pp(25),prio(0),[protect,mirror],1,[ailment(freeze,10)]).
move(protect,normal,status,acc(always),pp(10),prio(4),[],1,[unique]).
move(mach-punch,fighting,physical(40),acc(100),pp(30),prio(1),[contact,protect,mirror,punch],1,[]).
move(scary-face,normal,status,acc(100),pp(10),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (speed,-2)])]).
move(feint-attack,dark,physical(60),acc(always),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(sweet-kiss,fairy,status,acc(75),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(confusion,always,between(2,5))]).
move(belly-drum,normal,status,acc(always),pp(10),prio(0),[snatch],1,[unique]).
move(sludge-bomb,poison,special(90),acc(100),pp(10),prio(0),[protect,mirror,ballistics],1,[ailment(poison,30)]).
move(mud-slap,ground,special(20),acc(100),pp(10),prio(0),[protect,mirror],1,[stats(target,100,[ (accuracy,-1)])]).
move(octazooka,water,special(65),acc(85),pp(10),prio(0),[protect,mirror,ballistics],1,[stats(target,50,[ (accuracy,-1)])]).
move(spikes,ground,status,acc(always),pp(20),prio(0),[reflectable],1,[field]).
move(zap-cannon,electric,special(120),acc(50),pp(5),prio(0),[protect,mirror],1,[ailment(paralysis,100)]).
move(foresight,normal,status,acc(always),pp(40),prio(0),[protect,reflectable,mirror,authentic],1,[ailment(no-type-immunity,always)]).
move(destiny-bond,ghost,status,acc(always),pp(5),prio(0),[authentic],1,[unique]).
move(perish-song,normal,status,acc(always),pp(5),prio(0),[sound,authentic],1,[ailment(perish-song,always,between(4,4))]).
move(icy-wind,ice,special(55),acc(95),pp(15),prio(0),[protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(detect,fighting,status,acc(always),pp(5),prio(4),[],1,[unique]).
move(bone-rush,ground,physical(25),acc(90),pp(10),prio(0),[protect,mirror],between(2,5),[]).
move(lock-on,normal,status,acc(always),pp(5),prio(0),[protect,mirror],1,[unique]).
move(outrage,dragon,physical(120),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(sandstorm,rock,status,acc(always),pp(10),prio(0),[],1,[field]).
move(giga-drain,grass,special(75),acc(100),pp(10),prio(0),[protect,mirror,heal],1,[drain(50)]).
move(endure,normal,status,acc(always),pp(10),prio(4),[],1,[unique]).
move(charm,fairy,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (attack,-2)])]).
move(rollout,rock,physical(30),acc(90),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(false-swipe,normal,physical(40),acc(100),pp(40),prio(0),[contact,protect,mirror],1,[]).
move(swagger,normal,status,acc(90),pp(15),prio(0),[protect,reflectable,mirror],1,[ailment(confusion,always,between(2,5)),stats(target,always,[ (attack,2)])]).
move(milk-drink,normal,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(50)]).
move(spark,electric,physical(65),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[ailment(paralysis,30)]).
move(fury-cutter,bug,physical(40),acc(95),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(steel-wing,steel,physical(70),acc(90),pp(25),prio(0),[contact,protect,mirror],1,[stats(user,10,[ (defense,1)])]).
move(mean-look,normal,status,acc(always),pp(5),prio(0),[reflectable,mirror],1,[unique]).
move(attract,normal,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror,authentic,mental],1,[ailment(infatuation,always)]).
move(sleep-talk,normal,status,acc(always),pp(10),prio(0),[],1,[unique]).
move(heal-bell,normal,status,acc(always),pp(5),prio(0),[snatch,sound,authentic],1,[unique]).
move(return,normal,physical(variable),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(present,normal,physical(variable),acc(90),pp(15),prio(0),[protect,mirror],1,[]).
move(frustration,normal,physical(variable),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(safeguard,normal,status,acc(always),pp(25),prio(0),[snatch],1,[field]).
move(pain-split,normal,status,acc(always),pp(20),prio(0),[protect,mirror],1,[unique]).
move(sacred-fire,fire,physical(100),acc(95),pp(5),prio(0),[protect,mirror,defrost],1,[ailment(burn,50)]).
move(magnitude,ground,physical(variable),acc(100),pp(30),prio(0),[protect,mirror],1,[]).
move((dynamic-punch),fighting,physical(100),acc(50),pp(5),prio(0),[contact,protect,mirror,punch],1,[ailment(confusion,100,between(2,5))]).
move(megahorn,bug,physical(120),acc(85),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(dragon-breath,dragon,special(60),acc(100),pp(20),prio(0),[protect,mirror],1,[ailment(paralysis,30)]).
move(baton-pass,normal,status,acc(always),pp(40),prio(0),[],1,[unique]).
move(encore,normal,status,acc(100),pp(5),prio(0),[protect,reflectable,mirror,authentic,mental],1,[unique]).
move(pursuit,dark,physical(40),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(rapid-spin,normal,physical(20),acc(100),pp(40),prio(0),[contact,protect,mirror],1,[]).
move(sweet-scent,normal,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (evasion,-2)])]).
move(iron-tail,steel,physical(100),acc(75),pp(15),prio(0),[contact,protect,mirror],1,[stats(target,30,[ (defense,-1)])]).
move(metal-claw,steel,physical(50),acc(95),pp(35),prio(0),[contact,protect,mirror],1,[stats(user,10,[ (attack,1)])]).
move(vital-throw,fighting,physical(70),acc(always),pp(10),prio(-1),[contact,protect,mirror],1,[]).
move(morning-sun,normal,status,acc(always),pp(5),prio(0),[snatch,heal],1,[heal(50)]).
move(synthesis,grass,status,acc(always),pp(5),prio(0),[snatch,heal],1,[heal(50)]).
move(moonlight,fairy,status,acc(always),pp(5),prio(0),[snatch,heal],1,[heal(50)]).
move(hidden-power,normal,special(60),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(cross-chop,fighting,physical(100),acc(80),pp(5),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(twister,dragon,special(40),acc(100),pp(20),prio(0),[protect,mirror],1,[flinch(20)]).
move(rain-dance,water,status,acc(always),pp(5),prio(0),[],1,[field]).
move(sunny-day,fire,status,acc(always),pp(5),prio(0),[],1,[field]).
move(crunch,dark,physical(80),acc(100),pp(15),prio(0),[contact,protect,mirror,bite],1,[stats(target,20,[ (defense,-1)])]).
move(mirror-coat,psychic,special(variable),acc(100),pp(20),prio(-5),[protect],1,[]).
move(psych-up,normal,status,acc(always),pp(10),prio(0),[authentic],1,[unique]).
move(extreme-speed,normal,physical(80),acc(100),pp(5),prio(2),[contact,protect,mirror],1,[]).
move(ancient-power,rock,special(60),acc(100),pp(5),prio(0),[protect,mirror],1,[stats(user,10,[ (attack,1), (defense,1), (special-attack,1), (special-defense,1), (speed,1)])]).
move(shadow-ball,ghost,special(80),acc(100),pp(15),prio(0),[protect,mirror,ballistics],1,[stats(target,20,[ (special-defense,-1)])]).
move(future-sight,psychic,special(120),acc(100),pp(10),prio(0),[],1,[unique]).
move(rock-smash,fighting,physical(40),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[stats(target,50,[ (defense,-1)])]).
move(whirlpool,water,special(35),acc(85),pp(15),prio(0),[protect,mirror,mental],1,[ailment(trap,100,between(5,6))]).
move(beat-up,dark,physical(variable),acc(100),pp(10),prio(0),[protect,mirror],6,[]).
move(fake-out,normal,physical(40),acc(100),pp(10),prio(3),[contact,protect,mirror],1,[flinch(100)]).
move(uproar,normal,special(90),acc(100),pp(10),prio(0),[protect,mirror,sound,authentic],1,[]).
move(stockpile,normal,status,acc(always),pp(20),prio(0),[snatch],1,[unique]).
move(spit-up,normal,special(variable),acc(100),pp(10),prio(0),[protect],1,[]).
move(swallow,normal,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(25)]).
move(heat-wave,fire,special(95),acc(90),pp(10),prio(0),[protect,mirror],1,[ailment(burn,10)]).
move(hail,ice,status,acc(always),pp(10),prio(0),[],1,[field]).
move(torment,dark,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror,authentic,mental],1,[ailment(torment,always)]).
move(flatter,dark,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[ailment(confusion,always,between(2,5)),stats(target,always,[ (special-attack,1)])]).
move(will-o-wisp,fire,status,acc(85),pp(15),prio(0),[protect,reflectable,mirror],1,[ailment(burn,always)]).
move(memento,dark,status,acc(100),pp(10),prio(0),[protect,mirror],1,[unique]).
move(facade,normal,physical(70),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(focus-punch,fighting,physical(150),acc(100),pp(20),prio(-3),[contact,protect,punch],1,[]).
move(smelling-salts,normal,physical(70),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(follow-me,normal,status,acc(always),pp(20),prio(2),[],1,[unique]).
move(nature-power,normal,status,acc(always),pp(20),prio(0),[],1,[unique]).
move(charge,electric,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (special-defense,1)])]).
move(taunt,dark,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror,authentic,mental],1,[unique]).
move(helping-hand,normal,status,acc(always),pp(20),prio(5),[authentic],1,[unique]).
move(trick,psychic,status,acc(100),pp(10),prio(0),[protect,mirror],1,[unique]).
move(role-play,psychic,status,acc(always),pp(10),prio(0),[authentic],1,[unique]).
move(wish,normal,status,acc(always),pp(10),prio(0),[snatch,heal],1,[unique]).
move(assist,normal,status,acc(always),pp(20),prio(0),[],1,[unique]).
move(ingrain,grass,status,acc(always),pp(20),prio(0),[snatch],1,[ailment(ingrain,always)]).
move(superpower,fighting,physical(120),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[stats(user,100,[ (attack,-1), (defense,-1)])]).
move(magic-coat,psychic,status,acc(always),pp(15),prio(4),[],1,[unique]).
move(recycle,normal,status,acc(always),pp(10),prio(0),[snatch],1,[unique]).
move(revenge,fighting,physical(60),acc(100),pp(10),prio(-4),[contact,protect,mirror],1,[]).
move(brick-break,fighting,physical(75),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(yawn,normal,status,acc(always),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(yawn,always,between(2,2))]).
move(knock-off,dark,physical(65),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(endeavor,normal,physical(variable),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(eruption,fire,special(150),acc(100),pp(5),prio(0),[protect,mirror],1,[]).
move(skill-swap,psychic,status,acc(always),pp(10),prio(0),[protect,mirror,authentic],1,[unique]).
move(imprison,psychic,status,acc(always),pp(10),prio(0),[snatch,authentic],1,[unique]).
move(refresh,normal,status,acc(always),pp(20),prio(0),[snatch],1,[unique]).
move(grudge,ghost,status,acc(always),pp(5),prio(0),[authentic],1,[unique]).
move(snatch,dark,status,acc(always),pp(10),prio(4),[authentic],1,[unique]).
move(secret-power,normal,physical(70),acc(100),pp(20),prio(0),[protect,mirror],1,[]).
move(dive,water,physical(80),acc(100),pp(10),prio(0),[contact,charge,protect,mirror],1,[]).
move(arm-thrust,fighting,physical(15),acc(100),pp(20),prio(0),[contact,protect,mirror],between(2,5),[]).
move(camouflage,normal,status,acc(always),pp(20),prio(0),[snatch],1,[unique]).
move(tail-glow,bug,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (special-attack,3)])]).
move(luster-purge,psychic,special(70),acc(100),pp(5),prio(0),[protect,mirror],1,[stats(target,50,[ (special-defense,-1)])]).
move(mist-ball,psychic,special(70),acc(100),pp(5),prio(0),[protect,mirror],1,[stats(target,50,[ (special-attack,-1)])]).
move(feather-dance,flying,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (attack,-2)])]).
move(teeter-dance,normal,status,acc(100),pp(20),prio(0),[protect,mirror],1,[ailment(confusion,always,between(2,5))]).
move(blaze-kick,fire,physical(85),acc(90),pp(10),prio(0),[high-crit,contact,protect,mirror],1,[ailment(burn,10)]).
move(mud-sport,ground,status,acc(always),pp(15),prio(0),[],1,[field]).
move(ice-ball,ice,physical(30),acc(90),pp(20),prio(0),[contact,protect,mirror,ballistics],1,[]).
move(needle-arm,grass,physical(60),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(slack-off,normal,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(50)]).
move(hyper-voice,normal,special(90),acc(100),pp(10),prio(0),[protect,mirror,sound,authentic],1,[]).
move(poison-fang,poison,physical(50),acc(100),pp(15),prio(0),[contact,protect,mirror,bite],1,[ailment(bad-poison,50)]).
move(crush-claw,normal,physical(75),acc(95),pp(10),prio(0),[contact,protect,mirror],1,[stats(target,50,[ (defense,-1)])]).
move(blast-burn,fire,special(150),acc(90),pp(5),prio(0),[recharge,protect,mirror],1,[]).
move(hydro-cannon,water,special(150),acc(90),pp(5),prio(0),[recharge,protect,mirror],1,[]).
move(meteor-mash,steel,physical(90),acc(90),pp(10),prio(0),[contact,protect,mirror,punch],1,[stats(user,20,[ (attack,1)])]).
move(astonish,ghost,physical(30),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(weather-ball,normal,special(50),acc(100),pp(10),prio(0),[protect,mirror,ballistics],1,[]).
move(aromatherapy,grass,status,acc(always),pp(5),prio(0),[snatch],1,[unique]).
move(fake-tears,dark,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (special-defense,-2)])]).
move(air-cutter,flying,special(60),acc(95),pp(25),prio(0),[high-crit,protect,mirror],1,[]).
move(overheat,fire,special(130),acc(90),pp(5),prio(0),[protect,mirror],1,[stats(user,100,[ (special-attack,-2)])]).
move(odor-sleuth,normal,status,acc(always),pp(40),prio(0),[protect,reflectable,mirror,authentic],1,[ailment(no-type-immunity,always)]).
move(rock-tomb,rock,physical(60),acc(95),pp(15),prio(0),[protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(silver-wind,bug,special(60),acc(100),pp(5),prio(0),[protect,mirror],1,[stats(user,10,[ (attack,1), (defense,1), (special-attack,1), (special-defense,1), (speed,1)])]).
move(metal-sound,steel,status,acc(85),pp(40),prio(0),[protect,reflectable,mirror,sound,authentic],1,[stats(target,always,[ (special-defense,-2)])]).
move(grass-whistle,grass,status,acc(55),pp(15),prio(0),[protect,reflectable,mirror,sound,authentic],1,[ailment(sleep,always,between(2,4))]).
move(tickle,normal,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (attack,-1), (defense,-1)])]).
move(cosmic-power,psychic,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (defense,1), (special-defense,1)])]).
move(water-spout,water,special(150),acc(100),pp(5),prio(0),[protect,mirror],1,[]).
move(signal-beam,bug,special(75),acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(confusion,10,between(2,5))]).
move(shadow-punch,ghost,physical(60),acc(always),pp(20),prio(0),[contact,protect,mirror,punch],1,[]).
move(extrasensory,psychic,special(80),acc(100),pp(20),prio(0),[protect,mirror],1,[flinch(10)]).
move(sky-uppercut,fighting,physical(85),acc(90),pp(15),prio(0),[contact,protect,mirror,punch],1,[]).
move(sand-tomb,ground,physical(35),acc(85),pp(15),prio(0),[protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(sheer-cold,ice,special(ohko),acc(30),pp(5),prio(0),[protect,mirror],1,[]).
move(muddy-water,water,special(90),acc(85),pp(10),prio(0),[protect,mirror],1,[stats(target,30,[ (accuracy,-1)])]).
move(bullet-seed,grass,physical(25),acc(100),pp(30),prio(0),[protect,mirror,ballistics],between(2,5),[]).
move(aerial-ace,flying,physical(60),acc(always),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(icicle-spear,ice,physical(25),acc(100),pp(30),prio(0),[protect,mirror],between(2,5),[]).
move(iron-defense,steel,status,acc(always),pp(15),prio(0),[snatch],1,[stats(user,always,[ (defense,2)])]).
move(block,normal,status,acc(always),pp(5),prio(0),[reflectable,mirror],1,[unique]).
move(howl,normal,status,acc(always),pp(40),prio(0),[snatch],1,[stats(user,always,[ (attack,1)])]).
move(dragon-claw,dragon,physical(80),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(frenzy-plant,grass,special(150),acc(90),pp(5),prio(0),[recharge,protect,mirror],1,[]).
move(bulk-up,fighting,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (defense,1)])]).
move(bounce,flying,physical(85),acc(85),pp(5),prio(0),[contact,charge,protect,mirror,gravity],1,[ailment(paralysis,30)]).
move(mud-shot,ground,special(55),acc(95),pp(15),prio(0),[protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(poison-tail,poison,physical(50),acc(100),pp(25),prio(0),[high-crit,contact,protect,mirror],1,[ailment(poison,10)]).
move(covet,normal,physical(60),acc(100),pp(25),prio(0),[contact,protect,mirror],1,[]).
move(volt-tackle,electric,physical(120),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[ailment(paralysis,10),drain(-33)]).
move(magical-leaf,grass,special(60),acc(always),pp(20),prio(0),[protect,mirror],1,[]).
move(water-sport,water,status,acc(always),pp(15),prio(0),[],1,[field]).
move(calm-mind,psychic,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (special-attack,1), (special-defense,1)])]).
move(leaf-blade,grass,physical(90),acc(100),pp(15),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(dragon-dance,dragon,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (speed,1)])]).
move(rock-blast,rock,physical(25),acc(90),pp(10),prio(0),[protect,mirror],between(2,5),[]).
move(shock-wave,electric,special(60),acc(always),pp(20),prio(0),[protect,mirror],1,[]).
move(water-pulse,water,special(60),acc(100),pp(20),prio(0),[protect,mirror,pulse],1,[ailment(confusion,20,between(2,5))]).
move(doom-desire,steel,special(140),acc(100),pp(5),prio(0),[],1,[unique]).
move(psycho-boost,psychic,special(140),acc(90),pp(5),prio(0),[protect,mirror],1,[stats(user,100,[ (special-attack,-2)])]).
move(roost,flying,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(50)]).
move(gravity,psychic,status,acc(always),pp(5),prio(0),[],1,[field]).
move(miracle-eye,psychic,status,acc(always),pp(40),prio(0),[protect,reflectable,mirror,authentic],1,[ailment(no-type-immunity,always)]).
move(wake-up-slap,fighting,physical(70),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(hammer-arm,fighting,physical(100),acc(90),pp(10),prio(0),[contact,protect,mirror,punch],1,[stats(user,100,[ (speed,-1)])]).
move(gyro-ball,steel,physical(variable),acc(100),pp(5),prio(0),[contact,protect,mirror,ballistics],1,[]).
move(healing-wish,psychic,status,acc(always),pp(10),prio(0),[snatch,heal],1,[unique]).
move(brine,water,special(65),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(natural-gift,normal,physical(variable),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(feint,normal,physical(30),acc(100),pp(10),prio(2),[mirror],1,[]).
move(pluck,flying,physical(60),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(tailwind,flying,status,acc(always),pp(15),prio(0),[snatch],1,[field]).
move(acupressure,normal,status,acc(always),pp(30),prio(0),[],1,[unique]).
move(metal-burst,steel,physical(variable),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(u-turn,bug,physical(70),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(close-combat,fighting,physical(120),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[stats(user,100,[ (defense,-1), (special-defense,-1)])]).
move(payback,dark,physical(50),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(assurance,dark,physical(60),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(embargo,dark,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[ailment(embargo,always,between(5,5))]).
move(fling,dark,physical(variable),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(psycho-shift,psychic,status,acc(100),pp(10),prio(0),[protect,mirror],1,[unique]).
move(trump-card,normal,special(variable),acc(always),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(heal-block,psychic,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[ailment(heal-block,always,between(5,5))]).
move(wring-out,normal,special(variable),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(power-trick,psychic,status,acc(always),pp(10),prio(0),[snatch],1,[unique]).
move(gastro-acid,poison,status,acc(100),pp(10),prio(0),[protect,reflectable,mirror],1,[unique]).
move(lucky-chant,normal,status,acc(always),pp(30),prio(0),[snatch],1,[field]).
move(me-first,normal,status,acc(always),pp(20),prio(0),[protect,authentic],1,[]).
move(copycat,normal,status,acc(always),pp(20),prio(0),[],1,[unique]).
move(power-swap,psychic,status,acc(always),pp(10),prio(0),[protect,mirror,authentic],1,[unique]).
move(guard-swap,psychic,status,acc(always),pp(10),prio(0),[protect,mirror,authentic],1,[unique]).
move(punishment,dark,physical(variable),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(last-resort,normal,physical(140),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(worry-seed,grass,status,acc(100),pp(10),prio(0),[protect,reflectable,mirror],1,[unique]).
move(sucker-punch,dark,physical(80),acc(100),pp(5),prio(1),[contact,protect,mirror],1,[]).
move(toxic-spikes,poison,status,acc(always),pp(20),prio(0),[reflectable],1,[field]).
move(heart-swap,psychic,status,acc(always),pp(10),prio(0),[protect,mirror,authentic],1,[unique]).
move(aqua-ring,water,status,acc(always),pp(20),prio(0),[snatch],1,[unique]).
move(magnet-rise,electric,status,acc(always),pp(10),prio(0),[snatch,gravity],1,[unique]).
move(flare-blitz,fire,physical(120),acc(100),pp(15),prio(0),[contact,protect,mirror,defrost],1,[ailment(burn,10),drain(-33)]).
move(force-palm,fighting,physical(60),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[ailment(paralysis,30)]).
move(aura-sphere,fighting,special(80),acc(always),pp(20),prio(0),[protect,mirror,pulse,ballistics],1,[]).
move(rock-polish,rock,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (speed,2)])]).
move(poison-jab,poison,physical(80),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[ailment(poison,30)]).
move(dark-pulse,dark,special(80),acc(100),pp(15),prio(0),[protect,mirror,pulse],1,[flinch(20)]).
move(night-slash,dark,physical(70),acc(100),pp(15),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(aqua-tail,water,physical(90),acc(90),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(seed-bomb,grass,physical(80),acc(100),pp(15),prio(0),[protect,mirror,ballistics],1,[]).
move(air-slash,flying,special(75),acc(95),pp(15),prio(0),[protect,mirror],1,[flinch(30)]).
move(x-scissor,bug,physical(80),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(bug-buzz,bug,special(90),acc(100),pp(10),prio(0),[protect,mirror,sound,authentic],1,[stats(target,10,[ (special-defense,-1)])]).
move(dragon-pulse,dragon,special(85),acc(100),pp(10),prio(0),[protect,mirror,pulse],1,[]).
move(dragon-rush,dragon,physical(100),acc(75),pp(10),prio(0),[contact,protect,mirror],1,[flinch(20)]).
move(power-gem,rock,special(80),acc(100),pp(20),prio(0),[protect,mirror],1,[]).
move(drain-punch,fighting,physical(75),acc(100),pp(10),prio(0),[contact,protect,mirror,punch,heal],1,[drain(50)]).
move(vacuum-wave,fighting,special(40),acc(100),pp(30),prio(1),[protect,mirror],1,[]).
move(focus-blast,fighting,special(120),acc(70),pp(5),prio(0),[protect,mirror,ballistics],1,[stats(target,10,[ (special-defense,-1)])]).
move(energy-ball,grass,special(90),acc(100),pp(10),prio(0),[protect,mirror,ballistics],1,[stats(target,10,[ (special-defense,-1)])]).
move(brave-bird,flying,physical(120),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[drain(-33)]).
move(earth-power,ground,special(90),acc(100),pp(10),prio(0),[protect,mirror],1,[stats(target,10,[ (special-defense,-1)])]).
move(switcheroo,dark,status,acc(100),pp(10),prio(0),[protect,mirror],1,[unique]).
move(giga-impact,normal,physical(150),acc(90),pp(5),prio(0),[contact,recharge,protect,mirror],1,[]).
move(nasty-plot,dark,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (special-attack,2)])]).
move(bullet-punch,steel,physical(40),acc(100),pp(30),prio(1),[contact,protect,mirror,punch],1,[]).
move(avalanche,ice,physical(60),acc(100),pp(10),prio(-4),[contact,protect,mirror],1,[]).
move(ice-shard,ice,physical(40),acc(100),pp(30),prio(1),[protect,mirror],1,[]).
move(shadow-claw,ghost,physical(70),acc(100),pp(15),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(thunder-fang,electric,physical(65),acc(95),pp(15),prio(0),[contact,protect,mirror,bite],1,[ailment(paralysis,10),flinch(10)]).
move(ice-fang,ice,physical(65),acc(95),pp(15),prio(0),[contact,protect,mirror,bite],1,[ailment(freeze,10),flinch(10)]).
move(fire-fang,fire,physical(65),acc(95),pp(15),prio(0),[contact,protect,mirror,bite],1,[ailment(burn,10),flinch(10)]).
move(shadow-sneak,ghost,physical(40),acc(100),pp(30),prio(1),[contact,protect,mirror],1,[]).
move(mud-bomb,ground,special(65),acc(85),pp(10),prio(0),[protect,mirror,ballistics],1,[stats(target,30,[ (accuracy,-1)])]).
move(psycho-cut,psychic,physical(70),acc(100),pp(20),prio(0),[high-crit,protect,mirror],1,[]).
move(zen-headbutt,psychic,physical(80),acc(90),pp(15),prio(0),[contact,protect,mirror],1,[flinch(20)]).
move(mirror-shot,steel,special(65),acc(85),pp(10),prio(0),[protect,mirror],1,[stats(target,30,[ (accuracy,-1)])]).
move(flash-cannon,steel,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[stats(target,10,[ (special-defense,-1)])]).
move(rock-climb,normal,physical(90),acc(85),pp(20),prio(0),[contact,protect,mirror],1,[ailment(confusion,20,between(2,5))]).
move(defog,flying,status,acc(always),pp(15),prio(0),[protect,reflectable,mirror,authentic],1,[unique]).
move(trick-room,psychic,status,acc(always),pp(5),prio(-7),[mirror],1,[field]).
move(draco-meteor,dragon,special(130),acc(90),pp(5),prio(0),[protect,mirror],1,[stats(user,100,[ (special-attack,-2)])]).
move(discharge,electric,special(80),acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(paralysis,30)]).
move(lava-plume,fire,special(80),acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(burn,30)]).
move(leaf-storm,grass,special(130),acc(90),pp(5),prio(0),[protect,mirror],1,[stats(user,100,[ (special-attack,-2)])]).
move(power-whip,grass,physical(120),acc(85),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(rock-wrecker,rock,physical(150),acc(90),pp(5),prio(0),[recharge,protect,mirror],1,[]).
move(cross-poison,poison,physical(70),acc(100),pp(20),prio(0),[high-crit,contact,protect,mirror],1,[ailment(poison,10)]).
move(gunk-shot,poison,physical(120),acc(80),pp(5),prio(0),[protect,mirror],1,[ailment(poison,30)]).
move(iron-head,steel,physical(80),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(magnet-bomb,steel,physical(60),acc(always),pp(20),prio(0),[protect,mirror,ballistics],1,[]).
move(stone-edge,rock,physical(100),acc(80),pp(5),prio(0),[high-crit,protect,mirror],1,[]).
move(captivate,normal,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (special-attack,-2)])]).
move(stealth-rock,rock,status,acc(always),pp(20),prio(0),[reflectable],1,[field]).
move(grass-knot,grass,special(variable),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(chatter,flying,special(65),acc(100),pp(20),prio(0),[protect,mirror,sound,authentic],1,[ailment(confusion,100,between(2,5))]).
move(judgment,normal,special(100),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(bug-bite,bug,physical(60),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(charge-beam,electric,special(50),acc(90),pp(10),prio(0),[protect,mirror],1,[stats(user,70,[ (special-attack,1)])]).
move(wood-hammer,grass,physical(120),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[drain(-33)]).
move(aqua-jet,water,physical(40),acc(100),pp(20),prio(1),[contact,protect,mirror],1,[]).
move(attack-order,bug,physical(90),acc(100),pp(15),prio(0),[high-crit,protect,mirror],1,[]).
move(defend-order,bug,status,acc(always),pp(10),prio(0),[snatch],1,[stats(user,always,[ (defense,1), (special-defense,1)])]).
move(heal-order,bug,status,acc(always),pp(10),prio(0),[snatch,heal],1,[heal(50)]).
move(head-smash,rock,physical(150),acc(80),pp(5),prio(0),[contact,protect,mirror],1,[drain(-50)]).
move(double-hit,normal,physical(35),acc(90),pp(10),prio(0),[contact,protect,mirror],2,[]).
move(roar-of-time,dragon,special(150),acc(90),pp(5),prio(0),[recharge,protect,mirror],1,[]).
move(spacial-rend,dragon,special(100),acc(95),pp(5),prio(0),[high-crit,protect,mirror],1,[]).
move(lunar-dance,psychic,status,acc(always),pp(10),prio(0),[snatch,heal],1,[unique]).
move(crush-grip,normal,physical(variable),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(magma-storm,fire,special(100),acc(75),pp(5),prio(0),[protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(dark-void,dark,status,acc(80),pp(10),prio(0),[protect,reflectable,mirror],1,[ailment(sleep,always,between(2,4))]).
move(seed-flare,grass,special(120),acc(85),pp(5),prio(0),[protect,mirror],1,[stats(target,40,[ (special-defense,-2)])]).
move(ominous-wind,ghost,special(60),acc(100),pp(5),prio(0),[protect,mirror],1,[stats(user,10,[ (attack,1), (defense,1), (special-attack,1), (special-defense,1), (speed,1)])]).
move(shadow-force,ghost,physical(120),acc(100),pp(5),prio(0),[contact,charge,mirror],1,[]).
move(hone-claws,dark,status,acc(always),pp(15),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (accuracy,1)])]).
move(wide-guard,rock,status,acc(always),pp(10),prio(3),[snatch],1,[field]).
move(guard-split,psychic,status,acc(always),pp(10),prio(0),[protect],1,[unique]).
move(power-split,psychic,status,acc(always),pp(10),prio(0),[protect],1,[unique]).
move(wonder-room,psychic,status,acc(always),pp(10),prio(0),[mirror],1,[field]).
move(psyshock,psychic,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(venoshock,poison,special(65),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(autotomize,steel,status,acc(always),pp(15),prio(0),[snatch],1,[stats(user,always,[ (speed,2)])]).
move(rage-powder,bug,status,acc(always),pp(20),prio(2),[powder],1,[unique]).
move(telekinesis,psychic,status,acc(always),pp(15),prio(0),[protect,reflectable,mirror,gravity],1,[ailment(unknown,always,between(3,3))]).
move(magic-room,psychic,status,acc(always),pp(10),prio(0),[mirror],1,[field]).
move(smack-down,rock,physical(50),acc(100),pp(15),prio(0),[protect,mirror],1,[ailment(unknown,100)]).
move(storm-throw,fighting,physical(60),acc(100),pp(10),prio(0),[always-crit,contact,protect,mirror],1,[]).
move(flame-burst,fire,special(70),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(sludge-wave,poison,special(95),acc(100),pp(10),prio(0),[protect,mirror],1,[ailment(poison,10)]).
move(quiver-dance,bug,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (special-attack,1), (special-defense,1), (speed,1)])]).
move(heavy-slam,steel,physical(variable),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(synchronoise,psychic,special(120),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(electro-ball,electric,special(variable),acc(100),pp(10),prio(0),[protect,mirror,ballistics],1,[]).
move(soak,water,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[unique]).
move(flame-charge,fire,physical(50),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[stats(user,100,[ (speed,1)])]).
move(coil,poison,status,acc(always),pp(20),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (defense,1), (accuracy,1)])]).
move(low-sweep,fighting,physical(65),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(acid-spray,poison,special(40),acc(100),pp(20),prio(0),[protect,mirror,ballistics],1,[stats(target,100,[ (special-defense,-2)])]).
move(foul-play,dark,physical(95),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(simple-beam,normal,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[unique]).
move(entrainment,normal,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[unique]).
move(after-you,normal,status,acc(always),pp(15),prio(0),[authentic],1,[unique]).
move(round,normal,special(60),acc(100),pp(15),prio(0),[protect,mirror,sound,authentic],1,[]).
move(echoed-voice,normal,special(40),acc(100),pp(15),prio(0),[protect,mirror,sound,authentic],1,[]).
move(chip-away,normal,physical(70),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[]).
move(clear-smog,poison,special(50),acc(always),pp(15),prio(0),[protect,mirror],1,[]).
move(stored-power,psychic,special(20),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(quick-guard,fighting,status,acc(always),pp(15),prio(3),[snatch],1,[field]).
move(ally-switch,psychic,status,acc(always),pp(15),prio(1),[],1,[unique]).
move(scald,water,special(80),acc(100),pp(15),prio(0),[protect,mirror,defrost],1,[ailment(burn,30)]).
move(shell-smash,normal,status,acc(always),pp(15),prio(0),[snatch],1,[unique]).
move(heal-pulse,psychic,status,acc(always),pp(10),prio(0),[protect,reflectable,heal,pulse],1,[heal(50)]).
move(hex,ghost,special(65),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(sky-drop,flying,physical(60),acc(100),pp(10),prio(0),[contact,charge,protect,mirror,gravity],1,[]).
move(shift-gear,steel,status,acc(always),pp(10),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (speed,2)])]).
move(circle-throw,fighting,physical(60),acc(90),pp(10),prio(-6),[contact,protect,mirror],1,[]).
move(incinerate,fire,special(60),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(quash,dark,status,acc(100),pp(15),prio(0),[protect,mirror],1,[unique]).
move(acrobatics,flying,physical(55),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(reflect-type,normal,status,acc(always),pp(15),prio(0),[protect,authentic],1,[unique]).
move(retaliate,normal,physical(70),acc(100),pp(5),prio(0),[contact,protect,mirror],1,[]).
move(final-gambit,fighting,special(variable),acc(100),pp(5),prio(0),[protect],1,[]).
move(bestow,normal,status,acc(always),pp(15),prio(0),[mirror,authentic],1,[unique]).
move(inferno,fire,special(100),acc(50),pp(5),prio(0),[protect,mirror],1,[ailment(burn,100)]).
move(water-pledge,water,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(fire-pledge,fire,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(grass-pledge,grass,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(volt-switch,electric,special(70),acc(100),pp(20),prio(0),[protect,mirror],1,[]).
move(struggle-bug,bug,special(50),acc(100),pp(20),prio(0),[protect,mirror],1,[stats(target,100,[ (special-attack,-1)])]).
move(bulldoze,ground,physical(60),acc(100),pp(20),prio(0),[protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(frost-breath,ice,special(60),acc(90),pp(10),prio(0),[always-crit,protect,mirror],1,[]).
move(dragon-tail,dragon,physical(60),acc(90),pp(10),prio(-6),[contact,protect,mirror],1,[]).
move(work-up,normal,status,acc(always),pp(30),prio(0),[snatch],1,[stats(user,always,[ (attack,1), (special-attack,1)])]).
move(electroweb,electric,special(55),acc(95),pp(15),prio(0),[protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(wild-charge,electric,physical(90),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[drain(-25)]).
move(drill-run,ground,physical(80),acc(95),pp(10),prio(0),[high-crit,contact,protect,mirror],1,[]).
move(dual-chop,dragon,physical(40),acc(90),pp(15),prio(0),[contact,protect,mirror],2,[]).
move(heart-stamp,psychic,physical(60),acc(100),pp(25),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(horn-leech,grass,physical(75),acc(100),pp(10),prio(0),[contact,protect,mirror,heal],1,[drain(50)]).
move(sacred-sword,fighting,physical(90),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[]).
move(razor-shell,water,physical(75),acc(95),pp(10),prio(0),[contact,protect,mirror],1,[stats(target,50,[ (defense,-1)])]).
move(heat-crash,fire,physical(variable),acc(100),pp(10),prio(0),[contact,protect,mirror],1,[]).
move(leaf-tornado,grass,special(65),acc(90),pp(10),prio(0),[protect,mirror],1,[stats(target,50,[ (accuracy,-1)])]).
move(steamroller,bug,physical(65),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[flinch(30)]).
move(cotton-guard,grass,status,acc(always),pp(10),prio(0),[snatch],1,[stats(user,always,[ (defense,3)])]).
move(night-daze,dark,special(85),acc(95),pp(10),prio(0),[protect,mirror],1,[stats(target,40,[ (accuracy,-1)])]).
move(psystrike,psychic,special(100),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(tail-slap,normal,physical(25),acc(85),pp(10),prio(0),[contact,protect,mirror],between(2,5),[]).
move(hurricane,flying,special(110),acc(70),pp(10),prio(0),[protect,mirror],1,[ailment(confusion,30,between(2,5))]).
move(head-charge,normal,physical(120),acc(100),pp(15),prio(0),[contact,protect,mirror],1,[drain(-25)]).
move(gear-grind,steel,physical(50),acc(85),pp(15),prio(0),[contact,protect,mirror],2,[]).
move(searing-shot,fire,special(100),acc(100),pp(5),prio(0),[protect,mirror],1,[ailment(burn,30)]).
move(techno-blast,normal,special(120),acc(100),pp(5),prio(0),[protect,mirror],1,[]).
move(relic-song,normal,special(75),acc(100),pp(10),prio(0),[protect,mirror,sound,authentic],1,[ailment(sleep,10,between(2,4))]).
move(secret-sword,fighting,special(85),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(glaciate,ice,special(65),acc(95),pp(10),prio(0),[protect,mirror],1,[stats(target,100,[ (speed,-1)])]).
move(bolt-strike,electric,physical(130),acc(85),pp(5),prio(0),[contact,protect,mirror],1,[ailment(paralysis,20)]).
move(blue-flare,fire,special(130),acc(85),pp(5),prio(0),[protect,mirror],1,[ailment(burn,20)]).
move(fiery-dance,fire,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[stats(user,50,[ (special-attack,1)])]).
move(freeze-shock,ice,physical(140),acc(90),pp(5),prio(0),[charge,protect,mirror],1,[ailment(paralysis,30)]).
move(ice-burn,ice,special(140),acc(90),pp(5),prio(0),[charge,protect,mirror],1,[ailment(burn,30)]).
move(snarl,dark,special(55),acc(95),pp(15),prio(0),[protect,mirror,sound,authentic],1,[stats(target,100,[ (special-attack,-1)])]).
move(icicle-crash,ice,physical(85),acc(90),pp(10),prio(0),[protect,mirror],1,[flinch(30)]).
move(v-create,fire,physical(180),acc(95),pp(5),prio(0),[contact,protect,mirror],1,[stats(user,100,[ (defense,-1), (special-defense,-1), (speed,-1)])]).
move(fusion-flare,fire,special(100),acc(100),pp(5),prio(0),[protect,mirror,defrost],1,[]).
move(fusion-bolt,electric,physical(100),acc(100),pp(5),prio(0),[protect,mirror],1,[]).
move(flying-press,fighting,physical(80),acc(95),pp(10),prio(0),[contact,protect,mirror,gravity],1,[]).
move(mat-block,fighting,status,acc(always),pp(10),prio(0),[snatch],1,[field]).
move(belch,poison,special(120),acc(90),pp(10),prio(0),[protect],1,[]).
move(rototiller,ground,status,acc(always),pp(10),prio(0),[],1,[stats(user,100,[ (attack,1), (special-attack,1)])]).
move(sticky-web,bug,status,acc(always),pp(20),prio(0),[reflectable],1,[field]).
move(fell-stinger,bug,physical(30),acc(100),pp(25),prio(0),[contact,protect,mirror],1,[]).
move(phantom-force,ghost,physical(90),acc(100),pp(10),prio(0),[contact,charge,mirror],1,[]).
move(trick-or-treat,ghost,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[unique]).
move(noble-roar,normal,status,acc(100),pp(30),prio(0),[protect,reflectable,mirror,sound,authentic],1,[stats(target,100,[ (attack,-1), (special-attack,-1)])]).
move(ion-deluge,electric,status,acc(always),pp(25),prio(1),[],1,[field]).
move(parabolic-charge,electric,special(50),acc(100),pp(20),prio(0),[protect,mirror,heal],1,[drain(50)]).
move(forests-curse,grass,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[unique]).
move(petal-blizzard,grass,physical(90),acc(100),pp(15),prio(0),[protect,mirror],1,[]).
move(freeze-dry,ice,special(70),acc(100),pp(20),prio(0),[protect,mirror],1,[ailment(freeze,10)]).
move(disarming-voice,fairy,special(40),acc(always),pp(15),prio(0),[protect,mirror,sound,authentic],1,[]).
move(parting-shot,dark,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror,sound,authentic],1,[stats(target,100,[ (attack,-1), (special-attack,-1)])]).
move(topsy-turvy,dark,status,acc(always),pp(20),prio(0),[protect,reflectable,mirror],1,[unique]).
move(draining-kiss,fairy,special(50),acc(100),pp(10),prio(0),[contact,protect,mirror,heal],1,[drain(75)]).
move(crafty-shield,fairy,status,acc(always),pp(10),prio(3),[],1,[field]).
move(flower-shield,fairy,status,acc(always),pp(10),prio(0),[],1,[unique]).
move(grassy-terrain,grass,status,acc(always),pp(10),prio(0),[],1,[field]).
move(misty-terrain,fairy,status,acc(always),pp(10),prio(0),[],1,[field]).
move(electrify,electric,status,acc(always),pp(20),prio(0),[protect,mirror],1,[unique]).
move(play-rough,fairy,physical(90),acc(90),pp(10),prio(0),[contact,protect,mirror],1,[stats(target,10,[ (attack,-1)])]).
move(fairy-wind,fairy,special(40),acc(100),pp(30),prio(0),[protect,mirror],1,[]).
move(moonblast,fairy,special(95),acc(100),pp(15),prio(0),[protect,mirror],1,[stats(target,30,[ (special-attack,-1)])]).
move(boomburst,normal,special(140),acc(100),pp(10),prio(0),[protect,mirror,sound,authentic],1,[]).
move(fairy-lock,fairy,status,acc(always),pp(10),prio(0),[mirror,authentic],1,[field]).
move(kings-shield,steel,status,acc(always),pp(10),prio(4),[],1,[unique]).
move(play-nice,normal,status,acc(always),pp(20),prio(0),[reflectable,mirror,authentic],1,[stats(target,100,[ (attack,-1)])]).
move(confide,normal,status,acc(always),pp(20),prio(0),[reflectable,mirror,sound,authentic],1,[stats(target,100,[ (special-attack,-1)])]).
move(diamond-storm,rock,physical(100),acc(95),pp(5),prio(0),[protect,mirror],1,[stats(user,50,[ (defense,1)])]).
move(steam-eruption,water,special(110),acc(95),pp(5),prio(0),[protect,mirror,defrost],1,[ailment(burn,30)]).
move(hyperspace-hole,psychic,special(80),acc(always),pp(5),prio(0),[mirror,authentic],1,[]).
move(water-shuriken,water,physical(15),acc(100),pp(20),prio(1),[protect,mirror],between(2,5),[]).
move(mystical-fire,fire,special(65),acc(100),pp(10),prio(0),[protect,mirror],1,[stats(target,100,[ (special-attack,-1)])]).
move(spiky-shield,grass,status,acc(always),pp(10),prio(4),[],1,[unique]).
move(aromatic-mist,fairy,status,acc(always),pp(20),prio(0),[authentic],1,[stats(user,always,[ (special-defense,1)])]).
move(eerie-impulse,electric,status,acc(100),pp(15),prio(0),[protect,reflectable,mirror],1,[stats(target,always,[ (special-attack,-2)])]).
move(venom-drench,poison,status,acc(100),pp(20),prio(0),[protect,reflectable,mirror],1,[stats(target,100,[ (attack,-1), (special-attack,-1), (speed,-1)])]).
move(powder,bug,status,acc(100),pp(20),prio(1),[protect,reflectable,mirror,authentic,powder],1,[unique]).
move(geomancy,fairy,status,acc(always),pp(10),prio(0),[charge],1,[stats(user,always,[ (special-attack,2), (special-defense,2), (speed,2)])]).
move(magnetic-flux,electric,status,acc(always),pp(20),prio(0),[snatch,authentic],1,[stats(user,always,[ (defense,1), (special-defense,1)])]).
move(happy-hour,normal,status,acc(always),pp(30),prio(0),[],1,[unique]).
move(electric-terrain,electric,status,acc(always),pp(10),prio(0),[],1,[field]).
move(dazzling-gleam,fairy,special(80),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(celebrate,normal,status,acc(always),pp(40),prio(0),[],1,[unique]).
move(hold-hands,normal,status,acc(always),pp(40),prio(0),[authentic],1,[unique]).
move(baby-doll-eyes,fairy,status,acc(100),pp(30),prio(1),[protect,reflectable,mirror],1,[stats(target,always,[ (attack,-1)])]).
move(nuzzle,electric,physical(20),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[ailment(paralysis,100)]).
move(hold-back,normal,physical(40),acc(100),pp(40),prio(0),[contact,protect,mirror],1,[]).
move(infestation,bug,special(20),acc(100),pp(20),prio(0),[contact,protect,mirror],1,[ailment(trap,100,between(5,6))]).
move(power-up-punch,fighting,physical(40),acc(100),pp(20),prio(0),[contact,protect,mirror,punch],1,[stats(user,100,[ (attack,1)])]).
move(oblivion-wing,flying,special(80),acc(100),pp(10),prio(0),[protect,mirror,heal],1,[drain(75)]).
move(thousand-arrows,ground,physical(90),acc(100),pp(10),prio(0),[protect,mirror],1,[ailment(unknown,100)]).
move(thousand-waves,ground,physical(90),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(lands-wrath,ground,physical(90),acc(100),pp(10),prio(0),[protect,mirror],1,[]).
move(light-of-ruin,fairy,special(140),acc(90),pp(5),prio(0),[protect,mirror],1,[drain(-50)]).
