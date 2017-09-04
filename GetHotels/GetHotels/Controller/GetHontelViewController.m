//
//  GetHontelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "GetHontelViewController.h"
#import "HontelTableViewCell.h"
#import "GethontelModel.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "HontelBookingViewController.h"
@interface GetHontelViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIScrollViewDelegate>{
    BOOL      isLoading;
    NSInteger flag;
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL      firstVisit;
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger i;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;//
@property (weak, nonatomic) IBOutlet UIImageView *locationImg;//位置图片
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;//位置
- (IBAction)locationAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITextField *searchText;//搜索
@property (weak, nonatomic) IBOutlet UILabel *temLabel;//温度
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UIButton *checkTimeBtn;//入住时间
@property (weak, nonatomic) IBOutlet UIButton *leaveTimeBtn;//离店时间
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;//排序
@property (weak, nonatomic) IBOutlet UIButton *screeningBtn;//筛选
- (IBAction)checkAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)leaveAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)rankAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)screeningAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//定位
@property(strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSMutableArray *arr;
@property (strong,nonatomic) NSMutableArray *arr1;
@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic) NSInteger workingFrame;

//入店时间选择事件
@property (weak, nonatomic) IBOutlet UIToolbar *toobar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deteItem;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)deteAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;



@end

@implementation GetHontelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为白色
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleLightContent;
    
    firstVisit = YES;
    pageNum =1;
    pageSize = 5;
    page = 1;
    // Do any additional setup after loading the view.
    //为表格视图创建footer （该方法可以去除表格视图底部多余的下划线）
    _arr =  [NSMutableArray new];
    _arr1 =  [NSMutableArray new];


    [self naviConfig];
    [self networkRequest];
    [self locationConfig];
    [self enterApp];
    [self uiLayout];
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    
    [self addTimer];
    
    //去除返回按钮上的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//每次将要来到这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _timePicker.backgroundColor = [UIColor lightGrayColor];
    _toobar.backgroundColor = [UIColor lightGrayColor];
    _timePicker.hidden = YES;

    [self locationstart];
    
    
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
}


//

-(void)nextImage
 {
     // int page = (int)self.pageControl.currentPage;
     if (page == 3) {
         page = 0;
     }else{
        page++;
     }
     //滚动scrollview
     CGFloat x = page * self.scrollview.frame.size.width;
     self.scrollview.contentOffset = CGPointMake(x, 0);
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //开启定时器
    [self addTimer];
}
//开启定时器,设置图片多少秒跳转一次
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
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
    refreshControl.tag = 10001;
    //将下拉刷新控件添加到activityTableView中（在tableview中，下拉刷新控件会自动放置在表格视图的后侧位置） 就不用设置位置了
    [self.tableView addSubview:refreshControl];
}
-(void)refreshPage{
    page = 1;
    [self networkRequest];
}

////刷完之后 结束收回根据下标tag获得子视图也就是refreshcontrol
//-(void)end{
//    UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:1];
//    [refresh endRefreshing];
//}


//执行网络请求
-(void)networkRequest{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"yyyy-MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr= [formatter stringFromDate:dateTom];
    //参数
    NSDictionary *para = @{@"city_name" :@"无锡", @"pageNum" :@(pageNum), @"pageSize" :  @(pageSize), @"startId" :  @1, @"priceId" :@1, @"sortingId" :@1 ,@"inTime" : dateStr ,@"outTime" : dateTomStr,@"wxlongitude" :@"", @"wxlatitude" :@""};
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject)
     {
         
         NSLog(@"首页%@",responseObject);
         if ([responseObject[@"result"] integerValue] == 1)
         {
             UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:10001];
            [refresh endRefreshing];
             NSDictionary *content = responseObject[@"content"];
             NSArray *adv = content[@"advertising"];
             NSDictionary *hotel = content[@"hotel"];
             NSArray *list= hotel[@"list"];
             for (NSDictionary *img in adv)
             {
                 _arr[i] = img[@"ad_img"];
                 i++;
             }
             [_firstImg sd_setImageWithURL:[NSURL URLWithString:_arr[0]] placeholderImage:[UIImage imageNamed:@""]];
             [_secondImg sd_setImageWithURL:[NSURL URLWithString:_arr[2]] placeholderImage:[UIImage imageNamed:@""]];
             [_threeImg sd_setImageWithURL:[NSURL URLWithString:_arr[3]] placeholderImage:[UIImage imageNamed:@""]];
             [_fourImg sd_setImageWithURL:[NSURL URLWithString:_arr[4]] placeholderImage:[UIImage imageNamed:@""]];
             for (NSDictionary *dic in list) {
                 GethontelModel *model= [[GethontelModel alloc]initWithDict:dic];
                 [_arr1 addObject:model];
             }
             [_tableView reloadData];
            
         }
         else{
             [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
         }
     } failure:^(NSInteger statusCode, NSError *error)
     {
         //失败以后要做的事情在此执行
         NSLog(@"statusCode=%ld",statusCode);
         [self endAnimation];
         [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
     }];
    
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
        if (AppInit) {
            //第一次打开到APP将默认城市与记忆城市同步
            NSString *userCity = _locationBtn.titleLabel.text;
            [Utilities setUserDefaults:@"UserCity" content:userCity];
        }else {
            //不是第一次打开到APP将默认城市与按钮上的城市名反向同步
            NSString *userCity =[Utilities getUserDefaults:@"UserCity"];
            [_locationBtn setTitle:userCity forState:UIControlStateNormal];
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
    return _arr1.count;
    
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
    GethontelModel *model = _arr1[indexPath.row];
    cell.hontelName.text = model.hotel_name;
    cell.price.text = [NSString stringWithFormat:@"¥%ld",(long)model.Price];
    cell.hotel_address.text = model.hotel_address;
    
    //计算距离
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:[model.latitude doubleValue] longitude:[model.longitude doubleValue]];
    
    CLLocationDistance kilometers=[_location distanceFromLocation:otherLocation]/1000;
    cell.distance.text = [NSString stringWithFormat:@"距离我%.1f公里",kilometers];
    
    
    [_aiv stopAnimating];
    return cell;
}

//设置每一组中每一行细胞的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 100;
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



////按键盘return收回按钮
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == _searchText)  {
//        [textField resignFirstResponder];
//    }
//    return YES;
//}

//键盘收回
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"ToDetail"]) {
        
        NSIndexPath *indexpath = [_tableView indexPathForSelectedRow];
       
        GethontelModel *model = _arr1[indexpath.row];
        HontelBookingViewController *detailVc = [segue destinationViewController];
        detailVc.hotelid = model.hotelId;
        
        
    }
    // Pass the selected object to the new view controller.
}


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
                //
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_locationBtn.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候去弹窗
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@，请问您是否需要切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_locationBtn setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择的城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                    
                    }];
                    UIAlertAction * noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    [alertView addAction:noAction];
                    [alertView addAction:yesAction];
                    
                    [self presentViewController:alertView animated:YES completion:nil];
                }

                //修改城市按钮标题
                [_locationBtn setTitle:cityStr forState:UIControlStateNormal];
                _locationBtn.enabled = YES;
                
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}

-(void)checkCityState:(NSNotification *)note{
    NSString * cityStr = note.object;
    if (![cityStr isEqualToString:_locationBtn.titleLabel.text]) {
        //修改城市按钮标题
        [_locationBtn setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择的城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
      
    }
    
}

//入店时间选择事件
- (IBAction)checkAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
//    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, 320, 216)];//创建datePicker实例变量 并初始化
//    datePicker.backgroundColor = [UIColor grayColor];
    
    _toobar.hidden = NO;
    _timePicker.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
//离开时间选择事件
- (IBAction)leaveAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _toobar.hidden = NO;
    _timePicker.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
//时间取消事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toobar.hidden = YES;
    _timePicker.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
//时间确定事件
- (IBAction)deteAction:(UIBarButtonItem *)sender {
    NSDate *date = _timePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    if(flag == 0){
        
        formatter.dateFormat = @"入住MM-dd ▼";
        NSString *theDate = [formatter stringFromDate:date];
        
        [_checkTimeBtn setTitle:theDate forState:UIControlStateNormal];
    }else{
        formatter.dateFormat = @"离开MM-dd ▼";
        NSString *theDate = [formatter stringFromDate:date];
        
        [_leaveTimeBtn setTitle:theDate forState:UIControlStateNormal];
    }
    self.tabBarController.tabBar.hidden = NO;
    _toobar.hidden = YES;
    _timePicker.hidden = YES;
}



- (IBAction)rankAction:(UIButton *)sender forEvent:(UIEvent *)event {
    self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)screeningAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    self.tabBarController.tabBar.hidden = NO;
}


@end
