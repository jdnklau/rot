print_teams(Team_A, Team_B) :-
  print_team_enemy(Team_B),
  print_team_player(Team_A).

print_team_enemy(Team) :-
  Team = [Active|_],
  print_team_pokeballs_enemy(Team),nl,
  Active = [Name, kp(KP_cur, KP_max), _,_,_,_],
  Perc is round(KP_cur / KP_max * 100),
  write(Perc), write('% '), write(Name), write(' (rot)'),nl.

print_team_pokeballs_enemy([]).
print_team_pokeballs_enemy([_|Rest]) :-
  write('O'),
  print_team_pokeballs_enemy(Rest).

print_team_player(Team) :-
  Team = [Active|Team_rest],
  print_active_pokemon_player(Active),!,
  write('team:'), nl,
  print_team_rest_player(Team_rest).

print_active_pokemon_player([Name, kp(KP_cur, KP_max), Moves,_,_,_]) :-
  Perc is round(KP_cur/KP_max * 100),
  write(Perc), write('%'), tab(1), write(Name), write(' (you)'), nl,
  tab(2),write('at '),write(KP_cur), write('/'), write(KP_max), write(' KP'),nl,nl,
  print_active_pokemon_moves(Moves).

print_active_pokemon_moves([]).
print_active_pokemon_moves([[Move,PP_cur]|Rest]) :-
  tab(2),
  move(Move, Type, Category, acc(Accuracy), _, _, _),
  write(Move), write(' - '),
  write(PP_cur), write('pp, '),
  write(Type), write(' type, '),
  ((Category =.. [Cat, Power],
    write(Cat), write(', '),
    write('power:'), write(Power), write(', '))
    ;
    (Category = status,
      write(status), write(', '))),
  write('accuracy:'), write(Accuracy),nl,
  print_active_pokemon_moves(Rest).

print_team_rest_player([]).
print_team_rest_player([Team_mate|Rest]) :-
  print_team_mate_player(Team_mate),
  print_team_rest_player(Rest).

print_team_mate_player([Name, kp(KP_cur, KP_max), _, _, _, _]) :-
  tab(2), write(Name), tab(1), write(at), tab(1),
  Perc is floor(KP_cur/KP_max * 100),
  ui_write_percentage(Perc), nl.

print_help_message :-
  nl,
  write('> for a specific move type the move name between a pair of \' (apostrophe)'), nl,
  tab(2), write('example: \'tackle\'.'),nl,
  write('> for switching to a partner type switch(\'partner name here\')'), nl,
  tab(2), write('example: switch(\'pikachu\').'),nl,
  write('> you can always end the battle by typing: run.'), nl, nl,
  write('>>> as shown in the examples all choices have to end with a . (full stop)'), nl, nl.

opposite_player(you, rot).
opposite_player(rot, you).

print_effectiveness_message(1).
print_effectiveness_message(1.0).
print_effectiveness_message(0) :-
ui_no_effect, nl.
print_effectiveness_message(0.0) :-
ui_no_effect, nl.
print_effectiveness_message(E) :-
E > 1,
ui_very_effective, nl.
print_effectiveness_message(E) :-
E < 1,
ui_not_very_effective, nl.

ui_no_effect :- tab(2),write('it has no effect').
ui_very_effective :- tab(2),write('it is very effective').
ui_not_very_effective :- tab(2),write('it is not very effective').

ui_move_misses :- tab(2), write('but it misses').
ui_uses_move(Pokemon, Who, Move_name) :- write(Pokemon), write(' ('), write(Who), write(') uses '), write(Move_name).
ui_switching(Out, In, Who) :-
  write(Out), write(' is called back by '), write(Who),
  write(' and instead '), write(In), write(' is send in').

ui_write_percentage(P) :- write(P), write('%').
ui_hp_changed(Pokemon, Who, kp(KP_new, KP_max)) :-
  tab(2), write(Pokemon), write(' ('), write(Who), write(') is now at '),
  Perc is floor(KP_new/KP_max*100),
  ui_write_percentage(Perc).

ui_run_away :- write('you escaped safely').
ui_choose_move_prompt :- write('choose your move: ').
ui_already_fighting(Pokemon) :- tab(2),write(Pokemon), write(' is already fighting').
ui_no_such_team_member(Pokemon) :- tab(2),write('there is no '), write(Pokemon), write(' in the team').
ui_move_unknown(Pokemon, Move) :- tab(2),write(Pokemon), write(' does not know how to '), write(Move).
