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
#import "ZLImageViewDisplayView.h"
#import "UserModel.h"

@interface ConvergenceViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    NSInteger page;
    NSInteger perPage;
    NSInteger i;
    BOOL      firstVisit;
    NSInteger totalPage;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *logoImg;

@property (weak, nonatomic) IBOutlet UIView *imgView;

@property (strong,nonatomic)UIImageView *img;
@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSMutableArray * arr;
@property (strong,nonatomic) NSMutableArray * brr;
@property (strong,nonatomic) NSMutableArray * imgArr;

@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;
@property (strong,nonatomic)UIImageView *imgview;

@end

@implementation ConvergenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uiLayout];
    [self enterApp];
    [self locationConfig];
    [self dataInitialize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(37, 139, 254);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = NO;
    
    //设置状态栏为白色
    UIApplication *app= [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //去掉tableView多余的线
    self.tableView.separatorStyle =NO;
    
    _imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_imgview];
    _imgview.layer.borderWidth = 1;
    _imgview.layer.cornerRadius = 12.5;
    _imgview.layer.borderColor = UIColorFromRGB(37, 139, 254).CGColor;
    _imgview.layer.masksToBounds = YES;
    [self addtapgestureRecognizer:self.imgview];
    //接收侧滑按钮被按的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHeadImg) name:@"changeHeadImg" object:nil];
}
//添加单击手势
-(void)addtapgestureRecognizer:(id)any{
    //初始化一个单击手势，设置响应的事件为tapclick
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [any addGestureRecognizer:tap];
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateRecognized ) {
        //发送注册按钮被按的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
    }
}
- (void)addZLImageViewDisPlayView:(NSArray *)imageArray{
    
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_W, 125);
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = _imgArr;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.7;
    [self.imgView addSubview:imageViewDisplay];
    
}

//每次将要来到这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)changeHeadImg{
    UserModel * user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    if (![Utilities loginCheck]) {
        //[_avatarImg setImage:[UIImage imageNamed:@"Location"]];
        [_imgview setImage:[UIImage imageNamed:@"ic_user"]];
    }
    else{
//        NSLog(@"图片 %@",user.avatarUrl);
        //NSString *imgurl = [NSString stringWithFormat:@"%@",user.avatarUrl];
        [_imgview sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
    }

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
    _imgArr = [NSMutableArray new];
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
    //duration表示从NOW开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(duration,dispatch_get_main_queue(),^{
        NSDictionary *para = @{@"city":@"无锡",@"jing":@(_location.coordinate.longitude),@"wei":@(_location.coordinate.latitude),@"page":@(page),@"perPage":@(perPage)};
        
        [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            
//            NSLog(@"首页%@",responseObject);
            [_aiv stopAnimating];
            UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:11];
            [refresh endRefreshing];
            if ([responseObject[@"resultFlag"] integerValue] == 8001) {
                
                NSArray * adv = responseObject[@"advertisement"];
                
                for(NSDictionary * advDict in adv){
                    
                    _imgArr[i] = advDict[@"imgurl"];
                    i++;
                }
//                NSLog(@"_advArr =%@",_imgArr);
                [self addZLImageViewDisPlayView:_imgArr];
                NSDictionary * result = responseObject[@"result"];
                NSArray * models = result[@"models"];
                NSDictionary *pagingInfo = result[@"pagingInfo"];
                totalPage = [pagingInfo[@"totalPage"]integerValue];
                if (page == 1) {
                    //清空数据
                    [_arr removeAllObjects];
                    
                }
                
                for(NSDictionary * dict in models){
                    ConvergenceModel * home = [[ConvergenceModel alloc]initWithSecondNSDictionary:dict];
                    
                    [_arr addObject:home];
                    
                }
                
                [_tableView reloadData];
                
            } else {
                [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
            }
        } failure:^(NSInteger statusCode, NSError *error) {
            //失败以后要做的事情在此执行
//            NSLog(@"statusCode=%ld",statusCode);
            [_aiv stopAnimating];
            UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:11];
            [refresh endRefreshing];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];

    });
                   
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
        return 215;
    }else{
        return 115;
    }
    
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ConvergenceModel * home = _arr[indexPath.section];
    NSString *Id =  [NSString stringWithFormat:@"%ld",home.clubId];
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:Id];
    //NSLog(@"id是：%@",Id);
    
    if(indexPath.row == 0){
        
        [self performSegueWithIdentifier:@"List2Detail" sender:nil];
    }else {
        NSArray *array = home.experience;
        NSDictionary *dict = array[indexPath.row-1];
        NSString *eId =  dict[@"id"];
        [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:eId];
        [self performSegueWithIdentifier:@"List2Vouchers" sender:nil];
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
    [self locationstart];
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
    //NSLog(@"纬度：%f",newLocation.coordinate.latitude);
    //NSLog(@"经度：%f",newLocation.coordinate.longitude);

    
    _location = newLocation;
    
   [[StorageMgr singletonStorageMgr]addKey:@"jindu" andValue:[ NSString stringWithFormat:@"%f",_location.coordinate.longitude]];
    [[StorageMgr singletonStorageMgr]addKey:@"weidu" andValue:[ NSString stringWithFormat:@"%f",_location.coordinate.latitude]];
    //[self dataInitialize];
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
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(duration,dispatch_get_main_queue(),^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(!error){
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
//                NSLog(@"locDict = %@",locDict);
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
       

        
        NSURL * url = [NSURL URLWithString:conver.clubimage];
        [cell.logoImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认图"]];
        
        cell.ipLabel.text = conver.clubaddress;
        cell.nameLabel.text = conver.clubname;
        
        
       
        cell.distanceLabel.text = [NSString stringWithFormat:@"%ld米",(long)conver.clubdis];
        
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
