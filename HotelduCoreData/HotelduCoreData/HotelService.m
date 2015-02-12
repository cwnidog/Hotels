//
//  HotelService.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/11/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "HotelService.h"

@implementation HotelService

+ (id) sharedService
{
  static HotelService *mySharedService = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    mySharedService = [self new];
  });
  
  return mySharedService;
} // sharedService

-(instancetype) init
{
  self = [super init];
  if (self)
  {
    self.coreDataStack = [CoreDataStack new];
  }
  
  return self;
} // init

- (instancetype) initForTesting
{
  self = [super init];
  if (self)
  {
    self.coreDataStack = [[CoreDataStack alloc] initForTesting];
  }
  return self;
} // initForTesting

- (Reservation *) bookReservationForGuest:(Guest *)guest ForRoom:(Room *)room startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
  
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  reservation.startDate = startDate;
  reservation.endDate = endDate;
  reservation.room = room;
  reservation.guest = guest;
  
  NSError *saveError;
  [self.coreDataStack.managedObjectContext save:&saveError];
  
  if (!saveError)
  {
    return reservation;
  }
  else
  {
    return nil;
  }
} // bookReservationForGuest()

@end
