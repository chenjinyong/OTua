//
//  DetailViewController.h
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvergenceModel.h"
#import "DetailModel.h"
@interface DetailViewController : UIViewController{
    NSInteger _nextIndex;
}

//创建一个容器去接受别的页面传来的数据
@property (strong,nonatomic) ConvergenceModel * fitness;
@property(nonatomic,strong) DetailModel * home;
@property (strong, nonatomic) NSArray *imagePaths;

@end
