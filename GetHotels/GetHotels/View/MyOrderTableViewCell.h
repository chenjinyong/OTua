//
//  MyOrderTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelsnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotelsLabel;

@end
