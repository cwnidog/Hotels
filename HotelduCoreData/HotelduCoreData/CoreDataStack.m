//
//  CoreDataStack.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/11/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"

@interface CoreDataStack()

@property (nonatomic) BOOL isTesting;

@end

@implementation CoreDataStack

#pragma mark - Core Data Stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (instancetype) initForTesting // initalize for testing
{
  self = [super init];
  if (self)
  {
    self.isTesting = true;
  }
  return self;
} // initForTesting

- (void) seedDataBaseIfNeeded
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  
  
  NSInteger results = [self.managedObjectContext countForFetchRequest:fetchRequest error:&fetchError];
  NSLog(@" %ld", (long)results);
  
  // if there are no hotels found in memory, use the JSON seed data
  if (results == 0)
  {
    NSURL *seedURL = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
    NSData *seedData = [[NSData alloc] initWithContentsOfURL:seedURL];
    
    NSError *jsonError;
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:seedData options:0 error:&jsonError];
    
    if (!jsonError) // dictionary parsed OK
    {
      NSArray *jsonArray = rootDictionary[@"Hotels"];
      
      for (NSDictionary *hotelDictionary in jsonArray)
      {
        Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
        hotel.name = hotelDictionary[@"name"];
        hotel.rating = hotelDictionary[@"stars"];
        hotel.location = hotelDictionary[@"location"];
        
        NSArray *roomsArray = hotelDictionary[@"rooms"];
        for (NSDictionary *roomDictionary in roomsArray)
        {
          Room *room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.managedObjectContext];
          room.number = roomDictionary[@"number"];
          room.beds = roomDictionary[@"beds"];
          room.rate = roomDictionary[@"rate"];
          room.hotel = hotel;
        } // for each room in the hotel
      } // for each hotel
      
      NSError *saveError;
      [self.managedObjectContext save: &saveError];
      
      if (saveError)
      {
        NSLog(@" %@", saveError.localizedDescription);
      }
      
    } // no error
  } // no hotels in memory
} // seedDataBaseIfNeeded

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "JFL.HotelduCoreData" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
} // applicationDocumentsDirectory

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HotelduCoreData" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
} // managedObjectModel

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotelduCoreData.sqlite"];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  
  NSString *storeType;
  if (self.isTesting)
  {
    storeType = NSInMemoryStoreType; // store in the sandbox only
  }
  
  else
  {
    storeType = NSSQLiteStoreType; // store in persistent memory
  }
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:nil error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return _persistentStoreCoordinator;
} // persistentStoreCoordinator

- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
} // managedObjectContext

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
} // saveContext

@end
