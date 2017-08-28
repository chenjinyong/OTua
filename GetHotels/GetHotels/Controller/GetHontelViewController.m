//
//  GetHontelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "GetHontelViewController.h"
#import "HontelTableViewCell.h"
#import "EnterModel.h"
#import <CoreLocation/CoreLocation.h>

@interface GetHontelViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    BOOL      isLoading;
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL      firstVisit;
}
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImg;//位置图片
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;//位置
- (IBAction)locationAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITextField *searchText;//搜索
@property (weak, nonatomic) IBOutlet UILabel *temLabel;//温度
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UILabel *checkTimeLabel;//入住时间
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;//离店时间
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;//排序
@property (weak, nonatomic) IBOutlet UILabel *screeningLabel;//筛选

//定位
@property(strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSArray *arr;
@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;


@property (nonatomic) NSInteger *workingFrame;
@end

@implementation GetHontelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //为表格视图创建footer （该方法可以去除表格视图底部多余的下划线）
    _activityTableView.tableFooterView = [UIView new];
    _arr =  [NSMutableArray new];
    [self naviConfig];
    [self networkRequest];
    
 //   [self loadPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}
-(void)uiLayout{
    if (![[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"]isKindOfClass:[NSNull class]]) {
        if ([[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"] != nil) {
            //已经获得了定位，将定位的城市显示在按钮上
            [_locationBtn setTitle:[[StorageMgr singletonStorageMgr] objectForKey:@"locationBtn"] forState:UIControlStateNormal];
            _locationBtn.enabled = YES;
            return;
        }
    }
    //当前还没有获取定位的情况下，去执行定位功能
    [self locationStart];
}

-(void)locationStart{
    //这个方法专门处理定位的基本设置
    
    _locMgr = [CLLocationManager new];
    //    _location = [CLLocation new];
    //签协议
    _locMgr.delegate =self;
    //定位到的设备位移多少距离进行识别 距离决定于kCLLocationAccuracyBest的精确度
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
}

//执行网络请求
-(void)networkRequest{
    NSDictionary *dicA = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicB = @{@"hontelImg" : @"",@"hontelName" : @"无锡苏宁凯酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicC = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicD = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicE = @{@"hontelImg" : @"",@"hontelName" : @"无锡苏宁凯酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicF = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    _arr = @[dicA,dicB,dicC,dicD,dicE,dicF];
    }

//这个方法处理网络请求完成后所有不同的动画终止
-(void)endAnimation{
    isLoading = NO;
    [_aiv stopAnimating];
}
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


#pragma mark - table view


//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HontelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HontelTableViewCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _arr[indexPath.row];
    cell.hontelImg.image = [UIImage imageNamed:@"hontel"];
    cell.hontelName.text = dict[@"hontelName"];
    cell.distanceLabel.text = dict[@"distanceLabel"];
    cell.ip.text = dict[@"ip"];
    cell.rmbLabel.text = dict[@"rmbLabel"];
    return cell;
}

//设置每一组中每一行细胞的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 120;
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}



////按键盘return收回按钮
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == _searchText)  {
//        [textField resignFirstResponder];
//    }
//    return YES;
//}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)locationAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //发送注册按钮被按的通知
    NSNotificationCenter * noteCenter = [NSNotificationCenter defaultCenter];
    //A=B
    //[notCenter  postNotificationName:@"ResetHome" object:nil];
    //B=A
    NSNotification * note = [NSNotification notificationWithName:@"ResetHome" object:[[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"]];
    //[noteCenter postNotification:note];
    //结合线程通知（表示先让通知接收者完成它收到通知后要做的事以后再执行别的任务）
    [noteCenter performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
    //返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}

//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"纬度：%f",newLocation.coordinate.latitude);
    NSLog(@"经度：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿到城市
    if(firstVisit){
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegeoViaCoordinate];
    }
}

//根据定位拿到城市
-(void)getRegeoViaCoordinate{
    //duration表示从NOW开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_after(duration,dispatch_get_main_queue(),^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(!error){
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length -1)];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"LocCity"];
                //
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                
                //修改城市按钮标题
                [_locationBtn setTitle:cityStr forState:UIControlStateNormal];
                _locationBtn.enabled = YES;
                
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}


@end
