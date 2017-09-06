//
//  ConvergenceViewController.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ConvergenceViewController.h"
#import "ConTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ConvergenceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
-(void)networkRequest{
    NSDictionary *para = @{@"city":@"0510",@"jing":@1,@"wei":@1,@"page":@1,@"perPage":@6};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //        NSDictionary *content = responseObject[@"content"];
        //
        //        _model= [[ConvergenceModel alloc]initWithDict:content];
        
        //NSLog(@"首页%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001)
        {
            //NSArray *advertisement =responseObject[@"advertisement"];
            NSDictionary *result =responseObject[@ "result"];
            NSLog(@"result = %@",result);
            NSArray * exper =result[@"models"];
            NSLog(@"exper = %@",exper);
            for (NSDictionary *dict in exper)
            {
                //用ConvergenceModel类中定义的初始化方法initWithDict:建行遍历得来的字典dict转换成为activityModel对象
                ConvergenceModel *ConModel = [[ConvergenceModel alloc]initWithDict:dict];
                //将上述实例化好的ConvergenceModel对象插入_arr数组
                [_arr addObject:ConModel];
            }
            [_tableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"statusCode = %ld",(long)statusCode);
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
        return 200;
    }else{
        return 100.0f;
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
        
        
        return cell;

    }else{
    ConTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        ConvergenceModel *model=_arr[indexPath.row];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Image]];
        [cell.cardImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"MineSelected"]];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
