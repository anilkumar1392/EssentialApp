## From Design Patterns to Universal Abstractions Using the Combine Framework

why? would we do that.

Thier is nothing wrong with design pattern.
Some design pattern are equivalent to universal abstractions.

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

## Holding the Cancellable reference
The result of subscribing to a publisher using sink is a Cancellable that exposes a cancel method. You can use it to cancel the operation when you don’t need to receive events anymore.

It’s important to hold a reference to an AnyCancellable because it automatically calls cancel() when deinitialized. So you wouldn’t receive events anymore.

Should we use Combine everywhere?
The composable Combine operators can speed up development and simplify complex tasks with its built-in solutions. So, it can be tempting to start using it everywhere.

But as shown in the lecture, we used Combine only in the Composition Root as building blocks to compose the modules.

We could have instead made all our modules depend on Combine and use its operators everywhere. But that would couple our modules to the Combine framework, including the Core domain layer.

We recommend against coupling all your modules to a specific framework, so you can develop, test, maintain, and deploy your modules in isolation and on any platform.

Moreover, frameworks in the domain layer introduce leaky low-level details. So we suggest at least your Core domain to be free of frameworks. You can design your models and services using pure language features (functions, structs, enums, classes, protocols...).

And you can then compose your application using Combine in a centralized place: the Composition Root. That’s how you can protect your modules from external frameworks and minimize their impact on the overall architecture of the app.

But that’s a decision you and your team will have to make!

References
Some design patterns as universal abstractions https://blog.ploeh.dk/2018/03/05/some-design-patterns-as-universal-abstractions
Combine reference https://developer.apple.com/documentation/combine
Publisher reference https://developer.apple.com/documentation/combine/publisher
Future reference https://developer.apple.com/documentation/combine/future
Deferred reference https://developer.apple.com/documentation/combine/deferred
AnyPublisher reference https://developer.apple.com/documentation/combine/anypublisher
Publisher.eraseToAnyPublisher reference https://developer.apple.com/documentation/combine/publisher/3241548-erasetoanypublisher
Publisher.map reference https://developer.apple.com/documentation/combine/publisher/3204718-map
Publisher.catch reference https://developer.apple.com/documentation/combine/publisher/3204690-catch
Publisher.sink reference https://developer.apple.com/documentation/combine/publisher/3343978-sink
Publisher.receive(on:) reference https://developer.apple.com/documentation/combine/publisher/3204743-receive
Scheduler reference https://developer.apple.com/documentation/combine/scheduler
Cancellable reference https://developer.apple.com/documentation/combine/cancellable


## Revision comments.


Our 'RemoteFeedLoader' does not know combine.
So we need to lift this feedLoader to the Combine world.

So we can wrap feedLoader in a combine publisher.

Their are many publishers you can create and one of them is Future publisher

That starts with a completions block and once you are done with the work you call the compeltion woth some result.
what we can do inside the future is to actually invoke our 'RemoteFeedLoader' load operation and complete with the completion becasue they have matching types.


    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher { // AnyPublisher<[FeedImage], Error>
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: self.httpClient)
        
        // Wrap feedloader in to a publisher.
        // We are wrapping publishers in side a publisher just like we were wrapping our abstractions with decorators, composites and adapters.
        // Wrapping the type to another type to change it's behaviour.

        return Deferred {
            Future { completion in
                remoteFeedLoader.load(completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }

## use eraseToAnyPublisher to hide which kind of publisher we are using.
So when you do not want to expose the specific publisher you are using you can erase to AnyPublisher to hide from clients.

Their is one problem with Future publishers they are eager publisher which means this block will be executed as soon as you created you created the future.

But what we want here is to only fire a request when subscribe to it not on creation of the publisher.
One way to deffer the exection of Future publisher is to wrap them in deffered publisher.
  
  We are wrapping publisher into publisher just like we wrap our abstractions with decorators, composites and adapters.
  ## this is same behaviour of wrapping the one time in to another behaviour to change the behaviour.
  
  INstead of creating our own types we are using Universal abstractions that are bulit-in type.
  
  So now we lifted our 'RemoteFeedLoader' into the combine framework. we can now load the feed using combine publishers.
  
  extension RemoteFeedLaoder {
        typealias Publisher = AnyPublisher<[FeedImage], Swift.Error>
        func loadPublisher() -> Publisher {
             return Deferred {
                Future { completion in
                    remoteFeedLoader.load(completion: completion)
                }
            }
            .eraseToAnyPublisher()
        }
    }
 }
  
  
## we just wrapper the load function into combine publisher.
We still need to perform Composition with the cache and with the fallback.

## let's start with the Cache Decorator.

So 'FeedLoaderCacheDecorator' exist just to add a side effect into a FeedLoader.

So everytime we load something from this FeedLoader we inject the cache side effect using map.
So we are injecting side efect with map.

##  We can do exactly the same thing with Combine operator.

// Where the output is array of FeedImage

extension Publisher where Output == [FeedImage] {
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> {
            map { feed in
                cache.saveIgnoringResult(feed)
                return feed
            }
            .eraseToAnyPublisher()
        }
        
        //        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()

}
 
 ## because when you use a decorator to inject a side effect in to a polymorphic interface you can always replace that with map.
 
 We can also use HandleEvent operation build in specially for Injecting a behaviour.


## Doing the same with fallback logic.

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> Publisher<Output, Failure> {
        // self.catch(fallbackPublisher).eraseToAnyPublisher()
        self.catch { _ in fallbackPublisher }.eraseToAnyPublisher()

    }
    
    // Self is primary and fallbackPubliser is the fallback.
}

Now we want to listen to error and if their is an error if their is a failure we want to load from fallback.

In this case we want to replace the chain with the fallback publisher.

## and their is an operator for that cache operator.

The Cache function expects a Closure that receives an error and returns a Publisher. 

## We will do the same with MainThread Dispatcher.

their is an operator for dispatching on Any queue.

which is receive(on: Schedular)

so 

received(on: DispatchQueue.main).eraseToAnyPublisher()

SO to change the behaviour of DispatchQueue with our own what we can do.
Wrap the main schedular into our own Schedular.

extension DispatchQueue {
    struct ImmediateOnMainQueueSchedular: Schedular {
    }
} 
