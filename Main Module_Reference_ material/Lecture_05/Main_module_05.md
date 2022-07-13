 In last lecture we tested the acceptance criteria with UI Tests which works fine but their are two problems.
 
 1. We eneded up adding test code in our production target. (Test specific code populating the production target)
 2. Those tests are extremely slow.
 
 three simple test stook 30s.
 As we add more features, UI tests will slow down the development process.
 
 Your iterations should be fast, So you can keep merging and releasing code with confidance several times a day.
 But if our CI tool takes hours to run this will become bottle neck.
 
 ## So we need a better statergy to test.
 
So the idea to translate those UI Acceptance test into Integration acceptance tests. 
So they don't need to run the app and investigate elements on screen with the slow UI Queries.

We migrate App UI tests to Integration tests ahving more control than UI tests and faster than UI Tests.

## In this lecture, you’ll learn how to validate your app’s Acceptance Criteria with fast and thorough Integration Tests and how to create and test components of the Composition Root in iOS apps.

Learning Outcomes
Validating acceptance criteria with Integration Tests.
Replacing UI Tests with significantly faster and thorough Integration Tests.
What’s a Composition Root
Where’s the Composition Root in iOS apps
How to test components of the Composition Root
Simulating app launch and state transitions during tests
Testing methods you cannot invoke

## What’s a Composition Root?
Composition Root is an essential Dependency Injection pattern to achieve a clean and modular design.

“When you write loosely coupled code, you create many classes to create an application. It can be tempting to compose these classes at many different locations in order to create small subsystems, but that limits your ability to Intercept those systems to modify their behavior. Instead, you should compose classes in one single area of your application.

When you look at Constructor Injection in isolation, you may wonder, doesn’t it defer the decision about selecting a Dependency to another place? Yes, it does, and that’s a good thing. This means that you get a central place where you can connect collaborating classes.

The Composition Root acts as a third party that connects consumers with their services. The longer you defer the decision on how to connect classes, the more you keep your options open. Thus, the Composition Root should be placed as close to the application’s entry point as possible.”—Dependency Injection: Principles, Practices and Patterns by Mark Seemann, Steven van Deursen

The thing is… When creating independent modules, they should not have any reference to components that belong to another module.

For example, if you want to decouple a Login module from a Feed module (and vice-versa), they should not reference each other. For instance, a component in the Login module should not instantiate a component from the Feed module.

Furthermore, components should require their dependencies through initializer injection.

So, the idea is to create a “Main module” responsible for instantiating and composing all independent modules in a centralized place, aka the “Composition Root.”

Thus, if after login, you want to transition to the feed screen, this transition can be delegated through an abstraction that will be implemented by a component in the Composition Root.

So, the modules are independent of each other. You can easily develop, test, maintain, extend, replace, and reuse them in isolation.

For example, you could easily replace the transition to a “Welcome” screen after login or stop forcing customers to login on startup altogether! You can make those changes without affecting the Login or the Feed module by simply changing the composition from the Composition Root.

Centralizing your app’s instantiation and composition simplifies drastically the development and management of modules, components, and their dependencies.

This way, you can design elegant and independent modules, where components communicate through clean abstractions. Moreover, components don’t need to be concerned about concrete dependency implementations or how to instantiate them. The dependencies can be easily injected and replaced without breaking existing code, promoting composability and extensibility (Open/Closed principle).


## Acceptance criteria of your application and while composition with integration tests.
// Which are much fater adn does not require you to add test ot debug code to the production.

## Scene Delegate and App Delegate are just another class if their is code in their it can be tested.

## when you do not have access to init of a class that means that method can not be invocked.

Ideally framework should give you tools to test your code.
but when they dont their is something we can do.

## Solution: move logic from method that you can not invoke to a method that we can invoke.

Calling configureWindow instead of SceneDelegate method.

