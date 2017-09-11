//
//  ModifyViewController.m
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的文字
    self.navigationItem.title = @"修改昵称";
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Sava" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = right;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
