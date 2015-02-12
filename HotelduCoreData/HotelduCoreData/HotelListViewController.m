//
//  HotelListViewController.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/9/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "HotelListViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "RoomListViewController.h"
#import "HotelService.h"

@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *hotels;

@end

@implementation HotelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  
  // execute the fetch request
  NSArray *results = [[[HotelService sharedService] coreDataStack].managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  
  if (!fetchError) // if we were able to fetch something
  {
    self.hotels = results; // put it in the list of hotels
    [self.tableView reloadData]; // refresh the displayed data
  } // no error

} // viewDidLoad()

// if we have hotels in the array, return how many, else return 0
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.hotels)
  {
    return self.hotels.count;
  }
  else
  {
    return 0;
  }
} // numberOfRowsInSection

// how do we want to display the hotel data in the list
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOTEL_CELL" forIndexPath:indexPath];
  Hotel *hotel = self.hotels[indexPath.row];
  cell.textLabel.text = hotel.name;
  return cell;
} // cellForRowAtIndexPath

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"SHOW_ROOMS"])
  {
    RoomListViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    Hotel *hotel = self.hotels[indexPath.row];
    destinationVC.selectedHotel = hotel;
  } // if segue.identifier
} // prepareForSegue()

@end
