//
//  FeedbackViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UserModel.h"

@interface FeedbackViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *FeedBackTextView;
- (IBAction)SubmitAction:(UIBarButtonItem *)sender;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    //[self Request];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 145, 255);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)backAction{
    //用model方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
    //用push方式返回上一页
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];                // 1
    [self.FeedBackTextView becomeFirstResponder];   // 2
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

-(void)Request{
    
    UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    NSDictionary *para = @{@"memberId":@([model.memberId integerValue]),@"message":_FeedBackTextView.text};

    [RequestAPI requestURL:@"/clubFeedback" withParameters:para andHeader:nil byMethod:kPost andSerializer:kRes success:^(id responseObject) {
        NSLog(@"反馈：%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            [Utilities popUpAlertViewWithMsg:@"提交成功" andTitle:@"提示" onView:self];
            
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，请稍候再试" andTitle:@"提示" onView:nil];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"statusCode%ld",(long)statusCode);
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

- (IBAction)SubmitAction:(UIBarButtonItem *)sender {
    [self Request];
    [Utilities popUpAlertViewWithMsg:@"提交成功" andTitle:@"提示" onView:self];

}
@end
