## 

1. Directives 
2. Test Codes
3. Production Codes


Thats the problem with black box testing.
if you need to have any kind of control then you need to inject to test some edge cases.
Since you do not want this code to deploy on production you need to use #if DEBUG flags.

Their are other ways to do this.
All those if DEBUG flags can be removed.

How?

All this flags can be moved to another class.

// So far we are checking taht we are loading 22 cells.
But the problem is we are loading them from server that we do not have control.
We may get 23 or network error or what is server is down.
So all thsi will make your test fail. 
So these tests are falky it depends on some external system being in a specific state you expect to.


IDeally we should be able to run this test over and over and get same result.

So to decouple falkyness.
And decopule our UI test from specific backend.

We have a mechamism for doing that.
JUst like we control the 'Offline' state, we can create an 'Online' state with canned HTTP response.

Thus our test would not depend on connectivity or the backend state server.

# Instead of testing low level details, Use black-box UI tests for testing high level acceptance criteria.

Now those tests does not depend on Server state or the network state.
So these tests are much more reliable.
