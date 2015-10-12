# To run the program
1. load main.pl in your prolog environment
  - the code is only tested in SWI-Prolog 7.2.2
2. to start a battle query
  - `battle` to start a battle with a pre-set team against Rot
      - Rot uses Minimax and the first heuristic
      - `battle(Algorithm, Heuristic)` does the same with a search algorithm
        and a Heuristic of your choice
          - `minmax` is the basic Minimax
          - `minmax_prediction` is Prediction Minimax
          - the heuristics are `simple` (first heuristic),
            `advanced` (second), and `advantage` (third)
  - `rot_battle` to let Rot battle itself
      - both instances use Minimax and the first heuristic by default
      - `battle(Algorithm_1, Heuristic_1, Algorithm_2, Heuristic_2)`
        allows to pick the algorithm and heuristic for each instance
        individually

## To create the documentation
1. load main.pl in your Prolog environment
2. query the goal `[pldoc]`
3. after pldoc.pl is loaded query `doc`
4. The documentation should be in your doc/ directory


# About Rot
*Rot* is a portmanteau of *red* and *bot*.

Red stands for the main protagonist of the first Generation of core game series of Pokemon, namely Pokemon Red Edition and Pokemon Blue Edition. In those games the player plays Red, a 10 year old boy travelling through all the land to become the leading Pokemon champion.

Bot is a commonly used short for (software) robot, indicating that the AI of Rot indeed chooses its actions by itself and without external input but the current game state.


# State of implementation

## Battle Engine
- available actions are either the active Pokemon's moves or switches to its team mates
- the following move effects are fully implemented:
  - physical and special move damage
  - moves inflicting primary status conditions
      - primary status conditions are: `burn`, `freeze`, `paralysis`, `sleep`, `poison`, `bad-poison`
  - increases or decreases of the status values
      - the status values are: `attack`, `defense`, `special-attack`, `special-defense`, `speed`
      - at maximum they can be increased by `+6` stages
      - at minimum they can be decreased by `-6` stages
  - life drain and recoil damage
      - life drain effects increase the users hit points by a percentage of the damage done
      - recoil effects inflict damage to the user based on a percentage of the damage done
- not implemented (yet):
    - unique move effects
    - multi-strike moves
    - charging or recharging of moves
    - _flinch_, _charm_, _confusion_ and other secondary status conditions
    - abilities
    - items and berries
    - mega evolutions
    - other things not explicitly mentioned to be implemented

## Rot's AI
- uses a search tree of depth 2, thus planing two turns ahead
- if forced to switch out a Pokemon, Rot currently chooses randomly
- Rot continuously learns about your team
    - first it sets up very generic data that could unify with every possible set for each Pokemon
    - the data gets updated whilst battling
        - damage done by moves is used to get more information  about the ev/dv split of the Pokemon
    - instead of the real game state Rot creates its own, assumed game state
        - this game state is used for Rots search tree
