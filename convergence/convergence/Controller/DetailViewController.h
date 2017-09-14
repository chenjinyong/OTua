//
//  DetailViewController.h
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvergenceModel.h"

@interface DetailViewController : UIViewController
//创建一个容器去接受别的页面传来的数据
@property (strong,nonatomic) ConvergenceModel * fitness;

@end
