//
//  AvailibilityViewController.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/10/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "AvailibilityViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"

@interface AvailibilityViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hotelSegmentedControl;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation AvailibilityViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
} // viewDidLoad()


- (IBAction)checkAvailibilityPressed:(id)sender
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
  
  NSString *selectedHotel = [self.hotelSegmentedControl titleForSegmentAtIndex:self.hotelSegmentedControl.selectedSegmentIndex];
  
  // fetch all the rooms with a hotel ame that matches the selected hotel
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.hotel.name MATCHES %@", selectedHotel];
  fetchRequest.predicate = predicate;
  
  // get the set of rooms that are reserved for all or part of the sleected period at the selected hotel
  NSFetchRequest *reservationFetch = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
  
  // if a room is reserved for any time during between the selected start and end dates, it's considered unavailable
  NSPredicate *reservationPredicate = [NSPredicate predicateWithFormat:@"room.hotel.name MATCHES %@ AND (startDate <= %@ AND endDate >= %@)", selectedHotel, self.endDatePicker.date, self.startDatePicker.date];
  
  reservationFetch.predicate = reservationPredicate;
  NSError *fetchError;
  
  // fetch the set of unavailable rooms from persistent data
  NSArray *results = [self.context executeFetchRequest:reservationFetch error:&fetchError];
  NSLog(@"Results count: %lu", (unsigned long)results.count);
  
  if (fetchError)
  {
    NSLog(@" Reservation fetch got error %@", fetchError);
  }
  
  NSMutableArray *rooms = [NSMutableArray new]; // the list of unavailable rooms
  for (Reservation *reservation in results)
  {
    [rooms addObject:reservation.room];
  }
  
  // get the set of unreserved rooms at the selected hotel
  NSFetchRequest *anotherFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
  NSPredicate *roomsPredicate = [NSPredicate predicateWithFormat:@"hotel.name MATCHES %@ AND NOT (self IN %@)", selectedHotel, rooms];
  anotherFetchRequest.predicate = roomsPredicate;
  NSError *finalError;
  NSArray *finalResults = [self.context executeFetchRequest:anotherFetchRequest error:&finalError];
  
  if (finalError)
  {
    NSLog(@" Finale fetch got error: %@", finalError.localizedDescription);
  }
  
  NSLog(@"Number of availible rooms in the selected period: %lu", (unsigned long)finalResults.count);
  
} // checkAvailibilityPressed()


@end
