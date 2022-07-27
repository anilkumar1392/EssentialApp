
## Part 2 - Handling selection and navigation in the Composition Root


To decouple the Feed and Comments features, you can handle the navigation from the Feed to the Comments view in the Composition Root.

“In large applications, it’s essential to be able to work with each area of the application in isolation. [...] In theory, we should be able to compose modules any way we like. We may need to write new modules to bind existing modules together in new and unanticipated ways, but, ideally, we should be able to do so without having to modify the existing modules.“—Dependency Injection Principles, Practices, and Patterns by Mark Seemann and Steven van Deursen

At the moment, the navigation via the selection handler is so simple that we decided to keep it in the SceneDelegate. But if your app contains complex flows, you can extract the navigation logic into new components in the Composition Root (e.g., Flow/Coordinator/Router).

## “The Composition Root isn’t a method or a class, it’s a concept. It can be part of the Main method, or it can span multiple classes, as long as they all reside in a single module.“—Dependency Injection: Principles, Practices and Patterns by Mark Seemann, Steven van Deursen

## Dependencies Lifestyle

When managing dependencies from the Composition Root properly, you have much more control over the lifetime of the dependencies.

And it’s the Composer’s job to compose/manage components, including their lifetime.

For example, the Composers use the WeakRefVirtualProxy to avoid retain cycles in the Composition, without leaking those details into modules outside the Composition Root.

Moreover, the SceneDelegate (another component part of the Composition Root) creates and shares a single instance of the HTTPClient and CoreDataFeedStore infrastructure across the features.

As your app grows, you can also manage dependencies with a DI container in the Composition Root.

But the features don’t know about it - which makes the features easier to develop, maintain, test, extend, and reuse.

Using a single shared instance is a composition detail which can save memory, battery, and other device resources. This is such an important concept, that it was formalized into a “Lifestyle pattern” called the “Singleton Lifestyle” (don’t confuse this with the Singleton design pattern).

It’s important to note that instances with a Singleton Lifestyle usually need to be thread-safe as they’re shared among many consumers. Immutable types and stateless service are thread-safe by definition, so they are usually great candidates for a Singleton Lifestyle.

Another example is a “Transient Lifestyle”, where a dependency is released along with its client.

## Common Lifestyle patterns

## DEFINITION: A Lifestyle is a formalized way of describing the intended lifetime of a Dependency.

“Singleton: A single instance is perpetually reused. The resulting behavior is similar to the Singleton design pattern, but the structure is different. With both the Singleton Lifestyle and the Singleton design pattern, there’s only one instance of a Dependency, but the similarity ends there. The Singleton design pattern provides a global point of access to its instance, which is similar to the Ambient Context anti-pattern. A consumer, however, can’t access a Singleton-scoped Dependency through a static member. If you ask two different Composers to serve an instance, you’ll get two different instances. It’s important, therefore, that you don’t confuse the Singleton Lifestyle with the Singleton design pattern. Because only a single instance is in use, the Singleton Lifestyle generally consumes a minimal amount of memory and is efficient. The only time this isn’t the case is when the instance is used rarely but consumes large amounts of memory. In such cases, the instance can be wrapped in a Virtual Proxy. Use the Singleton Lifestyle whenever possible[...]

Transient: New instances are always served. The Transient Lifestyle involves returning a new instance every time it’s requested. The Transient Lifestyle is the safest choice of Lifestyles, but also one of the least efficient. It can cause a myriad of instances to be created and garbage collected, even when a single instance would have sufficed. If you have doubts about the thread-safety of a component, however, the Transient Lifestyle is safe, because each consumer has its own instance of the Dependency. In many cases, you can safely exchange the Transient Lifestyle for a Scoped Lifestyle, where access to the Dependency is also guaranteed to be sequential[...]

Scoped: At most, one instance of each type is served per an implicitly or explicitly defined scope. For example, when building a service application that processes items one by one from a queue, you can imagine each processed item as an individual request, consisting of its own set of Dependencies. The same could hold for desktop or phone applications. Although the top root types (views or ViewModels) could potentially live for a long time, you could see a button press as a request, and you could scope this operation and give it its own isolated bubble with its own set of Dependencies. This leads to the concept of a Scoped Lifestyle, where you decide to reuse instances within a given scope. The Scoped Lifestyle makes sense for long-running applications that are tasked with processing operations that need to run with some degree of isolation. Isolation is required when these operations are processed in parallel, or when each operation contains its own state.“—Dependency Injection Principles, Practices, and Patterns by Mark Seemann and Steven van Deursen

## Base URL and Environment details

A baseURL is usually an environment detail. For example, when running a debug version of your app, you’d probably use a dev or staging API. But the release version of the app would use a prod API.

To avoid leaking unnecessary details into other modules, environment details should ideally be handled in the Composition Root. This way, you avoid complicating independent modules with compilation directives such as #if DEBUG.

The recommendation is to create/manage environment details in the Composition Root, and inject them into the other modules.

For example, you can create the baseURL for the specific environment in the Composition Root, and inject it into the API modules:

class SceneDelegate {
  #if DEBUG
    let baseURL = URL(string: "https://dev.api.com")!
  #else
    let baseURL = URL(string: "https://prod.api.com")!
  #endif

  private func makeRemoteFeedLoaderWithLocalFallback() -> ... {
    let url = FeedEndpoint.get.url(baseURL: baseURL)
    …
  }
}

This way, the API modules are decoupled from environment details. They only contain logic regarding the API contract, such as the endpoint paths (e.g., /v1/feed) and the JSON mapping. (If the endpoint path is also environment-specific, it should ideally be created/managed in the Composition Root.)

You can follow the same principle for any other environment detail, such as injecting environment-specific keys, secrets, local database settings, assets, and so on.

## References

UIViewController.show(_:sender:) reference https://developer.apple.com/documentation/uikit/uiviewcontroller/1621377-show
UIViewController.showDetailViewController(_:sender:) reference https://developer.apple.com/documentation/uikit/uiviewcontroller/1621432-showdetailviewcontroller
UINavigationController reference https://developer.apple.com/documentation/uikit/uinavigationcontroller
Using Autorelease Pool blocks https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmAutoreleasePools.html
Dependency Injection: Principles, Practices, and Patterns by Mark Seemann and Steven van Deursen
