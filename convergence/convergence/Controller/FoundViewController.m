//
//  FoundViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundCollectionViewCell.h"
//#import "FoundModel.h"
#import <UIImageView+WebCache.h>
#import "sxTableViewCell.h"
#import "DetailViewController.h"
//#import "ConvergenceModel.h"
@interface FoundViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>{
    BOOL flag;
    NSInteger index;
    NSInteger page;
    NSInteger perpage;
    
}
@property (weak, nonatomic) IBOutlet UIButton *wholecityBtn;//全城
- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *FullfillBtn;//全部分类

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;//距离
- (IBAction)distance:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@property (strong,nonatomic)NSMutableArray *arr;
@property (strong,nonatomic)NSArray *brr;
@property (strong,nonatomic)NSArray *crr;
@property (strong,nonatomic)NSArray *drr;
@property (strong,nonatomic)NSMutableArray *detailarr;
//定义一个存放数据的数组
@property (strong,nonatomic) NSArray * foundArr;

@property (strong,nonatomic)NSArray *cellarr;
@end

@implementation FoundViewController

- (void)viewDidLoad {
    //_brr = [NSArray new];
    
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];
    [self netRequest];
    
    [self dataInitalize];
    [self payAction];
    

    // Do any additional setup after loading the view.
    
    
    _arr = [NSMutableArray new];
    _detailarr = [NSMutableArray new];
    //_brr = [NSArray new];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tableView.hidden = YES;
    

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

-(void)uiLayout{
    //    _CollectionView.tableFooterView = [UIView new];
    [self refresh];
    flag = NO;
    index = 0;
    perpage =10;
    
    //去掉多余下划线
    //self.tableView.tableFooterView = [UIView new];
    //将表格试图设置为“编辑视图中”
    //self.tableView.editing = YES;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表歌视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    _tableView.hidden = YES;
    
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
    [self.CollectionView addSubview:refreshControl];
}

-(void)refreshPage{
    page = 1;
    [self netRequest];
}


-(void)netRequest{
    NSDictionary *para = @{@"city":@"0510",@"jing":@31.59,@"wei":@120.29,@"page":@(page),@"perPage":@(perpage)};
    [RequestAPI requestURL:@"/homepage/freeTrial" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"faxian = %@",responseObject);
        UIRefreshControl *refresh = (UIRefreshControl *)[self.CollectionView viewWithTag:11];
        [refresh endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            NSLog(@"models = %@",models);
            [_detailarr addObject:models];
            for(NSDictionary *dict in models){
             ConvergenceModel * foundModel = [[ConvergenceModel alloc]initWithDict:dict];
             //   NSLog(@"foundModel = %@",foundModel);
               [_arr addObject:foundModel];
            }
            [_CollectionView reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}

////设置多少组
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return _arr.count;
//    
//    
//    
//}
//每组有多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arr.count;
//    FoundModel * conver = _arr[section];
//    return conver.models.count+2;
}

//每个细胞长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 0){
        FoundCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foundCell" forIndexPath:indexPath];
        
        ConvergenceModel *foundModel = _arr[indexPath.row];
        NSURL *url = [NSURL URLWithString:foundModel.Image];
        [cell.logoImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text = foundModel.name;
        cell.ipLabel.text  = foundModel.address;
        cell.distanceLabel.text = foundModel.distance;
        return cell;
        
    

    //NSDictionary *dict = _arr[indexPath.section];
    
}

//每个细胞的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat x = self.view.frame.size.width/2-5;
    
    return CGSizeMake(x,x);
    
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//细胞的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}



#pragma mark - tableViewCell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _brr.count;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    sxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    
    cell.sxLbl.text = _brr[indexPath.row];
    
    return cell;
}

//细胞被点击后要做的事情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(flag ==0){
        
    }
    
    ConvergenceModel * home = _arr[indexPath.row];
    DetailViewController*Vouch = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"clubdetail"];
    Vouch.fitness = home;
    [self.navigationController pushViewController:Vouch animated:YES];
    

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    //遍历表格视图中所有选中状态下的细胞
    for (NSIndexPath * eachIP in tableView.indexPathsForSelectedRows) {
        //当选中的细胞不是当前正在按的这个细胞的情况下
        if (eachIP != indexPath) {
            //将细胞从选中状态下改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
            
        }
    }
    
    
}


-(void)dataInitalize{
    _brr = @[@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动"];
}

-(void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            
        }
            
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
        case 3:{
            
        }
        case 4:{
            
        }
            break;
            
        default:
            break;
    }
    
}







 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }

//

- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if (sender.selected) {
        _tableView.hidden = YES;  //点击显示
    }else{
        _tableView.hidden = NO;  //再次点击隐藏
    }
    
    
    
}
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _tableView.hidden = NO;
 //   _brr = @[@"0分类",@"动0单车",@"力量0",@"00",@"00"];
    
}
- (IBAction)distance:(UIButton *)sender forEvent:(UIEvent *)event {
}


@end
