//
//  Bucket.h
//  HotelduCoreData
//
//  Created by John Leonard on 2/12/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bucket : NSObject

@property (strong, nonatomic) Bucket *next;
@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSString *key;

@end
