
## Part 2 - Decoupling feature-specific UI from the Shared module

So Swift UI Previews does not repalc ethe need for snapshot tests.
becasue previws does not eliminate regressions.
we want to automate regression testing.
That's why we have snapshots.

So we implemented the UI Test-Driven with snapshots.

## ImageCommentCellController has two empty Implementations.
some how we are leaking the implementation detials of other clients into the CellController protocol.

this is a voildation of Interface segregration principle.
Client has implemented interfaces it does not care about.

## BUt 'FeedImageCellController' and 'ImageCommentCellController' depends on shared module becasue they implement this module.

Thier is nothing wrong in having a shared module with shared logic and other module depending on it.
Implementing interface and Implementing types from it.

## But if you want to eliminate this dependency you can.

Ideally you should eliminate this dependency if you can completely.
As we did with the other modules with the API and the presentation.

## Their is already a common abstraction between the shared and the Custom feature UI modules.

Becasue they depend on UIKit already.
UIKit already defines a common Interface that they all can share.

This way this module don't depend on each other they depend on UIKit.

## CellController Protocol depends on UIKit, so this is a UIKit Implementation.

if we implement swift UI tomorrow we may create a new module just for SwiftUI and replace them.

So we could use this common abstraction from the tableView dataSource delegate and prefetching protocols.

## So we do not need to create our own custom protocol which will eliminate this two dependency.

## Thier is nothing wrong in having a shared module and but if you don't have to even better.

which means you can develop those modules in isolation you can make changes to them in isolation without breaking each other.

## So thats the Goal repalce CellController Protocol.

With the common abstraction given by tableView API's so an easy way to do it.

Make the CellController a typealias.

public typealias CellController = UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching

so with the and symbol we can create a new type that confirms to all of them.


    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cellController = cellController(forRowAt: indexPath)
        return cellController.view(in: tableView) */
        
        let controller = cellController(forRowAt: indexPath)
        return controller.tableView(tableView, cellForRowAt: indexPath)
    }
    
    because now controller is a type that implements UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching

which means we can directly use dataSource methods in controller.

## So the controller is dispatching the methods.

controller is dispatching cellForRow at indexpath method for each cell.

Becasue each cell needs to implements dataSource and delegate.

so nothing wrong in having a custom protocol if you need to but in this case we don't.
we can use the common abstraciton by UIKit.

## Move cancel operation to didEndDisplaying method.

ImageCommentCellController has to implement some empty method which breaks Interface segregration principle.

One solution is we can have extension we default implementation that do nothing.

But thier is a  better solution to this.

Instead of Using protocol composition into one type.

public typealias CellController = UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching

## we can acutally compose them in to a type that contain three types one for each implementation.

so we can it it with a tuple or a struct.

public typealias CellController = (UITableViewDataSource, UITableViewDelegate,  UITableViewDataSourcePrefetching)

So in this way clients can implement what they need they are not forced to implement all of them.

## So we moved from composing three protocols in to one to creating one type that holds three instacnes one of each protocol.

## So the Rule is
The shortest the scope the shortest the name can be.

So CellController is a Tuple and we can not Implement a Tuple.
what we can do now is to Implement the method or the protocol we care about.

So we Implemented UITableViewDataSource for ImageCommentCellController.

by doing this we have now decoupled ImageCommentCellController from CellController.

## we can decide now which protocol we implement.

if this is a struct we can give some default init and convenience init.

We prefer struct than a tuple because we can have this initailzer.
which make our api easier to use.














 


 
