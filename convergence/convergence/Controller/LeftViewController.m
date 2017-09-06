//
//  LeftViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "LeftViewController.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LeftViewController ()

@property (strong,nonatomic) NSArray *arr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self uiLayout];
    [self dataInitialize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //登录
        _LoginBtn.hidden = YES;
        _usernameLbl.hidden = NO;
        
        UserModel * user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        _usernameLbl.text = user.nickname;
        
        
    }else{
        //未登录
        _LoginBtn.hidden = NO;
        _usernameLbl.hidden = YES;
        
        _avatarImageView.image = [UIImage imageNamed:@"ic_user_head"];
        _usernameLbl.text = @"游客";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uiLayout{
    _avatarImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

-(void) dataInitialize{
    _arr = @[@"我的订单",@"我的推广",@"积分中心",@"关于我们",@"意见反馈"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _arr.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        cell.textLabel.text = _arr[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        return cell;
    }
    
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.f;
    }else{
        return UI_SCREEN_H - 500;
    }
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([Utilities loginCheck]) {
            switch (indexPath.row) {
                case 0:{
                    [self performSegueWithIdentifier:@"Let2MyAct" sender:self];
                }
                    break;
                case 1:{
                    
                }
                    break;
                case 2:{
                    
                }
                    break;
                case 3:{
                    
                }
                    break;
                case 4:{
                    
                }
                    break;
                default:
                    break;
            }
        }else{
            UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
            [self presentViewController:signNavi animated:YES completion:nil];
        }
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

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //获取要跳转过去的那个页面
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
    
    //创建一个navigationcontroller
    //UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:signNavi];
    //执行跳转//2.用某种方式跳转到上述页面（这里用modal方式跳转）
    [self presentViewController:signNavi animated:YES completion:nil];
    
    //(这里用push方式跳转）
    //[self.navigationController pushViewController:nc animated:YES];
}

- (IBAction)settingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if ([Utilities loginCheck]) {
        
    }else{
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"MyLogin" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
    }
}
@end
