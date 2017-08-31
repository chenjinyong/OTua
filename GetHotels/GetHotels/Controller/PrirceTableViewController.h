//
//  PrirceTableViewController.h
//  GetHotels
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GethontelModel.h"
#import "HontelModel.h"
#import "HontelBookingModel.h"

@interface PrirceTableViewController : UITableViewController

@property (strong,nonatomic) GethontelModel *Hotel;
@property (strong,nonatomic) HontelBookingModel *apply;


@end
