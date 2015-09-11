%! log_win(+Winner).
% Increases the win counter for the winner in the corresponding log file.
%
% The log file is created automatically and contains data in the form `Player-Rot`
% where ``Player`` and ``Rot`` are non-negative integer variables representing the
% amount of times won against the other.
%
% Currently only does something if `rot(self_battle)` is true, assuming the battling
% instances of Rot are `rot` and `blau`
% @arg Winner Either `rot` or `player`
log_win(Who) :-
  rot(self_battle), % always log if Rot battles itself
  rot(instance(rot,[Rot|_])), % algorithm instance #1
  rot(instance(blau,[Blau|_])), % algorithm instance #2
  % create log file name
  atomics_to_string(['logs/log',win,Blau,vs,Rot],'_',Logfile),
  % make sure logfile exists
  log_win_assure_existance(Logfile),
  log_win_write(Logfile,Who).
log_win(_).

log_win_assure_existance(F) :-
  \+ exists_file(F),!,
  open(F,write,S),
  write(S,'0-0.'),
  close(S).
log_win_assure_existance(_).

log_win_write(Lf, player) :-
  % read wins
  open(Lf,read,Read), % open log file
  read(Read,P-R),
  close(Read),
  open(Lf,write,Write), % open log file again
  PP is P+1,
  write(Write, PP-R),
  write(Write,'.'),
  close(Write).
log_win_write(Lf, rot) :-
  % read wins
  open(Lf,read,Read), % open log file
  read(Read,P-R),
  close(Read),
  open(Lf,write,Write), % open log file again
  RR is R+1,
  write(Write, P-RR),
  write(Write,'.'),
  close(Write).
