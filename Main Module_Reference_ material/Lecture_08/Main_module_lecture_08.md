##   Organizing Modular Codebases with Horizontal and Vertical Slicing

## Learning Outcomes
Horizontal modular slicing by layers
Vertical modular slicing by features
Organizing the codebase into independent frameworks and projects


## 1. Monolith - Single project with a single application target
The most common way to organize projects is to keep all components in a single project with a single application target. For example, an iOS application target where all components live:

This may work well for small projects and prototypes but can quickly become a bottleneck as the team grows, and more features are added to the app.

The more code you add to a single target, the more conflicts will arise. And the longer it will take to build, run, and test the project.

Moreover, there’s no physical separation of modules. So, it requires discipline to keep your code modular.


## In the core we have models and abstraction (service interfaces)

we have a protocol defining a way to load image data, another one to load feed and a domain model representing a domain model.

SO this Code Module does not depend on any other module.

Ref: Core_module

Their ar eno arrows from this module pointing to any other module. on the contrary other module depend on any other module.

The 'FeedApiModule' has implementations of the service and the use cases.
The 'FeedCacheModule' again has use case implementations  valdiating and controlling the cache. So feedCache also depends on feedFeature.
Then we have 'FeedPresentationModule' which also depends on 'FeedFeature' Module.
and finally we have UI that renders 'FeedImageViewModel' on screen.
Specifically it's a UIKit implementation for iOS.

Since this is a modular design we can easily replace UKit with swiftUI.
Without changing any thing in other Module. 

At the bottom we have platform specifc module.
And all the other module on top are platform agnostic that can be used in cross-platform.

Any infrastructure Implementation can be easily replaced.

## So we can change FeedApi Module without affecting anyother module, we can change the cache without effecting any other module.
we can plug new user interfaces we can plug new caching infrastrucutre we can plug new Api infrastructure because our module are decoupled.

At the center we have only Domain Specific Service Abstraction and Domain models.

## Ref: Dependency_in_circel

1. In the Center we have Only  specific service abstractions and Domain models
2. Around it we have more sepcialized implementations.
3. And on the oputer layers we have infrastructure implementations.
4. In the even outer layer we have frameworks.

Thats how we protect our code bases from external influences.

So we can represent this in circular or Onion Architecture.

## Infra Strucutre adapters that will provide communication with the external frameworks.

So the Infrastructure adapter are platform or framework specific.

## Inner layers don't know about outer layer.

This provide untimate Plug-ability, ultimate freedom.

## It's all about slicing your applciation in to layers and mamaging the dependecy between them.
High level module should not depend on low level module.


## So how to arrange this layers in our projects.

In our current Implemenations we have

Workspace that contain two projects.

EssentialFeed
EssentialApp

Inside the 'EssentailFeed' we have two frameworks 'EssentialFeed' and 'EssentialFeediOS'.
'EssentialFeed' for platform agnostic components.
'EssentialFeediOS' for platform specific framework for iOS specific components.

The Other project is Application Specific project (EssentialApp).
So we have one applcication Target that depends on 'FeedFrameworks'.


So In  EssentialApp we have composition root that composes platform aagnostic with the platform specific modules.

So right now we have One Workspace, two Projects and three Targets.

## Every thing under same repository Which is the easiest way to maintain your modular application under source control in one repository.

Everything in one repository.
Separate project, separate targets depending on what you need.

But if you want to put down code under Separate repositoy That's much harder to maintain.
You will probably need CocoaPods, Git Submodules and Carthage or Swift Package manager.

## How you are going to organize your project also depends on your Team structure.

Like if you have Feature team, or Remote Teams.
all of that influences how you are going to organize your project.


## but as soon as you acheive a clear seperation between your modules.

That gives you ability to slice and peel your architecture and replace things easily.

## References
Mentoring Session #006 - Architecture and Software Design https://academy.essentialdeveloper.com/courses/1112681/lectures/23826885
Clean Architecture by Robert C. Martin https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
