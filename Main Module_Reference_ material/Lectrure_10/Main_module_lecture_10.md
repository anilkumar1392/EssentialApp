## From Design Patterns to Universal Abstractions Using the Combine Framework


Combine framwork.


Build in Operator handleEvents method is just to inject side effects so can be used when injecting side-effects.
You don't need to develop, test and maintain. 

All loader will be replaced with Publisher.
Use publisher.sink to subscribe to the publisher.
if we don't hold cancellable it will be deallocated and observer will be deleted.

# In this lecture, you’ll learn how to refactor the app composition from Design Patterns to Universal Abstractions using the Combine framework.

##Learning Outcomes
Correlations between SOLID components, Design Patterns, and Universal Abstractions from Category Theory
Using Combine to compose your application in the Composition Root
Future, Deferred, and AnyPublisher publishers
map, handleEvents, catch, eraseToAnyPublisher, sink, and receive(on:) operators
Cancellable


## SOLID Abstractions and Design Patterns

Good abstractions help simplify our code, making it easier to develop, maintain, replace, reuse, and test.

“Abstraction is the elimination of the irrelevant and the amplification of the essential” — Robert C. Martin, Agile Principles, Patterns, and Practices in C#

And good abstractions are supported by the SOLID principles of software design.

For example, the FeedLoader protocol abstraction helped us quickly develop and test parts of the application in isolation since it represents a single-purpose abstraction (Interface Segregation Principle) responsible for a specific service (Single Responsibility Principle) while hiding low-level implementation details (Dependency Inversion Principles).

Moreover, the FeedLoader is a polymorphic interface that allowed us to compose, replace, and inject different implementations (Liskov Substitution Principle) and extend the behavior without altering existing code (Open/Closed Principle).

“...abstractions reduce risk and increase flexibility, making your application cheaper to maintain and easier to change.” — Sandi Metz, Practical Object-Oriented Design in Ruby: An Agile Primer


And with a good abstraction in place, we were able to use Design Patterns to solve common composition challenges.

Design Patterns offer a common vocabulary and proven solutions to recurring problems in software development. And they can help you unleash the full power of SOLID abstractions and modularity.

For example, we’ve been using Design Patterns to decide between different behavior at runtime (Strategy), adapt interfaces (Adapter), add functionality to existing objects and deal with cross-cutting concerns (Decorator), combining components in different ways to achieve higher goals (Composite), and so on.

Those patterns also helped us compose the whole application in the Composition Root while keeping low-coupling between the modules. That’s key to a flexible modular design.

However, there’s a cost for developing, testing, and maintaining implementations of the Design Patterns.

But what if there were built-in ‘Universal Abstractions’ that could act as building blocks for our applications? And what if they could also help us compose our components seamlessly without reinventing the wheel every time?

The thing is…

Those Universal Abstractions exist.

Some Design Patterns like the Composite, Adapter, and Decorator can be seamlessly replaced with universal abstractions from Mathematics and Category Theory.

“The objects of category theory are universal abstractions. Some of them, it turns out, coincide with known design patterns. The difference is, however, that category theory concepts are governed by specific laws. In order to be a functor, for example, an object must obey certain simple and intuitive laws. This makes the category theory concepts more specific, and less ambiguous, than design patterns.” — Mark Seemann
The Combine framework by Apple provides us building blocks based on those universal abstractions. This means that, with SOLID abstractions, you can seamlessly replace some existing design pattern implementations with built-in Combine operators.

As a result, you don’t have to develop, maintain, and test your own implementations.
