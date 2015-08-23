%! rot_evaluate_switch(+Player, +Out_pokemon, +In_pokemon, +Opponent_pokemon, +Message_list, -Result_out, -Result_in, Result_opponent).
%
% Evaluates the switching out of a pokemon.
%
% @arg Player Either `rot` or `player`
% @arg Out_pokemon The pokemon data of the pokemon being switched out of battle
% @arg In_pokemon The pokemon data of the pokemon being switched into battle
% @arg Opponent_pokemon The pokemon data of the opposing active pokemon
% @arg Message_list A list of messages occurred by the switch
% @arg Result_out The resulting pokemon data of the switched out pokemon
% @arg Result_in The resulting pokemon data of the switched in pokemon
% @arg Result_opponent The resulting pokemon data of the opposing pokemon
rot_evaluate_switch(Who, Out, In, Opp, List, New_out, In, Opp) :-
  rot_ask_message(switch,_,List,_),
  % handle switch out routine
  clear_stat_stages(Out,New_out),
  % set new active pokemon
  rot_set_active_pokemon(Who, In).

%! rot_set_active_pokemon(+Player, +Pokemon).
% Rot saves the given pokemon as the active pokemon of the given player.
% @arg Player Either `rot` or `player`
% @arg Pokemon The pokemon data of the pokemon in question
rot_set_active_pokemon(player, Pokemon) :-
  % set player's active pokemon
  pokemon_name(Pokemon,Name),
  retractall(rot(opponent_active(_))),
  asserta(rot(opponent_active(Name))).
rot_set_active_pokemon(rot, Pokemon) :-
  % set rot's active pokemon
  pokemon_name(Pokemon,Name),
  retractall(rot(own_active(_))),
  asserta(rot(own_active(Name))).
