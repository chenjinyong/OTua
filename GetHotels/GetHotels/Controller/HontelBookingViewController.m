//
//  HontelBookingHontelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HontelBookingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PrirceTableViewController.h"
//#import "HontelBookingModel.h"
//#import "GethontelModel.h"

@interface HontelBookingViewController (){
    NSInteger flag;
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
}

@property (weak, nonatomic) IBOutlet UIImageView *hontelImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *hontelbedLabel;//风格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
//@property (weak, nonatomic) IBOutlet UILabel *timeOneLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeTwoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bedImg;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *breakfastLabel;//是否含早点
@property (weak, nonatomic) IBOutlet UILabel *bedStylelabel;//床大小
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;//大小
@property (weak, nonatomic) IBOutlet UILabel *serviceA;//酒店设施/服务
@property (weak, nonatomic) IBOutlet UILabel *serviceB;
@property (weak, nonatomic) IBOutlet UILabel *serviceC;
@property (weak, nonatomic) IBOutlet UILabel *serviceD;
@property (weak, nonatomic) IBOutlet UILabel *policyA;//政策
@property (weak, nonatomic) IBOutlet UILabel *policyB;



@property (weak, nonatomic) IBOutlet UILabel *petLabel;

@property (weak, nonatomic) IBOutlet UIButton *contactBtn;//米聊
- (IBAction)contactAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;//购买

@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
- (IBAction)todayAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowBtn;
- (IBAction)tomorrowAction:(UIButton *)sender forEvent:(UIEvent *)event;



- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detaBtn;
- (IBAction)detaBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;



@property (strong,nonatomic) NSMutableArray *arr;
@end

@implementation HontelBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self networkRequest];
    [self naviConfig];
    
    _arr =  [NSMutableArray new];
    _toolbar.backgroundColor = [UIColor lightGrayColor];
    _picker.backgroundColor = [UIColor lightGrayColor];
    _picker.hidden = YES;
    _toolbar.hidden = YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(7, 121, 239);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    
    //去除返回按钮上的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)networkRequest{
    NSDictionary *dict = @{@"id" : @(_hotelid)};
    [RequestAPI requestURL:@"/findHotelById" withParameters:dict andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject1234= %@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1){
            NSLog(@"详情%@",responseObject);
            NSDictionary *content = responseObject[@"content"];
            NSDictionary *contents = responseObject[@"content"];
    
            _mod= [[GethontelModel alloc]initWithDict:content];
           HontelBookingModel *model= [[HontelBookingModel alloc]initWithDic:contents];
            
           [_hontelImg sd_setImageWithURL:[NSURL URLWithString:_HontelBooking.hotel_img] placeholderImage:[UIImage imageNamed:@"hotel_img"]];
            
           [_bedImg sd_setImageWithURL:[NSURL URLWithString:_HontelBooking.room_img] placeholderImage:[UIImage imageNamed:@"room_img"]];
        
 //           _hontelImg.image = model.hotel_img;
            _addressLabel.text = _mod.hotel_address;
            _hontelbedLabel.text = _mod.hotel_name;
            _priceLabel.text = [NSString stringWithFormat:@"¥%ld元",(long)_mod.Price];
//            _policyB.text = [Utilities dateStrFromCstampTime:_HontelBooking.out_time withDateFormat:@"HH:mm以后 "];
            
            NSArray *types = content[@"hotel_types"];
            for (int i = 0;i<types.count;i++ ) {
                _styleLabel.text =types[0];
                _breakfastLabel.text =types[1];
                _bedStylelabel.text =types[2];
                _sizeLabel.text =types[3];
                
            }
            
            
            NSArray *facilities = content[@"hotel_facilities"];
            for (int i = 0;i<facilities.count;i++ ) {
                _serviceA.text =facilities[0];
                _serviceB.text =facilities[1];
                _serviceC.text =facilities[2];
                _serviceD.text =facilities[3];
                
            }
            NSArray *policy = content[@"remarks"];
            for(int i = 0;i<policy.count;i++){
                _policyA.text = policy[0];
                _policyB.text = policy[1];
            }
            
//in_time          _policyA.text = model.remark;
            _petLabel.text = model.is_pet;
//            _sizeLabel.text = model.hotel_types;
            
 // is_pet   remark        _policyA.text = [Utilities dateStrFromCstampTime:_HontelBooking.start_time withDateFormat:@"HH:mm以前 "];

//            _timeOneLabel.text = [Utilities
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求失败" andTitle:@"提示" onView:self];
        }

    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此执行
        NSLog(@"statusCode=%ld",statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
   }

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // Get the new view controller using [segue destinationViewController].
}




- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        PrirceTableViewController * purchaseVC = [Utilities getStoryboardInstance:@"Hotel" byIdentity:@"Purchase"];
        purchaseVC.Hotel = _mod;
        [self.navigationController pushViewController:purchaseVC animated:YES];
        
    }else{
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Login" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
    }
    
}

- (IBAction)contactAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}


//今天时间选择事件
- (IBAction)todayAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
//    [_todayBtn setTitle:theDate forState:UIControlStateNormal];
    _toolbar.hidden = NO;
    _picker.hidden = NO;
}
//明天时间选择事件
- (IBAction)tomorrowAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _toolbar.hidden = NO;
    _picker.hidden = NO;
}
//取消时间按钮点击事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    
    _toolbar.hidden = YES;
    _picker.hidden = YES;
    
}

//确定时间按钮点击事件
- (IBAction)detaBtn:(UIBarButtonItem *)sender {
    NSDate *date = _picker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM月dd日";
    NSString *theDate = [formatter stringFromDate:date];
    if (flag == 0) {
        [_todayBtn setTitle:theDate forState:UIControlStateNormal];
        _todayBtn.titleLabel.text = theDate;
        [[StorageMgr singletonStorageMgr]addKey:@"today" andValue:_todayBtn.titleLabel.text];
    } else {
        [_tomorrowBtn setTitle:theDate forState:UIControlStateNormal];
        _tomorrowBtn.titleLabel.text = theDate;
        [[StorageMgr singletonStorageMgr] addKey:@"tomorrow" andValue:_tomorrowBtn.titleLabel.text];
    }
    _toolbar.hidden = YES;
    _picker.hidden = YES;
}
@end




