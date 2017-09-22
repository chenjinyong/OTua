//
//  activityViewController.m
//  convergence
//
//  Created by admin on 2017/9/21.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "activityViewController.h"
#import "activityCell.h"
#import "ActivityModel.h"

@interface activityViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSInteger perPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) UIActivityIndicatorView * aiv;
@property (strong,nonatomic) NSMutableArray *arr;

@end

@implementation activityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr = [NSMutableArray new];
    [self naviConfig];
    [self Request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 110, 255);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小CGRectMake(0, 0, 20, 20)
    leftBtn.frame = CGRectMake(0, 0, 15, 25);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}


-(void)backAction{
    //用model方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
    //用push方式返回上一页
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mack request

-(void)Request{
    //点击按钮的时候创建一个蒙层（菊花膜）并显示在当前页面（self.view）
    _aiv = [Utilities getCoverOnView:self.view];
    perPage = 10;
    NSString *string = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"];
    NSDictionary *para = @{@"memberId":string,@"page":@(page),@"perPage":@(perPage)};
    
    [RequestAPI requestURL:@"/eventOrder/my" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_aiv stopAnimating];
//        NSLog(@"活动：%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result= responseObject[@"result"];
            NSArray * list = result[@"models"];
            for (NSDictionary *dict in list) {
                _activity = [[ActivityModel alloc] initWithDictionary:dict];
                //将上述实例化好的ConvergenceModel对象插入_arr数组
                [_arr addObject:_activity];
            }
            [_tableview reloadData];
        
        }else {
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误," andTitle:@"提示" onView:self];
        }

        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请求发生了错误," andTitle:@"提示" onView:self];
    }];
    
}

//设置表格视图一共多少组{
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    NSLog(@"个数是：%lu",(unsigned long)_arr.count);
    return _arr.count;
}

//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据某个具体名字找到改名字在页面上的对应的细胞
    activityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"activity" forIndexPath:indexPath];
    //去掉底部多余下划线
    self.tableview.tableFooterView = [UIView new];
    //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    ActivityModel * Order = _arr[indexPath.section];
    cell.activityLbl.text = Order.name;
    cell.LikeLbl.text = [NSString stringWithFormat:@"顶:%ld",(long)Order.like];
    cell.UnlikeLbl.text = [NSString stringWithFormat:@"踩:%ld",(long)Order.unlike];
    cell.addLbl.text = Order.address;
    
    //将http请求的字符串转为NSURL
    NSURL *url=[NSURL URLWithString:Order.imgURL];
    [cell.ImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
    
    return cell;
    
}

//细胞选中后调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击细胞后变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
