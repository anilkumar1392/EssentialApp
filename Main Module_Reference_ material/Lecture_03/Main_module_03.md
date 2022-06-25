
##   Interception: An Effective, Modular and Composable Way of Injecting Behavior and Side-effects in the App Composition

Class Inheritance is not composable as you can only inherit from a single class.

Another solution is Use protocol.

## In this lecture, you’ll learn how to use the Decorator pattern to add behavior to an existing component without altering that component. You’ll also learn how to use Interception effectively to inject side-effects in your composition while maintaining modularity and composability.

Learning Outcomes
Isolating side-effects to create simple, testable, and composable operations (Command-Query Separation Principle).
Using the Decorator Design Pattern to intercept and inject side-effects in the system composition, supporting single-purpose, testable, and modular components.
Using the Decorator Design Pattern to extend the behavior of a component without altering it (Open/Closed Principle).

## Interception
In this lecture, we want to save the data loaded from the remote backend to the local cache. The challenge is:

The Feed API module must stay a single-purpose module for communicating with the backend API (Single Responsibility Principle). Thus, it should not know about the cache use cases. The Feed API module should be a standalone module that can be developed, tested, extended, and used in isolation.
The RemoteFeedLoader.load method is a Query. So, we don’t want it performing any mutation in the system state (Command-Query Separation Principle). We need to inject the save side-effect somewhere else.
We want to avoid adding a save method to the <FeedLoader> protocol as not all feed loaders would be able to implement this behavior, i.e., RemoteFeedLoader (Liskov Substitution Principle). Additionally, not every client of the FeedLoader protocol needs the save method (Interface Segregation Principle).
We want to inject the save side-effect without altering existing components (Open/Closed Principle). And we want to find a composable solution that doesn’t rely on inheritance (Composite Reuse Principle).
So how can you fulfill all of those good principles to achieve a clean, modular, and composable solution? And… How can you add new behavior to a component without altering it?

With a Decorator!

When you create good, polymorphic, and single-purpose abstractions such as the FeedLoader protocol, you can use a Decorator to intercept operations easily and alter/extend/inject new behavior into your system.

For example, the new FeedLoaderCacheDecorator is responsible for decorating (intercepting) any <FeedLoader>.load implementation and injecting the <FeedCache>.save side-effect on successful load results.
