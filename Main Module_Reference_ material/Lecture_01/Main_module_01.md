

Learning Outcomes
## Breaking responsibilities into multiple protocols (Interface Segregation Principle) to achieve flexible, composable and modular components.
Combining Xcode projects into a workspace and embedding frameworks to compose modules into a running iOS app.


So, just as we did with the Feed Loading specs, we’ve added use cases to clarify and document the Feed Image Data Loading specs.

## Load Feed Image Data From Remote Use Case
Data:

URL
Primary course (happy path):

Execute “Load Image Data” command with above data.
System downloads data from the URL.
System validates downloaded data.
System delivers image data.
Cancel course:

System does not deliver image data nor error.
Invalid data – error course (sad path):

System delivers invalid data error.
No connectivity – error course (sad path):

System delivers connectivity error.

## Load Feed Image Data From Cache Use Case
Data:

URL
Primary course (happy path):

Execute “Load Image Data” command with above data.
System retrieves data from the cache.
System delivers cached image data.
Cancel course:

System does not deliver image data nor error.
Retrieval error course (sad path):

System delivers error.
Empty cache course (sad path):

System delivers not found error.

## Cache Feed Image Data Use Case
Data:

Image data
Primary course (happy path):

Execute “Save Image Data” command with above data.
System saves new cache data.
System delivers success message.
Saving error course (sad path):

System delivers error.
