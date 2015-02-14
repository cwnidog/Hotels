//
//  HashTableTests.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/13/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HashTable.h"

@interface HashTableTests : XCTestCase
@property (nonatomic) NSInteger size;
@property (strong, nonatomic) HashTable *hashTable;

@end

@implementation HashTableTests

- (void)  setUp
{
  [super setUp];
  
  self.size = 100;
  self.hashTable = [[HashTable alloc] initWithSize:self.size];
} // setUp

-(void) tearDown
{
  self.hashTable = nil;
  [super tearDown];
} // tearDown

- (void) testSetObject
{
  NSString *key = @"Bob";
  NSString *object = @"123 Main St.";
  BOOL success = false;
  
  success = [self.hashTable setObject:object forKey:key];
  XCTAssert(success, @"setObject should not return false when adding first key.");
  
  key = @"Bob";
  object = @"456 Elm St.";
  success = false;
  
  success = [self.hashTable setObject:object forKey:key];
  XCTAssert(success, @"setObject should not return false when finds duplicate key.");
  
  key = @"Jim";
  object = @"A dozen oranges";
  success = false;
  
  success = [self.hashTable setObject:object forKey:key];
  XCTAssert(success, @"setObject should not return nil when it adds a new key.");
  
} // testSetObject

- (void) testRemoveObjectForKey
{
  NSString *key = @"Bob";
  NSString *object = @"123 Main St.";
  BOOL success = false;
  
  // add bucket with data to the hash table
  [self.hashTable setObject:object forKey:key];
  
  success = [self.hashTable removeObjectForKey:key];
  XCTAssert(success, @"removeObjectForKey should not return false");
  
  success = [self.hashTable removeObjectForKey:key];
  XCTAssertFalse(success, @"removeObjectForKey should return false if key not found");
  
} // testRemoveObjectForKey

- (void) testObjectForKey
{
  NSString *bobKey = @"Bob";
  NSString *bobObject = @"123 Main St.";
  NSString *jimKey = @"Jim";
  NSString *jimObject = @"A dozen oranges";
  NSString *obbKey = @"boB";
  NSString *obbObject = @"A peck of pickled peppers";
  NSString *noneKey = @"Nonesuch";
  
  [self.hashTable setObject:bobObject forKey:bobKey];
  [self.hashTable setObject:jimObject forKey:jimKey];
  [self.hashTable setObject:obbObject forKey:obbKey];
  
  XCTAssertEqualObjects([self.hashTable objectForKey:bobKey], bobObject, @"Fail if don't get Bob's object.");
  XCTAssertEqualObjects([self.hashTable objectForKey:obbKey], obbObject, @"Fail if don't get obB's object.");
  XCTAssertEqualObjects([self.hashTable objectForKey:jimKey], jimObject, @"Fail if don't get Jims's object.");
  XCTAssertNil([self.hashTable objectForKey:noneKey], @"Fail if find an object for a key not in the hash table.");
  
} // testObjectForKey
@end
