//
//  SettingViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "SettingViewController.h"
#import "StetingTableViewCell.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
- (IBAction)ModifyPicture:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIView *ImgView;

//定义一个存放数据的数组
@property (strong,nonatomic) NSMutableArray * arr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_arr = @[@{@"nickLabel":@"昵称",@"userNameLabel":@""},@{@"nickLabel":@"性别",@"userNameLabel":@""},@{@"nickLabel":@"生日",@"userNameLabel":@""},@{@"nickLabel":@"身份证号码",@"userNameLabel":@""}];
    _arr = [NSMutableArray new];//可变数组必须初始化
    NSDictionary * dictA = @{@"nickLabel":@"昵称",@"userNameLabel":@""};
    NSDictionary * dictB = @{@"nickLabel":@"性别",@"userNameLabel":@""};
    NSDictionary * dictC = @{@"nickLabel":@"生日",@"userNameLabel":@""};
    NSDictionary * dictD = @{@"nickLabel":@"身份证号码",@"userNameLabel":@""};
    [_arr addObject:dictA];
    [_arr addObject:dictB];
    [_arr addObject:dictC];
    [_arr addObject:dictD];
    //数据重载
    [_settingTableView reloadData];
    
    [self naviConfig];
    //调用大脚方法
    [self setFootViewForTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 110, 255);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //去掉导航栏下面的空格
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)backAction{
    //用model方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
    //用push方式返回上一页
    //[self.navigationController popViewControllerAnimated:YES];
}

//将要来到此页面（隐藏导航栏）
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//多少组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _arr.count;
//}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StetingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    //去掉底部多余下划线
    self.settingTableView.tableFooterView = [UIView new];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _arr[indexPath.row];
    cell.nickLabel.text = dict[@"nickLabel"];
    cell.userNameLabel.text = dict[@"userNameLabel"];
    return cell;
}

//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击某行细胞变色
    //NSLog(@"%ld<<",(long)indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                switch (indexPath.row) {
                    case 0:
                       [self performSegueWithIdentifier:@"nickName" sender:self];
                        break;
//                    case 1:
//                        [self performSegueWithIdentifier:@"" sender:self];
//                        break;
//                    case 2:
//                        [self performSegueWithIdentifier:@"" sender:self];
//                        break;
//                    case 3:
//                        [self performSegueWithIdentifier:@"" sender:self];
//                        break;
//    
//    
                    default:
                        break;
               }
}

//设置大脚
- (void)setFootViewForTableView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 45)];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置按钮位置大小
    exitBtn.frame = CGRectMake(0, 5, UI_SCREEN_W, 40);
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    //使用常量包定义按钮标题字体颜色
    [exitBtn setTitleColor:UIColorFromRGB(221.f, 129.f, 116.f) forState:UIControlStateNormal];
    //给按钮添加事件
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    exitBtn.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:exitBtn];
    [_settingTableView setTableFooterView:view];
    
}

- (void)exitAction:(UIButton *)button{
    NSLog(@"点了");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self exit];
        
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exit{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//修改头像
- (IBAction)ModifyPicture:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
}
@end







