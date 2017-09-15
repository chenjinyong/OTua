//
//  ConvergenceViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ConvergenceViewController.h"
#import "ConTableViewCell.h"
#import "DetailViewController.h"
#import "VouchersViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"

#import <CoreLocation/CoreLocation.h>

@interface ConvergenceViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    NSInteger page;
    NSInteger perPage;
    NSInteger i;
    BOOL      firstVisit;
}
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *logoImg;



@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSMutableArray * arr;
@property (strong,nonatomic) NSMutableArray * brr;

@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;;


@end

@implementation ConvergenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uiLayout];
    [self dataInitialize];
    //
    
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
    
    //设置状态栏为白色
    UIApplication *app= [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    
//    //去除导航栏下方的横线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

//每次将要来到这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)uiLayout{
    _tableView.tableFooterView = [UIView new];
    [self refresh];
}

-(void)refresh{
    //初始化一个下拉刷新按钮
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]init];
    NSString *title = @"加载中...";
    //设置标题
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor grayColor], NSBackgroundColorAttributeName: [UIColor groupTableViewBackgroundColor] };
    NSAttributedString *attrTitle = [[NSAttributedString alloc]initWithString:title attributes:dic];
    refreshControl.attributedTitle = attrTitle;
    //设置刷新指示器的颜色
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户触发下拉事件执行的方法
    [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 11;
    //将下拉刷新控件添加到TableView中（在tableview中，下拉刷新控件会自动放置在表格视图的后侧位置） 就不用设置位置了
    [self.tableView addSubview:refreshControl];
}

- (void)dataInitialize {
    _arr = [NSMutableArray new];
    _brr = [NSMutableArray new];
    
    perPage = 10;
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshPage];
}

-(void)refreshPage{
    page = 1;
    [self networkRequest];
}


-(void)networkRequest{
    NSDictionary *para = @{@"city":@"无锡",@"jing":@120.333,@"wei":@31.57,@"page":@(page),@"perPage":@(perPage)};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"首页%@",responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:11];
        [refresh endRefreshing];
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            
            //NSArray *advertisement =responseObject[@"advertisement"];
            NSDictionary *result =responseObject[@"result"];
            NSArray * models =result[@"models"];
            NSArray *adver = responseObject[@"advertisement"];
            for(NSDictionary *Dict in adver){
                ConvergenceModel * Model = [[ConvergenceModel alloc]initWithDict:Dict];
                NSURL * url = [NSURL URLWithString:Model.imgurl];
                [_backImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"MineSelected"]];
            }
            
            
            for(NSDictionary * dict in models){
            ConvergenceModel * ConModel = [[ConvergenceModel alloc]initWithDict:dict];
                
                [_arr addObject:ConModel];
                
           }
            //NSArray *adver =responseObject[@"advertisement"];
            
            
            [_tableView reloadData];
    
        } else {
            [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此执行
        NSLog(@"statusCode=%ld",statusCode);
        [_aiv stopAnimating];
        UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:11];
        [refresh endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ConvergenceModel * conver = _arr[section];
    return conver.experience.count+1;
    
}
//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 240;
    }else{
        return 120.0f;
    }
    
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //体验劵详情页的跳转
    if (!(indexPath.row == 0)) {
        ConvergenceModel * home = _arr[indexPath.section];
        //判断当前tableView是否为_activityTableView（这个条件判断常用在一个页面中有多个taleView的时候）
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *array = home.experience;
        NSDictionary *dict = array[indexPath.row-1];
        NSString *eId =  dict[@"id"];
        NSLog(@"eId的值为：%@",eId);
        [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:eId];
    }
   
    
    
}


-(void)locationConfig{
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

- (void)enterApp{
    BOOL AppInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开APP
        AppInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //也说明是第一次打开APP
            AppInit = YES;
        }
        
    }
}

-(void)locationstart{
    //判断用户是否选择过是否使用定位
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        //询问用户是否愿意使用定位
        //判断用户使用的版本 （8.0以上）
#ifdef __IPHONE_8_0
        if([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            //使用“使用中打开定位”这个策略去运用定位功能
            [_locMgr requestWhenInUseAuthorization];
        }
#endif
    }
    //打开定位服务的开关（开始定位）
    [_locMgr startUpdatingLocation];
}

//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    // NSLog(@"纬度：%f",newLocation.coordinate.latitude);
    //NSLog(@"经度：%f",newLocation.coordinate.longitude);
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
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}

-(void)checkCityState:(NSNotification *)note{
    NSString * cityStr = note.object;
    
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
    
}

#pragma mark - table view


//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConvergenceModel * conver = _arr[indexPath.section];
    if (indexPath.row == 0) {
        ConvergenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
       

        
        NSURL * url = [NSURL URLWithString:conver.Image];
        [cell.logoImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"MineSelected"]];
        
        cell.ipLabel.text = conver.address;
        cell.nameLabel.text = conver.name;

        //计算距离
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[_model.distance doubleValue] longitude:[_model.distance doubleValue]];
        
        CLLocationDistance kilometers=[_location distanceFromLocation:location]/1000;
        cell.distanceLabel.text = [NSString stringWithFormat:@"距离我%.1f公里",kilometers];
        
        [_aiv stopAnimating];
        return cell;

    }else{
        NSArray * expArr = conver.experience;
        NSDictionary * dict = expArr[indexPath.row-1];
    ConTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        NSURL * url = [NSURL URLWithString:dict[@"logo"]];
        [cell.cardImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        cell.cardNameLabel.text = dict[@"name"];
       
        cell.volumeLabel.text = @"综合卷";
        cell.pricelabel.text = [NSString stringWithFormat:@"%@元",dict[@"orginPrice"]];
        cell.numLabel.text = [NSString stringWithFormat:@"已售：%@",dict[@"sellNumber"]];

        return cell;
    }
    
    
}

//当某一个跳转行为将要发生的时候
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List2Detail"]) {
        //当从列表也到详情页的这个跳转要发生的时候
        //1 获取要传递到下一页去的数据
        NSIndexPath *indexpath = [_tableView indexPathForSelectedRow];
        ConvergenceModel * activity = _arr[indexpath.section];
        //2获取下一页这个实例
        DetailViewController *detailVC = segue.destinationViewController;
        
        //3把数据给下一页预备好的接受容器
        detailVC.fitness = activity;
    }
    if ([segue.identifier isEqualToString:@"List2Vouchers"]) {
        
        //当从列表也到详情页的这个跳转要发生的时候
        //1 获取要传递到下一页去的数据
        NSIndexPath *indexpath = [_tableView indexPathForSelectedRow];
        ConvergenceModel * activity = _arr[indexpath.section];
        //2获取下一页这个实例
        VouchersViewController *detailVC = segue.destinationViewController;
        
        //3把数据给下一页预备好的接受容器
        detailVC.conver = activity;
    }

}
//这个方法处理网络请求完成后所有不同的动画终止
-(void)endAnimation{
    [_aiv stopAnimating];
}


@end
