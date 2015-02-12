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
    [self.coreDataStack seedDataBaseIfNeeded];
  }
  
  return self;
} // init

- (instancetype) initForTesting
{
  self = [super init];
  if (self)
  {
    self.coreDataStack = [[CoreDataStack alloc] initForTesting];
    [self.coreDataStack seedDataBaseIfNeeded];
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
  
  // get today's date, without time
  NSDate *now = [NSDate new];
  
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  [dateFormatter setDateFormat:@"yyyy-mm-dd"];
  NSString *dateString = [dateFormatter stringFromDate:now];
  NSDate *currDate = [dateFormatter dateFromString:dateString];
  
  NSLog(@"Start date: %@", startDate);
  NSLog(@"End date: %@", endDate);
  NSLog(@"Now : %@", currDate);
  
  // if the start date is the same as or before the end date, not valid
  if ([startDate compare:endDate] != NSOrderedAscending)
  {
    NSLog(@"Start date is not before end date.");
    return nil;
  }
  
  // the start date has to be now or later
  else if([startDate compare:currDate] == NSOrderedAscending)
  {
    NSLog(@"Start date is not before or the same as now.");
    return nil;
  }
  // the end date has to be after today
  else if ([endDate compare:currDate]!= NSOrderedDescending)
  {
    NSLog(@"End date is not after now.");
    return nil;
  }
  
  
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
