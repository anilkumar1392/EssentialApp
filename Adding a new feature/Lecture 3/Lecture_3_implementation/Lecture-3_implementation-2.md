
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




 
