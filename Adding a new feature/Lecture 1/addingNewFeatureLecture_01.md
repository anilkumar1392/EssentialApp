## #001 - [Image Comments API] From Dependency Injection to Dependency Rejection

- How to add new feature without duplicating code (HTTPClient, Loader, Presenters, UI)
- How to handle navigation between the screens without breaking modularity.

## if you do not have multiple implementations of a protocol you dont need a protocol.

## We have decided the architecture for FeedCommnet that is similar to FeedApi.

pros: They don't know about each other,
Cons: Duplication everything is duplicated.
Loaders are probably duplicating a lot of code.

But then we will loose modularity.

But that's a good start so we can start here.

## So how to create RemoteCommentLoader without duplicating code. 

So the simplest thing we can do is to move them in the same module.
But we willa so loose modularity. Then you can share the client protocol and the implementation.

First we will implement the RemoteCommentLoader and then we will find the 

## So the process we can follow is Copy and Paste.

Starting with test we can copy and paste the code.
It's a very safe way just follow the steps and compiler will guide you.

## Date is a rich data struct.

should be converted in json to string(Here it matches ISO8601).

ISO8601DateFormatter().string(from: Date())

## what is the problem in using date formatter in tests?

They can vbe fragile, because they have dependecy on timezone and locale things like that.
 Solution: I don't want to anythign for test I would like to provide precide value.
 
 (data: Date, iso8601String: String)
 
 so we do not need to do formatting in test we are always going to get precise value.
 
 ## The process to change
 1. Copy the code make sure tests are passing.
 2. Then we change the duplicated code to do the new thing.
 3. That's a safe process when adding a new feature.
 
 ## By now we have duplicated the loader and the mapper.
 
 Sharing the HTTP Client in the same module.
 
 but what if we want to reuse the image Comment api or image Feed api in isolcation or in another application?
 what if we change for different reason.
 
 Then ideally we should separate them in different module.
 
 ## how can we do that without duplicating the code.
 
 if they want them to be isolated standalone modules they should not depend on each other.
 
 ## So what can we do?
 
 Two client prtocols, It is not a problem to duplicate the protocol.
 
 ## Because protocol defines the interface that the client needs. 
 
 So right now ImageComment api is using GET interface and what if you want to post comments.
 you may need a post method.
 but FeedApi module does not need a post method.
 
 SO if you share the same client.
 you will make a change in the api client and it will effect FeedApi module.
 
 And FeedApi does not even need it the post method.
 so if we sahre the same client you would make a change in the api client and you could effect the Feed Api.
 
 ## Check Image: Sharing_client
 
 So by breaking down two separate protocols even with the same name but in different modules 
 you are respecting Interface Segregation Principle.
 Where the clients do not depend on the method they do not need.
 
 It's a way of prventign them from happening.
 You create different protocol in different module.
 But you share the same Implementation.
 
 So now Infrastrucutre depends on Api module and Api module does not even know that the implementation is shared.
 
 ## So this is the dependency Inversion principle in action.
 
 It does not depend on implementation it depends on abstraction.
 
 
 ## What if I want to share the client but don't want to duplicate the client.
 Image: sharedInfrastructureModule
 
 So now looking at the Infrastructure 
 Api module now depend on shared infrastructure module. 
 
 The problem is that now those API module depend on Infrastrucutre details like the framework here would not be 
 move the FeedApi module to another project wothout dragging this module(Shared API Infra module) with it.
 
 And that may be a problem.
 
 If you are using framwork like Moya, Firebase, Alomofire.
 and you do not want to drag that masive dependecy you would not be able to.
 
 You need to drag those dependency together. 
 
 
## So caio prefers previous one Image ref: Sharing_client.
Shared the implementation not the Interface.
Having duplicate interfaces because they may chnage for many reasons and they may have differnt methods.

Share the infrastructure and having duplicate client.

Becaue they may change for differnet reasons, they may have differnt methods.

Prefer this one then deoending on concrete framework details. Image Ref: 'sharedInfrastructureModule'
 
 ## But their is something else we can do.
 
 Not to duplicate the client.
 and Not to depend on Infrastructure Implementations.
 
 ## Image ref: SharedClient create a module just with interface.
 
 You can create a module just with interface.
 Their is nothing wrong with that.
 
 So Feed Api module will depend on the shared interface and the implementation as well.
 So the implementation of Infra is decoupled from modules and the modules are decoupled from the infrastructure Implementation as well.
 
 They only share interfaces.
 
 The upside is Modularity and 
 The downside of this is the maintanance. 
 
 Their is a bug problem If you are separating your modules into packages, frameworks and different projects, different repository.
 But if everything is in the same project because you are not sharing this code across modules across applicaitons.
 Then you don't have the maintanance burden.
 
 
 ## So this is what we are doing here
 
 One Repo - One project - One Folder just containing every thing.
 we are using discipline basically.
 
 We can replcate this just with folders now.
 At some points we can move it to Different Targets, Repository, Diff projects and Diff packages.
 
 But keep it simple as much as you can.
 
 ## Separating in folders is just like virtual seperation of Modules, because nothing is stopping us from referencing other types.
 
 ## In our current implementation we are using 'sharedClient' approach.
 
 So now we have FeedApi module, ImageComment api module. That are sharing Shared api client.
 
 But we have code duplication in FeedApi loader and ImageComment loader.
 
 So most of the code in both the loader is exactly same.
 ## So now we can abstract what is similar and inject what is different.
 
 When you duplicate the code you exactly see what is same and what is different.
 ## So we need to solve this duplication here.
 
 1. One way to to it is to create a generic loader.
 That has a same logic apart from what is different.
 
 
 # Steps to create new Loader with Copy and paste.
 
 1. First Create a file and copy paste all the content in it. (RemoteLoaderTests)
 2. Next Step Rename. eg. (RemoteFeedLoader to FeedLoader) you can use find and replace with in the file.
 
 
 ## Creating Generic Remote Loader
 
 So afetr creating Generic Loader, This loader live in Shared module.
 Refer Image: Shared_RemoteLoader
 
 ## So in localFeedFromRemoteFeedLoader
 
 The less dependency we have the easier it is to move code around and more flexible needs less maintanance.
 So moving these extension to composition Root.
 but to be able to Compose Loaders with the mapper, mappers need to be public.
 otherwise we can't compose them.
 
 2. Another problem we see is that the Loader tests are testing mapping.
 The only thing that is left here is mapping as other cases we are testing in Generic RemoteLoader.
  
But we are testing Mapping in integration with generic loader.
Which is unnecessary as we have alreay tested the generic loader.

## So we can test mapper in isolation.

Without a loader in mix.
Because they are just pure functions.
you can test them, directly and make them public.

So we do not need any client just pure functions.

## Test Feed Image mapper in isolation.
## Test Comment mapper in isolation.

Removal of Those function from FeedRemoteLoader and CommentLoader is only possible becasue of abstraction.


## Tomato 3

Move remote layer comosition to the composition Root.

So now new new design. Ref image: 'DesignAfter_remoteLoader'

The Feed Api module does not depend on Shared Api Module or the Image comments.
They are all standalone modules.

The infrastructure Module is still separated into two modules.

## Standalone pure functions with the use case implementations they are compsoed in composition root Thus you eliminate module dependency.

In this case we are eliminating dependency of the Api infrastrucutre.

## we are rejecting the dependency 
That's why topic is from dependency inejection to dependency rejection.

and their are no dependency here.


## Q1: Do we need Error enum inside Generic Loader?

No The error are usecase specific and but the generic FeedLoader should be generic not use case specific.

So now we have less dependency, less duplication the better.

If you want to add a new api here a new feature with an Api layer you just create a Mapper and compose it in composition Root.

So no more duplication with the infrastructure details like closure no expectations and all the stuffs.
Basically pure function input output that't it.

## You can do exaclty the same with FeedImageDataLoader do as exercise?

## you can do even in more simpler we can do.

In this case we created a Generic loader.
to eliminate duplication.

But if you are using a framework like Combine you can use the universal abstractions that come with the framework to create this composition.

So infrastructure composiotn here is in the composition root.

eg. RemoteLoader(url: remoteURL, client: HTTPClient, mapper: FeedItemMapper.map)

if you are not using comine it is fine Cretae a Generic laoder and 

## Now we don't inject dependency we compose them.

we create composable function, Pure functions and you compose them with infrastructure.

## Now we do not need to have a Loader 
Image ref: Without_loader

Since we don't a Component from the FeedApi module conforming to the FeedLoader like the RemoteFeedLoader 
we have only localFeedLoader conforming to FeedLoader we don't even need the feedLaoder protocol.
Because we don't have a stratery any more.

## Their is nothing wrong  with protcol and having a stratery pattern
but if don't have multiple strategies you dont need a protocol.

## removing FeedLoader protocol as we dont need we don't need it anymore we are composing the types with universal abstraction provided by combine framework.

Now everytime their is a new feature you just implement the api module and the core domain.
we don't need loader and services any more.
we compose the infrastrucutre with the pure mappers that generate the models in the composition root using combine.
The universall abstractions.


If you are not using combine no problem just create generic loader.


## Remember in Functional style

you don't inject dependency you compose dependency with the functional sandwich. 

## In Object Oriented way you can use Protocol but in fucntional way you can remove them.








 


