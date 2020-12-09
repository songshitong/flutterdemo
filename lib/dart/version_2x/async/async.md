//官方文档
https://web.archive.org/web/20170704074724/https://webdev.dartlang.org/articles/performance/event-loop#how-to-schedule-a-task

Event loops and queues
An event loop’s job is to take an item from the event queue and handle it, repeating these two steps for as long as the queue has items.

events going into a queue, feeding into an event loop
events->event queue -> event loop

Dart’s single thread of execution
Once a Dart function starts executing, it continues executing until it exits.
In other words, Dart functions can’t be interrupted by other Dart code.


Dart’s event loop and queues
A Dart app has a single event loop with two queues—the event queue and the microtask queue.

The event queue contains all outside events: I/O, mouse events, drawing events, timers, messages between Dart isolates, and so on.

The microtask queue is necessary because event-handling code sometimes needs to complete a task later, but before returning control to the event loop. For example, when an observable object changes, it groups several mutation changes together and reports them asychronously.
The microtask queue allows the observable object to report these mutation changes before the DOM can show the inconsistent state



How to schedule a task
When you need to specify some code to be executed later, you can use the following APIs provided by the dart:async library:

The Future class, which adds an item to the end of the event queue.
The top-level scheduleMicrotask() function, which adds an item to the end of the microtask queue.


Event queue: new Future()
To schedule a task on the event queue, use new Future() or new Future.delayed(). These are two of the Future constructors defined in the dart:async library.

Note: You can also use Timer to schedule tasks, but if any uncaught exceptions occur in the task, your app will exit. Instead, we recommend Future, which is built on top of Timer and adds features such as detecting task completion and responding to errors.


To immediately put an item on the event queue, use new Future():

// Adds a task to the event queue.
new Future(() {
  // ...code goes here...
});


To enqueue an item after some time elapses, use new Future.delayed():

// After a one-second delay, adds a task to the event queue.
new Future.delayed(const Duration(seconds:1), () {
  // ...code goes here...
});
Although the preceding example adds the task to the event queue after one second, that task can’t execute until the main isolate is idle, the microtask queue is empty, and previously enqueued entries in the event queue are gone.
 For example, if the main() function or an event handler are running an expensive computation, the task can’t execute until after that computation completes. In that case, the delay might be much more than one second.



 Fun facts about Future:

 The function that you pass into Future’s then() method executes immediately when the Future completes. (The function isn’t enqueued, it’s just called.)
 If a Future is already complete before then() is invoked on it, then a task is added to the microtask queue, and that task executes the function passed into then().
 The Future() and Future.delayed() constructors don’t complete immediately; they add an item to the event queue.
 The Future.value() constructor completes in a microtask, similar to #2.
 The Future.sync() constructor executes its function argument immediately and (unless that function returns a Future) completes in a microtask, similar to #2.


 代码执行顺序
 同一个方法中，普通代码先执行，micro task queue ,event task queue
