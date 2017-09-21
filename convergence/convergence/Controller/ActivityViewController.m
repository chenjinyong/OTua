//
//  ActivityViewController.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"

#import "ActivityDetailViewController.h"
//#import "IssueViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    BOOL      isLoading;
    BOOL      firstVisit;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *arr;

- (IBAction)favorAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property(strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) UIImageView *zoomIV;
@property (strong,nonatomic) CLLocationManager *locMgr;
@property (strong,nonatomic) CLLocation *location;
- (IBAction)userAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *userImg;

- (IBAction)searchAction:(UIBarButtonItem *)sender;
- (IBAction)SwitchAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cityBrn;



@end

@implementation ActivityViewController
//第一次将要开始渲染这个页面的时候
-(void)awakeFromNib{
    [super awakeFromNib];
}
//第一次来到这个页面的时候
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self naviConfig];
    [self uiLayout];
    [self locationConfig];
    
    //[self performSelector:@selector(networkRequest) withObject:nil afterDelay:2];
    [self dataInitalize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    
}
//每次将要来到这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
    self.tabBarController.tabBar.hidden = NO;
    
}
//每次到达这个页面的时候
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
//每次将要离开这个页面的时候
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}
//每次离开了这个页面的时候
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //获取当前页面的导航控制器所维系的关于导航关系的数组 ,判断该数组中是否包含自己来得知当前操作是离开本页面还是退出本页面
    if(![self.navigationController.viewControllers containsObject:self]){
        //先释放故事板所有监听（包括：Action事件；protocol协议；gesture手势；Notication通知。。。。）
    }
}
//一旦退出这个页面的时候（并且所有的监听都已经全部被释放）
-(void)dealloc{
    //在这里释放所有内存（s设置为nil）
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//这个方法专门处理定位的基本设置
-(void)locationConfig{
    _locMgr = [CLLocationManager new];
    //    _location = [CLLocation new];
    //签协议
    _locMgr.delegate =self;
    //定位到的设备位移多少距离进行识别 距离决定于kCLLocationAccuracyBest的精确度
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
}

//这个方法处理开始定位
-(void)locationStart{
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
//专门做导航条的控制
-(void)naviConfig{
    //设置导航条的文字
    self.navigationItem.title = @"活动列表";
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
    
}
-(void)uiLayout{
    _tableView.tableFooterView = [UIView new];
    [self refresh];
}
-(void)refresh{
    //初始化一个下拉刷新按钮
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]init];
    refreshControl.tag=9478;
    NSString *title = @"加载中....";
    //设置标题
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor grayColor], NSBackgroundColorAttributeName: [UIColor groupTableViewBackgroundColor] };
    NSAttributedString *attrTitle = [[NSAttributedString alloc]initWithString:title attributes:dic];
    refreshControl.attributedTitle = attrTitle;
    //设置刷新指示器的颜色
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户触发下拉事件执行的方法
    [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到activityTableView中（在tableview中，下拉刷新控件会自动放置在表格视图的后侧位置） 就不用设置位置了
    [self.tableView addSubview:refreshControl];
}
//刷新数据
//- (void)refreshData:(UIRefreshControl *)sender{
//
//    [self performSelector:@selector(end) withObject:nil afterDelay:2];
//}
-(void)refreshPage{
    page = 1;
    [self networkRequest];
}
//刷完之后 结束收回根据下标tag获得子视图也就是refreshcontrol
-(void)end{
    UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:9478];
    [refresh endRefreshing];
}
//这个方法专门做数据的处理
-(void)dataInitalize{
    BOOL appInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNumber class]]) {
        //说明第一次打开App
        appInit =YES;
    }else{
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //也说明是第一次打开App
            appInit = YES;
        }
    }
    if (appInit) {
        //不是第一次来到APP将默认城市与记忆城市同步
        NSString *userCity = _cityBrn.titleLabel.text;
        [Utilities setUserDefaults:@"UserCity" content:userCity];
    }else{
        //不是第一次来到APP则将记忆城市与按钮上的城市反向同步
        NSString * userCity = [Utilities getUserDefaults:@"UserCity"];
        [_cityBrn setTitle:userCity forState:UIControlStateNormal];
    }
    
    firstVisit =YES;
    isLoading = NO;
    _arr = [NSMutableArray new];
    
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshPage];
    
}

//执行网络请求
-(void)networkRequest{
    
    perPage = 10;
    //  NSDictionary *dicA = @{@"name" : @"环太湖骑行",@"content" : @"从无锡滨湖区雪浪街道太湖边出发",@"like" : @80,@"unlike" : @9,@"imgURL" : @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A",@"isFavo" : @YES};
    //
    //     NSDictionary *dicB = @{@"name" : @"雪狼山骑马",@"content" : @"从无锡滨湖区雪浪街道太湖边出发",@"like" : @80,@"unlike" : @9,@"imgURL" : @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A",@"isFavo" : @YES};
    //     NSDictionary *dicC= @{@"name" : @"环电饭锅",@"content" : @"从无锡滨湖区雪浪街道太湖边出发",@"like" : @80,@"unlike" : @9,@"imgURL" : @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_3_2ADCF0CE-0A2F-46F0-869E-7E1BCAF455C1",@"isFavo" : @NO};
    
    //NSMutableArray *array=[NSMutableArray arrayWithObjects:dicA,dicB,dicC ,nil];
    //mutable数组会自动识别，存满一个会到下一个
    //    for (NSDictionary *dict in array)//for(int i=0,i<[arr count];i++)nsdictionary *dic  =arr[i]
    //    {
    //        //用acitivity类中定义的初始化方法initWithDictionary:建行遍历得来的字典dict转换成为activityModel对象
    //        activityModel *activitymodel = [[activityModel alloc]initWithDictionary:dict];
    //        //将上述实例化好的ActivityModel对象插入_arr数组
    //        [_arr addObject:activitymodel];
    //    }
    //  _arr = @[dicA,dicB,dicC];
    [_tableView reloadData];
    
    if (!isLoading) {
        isLoading = YES;
        //在这里开启一个真实的网络请求
        //设置接口地址
        NSString *request = @"/event/list";
        //设置接口入参
        NSDictionary *parameter = @{@"page" : @(page) , @"perPage" : @(perPage),@"city":_cityBrn.titleLabel.text};
        //
        [RequestAPI requestURL:request withParameters:parameter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            //成功以后要做的事情在此执行
//            NSLog(@"responseObject=%@",responseObject);
            [self endAnimation];
            if ([responseObject[@"resultFlag"] integerValue ] == 8001) {
                //业务逻辑成功的情况下
                NSDictionary *result = responseObject[@"result"];
                NSArray *models = result[@"models"];
                NSDictionary *pageinginfo = result [@"pagingInfo"];
                totalPage = [pageinginfo[@"totalPage"] integerValue];
                if (page == 1) {
                    [_arr removeAllObjects];
                }
                //清空数据
                
                for (NSDictionary *dict in models)
                    
                {
                    //用acitivity类中定义的初始化方法initWithDictionary:建行遍历得来的字典dict转换成为activityModel对象
                    ActivityModel *activitymodel = [[ActivityModel alloc]initWithDictionary:dict];
                    //将上述实例化好的ActivityModel对象插入_arr数组
                    [_arr addObject:activitymodel];
                }
                
                [_tableView reloadData];
            }
            else{
                //业务逻辑失败的情况下
                NSString *errMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue ]];
                [Utilities popUpAlertViewWithMsg:errMsg  andTitle:nil onView:self];
                
                
            }
            
        } failure:^(NSInteger statusCode, NSError *error) {
            //失败以后要做的事情在此执行
//            NSLog(@"statusCode=%ld",statusCode);
            [self endAnimation];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
        
    }
    
}
//这个方法处理网络请求完成后所有不同的动画终止
-(void)endAnimation{
    isLoading = NO;
    [_aiv stopAnimating];
    [self end];
}
//设置表格视图一共多少组{
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _arr.count;
}
//设置当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是不是最后一行细胞即将出现
    if (indexPath.row == _arr.count - 1) {
        //判断还有没有下一页存在
        if (page<totalPage) {
            //在这里执行上拉翻页的数据操作
            page ++;
            [self networkRequest];
        }
    }
    
    
}
//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据某个具体名字找到改名字在页面上的对应的细胞
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    ActivityModel *activity = _arr[indexPath.row];
    
    cell.activityNameLabel.text = activity.name;
    cell.activityInfoLabel.text = activity.content;
    cell.activityLikeLabel.text = [NSString stringWithFormat:@"顶:%ld",(long)activity.like];
    cell.activityUnlikeLabel.text = [NSString stringWithFormat:@"踩:%ld",(long)activity.unlike];
    //将http请求的字符串转为NSURL
    NSURL *url=[NSURL URLWithString:activity.imgURL];
    //依靠SDWebImage来异步的下载一张远程路径下的图片，并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
    [cell.activityImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image"]];
    
    //将url给nsdata；下载图片
    // NSData *data = [NSData dataWithContentsOfURL:url];
    //图片都是根据数据流来存取 的
    //cell.activityImageView.image = [UIImage imageWithData:data];
    //给每一行的收藏按钮打上下标，用来区分它是哪一行的按钮
   
    //给单元格添加长按手势
    [self longpress:cell];
    //给图片添加单击手势
    [self addtapgestureRecognizer:cell.activityImageView];
    
    
    return cell;
}
//添加长按手势事件
-(void)longpress:(UITableViewCell *)cell{
    //初始化一个长按手势，设置响应的事件为choose:
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
    //设置长按手势的时间间隔
    longpress.minimumPressDuration = 1.5;
    [cell addGestureRecognizer:longpress];
}

//长按手势响应时间
-(void)choose:(UILongPressGestureRecognizer *)longpress{
    //判断手势的状态（长按手势有时间间隔，对应的会有开始和结束两种状态）
    if (longpress.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"长按了!");
        //locationInView专门为手势服务
        CGPoint  location = [longpress locationInView:_tableView];
        //通过上述的点拿到_activityTableView对应的indexpath  确定你点的是哪一行细胞
        NSIndexPath *index = [_tableView indexPathForRowAtPoint:location];
        //防范式编程
        if (_arr != nil && _arr.count != 0) {
            //根据行号拿到数组中对应的数据
            ActivityModel *model =  _arr[index.row];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"复制操作" message:@"复制活动名称或内容" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"复制活动名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //创建复制板
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:model.name];
                NSLog(@"复制内容: %@",pasteboard.string);
            }];
            UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"复制活动内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:model.content];
//                NSLog(@"复制内容: %@",pasteboard.string);
                
                
            }];
            //一个弹出框只能有一个取消风格按钮
            UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            //            UIAlertAction *actionD = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            //            }];
            
            [alert addAction: actionA];
            [alert addAction: actionB];
            [alert addAction: actionC];
            //[alert addAction: actionD];
            [self  presentViewController:alert animated:YES completion:nil];
        }
        
        
    }
    
}
//添加单击手势
-(void)addtapgestureRecognizer:(id)any{
    //初始化一个单击手势，设置响应的事件为tapclick
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [any addGestureRecognizer:tap];
}
//单击手势响应事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateRecognized ) {
        
        
        //  NSLog(@"暴击");
        //locationInView专门为手势服务
        CGPoint  location = [tap locationInView:_tableView];
        //通过上述的点拿到_activityTableView对应的indexpath  确定你点的是哪一行细胞
        NSIndexPath *index = [_tableView indexPathForRowAtPoint:location];
        //防范式编程
        if (_arr != nil && _arr.count != 0) {
            //根据行号拿到数组中对应的数据
            ActivityModel *model =  _arr[index.row];
            //设置大图片的位置大小
            _zoomIV = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds ]];
            _zoomIV.userInteractionEnabled = YES;
            _zoomIV.backgroundColor = [UIColor blackColor];
            
            //将http请求的字符串转为NSURL
            NSURL *url=[NSURL URLWithString:model.imgURL];
            //依靠SDWebImage来异步的下载一张远程路径下的图片，并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
            [_zoomIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image"]];
            //三部获取图片资源
            //_zoomIV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgURL]]];
            //设置图片的内容模式
            _zoomIV.contentMode = UIViewContentModeScaleAspectFit;
            [[UIApplication sharedApplication].keyWindow addSubview:_zoomIV];
            //[self.view addSubview:_zoomIV];
            UITapGestureRecognizer *zoomtvtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomtap:)];
            [_zoomIV addGestureRecognizer:zoomtvtap];
            
        }
    }
}
//大图的单击手势响应事件
-(void)zoomtap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        //把大图本身的东西扔掉（大图的手势）
        [_zoomIV removeGestureRecognizer:tap];
        //把自己从父级视图中移除
        [_zoomIV removeFromSuperview];
        //彻底消失（不会造成内存的滥用）
        _zoomIV = nil;
    }
}
//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取三要素(计算文字高度的三要素)
    ActivityModel *model = _arr[indexPath.row];
    //1.文字内容
    NSString *activitycontent = model.content;
    //2.字体大小
    ActivityTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    UIFont *font = cell.activityInfoLabel.font;
    //3.宽度尺寸
    CGFloat  width = [UIScreen mainScreen].bounds.size.width -30;
    CGSize   size = CGSizeMake(width, 1000);
    //根据三元素计算尺寸
    CGFloat height = [activitycontent boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSForegroundColorAttributeName : font } context:nil].size.height ;
    //活动内容标签的原点y轴位置加上活动内容标签根据文字自适应大小后获得的高度+活动内容标签距离底部底部细胞的间距+10
    return cell.activityInfoLabel.frame.origin.y+height + 10;
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断当前tableview是否为_activityTableView（这个条件判断常用在一个页面中有多个tableView的时候）
    if ([tableView isEqual: _tableView]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (IBAction)favorAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_arr != nil && _arr.count !=0) {
        //通过按钮的下标值减去1拿到行号，在通过行号拿到对应的数据模型
        ActivityModel *activity = _arr[sender.tag - 1];
        NSString *message = activity.isFavo ? @"是否取消收藏活动" : @"是否收藏该活动";
        
        //创建弹出框，标题为@"提示"，内容为是否收藏
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        //创建取消按钮
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        //创建确定按钮
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (activity.isFavo) {
                activity.isFavo = NO;
            }
            else{
                activity.isFavo = YES;
                
            }
            [self.tableView reloadData];
        }];
        //将按钮添加到弹出框，（添加的顺序决定了按钮的排版，从左到右，从上到下，取消风格的按钮将会在最左边）
        
        [alert addAction:actionA];
        [alert addAction:actionB];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
    
    
}
//当某一个跳转行为将要发生的时候
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List2Detail"]) {
        //当从列表也到详情页的这个跳转要发生的时候
        //1 获取要传递到下一页去的数据
        NSIndexPath *indexpath = [_tableView indexPathForSelectedRow];
        ActivityModel * activity = _arr[indexpath.row];
        //2获取下一页这个实例
        ActivityDetailViewController *detailVC = segue.destinationViewController;
        
        //3把数据给下一页预备好的接受容器
        detailVC.activity = activity;
    }
}

- (IBAction)userAction:(UIBarButtonItem *)sender {
    //发送注册按钮被按的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
}

- (IBAction)searchAction:(UIBarButtonItem *)sender{
    //1.获得要跳转的页面的实例
    UINavigationController *searchVC = [Utilities getStoryboardInstance:@"Main" byIdentity:@"Issue"];
    
    //创建一个navigationcontroller
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:searchVC];
    //2.用某种方式跳转到上述页面（这里用modal方式跳转）
    [self presentViewController:nc animated:YES completion:nil];
    //(这里用push方式跳转）
    //[self.navigationController pushViewController:nc animated:YES];
    
}

- (IBAction)SwitchAction:(UIBarButtonItem *)sender{
    //发送注册按钮被按的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
}

- (IBAction)CityBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    
}



//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if(error){
        switch(error.code){
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
                break;
        }
    }
}

//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
//    NSLog(@"纬度：%f",newLocation.coordinate.latitude);
//    NSLog(@"经度：%f",newLocation.coordinate.longitude);
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
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
    dispatch_after(duration,dispatch_get_main_queue(),^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //方向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(!error){
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
//                NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length -1)];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"LocCity"];
                //
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                
                if (![cityStr isEqualToString:_cityBrn.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候去弹窗
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@，请问您是否需要切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityBrn setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择的城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新执行网络请求
                        [self networkRequest];
                    }];
                    UIAlertAction * noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
                
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}

-(void)checkCityState:(NSNotification *)note{
    NSString * cityStr = note.object;
    if (![cityStr isEqualToString:_cityBrn.titleLabel.text]) {
        //修改城市按钮标题
        [_cityBrn setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择的城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
        [self networkRequest];
    }
    
}


@end
