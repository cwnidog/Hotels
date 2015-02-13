//
//  HashTable.h
//  HotelduCoreData
//
//  Created by John Leonard on 2/12/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HashTable : NSObject
- (void) setObject:(id)object forKey:(NSString*)key;
- (void) removeObjectForKey:(NSString *)key;
- (id) objectForKey:(NSString *)key;
- (instancetype) initWithSize:(NSInteger)size;
@end
