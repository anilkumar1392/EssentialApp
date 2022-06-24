
## How to compose objects that share common interface with a composite design pattern.

Test against abstraction rather than concrete types.
Test components in isolation.
Because Concrete type can  change at nay type so it will break those tests.


In a Spy we capture the values to use them for later but In a stub we set the value upfront.

1. Stub
2. Spy  

They both have merits and disadvantages.
// Nothing is perfect the more techniques you know the more option you have to solve different problems.
It's all about mamangeing the trade-offs. 

## Learning Outcomes
Testing component behavior with the Stub test-double
Creating a flexible and modular strategy for loading data from remote with fallback logic without altering the services or the clients (Open/Closed Principle).
Composing objects that share a common interface with the Composite Design Pattern

## The Stub test-double
Stubs provide predefined responses to method invocations made during the tests. Opposed to the Spy test double, a Stub doesn’t capture values for later inspection or usage.

Stubs are simple test-double that can help you create flexible tests. Stubs usually require you to write less code, but may result in less code coverage when not used properly. Moreover, stubs can lead you to make too many upfront design decisions, resulting in a longer feedback loop. For simple use cases, Stubs work just fine. But when you want to take smaller steps and gain more control, a Spy can be a better choice.

##Composing the remote loader with the local fallback
1. Composition with concrete types
In this implementation, the RemoteWithLocalFallbackFeedLoader composite conforms to <FeedLoader> and depends on the concrete RemoteFeedLoader and LocalFeedLoader types.

Traits:

Compile-time type checks for composing the correct objects.
The composite is coupled with the concrete types.
Testing the composite would be done in integration with the concrete types instead of in isolation. Any change in the public interfaces of the concrete RemoteFeedLoader or LocalFeedLoader would potentially break the composite tests.

## 2. Composition with abstract types
In this implementation, the RemoteWithLocalFallbackFeedLoader composite conforms to <FeedLoader> and depends on the <FeedLoader> abstraction for representing the remote and local fallback strategy. In this composition variation, we don’t have to expose the concrete types. Instead, we can pass the RemoteFeedLoader and LocalFeedLoader types when composing the RemoteWithLocalFallbackFeedLoader.

Traits:

Working with abstractions as dependencies instead of concrete types increases our flexibility.
Can test the RemoteWithLocalFallbackFeedLoader in isolation as opposed to integration.
Can’t enforce compile-time checks for passing the dependencies in the correct order.


## 3. Composition with custom protocol abstractions
In this composition variation, the RemoteWithLocalFallbackFeedLoader composite conforms to <FeedLoader> and it depends on two new protocol abstractions: the <RemoteFeedLoader> and the <LocalFeedLoader> (both protocols inherit from the <FeedLoader> protocol). These abstractions are meant to be used only as type annotations for the composite. The concrete RemoteFeedLoader and LocalFeedLoader will then be extended in the composition module to conform to the respective protocols.

Mind how in the diagram above the RemoteFeedLoader and LocalFeedLoader extension arrows are colored orange, the color used for denoting the Composition layer. This is because the <RemoteFeedLoader> and <LocalFeedLoader> protocol abstractions belong in the Composition layer, whereas the RemoteFeedLoader and LocalFeedLoader belong in their own modules, agnostic of the existence of the custom protocol abstractions.

Traits:

Enforce compile-time checks for guaranteeing we are passing the dependencies in the correct order.
Working with abstractions as dependencies instead of concrete types increases our flexibility.
Can test the composite in isolation.
End up with more types and more complexity.

## The Composite Design Pattern
The Composite design pattern allows you to compose objects into tree structures to represent part or whole hierarchies. A Composite enables its clients to treat individual objects and compositions of objects uniformly, through a single interface.

A Composite object graph can look like the following diagram:


Since all the composition participants share the same interface, a Composite object graph can scale infinitely. For example, as shown in the diagram above a Composite object can refer to two types of dependencies:

A leaf object, which doesn’t extend further the composition.
Another Composite object, which extends the composition further.
“The Composite pattern makes the client simple. Clients can treat composite structures and individual objects uniformly. Clients normally don’t know (and shouldn’t care) whether they’re dealing with a leaf or a composite component. This simplifies client code, because it avoids having to write tag-and-case-statement-style functions over the classes that define the composition.

The Composite pattern makes it easier to add new kinds of components. Newly defined Composite or Leaf subclasses work automatically with existing structures and client code. Clients don’t have to be changed for new Component classes.” — Gamma, Johnson, Vlissides, Helm, “Design Patterns”

## Related Patterns
1. Strategy Design Pattern
“Define a family of algorithms, encapsulate each one, and make them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

Use the Strategy pattern when:

• many related classes differ only in their behavior. Strategies provide a way to configure a class with one of many behaviors.
• you need different variants of an algorithm. For example, you might define algorithms reflecting different space/time trade-offs. Strategies can be used when these variants are implemented as a class hierarchy of algorithms.
• an algorithm uses data that clients shouldn’t know about. Use the Strategy pattern to avoid exposing complex, algorithm-specific data structures.
• a class defines many behaviors, and these appear as multiple conditional statements in its operations. Instead of many conditionals, move related conditional branches into their own Strategy class.”— Gamma, Johnson, Vlissides, Helm, “Design Patterns”
2. Chain of Responsibility Design Pattern
“Avoid coupling the sender of a request to its receiver by giving more than one object a chance to handle the request. Chain the receiving objects and pass the request along the chain until an object handles it.

Use Chain of Responsibility when:

• more than one object may handle a request, and the handler isn’t known a priori. The handler should be ascertained automatically.
• you want to issue a request to one of several objects without specifying the receiver explicitly.
• the set of objects that can handle a request should be specified dynamically.”— Gamma, Johnson, Vlissides, Helm, “Design Patterns”
