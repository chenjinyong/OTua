//
//  PurchaseTableViewController.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "PurchaseTableViewController.h"

@interface PurchaseTableViewController ()
{
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong,nonatomic) NSArray * arr;
@end

@implementation PurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self naviConfig];
    [self uiLayout];
    [self dataInitalize];
    [self Lateralspreads];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
    self.tabBarController.tabBar.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)naviConfig{
    //设置导航条的文字
    self.navigationItem.title = @"活动报名支付";
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"支付" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(7, 121, 239);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    
    
}
//侧滑返回上一页
-(void)Lateralspreads{
    // 获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

-(void)uiLayout{
    _nameLabel.text = _activity.name;
    _contentLabel.text = _activity.content;
    _priceLabel.text = [NSString stringWithFormat:@"%@元",_activity.applyFee];
    //去掉多余下划线
    self.tableView.tableFooterView = [UIView new];
    //将表格试图设置为“编辑视图中”
    self.tableView.editing = YES;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表歌视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)dataInitalize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}

-(void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            NSString * tradeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_activity.name amount:_activity.applyFee tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@活动报名费",_activity.name] itBPay:@"30"];
        }
            
        default:
            break;
    }
}

-(void)purchaseResultAction:(NSNotification *)note{
    NSString * result = note.object;
    if ([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您，您成功完成报名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }else{
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"9000"]? @"未能支付成功，请账户余额充足": @"您已取消支付" andTitle:@"支付失败" onView:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _arr[indexPath.row];
    
    return cell;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

//设置组的名字方式
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"支付方式";
}

//按住细胞以后（取消选择）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != flag){
        flag = indexPath.row;
        //遍历表格视图中所有选中状态下的细胞
        for (NSIndexPath * eachIP in tableView.indexPathsForSelectedRows) {
            //当选中的细胞不是当前正在按的这个细胞的情况下
            if (eachIP != indexPath) {
                //将细胞从选中状态下改为不选中状态
                [tableView deselectRowAtIndexPath:eachIP animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == flag){
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
@end
