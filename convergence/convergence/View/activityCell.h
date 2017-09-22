//
//  activityCell.h
//  convergence
//
//  Created by admin on 2017/9/21.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImgView;
@property (weak, nonatomic) IBOutlet UILabel *activityLbl;
@property (weak, nonatomic) IBOutlet UILabel *LikeLbl;
@property (weak, nonatomic) IBOutlet UILabel *UnlikeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addLbl;

@end
