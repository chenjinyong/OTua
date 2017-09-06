//
//  ConTableViewCell.h
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;//体验卡图片
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;//体验卡
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;//卷
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *numLabel;//已售数量
@end
