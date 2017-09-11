//
//  MyOrderTableViewCell.h
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CardImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@end
