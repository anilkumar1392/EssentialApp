
--- 

It's time to put your development skills to test!

You are called to add new feature to the feed app:

Displaying image comments when user taps on an imagen the feed.

The goal is to implement this feature using what you have learned in this program.

Develop API, Presentation and UI layer for this feature.

* Important: No need to cache comments * 

## Goals

1. Display a list of comments when the user taps on an Image in the Feed.

2. Loading the comments can fail, so handle the UI states accordingly. 
    - Show a loading spinner while loading the comments
    - if it fails to load: show an error message.
    - If it loads successfully: show all loaded comments in order they were returned by the remote API.
    
3. The loading should starts automatically when the user navigates on the screen.
    - The user should be able to reload the comments manually (Pull-to-refresh)
    
4. At all times user should have the back button to return to feed screen.
    - Cancel any running comments API  requests when the user navigates back

5. The comment screen layout should match the UI specs.

Write tests to vaidate your Implementation including Unit, Integration and snapshot test (aim to write the test first).


## So we are simply using Comment Api That will generate image comment, That will be used by the presentation layer to show it on UI.

We are not creating protocol as we have only one Implementation here so we do not need protocol.

## How can we create new features without duplicating the loaders.
Without duplicating the HTTP Clinet.

## Current FeedImage Implementaiton

We have a RemoteFeedLoader that talks with the client gets some data back and it maps the data in to FeedImages.

We can follow the same design with comment module.

## So except Mapper most of the code is duplicated.
Loader code, HttpClient code.  
