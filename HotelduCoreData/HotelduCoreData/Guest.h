//
//  Guest.h
//  HotelduCoreData
//
//  Created by John Leonard on 2/9/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Guest : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet *reservation;
@end

@interface Guest (CoreDataGeneratedAccessors)

- (void)addReservationObject:(NSManagedObject *)value;
- (void)removeReservationObject:(NSManagedObject *)value;
- (void)addReservation:(NSSet *)values;
- (void)removeReservation:(NSSet *)values;

@end
