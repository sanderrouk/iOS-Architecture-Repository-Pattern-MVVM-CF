# iOS Architecture Repository Pattern MVVM-CF
The purpose of this project is to create a simple design and usability pattern for multiple data sources when dealing with data persistence in an iOS app. This is more of a proof of concept than an actual project. This is definitely apparent when looking at the view code as hard coded strings are present there. This would never be the case in an actual production application. 

## Running
The app comes with a small Vapor 3 based backend which has an inmemory sqlite db. 

To run the Vapor project a swift runtime must be present. Running the following command will launch the backend if port 8080 is vacant.

```bash
$ swift run 
```

The iOS app requires XCode and a Mac to be able to run. The app, if ran on a simulator will find the backend service running on the same machine, however if it is run elsewhere then additional code changes are needed.


## Concept
The purpose of this excercise is to abstract the usage of multiple data sources and offer view models with a singular point of contact. For instance when retrieving TODO objects in this app, our fictional business logic dictates, that we should first show the objects which are locally persisted (previously exist in Realm's database), and only after retrieving the new data from a remote source and persisting it into Realm's database should that data be forwarded to the view model. If this flow would be declared in multiple locations then it would be a nightmare to handle. Additionally if this data is all in one singular place then it becomes hard to handle as additional logic may be needed as well. 

For this using a single provider (TodoProvider) and multiple repositories one for the local source and one for the remote source can be used. This creates convenience and abstraction as much as neccessary.

This example is not perfect, and multiple layers of the implementation can be discussed over. The idea of the example is not to show which frameworks to use, but rather a pattern. That we recognize that both the repositories have a singular async action that can only be completed once. However the provider's get is a multiple completion async event. We recognize that different objects and patterns may be needed for this. It is highly likely that a large group of iOS developers would be claiming that RxSwift is perfect for this and it is not disputed here, instead it is just not the purpose of this concept.

This concept also demonstrates the ease of use of the MVVM-CF pattern alongside the repository pattern.