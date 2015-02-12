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
#import "HotelService.h"

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
  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:[[HotelService sharedService] coreDataStack].managedObjectContext];
  guest.firstName = @"John";
  guest.lastName = @"Leonard";
  
  [[HotelService sharedService] bookReservationForGuest:guest ForRoom:self.selectedRoom startDate:self.startDatePicker.date endDate:self.endDatePicker.date];
  [self dismissViewControllerAnimated:true completion:nil];
  
} // bookPressed()

@end
