%! create_message_frame(+State, +Player, +Action, -Message_frame).
%
% Creates an empty message frame for the given player.
%
% The frame is intended to contain all messages of events caused by the given
% action to the given game state.
% The given game state does not reflect those events and is to be understood
% as the base state the events are applied to (does not happen in the message frame
% but externally by the program).
%
% To create a message frame already filled with messages use create_message_frame/3
%
% To add messages to the frame use add_message_frame/3
%
% @arg State The base game state the messages originate from
% @arg Player Either `player` or `rot`
% @arg Action The action applied to the base game state causing the messages
% @arg Message_frame The resuting message frame
% @see create_message_frame/3
create_message_frame(State, Who, Action, msg(Who, Action, A1, A2, msgcol([]))) :-
  translate_attacker_state(State, Who, State_atk),
  % get active pokemon
  attacking_pokemon(State_atk, A1),
  defending_pokemon(State_atk, A2).

%! create_message_frame(+State, +Player, +Action, +Message_collection, -Message_frame).
%
% Creates a message frame for the given player.
% The message frame contains the messages of the given message collection.
%
% The frame is intended to contain all messages of events caused by the given
% action to the given game state.
% The given game state does not reflect those events and is to be understood
% as the base state the events are applied to (does not happen in the message frame
% but externally by the program).
%
% To create an empty message frame use create_message_frame/2.
%
% To add messages to the frame use add_message_frame/3
%
% @arg State The base game state the messages originate from
% @arg Player Either `player` or `rot`
% @arg Action The action applied to the base game state causing the messages
% @arg Message_collection A message collection preferably build with add_messages/3
% @arg Message_frame The resuting message frame
create_message_frame(State, Who, Action, msgcol(Message_collection), Message_frame) :-
  create_message_frame(State,Who,Action,Empty_frame), % create empty frame
  add_message_frame(msgcol(Message_collection), Empty_frame, Message_frame). % add messages to frame

%! message_frame_meta_data(+Message_frame, -Player, -Action, -Active_pokemon_player, -Active_pokemon_opponent).
% Retrieves the meta informations from a given message frame.
% @arg Message_frame The message frame in question
% @arg Player The corresponding player; either `rot` or `player`
% @arg Action The action causing the messages frame's messages
% @arg Active_pokemon_player The active pokemon's name of the given player
% @arg Active_pokemon_opponent The active pokemon's name of the given player's opponent
message_frame_meta_data(msg(Who,Ac,A1,A2,_), Who, Ac, A1, A2).

%! add_messages(+Messages, +Collection, -Resulting_message_collection)
%
% Adds the given messages to the message collection.
%
% @arg Messages A message collection or a list of messages in chronological order to be added
% @arg Collection The message collection the new messages shall be added to
% @arg Resulting_message_collection The resulting collection containing the new messages
add_messages([], msgcol(Stack), msgcol(Stack)). % add nothing to a collection
%add_messages([], List, Messages) :-
%  % add nothing to a list that is not a collection.
%  List \= msgcol(_),
%  add_messages(List, [], Messages). % create a message collection
add_messages([Push], msgcol(Stack), msgcol([Push|Stack])). % add  message to a collection
add_messages(Pushs, [], Result) :-
  % add a message to an empty collection
  add_messages(Pushs, msgcol([]), Result), !.
add_messages([Push|Pushs], msgcol(Stack), Result_stack) :-
  % add a list of messages to a collection
  add_messages([Push], msgcol(Stack), New_stack),
  add_messages(Pushs, New_stack, Result_stack).
add_messages(msgcol(Pushs), msgcol(Stack), msgcol(Result)) :-
  % add two message collections together
  append(Pushs, Stack, Result).

%! add_message_frame(+Message_collection, +Message_frame, -Resulting_message_frame).
%
% Adds a message collection to the message frame.
%
% @arg Message_collection The message collection to be added to the message frame
% @arg Message_frame The message frame the messages are added to
% @arg Resulting_message_collection The resulting message frame containing the new messages
add_message_frame(Messages, msg(Who,Ac,A1,A2, Message_collection), msg(Who,Ac,A1,A2, New_message_collection)) :-
  add_messages(Messages, Message_collection, New_message_collection).

%! pop_message_frame(-Message , +Message_frame, -Resulting_message_frame).
%
% Retrieves and deletes the next message from a given message frame.
% Fails if there is no message left.
%
% @arg Message The next message
% @arg Message_frame The message frame the next message shall be extracted from
% @arg Resulting_message_frame The message frame without the popped message
pop_message_frame(Message,
    msg(Who, Ac, A1, A2, msgcol([Message|Message_collection])),
    msg(Who, Ac, A1, A2, msgcol(Message_collection))
  ).

%! empty_message_frame(+Message_frame).
% True if the given message frame contains no messages
% @arg Message_frame The message frame in question
empty_message_frame(Frame) :-
  \+ pop_message_frame(_, Frame, _). % peek if there would be a message

%! messages_of_opposing_view(+Message_collection, -Message_collection_opposing_view)
%
% Translates the given message collection to a view opposing to the given one.
%
% As each message in the collection may be framed by either `target/1` or `user/1` predicates
% it carries a semantic link for whoms player side the message is meant.
% By translating to the opposing view all `target/1` frame become `user/1` frames and vice versa.
%
% Note that messages without such a frame have their `user/1` frame implied and thus are
% translated to have a `target/1` frame.
%
% Note also that, as `user/1` is implied for messages without explicit frames, messages
% with `target/1` frames may be translated to become frameless (as `user/1` is,
% like already said, implied then).
%
% @arg Message_collection The collection of messages to be translated
% @arg Message_collection_opposing_view The translated message collection
messages_of_opposing_view(msgcol(Msg),msgcol(Msg_opp)) :-
  % to operate on the message lists only split the msgcol/1 frame
  messages_of_opposing_view(Msg, Msg_opp).
messages_of_opposing_view([], []). % base case
messages_of_opposing_view([target(Msg)|Msgs], [Msg|Msgs_opposing]) :-
  % target/1 to user/1 (implied)
  messages_of_opposing_view(Msgs, Msgs_opposing).
messages_of_opposing_view([user(Msg)|Msgs], [target(Msg)|Msgs_opposing]) :-
  % user/1 to target/1
  messages_of_opposing_view(Msgs, Msgs_opposing).
messages_of_opposing_view([Msg|Msgs], [target(Msg)|Msgs_opposing]) :-
  % user/1 (implied) to target/1
  Msg \= target(_),
  Msg \= user(_),
  messages_of_opposing_view(Msgs, Msgs_opposing).

%! get_message_frame_list(+Message_frame, -List).
% Returns a list of messages occured in the frame in chronological order
% @arg Message_frame The message frame in question
% @arg List The list of messages the frame contains
get_message_frame_list(Frame, List) :-
  get_message_frame_list_acc(Frame, [], List).
% accumulator to reverse list: by LearnPrologNow
get_message_frame_list_acc(Frame,Seen,List) :-
  pop_message_frame(Msg, Frame, New_frame),
  get_message_frame_list_acc(New_frame, [Msg|Seen], List).
get_message_frame_list_acc(Frame, List, List) :-
  empty_message_frame(Frame).
