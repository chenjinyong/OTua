//
//  FindCollectionViewCell.h
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *shopLbl;//名字
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;//地址
@property (weak, nonatomic) IBOutlet UILabel *disLbl;//距离

@end
