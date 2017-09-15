//
//  DetailTableViewCell.h
//  convergence
//
//  Created by admin on 2017/9/15.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end
