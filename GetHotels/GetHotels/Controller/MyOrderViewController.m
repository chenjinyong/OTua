//
//  MyOrderViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "EnterModel.h"

@interface MyOrderViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger allorderPagNum;//判断是否是第一页
}

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *allorderTableView;

@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (strong,nonatomic)NSMutableArray *MyOrderArr;

@property (strong,nonatomic) UIActivityIndicatorView * aiv;

@property ( nonatomic)CGRect rectStatus;
@property ( nonatomic)CGRect rectNav;

@end

@implementation MyOrderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //状态栏(statusbar)
    _rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    _rectNav = self.navigationController.navigationBar.frame;
    
    
    [self naviConfig];
    [self setSegment];//设置菜单栏
    [self allorderRequest];
    
    //去除返回按钮上的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
        //设置导航条的颜色(风格颜色)
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 145, 255);
        //设置导航条标题的颜色
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        //设置导航条是否隐藏
        self.navigationController.navigationBar.hidden = NO;
        //设置导航条上按钮的风格颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        //设置是否需要毛玻璃效果
        self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
//将要来到此页面（隐藏导航栏）
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

#pragma  mark -  setSegment
//设置菜单栏的方法
- (void)setSegment{
    //用标题实例化一个HMSegmentedControl
    _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
    //设置segmentedControl的位置大小CGRectMake(0, _headbackView.frame.size.height, UI_SCREEN_W, 40);
    //
    _segmentedControl.frame = CGRectMake(0,_rectStatus.size.height + _rectNav.size.height, UI_SCREEN_W, 40);
    //设置segmentedControl的默认选中的项
    _segmentedControl.selectedSegmentIndex = 0;
    //segmentedControl的背景色
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    //设置下划线的高度（当被选中时会出现）
    _segmentedControl.selectionIndicatorHeight = 2.5f;
    //设置选中状态样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //设置选中时的标记位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(230, 230, 230, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f ]};
    //设置选中时的标题样式
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(154, 154, 154, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f ]};
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.ScrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    [self.view addSubview:_segmentedControl];
    
}

#pragma mack -RefreshControl
//创建刷新指示器的方法
- (void)setRefreshControl{
    //以获取列表的刷新指示器
    UIRefreshControl * allorderRef = [UIRefreshControl new];
    [allorderRef addTarget:self action:@selector(allorderRef) forControlEvents:UIControlEventValueChanged];
    allorderRef.tag = 10001;
    [_allorderTableView addSubview:allorderRef];
}
//以获取列表的刷新
- (void)allorderRef{
    allorderPagNum = 1;
    [self allorderRequest];
    NSLog(@"刷新了一下");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//多少组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _myOrderArr.count;
//}

//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断当前tableview是否为_activityTableView（这个条件判断常用在一个页面中有多个tableView的时候）
    if ([tableView isEqual: _allorderTableView]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrder" forIndexPath:indexPath];
    //NSDictionary *dict = _MyOrderArr[indexPath.row];
    self.allorderTableView.tableFooterView = [UIView new];
    return cell;
}

#pragma mack - resquest
//酒店请求
- (void)allorderRequest{
    //点击按钮的时候创建一个蒙层（菊花膜）并显示在当前页面（self.view）
    _aiv = [Utilities getCoverOnView:self.view];
    EnterModel * model = [[StorageMgr singletonStorageMgr]objectForKey: @"MemberInfo"];
    //参数
    NSDictionary *para = @{@"openid":model.openid,@"id":@1};
    //NSLog(@"%@",para);
    //网络请求
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //关闭蒙层（菊花膜）
        [_aiv stopAnimating];
        NSLog(@"%@",responseObject);
        UIRefreshControl * ref = (UIRefreshControl *)[_allorderTableView viewWithTag:100];
        [ref endRefreshing];
        if ([responseObject[@"result"] integerValue] == 1) {
            //NSDictionary * result = responseObject[@"content"];
            
            
            //用Model的方式返回上一页
            //[self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [_aiv stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
//        //NSLog(@"失败");
//        [_aiv stopAnimating];
//        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍候再试" andTitle:@"提示" onView:self];
    }];
}



@end








