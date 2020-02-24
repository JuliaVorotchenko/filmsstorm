# Project Architecture

## MVC+C is the base pattern on the project. Main actors are:
 
 * **Model** - Data container, persistance object;
 * **View** - Object to represent data on UI. You must inherite Cotroller type to use it as View.
 * **Controller** - Object, which acts as the intermediary between the application's view objects and its model objects.
 * **Coordinator** - Entity, which allows to manage all controllers and sub-coordinators.
 * **Presenter** - Entity, that contains the buisness logic of the app.
 
 ### Coordinator's roles:
 * Incapsulates dependencies;
 * Provides dependency injection role;
 * Init controllers;
 * Navigate controllers (show and hide instack, modally and in any other way);
 * Subscribes on controller's events and react on events;
 * Show or hide sub-coordinators if needed;
 * Conforms AppEventSource to handle app events.
 
 ### Coordinator CAN NOT:
 * Save any controller as property;
 
 ```swift
   protocol Coordinator: AnyObject, AppEventSource {
      var childCoordinators: [Coordinator] { get set }
      var navigationController: UINavigationController { get }
      func start()
   }
```
 
 ```swift
   protocol AppEventSource {
      var eventHandler: ((AppEvent) -> Void)? { get }
   }
 ```
 
 ## Controller
   You must implement this proptocol on each UIViewController which is used in coordinators.
 In this MVC+C pattern  every controller must init with its own events. 

```swift
    protocol Controller: RootViewGettable, ControllerEventSourse {}
```
   ### Controller's  roles:
 * define reusable view to display data;
 * generate events for coordinator about user's action;
 * RootViewGettable to get  access to controller's view;
 * ControllerEventSourse to provide events for coordinator.
 
   ### Controller CAN NOT:
 * Show other controllers;
 * Know how to present itself;
 * Modify any data before presentation.
 
  This protocol handles Controller's events in Coordinator (or use delegation as simple alternative):
 ```swift
    protocol ControllerEventSourse {
        associatedtype Event: EventProtocol
        var eventHandler: ((Event) -> Void)? { get }
    }
 ```
  
  This protocol is needed to subscribe events:
 ``` swift
    protocol EventProtocol {}
 ```
 
## Presenter
   ### Presenter's  roles:
* Mediates between ViewControllers and Networking
* Realizes buisness logic

All presenters have to be under Presener protocol:
```swift
 protocol Presenter: AnyObject, EventSourse {
    
}
 ```


   
 
