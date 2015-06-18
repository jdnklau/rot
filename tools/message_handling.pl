%! message_frame(+Player, +Message_stack, -Message_frame).
%
% Creates a message frame for the given player.
% The message frame contains the messages of the given message stack.
% To add messages to the frame use push_message_frame/3
%
% @arg Player Either `player` or `rot`
% @arg Message_stack A list containing the messages occured in anti-chronological order
% @arg Message_frame The resuting message frame
message_frame(Who, Message_stack, msg(Who, Message_stack)).

%! empty_message_frame(+Player, -Message_frame)
%
% Creates an empty message frame.
% The same as `message_frame(Player, [], Message_frame)`.
%
% @arg Player Either `player` or `rot`
% @arg Message_frame The resuting message frame
% @see message_frame/3
empty_message_frame(Who, msg(Who, [])).

%! push_message_stack(+Stack, +Messages, -Resulting_stack)
%
% Pushes the given messages onto the stack.
%
% @arg Stack The stack the messages are to be pushed onto
% @arg Messages The messages in chronological order to be pushed onto the stack
% @arg Resulting_stack The resulting stack containing the pushed messages
push_message_stack(Stack, [], Stack).
push_message_stack(Stack, [Push], [Push|Stack]).
push_message_stack(Stack, [Push|Pushs], Result_stack) :-
  push_message_stack(Stack, [Push], New_stack),
  push_message_stack(New_stack, Pushs, Result_stack).

%! push_message_frame(+Message_frame, +Messages, -Resulting_message_frame).
%
% Pushes the given message to the given message frame.
%
% @arg Message_frame The message frame the messages are to be pushed to
% @arg Messages The messages in chronological order to be pushed to the message frame
% @arg Resulting_stack The resulting message frame containing the pushed messages
push_message_frame(msg(Who, Message_stack), Push_stack, msg(Who, New_message_stack)) :-
  push_message_stack(Message_stack, Push_stack, New_message_stack).

%! messages_of_opposing_view(+Message_stack, -Message_stack_opposing_view)
%
% Translates the given message stack to a view opposing to the given one.
% Turns all `target(Msg)` messages to `user(Msg)` messages and vice versa
messages_of_opposing_view([], []).
messages_of_opposing_view([target(Msg)|Msgs], [user(Msg)|Msgs_opposing]) :-
  messages_of_opposing_view(Msgs, Msgs_opposing).
  messages_of_opposing_view([user(Msg)|Msgs], [target(Msg)|Msgs_opposing]) :-
    messages_of_opposing_view(Msgs, Msgs_opposing).
