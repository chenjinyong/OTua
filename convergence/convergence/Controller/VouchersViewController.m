//
//  VouchersViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "VouchersViewController.h"
#import "VouchersModel.h"

#import "payTableViewController.h"


@interface VouchersViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;//优惠卡类型
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//优惠价
@property (weak, nonatomic) IBOutlet UILabel *pricesLabel;//原价
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;//下单
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong,nonatomic) VouchersModel * voucher;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//会所名字
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;//地址

@property (weak, nonatomic) IBOutlet UILabel *soldNumLabel;//已售
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//结束时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//使用时间
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotLabel;//提示
- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event;



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
//    NSLog(@"para %@",para);
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        NSLog(@"体验卷 = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
//            NSLog(@"result = %@",result);
            _voucher = [[VouchersModel alloc]initWithDictionary:result];
            
            [_logoImg sd_setImageWithURL:[NSURL URLWithString:_voucher.eLogo] placeholderImage:[UIImage imageNamed:@"eLogo"]];
            _cardStyleLabel.text = _voucher.eName;
            _pricesLabel.text =[NSString stringWithFormat:@"原价:%ld元",(long)_voucher.orginPrice];
            _priceLabel.text = [NSString stringWithFormat:@"%ld元",_voucher.currentPrice];
//            NSLog(@"_conver.orginPrice%ld",(long)_conver.orginPrice);
            //                _pricesLabel.text = model.currentPrice;
            _nameLabel.text =_conver.clubname;
            _ipLabel.text = _voucher.eAddress;
            //_ipLabel.text = model.eAddress;
            _beginTimeLabel.text = _voucher.beginDate;
            _endTimeLabel.text = _voucher.endDate;
            _ruleLabel.text = _voucher.rules;
            _promotLabel.text = _voucher.ePromot;
            _timeLabel.text = _voucher.useDate;
            _soldNumLabel.text = _voucher.saleCount;
            [_arr addObject:_voucher];
        }
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
        pay.Vouch = _voucher;
        [self.navigationController pushViewController:pay animated:YES];
        
    }else{
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
    
    }
}

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *string = _voucher.clubTel;
    _arr =  [string componentsSeparatedByString:@","];
    // NSLog(@"数组里的是：%@",_arr);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  NSLog(@"点了第一个");
        // NSLog(@"%@",_arr[0]);
        //配置电话APP的路径，并将要拨打的号码组合到路径中
        NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[0]];
        
        UIWebView *callWebview =[[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        
        
    }];
    [alertController addAction:callAction];
    // }
    if(_arr.count == 2)
    {
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // NSLog(@"点了第二个");
            // NSLog(@"%@",_arr[1]);
            //配置电话APP的路径，并将要拨打的号码组合到路径中
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[1]];
            
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
            
        }];
        [alertController addAction:callAction];
        
    }
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    //  [alertController addAction:callAction];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)mapAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_voucher.longitude];
//    NSLog(@"%@",_voucher.longitude);
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_voucher.latitude];
    
}
@end
