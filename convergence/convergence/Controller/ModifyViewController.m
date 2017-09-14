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

@end

@implementation ModifyViewController

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
    //设置导航条的文字
    self.navigationItem.title = @"修改昵称";
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
    UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    //[parameters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"]];
    NSDictionary *para = @{@"memberId":@([model.memberId integerValue]),@"name":_textField.text};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        NSLog(@"昵称：%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            
            
        }else{
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
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

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    [self ModifyRequest];
    [Utilities popUpAlertViewWithMsg:@"修改成功" andTitle:@"提示" onView:self];
}
@end
