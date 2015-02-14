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
      Bucket *bucket = [Bucket new];
      [self.hashArray addObject:bucket];
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
  NSInteger index = [self hash:key];
  Bucket *bucket = self.hashArray[index];
  
  while (bucket)
  {
    if ([bucket.key isEqualToString:key])
    {
      return bucket.data;
    }
    
    else
    {
      bucket = bucket.next;
    }
  } // while bucket
  return nil; // bucket with key not found
} // objectForKey()

- (BOOL) removeObjectForKey:(NSString *)key
{
  NSInteger index = [self hash:key];
  Bucket *bucket = self.hashArray[index];
  Bucket *previousBucket;
  BOOL success = false;
  
  while (bucket)
  {
    if ([key isEqualToString:bucket.key])
    {
      if (!previousBucket)
      {
        Bucket *nextBucket = bucket.next;
        if (!nextBucket)
        {
          nextBucket = [Bucket new];
        }
        self.hashArray[index] = nextBucket;
      } // !previous bucket
      
      else
      {
        previousBucket.next = bucket.next;
      }
      success = true;
      return success;
    } // if key
    
    previousBucket = bucket;
    bucket = bucket.next;
  } // while bucket
  
  if (bucket == nil) {
    return false;
  }
  return success;
} // removeObjectForKey()

- (BOOL) setObject:(id)object forKey:(NSString *)key
{
  NSInteger index = [self hash:key];
  Bucket *bucket = [Bucket new];
  bucket.key = key;
  bucket.data = object;
  
  BOOL success = false;
  
  [self removeObjectForKey:key];
  Bucket *head = self.hashArray[index];
  
  if (!head.data) // just an empty node, so list is empty
  {
    self.hashArray[index] = bucket;
    success = true;
  }
  
  else
  {
    bucket.next = head;
    self.hashArray[index] = bucket;
    success = true;
  }
  return success;
} // setObject()

@end
