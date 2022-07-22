## Resuable Presentation Logic.

We are going to write presentation logic that is going to that will control the states here.

1. Loading
2. Error
3. Success

also translating the date to relative formatting.(eg. 1 week ago)

So FeedLoader, ImageLoader and Comment loader are very much similar.
like loading, Success and error.

So the presentation logic of controlling the state of loading a resource is the same even when loading an image.
So we don't want to duplicate this logic over and over again.
So we have three sepearte resources that we load.

## So we need to unify this logic. (This presentation logic)
Other wise everytime their is a new feature we are gonna duplicate this while presentation layer.

## So thats the Goal: Introduce some kind of abstraction, reusable abstraction that allow us to introduce new feature easily without duplicating the presentation logic.

So next time we need to load a resource we use the same presentation layer.


## Look in to FeedPresenter

we have a 'FeedPresenter' that we implemented in Feed Module.
That creates viewModels, So to control the loading state is creates the loading viewModel and passes it to the view.
Same with error, and success.

REf: FeedPresentationLogic

So FeedPresenter controls the loading of the resource and the resource is Feed which is array of images. [FeedImage]

## we can follow the same deisgn but we will end up with duplciation.

ref: CommentPresentationLogic

So the Good thing is both the features are decoupled from each other but we also don;t want to end up with duplication.

## We can do the same as we did in api modules.
## we created a shared module with all the logic that is similar and we inject what is defferent in to the Generic Presenter.

So we can abstract all this loading of resource in to reusbale shared logic and inject what is different. the difference is the mapping 
eg. Array of 'FeedImages' into the feedViewModel
or mapping data into UIImage.
Array of imageComment to  array of ImageCommentViewModels.

## if you look into the ImageRef: 'sharedPresentationModule' you will se their is no dependency from 'FeedPresntationModule' and 'CommentPresentationModule' into the 'SharedPresentationModule' and view verca.

we compose all of the module in composition module and that's how you decouple modules.

## So the composition Root is the key design choice we made to allow these modules to be decoupled.

So decoupling all the modules with this generic presenter and injecting the custom logic for each presenter in the composition.

[FeedImage] -> creates view models -> sends out to the UI
[ImageComment] -> creates view models -> sends out to the UI
Data -> UIImage -> sends out to the UI
Resource -> creates ResourceViewModel -> sends out to the UI

So by looking in to we need a Generic Resource and a Generic ResourceViewModel so that we can accomaodate all the cases.

## // So in the test we are mapping the resource into the view model

So we need to imject a mapper that converts a resource to a viewModel.





