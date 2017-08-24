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
    
    //创一个加载图片图标，防止按钮被多次点击
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //参数是字典
    NSDictionary *para = @{@"username":_phoneText.text,@"password":_pwdText.text};
    NSLog(@"参数:%@",para);
    //网络请求 post   数据提交方式 kjson
    [RequestAPI requestURL:@"/api/session"  withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        //NSLog(@"登录成功:%@",responseObject);
        //网络请求成功，加载图标消失
        [aiv stopAnimating];
        
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            NSDictionary *result = responseObject[@"result"];
            NSString *token = result[@"token"];
            //把token存入单例化的全局变量当中
            //- 把自己实例化
            // StorageMgr *sto = [StorageMgr singletonStorageMgr];
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"token"];//防范式编程
            [[StorageMgr singletonStorageMgr] addKey:@"token" andValue:token];
            
            //把之前有相同的键都删掉去(相当于字典一样)
            [Utilities removeUserDefaults:@"username"];
            
            //客户的电话号码是否要加密处理根据接口返回的hidePhone判断，把hidePhone处理后存入到单例化的全局变量中，在其他有客户信息显示的页面上进行判断
            
            NSDictionary *agent = result[@"agent"];
            BOOL showPhone = [agent[@"hidePhone"]boolValue];
            [[StorageMgr singletonStorageMgr] removeObjectForKey:@"showPhone"];//防范式编程
            [[StorageMgr singletonStorageMgr] addKey:@"showPhone" andValue:@(showPhone)];
            //保留用户名
            [Utilities setUserDefaults:@"username" content:_phoneText.text];
            _pwdText.text= @"";
            [self performSegueWithIdentifier:@"loginToTask" sender:self];
        }
        else{
            [Utilities popUpAlertViewWithMsg:responseObject[@"message"] andTitle:@"提示" onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        
    }];
    
}
@end
