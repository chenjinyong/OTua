//
//  VouchersViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "VouchersViewController.h"
//#import "VouchersModel.h"
//#import "ConvergenceModel.h"
#import "payTableViewController.h"


@interface VouchersViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;//优惠卡类型
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//优惠价
@property (weak, nonatomic) IBOutlet UILabel *pricesLabel;//原价
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;//下单
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//会所名字
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;//地址

@property (weak, nonatomic) IBOutlet UILabel *soldNumLabel;//已售
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//结束时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//使用时间
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotLabel;//提示
@property (strong,nonatomic)VouchersModel *model;
@property (strong,nonatomic)NSMutableArray *arr;
@end

@implementation VouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self uiLyout];
    [self netRequest];
    
    _arr = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

//网络请求
-(void)netRequest{
    NSString *eid = [[StorageMgr singletonStorageMgr]objectForKey:@"eId"];
//isKindOfClass:[NSNull class] ?@"-1" : [[StorageMgr singletonStorageMgr]objectForKey:@"eId"];
    
    NSDictionary *para = @{@"experienceId":eid};
    NSLog(@"para %@",para);
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        NSLog(@"体验卷 = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSLog(@"result = %@",result);
            _model = [[VouchersModel alloc]initWithDictionary:result];
            
            [_logoImg sd_setImageWithURL:[NSURL URLWithString:_model.eLogo] placeholderImage:[UIImage imageNamed:@"eLogo"]];
            _cardStyleLabel.text = _model.eName;
            _pricesLabel.text =[NSString stringWithFormat:@"原价:%ld元",(long)_model.orginPrice];
            _priceLabel.text = [NSString stringWithFormat:@"%ld元",_model.currentPrice];
            NSLog(@"_conver.orginPrice%ld",(long)_conver.orginPrice);
            //                _pricesLabel.text = model.currentPrice;
            _nameLabel.text =_conver.name;
            _ipLabel.text = _model.eAddress;
            //_ipLabel.text = model.eAddress;
            _beginTimeLabel.text = _model.beginDate;
            _endTimeLabel.text = _model.endDate;
            _ruleLabel.text = _model.rules;
            _promotLabel.text = _model.ePromot;
            _timeLabel.text = _model.useDate;
            _soldNumLabel.text = _model.saleCount;        }
        else {
            [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
        }

    } failure:^(NSInteger statusCode, NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}

//-(void)uiLyout{
//    [_logoImg sd_setImageWithURL:[NSURL URLWithString:_conver.logo] placeholderImage:[UIImage imageNamed:@"logo"]];
////    _ipLabel.text =
//    _cardStyleLabel.text = _conver.name;
//    _priceLabel.text = [NSString stringWithFormat:@"%ld元",(long)_conver.orginPrice];
//    _ipLabel.text = _conver.address;
//    _nameLabel.text = _conver.name;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        payTableViewController *pay = [Utilities getStoryboardInstance:@"Vouchers" byIdentity:@"Purchase"];
        pay.Vouch = _model;
        [self.navigationController pushViewController:pay animated:YES];
        
    }else{
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
    
    }
}
@end
