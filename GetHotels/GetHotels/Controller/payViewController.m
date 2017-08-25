//
//  payViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "payViewController.h"

@interface payViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hontelNameLabel;//酒店名称
@property (weak, nonatomic) IBOutlet UILabel *stayTimeLabel;//入住时间
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UIImageView *orighImg;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *payaBtn;
@property (weak, nonatomic) IBOutlet UIButton *paybBtn;
@property (weak, nonatomic) IBOutlet UIButton *paycBtn;

- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation payViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
