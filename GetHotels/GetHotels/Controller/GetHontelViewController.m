//
//  GetHontelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "GetHontelViewController.h"
#import "HontelTableViewCell.h"

@interface GetHontelViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImg;//位置图片
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;//位置
@property (weak, nonatomic) IBOutlet UITextField *searchText;//搜索
@property (weak, nonatomic) IBOutlet UILabel *temLabel;//温度
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UILabel *checkTimeLabel;//入住时间
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;//离店时间
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;//排序
@property (weak, nonatomic) IBOutlet UILabel *screeningLabel;//筛选

@property (strong,nonatomic) NSArray *arr;
@end

@implementation GetHontelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //为表格视图创建footer （该方法可以去除表格视图底部多余的下划线）
    _activityTableView.tableFooterView = [UIView new];
    _arr =  [NSMutableArray new];;
    [self naviConfig];
    [self networkRequest];
    
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
}

//执行网络请求
-(void)networkRequest{
    NSDictionary *dicA = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicB = @{@"hontelImg" : @"",@"hontelName" : @"无锡苏宁凯酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicC = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicD = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicE = @{@"hontelImg" : @"",@"hontelName" : @"无锡苏宁凯酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    NSDictionary *dicF = @{@"hontelImg" : @"",@"hontelName" : @"无锡万达喜来登酒店",@"distanceLabel" : @"100米",@"ip" : @"无锡",@"rmbLabel" :@"330"};
    _arr = @[dicA,dicB,dicC,dicD,dicE,dicF];
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}

#pragma mark - table view


//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HontelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HontelTableViewCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _arr[indexPath.row];
    cell.hontelImg.image = [UIImage imageNamed:@"aircraft"];
    cell.hontelName.text = dict[@"hontelName"];
    cell.distanceLabel.text = dict[@"distanceLabel"];
    cell.ip.text = dict[@"ip"];
    cell.rmbLabel.text = dict[@"rmbLabel"];
    return cell;
}

//设置每一组中每一行细胞的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    
    return 120;
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

////按键盘return收回按钮
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == _searchText)  {
//        [textField resignFirstResponder];
//    }
//    return YES;
//}

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

@end
