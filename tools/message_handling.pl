message_frame(Who, Message_stack, msg(Who, Message_stack)).

empty_message_frame(Who, msg(Who, [])).

push_message_stack(Stack, [], Stack).
push_message_stack(Stack, [Push], [Push|Stack]).
push_message_stack(Stack, [Push|Pushs], Result_stack) :-
  push_message_stack(Stack, [Push], New_stack),
  push_message_stack(New_stack, Pushs, Result_stack).

push_message_frame(msg(Who, Message_stack), Push_stack, msg(Who, New_message_stack)) :-
  push_message_stack(Message_stack, Push_stack, New_message_stack).

messages_of_opposing_view([], []).
messages_of_opposing_view([target(Msg)|Msgs], [user(Msg)|Msgs_opposing]) :-
  messages_of_opposing_view(Msgs, Msgs_opposing).
  messages_of_opposing_view([user(Msg)|Msgs], [target(Msg)|Msgs_opposing]) :-
    messages_of_opposing_view(Msgs, Msgs_opposing).
