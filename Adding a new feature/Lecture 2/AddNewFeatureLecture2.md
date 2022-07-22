## #002 - [Image Comments Presentation] Reusable Presentation Logic

## Goals

1. Display a list of comments when the user taps on an image in the feed.
2. Loading the commetns can fail so handle the states accordingly.
    - showing a loading spinner while loading.
    - if it fails, show an error.
    - if it loads successfully, show all loaded comments in the order they were returned by the remote api.

3. The loading should start automatically when the uiser navigates to the screen.
    - user should be able to reload the comments manually (Pull to refresh).
    - 

## Introduce some kind of reusable abstraction that allow us to allow us to represent new feature anutomatically without duplicating code.


So FeedPresenter controls the loading of the Feed.
while loading it controls the loading, error and maps the loaded resource in to a FeedView.

## We can do same for ImageComment Model, but this will duplicate everything.
But we don't want this duplciation.
the Good Thing is that both features are decoupled from each other.
and also we don't want features to depend on each other but we also don't want duplication.

So we need a better design.
And we can follow what we did in api layer.

where we created a shared moduel with the logic that is similar and inject what is different.

## So as per new design

Their is no dependency from 'FeedPresentationModule' or 'ImageCommentPresentaitonModule' into the sharedModule.
and vice versa the shared module also does not depend on 'FeedPresentationModule' or 'ImageCommentPresentaitonModule'.

With the help of composition Root.

## We compose all of these models in the composition Root.
That's how we can keep the module decoupled.

Usually in code bases you see every module depends on shared module(because you want to share logic)
Also you don't want to duplicate code.

## Problem with a shared module

Every time we change a shared module we are going to break the other modules. So that's not great so if you can keep them isloated from each other even better.

## You can change the shared module without breaking the client.

You just change the composition root you are good to Go.

## So this is what we are going to get in this module.

1. Now we will create a reusable shared Presentation Module without introducing duplication.

Decpupling all the modules from the generic presenter and injecting the custom logic for each presenter in the composition.


## To create a Generic one let's ahve a look what we need.

    // [FeedImage] -> created view model -> sends to the UI
    // [ImageComment] -> created view model -> sends to the UI
    // Data -> UIImage -> Sends to the UI
    // Resource -> created ResourceViewModel -> sends to the UI
    
    So our Resource will be Generic and ResourceViewModel will be Generic.
    we can accomodate any use case that have same loading logic.
    So every time we are loading a Resource a Generic Resource.
    
## Idea here is to create a shared presentation module.

So simply what we are doign here
1. we have a generic resource eg. String
2. Then we need to inject a mapper, because mapper will be use case specific. that will convert a 'resource' to a 'resourceViewModel'
3. Then the view will receive a 'resourcViewModel'

So 'resource'and 'resourceViewModel' both are generic.

## Red flag: Multiple module depending on same key.
So I don't want multiple module depending on same key.
Also I don't want this Feed_Connection_error key to be defined in Feed.strings
Beacuse Feed.strings is a file in the FeedPresentation module.
and since the shared module is using the key some how it has knowledge about this Feed.string key that lives in another module.
Which couples the Generic presenter with the Feed Presenter.

So what we can do it to create a new Strigs file for the generic one.
 
 ## Main module is depending on concrete keys and that's not good because when you change the key's or move them around you break the main module.
    
    We can prevent that from happening. One way to do it is to create DSL.
    1. So instead of accessing keys directly, we could create something a loadError

var loadError: String {
    localized("GENERIC_CONNECTION_ERROR")
}

but again if we change this key around and change the key, we are going to break the test.
This DSL protects the test but still if we change or move the key we will break the test.

So that's not great what else we can do.

## well we can expose the loadError in LoadResourcePresenter.

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

class DummyView: ResourceView {
    func display(_ viewModel: Any) { }
}

var feedTitle: String {
    FeedPresenter.title
}

## The only thing we need to do is to expose these static variables.

FeedLoader and FeedImageDataLoader are also very much similar.
So we can also make them Generic.

## so we are here now

We separated FeedImage Data loading from FeedImageViewModel.
So we can use the FeedImageData loading with the generic presentation.
and they are not coupled with each other.
Because we compose them in composition root.
 
## Refactoring, Refactoring writing tests, having absolute control over code and having flexible code.
Having flexible code that can be resued, that can be replaced, can be tested simply. 

## In this live lecture, you’ll learn how to create a reusable Presentation module to eliminate duplication without breaking modularity. You’ll also learn how to format Date instances into presentable localized strings.

## Learning Outcomes

How to refactor code backed by tests and the compiler
How to decouple feature-specific modules without introducing duplication
How to create reusable generic Presentation components
How to format Date instances into presentable localized strings
How to control the current date, locale, calendar, and other environment details to create fast and reliable tests

## Identifying and eliminating duplication in the Presentation module

Up to this lecture, the FeedPresenter could handle three events:

loading the feed via didStartLoadingFeed()
successfully loaded the feed via didFinishLoadingFeed([FeedImage])
failed to load the feed via didFinishLoadingFeed(Error)
The FeedPresenter would then map these events into appropriate view models and send them to the UI via the view protocols.

The FeedLoadingView would display FeedLoadingViewModels.
The FeedView would display FeedViewModels.
The FeedErrorView would display ResourceErrorViewModels
So the general presentation flow happened as follows:

Event in → Create immutable ViewModels → Send ViewModels to the UI

However, this sequence of state changes is the same for any resource that can be loaded asynchronously.

For example, the ImageCommentsPresenter needs to handle the same three events: Loading, Success, Failure. The only difference is that in one we’re loading an array of FeedImage, and the other an array of ImageComment.

So adding this new feature would lead to a lot duplication:

The FeedImagePresenter also handles the same three events: Loading, Success, Failure. But the resource we’re loading is the image Data.

When you find such a clear pattern, you can create a generic solution to eliminate the duplication.

In this case, you can create a generic Presenter containing the logic that is similar to loading any resource. And customize it by injecting the logic that’s specific to each resource.

The loading and the error logic is the same for all cases. But mapping a generic Resource into a generic ResourceViewModel is specific to each resource.

So in this live, we create the reusable LoadResourcePresenter that can handle all three events with a generic Resource type:

loading the feed via didStartLoading()
successfully loaded the feed via didFinishLoading(Resource)
failed to load the feed via didFinishLoading(Error)
You can inject the Resource to ResourceViewModel mapping, which can be implemented as pure functions by specific presenters.

The FeedPresenter maps [FeedImage] to FeedViewModel.
The FeedImagePresenter maps FeedImage to FeedImageViewModel.
The ImageCommentsPresenter maps [ImageComment] to ImageCommentsViewModel
This way, you can design, develop, maintain, and test independent Presentation modules that can be easily composed in the Composition Root.

## References

Testing Date Span in Swift: Controlling the current date & time https://www.essentialdeveloper.com/articles/testing-date-span-in-swift-controlling-the-current-date-and-time-ios-lead-essentials-community-qa
