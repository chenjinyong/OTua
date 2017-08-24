//
//  LoginViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *firstPswText;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    //用push方式返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}


//自定义的返回按钮的事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

//当textfield结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //当密码和确认密码都输入了之后，按钮才能被点击
    if (textField == _firstPswText || textField == _secondPwdText || textField ) {
        if (_firstPswText.text.length != 0 && _secondPwdText.text.length != 0) {
            _secondPwdText.enabled = YES;
        }
    }
}

//按键盘return收回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _firstPswText || textField == _secondPwdText)  {
        [textField resignFirstResponder];
    }
    return YES;
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    if ([_firstPswText.text isEqualToString:_secondPwdText.text]) {
        //回到登录页面,释放全部页面
        [self dismissViewControllerAnimated:YES completion:nil];
        [aiv stopAnimating];
    } else {
        [Utilities popUpAlertViewWithMsg:@"密码输入不一致，请重新输入" andTitle:@"提示" onView:self];
            //_firstPswText.text = @"";
            _secondPwdText.text = @"";
        [aiv stopAnimating];
    }
}

@end
