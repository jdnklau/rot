:- use_module(library(doc_files)).

doc :-
  doc_save(., [recursive(true)]).

server :-
  doc_server(4000), portray_text(true).

browse :-
  doc_browser.
