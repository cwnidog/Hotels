//
//  RoomListViewController.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/9/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "RoomListViewController.h"
#import "Room.h"

@interface RoomListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RoomListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSLog(@"Number of rooms handed in %lu", (unsigned long)self.rooms.count);
  
  // we're our own datasource
  self.tableView.dataSource = self;
  
  // refresh the disolayed data to show updates
  [self.tableView reloadData];
  
} // viewDidLoad


// how many rows, i.e. rooms in the room list?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.rooms)
  {
    return _rooms.count;
  }
  else
  {
    return 0;
  }
} // numberOfRowsInSection

// we want to display room number for each room in the room list
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // dequeue the cell
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ROOM_CELL" forIndexPath:indexPath];
  
  // get the room from the room array
  Room *room = self.rooms[indexPath.row];
  
  // display its number 
  cell.textLabel.text = [NSString stringWithFormat:@"%@",room.number];
  
  return cell;
} //cellForRowAtIndexPath


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
