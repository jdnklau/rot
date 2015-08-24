# To run the program
1. load main.pl in your prolog environment
  - the code is only tested in SWI Prolog
2. query the goal `test_battle`
  - this starts a test run with a preset team used by both players

Keep in mind that this could change, as it is still in early development

# Test Queries
As there currently is no API worth mentioning (see below: _State of implementation - API_) everything is run by certain test calls.

- `test_ui/0`
  - displays the user interface and displays Rot's and the player's teams with their active pokemon
  - this tests:
      - interface display in general
      - setup predicates for pokemon data
  - there are individual tests for either Rot's or the player's team on their own:
      - `test_ui_rot/0`
      - `test_ui_player/0`
- `test_battle/0`
  - sets up a battle between Rot and the player
  - uses a generic team of 6 pokemon used by both sides
      - Pikachu, Snorlax, Lapras, Venusaur, Charizard, Blastoise
      - this is Rot's team in *Pokemon Black 2 Edition* and *Pokemon White 2 Edition*
          - few moves (but no more than 3 of all 24) are not the same as in those games mentioned
  - **this is currently the only way to actually test the AI in action**
  - `test_battle_small/0` does the same but with a team of only 3 pokemon on each side
      - Venusaur, Charizard, Blastoise
- `test_available_actions/0`
  - displays a list of available actions to a certain team
      - the team used is the small team mentioned above at `test_battle/0`-`test_battle_small`
      - actions are switches to other pokemon in the team (not the active one, not fainted ones) or moves usable by the active pokemon
  - implementation may change in the future as PP usage, trapping pokemon, and various other not yet implemented factors could alter the available actions and need to be tested then
- `test_tree/0`
  - tests the creation of the search tree
  - prompts for a tree depth to create
      - tree depth is how many turns are planned ahead in the search tree
      - calling `test_tree/1` does the same, but the 1st argument already is the tree depth
  - **known problems**
      - (SWI) Prolog can not handle a fully created (means no pruned options) search tree of depth 3 or higher
- `test_tree_search/0`
  - prompts for a tree depth `D`
  - creates a search tree of the given depth `D`
  - searches the tree for the best moves by the player and Rot
      - output is `expected:(Player_action,Rot_action)`
- `test_evolutions/0`
  - tests if all pokemon mentioned in `database/evolutions.pl` by the `evolves_to/2` predicate actually are pokemon in the database
- `test_pokemon_name/1`
  - tests if a given pokemon name (1st argument) can be matched with a pokemon from the database
  - writes to console if a name is unknown



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
