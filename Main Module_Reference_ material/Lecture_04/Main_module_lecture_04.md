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
