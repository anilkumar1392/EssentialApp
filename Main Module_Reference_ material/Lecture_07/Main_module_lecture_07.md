
##   Preventing a Crash when Invalidating Work Based on UITableViewDelegate events


In this lecture, you'll learn an effective 3-step way to find and fix bugs with TDD as we solve a potential crash in the image request cancellation logic based on table view events.

Learning Outcomes
Fixing bugs and preventing regressions following the TDD process
UITableViewCell reuse cycle
Invalidating work based on UITableViewDelegate events
Enforcing UITableView delegate events in Integration Tests


Cancelling requests based on table view events
When using table views, it's common to load additional data for each cell on demand.

Loading data can be an expensive operation, such as loading images from the network or the file system.

To manage device resources effectively (battery, data plan...) and deliver a smooth scrolling experience, it's recommended that you only load resources when needed (e.g., the cell is visible or about to become visible).

And you can stop those operations as soon as a cell is removed from the table view hierarchy (e.g., the cell gets out of screen as you scroll).

A simple way to know when a cell is removed from the table view is to implement the didEndDisplayingCell delegate method. However, you need to be careful because this method can be invoked after calling reloadData with a new set of models to display on screen.

For example, imagine you render cells on a table view based on an array of items as the table model:

public override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
  return tableModel.count
}
And you start with 10 items:

tableModel = [item1, item2, item3, …, item10]
tableView.reloadData()
Then, UIKit will call the table view data source asking for a cell for each item. You can get the model for each row index, populate a cell with the model, and start running an expensive operation.

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = UITableViewCell()
  let model = tableModel[indexPath.row] ✅
  model.startLoadingExpensiveOperation()
  cell.textLabel.text = model.text
  return cell
}
As the user scrolls the table view, cells will show up on screen and others will go off screen. When a cell goes off screen, UIKit will call didEndDisplayingCell for a specific row index. So, you can cancel the expensive operation as it’s not needed anymore:

func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 let model = tableModel[indexPath.row] ✅
 model.cancelLoadingExpensiveOperation()
}
Now, imagine you change the model to an empty array with 0 items:

tableModel = []
tableView.reloadData()
As the model is transitioning from 10 items to zero, every cell on screen will be removed from the view hierarchy. So UIKit will call didEndDisplayingCell for those rows.

But we don't have items in the tableModel anymore. So the app will crash when trying to access the model for that row (it doesn't exist anymore!).

func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 let model = tableModel[indexPath.row] ❌
 model.cancelLoadingExpensiveOperation()
}
UIKit will call this method after the model changes, so this crash could happen when transitioning to any tableModel with fewer items than before.

This is not a big problem at the moment since items cannot be removed from the feed. But we cannot assume the backend will keep this behavior going further.

So we need to be careful when invalidating work based on the didEndDisplayingCell delegate method.

As shown in the video, a simple solution is to keep track of the items that need invalidation in a separate Dictionary property:

private var loadingItems = [IndexPath: Item]()
You can use that Dictionary as a lookup table:

func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  let model = loadingItems[indexPath] ✅
  model?.cancelLoadingExpensiveOperation()
  loadingItems[indexPath] = nil
}
This way, you can guarantee the messages are being sent to the right models while preventing potential out-of-bounds runtime errors.

Thanks, Luke Jones, for pointing out this potential crash!
