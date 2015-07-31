%! create_queue(?Queue).
% Creates an empty queue.
% To enqueue elements to the queue use enqueue/3,
% to dequeue use dequeue/3
% @arg Queue A new, empty queue
% @see enqueue/3
% @see enqueue_list/3
% @see dequeue/3
create_queue(L-L).

%! enqueue(+Element, +Queue, -Result_queue).
% Enqueues a given element to a queue.
% To enqueue a list of elements use enqueue_list/3
% @arg Element The Element to be enqueued
% @arg Queue The queue the element gets enqueued to
% @arg Result_queue The resulting queue
% @see enqueue_list/3
enqueue(E, L-[E|R], L-R).

%! enqueue_list(+List, +Queue, -Result_queue).
% Enqueues a given list of elements to a queue. This list can be a queue itself.
% @arg List The list of elements to be enqueued.
% @arg Queue The queue the elements gets enqueued to
% @arg Result_queue The resulting queue
% @see enqueue/3
enqueue_list([],Q,Q). % base case: nothing to enqueue
enqueue_list([H|T],Q, Q_new) :-
  % enqueues a list
  enqueue(H,Q,QQ),
  enqueue_list(T,QQ,Q_new).
enqueue_list(L-R,Q-L, Q-R). % enqueues queues

%! dequeue(-Element, +Queue, -Result_queue).
% Dequeues the first element from a queue.
% @arg Element The Element dequeued
% @arg Queue The queue the element gets dequeued from
% @arg Result_queue The resulting queue
dequeue(E, L-Last, NewL-Last) :-
    \+ empty_queue(L-Last),
    L = [E|NewL].

%! empty_queue(?Queue).
% True if the given queue is empty.
%
% This predicate is only intended to check whether a queue is empty.
% To get a new queue for enqueueing and dequeueing use create_queue/1 instead.
% @arg Queue An empty queue.
% @see create_queue/1
empty_queue(L-M) :-
    L == M.
