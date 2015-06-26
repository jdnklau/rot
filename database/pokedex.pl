%! pokemon(Name, Types, Base_stats, Abilities)
% @arg Name Name of the pokemon
% @arg Types List of types of the pokemon
% @arg Base_stats Has the form `stats(KP,Attack,Defense,Special Attack,Special Defense,Speed)`
% @arg Abilities List of possible abilities availale to the pokemon
pokemon(abomasnow, [grass, ice], stats(90,92,75,92,85,60), ['snow warning', soundproof]).
pokemon(mega(abomasnow), [grass, ice], stats(90,132,405,132,105,30), ['snow warning']).
pokemon(abra, [psychic], stats(25,20,15,105,55,90), ['inner focus', synchronize, 'magic guard']).
pokemon(absol, [dark], stats(65,130,60,75,60,75), [justified, 'super luck', pressure]).
pokemon(mega(absol), [dark], stats(65,150,60,115,60,115), ['magic bounce']).
pokemon(accelgor, [bug], stats(80,75,40,100,60,145), [hydration, unburden, 'sticky hold']).
pokemon(blade(aegislash), [ghost, steel], stats(60,150,50,150,50,60), ['stance change']).
pokemon(aegislash, [ghost, steel], stats(60,50,150,50,150,60), ['stance change']).
pokemon(aerodactyl, [flying, rock], stats(80,105,65,60,75,130), [pressure, unnerve, 'rock head']).
pokemon(mega(aerodactyl), [flying, rock], stats(80,135,85,70,95,150), ['tough claws']).
pokemon(aggron, [rock, steel], stats(70,110,180,60,60,50), ['heavy metal', sturdy, 'rock head']).
pokemon(mega(aggron), [steel], stats(70,140,230,60,80,50), [filter]).
pokemon(aipom, [normal], stats(55,70,55,40,55,85), [pickup, 'skill link', 'run away']).
pokemon(alakazam, [psychic], stats(55,50,45,135,95,120), ['inner focus', sychronize, 'magic guard']).
pokemon(mega(alakazam), [psychic], stats(55,50,65,175,95,150), [trace]).
pokemon(alomomola, [water], stats(165,75,80,40,45,65), [healer, regenerator, hydration]).
pokemon(altaria, [dragon, flying], stats(75,70,9070,105,80), ['cloud nine', 'natural core']).
pokemon(mega(altaria), [dragon, fairy], stats(75,110,110,110,105,80), [pixilate]).
pokemon(amaura, [ice, rock], stats(77,59,50,67,63,46), [refrigerate, 'snow warning']).
pokemon(ambipom, [normal], stats(76,100,66,60,66,115), [technician, pickup, 'skill link']).
pokemon(amoonguss, [grass, poison], stats(114,85,70,85,80,30), ['effect spore', regenerator]).
pokemon(ampharos, [electric], stats(90,75,85,115,90,55), [plus, static]).
pokemon(mega(ampharos), [dragon, electric], stats(90,95,105,165,110,45), ['mold breaker']).
pokemon(anorith, [bug, rock], stats(45,95,50,40,50,75), ['battle armor', 'swift swim']).
pokemon(arbok, [poison], stats(60,85,69,65,79,80), [intimidate, unnerve, 'shed skin']).
pokemon(arcanine, [fire], stats(90,110,80,100,80,95), ['flash fire', justified, intimidate]).
pokemon(arceus, [normal], stats(120,120,120,120,120,120), [multitype]).
pokemon(bug(arceus), [bug], stats(120,120,120,120,120,120), [multitype]).
pokemon(dark(arceus), [dark], stats(120,120,120,120,120,120), [multitype]).
pokemon(dragon(arceus), [dragon], stats(120,120,120,120,120,120), [multitype]).
pokemon(electric(arceus), [electric], stats(120,120,120,120,120,120), [multitype]).
pokemon(fairy(arceus), [fairy], stats(120,120,120,120,120,120), [multitype]).
pokemon(fighting(arceus), [fighting], stats(120,120,120,120,120,120), [multitype]).
pokemon(fire(arceus), [fire], stats(120,120,120,120,120,120), [multitype]).
pokemon(flying(arceus), [flying], stats(120,120,120,120,120,120), [multitype]).
pokemon(ghost(arceus), [ghost], stats(120,120,120,120,120,120), [multitype]).
pokemon(grass(arceus), [grass], stats(120,120,120,120,120,120), [multitype]).
pokemon(ground(arceus), [ground], stats(120,120,120,120,120,120), [multitype]).
pokemon(ice(arceus), [ice], stats(120,120,120,120,120,120), [multitype]).
pokemon(poison(arceus), [poison], stats(120,120,120,120,120,120), [multitype]).
pokemon(psychic(arceus), [psychic], stats(120,120,120,120,120,120), [multitype]).
pokemon(rock(arceus), [rock], stats(120,120,120,120,120,120), [multitype]).
pokemon(steel(arceus), [steel], stats(120,120,120,120,120,120), [multitype]).
pokemon(water(arceus), [water], stats(120,120,120,120,120,120), [multitype]).
pokemon(archen, [flying, rock], stats(55,112,45,74,45,70), [defeatist]).
pokemon(archeops, [flying, rock], stats(75,140,65,112,65,110), [defeatist]).
pokemon(ariados, [bug, poison], stats(70,80,70,60,60,40), [insomnia, swarm, sniper]).
pokemon(armaldo, [bug, rock], stats(75,125,100,70,80,45), ['battle armor', 'swift swim']).
pokemon(aromatisse, [fairy], stats(101,72,72,99,89,29), ['aroma veil', healer]).
pokemon(aron, [rock, steel], stats(50,70,100,40,40,30), ['heavy metal', sturdy, 'rock head']).
pokemon(articuno, [flying, ice], stats(90,85,100,95,125,85), [pressure]).
pokemon(audino, [normal], stats(103,60,86,60,86,50), [healer, regenerator, klutz]).
pokemon(mega(audino), [fairy, normal], stats(103,60,126,80,126,50), [healer]).
pokemon(aurorus, [ice, rock], stats(123,77,72,99,92,58), [refrigerate, 'snow warning']).
pokemon(avalugg, [ice], stats(95,117,184,44,46,28), ['icy body', sturdy, 'own tempo']).
pokemon(axew, [dragon], stats(46,87,60,30,40,57), ['mold breaker', unnerve, rivalry]).
pokemon(azelf, [psychic], stats(75,125,70,125,70,115), [levitate]).
pokemon(azumarill, [fairy, water], stats(100,50,80,60,80,50), ['huge power', 'thick fat', 'sap sipper']).
pokemon(azurill, [fairy, normal], stats(50,20,40,20,40,20), ['huge power', 'thick fat', 'sap sipper']).
pokemon(bagon, [dragon], stats(45,75,60,40,30,50), ['rock head', 'sheer force']).
pokemon(baltoy, [ground, psychic], stats(40,40,55,40,70,55), [levitate]).
pokemon(banette, [ghost], stats(64,115,65,83,63,65), ['cursed body', insomnia, frisk]).
pokemon(mega(banette), [ghost], stats(64,165,75,93,83,75), [prankster]).
pokemon(barbaracle, [rock, water], stats(72,105,115,54,86,68), [pickpocket, 'tough claws', sniper]).
pokemon(barboach, [ground, water], stats(50,48,43,46,41,60), [anticipation, oblivious, hydration]).
pokemon(basculin, [water], stats(70,92,65,80,55,98), [adaptability, reckless, 'mold breaker', 'rock head']).
pokemon(bastiodon, [rock, steel], stats(60,52,168,47,138,30), [soundproof, sturdy]).
pokemon(bayleef, [grass], stats(60,62,80,63,80,60), ['leaf guard', overgrow]).
pokemon(beartic, [ice], stats(95,110,80,70,80,50), ['snow cloak', 'swift swim']).
pokemon(beautifly, [bug, flying], stats(60,70,50,100,50,65), [rivalry, swarm]).
pokemon(beedrill, [bug, poison], stats(65,90,40,45,80,75), [sniper, swarm]).
pokemon(mega(beedrill), [bug, poison], stats(65,150,40,15,80,145), [adaptability]).
pokemon(beheeyem, [psychic], stats(75,75,75,125,95,40), [analytic, telepathy, synchronize]).
pokemon(beldum, [psychic, steel], stats(40,55,80,35,60,30), ['clear body', 'light metal']).
pokemon(bellossom, [grass], stats(75,80,95,90,100,50), [chlorophyll, healer]).
pokemon(bellsprout, [grass, poison], stats(50,75,35,70,30,40), [chlorophyll, gluttony]).
pokemon(bergmite, [ice], stats(56,69,86,32,36,28), ['ice body', sturdy, 'own tempo']).
pokemon(bibarel, [normal, water], stats(79,85,60,55,60,72), [moody, unaware, simple]).
pokemon(bidoof, [normal], stats(59,45,40,30,40,31), [moody, unaware, simple]).
pokemon(binacle, [rock, water], stats(42,52,67,39,56,50), [pickpocket, 'tough claws', sniper]).
pokemon(bisharp, [dark, steel], stats(65,125,100,60,70,70), [defiant, pressure, 'inner focus']).
pokemon(blastoise, [water], stats(79, 83, 100, 85, 105, 78), [torrent, 'rain dish']).
pokemon(mega(blastoise), [water], stats(79, 103, 120, 135, 115, 78),['mega launcher']).
pokemon(blaziken, [fighting, fire], stats(80,120,70,110,70,80), [blaze, 'speed boost']).
pokemon(mega(blaziken), [fighting, fire], stats(80,160,80,130,80,100), ['speed boost']).
pokemon(blissey, [normal], stats(255,10,10,75,135,55), [healer, 'serene grace', 'natural core']).
pokemon(blitzle, [electric], stats(45,60,32,50,32,76), [lightningrod, 'sap sipper', 'motor drive']).
pokemon(boldore, [rock], stats(70,105,105,50,40,20), ['sand force', sturdy]).
pokemon(bonsly, [rock], stats(50,80,95,10,45,10), [rattled, sturdy, 'rock head']).
pokemon(bouffalant, [normal], stats(95,110,95,40,95,55), [reckless, soundproof, 'sap sipper']).
pokemon(braixen, [fire], stats(59,59,58,90,70,73), [blace, magician]).
pokemon(braviary, [flying, normal], stats(100,123,75,57,75,80), [defiant, 'sheer force', 'keen eye']).
pokemon(breloom, [fighing, grass], stats(60,130,80,60,60,70), ['effect spore', technician, 'poison heal']).
pokemon(bronzong, [psychic, steel], stats(67,89,116,79,116,33), [heatproof, levitate, 'heavy metal']).
pokemon(bronzor, [psychic, steel], stats(57,24,86,24,86,23), [heatproof, levitate, 'heavy metal']).
pokemon(budew, [grass, poison], stats(40,30,35,50,70,55), ['leaf guard', 'poison point', 'natural core']).
pokemon(buizel, [water], stats(55,65,35,60,30,85), ['swift swim', 'water veil']).
pokemon(bulbasaur, [grass, poison], stats(45,49,49,65,65,45), [chlorophyll, overgrow]).
pokemon(buneary, [normal], stats(55,66,44,44,56,85), [klutz, limber, 'run away']).
pokemon(bunnelby, [normal], stats(38,36,38,32,36,57), ['cheek pouch', pickup, 'huge power']).
pokemon(burmy, [bug], stats(40,29,45,29,45,36), [overcoat, 'shed skin']).
pokemon(butterfree, [bug, flying], stats(60,45,50,90,80,70), ['compound eyes', 'tinted lens']).
pokemon(cacnea, [grass], stats(50,85,40,85,40,35), ['sand vail', 'water absorb']).
pokemon(cacturne, [grass], stats(70,115,60,155,60,55), ['sand vail', 'water absorb']).
pokemon(camerupt, [fire, groundon], stats(70,100,70,105,75,40), ['anger point', 'solid rock', 'magma armor']).
pokemon(mega(camerupt), [fire, groundon], stats(70,120,100,145,105,20), ['sheer force']).
pokemon(carbink, [fairy, rock], stats(50,50,150,50,150,50), ['clear body', sturdy]).
pokemon(carnivine, [grass], stats(74,100,72,90,72,46), [levitate]).
pokemon(carracosta, [rock, water], stats(74,108,133,83,65,32), ['solid rock', 'swift swim', sturdy]).
pokemon(carvanha, [dark, water], stats(45,90,20,65,20,65), ['rough skin', 'speed boost']).
pokemon(cascoon, [bug], stats(50,35,55,25,25,15), ['shed skin']).
pokemon(castform, [normal], stats(70,70,70,70,70,70), [forecast]).
pokemon(rainy(castform), [water], stats(70,70,70,70,70,70), [forecast]).
pokemon(sunny(castform), [fire], stats(70,70,70,70,70,70), [forecast]).
pokemon(snowy(castform), [ice], stats(70,70,70,70,70,70), [forecast]).
pokemon(caterpie, [bug], stats(45,30,35,20,20,45), ['run away', 'shield dust']).
pokemon(celebi, [grass, psychic], stats(100,100,100,100,100,100), ['natural core']).
pokemon(chandelure, [fire, ghost], stats(60,55,90,145,90,80), ['flame body', infiltrator, 'flash fire']).
pokemon(chansey, [normal], stats(250,5,5,35,105,50), [healer, 'serence grace', 'natural core']).
pokemon(charizard, [fire, flying], stats(76, 84, 78, 109, 85, 100), [blaze, 'solar power']).
pokemon(mega(charizard, x), [dragon, fire], stats(78,130,111,130,85,100), ['rough claws']).
pokemon(mega(charizard, y), [fire, flying], stats(78,104,78,159,115,100), [drought]).
pokemon(charmander, [fire], stats(36,52,43,60,50,65), [blaze, 'solar power']).
pokemon(charmeleon, [fire], stats(58,64,58,80,65,80), [blaze, 'solar power']).
pokemon(chatot, [flying, normal], stats(76,65,45,92,42,91), ['big pecks', 'tangled feet', 'keen eye']).
pokemon(cherrim, [grass], stats(70,60,70,87,78,85), ['flower gift']).
pokemon(cherubi, [grass], stats(45,35,45,62,53,35), [chlorophyll]).
pokemon(chesnaught, [fighting, grass], stats(88,107,122,74,75,64), [bulletproof, overgrow]).
pokemon(chespin, [grass], stats(56,61,65,48,45,38), [bulletproof, overgrow]).
pokemon(chikorita, [grass], stats(45,49,65,49,65,45), ['leaf guard', overgrow]).
pokemon(chimchar, [fire], stats(44,58,44,58,44,61), [blaze, 'iron fist']).
pokemon(chimecho, [psychic], stats(65,50,70,95,80,65), [levitate]).
pokemon(chinchou, [electric, water], stats(75,38,38,56,56,67), [illuminate, 'water absorb', 'volt absorb']).
pokemon(chingling, [psychic], stats(45,30,50,65,50,45), [levitate]).
pokemon(cinccino, [normal], stats(75,95,60,65,60,115), ['cute charm', technican, 'skill link']).
pokemon(clamperl, [water], stats(35,64,85,74,55,32), [rattled, 'shell armor']).
pokemon(clauncher, [water], stats(50,53,62,58,63,44), ['mega launcher']).
pokemon(clawitzer, [water], stats(71,73,88,120,89,59), ['mega launcher']).
pokemon(claydol, [ground, psychic], stats(60,70,105,70,120,75), [levitate]).
pokemon(clefable, [fairy], stats(95,70,73,95,90,60), ['cute charm', unaware, 'magic guard']).
pokemon(clefairy, [fairy], stats(70,45,48,60,65,35), ['cute charm', unaware, 'magic guard']).
pokemon(cleffa, [fairy], stats(50,25,28,45,55,15), ['cute charm', unaware, 'magic guard']).
pokemon(cloyster, [ice, water], stats(50,95,180,85,45,70), [overcoat, 'skill link', 'shell armor']).
pokemon(cobalion, [fighting, steel], stats(91,90,129,90,72,108), [justified]).
pokemon(cofagrigus, [ghost], stats(58,50,145,95,105,30), [mummy]).
pokemon(combee, [bug, flying], stats(30,30,42,30,42,70), ['honey gather', hustle]).
pokemon(combusken, [fighting, fire], stats(60,85,60,85,60,55), [blaze, 'speed boost']).
pokemon(conkeldurr, [fighting], stats(105,140,95,55,65,45), [guts, 'sheer force', 'iron fist']).
pokemon(corphish, [water], stats(43,80,65,50,35,35), [adaptability, 'shell armor', 'hyper cutter']).
pokemon(corsola, [rock, water], stats(55,55,85,65,85,35), [hustle, regenerator, 'natural core']).
pokemon(cottonee, [fairy, grass], stats(40,27,60,37,50,66), [chlorophyll, prankster, infiltrator]).
pokemon(cradily, [grass, rock], stats(86,81,97,81,107,43), ['storm drain', 'suction cups']).
pokemon(cranidos, [rock], stats(67,125,40,30,30,58), ['mold breaker', 'sheer force']).
pokemon(crawdaunt, [dark, water], stats(63,120,85,90,55,55), [adaptability, 'shell armor', 'hyper cutter']).
pokemon(cresselia, [psychic], stats(120,70,120,75,130,85), [levitate]).
pokemon(croagunk, [fighting, poison], stats(48,61,40,61,40,50), [anticipation, 'poison touch', 'dry skin']).
pokemon(crobat, [flying, dark], stats(85,90,80,70,80,130), [infiltrator, 'inner focus']).
pokemon(croconaw, [water], stats(65,80,80,59,63,58), ['sheer force', torrent]).
pokemon(crustle, [bug, rock], stats(70,95,125,65,75,45), ['shell armor', 'weak armor', sturdy]).
pokemon(cryogonal, [ice], stats(70,50,30,95,135,105), [levitate]).
pokemon(cubchoo, [ice], stats(55,70,40,60,40,40), [rattled, 'snow cloak']).
pokemon(cubone, [ground], stats(50,50,95,40,50,35), ['battle armor', 'rock head', lightningrod]).
pokemon(cyndaquil, [fire], stats(39,52,43,60,50,65), [blaze, 'flash fire']).
pokemon(darkrai, [dark], stats(70,90,90,135,90,125), ['bad dreams']).
pokemon(darmanitan, [fire], stats(105,140,55,60,55,95), ['sheer force', 'zen mode']).
pokemon(zenmode(darmanitan), [fire, psychic], stats(105,30,105,150,105,55), ['zen mode']).
pokemon(darumaka, [fire], stats(70,90,45,15,45,50), [hustle, 'inner focus']).
pokemon(dedenne, [electric, fairy], stats(67,58,57,81,67,101), ['cheek pouch', plus, pickup]).
pokemon(deerling, [grass, normal], stats(60,60,50,40,50,75), [chlorophyll, 'serene grace', 'sap sipper']).
pokemon(deino, [dark, dragon], stats(52,65,50,45,50,38), [hustle]).
pokemon(delcatty, [normal], stats(70,65,65,55,55,70), ['cute charm', 'wonder skin', normalize]).
pokemon(delibird, [flying, ice], stats(45,55,45,65,45,75), [hustle, 'vital spirit', insomnia]).
pokemon(delphox, [fire, psychic], stats(75,69,75,114,100,104), [blaze, magician]).
pokemon(deoxys, [psychic], stats(50,150,50,150,50,150), [pressure]).
pokemon(attack(deoxys), [psychic], stats(50,180,20,180,20,150), [pressure]).
pokemon(defense(deoxys), [psychic], stats(50,70,160,70,160,90), [pressure]).
pokemon(speed(deoxys), [psychic], stats(50,95,90,95,90,180), [pressure]).
pokemon(dewgong, [ice, water], stats(90,70,80,70,95,70), [hydration, 'thick fat', 'ice body']).
pokemon(dewott, [water], stats(75,75,60,83,60,60), ['shell armor', torrent]).
pokemon(dialga, [dragon, steel], stats(100,120,120,150,100,90), [pressure, telepathy]).
pokemon(diancie, [fairy, rock], stats(50,100,150,100,150,50), ['clear body']).
pokemon(mega(diancie), [fairy, rock], stats(50,160,110,160,110,110), ['magic bounce']).
pokemon(diggersby, [ground, normal], stats(85,56,77,50,77,78), ['cheek pouch', pickup, 'huge power']).
pokemon(diglett, [ground], stats(10,55,25,35,45,95), ['arena trap', 'sand veil', 'sand force']).
pokemon(ditto, [normal], stats(48,48,48,48,48,48), [imposter, limber]).
pokemon(dodrio, [flying, normal], stats(60,110,70,60,60,100), ['early bird', 'tangled feet', 'run away']).
pokemon(doduo, [flying, normal], stats(35,85,45,35,35,75), ['early bird', 'tangled feet', 'run away']).
pokemon(donphan, [ground], stats(90,120,120,60,60,50), ['sand veil', sturdy]).
pokemon(doublade, [ghost, steel], stats(59,110,150,45,49,35), ['no guard']).
pokemon(dragalge, [dragon, poison], stats(65,75,90,97,123,44), [adaptability, 'poison touch', 'poison point']).
pokemon(dragonair, [dragon], stats(61,84,65,70,70,70), ['marcel scale', 'shed skin']).
pokemon(dragonite, [dragon, flying], stats(91,134,95,100,100,80), ['inner focus', multiscale]).
pokemon(drapion, [dark, poison], stats(70,90,110,60,75,95), ['battle armor', sniper, 'keen eye']).
pokemon(dratini, [dragon], stats(41,64,45,50,50,50), ['marvel scale', 'shed skin']).
pokemon(drifblim, [flying, ghost], stats(150,85,44,90,54,80), [aftermath, unburden, 'flare boost']).
pokemon(drifloon, [flying, ghost], stats(90,50,34,60,44,70), [aftermath, unburden, 'flare boost']).
pokemon(drilbur, [ground], stats(60,85,40,30,45,68), ['sand rush', 'sand force', 'mold breaker']).
pokemon(drowzee, [psychic], stats(60,48,45,43,90,42), [forewarn, insomnia, 'inner focus']).
pokemon(druddigon, [dragon], stats(77,120,90,60,90,48), ['mold breaker', 'sheer force', 'rough skin']).
pokemon(ducklett, [flying, water], stats(62,44,50,44,50,55), ['big pecks', 'keen eye', hydration]).
pokemon(dugtrio, [ground], stats(35,80,50,50,70,120), ['arena trap', 'sand veil', 'sand force']).
pokemon(dunsparce, [normal], stats(100,70,70,65,65,45), [rattled, 'serene grace', 'run away']).
pokemon(duosion, [psychic], stats(65,40,50,125,60,30), ['magic guard', regenerator, overcoat]).
pokemon(durant, [bug, steel], stats(58,109,112,48,48,109), [hustle, truant, swarm]).
pokemon(dusclops, [ghost], stats(40,70,130,60,130,25), [frisk, pressure]).
pokemon(dusknoir, [ghost], stats(45,100,135,65,135,45), [frisk, pressure]).
pokemon(duskull, [ghost], stats(20,40,90,30,90,25), [frist, pressure]).
pokemon(dustox, [bug, poison], stats(60,50,70,50,90,65), ['compound eyes', 'shield, dust']).
pokemon(dwebble, [bug, rock], stats(50,65,85,35,35,55), ['shell armor', 'weak armor', sturdy]).
pokemon(eelektrik, [electric], stats(65,85,70,75,70,40), [levitate]).
pokemon(eelektross, [electric], stats(85,115,80,105,80,50), [levitate]).
pokemon(eevee, [normal], stats(55,55,50,45,65,55), [adaptability, 'run away', anticipation]).
pokemon(ekans, [poison], stats(35,60,44,40,54,55), [intimidate, unnerve, 'shed skin']).
pokemon(electabuzz, [electric], stats(65,83,57,95,85,105), [static, 'vital spirit']).
pokemon(electivire, [electric], stats(75,123,67,95,85,95), ['motor drive', 'vital spirit']).
pokemon(electrike, [electric], stats(40,45,40,65,40,65), [lightningrod, static, minus]).
pokemon(electrode, [electric], stats(60,50,70,80,80,140), [aftermath, static, soundproof]).
pokemon(elekid, [electric], stats(45,63,37,65,55,95), [static, 'vital spirit']).
pokemon(elgyem, [psychic], stats(55,55,55,85,55,30), [analytic, telepathy, synchronize]).
pokemon(emboar, [fighting, fire], stats(110,123,65,100,65,65), [blaze, reckless]).
pokemon(emolga, [electroc, flying], stats(55,75,60,75,60,103), ['motor drive', static]).
pokemon(empoleon, [steel, water], stats(84,86,88,111,101,60), [torrent, defiant ]).
pokemon(entei, [fire], stats(115,115,85,90,75,100), [pressure]).
pokemon(escavalier, [bug, steel], stats(70,135,105,60,105,20), [overcoat, swarm, 'shell armor']).
pokemon(espeon, [psychic], stats(65,65,60,130,95,110), ['magic bounce', synchronize]).
pokemon(espurr, [psychic], stats(62,48,54,63,60,68), [infiltrator, 'own tempo', 'keen eye']).
pokemon(excadrill, [ground, steel], stats(110,135,60,50,65,88), ['mold breaker', 'sand rush', 'sand force']).
pokemon(exeggcute, [grass, psychic], stats(60,40,80,60,45,40), [chlorophyll, harvest]).
pokemon(exeggutor, [grass, psychic], stats(95,95,85,125,65,55), [chlorophyll, harvest]).
pokemon(exploud, [normal], stats(104,91,63,91,73,68), [scrappy, soundproof]).
pokemon(farfetchd, [flying, normal], stats(52,65,55,58,62,60), [defiant, 'keen eye', 'inner focus']).
pokemon(fearow, [flying, normal], stats(65,90,65,61,61,100), ['keen eye', sniper]).
pokemon(feebas, [water], stats(20,15,20,10,55,80), [adaptabilitiy, 'swift swim', oblivious]).
pokemon(fennekin, [fire], stats(40,45,40,62,60,60), [blaze, magician]).
pokemon(feraligatr, [water], stats(85,105,100,79,83,78), ['sheer force', torrent]).
pokemon(ferroseed, [grass, steel], stats(44,50,91,24,86,10), ['iron barbs']).
pokemon(ferrothorn, [grass, steel], stats(74,94,131,54,116,20), [anticipatopn, 'iron barbs']).
pokemon(finneon, [water], stats(49,49,56,49,61,66), ['storm drain', 'water veil', 'swift swim']).
pokemon(flaaffy, [electric], stats(70,55,55,80,60,45), [plus, static]).
pokemon(flabebe, [fairy], stats(44,38,39,61,79,42), ['flower veil', symbiosis]).
pokemon(flareon, [fire], stats(65,130,60,95,110,65), ['flash fire', guts]).
pokemon(fletchinder, [fire, flying], stats(62,73,55,56,52,84), ['flame body', 'gale wings']).
pokemon(fletchling, [flying, normal], stats(45,50,43,40,38,62), ['big pecks', 'gale wings']).
pokemon(floatzel, [water], stats(85,105,55,85,50,115), ['swift swim', 'water veil']).
pokemon(floette, [fairy], stats(54,45,47,75,98,52), ['flower veil', symbiosis]).
pokemon(eternal(floette), [fairy], stats(74,65,67,125,128,92), ['flower veil', symbiosis]).
pokemon(florges, [fairy], stats(78,65,68,112,154,75), ['flower veil', symbiosis]).
pokemon(flygon, [dragon, ground], stats(80,100,80,80,80,100), [levitate]).
pokemon(foongus, [grass, poison], stats(69,55,45,55,55,15), ['effect spore', regenerator]).
pokemon(forretress, [bug, steel], stats(75,90,140,60,60,40), [overcoat, sturdy]).
pokemon(fraxure, [dragon], stats(66,117,70,40,50,67), ['mold breaker', unnerve, rivalry]).
pokemon(frillish, [ghost, water], stats(55,40,50,65,85,40), ['cursed body', 'water absorb', damp]).
pokemon(froakie, [water], stats(41,56,41,62,44,71), [torrent, protean]).
pokemon(frogadier, [water], stats(54,53,52,83,56,91), [torrent, protean]).
pokemon(froslass, [ghost, ice], stats(70,80,70,80,70,110), ['cursed body', 'snow cloak']).
pokemon(furfrou, [normal], stats(75,80,60,65,90,102), ['fur coat']).
pokemon(furret, [normal], stats(85,76,64,45,55,90), [frisk, 'run away', 'keen eye']).
pokemon(gabite, [dragon, ground], stats(68,90,65,50,55,82), ['rough skin', 'sand veil']).
pokemon(gallade, [fighting, psychic], stats(68,125,65,65,115,80), [justified, steadfast]).
pokemon(mega(gallade), [fighting, psychic], stats(68,165,95,65,115,110), ['inner focus']).
pokemon(galvantula, [bug, electric], stats(70,77,60,97,60,108), ['compound eyes', unnerve, swarm]).
pokemon(garbodor, [poison], stats(80,95,82,60,82,75), [aftermath, 'weak armor', stench]).
pokemon(garchomp, [dragon, ground], stats(108,130,95,80,85,102), ['rough skin', 'sand veil']).
pokemon(mega(garchomp), [dragon, ground], stats(108,170,115,120,95,92), ['sand force']).
pokemon(gardevoir, [fairy, psychic], stats(68,65,65,125,115,80), [synchronize, trace, telepathy]).
pokemon(mega(gardevoir), [fairy, psychic], stats(68,85,65,165,135,100), [pixilate]).
pokemon(gastly, [ghost, poison], stats(30,35,30,100,35,80), [levitate]).
pokemon(gastrodon, [ground, water], stats(111,83,68,92,82,39), ['sand force', 'storm drain', 'sticky hold']).
pokemon(genesect, [bug, steel], stats(71,120,95,120,95,99), [download]).
pokemon(gengar, [ghost, poison], stats(60,65,60,130,75,110), [levitate]).
pokemon(mega(gengar), [ghost, poison], stats(60,65,80,170,95,130), ['shadow tag']).
pokemon(geodude, [ground, rock], stats(40,80,100,30,30,20), ['rock head', sturdy, 'sand veil']).
pokemon(gible, [dragon, ground], stats(58,70,45,40,45,42), ['rough skin', 'sand veil']).
pokemon(gigalith, [rock], stats(85,135,130,60,80,25), ['sand force', sturdy]).
pokemon(girafarig, [normal, psychic], stats(70,80,65,90,65,85), ['early bird', 'sap sipper', 'inner focus']).
pokemon(giratina, [dragon, ghost], stats(150,100,120,100,120,90), [pressure, telepathy]).
pokemon(origin(giratina), [dragon, ghost], stats(150,120,100,120,100,90), [levitate]).
pokemon(glaceon, [ice], stats(65,60,110,130,95,65), ['snow cloak', 'ice body']).
pokemon(glalie, [ice], stats(80,80,80,80,80,80), ['ice body', moody, 'inner focus']).
pokemon(mega(glalie), [ice], stats(80,120,80,120,100), [refrigerate]).
pokemon(glameow, [normal], stats(49,55,42,42,37,85), ['keen eye', 'own tempo', limber]).
pokemon(gligar, [flying, ground], stats(65,75,105,35,65,85), ['hyper cutter', 'sand veil', immunity]).
pokemon(gliscor, [ground, flying], stats(76, 95, 125, 45, 75, 95), ['hyper cutter', 'sand veil', 'poison heal']).
pokemon(gloom, [grass, poison], stats(60,65,70,85,75,40), [chlorophyll, stench]).
pokemon(gogoat, [grass], stats(123,100,62,97,81,68), ['grass pelt', 'sad sipper']).
pokemon(golbat, [flying, poison], stats(75,80,70,65,75,90), [infiltrator, 'inner focus']).
pokemon(goldeen, [water], stats(45,67,60,35,50,63), [lightningrod, 'water veil', 'swift swim']).
pokemon(golduck, [water], stats(80,82,78,95,80,85), ['cloud nine', 'swift swim', damp]).
pokemon(golem, [ground, rock], stats(80,120,130,55,65,45), ['rock head', sturdy, 'sand veil']).
pokemon(golett, [ghost, ground], stats(59,75,50,35,50,35), ['iron fist', 'no guard', klutz]).
pokemon(golurk, [ghost, ground], stats(89,124,80,55,80,55), ['iron fist', 'no guard', klutz]).
pokemon(goodra, [dragon], stats(90,100,70,110,150,80), [gooey, 'sad sipper', hydration]).
pokemon(goomy, [dragon], stats(45,50,35,55,75,40), [gooey, 'sad sipper', hydration]).
pokemon(gorebyss, [water], stats(55,84,105,114,75,52), [hydration, 'swift swim']).
pokemon(gothita, [psychic], stats(45,30,50,55,65,45), [competetive, 'shadow tag', frisk]).
pokemon(gothitelle, [psychic], stats(70,55,95,95,110,65), [competetive, 'shadow tag', frisk]).
pokemon(gothorita, [psychic], stats(60,45,70,75,85,55), [competetive, 'shadow tag', frisk]).
pokemon(gourgeist, [ghost, grass], stats(65,90,122,58,75,84), [frisk, pickup, insomnia]).
pokemon(large(gourgeist), [ghost, grass], stats(75,95,122,58,75,69), [frisk, pickup, insomnia]).
pokemon(small(gourgeist), [ghost, grass], stats(55,85,122,58,75,99), [frisk, pickup, insomnia]).
pokemon(super(gourgeist), [ghost, grass], stats(85,100,122,58,75,54), [frisk, pickup, insomnia]).
pokemon(granbull, [fairy], stats(90,120,75,60,60,45), [intimidate, rattled, 'quick feet']).
pokemon(graveler, [ground, rock], stats(55,95,115,45,45,35), ['rock head', sturdy, 'sand veil']).
pokemon(greninja, [water], stats(72,95,67,103,71,122), [torrent, protean]).
pokemon(grimer, [poison], stats(80,80,50,40,50,25), ['poison touch', 'sticky hold', stench]).
pokemon(grotle, [grass], stats(75,89,85,55,65,36), [overgrow, 'shell armor']).
pokemon(groudon, [ground], stats(100,150,140,100,90,90), [drought]).
pokemon(primal(groudon), [fire, ground], stats(100,180,160,150,90,90), ['desolate land']).
pokemon(grovyle, [grass], stats(50,65,45,85,65,95), [overgrow, unburden]).
pokemon(growlithe, [fire], stats(55,70,45,70,50,60), ['flash fire', justified, intimidate]).
pokemon(grumpig, [psychic], stats(80,45,65,90,110,80), [gluttony, 'thick fat', 'own tempo']).
pokemon(gulpin, [poison], stats(70,43,53,43,53,40), [gluttony, 'sticky, hold', 'liquid ooze']).
pokemon(gurdurr, [fighting], stats(85,105,85,40,50,40), ['iron fist', guts, 'sheer force']).
pokemon(gyarados, [flying, water], stats(85,125,79,60,100,81), [intimidate, moxie]).
pokemon(mega(gyarados), [dark, water], stats(95,155,109,70,130,81), ['mold breaker']).
pokemon(happiny, [normal], stats(100,5,5,15,65,30), ['friend guard', 'serene grace', 'natural core']).
pokemon(hariyama, [fighting], stats(144,120,60,40,60,50), [guts, 'thick fat', 'sheer force']).
pokemon(haunter, [ghost, poison], stats(45,50,45,115,55,95), [levitate]).
pokemon(hawlucha, [fighting, flying], stats(78,92,77,74,63,118), [limber, unburden, 'mold breaker']).
pokemon(haxorus, [dragon], stats(76,147,90,60,70,97), ['mold breaker', unnerve, rivalry]).
pokemon(heatmor, [fire], stats(85,97,66,105,66,65), ['flash fire', 'white smoke', gluttony]).
pokemon(heatran, [fire, steel], stats(91, 90, 106, 130, 106, 77), ['flash fire', 'flame body']).
pokemon(heliolisk, [electric, normal], stats(62,55,52,109,94,109), ['dry skin', 'solar power', 'sand veil']).
pokemon(helioptile, [electric, normal], stats(44,38,33,61,43,70), ['dry skin', 'solar power', 'sand veil']).
pokemon(heracross, [bug, fighting], stats(80,125,75,40,95,85), [guts, swarm, moxie]).
pokemon(mega(heracross), [bug, fighting], stats(80,185,115,40,105,75), ['skill link']).
pokemon(herdier, [normal], stats(65,80,65,35,65,60), [intimidate, scrappy, 'sand rush']).
pokemon(hippopotas, [ground], stats(68,72,78,38,42,32), ['sand force', 'sand stream']).
pokemon(hippowdon, [ground], stats(108,112,118,68,72,47), ['sand force', 'sand stream']).
pokemon(hitmonchan, [fighting], stats(50,105,79,35,110,76), ['inner focus', 'keen eye', 'iron fist']).
pokemon(hitmonlee, [fighting], stats(50,120,53,35,110,87), [limber, unburden, reckless]).
pokemon(hitmontop, [fighting], stats(50,95,95,35,110,70), [intimidate, technician, steadfast]).
pokemon(ho-oh, [fire, flying], stats(106,130,90,110,154,90), [pressure, regenerator]).
pokemon(honchkrow, [dark, flying], stats(100,125,52,105,52,71), [insomnia, 'super luck', moxie]).
pokemon(honedge, [ghost, steel], stats(45,80,100,35,37,28), ['no guard']).
pokemon(hoopa, [ghost, psychic], stats(80,110,60,150,130,70), [magician]).
pokemon(alt(hoopa), [dark, psychic], stats(80,160,60,170,130,80), [magician]).
pokemon(hoothoot, [flying, normal], stats(60,30,30,36,56,50), [insomnia, 'tinted lens', 'keen eye']).
pokemon(hoppip, [flying, grass], stats(35,35,40,35,55,50), [chlorophyll, 'leaf guard', infiltrator]).
pokemon(horsea, [water], stats(30,40,70,70,25,60), [damp, 'swift swim', sniper]).
pokemon(houndoom, [dark, fire], stats(75,90,50,110,80,95), ['early bird', unnerve, 'flash fire']).
pokemon(mega(houndoom), [dark, fire], stats(75,90,90,140,90,115), ['solar power']).
pokemon(houndour, [dark, fire], stats(45,60,30,80,50,65), ['early bird', unnerve, 'flash fire']).
pokemon(huntail, [water], stats(55,104,105,94,75,52), ['swift swim', 'water veil']).
pokemon(hydreigon, [dark, dragon], stats(92,105,90,125,90,98), [levitate]).
pokemon(hypno, [psychic], stats(85,73,70,73,115,67), [forewarn, insomnia, 'inner focus']).
pokemon(igglybuff, [fairy, normal], stats(90,30,15,40,20,15), [competetive, 'friend guard', 'cute charm']).
pokemon(illumise, [bug], stats(65,47,55,73,75,85), [oblivious, 'tinted lens', prankster]).
pokemon(infernape, [fighting, fire], stats(76,104,71,104,71,108), [blaze, 'iron fist']).
pokemon(inkay, [dark, psychic], stats(53,54,53,37,46,45), [contrary, 'suction cups', infiltrator]).
pokemon(ivysaur, [grass, poison], stats(60,62,63,80,80,60), [chlorophyll, overgrow]).
pokemon(jellicent, [ghost, water], stats(100,60,70,85,105,60), ['cursed body', 'water absorb', damp]).
pokemon(jigglypuff, [fairy, normal], stats(115,45,20,45,25,20), [competetive, 'friend guard', 'cute charm']).
pokemon(jirachi, [psychic, steel], stats(100,100,100,100,100,100), ['serene grace']).
pokemon(jolteon, [electric], stats(65,65,60,110,95,130), ['quick feet', 'volt absorb']).
pokemon(joltik, [bug, electric], stats(50,47,50,57,50,65), ['compound eyes', unnerve, swarm]).
pokemon(jumpluff, [flying, grass], stats(75,55,70,55,95,110), [chlorophyll, 'leaf guard', infiltrator]).
pokemon(jynx, [ice, psychic], stats(65,50,35,115,95,95), ['dry skin', oblivious, forewarn]).
pokemon(kabuto, [rock, water], stats(30,80,90,55,45,55), ['battle armor', 'weak armor', 'swift swim']).
pokemon(kabutops, [rock, water], stats(60,115,105,65,70,80), ['battle armor', 'weak armor', 'swift swim']).
pokemon(kadabra, [psychic], stats(40,35,30,120,70,105), ['inner focus', synchronize, 'magic guard']).
pokemon(kakuna, [bug, poison], stats(45,25,50,25,25,35), ['shed skin']).
pokemon(kangaskhan, [normal], stats(105,95,80,40,80,90), ['early bird', scrappy, 'inner focus']).
pokemon(mega(kangaskhan), [normal], stats(105,125,100,60,100,100), ['family bond']).
pokemon(karrablast, [bug], stats(50,75,45,40,45,60), ['no guard', swarm, 'shed skin']).
pokemon(kecleon, [normal], stats(60,90,70,60,120,40), ['color change', protean]).
pokemon(keldeo, [fighting, water], stats(91,72,90,129,90,108), [justified]).
pokemon(kingdra, [dragon, water], stats(75,95,95,95,95,85), [damp, 'swift swim', sniper]).
pokemon(kingler, [water], stats(55,130,115,50,50,75), ['hyper cutter', 'shell armor', 'sheer force']).
pokemon(kirlia, [fairy, psychic], stats(38,35,35,65,55,50), [synchronize, trace, telepathy]).
pokemon(klang, [steel], stats(60,80,95,70,85,50), ['clear body', plus, minus]).
pokemon(klefki, [fairy, steel], stats(57,80,91,80,87,75), [magician, prankster]).
pokemon(klink, [steel], stats(40,55,70,45,60,30), ['clear body', plus, minus]).
pokemon(klinklang, [steel], stats(60,100,115,70,85,90), ['clear body', plus, minus]).
pokemon(koffing, [poison], stats(40,65,95,60,45,35), [levitate]).
pokemon(krabby, [water], stats(30,105,90,25,25,50), ['hyper cutter', 'sheer force', 'shell armor']).
pokemon(kricketot, [bug], stats(37,25,41,25,41,25), ['run away', 'shed skin']).
pokemon(kricketune, [bug], stats(77,85,51,55,51,65), [swarm, technician]).
pokemon(krokorok, [dark, ground], stats(60,82,45,45,45,74), ['anger point', moxie, intimidate]).
pokemon(krookodile, [dark, ground], stats(95,117,80,65,70,92), ['anger point', moxie, intimidate]).
pokemon(kyogre, [water], stats(100,100,90,150,140,90), [drizzle]).
pokemon(primal(kyogre), [water], stats(100,150,90,180,160,90), ['primordial sea']).
pokemon(kyurem, [dragon, ice], stats(125,130,90,130,90,95), [pressure]).
pokemon(black(kyurem), [dragon, ice], stats(125,170,100,120,90,95), [teravolt]).
pokemon(white(kyurem), [dragon, ice], stats(125,120,90,170,100,95), [turboblaze]).
pokemon(lairon, [rock, steel], stats(60,90,140,50,50,40), ['heavy metal', 'rock head', sturdy]).
pokemon(lampent, [fire, ghost], stats(60,40,60,95,60,55), ['flame body', 'flash fire', infiltrator]).
pokemon(landorus, [flying, ground], stats(89,125,90,115,80,101), ['sand force', 'sheer force']).
pokemon(therian(landorus), [flying, ground], stats(89,145,90,105,80,91), [intimidate]).
pokemon(lanturn, [electric, water], stats(125,58,58,76,76,67), [illuminate, 'water absorb', 'volt absorb' ]).
pokemon(lapras, [water, ice], stats(130, 85, 80, 85, 95, 60), ['water absorb', 'shell armor', hydration]).
pokemon(larvesta, [bug, fire], stats(55,85,55,50,55,60), ['flame body', swarm]).
pokemon(larvitar, [ground, rock], stats(50,64,50,45,50,41), [guts, 'sand veil']).
pokemon(latias, [dragon, psychic], stats(80,80,90,110,130,110), [levitate]).
pokemon(mega(latias), [dragon, psychic], stats(80,100,120,140,150,110), [levitate]).
pokemon(latios, [dragon, psychic], stats(80,90,80,130,110,110), [levitate]).
pokemon(mega(latios), [dragon, psychic], stats(80,130,100,160,120,110), [levitate]).
pokemon(leafeon, [grass], stats(65,110,130,60,65,95), [chlorophyll, 'leaf guard']).
pokemon(leavanny, [bug, grass], stats(75,103,80,70,80,92), [chlorophyll, swarm, overcoat]).
pokemon(ledian, [bug, flying], stats(55,35,50,55,110,85), ['early bird', swarm, 'iron fist']).
pokemon(ledyba, [bug, flyong], stats(40,20,30,40,80,55), ['early bird', swarm, rattled]).
pokemon(lickilicky, [normal], stats(110,85,95,80,95,50), ['cloud nine', 'own tempo', oblivious]).
pokemon(lickitung, [normal], stats(90,55,75,60,75,30), ['cloud nine', 'own tempo', oblivious]).
pokemon(liepard, [dark], stats(64,88,50,88,50,106), [limber, unburden, prankster]).
pokemon(lileep, [grass, rock], stats(66,41,77,61,87,23), ['storm drain', 'suction cups']).
pokemon(lilligant, [grass], stats(70,60,75,110,75,90), [chlorophyll, 'own tempo', 'leaf guard']).
pokemon(lillipup, [normal], stats(45,60,45,25,45,55), [pickup, 'vital spirit', 'run away']).
pokemon(linoone, [normal], stats(78,70,61,50,61,100), [gluttony, 'quick feet', pickup]).
pokemon(litleo, [fire, normal], stats(62,50,58,73,54,72), [moxie, unnerve, rivalry]).
pokemon(litwick, [fire, ghost], stats(50,30,55,65,55,20), ['flame body', infiltrator, 'flash fire']).
pokemon(lombre, [grass, water], stats(60,50,50,60,70,50), ['own tempo', 'swift swim', 'rain dish']).
pokemon(lopunny, [normal], stats(65,76,84,54,96,105), ['cute charm', limber, klutz]).
pokemon(mega(lopunny), [fighting, normal], stats(65,136,94,54,96,135), [scrappy]).
pokemon(lotad, [grass, water], stats(40,30,30,40,50,30), ['own tempo', 'rain dish', 'swift swim']).
pokemon(loudred, [normal], stats(84,71,43,71,43,48), [scrappy, soundproof]).
pokemon(lucario, [fighting, steel], stats(70,110,70,115,70,90), [justified, 'inner focus', steadfest]).
pokemon(mega(lucario), [fighting, steel], stats(70,145,88,140,70,112), [adaptability]).
pokemon(ludicolo, [grass, water], stats(80,70,70,90,100,70), ['own tempo', 'swift swim', 'rain dish']).
pokemon(lugia, [flying, psychic], stats(106,90,130,30,154,110), [multiscale, pressure]).
pokemon(lumineon, [water], stats(69,69,76,69,86,91), ['storm drain', 'water veil', 'swift swim']).
pokemon(lunatone, [psychic, rock], stats(70,55,65,95,85,70), [levitate]).
pokemon(luvdisc, [water], stats(43,30,55,40,65,97), [hydration, 'swift swim']).
pokemon(luxio, [electric], stats(60,85,49,60,49,60), [guts, rivalry, intimidate]).
pokemon(luxray, [electric], stats(80,120,79,95,79,70), [guts, rivalry, intimidate]).
pokemon(machamp, [fighting], stats(90,130,80,65,85,55), [guts, steadfest, 'no guard']).
pokemon(machoke, [fighting], stats(80,100,70,50,60,45), [guts, steadfest, 'no guard']).
pokemon(machop, [fighting], stats(70,80,50,35,35,35), [guts, steadfest, 'no guard']).
pokemon(magby, [fire], stats(45,75,37,70,55,83), ['flame body', 'vital spirit']).
pokemon(magcargo, [fire, rock], stats(50,50,120,80,80,30), ['flame body', 'weak armor', 'magma armor']).
pokemon(magikarp, [water], stats(20,10,55,15,20,80), [rattled, 'swift swim']).
pokemon(magmar, [fire], stats(65,95,57,100,85,93), ['flame body', 'vital spirit']).
pokemon(magmortar, [fire], stats(75,95,67,125,95,83), ['flame body', 'vital spirit']).
pokemon(magnemite, [electric, steel], stats(25,35,70,95,55,45), [analytic, sturdy, 'magnet pull']).
pokemon(magneton, [electric, steel], stats(50,60,95,120,70,70), [analytic, sturdy, 'magnet pull']).
pokemon(magnezone, [electric, steel], stats(70,70,115,130,90,60), [analytic, sturdy, 'magnet pull']).
pokemon(makuhita, [fighting], stats(72,60,30,20,30,25), [guts, 'thick fat', 'sheer force']).
pokemon(malamar, [dark, psychic], stats(86,92,88,68,75,73), [contrary, 'suction cups', infiltrator]).
pokemon(mamoswine, [ground, ice], stats(110,130,80,70,60,80), [oblivious, 'thick fat', 'snow cloak']).
pokemon(manaphy, [water], stats(100,100,100,100,100,100), [hydration]).
pokemon(mandibuzz, [dark, flying], stats(110,65,105,55,95,80), ['big pecks', 'weak armor', overcoat]).
pokemon(manectric, [electric], stats(70,75,60,105,60,105), [lightningrod, static, minus]).
pokemon(mega(manectric), [electric], stats(70,75,80,135,80,135), [intimidate]).
pokemon(mankey, [fighting], stats(40,80,35,35,45,70), ['anger point', 'vital spirit', defiant]).
pokemon(mantine, [flying, water], stats(65,40,70,80,140,70), ['swift swim', 'water veil', 'water absorb']).
pokemon(mantyke, [flying, water], stats(45,20,50,60,120,50), ['swift swim', 'water veil', 'water absorb']).
pokemon(maractus, [grass], stats(75,86,67,106,67,60), [chlorophyll, 'water absorb', 'storm drain']).
pokemon(mareep, [electric], stats(55,40,40,65,45,35), [plus, static]).
pokemon(marill, [fairy, water], stats(70,20,50,20,50,40), ['huge power', 'thick fat', 'sap sipper']).
pokemon(marowak, [ground], stats(60,80,110,50,80,45), ['battle armor', 'rock head', lightningrod]).
pokemon(marshtomp, [ground, water], stats(70,85,70,60,70,50), [torrent, damp]).
pokemon(masquerain, [bug, flying], stats(70,60,62,80,82,60), [intimidate, unnerve]).
pokemon(mawile, [fairy, steel], stats(50,85,85,55,55,50), ['hyper cutter', 'sheer force', intimidate]).
pokemon(mega(mawile), [fairy, steel], stats(50,105,125,55,95,50), ['huge power']).
pokemon(medicham, [fighting, psychic], stats(60,60,75,60,75,80), ['pure power', telepathy]).
pokemon(mega(medicham), [fighting, psychic], stats(60,100,85,80,85,100), ['pure power']).
pokemon(meditite, [fighting, psychic], stats(30,40,55,40,55,60), ['pure power', telepathy]).
pokemon(meganium, [grass], stats(80,82,100,83,100,80), ['leaf guard', overgrow]).
pokemon(meloetta, [normal, psychic], stats(100,77,77,128,128,90), ['serene grace']).
pokemon(pirouette(meloetta), [fighting, normal], stats(100,128,90,77,77,128), ['serene grace']).
pokemon(meowstic, [psychic], stats(74,48,76,83,81,104), [competetive, 'keen eye', infiltrator, prankster]).
pokemon(meowth, [normal], stats(40,45,35,40,40,90), [technician, pickup, unnerve]).
pokemon(mesprit, [psychic], stats(80,105,105,105,105,80), [levitate]).
pokemon(metagross, [psychic, steel], stats(80,135,130,95,90,70), ['clear body', 'light metal']).
pokemon(mega(metagross), [psychic, steel], stats(80,145,150,105,110,110), ['rough claws']).
pokemon(metang, [psychic, steel], stats(60,75,100,55,80,50), ['clear body', 'light metal']).
pokemon(metapod, [bug], stats(50,20,55,25,25,30), ['shed skin']).
pokemon(mew, [psychic], stats(100,100,100,100,100,100), [synchronize]).
pokemon(mewtwo, [psychic], stats(106,110,90,154,90,130), [pressure, unnerve]).
pokemon(mega(mewtwo, x), [fighting, psychic], stats(106,190,100,154,100,130), [steadfest]).
pokemon(mega(mewtwo, y), [psychic], stats(106,150,70,194,120,140), [insomnia]).
pokemon(mienfoo, [fighing], stats(45,85,50,55,50,65), ['inner focus', regenerator, reckless]).
pokemon(mienshao, [fighting], stats(65,125,60,95,60,105), ['inner focus', regenerator, reckless]).
pokemon(mightyena, [dark], stats(70,90,70,60,60,70), [intimidate, 'quick feet', moxie]).
pokemon(milotic, [water], stats(95,60,79,100,125,81), [competetive, 'marvel scale', 'cute charm']).
pokemon(miltank, [normal], stats(95,80,105,40,70,100), ['sap sipper', 'thick fat', scrappy]).
pokemon('mime jr.', [fairy, psychic], stats(20,25,45,70,90,60), [filter, technician, soundproof]).
pokemon(minccino, [normal], stats(55,50,40,40,40,75), ['cute charm', technician, 'skill link']).
pokemon(minun, [electric], stats(60,40,50,75,85,95), [minus, 'volt absorb']).
pokemon(misdreavus, [ghost], stats(60,60,60,85,85,85), [levitate]).
pokemon(mismagius, [ghost], stats(6,60,60,105,105,105), [levitate]).
pokemon(moltres, [fire, flying], stats(90,100,90,125,85,90), [pressure]).
pokemon(monferno, [fighting, fire], stats(64,78,52,78,52,81), [blaze, 'iron fist']).
pokemon(mothim, [bug, flying], stats(70,94,50,94,50,66), [swarm, 'tinted lens']).
pokemon('mr. mime', [fairy, psychic], stats(40,45,65,100,120,90), [filter, technician, soundproof]).
pokemon(mudkip, [water], stats(50,70,50,50,50,40), [torrent, damp]).
pokemon(muk, [poison], stats(105,105,75,65,100,50), ['poison touch', 'sticky hold', stench]).
pokemon(munchlax, [normal], stats(135,85,40,40,85,5), [gluttony, 'thick fat', pickup]).
pokemon(munna, [psychic], stats(76,25,45,67,55,24), [forewarn, telepathy, synchronize]).
pokemon(murkrow, [dark, flying], stats(60,85,42,85,42,91), [insomnia, 'super luck', prankster]).
pokemon(musharna, [psychic], stats(116,55,85,107,95,29), [forewarn, telepathy, synchronize]).
pokemon(natu, [flying, psychic], stats(40,50,45,70,45,70), ['early bird', synchronize, 'magic bounce']).
pokemon(nidoking, [ground, poison], stats(81,102,77,85,75,85), ['poison point', 'sheer force', rivalry]).
pokemon(nidoqueen, [ground, poison], stats(90,92,87,75,85,76), ['poison point', 'sheer force', rivalry]).
pokemon(nidoran-f, [poison], stats(55,47,52,40,40,41), [hustle, rivalry, 'poison point']).
pokemon(nidoran-m, [poison], stats(46,57,40,40,40,50), [hustle, rivalry, 'poison point']).
pokemon(nidorina, [poison], stats(70,62,67,55,55,56), [hustle, rivalry, 'poison point']).
pokemon(nidorino, [poison], stats(61,72,57,55,55,65), [hustle, rivalry, 'poison point']).
pokemon(nincada, [bug, ground], stats(31,45,90,30,30,40), ['compound eyes', 'run away']).
pokemon(ninetales, [fire], stats(73,76,75,81,100,100), [drought, 'flash fire']).
pokemon(ninjask, [bug, flying], stats(61,90,45,50,50,160), [infiltrator, 'speed boost']).
pokemon(noctowl, [flying, normal], stats(100,50,50,76,96,70), [insomnia, 'tinted lens', 'keen eye']).
pokemon(noibat, [dragon, flying], stats(40,30,35,45,40,55), [frisk, telepathy, infiltrator]).
pokemon(noivern, [dragon, flying], stats(85,70,80,97,80,123), [frist, telepathy, infiltrator]).
pokemon(nosepass, [rock], stats(30,45,135,45,90,30), ['magnet pull', sturdy, 'sand force']).
pokemon(numel, [fire, ground], stats(60,60,40,65,45,30), [oblivious, simple, 'own tempo']).
pokemon(nuzleaf, [dark, grass], stats(70,70,40,60,40,60), [chlorophyll, pickpocket, 'early bird']).
pokemon(octillery, [water], stats(75,105,75,105,75,45), [moody, 'suction cups', sniper]).
pokemon(oddish, [grass, poison], stats(45,50,55,75,65,30), [chlorophyll, 'run away']).
pokemon(omanyte, [rock, water], stats(35,40,100,90,55,35), ['shell armor', 'weak armor', 'swift swim']).
pokemon(omastar, [rock, water], stats(70,60,125,115,70,55), ['shell armor', 'weak armor', 'swift swim']).
pokemon(onix, [ground, rock], stats(35,45,160,30,45,70), ['rock head', 'weak armor', sturdy]).
pokemon(oshawott, [water], stats(55,55,45,63,45,45), ['shell armor', torrent]).
pokemon(pachirisu, [electric], stats(60,45,70,45,90,95), [pickup, 'volt absorb', 'run away']).
pokemon(palkia, [dragon, water], stats(90,120,100,150,120,100), [pressure, telepathy]).
pokemon(palpitoad, [ground, water], stats(75,65,55,65,55,69), [hydration, 'water absorb', 'swift swim']).
pokemon(pancham, [fighting], stats(67,82,62,46,48,43), [scrappy, 'iron fist', 'mold breaker']).
pokemon(pangoro, [dark, fighting], stats(95,124,78,69,71,58), ['iron fist', 'mold breaker', scrappy]).
pokemon(panpour, [water], stats(50,53,48,53,48,64), [gluttony, torrent]).
pokemon(pansage, [grass], stats(50,53,48,53,48,64), [gluttony, overgrow]).
pokemon(pansear, [fire], stats(50,53,48,53,48,64), [gluttony, blaze]).
pokemon(paras, [bug, grass], stats(35,70,55,45,55,25), [damp, 'effect spore', 'dry skin']).
pokemon(parasect, [bug, grass], stats(60,95,80,60,80,30), [damp, 'effect spore', 'dry skin']).
pokemon(patrat, [normal], stats(45,55,39,35,39,42), [analytic, 'run away', 'keen eye']).
pokemon(pawniard, [dark, steel], stats(45,85,70,40,40,60), [defiant, pressure, 'inner focus']).
pokemon(pelipper, [flying, water], stats(60,50,100,85,70,65), ['keen eye', 'rain dish']).
pokemon(persian, [normal], stats(65,70,60,65,65,115), [limber, unnerve, technician]).
pokemon(petilil, [grass], stats(45,35,50,70,50,30), [chlorophyll, 'own tempo', 'leaf guard']).
pokemon(phanpy, [ground], stats(90,60,60,40,40,40), [pickup, 'sand veil']).
pokemon(phantump, [ghost, grass], stats(43,70,48,50,60,38), [frist, 'natural core', harvest]).
pokemon(phione, [water], stats(80,80,80,80,80,80), [hydration]).
pokemon(pichu, [electric], stats(20,40,15,35,35,60), [lightningrod, static]).
pokemon(pidgeot, [flying, normal], stats(83,80,75,70,70,101), ['big pecks', 'tangled feet', 'keen eye']).
pokemon(mega(pidgeot), [flying, normal], stats(83,80,80,135,80,121), ['no guard']).
pokemon(pidgeotto, [flying, normal], stats(63,60,55,50,50,71), ['big pecks', 'tangled feet', 'keen eye']).
pokemon(pidgey, [flying, normal], stats(40,45,40,35,35,56), ['big pecks', 'tangled feet', 'keen eye']).
pokemon(pidove, [flying, normal], stats(50,55,50,36,30,43), ['big pecks', 'super luck', rivalry]).
pokemon(pignite, [fighting, fire], stats(90,93,55,70,55,55), ['thick fat', blaze]).
pokemon(pikachu, [electric], stats(35, 55, 30, 50, 40, 90), [static, 'lightning rod']).
pokemon(piloswine, [ground, ice], stats(100,100,80,60,60,50), [oblivious, 'thick fat', 'snow cloak']).
pokemon(pineco, [bug], stats(50,65,90,35,35,15), [overcoat, sturdy]).
pokemon(pinsir, [bug], stats(65,125,100,55,70,85), ['hyper cutter', 'mold breaker', moxie]).
pokemon(mega(pinsir), [bug, flying], stats(65,155,120,65,90,105), [aerilate]).
pokemon(piplup, [water], stats(53,51,53,61,56,40), [torrent, defiant]).
pokemon(plusle, [electric], stats(60,50,40,80,75,95), [lightningrod, plus]).
pokemon(politoed, [water], stats(90,75,75,90,100,70), [damp, 'water absorb', drizzle]).
pokemon(poliwag, [water], stats(40,50,40,40,40,90), [damp, 'water absorb', 'swift swim']).
pokemon(poliwhirl, [water], stats(65,65,65,50,50,90), [damp, 'water absorb', 'swift swim']).
pokemon(poliwrath, [fighting, water], stats(90,95,95,70,90,70), [damp, 'water absorb', 'swift swim']).
pokemon(ponyta, [fire], stats(50,85,55,65,65,90), ['flame body', 'run away', 'flash fire']).
pokemon(poochyena, [dark], stats(35,55,35,30,30,35), ['quick feet', 'run away', rattled]).
pokemon(porygon, [normal], stats(65,60,70,85,75,40), [analytic, trace, download]).
pokemon(porygon-z, [normal], stats(85,80,70,135,75,90), [adaptability, download, analytic]).
pokemon(porygon2, [normal], stats(85,80,90,105,95,60), [analytic, trace, download]).
pokemon(primeape, [fighting], stats(65,105,60,60,70,95), ['anger point', 'vital spirit', defiant]).
pokemon(prinplup, [water], stats(64,66,68,81,76,50), [defiant, torrent]).
pokemon(probopass, [rock, steel], stats(60,55,145,75,150,40), ['magnet pull', sturdy, ' sand force']).
pokemon(psyduck, [water], stats(50,52,48,65,50,55), ['cloud nine', 'swift swim', damp]).
pokemon(pumpkaboo, [ghost, grass], stats(49,66,70,44,55,51), [frist, pickup, insomnia]).
pokemon(large(pumpkaboo), [ghost, grass], stats(54,66,70,44,55,46), [frist, pickup, insomnia]).
pokemon(small(pumpkaboo), [ghost, grass], stats(44,66,70,44,55,56), [frist, pickup, insomnia]).
pokemon(super(pumpkaboo), [ghost, grass], stats(59,66,70,44,55,41), [frist, pickup, insomnia]).
pokemon(pupitar, [ground, rock], stats(70,84,70,65,70,51), ['shed skin']).
pokemon(purrloin, [dark], stats(41,50,37,50,37,66), [limber, unburden, prankster]).
pokemon(purugly, [normal], stats(71,82,64,64,59,112), [defiant, 'thick fat', 'own tempo']).
pokemon(pyroar, [fire, normal], stats(86,68,72,109,66,106), [moxie, unnerve, rivalry]).
pokemon(quagsire, [ground, water], stats(95,85,85,65,65,35), [damp, unaware, 'water absorb']).
pokemon(quilava, [fire], stats(58,64,58,80,65,35), [blaze, 'flash fire']).
pokemon(quilladin, [grass], stats(61,78,95,56,58,57), [overgrow, bulletproof]).
pokemon(qwilfish, [poison, water], stats(65,95,75,55,55,85), [intimidate, 'swift swim', 'poison point']).
pokemon(raichu, [electric], stats(60,90,55,90,80,110), [lightningrod, static]).
pokemon(raikou, [electric], stats(90,85,75,115,100,115), [pressure]).
pokemon(ralts, [fairy, psychic], stats(28,25,25,45,35,40), [synchronize, trace, telepathy]).
pokemon(rampardos, [rock], stats(97,165,60,65,50,58), ['sheer force', 'mold breaker']).
pokemon(rapidash, [fire], stats(65,100,70,80,80,105), ['flame body', 'run away', 'flash fire']).
pokemon(raticate, [normal], stats(55,81,60,50,70,97), [guts, 'run away', hustle]).
pokemon(rattata, [normal], stats(30,56,35,25,35,72), [guts, 'run away', hustle]).
pokemon(rayquaza, [dragon, flying], stats(105,150,90,150,90,95), ['air lock']).
pokemon(mega(rayquaza), [dragon, flying], stats(105,180,100,180,100,115), ['delta stream']).
pokemon(regice, [ice], stats(80,50,100,100,200,50), ['clear body']).
pokemon(regigigas, [normal], stats(110,160,110,80,110,100), ['slow start']).
pokemon(regirock, [rock], stats(80,100,200,50,100,50), ['clear body']).
pokemon(registeel, [steel], stats(80,75,150,75,150,50), ['clear body']).
pokemon(remoraid, [water], stats(35,65,35,65,35,65), [hustle, sniper, moody]).
pokemon(reshiram, [dragon, fire], stats(100,120,100,150,120,90), [turboblaze]).
pokemon(reuniclus, [psychic], stats(110,65,75,125,85,30), ['magic guard', regenerator, overcoat]).
pokemon(rhydon, [ground, rock], stats(105,130,120,45,45,40), [lightningrod, 'rock head', reckless]).
pokemon(rhyhorn, [ground, rock], stats(80,85,95,30,30,25), [lightningrod, 'rock head', reckless]).
pokemon(rhyperior, [ground, rock], stats(115,140,130,55,55,40), [lightningrod, reckless, 'solid rock']).
pokemon(riolu, [fighting], stats(40,70,40,35,40,60), ['inner focus', steadfest, prankster]).
pokemon(roggenrola, [rock], stats(55,75,85,25,25,15), ['sand force', sturdy]).
pokemon(roselia, [grass, poison], stats(50,60,45,100,80,65), ['leaf guard', 'poison point', 'natural core']).
pokemon(roserade, [grass, poison], stats(60,70,65,125,105,90), ['natural core', 'poison point', technician]).
pokemon(rotom, [electric, ghost], stats(50,50,77,95,77,91), [levitate]).
pokemon(fan(rotom), [electric, flying], stats(50,65,107,105,107,86), [levitate]).
pokemon(frost(rotom), [electric, ice], stats(50,65,107,105,107,86), [levitate]).
pokemon(heat(rotom), [electric, fire], stats(50,65,107,105,107,86), [levitate]).
pokemon(mow(rotom), [electric, grass], stats(50,65,107,105,107,86), [levitate]).
pokemon(wash(rotom), [electric, water], stats(50,65,107,105,107,86), [levitate]).
pokemon(rufflet, [flying, normal], stats(70,83,50,37,50,60), [hustle, 'sheer force', 'keen eye']).
pokemon(sableye, [dark, ghost], stats(50,75,75,65,65,50), ['keen eye', stall, prankster]).
pokemon(mega(sableye), [dark, ghost], stats(50,85,125,85,115,20), ['magic bounce']).
pokemon(salamence, [dragon, flying], stats(95,135,80,110,80,100), [intimidate, moxie]).
pokemon(mega(salamence), [dragon, fyling], stats(95,145,130,120,90,120), [aerilate]).
pokemon(samurott, [water], stats(95,100,85,108,70,70), ['shell armor', torrent]).
pokemon(sandile, [dark, ground], stats(50,72,35,35,35,65), ['anger point', moxie, intimidate]).
pokemon(sandshrew, [ground], stats(50,75,85,20,30,40), ['sand rush', 'sand veil']).
pokemon(sandslash, [ground], stats(75,100,110,45,55,65), ['sand rush', 'sand veil']).
pokemon(sawk, [fighting], stats(75,125,75,30,75,85), ['inner focus', 'mold breaker', sturdy]).
pokemon(sawsbuck, [grass, normal], stats(80,100,70,60,70,95), [chlorophyll, 'serene grace', 'sap sipper']).
pokemon(scatterbug, [bug], stats(38,35,40,27,25,35), ['compound eyes', 'shield dust', 'friend guard']).
pokemon(sceptile, [grass], stats(70,85,65,105,85,120), [overgrow, unburden]).
pokemon(mega(sceptile), [dragon, grass], stats(70,110,75,145,85,145), [lightningrod]).
pokemon(scizor, [bug, steel], stats(70,130,100,55,80,65), ['light metal', technician, swarm]).
pokemon(mega(scizor), [bug, steel], stats(70,150,140,65,100,75), [technician]).
pokemon(scolipede, [bug, poison], stats(60,100,89,55,69,112), ['speed boost', 'poison point', swarm]).
pokemon(scrafty, [dark, fighting], stats(65,90,115,45,115,58), [intimidate, 'shed skin', moxie]).
pokemon(scraggy, [dark, fighting], stats(50,75,70,35,70,48), [intimidate, 'shed skin', moxie]).
pokemon(scyther, [bug, flying], stats(70,110,80,55,80,105), [steadfest, technician, swarm]).
pokemon(seadra, [water], stats(55,65,95,95,45,85), [damp, sniper, 'poison point']).
pokemon(seaking, [water], stats(80,92,65,65,80,68), [lightningrod, 'water veil', 'swift swim']).
pokemon(sealeo, [ice, water], stats(90,60,70,75,70,45), ['ice body', 'thick fat', oblivious]).
pokemon(seedot, [grass], stats(40,40,50,30,30,30), [chlorophyll, pickpocket, 'early bird']).
pokemon(seel, [water], stats(65,45,55,45,70,45), [hydration, 'thick fat', 'ice body']).
pokemon(seismitoad, [ground, water], stats(105,95,75,85,75,74), ['poison touch', 'water absorb', 'swift swim']).
pokemon(sentret, [normal], stats(35,46,34,35,45,20), [frisk, 'run away', 'keen eye']).
pokemon(serperior, [grass], stats(75,75,95,75,95,113), [contrary, overgrow]).
pokemon(servine, [grass], stats(60,60,75,60,75,83), [contrary, overgrow]).
pokemon(seviper, [poison], stats(73,100,60,100,60,65), [infiltrator, 'shed skin']).
pokemon(sewaddle, [bug, grass], stats(45,53,70,40,60,42), [chlorophyll, swarm, overcoat]).
pokemon(sharpedo, [dark, water], stats(70,120,40,95,40,95), ['rough skin', 'speed boost']).
pokemon(mega(sharpedo), [dark, water], stats(70,140,70,110,65,105), ['strong jaw']).
pokemon(shymin, [grass], stats(100,100,100,100,100,100), ['natural core']).
pokemon(sky(shymin), [flying, grass], stats(100,103,75,120,75,127), ['serene grave']).
pokemon(shedinja, [bug, ghost], stats(1,90,45,30,30,40), ['wonder guard']).
pokemon(shelgon, [dragon], stats(65,95,100,60,50,50), [overcoat, 'rock head']).
pokemon(shellder, [water], stats(30,65,100,45,25,40), [overcoat, 'skill link', 'shell armor']).
pokemon(shellos, [water], stats(76,48,48,57,62,34), ['sand force', 'storm drain', 'sticky hold']).
pokemon(shelmet, [bug], stats(50,40,85,40,65,25), [hydration, 'shell armor', overcoat]).
pokemon(shieldon, [rock, steel], stats(30,42,118,42,88,30), [soundproof, sturdy]).
pokemon(shiftry, [dark, grass], stats(90,100,60,90,60,80), [chlorophyll, pickpocket, 'early bird']).
pokemon(shinx, [electric], stats(45,65,34,40,34,45), [guts, rivalry, intimidate]).
pokemon(shroomish, [grass], stats(60,40,60,40,60,35), ['effect spore', 'quick feet', 'poison heal']).
pokemon(shuckle, [bug, rock], stats(20,10,230,10,230,5), [contrary, sturdy, gluttony]).
pokemon(shuppet, [ghost], stats(44,75,35,63,33,45), ['cursed body', insomnia, frisk]).
pokemon(sigilyph, [flying, psychic], stats(72,58,80,103,80,97), ['magic guard', 'wonder skin', 'tinted lens']).
pokemon(silcoon, [bug], stats(50,35,55,25,25,15), ['shed skin']).
pokemon(simipour, [water], stats(75,98,63,98,63,101), [gluttony, torrent]).
pokemon(simisage, [grass], stats(75,98,63,98,63,101), [gluttony, overgrow]).
pokemon(simisear, [fire], stats(75,98,63,98,63,101), [blaze, gluttony]).
pokemon(skarmory, [steel, flying], stats(66, 80, 140, 40, 70, 70), ['keen eye', sturdy, 'weak armor']).
pokemon(skiddo, [grass], stats(66,65,48,62,57,52), ['grass pelt', 'sad sipper']).
pokemon(skiploom, [flying, grass], stats(55,45,50,45,65,80), [chlorophyll, 'leaf guard', infiltrator]).
pokemon(skitty, [normal], stats(40,45,45,35,35,50), ['cute charm', 'wonder skin', normalize]).
pokemon(skorupi, [bug, poison], stats(40,50,90,30,55,65), ['battle, armor', sniper, 'keen eye']).
pokemon(skrelp, [poison, water], stats(50,60,60,60,60,30), [adaptability, 'poison touch', 'poison point']).
pokemon(skuntank, [dark, poison], stats(103,93,67,71,61,84), [aftermath, stench, 'keen eye']).
pokemon(slaking, [normal], stats(150,160,100,95,65,100), [truant]).
pokemon(slakoth, [normal], stats(60,60,60,35,35,30), [truant]).
pokemon(sliggoo, [draon], stats(68,75,53,83,113,60), [gooey, 'sap sipper', hydration]).
pokemon(slowbro, [psychic, water], stats(95,75,110,100,80,30), [oblivios, regenerator, 'own tempo']).
pokemon(mega(slowbro), [psychic, water], stats(95,75,180,130,80,30), ['shell armor']).
pokemon(slowking, [psychic, water], stats(95,75,80,100,110,30), [oblivous, regenerator, 'own tempo']).
pokemon(slowpoke, [psychic, water], stats(90,65,65,40,40,15), [oblivious, regenerator, 'own tempo']).
pokemon(slugma, [fire], stats(40,40,40,70,40,20), ['flame body', 'weak armor', 'magma armor']).
pokemon(slurpuff, [fairy], stats(82,80,86,85,75,72), ['sweet veil', unburden]).
pokemon(smeargle, [normal], stats(55,20,35,20,45,75), [moody, technician, 'own tempo']).
pokemon(smoochum, [ice, psychic], stats(45,30,15,85,65,65), [forewarn, oblivious, hydration]).
pokemon(sneasel, [dark, ice], stats(55,95,55,35,75,115), ['inner focus', 'keen eye', pickpocket]).
pokemon(snivy, [grass], stats(45,45,55,45,55,63), [contrary, overgrow]).
pokemon(snorlax, [normal], stats(160, 110, 65, 65, 110, 30), ['immunity', 'thick fat', gluttony]).
pokemon(snorunt, [ice], stats(50,50,50,50,50,50), ['ice body', moody, 'inner focus']).
pokemon(snover, [grass, ice], stats(60,62,50,62,60,40), ['snow warning', soundproof]).
pokemon(snubbull, [fairy], stats(60,80,50,40,40,30), [intimidate, 'run away', rattled]).
pokemon(solosis, [psychic], stats(45,30,40,105,50,20), ['magic guard', regenerator, overcoat]).
pokemon(solrock, [psychic, rock], stats(70,95,85,55,65,70), [levitate]).
pokemon(spearow, [flying, normal], stats(40,60,30,31,31,70), ['keen eye', sniper]).
pokemon(spewpa, [bug], stats(45,22,60,27,30,29), ['friend guard', 'shed skin']).
pokemon(spheal, [ice, water], stats(70,40,50,55,50,25), ['ice body', 'thick fat', oblivious]).
pokemon(spinarak, [bug, poison], stats(40,60,40,40,40,30), [insomnia, swarm, sniper]).
pokemon(spinda, [normal], stats(60,60,60,60,60,60), [contrary, 'own tempo', 'tangled feet']).
pokemon(spiritomb, [dark, ghost], stats(50,92,108,92,108,35), [infiltrator, pressure]).
pokemon(spoink, [psychic], stats(60,25,35,70,80,60), [gluttony, 'thick fat', 'own tempo']).
pokemon(spritzee, [fairy], stats(78,52,60,63,65,23), ['aroma veil', healer]).
pokemon(squirtle, [water], stats(44,48,65,50,64,43), [torrent, 'rain dish']).
pokemon(stantler, [normal], stats(73,95,62,85,65,85), [frisk, 'sap sipper', intimidate]).
pokemon(staraptor, [flying, normal], stats(85,120,70,50,60,100), [intimidate, reckless]).
pokemon(staravia, [flying, normal], stats(55,75,50,40,40,80), [intimidate, reckless]).
pokemon(starly, [flying, normal], stats(40,55,30,30,30,60), ['keen eye', reckless]).
pokemon(starmie, [psychic, water], stats(60,75,85,100,85,115), [analytic, 'natural core', illuminate]).
pokemon(staryu, [water], stats(30,45,55,70,55,85), [analytic, 'natural core', illuminate]).
pokemon(steelix, [ground, steel], stats(75,85,200,55,65,30), ['rock head', 'sheer force', sturdy]).
pokemon(mega(steelix), [ground, steel], stats(75,125,230,55,95,30), ['sand force']).
pokemon(stoutland, [normal], stats(85,110,90,45,90,80), [intimidate, srappy, 'sand rush']).
pokemon(stunfisk, [electric, ground], stats(109,66,84,81,99,32), [limber, static, 'sand veil']).
pokemon(stunky, [dark, poison], stats(63,63,47,41,41,74), [aftermath, stench, 'keen eye']).
pokemon(sudowoodo, [rock], stats(70,100,115,30,65,30), [rattled, sturdy, 'rock head']).
pokemon(suicune, [water], stats(100,75,115,90,115,85), [pressure]).
pokemon(sunflora, [grass], stats(75,75,55,105,85,30), [chlorophyll, 'solar power', 'early bird']).
pokemon(sunkern, [grass], stats(30,30,30,30,30,30), [chlorophyll, 'solar power', 'early bird']).
pokemon(surskit, [bug, water], stats(40,30,32,50,52,65), ['rain dish', 'swift swim']).
pokemon(swablu, [flying, normal], stats(45,40,60,40,75,50), ['cloud nine', 'natural cure']).
pokemon(swadloon, [bug, grass], stats(55,63,90,50,80,42), [chlorophyll, overcoat, 'leaf guard']).
pokemon(swalot, [poison], stats(100,73,83,73,83,55), [gluttony, 'sticky hold', 'liquid ooze']).
pokemon(swampert, [ground, water], stats(100,110,90,85,90,60), [damp, torrent]).
pokemon(mega(swampert), [ground, water], stats(100,150,110,95,110,70), ['swift swim']).
pokemon(swanna, [flying, water], stats(75,87,63,87,63,98), ['big pecks', 'keen eye', hydration]).
pokemon(swellow, [flying, normal], stats(60,85,60,50,50,125), [guts, scrappy]).
pokemon(swinub, [ground, ice], stats(50,50,40,30,30,50), [oblivious, 'snow cloak', 'thick fat']).
pokemon(swirlix, [fairy], stats(62,48,66,59,57,49), ['sweet veil', unburden]).
pokemon(swoobat, [flying, psychic], stats(67,57,55,77,55,114), [klutz, unaware, simple]).
pokemon(sylveon, [fairy], stats(96, 65, 65, 110, 130, 60), [pixilate, 'cute charm']).
pokemon(taillow, [flying, normal], stats(40,55,30,30,30,85), [guts, scrappy]).
pokemon(talonflame, [fire, flying], stats(78,81,71,74,69,126), ['flame body', 'gale wings']).
pokemon(tangela, [grass], stats(65,55,115,100,40,60), [chlorophyll, regenerator, 'leaf guard']).
pokemon(tangrowth, [grass], stats(100,100,125,110,50,50), [chlorophyll, regenerator, 'leaf guard']).
pokemon(tauros, [normal], stats(75,100,95,40,70,110), ['anger point', 'sheer force', intimidate]).
pokemon(teddiursa, [normal], stats(60,80,50,50,50,40), ['honey gather', 'quick feet', pickup]).
pokemon(tentacool, [poison, water], stats(40,40,5,50,100,70), ['clear body', 'rain dish', 'liquid ooze']).
pokemon(tentacruel, [poison, water], stats(80,70,65,80,120,100), ['clear body', 'rain dish', 'liquid ooze']).
pokemon(tepig, [fire], stats(65,63,45,45,45,45), [blaze, 'thick fat']).
pokemon(terrakion, [fighting, rock], stats(91,129,90,72,90,108), [justified]).
pokemon(throh, [fighting], stats(120,100,85,30,85,45), [guts, 'mold breaker', 'inner focus']).
pokemon(thundurus, [electric, flying], stats(79,115,70,125,80,111), [defiant, prankster]).
pokemon(therian(thundurus), [electric, flying], stats(79,105,70,145,80,101), ['volt absorb']).
pokemon(timburr, [fighting], stats(75,80,55,25,35,35), [guts, 'sheer force', 'iron fist']).
pokemon(tirtouga, [rock, water], stats(54,78,103,53,45,22), ['solid rock', 'swift swim', sturdy]).
pokemon(togekiss, [fairy, flying], stats(85,50,95,120,115,80), [hustle, 'super luck', 'serene grace']).
pokemon(togepi, [fairy], stats(35,20,65,40,65,20), [hustle, 'super luck', 'serene grace']).
pokemon(togetic, [fairy, flying], stats(55,40,85,80,105,40), [hustle, 'super luck', 'serene grace']).
pokemon(torchic, [fire], stats(45,60,40,70,50,45), [blaze, 'speed boost']).
pokemon(torkoal, [fire], stats(70,85,140,84,70,20), ['shell armor', 'white smoke']).
pokemon(tornadus, [flying], stats(79,115,70,125,80,111), [defiant, prankster]).
pokemon(therian(tornadus), [flying], stats(79,100,80,110,90,121), [regenerator]).
pokemon(torterra, [grass, ground], stats(95,109,105,75,85,56), ['shell armor', overgrow]).
pokemon(totodile, [water], stats(50,65,64,44,48,43), ['sheer force', torrent]).
pokemon(toxicroak, [fighting, poison], stats(83,106,65,86,65,85), [anticipatoin, 'poison touch', 'dry skin']).
pokemon(tranquill, [flying, normal], stats(62,77,62,50,42,65), ['big pecks', 'super luck', rivalry]).
pokemon(trapinch, [ground], stats(45,100,45,45,45,10), ['arena trap', 'sheer force', 'hyper cutter']).
pokemon(treecko, [grass], stats(40,45,35,65,55,70), [unburden, overgrow]).
pokemon(trevenant, [ghost, grass], stats(85,110,76,65,82,56), [frisk, 'natural core', harvest]).
pokemon(tropius, [flying, grass], stats(99,68,83,72,87,51), [chlorophyll, 'solar power', harvest]).
pokemon(trubbish, [poison], stats(50,50,62,40,62,65), [aftermath, 'sticky hold', stench]).
pokemon(turtwig, [grass], stats(55,68,64,65,45,55,31), ['shell armor', overgrow]).
pokemon(tympole, [water], stats(50,50,40,50,40,64), [hydration, 'water absorb', 'swift swim']).
pokemon(tynamo, [electric], stats(35,55,40,45,40,60), [levitate]).
pokemon(typhlosion, [fire], stats(78,84,78,109,85,100), ['flash fire', blaze]).
pokemon(tyranitar, [dark, rock], stats(100,134,110,95,100,61), ['sand stream', unnerve]).
pokemon(mega(tyranitar), [dark, rock], stats(100,164,150,95,120,71), ['sand stream']).
pokemon(tyrantrum, [dragon, rock], stats(82,121,119,69,59,71), ['rock head', 'strong jaw']).
pokemon(tyrogue, [fighting], stats(35,35,35,35,35,35), [guts, 'vital spirit', steadfest]).
pokemon(tyrunt, [dragon, rock], stats(58,89,77,45,45,48), ['strong jaw', sturdy]).
pokemon(umbreon, [dark], stats(95,65,110,60,130,65), ['inner focus', synchronize]).
pokemon(unfezant, [flying, normal], stats(80,115,80,65,55,93), ['big pecks', 'super luck', rivalry]).
pokemon(unown, [psychic], stats(48,72,48,72,48,48), [levitate]).
pokemon(ursaring, [normal], stats(90,130,75,75,75,55), [guts, unnerve, 'quick feet']).
pokemon(uxie, [psychic], stats(75,75,130,75,130,95), [levitate]).
pokemon(vanillish, [ice], stats(51,65,65,80,75,59), ['ice body', 'weak armor']).
pokemon(vanillite, [ice], stats(36,50,50,65,60,44), ['ice body', 'weak armor']).
pokemon(vanilluxe, [ice], stats(71,95,85,110,95,79), ['ice body', 'weak armor']).
pokemon(vaporeon, [water], stats(130,65,60,110,95,65), [hydration, 'water absorb']).
pokemon(venipede, [bug, poison], stats(30,45,59,30,39,57), ['poison point', swarm, 'speed boost']).
pokemon(venomoth, [bug, poison], stats(70,65,60,90,75,90), ['shield dust', 'tinted lens', 'wonder skin']).
pokemon(venonat, [bug, poison], stats(60,55,50,40,55,45), ['compound eyes', 'tinted lens', 'run away']).
pokemon(venusaur, [grass, poison], stats(80, 82, 83, 100, 100, 80), [overgrow, chlorophyll]).
pokemon(mega(venusaur), [grass, poison], stats(80,100,123,122,120,80), ['thick fat']).
pokemon(vespiquen, [bug, flying], stats(70,80,102,80,102,40), [pressure, unnerve]).
pokemon(vibrava, [dragon, ground], stats(50,70,50,50,50,70), [levitate]).
pokemon(victini, [fire, psychic], stats(100,100,100,100,100,100), ['victory star']).
pokemon(victreebel, [grass, poison], stats(80,105,65,100,70,70), [chlorophyll, gluttony]).
pokemon(vigoroth, [normal], stats(80,80,80,55,55,90), ['vital spirit']).
pokemon(vileplume, [grass, poison], stats(75,80,85,110,90,50), [chlorophyll, 'effect spore']).
pokemon(virizion, [fighting, grass], stats(91,90,72,92,50,89), [justified]).
pokemon(vivillon, [bug, flying], stats(80,52,50,90,50,89), ['compound eyes', 'shield dust', 'friend guard']).
pokemon(volbeat, [bug], stats(65,73,55,47,75,85), [illuminate, swarm, prankster]).
pokemon(volcanion, [fire, water], stats(80,110,120,130,90,70), ['water absorb']).
pokemon(volcarona, [bug, fire], stats(85,60,65,135,105,100), ['flame body', swarm]).
pokemon(voltorb, [electric], stats(40,30,50,55,55,100), [aftermath, static, soundproof]).
pokemon(vullaby, [dark, flying], stats(70,55,75,45,65,60), ['big pecks', 'wark armor', overcoat]).
pokemon(vulpix, [fire], stats(38,41,40,50,65,65), [drought, 'flash fire']).
pokemon(wailmer, [water], stats(130,70,35,70,35,60), [oblivious, 'water veil', pressure]).
pokemon(wailord, [water], stats(170,90,45,90,45,60), [oblivious, 'water veil', pressure]).
pokemon(walrein, [ice, water], stats(110,80,90,95,90,65), ['ice body', 'thick fat', oblivious]).
pokemon(wartortle, [water], stats(59,63,80,65,80,58), ['rain dish', torrent]).
pokemon(watchog, [normal], stats(60,85,69,60,69,77), [analytic, 'keen eye', illuminate]).
pokemon(weavile, [dark, ice], stats(70,120,65,45,85,125), [pickpocket, pressure]).
pokemon(weedle, [bug, poison], stats(40,35,30,20,20,50), ['run away', 'shield dust']).
pokemon(weepinbell, [grass, poison], stats(65,90,50,85,45,55), [chlorophyll, gluttony]).
pokemon(weezing, [poison], stats(65,90,120,85,70,60), [levitate]).
pokemon(whimsicott, [fairy, grass], stats(60,67,85,77,75,116), [chlorophyll, prankster, infiltrator]).
pokemon(whirlipede, [bug, poison], stats(40,55,99,40,79,47), ['poison point', swarm, 'speed boost']).
pokemon(whiscash, [ground, water], stats(110,78,73,76,71,60), [anticipation, oblivious, hydration]).
pokemon(whismur, [normal], stats(64,51,23,51,23,28), [rattled, soundproof]).
pokemon(wigglytuff, [fairy, normal], stats(140,70,45,85,50,45), [competetive, frisk, 'cute charm']).
pokemon(wingull, [flying, water], stats(40,30,30,55,30,85), ['keen eye', 'rain dish']).
pokemon(wobbuffet, [psychic], stats(190,33,58,33,58,33), ['shadow tag', telepathy]).
pokemon(woobat, [flying, psychic], stats(55,45,43,55,43,72), [klutz, unaware, simple]).
pokemon(wooper, [ground, water], stats(55,45,45,25,25,15), [unaware, damp, 'water absorb']).
pokemon(plant(wormadam), [bug, grass], stats(60,59,85,79,105,36), [anticipation, overcoat]).
pokemon(sandy(wormadam), [bug, ground], stats(60,79,105,59,85,36), [anticipation, overcoat]).
pokemon(trash(wormadam), [bug, steel], stats(60,69,95,69,95,36), [anticipation, overcoat]).
pokemon(wurmple, [bug], stats(45,45,35,20,30,20), ['run away', 'shield dust']).
pokemon(wynaut, [psychic], stats(95,23,48,23,48,23), ['shadow tag', telepathy]).
pokemon(xatu, [flying, psychic], stats(65,75,70,95,70,95), ['early bird', synchronize, 'magic bounce']).
pokemon(xerneas, [fairy], stats(126,131,95,131,98,99), ['fairy aura']).
pokemon(yamask, [ghost], stats(38,30,85,55,65,30), [mummy]).
pokemon(yanma, [bug, flying], stats(65,65,45,75,45,95), ['compound eyes', 'speed boost', frisk]).
pokemon(yanmega, [bug, flying], stats(86,76,86,116,56,95), ['compund eyes', 'speed boost', frisk]).
pokemon(yveltal, [dark, flying], stats(126,131,95,131,95,99), ['dark aura']).
pokemon(zangoose, [normal], stats(73,115,60,60,60,90), [immunity, 'toxic boost']).
pokemon(zapdos, [electric, flying], stats(90,90,85,125,90,100), [pressure]).
pokemon(zebstrika, [electric], stats(75,100,63,80,63,116), [lightningrod, 'sap sipper', 'motor drive']).
pokemon(zekrom, [dragon, electric], stats(100,150,120,120,100,90), [teravolt]).
pokemon(zigzagoon, [normal], stats(38,30,41,30,41,60), [gluttony, 'quick feet', pickup]).
pokemon(zoroark, [dark], stats(60,105,60,120,60,105), [illusion]).
pokemon(zorua, [dark], stats(40,65,40,80,40,65), [illusion]).
pokemon(zubat, [flying, poison], stats(40,45,35,30,40,55), [infiltrator, 'inner focus']).
pokemon(zweilous, [dark, dragon], stats(72,85,70,65,70,58), [hustle]).
pokemon(zygarde, [dragon, ground], stats(108,100,121,81,95,95), ['aura break']).
