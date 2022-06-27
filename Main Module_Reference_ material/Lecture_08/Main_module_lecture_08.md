##   Organizing Modular Codebases with Horizontal and Vertical Slicing

## Learning Outcomes
Horizontal modular slicing by layers
Vertical modular slicing by features
Organizing the codebase into independent frameworks and projects


## 1. Monolith - Single project with a single application target
The most common way to organize projects is to keep all components in a single project with a single application target. For example, an iOS application target where all components live:

This may work well for small projects and prototypes but can quickly become a bottleneck as the team grows, and more features are added to the app.

The more code you add to a single target, the more conflicts will arise. And the longer it will take to build, run, and test the project.

Moreover, there’s no physical separation of modules. So, it requires discipline to keep your code modular.
