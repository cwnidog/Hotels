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

@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *hotels;

@end

@implementation HotelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  // get the context and set up the fetch request
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSManagedObjectContext *context = appDelegate.managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  
  // execute the fetch request
  NSArray *results =[context executeFetchRequest:fetchRequest error:&fetchError];
  
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
}

// if we click on a hotel in the list, show the list of its rooms by number
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // instantiate a new roomList VC
  RoomListViewController  *roomListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ROOM_LIST"];
  
  // turn the set of rooms at this hotel into an array
  Hotel *hotel = self.hotels[indexPath.row];
  NSArray *rooms = [hotel.rooms allObjects];
  
  //pass the array of rooms to the roomList VC and push a new roomListVC onto the nav stack
  NSLog(@"Number of rooms in hotel %lu", (unsigned long)rooms.count);
  roomListVC.rooms = rooms;
  [self.navigationController pushViewController:roomListVC animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
