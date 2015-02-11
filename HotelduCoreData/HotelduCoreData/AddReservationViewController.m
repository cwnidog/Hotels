//
//  AddReservationViewController.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/10/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "AddReservationViewController.h"
#import "Reservation.h"
#import "Guest.h"

@interface AddReservationViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end

@implementation AddReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)bookPressed:(id)sender
{
  Reservation * reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.selectedRoom.managedObjectContext];
  
  // set room attributes
  reservation.startDate = self.startDatePicker.date;
  reservation.endDate = self.endDatePicker.date;
  reservation.room = self.selectedRoom;
  
  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.selectedRoom.managedObjectContext];
  guest.firstName = @"John";
  guest.lastName = @"Leonard";
  reservation.guest = guest;
  
  NSLog(@"%lu", (unsigned long)self.selectedRoom.reservations.count);
  
  NSError * saveError;
  [self.selectedRoom.managedObjectContext save:&saveError];
  
  if (saveError)
  {
    NSLog(@" %@", saveError.localizedDescription);
  }
  
} // bookPressed()

@end
