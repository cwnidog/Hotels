# Hotels
=========

##Initial
---------
* Import the CoreDataStack file that I uploaded to Canvas into your project
* Setup your MOM with entities for Hotel >> Room >> Reservation > Guest
* Seed your data base with the JSON payload provided
* Create a static table view based menu view controller. This will be the first view controller the user sees. The first option should segue to HotelsViewController,
which will show the hotels in a table view.
* Upon selecting a hotel, segue to a RoomsViewController, which shows all the rooms of that hotel in another table view.

##Reservations
--------------
* Setup a View controller that allows you to book reservations for the room they select from your RoomsListViewController.
* Create an Availability View Controller, which lets the user query for all rooms that are available in a specific date range, aka they don't have reservations
anywhere in that range.

##CoreData
-----------
* Separate your core data setup into a separate CoreDataStack Class.
Create a HotelService class that should abstract away your business logic (booking reservations, checking availability, etc)
* Write unit tests for your HotelServiceMethods
* Implement a fetchedresultscontroller in your reservation list view controller.

##Hash
------
* Create an implementation of Hash Table.
