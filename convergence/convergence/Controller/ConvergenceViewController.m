//
//  ConvergenceViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ConvergenceViewController.h"
#import "ConTableViewCell.h"
#import "DetailViewController.h"
#import "VouchersViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ConvergenceViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page;
    NSInteger perPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSMutableArray * arr;
@property (strong,nonatomic) NSMutableArray * brr;

@property (strong,nonatomic) CLLocation *location;


@end

@implementation ConvergenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self networkRequest];
    _arr = [NSMutableArray new];
    _brr = [NSMutableArray new];
    
    page = 1;
    perPage = 10;
    
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];
    
    [self uiLayout];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
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

//每次将要来到这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)uiLayout{
    _tableView.tableFooterView = [UIView new];
    [self refresh];
}

-(void)refresh{
    //初始化一个下拉刷新按钮
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]init];
    NSString *title = @"加载中...";
    //设置标题
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor grayColor], NSBackgroundColorAttributeName: [UIColor groupTableViewBackgroundColor] };
    NSAttributedString *attrTitle = [[NSAttributedString alloc]initWithString:title attributes:dic];
    refreshControl.attributedTitle = attrTitle;
    //设置刷新指示器的颜色
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户触发下拉事件执行的方法
    [refreshControl addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 11;
    //将下拉刷新控件添加到TableView中（在tableview中，下拉刷新控件会自动放置在表格视图的后侧位置） 就不用设置位置了
    [self.tableView addSubview:refreshControl];
}

-(void)refreshPage{
    page = 1;
    [self networkRequest];
}


-(void)networkRequest{
    NSDictionary *para = @{@"city":@"0510",@"jing":@1,@"wei":@1,@"page":@(page),@"perPage":@(perPage)};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //        NSDictionary *content = responseObject[@"content"];
        //
        //        _model= [[ConvergenceModel alloc]initWithDict:content];
        
        //NSLog(@"首页%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001)
        {
            
            //NSArray *advertisement =responseObject[@"advertisement"];
            NSDictionary *result =responseObject[@ "result"];
 //           NSLog(@"rrrrr = %@",result);
            NSArray * exper =result[@"models"];
            NSLog(@"eeeee = %@",exper);
            for (NSDictionary *dict in exper)
            {
                //用ConvergenceModel类中定义的初始化方法initWithDict:建行遍历得来的字典dict转换成为activityModel对象
                ConvergenceModel *ConModel = [[ConvergenceModel alloc]initWithDict:dict];
                //将上述实例化好的ConvergenceModel对象插入_arr数组
                [_arr addObject:ConModel];
            }
            [_tableView reloadData];
            [self endAnimation];
            UIRefreshControl *refresh = (UIRefreshControl *)[self.tableView viewWithTag:11];
            [refresh endRefreshing];
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此执行
        NSLog(@"statusCode=%ld",statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
    
}
//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        return 240;
    }else{
        return 120.0f;
    }
    
}


#pragma mark - table view


//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        ConvergenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        ConvergenceModel *model=_arr[indexPath.row];

        
        NSURL * url = [NSURL URLWithString:model.Image];
        [cell.backgroundImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"MineSelected"]];
        
        cell.ipLabel.text = model.address;
        cell.nameLabel.text = model.name;
//        cell.volumeLabel.text = model.;
//        cell.distanceLabel.text = dict[@"distance"];
        //计算距离
        CLLocation *Location = [[CLLocation alloc] initWithLatitude:[model.distance doubleValue] longitude:[model.distance doubleValue]];
        
        CLLocationDistance kilometers=[_location distanceFromLocation:Location]/1000;
        cell.distanceLabel.text = [NSString stringWithFormat:@"距离我%.1f公里",kilometers];
        
        [_aiv stopAnimating];
        return cell;

    }else{
    ConTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        ConvergenceModel *model=_arr[indexPath.row];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Image]];
        [cell.cardImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        cell.cardNameLabel.text = model.name;
        cell.volumeLabel.text = model.categoryName;
        cell.pricelabel.text = [NSString stringWithFormat:@"%ld元",(long)_model.Price];
        cell.numLabel.text = [NSString stringWithFormat:@"已售：%@",_model.sellNumber];
        
//        cell.pricelabel.text = [NSString stringWithFormat:@"%ld元",(long)_model.orginPrice];
//        cell.numLabel.text = [NSString stringWithFormat:@"已售：%@",_model.sellNumber];
//        dict1[@"sellNumber"];
        return cell;
    }
    
    
}

//当某一个跳转行为将要发生的时候
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List2Detail"]) {
        //当从列表也到详情页的这个跳转要发生的时候
        //1 获取要传递到下一页去的数据
        NSIndexPath *indexpath = [_tableView indexPathForSelectedRow];
        ConvergenceModel * activity = _arr[indexpath.row];
        //2获取下一页这个实例
        DetailViewController *detailVC = segue.destinationViewController;
        
        //3把数据给下一页预备好的接受容器
        detailVC.fitness = activity;
    }
}


//这个方法处理网络请求完成后所有不同的动画终止
-(void)endAnimation{
    [_aiv stopAnimating];
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
