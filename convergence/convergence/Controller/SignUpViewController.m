//
//  SignUpViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "SignUpViewController.h"
#import "UserModel.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *conPwdText;
@property (weak, nonatomic) IBOutlet UITextField *VerBtn;
- (IBAction)VerAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)singUpAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *singUpBtn;
@property (strong,nonatomic) UIActivityIndicatorView * avi;

@end

@implementation SignUpViewController

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
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 110, 255);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)VerAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //点击按钮的时候创建一个蒙层，并显示在当前页面
    _avi = [Utilities getCoverOnView:self.view];
    
    //参数
    NSDictionary *para = @{@"userTel" : _userNameText.text,@"type" : @1};
    //网络请求
    [RequestAPI requestURL:@"/register/verificationCode" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"验证码 = %@",responseObject);
        //当网络请求成功时让蒙层消失
        [_avi stopAnimating];
        
        if([responseObject[@"resultFlag"]intValue] == 8001){
            
        }else {
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_avi stopAnimating];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

- (IBAction)singUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_userNameText.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    NSCharacterSet * notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([_userNameText.text rangeOfCharacterFromSet:notDigits].location != NSNotFound ) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    if (_nickNameText.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的昵称" andTitle:nil onView:self];
        return;
    }
    if (_pwdText.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self];
        return;
    }
    if (_pwdText.text.length < 6 || _pwdText.text.length >18) {
        [Utilities popUpAlertViewWithMsg:@"您输入的密码必须在6-18位之间" andTitle:nil onView:self];
        return;
    }
    if (_conPwdText.text.length == 0) {
        [Utilities popUpAlertViewWithMsg:@"请确认您的密码" andTitle:nil onView:self];
        return;
    }
    if (![_pwdText.text isEqualToString:_conPwdText.text]) {
        [Utilities popUpAlertViewWithMsg:@"密码输入不一致，请重新输入确认密码" andTitle:@"提示" onView:self];
        //  _pwdText.text = @"";
        _conPwdText.text = @"";
    }
    if ([_pwdText.text isEqualToString:_conPwdText.text]) {
        //无输入异常的情况下，开始正式登录接口
        [self readyForencoding];
        
    }
}
//注册接口
- (void)readyForencoding{
    _avi = [Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/register" withParameters:@{@"userTel":@7001,@"userPwd": [Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary * result = responseObject[@"result"];
            NSString * exponent = result[@"exponent"];
            NSString * modulus = result[@"modulus"];
            //对内容进行MD5加密
            NSString * md5Str = [_pwdText.text getMD5_32BitString];
            //用模数与指数对MD5加密过后的密码进行加密
            NSString * rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
            [self signInWithEncryptPwd:rsaStr];
            
        }else{
            [_avi stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

-(void)signInWithEncryptPwd:(NSString * )encryptPwd{
    [RequestAPI requestURL:@"/login" withParameters:@{@"userName": _userNameText.text,@"password": encryptPwd,@"userTel": @7001,@"userPwd":[Utilities uniqueVendor]} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        
        [_avi stopAnimating];
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary * result = responseObject[@"result"];
            UserModel *user = [[UserModel alloc] initWithDictionary:result];
            //将注册获取到的用户信息打包存储到单例化全局变量中
            [[StorageMgr singletonStorageMgr] addKey:@"MemberInfo" andValue:user];
            //单独将用户的ID也存储到单例化全局变量来作为用户是否已经登陆的判断一句，同时也方便其他所有页面更快捷的使用用户Id这个参数
            [[StorageMgr singletonStorageMgr] addKey:@"MemberId" andValue:user.memberId];
            //如果键盘还打开着就收回去
            [self.view endEditing:YES];
            //用Model的方式返回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络畅通" andTitle:nil onView:self];
        
    }];
}
@end
