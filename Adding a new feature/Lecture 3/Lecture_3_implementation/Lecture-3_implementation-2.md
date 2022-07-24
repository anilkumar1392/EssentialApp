
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

 

 


 
