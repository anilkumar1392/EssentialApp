
--- 

It's time to put your development skills to test!

You are called to add new feature to the feed app:

Displaying image comments when user taps on an imagen the feed.

The goal is to implement this feature using what you have learned in this program.

Develop API, Presentation and UI layer for this feature.

* Important: No need to cache comments * 

## Goals

1. Display a list of comments when the user taps on an Image in the Feed.

2. Loading the comments can fail, so handle the UI states accordingly. 
    - Show a loading spinner while loading the comments
    - if it fails to load: show an error message.
    - If it loads successfully: show all loaded comments in order they were returned by the remote API.
    
3. The loading should starts automatically when the user navigates on the screen.
    - The user should be able to reload the comments manually (Pull-to-refresh)
    
4. At all times user should have the back button to return to feed screen.
    - Cancel any running comments API  requests when the user navigates back

5. The comment screen layout should match the UI specs.

Write tests to vaidate your Implementation including Unit, Integration and snapshot test (aim to write the test first).


## So we are simply using Comment Api That will generate image comment, That will be used by the presentation layer to show it on UI.

We are not creating protocol as we have only one Implementation here so we do not need protocol.

## How can we create new features without duplicating the loaders.
Without duplicating the HTTP Clinet.

## Current FeedImage Implementaiton

We have a RemoteFeedLoader that talks with the client gets some data back and it maps the data in to FeedImages.

We can follow the same design with comment module.

## So except Mapper most of the code is duplicated.
Loader code, HttpClient code.  

GET API---

2xx response 
for any 2xx response their is success

{

}


## we do not need to follow the API specs precisely as we want our model decoupled from API.

if api changes we don't break the changes.

created_at is an api detail and we don't want to leak that in our code.

## Data is a rich data struct and should be converted in to database as a string.
 
 Using dates in test can be fragile, because they have depedency on locale, timezone etc.
 So depending on timezone this test may fail, depending on locale thos test may fail.
 
 Solution: Don't create it instead provide hardcoded value. 

## By now we have duplicated loader and mapper and then we have changed it to map image comment.

## what if we want to use Feed Api and Image Comment api in isolation?
what if they cahneg for different reasons?


Then ideally you should separate them in different modules.

Their is nothing wrong in duplicating the protocol, Because it's the inerface a client needs.
for eg. Image comment api is using a get method to get the commetns but it may need to post the api but Feed api moudle does not need Post inerface.

So if they sahre the same client you would make change in api client and you would effect the api that does not need new method.

So by breaking them in different protocol even by the same name in different module you are respecting interface Segregation principle.

Where the client do not depend on the method they do not need.

## The infrastructure depeds on our API module. This is dependcy inversion principle.

URLSessionHTTPClient depends on HTTPClient.

## Dont depend on implementations depend on abstraction.

## Duplicate interface and shared implementaiton is caio prefered.
ref: 'solution_to_sharing'



## another_solution. Ref: another_solution
What if I dont want to duplicate the client I want to sahre the client (Protocol)

Shared Api infra Module.

So we can move the client to the shared module.

Problem: Now they share the same client but Feed Api module does not depend on Comment api module and vise verca.
They depend on shared infrastrucutre module.

The problem is now those api module depend on Infrastrucutre details (HTTPClient protocol).
Like the framework here.

## We could not move this FeedApi module without dragging this shared api infra module with it.
and this may be a problem.
if you are usign framwork like Moya, Firebase or Alomofire and you do not want to drag that massive dependency it would not be possible.
You need to drap those dependency together.


## One more solution to to create one more module for sharing client.
Ref Image: Another_solution_01

Downside of this is the maintanance.
Now we have many physicaly separated components in the different module, framework, packages, pods.

Upside is modularity.

Every time their is a new change in client you need to re compile and deploy the other module.
But if you are keeping every thnig in teh same project then you do not have maintenance burden.

## This is what we are doing here. One Repo, one Project is doing everything.

## Inject what is different and abstract what is similar.

## we are going to create a generic one and inject what is different.

## With extension
ref Image: shared_remoteLoader

Remote module is now in the shared Api module along woth client interface.
FeedApi Module and Image Comment module depends on shared api module.

## they only depend on this module because of the extension. 

Those extension compose the generic loader with the mapper.

They compose which means composition details can be moved to composition root.
Then we will eliminate this depedndency in the shared module.

## so we are moving RemoteLoader extension to the shared composition root.

So in LoadFeedFromRemoteTests we do not need to create sut, we do not need to track memory.
we do not needt client, spy.

## Removal of those function from the RemoteFeedlaoder tests is only possible only becase of abstraction.
 
 ## Now they are all stand alone modules.
 
 Api module does not depend on any shared infrastrucutre or the image comments.
 ## They are all standalone modules.
 
 The infrastrucutre api still seperated into two modules.
 
 ## So standalone module with standalone pure function with the usecase implementaitons. They are composed in compostion root thus you eliminate module dependency.
 In this case we are eliminating the dependency of the api infrastructure.
 
 We are rejecting the dependency.
 

## Question: do we need error enum in generic Loader.

No error are use case sepcific but a generic feedloader should be generic not use case specific.

## so if you want to add a new API module here a new Feature with an API layer you just create a Mapper and compose it in the composition Root.
        
    let remoteFeedLoader = httpClient.getPublisher(url: remoteURL).tryMap(FeedItemMapper.map)
    return remoteFeedLoader
            .caching(to: localFeedLoader)
            .eraseToAnyPublisher()
            
## That's how you compose your use cases with infrastructure in a functional way you don't inject dependencies, you compose dependencies.

with Map, tryMap, flatMap

Create composable function, Pure functions, and you compose it with infrastructure.

## So nothing wrong with having a loader like a more Object-Oriented way or doing it with the Generic way.
if you are using a framework like combine you can get it for free.




 
  
