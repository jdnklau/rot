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
    `[Ability, Stats, Types, Stat_stages, EV_and_DV]`
    + Stats structure  
      `stats(Attack, Defense, Special_attack, Special_defense, Speed)`
    + Types structure  
      a list containing one or two of the elementary types used in pokemon
    + Stat_stages structure  
      `stat_stages(Attack, Defense, Special_attack, Special_defense, Speed)`  
      each stat increase value ranges from -6 to 6
  + Status_conditions structure  
    `[Primary_condition, Secondary_conditions, Additional_conditions]`
    + Primary_condition  
      may be one of the following: `nil`, `burn`, `freeze`, `paralysis`,
      `poison`, `toxin(Toxin_value)`, `sleep`, and `fainted`
    + Secondary_conditions  
      a list of currently active secondary status conditions (may be empty)  
      possible conditions are:  
      + confused
      + flinched
      + energy-focus
      + (NFI)  
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
  `move(Name, Type, Category_and_power, acc(Accuracy),pp(Power_points), prio(Priority), Flags, Hits, Additional_effects)`
  + Category_and_power format  
    `physical(Power)` or `special(Power)` or `status`
  + Flags format  
    a list containing a selection of the following flags (the list may be emtpy):
    + `high-crit`: the move has a high critical hit ratio
    + `always-crit`: the move always hits critically but for targets immune to critical hits
    + `contact`: the move causes contact
    + `charge`: the move needs to charge up and is executed in the following turn
    + `recharge`: the user needs to recharge the following turn, thus skipping it doing nothing
    + `protect` : the move is blocked by the use of _protect_ or similar moves
    + `reflectable`: the move may be reflected with the ability _magic bounce_ or similar effects
    + `snatch`: the move may be stolen by the use of _snatch_
    + `mirror`: the move can by mirrored by the use of mirror move
    + `punch`: the move is punch-based
    + `sound`: the move is sound based
    + `gravity`: the move is unusable during high gravity
    + `defrost`: the move cures the _frozen_ status condition of the user
    + `heal`: the move is blocked by _heal block_
    + `authentic`: the move ignores a possible _substitute_ of the target
    + `powder`: the move is powder-based
    + `bite`: the move is jaw-based
    + `pulse`: the move is pulse-based
    + `ballistics`: the move is ballistics-based
    + `mental`: the move has a mental effect on the target
  + Hits format  
    as number of guaranteed hits or `between(Minimum, Maximum)`
  + Additional_effects format  
    a list of possible effects (may be empty)
