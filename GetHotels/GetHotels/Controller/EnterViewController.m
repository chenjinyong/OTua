//
//  LoginViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "EnterViewController.h"
#import "EnterModel.h"


@interface EnterViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
- (IBAction)enterAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong,nonatomic) UIActivityIndicatorView * aiv;

@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    
    //阴影的颜色
    _imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    //阴影的透明度
    _imageView.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    _imageView.layer.shadowRadius = 4.f;
    //阴影偏移量
    _imageView.layer.shadowOffset = CGSizeMake(0,0);
    
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

//按键盘上的return键收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//按键盘外任意部位收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)uiLayout{
    //判断是否存在用户名记忆体
    if ([[Utilities getUserDefaults:@"Username" ]isKindOfClass:[NSNull class]]) {
        if ([Utilities getUserDefaults:@"Username"] != nil) {
            //将它显示在用户名输入框中
            _phoneText.text = [Utilities getUserDefaults:@"Username"];
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

- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)enterAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if (_phoneText.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    NSCharacterSet * notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([_phoneText.text rangeOfCharacterFromSet:notDigits].location != NSNotFound ) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    if (_pwdText.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self];
        return;
    }
    
        [self readyForencoding];
}



#pragma mack - resquest
//登录接口
- (void)readyForencoding{
    //点击按钮的时候创建一个蒙层（菊花膜）并显示在当前页面（self.view）
    _aiv = [Utilities getCoverOnView:self.view];
    //参数
    NSDictionary *para = @{@"tel":_phoneText.text,@"pwd":_pwdText.text};
    NSLog(@"%@",para);
    //网络请求
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //关闭蒙层（菊花膜）
        [_aiv stopAnimating];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary * result = responseObject[@"content"];
            EnterModel * user = [[EnterModel alloc] initWithDictionary:result];
            //将登陆获取到的用户信息打包存储到单例化全局变量中
            [[StorageMgr singletonStorageMgr] addKey:@"MemberInfo" andValue:user];
            //单独将用户的ID也存储到单例化全局变量来作为用户是否已经登陆的判断一句，同时也方便其他所有页面更快捷的使用用户Id这个参数
            [[StorageMgr singletonStorageMgr] addKey:@"MemberId" andValue:user.userId];
            //如果键盘还打开着就收回去
            [self.view endEditing:YES];
            //清空密码输入框里的内容
            _pwdText.text = @"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_phoneText.text];
            //用Model的方式返回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [_aiv stopAnimating];
            [Utilities popUpAlertViewWithMsg:responseObject[@"message"] andTitle:@"提示" onView:self];
            
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //NSLog(@"失败");
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍候再试" andTitle:@"提示" onView:self];
    }];
}

@end











