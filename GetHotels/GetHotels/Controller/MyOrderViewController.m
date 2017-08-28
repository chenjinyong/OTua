//
//  MyOrderViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"

@interface MyOrderViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (strong, nonatomic)HMSegmentedControl *segmentedControl;

@property (strong,nonatomic)NSMutableArray *MyOrderArr;

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
        //设置导航条的颜色(风格颜色)
        self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
        //设置导航条标题的颜色
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        //设置导航条是否隐藏
        self.navigationController.navigationBar.hidden = NO;
        //设置导航条上按钮的风格颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        //设置是否需要毛玻璃效果
        self.navigationController.navigationBar.translucent = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrder" forIndexPath:indexPath];
    //NSDictionary *dict = _MyOrderArr[indexPath.row];
    return cell;
}



@end








