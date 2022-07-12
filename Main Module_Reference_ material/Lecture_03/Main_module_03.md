
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

## The Decorator Design Pattern
“As is the case with many other patterns, the Decorator pattern is an old and well-described design pattern that predates DI by a decade. It’s such a fundamental part of Interception that it warrants a refresher.

The Decorator pattern was first described in the book Design Patterns: Elements of Reusable Object-Oriented Software by Erich Gamma et al. (Addison-Wesley, 1994). The pattern’s intent is to “attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.”—Erich Gamma et al., Design Patterns, 175.

A Decorator works by wrapping one implementation of an Abstraction in another implementation of the same Abstraction. This wrapper delegates operations to the contained implementation, while adding behavior before and/or after invoking the wrapped object.

The ability to attach responsibilities dynamically means that you can make the decision to apply a Decorator at runtime rather than having this relationship baked into the program at compile time, which is what you’d do with subclassing.

A Decorator can wrap another Decorator, which wraps another Decorator, and so on, providing a “pipeline” of interception.” – Dependency Injection: Principles, Practices, Patterns by Mark Seemann and Steven van Deursen

## Comments in review

// Classes are not very much composable.

class FeedLoaderTests: XCTestCase {}


but problem is that in the future we might want to compose this class with all the opertions that can be reusable

// But class can inherit form one class.
So the solution is use protocol.
So class Inheritance is not composable it can only inherti form on class.

However a swift class can confirm to multiple protocol.
2. and INherit implemantaiton from their extensions.
3. And you can constrain a protocol to a specific class.
Protcol in swift compose much better than classes.

Swift class can confirm to multiple protocol and inherit all of their extension.

## Decorator does not cache or load it only coordinates the load and cache.
It intercepts the load and it needs to send a message to the cache to save the laoded feed.

We do not want to use LocalFeedLoader as a dependecy in 'FeedLoaderCacheDecorator' as LocalFeedLoader is a concrete type and it has it's own dependecy so we need to create all its dependecny.

Also Doing this our test will be more fragile and This decorator will be less composable.

## We want to test decorator in isolation so we want our decorator to have an abstraciton that also allows composibility.

## Follow command-Query separation and Separate loading from separtion and the compose this functions together.
If you need modularity you can decorate and compose yout components.
When you don't need it. (Eg. very simple apps/ Use cases) you can go with the a more concrete and monolith approach.


## Final thoughts

When you want to ad a new behaviour use decorator and when you want to compose types that sahre common interface use Composites.
