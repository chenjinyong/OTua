//
//  SettingViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "SettingViewController.h"
#import "StetingTableViewCell.h"
#import "UserModel.h"
#import "JSONS.h"
@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
- (IBAction)ModifyPicture:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (weak, nonatomic) IBOutlet UIView *ImgView;

//定义一个存放数据的数组
@property (strong,nonatomic) NSArray * arr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // _arr = [NSMutableArray new];//可变数组必须初始化

    _arr = @[@"昵称",@"性别",@"生日",@"身份证号码"];
    
    
    [self naviConfig];
    //调用大脚方法
    [self setFootViewForTableView];
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
    //去掉导航栏下面的空格
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
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

//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self updateInfo];
}
-(void)updateInfo{
   // UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
   // NSDictionary *para = @{@"memberId":model.memberId,@"name":model.nickname,@"birthday":model.dob,@"gender":model.gender,@"identificationcard":model.idCardNo};
    //将字符串转换成NSURL对象
    NSURL *weatherURL = [NSURL URLWithString:@"http://club.fisheep.com.cn/mySelfController/updateMyselfInfos"];
    //初始化单例化的NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建一个基于NSURLSession的请求（除了请求任务还有上传和下载任务可以选择）任务并处理完成后的回调
    NSURLSessionDataTask *jsonDataTask = [session dataTaskWithURL:weatherURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"请求完成，开始做事");
        if (!error) {
            NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
            if (httpRes.statusCode == 200) {
                NSLog(@"网络请求成功，真的开始做事");
                //将JSON格式的数据流data用JSONS工具包里的NSData下的Category中的JSONCol方法转化为OC对象（Array或Dictionary）
                id jsonObject = [data JSONCol];
                NSLog(@"%@", jsonObject);
            } else {
                NSLog(@"%ld", (long)httpRes.statusCode);
            }
        } else {
            NSLog(@"%@", error.description);
        }
    }];
    //让任务开始执行
    [jsonDataTask resume];
}
//    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
//        NSLog(@"dddd %@",responseObject);
//        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
//            
//            
//        }else{
//            
//        }
//
//    } failure:^(NSInteger statusCode, NSError *error) {
//        NSLog(@"%@,%ld",error,(long)statusCode);
//    }];

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    //去掉底部多余下划线
    self.settingTableView.tableFooterView = [UIView new];
    UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    //根据行号拿到数组中对应的数据
   // NSDictionary *dict = _arr[indexPath.row];
//    cell.nickLabel.text = dict[@"nickLabel"];
//    cell.userNameLabel.text = dict[@"userNameLabel"];
    cell.textLabel.text = _arr[indexPath.section];
    if (indexPath.section == 0) {
        cell.detailTextLabel.text =model.nickname;
    }
    if (indexPath.section == 1) {
        cell.detailTextLabel.text = model.gender;
        
    }
    if (indexPath.section == 2 ){
        cell.detailTextLabel.text = model.dob;
        
    }
    if (indexPath.section == 3) {
        cell.detailTextLabel.text = model.idCardNo;
        
    }
    NSURL *url = [NSURL URLWithString:model.avatarUrl];
    [_UserImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
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
                switch (indexPath.section) {
                    case 0:
                       [self performSegueWithIdentifier:@"nickName" sender:self];
                        break;
//                    case 1:
//                        [self performSegueWithIdentifier:@"" sender:self];
//                        break;
//                    case 2:
//                        [self performSegueWithIdentifier:@"" sender:self];
//                        break;
//                    case 3:
//                        [self performSegueWithIdentifier:@"" sender:self];
//                        break;
    
    
                    default:
                        break;
               }
}

//设置大脚
- (void)setFootViewForTableView{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 45)];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置按钮位置大小
    exitBtn.frame = CGRectMake(0, UI_SCREEN_H/ 5 * 3, UI_SCREEN_W, 40);
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    //使用常量包定义按钮标题字体颜色
    [exitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //给按钮添加事件
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    exitBtn.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:exitBtn];
//    [_settingTableView setTableFooterView:view];
    
}

- (void)exitAction:(UIButton *)button{
    NSLog(@"点了");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self exit];
        
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exit{
    [[StorageMgr singletonStorageMgr] removeObjectForKey:@"MemberId"];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"changeHeadImg" object:nil]; 
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//修改头像
- (IBAction)ModifyPicture:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
}
@end







