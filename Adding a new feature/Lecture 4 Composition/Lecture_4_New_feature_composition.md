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
 
 
 
 
 

 


































    
