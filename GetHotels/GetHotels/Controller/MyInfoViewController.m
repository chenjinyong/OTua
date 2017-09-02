//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"

@interface MyInfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UITableView *MyInfoTableView;

//定义一个存放数据的数组
@property (strong,nonatomic) NSArray * myInfoArr;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self naviConfig];
    // Do any additional setup after loading the view.
     _myInfoArr = @[@{@"LeftIcon":@"酒店",@"TitleLabel":@"我的酒店"},@{@"LeftIcon":@"航空",@"TitleLabel":@"我的航空"},@{@"LeftIcon":@"信息",@"TitleLabel":@"我的消息"},@{@"LeftIcon":@"设置",@"TitleLabel":@"账户设置"},@{@"LeftIcon":@"协议",@"TitleLabel":@"使用协议"},@{@"LeftIcon":@"电话",@"TitleLabel":@"联系我们"}];
    
    //去除返回按钮上的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //登录
        _LoginBtn.hidden = YES;
        _nameLabel.hidden = NO;
        
        
    }else{
        //未登录
        _LoginBtn.hidden = NO;
        _nameLabel.hidden = YES;
        
        //_avatarImagrView.image = [UIImage imageNamed:@"Avatar"];
        //_nameLabel.text = @"小葵";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 145, 255);
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
}

//将要来到此页面（隐藏导航栏）
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - table view

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //去掉底部多余下划线
    self.MyInfoTableView.tableFooterView = [UIView new];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.LeftIcon.image = [UIImage imageNamed:dict[@"LeftIcon"]];
    cell.TitleLabel.text = dict[@"TitleLabel"];
    return cell;
}

//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 5.f;
    }
    return 1.f;
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
    if (![Utilities loginCheck] && indexPath.row == 0){
        [Utilities popUpAlertViewWithMsg:@"请先登录" andTitle:nil onView:self];
    } else {
        if (indexPath.section == 0){
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"MyInfoToOrder" sender:self];
                    break;
            }
        }
    }
}
//
- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Login" byIdentity:@"SignNavi"];
    
    //创建一个navigationcontroller
    //UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:signNavi];
    //执行跳转//2.用某种方式跳转到上述页面（这里用modal方式跳转）
    [self presentViewController:signNavi animated:YES completion:nil];
    
    //(这里用push方式跳转）
    //[self.navigationController pushViewController:nc animated:YES];
    
}
@end

















