//
//  RoomListViewController.h
//  HotelduCoreData
//
//  Created by John Leonard on 2/9/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hotel.h"

@interface RoomListViewController : UIViewController

@property (strong, nonatomic) Hotel *selectedHotel; // the hotel that was clicked

@end
