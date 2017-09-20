//
//  MyInfoViewController.m
//  convergence
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserModel.h"
#import "MyInfoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyInfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *MyInfoTableView;
- (IBAction)setUpAction:(UIBarButtonItem *)sender;
@property (strong,nonatomic)id result;
@property (strong,nonatomic)NSString *str;
//定义一个存放数据的数组
@property (strong,nonatomic) NSArray * myInfoArr;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myInfoArr = @[@{@"titleLabel":@"我的订单"},@{@"titleLabel":@"我的推广"},@{@"titleLabel":@"积分中心"},@{@"titleLabel":@"意见反馈"},@{@"titleLabel":@"关于我们"}];
    
    [self naviConfig];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //登录
        _LoginBtn.hidden = YES;
        _usernameLbl.hidden = NO;
        
        UserModel * user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_HeadImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        _usernameLbl.text = user.nickname;
        
        
    }else{
        //未登录
        _LoginBtn.hidden = NO;
        _usernameLbl.hidden = YES;
        
        _HeadImage.image = [UIImage imageNamed:@"ic_user_head"];
        _usernameLbl.text = @"游客";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 115, 255);
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
-(void)request{
    UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    [RequestAPI requestURL:@"/score/memberScore" withParameters:@{@"memberId":model.memberId} andHeader:nil byMethod:kGet andSerializer:kForm
        success:^(id responseObject){
//        NSLog(@"dhhhd %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            _result = responseObject[@"result"];
            
        }else{
            
        }
   
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
}
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
    cell.titleLabel.text = dict[@"titleLabel"];
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
    if (![Utilities loginCheck] && indexPath.row == 0){
        [Utilities popUpAlertViewWithMsg:@"请先登录" andTitle:nil onView:self];
    } else {
        //if (indexPath.section == 0) {
            
                switch (indexPath.section) {
                    case 0:
                        [self performSegueWithIdentifier:@"OrderToMyOrder" sender:self];
                        break;
                    case 1:
                        [self performSegueWithIdentifier:@"proToPromote" sender:self];
                        break;
                    case 2:
                        [self request];
                        if (_result != nil) {
                            _str = [NSString stringWithFormat:@"当前积分:%@",_result ];
                            [Utilities popUpAlertViewWithMsg:@"积分商城即将登录，准备好了吗，亲" andTitle:_str onView:self];
                        }
                        //[self performSegueWithIdentifier:@"123123" sender:self];
                        break;
                    case 3:
                        [self performSegueWithIdentifier:@"feedToBack" sender:self];
                        break;
                    case 4:
                        [self performSegueWithIdentifier:@"aboutToAbout" sender:self];
                        break;
                        
                        
                    default:
                        break;
                }
            
            
        //}
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

- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转过去的那个页面
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
    
    //创建一个navigationcontroller
    //UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:signNavi];
    //执行跳转//2.用某种方式跳转到上述页面（这里用modal方式跳转）
    [self presentViewController:signNavi animated:YES completion:nil];
    
    //(这里用push方式跳转）
    //[self.navigationController pushViewController:nc animated:YES];
}

- (IBAction)setUpAction:(UIBarButtonItem *)sender {
    if ([Utilities loginCheck]) {
        UINavigationController *setting = [Utilities getStoryboardInstance:@"setUp" byIdentity:@"Setting"];
        [self presentViewController:setting animated:YES completion:nil];
        }else{
            UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
            [self presentViewController:signNavi animated:YES completion:nil];
        }

}
@end








