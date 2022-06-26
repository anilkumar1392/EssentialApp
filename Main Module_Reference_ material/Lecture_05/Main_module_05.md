 In last lecture we tested the acceptance criteria with UI Tests which works fine but their are two problems.
 
 1. We eneded up adding test code in our production target. (Test specific code populating the production target)
 2. Those tests are extremely slow.
 
 three simple test stook 30s.
 As we add more features, UI tests will slow down the development process.
 
 Your iterations should be fast, So you can keep merging and releasing code with confidance several times a day.
 But if our CI tool takes hours to run this will become bottle neck.
 
 ## So we need a better statergy to test.
 
