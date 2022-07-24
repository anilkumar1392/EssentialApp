
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
