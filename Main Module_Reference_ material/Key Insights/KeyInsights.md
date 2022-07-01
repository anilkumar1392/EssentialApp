

## Main and the Composition Root
The Main module is where the app composition occurs. In iOS apps, that would be an iOS application target that composes other modules to start the application.

By centralizing the composition in the Main app module, you can keep other modules independent from each other. That’s key for a modular and flexible design.

For example, if you want to decouple the ‘Feed API’, ‘Feed Cache’, and ‘Feed UI’ modules, they should not reference each other. Only the Main module should know how to compose the concrete components of each module.

Centralizing your app’s instantiation and composition drastically simplifies the development and management of modules, components, and their dependencies.

If the API, Cache, and UI don’t know about each other, you can easily develop, test, maintain, extend, and deploy them in isolation. You can also easily replace or reuse those modules in different applications with different compositions.

Those are big wins in productivity and flexibility in app development. It’s how you can go fast without compromising quality.

But for the application to work, the API, Cache, and UI need to work together. So, the idea is to create a “Main module” responsible for instantiating and composing all independent modules in a centralized place, aka the “Composition Root.”

The Composition Root is the most concrete place in your app as it instantiates the concrete components for the app’s composition. The Composition Root is an application detail. Thus, only applications should have a Composition Root, not frameworks.

The Composition Root is supported by the SOLID principles and Dependency Injection patterns such as Initializer, Method, and Property Injection.

This way, you can design elegant and independent modules, where components communicate through clean abstractions. Moreover, components don’t need to be concerned about concrete dependency implementations or how to instantiate them. The dependencies can be easily injected and replaced without breaking existing code, promoting composability and extensibility (Open/Closed principle).

If the modules have unmatching interfaces or cross-cutting concerns, such as threading, analytics, and authentication, you can use Design Patterns (e.g., Decorator, Composite, Adapter) or Universal Abstractions (e.g., Combine’s map, catch, receive(on:)) to compose the components without creating tight coupling between modules.


## Testing the app as a whole

Automated testing is an essential practice to guarantee the correctness and quality of your apps and a productive development process. A trustworthy test suite and CI process can provide you and your team with the confidence to continue implementing the company’s vision. That’s how you can keep delivering great features at a fast and constant pace.

Remember that a good test suite is fast and reliable. So, you need a solid foundation of unit/isolated tests as your team’s primary testing strategy (the base of the testing strategy pyramid).

## 1. UI Testing in Apple’s ecosystem

UI testing allows you to test your app as a “black-box.” You interact with and validate the UI elements of your app using the XCTest APIs that integrate with Accessibility controls.

In other words, UI tests are decoupled from production code. UI tests don’t have access to any concrete implementations of your app, as you would typically with unit/isolated or integration tests.

Thus, unlike unit/isolated and integration tests, UI tests require a running application to execute. Running the application and interacting with UI elements make UI testing a costly testing strategy as it often introduces flakiness in test results and can take a long time to run.

That’s why UI tests allocate a very small portion of the testing strategy pyramid (we want only very few UI tests—if any).

## 2. Acceptance Testing

Acceptance testing is the process of validating the system’s compliance with high-level acceptance criteria or business requirements.

In teams following BDD or similar processes, the acceptance criteria and tests are written by business folks (e.g., business analysts), and they are implemented by QA engineers or developers.

Acceptance tests can be expensive to run as they check real scenarios and the whole system running in integration, usually through the UI.

But you don’t need to run those tests through the UI.

When possible, write them as plain XCTests that can be faster and more reliable since you have more control over the infrastructure details (network, databases, UI…).


## 3. Snapshot Testing

Snapshot tests record a “snapshot” of parts of your system in order to compare them against previously recorded states.

A common use case for snapshot testing is validating the UI of an app. The idea is to automatically store snapshot images of the UI as “recorded states” in tests. Then, you can run those tests again to compare the “current” state matches the “recorded state”.

The tests will pass if the recorded state is the same as the received one, and they will fail if the two snapshots don’t match. So you can ensure the UI looks exactly the same after refactorings, for example.

But you’re not limited to only images. You can also use snapshot tests with other data representations like JSON, XML, and Data.

You should avoid using snapshot tests to validate the logic/behavior of your applications because they aren’t as precise as other testing strategies such as unit/integration testing. For example, when a snapshot test fails, it can be hard to figure out why. You’ll probably have to spend some time debugging. Snapshot tests are also much slower than unit tests since they rely on expensive operations such as rendering the UI and reading stored state from disk.

For example, the average duration of a snapshot test can be 34 times slower than a unit test. But it’s still much faster than UI tests.

# Continuously delivering value with a CD pipeline

## Continuous Delivery is the practice of delivering working software in short cycles, usually several times a week or a day. “Working software” means reliable builds that can be released to customers at any time.

A Continuous Delivery workflow allows your team to continually deliver value to your stakeholders and customers as it eliminates long waiting periods.

In Continuous Delivery, the whole process of generating and uploading a build can also be automated. But approving the build and pushing it to production is done manually.

Once a build is approved by the business, it can be manually pushed to production. But pushing to production should be as simple as pressing a button because the build should always be ready to ship.

Going a step further, the team can achieve Continuous Deployment by eliminating the need for manual approvals

## Continuous Deployment is the practice of automatically approving and pushing builds to production as long as it passes all tests. The team needs to build a lot of confidence in the development process to eliminate the need for manual testing and approval, but it can be done by following practices you’ve been learning in this course such as excellent communication, clear requirements, Test-Driven Development, and supple software design.

Continuous Delivery and Deployment are key elements of technical excellence. Teams that achieve it can more rapidly deliver value to customers and adapt to market changes, which is a huge advantage against competitors.

## Organizing the modules
In the Main module, we covered multiple ways you can break down and organize your projects into modules.

In the Essential Feed Case Study, we’ve been creating decoupled modules and features using Horizontal and Vertical slicing.

The main point is that the domain layer is at the center of the design and it doesn’t depend on any other layer.

On the red layer, we have independent service implementations that depend on the domain layer. On the blue layer, the infrastructure implementations and adapters to protect the inner layers from external frameworks such as URLSession, Firebase, UIKit, SwiftUI, CoreData, Realm, etc.

Moreover, the modules within the same layer can also be decoupled. For example, the ‘Feed API’ and ‘Feed Cache’ modules are within the same red layer, but they don’t know about each other.

New features don’t need to know about each other. So they can follow the same structure but in separate targets and/or projects.
