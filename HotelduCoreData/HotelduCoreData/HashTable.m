//
//  HashTable.m
//  HotelduCoreData
//
//  Created by John Leonard on 2/12/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "HashTable.h"
#import "Bucket.h"

@interface HashTable()

@property (nonatomic) NSInteger size;
@property (strong, nonatomic) NSMutableArray *hashArray;

@end

@implementation HashTable

-(instancetype) initWithSize:(NSInteger)size
{
  self = [super init];
  
  if (self) // we exist
  {
    self.size = size;
    self.hashArray = [NSMutableArray new];
    
    // initialize each element in the array to nil
    for (int i = 0; i <self.size; i++)
    {
      self.hashArray[i] = nil;
    }
  } // if self
  return self;
} // initWithSize()

- (NSInteger) hash:(NSString *)key
{
  NSInteger total = 0;
  
  for (int i = 0; i < key.length; i++)
  {
    NSInteger ascii = [key characterAtIndex:i];
    total += ascii;
  }
  NSInteger index = total % self.size;
  return index;
} // hash()

- (id) objectForKey:(NSString *)key
{
  // hash the key to get the hashArray index
  NSInteger index = [self hash:key];
  Bucket *bucket = self.hashArray[index]; // may be nil
  
  // traverse the bucket list until we find the one that matches - or to the end
  while (bucket)
  {
    if ([bucket.key isEqualToString:key]) // found the right bucket
    {
      return bucket.data;
    }
    
    else
    {
      bucket = bucket.next;
    }
  } // while bucket
  
  return nil; // didn't find the riht bucket
} // objectForKey()

- (BOOL) removeObjectForKey:(NSString *)key
{
  NSInteger index = [self hash:key];
  BOOL success = false; // will return true if able to find and remove an object
  
  Bucket *previousBucket;
  Bucket *bucket = self.hashArray[index];
  
  while (bucket)
  {
    if ([key isEqualToString:bucket.key])
    {
      if (!previousBucket) // at head of array
      {
        Bucket *nextBucket = bucket.next;
        self.hashArray[index] = nextBucket;
      }
      
      else
      {
        previousBucket.next = bucket.next;
      }
      success = true;
    } // if key
    
    previousBucket = bucket;
    bucket = bucket.next;
  } // while bucket
  return  success;
} // removeObjectForKey()

- (BOOL) setObject:(id)object forKey:(NSString *)key
{
  NSInteger index = [self hash:key];
  BOOL success = false; // will return true if could add an object
  
  Bucket *bucket = [Bucket new];
  bucket.key = key;
  bucket.data = object;
  
  [self removeObjectForKey:key]; // no duplicates allowed
  Bucket *head = self.hashArray[index];
  
  if (!head) // empty bucket list
  {
    self.hashArray[index] = bucket;
    success = true;
  }
  
  else // bucket list isn't empty
  {
    bucket.next = head;
    self.hashArray[index] = bucket;
    success = true;
  }
  return success;
} // setObject()

@end
