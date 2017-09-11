//
//  MyOrderViewController.h
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VouchersModel.h"
#import "orderModel.h"

@interface MyOrderViewController : UIViewController

//创建一个容器去接受别的页面传来的数据
@property (strong,nonatomic)VouchersModel *order;
@property (strong,nonatomic)orderModel *model;


@end
