//
//  AddReservationViewController.h
//  HotelduCoreData
//
//  Created by John Leonard on 2/10/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface AddReservationViewController : UIViewController

@property (strong, nonatomic) Room *selectedRoom; // the room we want to know about

@end
