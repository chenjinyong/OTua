//
//  MyOrderViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "UserModel.h"
@interface MyOrderViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger allorderPagNum;//判断是否是第一页
    NSInteger page;
    NSInteger perPage;
    BOOL totalPage;
}

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIActivityIndicatorView * aiv;

@property (strong,nonatomic) NSMutableArray *arr;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr = [NSMutableArray new];
    [self naviConfig];
    [self setRefreshControl];
    [self allorderRequest];
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
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mack -RefreshControl
//创建刷新指示器的方法
- (void)setRefreshControl{
    //以获取列表的刷新指示器
    UIRefreshControl * allorderRef = [UIRefreshControl new];
    [allorderRef addTarget:self action:@selector(allorderRef) forControlEvents:UIControlEventValueChanged];
    allorderRef.tag = 100;
    [_tableView addSubview:allorderRef];
}
//以获取列表的刷新
- (void)allorderRef{
    allorderPagNum = 1;
    [self allorderRequest];
    NSLog(@"刷新了一下");
}

//设置表格视图一共多少组{
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

////设置组的名字方式
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"订单号:";
//}

//设置当一个细胞将要出现的时候要做的事情
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    //判断是不是最后一行细胞即将出现
//    if (indexPath.section== _arr.count - 1) {
//        NSLog(@"jjjj%ld",(long)totalPage);
//        //判断还有没有下一页存在
//        if (totalPage) {
//            //在这里执行上拉翻页的数据操作
//            allorderPagNum ++;
//            [self allorderRequest];
//        }
//    }
//}
//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CardVoucherCell" forIndexPath:indexPath];
    orderModel * Order = _arr[indexPath.section];
    cell.couponLabel.text = Order.productName;
    cell.shopNameLabel.text = Order.clubName;
    cell.priceLabel.text = Order.donepay;
    //将http请求的字符串转为NSURL
    NSURL *url=[NSURL URLWithString:Order.imgUrl];
    [cell.CardImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image"]];
    return cell;

}

//细胞选中后调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击细胞后变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//设置组的名称（标题头节）
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    orderModel *ordermodel = _arr[section];
    //字符串拼接
    return [NSString stringWithFormat:@"订单号：%@",ordermodel.orderNum];
}

-(void)allorderRequest{
    //点击按钮的时候创建一个蒙层（菊花膜）并显示在当前页面（self.view）
    
    _aiv = [Utilities getCoverOnView:self.view];
    //参数
    
    UserModel *model = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    //[parameters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"]];
   NSDictionary *para = @{@"memberId":@([model.memberId integerValue]),@"type":@0};
    [RequestAPI requestURL:@"/orderController/orderList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject 订单:%@",responseObject);
        [_aiv stopAnimating];
        //UIRefreshControl *强制转换
        UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:100];
        [refresh endRefreshing];
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result= responseObject[@"result"];
            totalPage = [result[@"totalPage"] boolValue];
            NSLog(@"result =%@",result);
            NSArray * List = result[@"orderList"];
            NSLog(@"List = %@",List);
//            if (allorderPagNum == 1) {
//                [_arr removeAllObjects];
//            }
            for (NSDictionary *dict in List) {
                orderModel *ConModel = [[orderModel alloc]initWithDictionary:dict];
                //将上述实例化好的ConvergenceModel对象插入_arr数组
                [_arr addObject:ConModel];
            }
            [_tableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误," andTitle:@"提示" onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请求发生了错误," andTitle:@"提示" onView:self];
        
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

@end
