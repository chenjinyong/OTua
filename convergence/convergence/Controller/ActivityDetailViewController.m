//
//  ActivityDetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PurchaseTableViewController.h"

@interface ActivityDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *applyFeeLbl;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *attendenceLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDueview;
@property (weak, nonatomic) IBOutlet UIView *applyingView;
@property (weak, nonatomic) IBOutlet UIView *applyendView;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self networkRequest];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    //设置导航条的文字
    self.navigationItem.title = _activity.name;
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}

-(void)networkRequest{
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    NSString *request = [NSString stringWithFormat:@"/event/%@",_activity.activityId];
    NSLog(@"%@",request);
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if([Utilities loginCheck]){
        [parameters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"]forKey:@"memberId"];
    }
    [RequestAPI requestURL:request withParameters:parameters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        [aiv stopAnimating];
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            _activity = [[ActivityModel alloc]initWithDetailDictionary:result];
            [self uiLyout];
            
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//添加单击手势
-(void)addtapgestureRecognizer:(id)any{
    //初始化一个单击手势，设置响应的事件为tapclick
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [any addGestureRecognizer:tap];
}

-(void)uiLyout{
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:_activity.imgURL] placeholderImage:[UIImage imageNamed:@"image"]];
    
    [self addtapgestureRecognizer:_activityImgView];
    
    _applyFeeLbl.text = [NSString stringWithFormat:@"%@元",_activity.applyFee];
    _attendenceLbl.text = [NSString stringWithFormat:@"%@/%@",_activity.attendence,_activity.limitation];
    _typeLbl.text = _activity.type;
    _issuerLbl.text = _activity.issuer;
    _addressLbl.text = _activity.address;
    _contentLbl.text = _activity.content;
    
    [_phoneBtn setTitle:[NSString stringWithFormat:@"联系活动发布者:%@",_activity.phone] forState:UIControlStateNormal];
    NSString * dueTimeStr = [Utilities dateStrFromCstampTime:_activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * startTimeStr = [Utilities dateStrFromCstampTime:_activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * endTimeStr = [Utilities dateStrFromCstampTime:_activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text = [NSString stringWithFormat:@"%@ ~ %@",startTimeStr,endTimeStr];
    _applyDueLbl.text = [NSString stringWithFormat:@"报名截止时间 (%@) ",dueTimeStr];
    
//    NSDate * now = [NSDate date];
//    //NSTimeInterval nowTime = [NSDate dateWithTimeIntervalSince1970:now];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSString *nsns = [formatter stringFromDate:now];
//    NSLog( @"当前时间：%@",nsns);
    NSDate * now = [NSDate date];
    NSTimeInterval nowTime = [now timeIntervalSince1970InMilliSecond];
    _applyStartView.backgroundColor = [UIColor grayColor];
    if (nowTime >= _activity.dueTime) {
        _applyDueview.backgroundColor = [UIColor grayColor];
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if (nowTime >= _activity.startTime) {
            _applyingView.backgroundColor = [UIColor grayColor];
            if (nowTime >= _activity.endTime) {
                _applyendView.backgroundColor = [UIColor grayColor];
            }
        }
    }
    if (_activity.attendence >= _activity.limitation) {
        _applyBtn.enabled = NO;
        [_applyBtn setTitle:@"活动满员" forState:UIControlStateNormal];
    }
    switch (_activity.status) {
        case 0:{
            _applyStateLbl.text = @"已取消";
        }
            break;
        case 1:{
            _applyStateLbl.text = @"待付款";
            [_applyBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            _applyStateLbl.text = @"已报名";
            [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
            break;
        case 3:{
            _applyStateLbl.text = @"退款中";
            [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
            break;
        case 4:{
            _applyStateLbl.text = @"已退款";
        }
            break;
            
        default:{
            _applyStateLbl.text = @"待报名";
        }
            break;
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        PurchaseTableViewController * purchaseVC = [Utilities getStoryboardInstance:@"Main" byIdentity:@"Purchase"];
        purchaseVC.activity = _activity;
        [self.navigationController pushViewController:purchaseVC animated:YES];
        
    }else{
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
    }
    

}
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //配置电话APP的路径，并将要拨打的号码组合到路径当中
    NSString * targetAPPStr = [NSString stringWithFormat:@"telprompt://%@",_activity.phone];
    
    NSURL * targetAPPUrl = [NSURL URLWithString:targetAPPStr];
    //从当前APP跳转到其他指定的APP中
    [[UIApplication sharedApplication] openURL:targetAPPUrl];
    
    
}
@end
