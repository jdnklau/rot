# Quick overview about used data formats

## Game Handling
+ Game State  
  `state(Team_A, Team_B, Field_data)`
+ Team  
  as list of 1 to 6 Pokemon, active Pokemon is head of list
+ Field_data structure  
  `[Field_A, Field_B, Field_global]`
+ Pokemon  
  `[Name, kp(Curr, Max), Moves, Status_data, Item, Status_conditions]`
  + Moves structure  
    `[[Move_1, PP_1], [Move_2, PP_2], [Move_3, PP_3], [Move_4, PP_4]]`
  + Status_data structure  
    `[Ability, Stats, Stat_increases, EV_and_DV]`
    + Stats structure  
      `stats(Attack, Defense, Special_attack, Special_defense, Speed)`
    + Stat_increases structure  
      `stat_increases(Attack, Defense, Special_attack, Special_defense, Speed)`  
      each stat increase value ranges from -6 to 6
    + Status_conditions structure  
      `[Primary_condition, Secondary_conditions, Additional_conditions]`
      + Primary_condition  
        may be one of the following: `nil`, `burn`, `freeze`, `paralysis`,
        `poison`, `toxin(Toxin_value)`, `sleep`, and `fainted`
      + Secondary_conditions  
        `[Confusion, Flinch, Focus_energy]` (NFI)  
+ Priority Frame  
  `priorities(Priority_player, Priority_red)`  
  + Priority
    tuple `(Move_priority, Speed_stat)`  
    + Move_priority  
      is the priority level of the choosen move and ranges form -7 to 7
+ Messages Frame  
  `msg(Who, Message_stack)`  
  + Who  
    is either `player` or `rot`  
  + Message_stack  
    stack of combat events; top of stack is the newest event
+ Search Tree  
  `tree(State, Nodes)`  
  + State  
    is the current game state
  + Nodes  
    is a list of `Move_rot:Nodes_by_player_move` entries  
    + Move_rot  
      a move rot could choose
    + Nodes_by_player_move  
      a list of `Move_player:Tree` entries
      + Move_player  
        a move the player could choose
      + Tree  
        a search tree with the resulting state of player's and rot's move choices as root

## Database Handling
+ Saving Pokemon Data  
  `pokemon(Name, Typing, Base_stats, Abilities)`
  + Typing format  
    `[Type]` or `[Type_1, Type_2]`
  + Base_stats format  
    `stats(KP, Attack, Defense, Special_attack, Special_defense, Speed)`
  + Abilities format  
    as list of possible abilities
+ Saving Move Data  
  as predicate `move/9`  
  `move(Name, Type, Category_and_power, acc(Accuracy),pp(Power_points), prio(Priority), Contact, Hits, Additional_effects)`
  + Category_and_power format  
    `physical(Power)` or `special(Power)` or `status`
  + Contact format  
    `contact` or `nocontact`
  + Hits format  
    as number of guaranteed hits or `between(Minimum, Maximum)`
  + Additional_effects format  
    `noeffect` or as list of possible effects
