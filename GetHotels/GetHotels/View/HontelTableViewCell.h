//
//  HontelTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HontelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hontelImg;
@property (weak, nonatomic) IBOutlet UILabel *hontelName;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@end
