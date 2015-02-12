//
//  ReservationListViewController.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/11/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "ReservationListViewController.h"
#import "HotelService.h"
#import "AddReservationViewController.h"

@interface ReservationListViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ReservationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  NSManagedObjectContext *context = [[HotelService sharedService] coreDataStack].managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"room == %@", self.selectedRoom];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true];
  fetchRequest.predicate = predicate;
  fetchRequest.sortDescriptors = @[sortDescriptor];
  
  self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
  
  self.fetchedResultsController.delegate = self;
  self.tableView.dataSource = self;
  
  NSError *fetchError;
  [self.fetchedResultsController performFetch:&fetchError];
  
  if (fetchError)
  {
    NSLog(@"Reservation List fetch returned error: %@", fetchError);
  }
} // viewDidLoad

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
} // controllerWillChangeContent()

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
} // controllerDidChangeContent()

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
       break;
    case NSFetchedResultsChangeMove:
     [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
     [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    default:
      break;
  } // switch(type)
} // controller()

-(void) configureCell:(UITableViewCell *)cell atIndexPath: (NSIndexPath *)indexPath
{
  Reservation *reservation = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"room: %@", reservation.room.number];
} // configureCell()

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
} // numberOfSectionsInTableView()

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray *sections = [self.fetchedResultsController sections];
  id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
  return [sectionInfo numberOfObjects];
} // numberOfRowsInSection

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RESERVATIONS_CELL" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
} // cellForRowAtIndexPath

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ADD_RESERVATION"])
  {
    AddReservationViewController *destinationVC = segue.destinationViewController;
    destinationVC.selectedRoom = self.selectedRoom;
  }
} // prepareForSegue()


@end
