//
//  payTableViewController.h
//  convergence
//
//  Created by admin on 2017/9/12.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvergenceModel.h"
#import "VouchersModel.h"
@interface payTableViewController : UITableViewController

@property (strong,nonatomic) VouchersModel *Vouch;
@property (strong,nonatomic) ConvergenceModel *Vouche;
@end
