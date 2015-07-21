# To run the program
1. load main.pl in your prolog environment
  - the code is only tested in SWI Prolog
2. query the goal `test_battle`
  - this starts a test run with a preset team used by both players

Keep in mind that this could change, as it is still in early development


# About Rot
*Rot* is a portmanteau of *red* and *bot*.

Red stands for the main protagonist of the first generation of core game series of pokemon, namely Pokemon Red Edition and Pokemon Blue Edition. In those games the player plays Red, a 10 year old boy traveling through all the land to become the leading pokemon champion.

Bot is a commonly used short for (software) robot, indicating that the AI of Rot indeed chooses it's actions by itself and without external input but the current game state.

Additionally is *rot* the German word for *red*, thus further implying that Rot is indeed meant to be a software version of Red from the core game series. 

# State of implementation

## API
Currently there is no user API despite the `test_battle` predicate. In the future this is about to change as the following things are planned:
- a team creator
  - create, save and edit your own teams to play with
  - team testing (maybe)
    - Rot battles himself with a given team of yours repeatedly and gives you a quick rating of your team
- choose a team to battle Rot with
  - there shall be a predicate to challenge Rot other as `test_battle`
  - before the battle begins the user may choose one of his saved teams to play with


## Battle Engine
- available actions are either the active pokemon's moves or switches to it's team mates
- the following move effects are fully implemented:
  - physical and special move damage
  - moves inflicting primary status conditions
    - primary status conditions are: `burn`, `freeze`, `paralysis`, `sleep`, `poison` (including `toxic poison`)
  - increases or decreases of the status values
    - the status values are: `attack`, `defense`, `special-attack`, `special-defense`, `speed`
    - at maximum they can be increased by `+6` stages
    - at minimum they can be decreased by `-6` stages
  - life drain and recoil damage
    - life drain effects increase the users hit points by a percentage of the damage done
    - recoil effects inflict damage to the user based on a percentage of the damage done
- not implemented (yet):
  - unique move effects
  - charging or recharging of moves
  - _flinch_, _charm_, _confusion_ and other secondary status conditions
  - abilities
  - items and berries
  - mega evolutions
  - other things not explicitly mentioned to be implemented

## Rot's AI
- uses a search tree of depth 2, thus planing two turns ahead
- if forced to switch out a pokemon, Rot currently chooses randomly - to be changed
- Rot still knows everything about your team, from moves to ev/dv distribution - also to be changed
