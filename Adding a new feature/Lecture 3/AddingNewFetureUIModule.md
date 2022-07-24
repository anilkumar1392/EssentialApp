
## #003 - [Image Comments UI] Reusable UI Components, Diffable Data Sources, Dynamic Type, Snapshot Testing

In this live lecture, you’ll learn how to create a shared UI module to eliminate duplication without breaking modularity. You’ll also learn how to migrate to Diffable Data Sources, scale fonts with Dynamic Type, debug memory leaks with the Memory Graph Debugger, and how to take snapshot tests to the next level.

## Learning Outcomes
How to create a shared UI module without breaking modularity
How to create UI elements programmatically to eliminate duplication in storyboards
How to solve memory leaks with the Memory Graph Debugger
How to migrate to Diffable Data Sources
How to scale fonts with Dynamic Type
How to use snapshot tests effectively

This lecture is split into 3 videos: Part 1 • Part 2 • Part 3

## Part 1 - Adding a feature-specific UI without duplication

UI (Live #003)
    - Reusing UI Components (without breaking modularity)
    - Creating UI Elements programmatically
    - Diffable data source
    - Dynamic fonts (aka Dynamic Type)
    - Snapshot testing

## Reuse and Inject what is different

Feed User Interface design.
Refer Image: 

FeedViewController Implements some shared user Interfaces and protocols and it renders a collection of ImageCellControllers.
And each ImageCellControllers renders a cell configured for a specific FeedImageViewModel.
So every Cell controller is specific to onc cell.

And FeedViewController coordinated the collection of ImageCellControllers.

## Create a Reusbale Shared UI Module.
That can be resued across fetaures.

## Every ptotocol with one method can be replace with closure.
## Logic should be tested with Unit and Integration tests.
 You can also test with acceptance test.
 
 
 To automate regression testing, we are using Snapshot testing.
 Preload(), cancelLoad() some how we are leaking details of other implementations here into the cell controller class.
 
 This is voilation of Interface segregration Principle.
 As it impement interface it does not care about.
 
 ## we need to solve it and simple thing we can do it is move the Implementation in to an extension.
 Move optional method to an extension.
 
 ## So they both(FeedImageCellController and ImageCommentCellController) Implement the CellController Protocol.
 So both concrete cell implement the cellController ptotocol.
 Which means we can render resue the listViewController with any cell Controller that implements this Interface.
 
 Which makes this super reusable.
 Without inheritance we can resue it.
 
 we are composing them with dependecy Injection.
 
 ##  FeedImageCellController and ImageCommentCellController depends on shared module.
 Because they Implement this CellController Interace.
 
 ## Their is nothing wrong with that.
 Nothing wrong in having a shared module with shared logic and other module depending on it.
 Implementing Interfaces or Resuing Types from it.
 
 But if you want to eliminate this dependency we can.
 
 1. For eg: we can move the CellController to abother module.
 but that is not going to help a lot.
 
 But ideally we should eliminate this dependency if we can.
 As we did it with other module with APi and Presentation.
 
## Replace the CellController Protocol with the common abstraction given by tableView API.
 
 1. So cellController defines ways for creating a Cell
 2. Preloading
 2. Cancelling data loading.
 
 but their are already protocols for all those operations on tableViews.
 
 for eg.
 we create a cell with table View datasource.
 we can preload with datasource prefetching protocol.
 we can cancel load with delegate and the datasource prefetching.
 
 So their is already a common abstraction between the shared and the custom feature UI modules.
 
 Because they all depend on UIKit and UIKit already defines a common interface that they can all share.
 
 ## This way those module don't depend on each other they only depend on UIKit.
 
 which they already do as we are using UIKit.
 
 ## We moved from composing from Three types to a One Type to Creating one type that holds three instaces that holds one of each protocol.
 ## Error view is not common on all screen so to use a common error view.
 we can do storyboard composition.
 but that is not a easy one.
 
 If We can also configure error view in code in the shared UI module then we don't have this problem.
 because we don't need to configure it in the storyboard.
 
 ## Configure a ErrorView in code so we don not need to configure it in Storyboard.
 
 Configure ErrorView programatically so we don't duplicate layout logic in Storyboards.
 
 Becasue we don't want to duplciate code in Storyboard we are do it in code or with protocol or with storyboard composition.
 
 You can find a video about storyboard composition in YouTube.
 
 ## Use dynamic type to scale the font as Needed.
 
 Currently we are setting font by code so UI will not respond to dynamic type while increasing an decreasing font.
 
 ## for accessability reason we should allow the user to decide which font size they want. 
 
 which will respond to as customer wants.
 
 ## we can use DiffableDataSource to eliminate whole table relaod and relaod only cells that changed.
 ## For Custom dynamic font.
 
 UIFontMetrics.default.scaledFont(for : customFont)
 
 you need to do it with font metrics.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

