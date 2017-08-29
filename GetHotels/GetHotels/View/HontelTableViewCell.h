//
//  HontelTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HontelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotel_address;
@property (weak, nonatomic) IBOutlet UILabel *hontelName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *distance;

//hontelImg hontelName distanceLabel timeLabel rmbLabel
@end
