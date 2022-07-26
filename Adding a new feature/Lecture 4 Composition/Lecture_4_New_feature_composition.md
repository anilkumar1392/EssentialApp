## #004 - [Image Comments Composition] Navigation and Feature Composition

In this live lecture, you’ll learn how to handle navigation between independent features without coupling them.

Learning Outcomes
How to navigate between features without breaking modularity or introducing common anti-patterns
How to develop, test and use Composers in the Composition Root
How to develop and test selection handlers
How to use autoreleasepool to release autoreleased instances during tests
Dependency Lifestyles

Part 1 - Composing the Comments feature layers

[] Composition 

    Display a list of comments when user taps on an Image.
    Back button in navigation.
    Cancel any running comment API when the user navigates back.
    
    Integration Tests
    Acceptance Tests.
    
So by now we are ready with FeedImage and FeedComment feature.
So now we need to plug the feed with the comments UI.

So when the user tap on an image we create this object graph here we compose all the moduels all the layers together and present it on the screen.

## Ways to do it
1. One way id to push comments view directly from the FeedUI. (Traditional approach)
    if does instantiate the commets UI withIn the FeedUI and you present it or push it in navigation controller and you present it modally.
    
The problem is that the Comments Scene here it's quite a complex graph Object graph It requires the integration of multuiple layers such as API, presentaiton the UI.

So the FeedUI would have to know how to integrate all those layers to be able to create this object graph 

## So FeedUI have to know all the dependencies of the Comments UI and how to integrate them.

So for simple UI transition that don't require this composition of dependencies just pushing a viewController within another works well no problem.

For Example : if you want to present an AlertController when their is an error we just do it from the controller.
## if we do not have complex dependency we can push it to navigation controller their is not problem with that.

another example:

if our FeedViewModel already has knowledge about commnet so we can push it from controller no problem with that.

class FeedViewController: UITabelViewController {
    overide func tableView(didSelectRowAt indexPath: IndexPath) {
    let commentVC = CommentVC(image.comment)
    self.navigationContoller.pushViewController(vc, false)
    }
}
    
    because their is no complex dependency we can do it in this way no issues.

if it's easy to create a UI from the other one why not.
you don't need to get any external dependency like API and  databases and things like that.

Next viewController is just an extenstion you already have all the data that you need to present the view Controller why not.

## Argument can we do this viewController need to know about that's it is with in an Navigation controller.

if it's with in a navigaiton controller yuo would need to know about the context of the presentation but you can byPass this by using the showAPI every viewController has this 

and UIKIt will decide depending on the context.
if we need to show it in a navigation controller or present it modally.

So this ViewController does not need to know about the context of the presentation, so you do not need to its with in a navigation Controller, a split view controller UIKit is going to determine the best way to present the viewController for you.

Also if you are using Seques you can prepare your dependecies in prepare for segues.

## So if it's a simple dependency and you are happy coupling the parent with the child ViewController that's probably fine to do with in the ViewController.

## But if you are dealing eith a complex Object graph you need to Compose a bunch of layers modules then it becomes quite cumbersome to do all this compositon with in the view controller.

So that's where you start looking for alternatives of handling navigation.

Also their are cases where do not have dependency  their are also cases where we do not want to couple one controller with the other one.

For ex: In the listViewController which is generic viewController which can handle any kind of cell controller,
you would not want the knowledge about what you present within this viewController.

## Other wise their will be bunch of if identifier to specific controllers.

So every time their is a new feature yuo will have to come and add a new identifier in condition.

So if you want to prevent these if else chain everytime you add a new feature.
So everytime you add a newViewController you need to change the Generic One.

then you will start looking for sloutions as well to handle navigations somewhere else.
That's the case we are trying to solve.

## we have got two feartures agnostic of each other.

So navigaiton need to be doen somewhere else this way no components in here need to know thi composition of Comment Feature.

Because everything software depends it depends what you are trying to achieve.
That's the key don't think that just because we are doing it you should also do the same.

when in dought go simple. The simple solution is probably the best way to go.

But if you have a good reason to separate your modules like we are doing, we are going to show you today how we can separate the navigation and decouple the features from each other.

## Because another solution we see a lot in VIPER Implementaiton is to move navigaitons to the presenter.

then we also end up with the similar issues where the presentation either needs to know how to navigate to the next view Controller or it needs to depend on all the other features.

## what we want is no dependency between each other that's the challenge.

and again if you are happy couling one view with the other no problem go ahead.

but if you need this extra flexibilty let's do it in this session.

## remember COmposition Root is the place in your application where you compose all the modules.

and it's the place that allows you to keep all the modules decoupled.
 
 Refer Image: CouplingWithComposition
 
 ## One thing you could do if you are happy coupling the viewControllers is instead of UI Depending on all the moduels the FeedUI can depend on CommentUI Composer but what is the problem here?
 
 Problem: You get the dependencies as well, you don't want isolated modules depending on the Composition Root.
 This is an anti-pattern. 
 what you want is Composition Root depending on the Modules.
 
 we want arrow form compostion root towards the Scenes. we don't want any arrow pointing towards the composition root.
 
 Other wise this will create circular dependency.
 And you also expose all the other moduels depending on compostion root because Composition root depends on all modules.
 
 So we don't want that.
 
 ## what we want is to handle navigation between decoupled features In the Composition Root that already knows about the concrete Implementations.
 
 So we will compose the comments scene in the composition layer and then handle the navigation here.
 
 
 
 ## A simple approach to navigate to a detail view is to use storyboard segues or push it directly from the main view using a Navigation Controller:

class MainViewController: UITableViewController {
  let models: [Model]
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = models[indexPath.row]
    let detailVC = DetailViewController(model)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
 
 You can also use the UIViewController.show(_:sender:) and UIViewController.showDetailViewController(_:sender:) APIs to let UIKit decide how to present the detail view based on the current context (i.e., a Navigation Controller push, or modal presentation):

 let model = models[indexPath.row]
let detailVC = DetailViewController(model)
show(detailVC, sender: self)

/*
“You use UIViewController.show(_:sender:) to decouple the need to display a view controller from the process of actually presenting that view controller onscreen. Using this method, a view controller does not need to know whether it is embedded inside a navigation controller or split-view controller. It calls the same method for both. The UISplitViewController and UINavigationController classes override this method and handle the presentation according to their design. For example, a navigation controller overrides this method and uses it to push vc onto its navigation stack.“—Apple Documentation */

This simple approach works well, and we recommend it, when (1) the detail view doesn't have complex dependencies and (2) you’re happy to couple the main view with the detail view.

For example, you could present the Comments view directly from the Feed view if they live under the same module and the comments are readily available in memory (no need to load them from complex dependencies such as an API or database):

class FeedViewController: UITableViewController {
  let images = [FeedImageViewModel]()
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let image = images[indexPath.row]
    let commentsVC = CommentsViewController(image.comments)
    show(commentsVC, sender: self)
  }
}


In this scenario, the Feed view (main view) would already have access to all dependencies required to present the Comments view (detail view), thus the FeedViewController wouldn't need to know how to create a complex object graph.

But if the Comments View had complex dependencies such as a CommentsService, this dependency would have to be passed to the FeedViewController - or the FeedViewController would have to know how to create a CommentsService - just so it can create the Comments view:


protocol CommentsService {}

class FeedViewController: UITableViewController {
  let commentsService: CommentsService
  
  init(commentsService: CommentsService) {
    self.commentsService = commentsService
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = CommentsViewController(commentsService)
    navigationController?.pushViewController(controller, animated: true)
  }
}

So the FeedViewController would depend on all CommentsViewController dependencies, leaking too many details about the child view dependencies into its parents. This makes the parent hard to instantiate (constructor over-injection code smell), develop, test, and maintain. And every new child dependency will force changes in the parent too (a violation of the Open/Closed principle).

A common solution is to use global dependencies that can be accessed from anywhere, which leads to DI anti-patterns such as the Service Locator and Ambient Context.

From “Dependency Injection Principles, Practices, and Patterns” by Mark Seemann and Steven van Deursen:





## Service Locator anti-pattern

“The main problem with Service Locator is that it impacts the reusability of the classes consuming it. This manifests itself in two ways:
The class drags along the Service Locator as a redundant Dependency.
The class makes it non-obvious what its Dependencies are.
You must redistribute not only your module but also the Locator Dependency, which only exists for mechanical reasons. If the Locator class is defined in a different module, new applications (reuse) must accept that module too.

Perhaps we could even tolerate that extra Dependency on Locator if it was truly necessary for DI to work. We’d accept it as a tax to be paid to gain other benefits. But there are better options (such as Constructor Injection) available, so this Dependency is redundant. Moreover, neither this redundant Dependency nor its relevant counterpart is explicitly visible to developers wanting to consume your components (you must set up the locator first, but it's not clear for clients!).

The use of generics may trick you into thinking that a Service Locator is strongly typed. But it is weakly typed, because you can request any type. Being able to compile code invoking the GetService<T> method gives you no guarantee that it won’t throw exceptions left and right at runtime.

When unit testing, you have the additional problem that a Test Double registered in one test case will lead to the Interdependent Tests code smell, because it remains in memory when the next test case is executed. It’s therefore necessary to perform Fixture Teardown after every test by invoking Locator.Reset(). This is something that you must manually remember to do, and it’s easy to forget.“


## Ambient Context anti-pattern

“An Ambient Context supplies application code outside the Composition Root with global access to a Volatile Dependency or its behavior by the use of static class members[...]

Ambient Context is similar in structure to the Singleton pattern. Both allow access to a Dependency by the use of static class members. The difference is that Ambient Context allows its Dependency to be changed, whereas the Singleton pattern ensures that its singular instance never changes.

NOTE The Singleton pattern should only be used either from within the Composition Root or when the Dependency is Stable. On the other hand, when the Singleton pattern is abused to provide the application with global access to a Volatile Dependency, its effects are identical to those of the Ambient Context[...]

The problems with Ambient Context are related to the problems with Service Locator. Here are the main issues:
The Dependency is hidden.
Testing becomes more difficult.
It becomes hard to change the Dependency based on its context.
There’s Temporal Coupling between the initialization of the Dependency and its usage.
When you hide a Dependency by allowing global access to it through Ambient Context, it becomes easier to hide the fact that a class has too many Dependencies. This is related to the Constructor Over-injection code smell and is typically an indication that you’re violating the Single Responsibility Principle.

Ambient Context also makes testing more difficult because it presents a global state. When a test changes the global state, it might influence other tests. This is the case when tests run in parallel, but even sequentially executed tests can be affected when a test forgets to revert its changes as part of its teardown. Although these test-related issues can be mitigated, it means building a specially crafted Ambient Context and either global or test-specific teardown logic. This adds complexity, whereas the alternative doesn’t[...]

The use of an Ambient Context makes it hard to provide different consumers with different implementations of the Dependency[...]

Ambient Context is typically a cover-up for larger design problems in the application.“
So when showing a view with complex dependencies, doing it directly via segues or code in the parent view is not the best approach. Moreover, you should avoid the Service Locator and Ambient Context DI anti-pattern by using proper DI patterns such as Constructor Injection.

In our case, the Comments view requires a complex object graph which consists of multiple layers: API, Presentation, and UI.

If the Feed UI were to present the Comments UI it would have to depend on all dependencies the Comments feature required introducing unnecessary complexity:

##  “Composer is a unifying term, referring to any object or method that composes Dependencies. It’s an important part of the Composition Root.

The Composer can be a DI Container, but it can also be any method that constructs object graphs manually using Pure DI.

The Composer has a greater degree of influence over the lifetime of Dependencies than any single consumer can have. The Composer decides when instances are created, and, by its choice of whether to share instances, it determines whether a Dependency goes out of scope with a single consumer or whether all consumers must go out of scope before the Dependency can be released.“—Dependency Injection Principles, Practices, and Patterns by Mark Seemann and Steven van Deursen
With a Composer in place, you can then move the navigation between the Feed and Comments to the Composition Root leaving the two features agnostic of each other.



















    
