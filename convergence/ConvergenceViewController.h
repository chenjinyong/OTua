//
//  ConvergenceViewController.h
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvergenceModel.h"
#import "ConvergenceTableViewCell.h"
@interface ConvergenceViewController : UIViewController
@property (strong,nonatomic) ConvergenceModel*model;
@property (strong,nonatomic)ConvergenceTableViewCell *convergence;
@end
