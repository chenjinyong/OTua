//
//  ModifyViewController.m
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ModifyViewController.h"
#import "UserModel.h"

@interface ModifyViewController ()
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong,nonatomic) UIActivityIndicatorView * aiv;
//@property(strong,nonatomic) UserModel * User;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _User = [[StorageMgr singletonStorageMgr] objectForKey:@"MemberInfo"];
    [self naviConfig];
    [self setTextFieldLeftPadding:_textField forWidth:15];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的文字
    self.navigationItem.title = @"修改昵称";
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 110, 255);
    //为导航条右上角创建一个按钮
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Sava" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];                // 1
    [self.textField becomeFirstResponder];   // 2
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

//键盘收回
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

-(void)ModifyRequest{
    NSString * nc  = _textField.text;
    UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
     _aiv=[Utilities getCoverOnView:self.view];
    //[parameters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"]];
    NSDictionary *para = @{@"memberId":@([model.memberId integerValue]),@"name":nc};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        NSLog(@"昵称：%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSNotification *note = [NSNotification notificationWithName:@"refresh" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            
            [Utilities popUpAlertViewWithMsg:@"修改成功" andTitle:@"提示" onView:self];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:nil];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍候再试" andTitle:@"提示" onView:nil];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    [self ModifyRequest];
    
//    [Utilities popUpAlertViewWithMsg:@"修改成功" andTitle:@"提示" onView:self];
}
@end
