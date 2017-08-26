//
//  HontelBookingHontelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HontelBookingViewController.h"

@interface HontelBookingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hontelImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *hontelbedLabel;//风格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *timeOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTwoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bedImg;
@property (weak, nonatomic) IBOutlet UIButton *styleBtn;
@property (weak, nonatomic) IBOutlet UILabel *breakfastLabel;//是否含早点
@property (weak, nonatomic) IBOutlet UILabel *bedStylelabel;//床大小
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;//大小

@property (weak, nonatomic) IBOutlet UILabel *serviceA;//酒店设施/服务
@property (weak, nonatomic) IBOutlet UILabel *serviceB;
@property (weak, nonatomic) IBOutlet UILabel *serviceC;
@property (weak, nonatomic) IBOutlet UILabel *serviceD;
@property (weak, nonatomic) IBOutlet UILabel *serviceE;
@property (weak, nonatomic) IBOutlet UILabel *serviceF;
@property (weak, nonatomic) IBOutlet UILabel *serviceG;
@property (weak, nonatomic) IBOutlet UILabel *serviceH;

@property (weak, nonatomic) IBOutlet UILabel *policyA;//政策
@property (weak, nonatomic) IBOutlet UILabel *policyB;

@property (weak, nonatomic) IBOutlet UILabel *petLabel;

@property (weak, nonatomic) IBOutlet UIButton *contactBtn;//米聊
- (IBAction)contactAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;//购买
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation HontelBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dict = @{@"taskName" : @"测试项目007",@"time" : @"2017-08-07 11:19",@"phone" : @"180****6666",@"name" : @"张三",@"detail" : @"测试项目",@"remark" : @"这是一段备注，详情暂无"};
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

- (IBAction)contactAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
