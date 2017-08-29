//
//  GetHontelViewController.h
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GethontelModel.h"
@interface GetHontelViewController : UIViewController
@property (strong,nonatomic) GethontelModel *callBack;

//滚动视图
@property (strong, nonatomic) UIScrollView *scrV;
@property (strong, nonatomic) UIPageControl *pageC;
@property (strong, nonatomic) UIImageView *imgVLeft;
@property (strong, nonatomic) UIImageView *imgVCenter;
@property (strong, nonatomic) UIImageView *imgVRight;
@property (strong, nonatomic) UILabel *lblImageDesc;
@property (strong, nonatomic) NSMutableDictionary *mDicImageData;
@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (assign, nonatomic) NSUInteger imageCount;


@end
