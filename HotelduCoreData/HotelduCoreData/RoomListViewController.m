//
//  RoomListViewController.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/9/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "RoomListViewController.h"
#import "Room.h"
#import "AddReservationViewController.h"

@interface RoomListViewController () <UITableViewDataSource>
@property (strong,nonatomic) NSArray *rooms; // holds all the rooms at the selected hotel
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RoomListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.rooms = self.selectedHotel.rooms.allObjects;
  
  // we're our own datasource
  self.tableView.dataSource = self;
  
} // viewDidLoad


// how many rows, i.e. rooms in the room list?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSLog(@"There are %lu rooms in the room list", (unsigned long)self.rooms.count);
  return self.rooms.count;
} // numberOfRowsInSection

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // get the room we're interested in
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROOM_CELL" forIndexPath:indexPath];
  Room *room = self.rooms[indexPath.row];
  
  // display the room number in the roomList VC
  cell.textLabel.text = [NSString stringWithFormat:@"%@", room.number];
  
  return cell;
} // cellForRowAtIndexPath

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"SHOW_RESERVATION_LIST"])
  {
    AddReservationViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    Room *room = self.rooms[indexPath.row];
    destinationVC.selectedRoom = room;
  }
} // prepareForSegue()
@end
