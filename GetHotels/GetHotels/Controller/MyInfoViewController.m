//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"

@interface MyInfoViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

//定义一个存放数据的数组
@property (strong,nonatomic) NSArray * myInfoArr;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _myInfoArr = @[@{@"LeftIcon":@"酒店",@"TitleLabel":@"我的酒店"},@{@"LeftIcon":@"航空",@"TitleLabel":@"我的航空"},@{@"LeftIcon":@"信息",@"TitleLabel":@"我的消息"},@{@"LeftIcon":@"设置",@"TitleLabel":@"账户设置"},@{@"LeftIcon":@"协议",@"TitleLabel":@"使用协议"},@{@"LeftIcon":@"电话",@"TitleLabel":@"联系我们"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//将要来到此页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

#pragma mark - table view

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.LeftIcon.image = [UIImage imageNamed:dict[@"LeftIcon"]];
    cell.TitleLabel.text = dict[@"TitleLabel"];
    return cell;
}

//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"MyInfoHotel" sender:self];
            break;
        default:
            break;
    }
    
}

@end


