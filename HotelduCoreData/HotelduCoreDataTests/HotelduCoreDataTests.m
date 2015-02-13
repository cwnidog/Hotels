//
//  HotelduCoreDataTests.m
//  HotelduCoreDataTests
//
//  Created by John Leonard on 2/9/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"

@interface HotelduCoreDataTests : XCTestCase
@property (strong, nonatomic) HotelService *hotelService;
@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) Guest *guest;
@property (strong, nonatomic) Hotel *hotel;

@end

@implementation HotelduCoreDataTests

- (void)setUp
{
  [super setUp];
  self.hotelService = [[HotelService alloc] initForTesting];
  self.hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.hotel.name = @"Fake Hotel";
  self.hotel.location = @"Ellensberg";
  self.hotel.rating = @1;
  
  self.room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.room.number = @101;
  self.room.rate = @1;
  self.room.hotel = self.hotel;
  self.room.beds = @2;
  
  self.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
  self.guest.firstName = @"Testy";
  self.guest.lastName = @"McTestorson";
  
} // setUp

- (void)tearDown
{
  self.hotelService = nil;
  self.hotel = nil;
  self.room = nil;
  self.guest = nil;
  
  [super tearDown];
} // tearDown

- (void) testBookReservation
{
  NSDate * startDate = [NSDate date];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [NSDateComponents new];
  components.day = 2;
  NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
  
  Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest ForRoom:self.room startDate:startDate endDate:endDate];
  XCTAssertNotNil(reservation, @"Reservation should not be nil for valid dates.");
} // testBookReservation

- (void) testBookReservationWithStartDateAfterEndDate
{
  NSDate  *currDate = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components  = [NSDateComponents new];
  components.day = 5;
  NSDate *endDate = [calendar dateByAddingComponents:components toDate:currDate options:0];
  components.day = 7;
  NSDate *startDate = [calendar dateByAddingComponents:components toDate:currDate options:0];

  Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest ForRoom:self.room startDate:startDate endDate:endDate];
  XCTAssertNil(reservation, @"Reservation should  be nil if start date ia after end date.");
} // testBookReservationWithStartDateAfterEndDate

- (void) testBookReservationWithStartDateToday
{
  NSDate  *currDate = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components  = [NSDateComponents new];
  components.day = 5;
  NSDate *endDate = [calendar dateByAddingComponents:components toDate:currDate options:0];
  NSDate *startDate = currDate;
  
  Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest ForRoom:self.room startDate:startDate endDate:endDate];
  XCTAssertNotNil(reservation, @"Reservation should allow start date to be thw current date.");
} // testBookReservationWithStartDateAfterEndDate

- (void) testBookReservationWithStartDateBeforeToday
{
  NSDate  *currDate = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components  = [NSDateComponents new];
  components.day = -2;
  NSDate *startDate = [calendar dateByAddingComponents:components toDate:currDate options:0];
  components.day = 7;
  NSDate *endDate = [calendar dateByAddingComponents:components toDate:currDate options:0];
  
  Reservation *reservation = [self.hotelService bookReservationForGuest:self.guest ForRoom:self.room startDate:startDate endDate:endDate];
  XCTAssertNil(reservation, @"Reservation should  be nil if start date is earlier than today.");
} // testBookReservationWithStartDateAfterEndDate


@end
