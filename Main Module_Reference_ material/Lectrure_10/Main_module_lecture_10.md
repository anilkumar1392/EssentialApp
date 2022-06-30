## From Design Patterns to Universal Abstractions Using the Combine Framework


Combine framwork.


Build in Operator handleEvents method is just to inject side effects so can be used when injecting side-effects.
You don't need to develop, test and maintain. 

All loader will be replaced with Publisher.
Use publisher.sink to subscribe to the publisher.
if we don't hold cancellable it will be deallocated and observer will be deleted.

