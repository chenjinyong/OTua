//
//  activityViewController.h
//  convergence
//
//  Created by admin on 2017/9/21.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface activityViewController : UIViewController

//创建一个容器去接受别的页面传来的数据
@property (strong,nonatomic)ActivityModel *activity;

@end
