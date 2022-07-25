
## Part 3 - Creating UI Programmatically, Memory Graph Debugger, Dynamic Type, and Diffable Data Sources


Create Error view programmatically.


## Dynamic Fonts

we can use dynamic types to scale the font as neeeded.

and we should for accessibility reason.

Set preferredFont and adjustsFontForContentSizeCategory to true because by default it is false.

## Diffable Data Sources

Every time I refresh it flickers becasue we are reloading the entire tableView.

So we don't want that.

we do not want to relaod entire tableView when we get a new data.
we can use diffable datasources to control that for us.

So instead of using array based model we can create a diffable data source.
// Also did in mentoring 15.


So the Diffable dataSource will handle all the updates for us automatically so we don't need to keep track of loading controller anymore.

It only udpates what is needed.

we do not need 
numberOfRowsInSection,
cellForRowAt

anymore.
because tableView datasource isnow Diffable datasource.
which means we need to configrue it here.

we do not need to remove loading controllers becasue these loading controller dont exist any more. Its all handled by the diffable datasource.

## Prevent rendering cell ahead of time in tests set tableview frame to zero.
        // This way their will not be enough space for rendering.

## Diffable dataSoruce does not works as expecetd with Dynamic type so we can listen to changes of Dynamic type and relaod table manually.

func traitCollectionDidCahnge()

## iOS 15 Update

Apple changed the behavior of the method apply(_:animatingDifferences:) of the UITableViewDiffableDataSource and UICollectionViewDiffableDataSource classes.

On iOS 14 and before, calling apply(snapshot, animatingDifferences: false) would call reloadData on the table/collection view and reload all cells. And calling apply(snapshot, animatingDifferences: true) would perform a diff on the data source and only update cells that the data changed.

But on iOS 15+, passing false or true in animatingDifferences will perform a diff and only update cells that the data changed.

If you want to reload the whole table/collection view on iOS 15, you need to call applySnapshotUsingReloadData(snapshot).

And if the reloadData behavior on both iOS 15 and before, you can use the following code:

## References
Validating the UI with Snapshot Tests + Dark Mode Support https://academy.essentialdeveloper.com/courses/447455/lectures/13303698
Composing View Controllers pt.1: Storyboards composition https://www.essentialdeveloper.com/articles/composing-view-controllers-part-1-storyboards-composition
iOS Dev Mentoring Session #015: DiffableDataSources, Pagination & Infinite Scroll https://academy.essentialdeveloper.com/courses/1112681/lectures/24140264
Gathering Information About Memory Use https://developer.apple.com/documentation/xcode/improving_your_app_s_performance/reducing_your_app_s_memory_use/gathering_information_about_memory_use
Scaling Fonts Automatically https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically
UIFontMetrics reference https://developer.apple.com/documentation/uikit/uifontmetrics
Make blazing fast lists and collection views https://developer.apple.com/videos/play/wwdc2021/10252/
