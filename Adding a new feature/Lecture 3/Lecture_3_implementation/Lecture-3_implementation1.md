
## Every ptotocol with one method can be replaced with closure.

So we are going to use snapshot test to test drive the implementation of this user interface.

We are not testing the logic but we are testing the rendering.
Logic should be tested with unit and integration tests.

## That's the idea with snapshot tests, is to automate the regression testing of the UI.

In Swift UI.

When you are happy with the live preview, you take the snapshot of it.
and them you can automate the regression testing.

You have much more unit test than the snapshot tests.
That's why we are not testing thoroughly with snapshot test we test take 2 snapshot.

That's a light and a dark one.

We are not testing the logic we are testing the logic with unit tests.


## Part 1 - Adding a feature-specific UI without duplication

The ‘Image Comments UI’ shares exactly the same layout with the ‘Feed UI’ for the states loading, empty, and error.
Only the success state is different, where we must render the comments:

A simple way to solve the duplication is to create a reusable ListViewController in a shared UI module containing the logic that’s shared. And inject the logic that’s different via an abstract interface (e.g., a protocol).

In this case, only the cell rendering in the success case changes. So we created the abstract CellController protocol, defining an interface with what’s needed to render any type of cell and handle some events.

public protocol CellController {
  func view(in tableView: UITableView) -> UITableViewCell
  func preload()
  func cancelLoad()
}
