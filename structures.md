# Quick overview about used data formats

## Game Handling
+ Game State structure  
  `state(Team_A, Team_B, Field_data)`
+ Team structure  
  as list of 1 to 6 Pokemon, active Pokemon is head of list
+ Field_data structure  
  `[Field_A, Field_B, Field_global]`
+ Pokemon structure  
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
      [Primary_condition, Secondary_conditions, Additional_conditions]  
      + Primary_condition  
        may be one of the following: `nil`, `burn`, `freeze`, `paralysis`,
        `poison`, `toxin(Toxin_value)`, `sleep`, and `fainted`
      + Secondary_conditions  
        `[Confusion, Flinch, Focus_energy]` (NFI)

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
