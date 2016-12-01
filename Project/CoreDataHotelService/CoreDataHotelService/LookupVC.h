//
//  LookupVC.h
//  CoreDataHotelService
//
//  Created by Jacob Dobson on 11/30/16.
//  Copyright © 2016 Jacob Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reservation+CoreDataClass.h"

@interface LookupVC : UIViewController

@property(strong, nonatomic)Reservation *reservation;

@end
