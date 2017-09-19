//
//  FoundViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundCollectionViewCell.h"
#import "FoundModel.h"
#import <UIImageView+WebCache.h>
#import "sxTableViewCell.h"
#import "DetailViewController.h"
@interface FoundViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>{
    NSInteger index;
    NSInteger page;
    NSInteger perpage;
    NSInteger totalPage;
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger flag;
    BOOL isDis;
    
}
@property (weak, nonatomic) IBOutlet UIButton *wholecityBtn;//全城
- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *FullfillBtn;//全部分类

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;//距离
- (IBAction)distance:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event;


@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic)NSMutableArray *arr;
@property (strong,nonatomic)NSArray *brr;
@property (strong,nonatomic) NSArray * disArr;
@property (strong,nonatomic) NSString * disStr;
@property (strong,nonatomic) NSString * idStr;
@property (strong,nonatomic)NSMutableArray *detailarr;
@property (strong,nonatomic) NSMutableArray * kindArr;
@property (strong,nonatomic) NSMutableArray * kindArr1;
@property (strong,nonatomic) NSArray * cityArr;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *SxTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableView;

//@property (strong,nonatomic) NSMutableArray * contentArr;
//定义一个存放数据的数组
@property (strong,nonatomic) NSArray * foundArr;

@property (strong,nonatomic)NSArray *cellarr;
@end

@implementation FoundViewController

- (void)viewDidLoad {
   
    
    
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];
    [self netRequest];
    
    [self initialization];
    [self disnetworkRequest];
    
    
    
    // Do any additional setup after loading the view.
    
    
    _arr = [NSMutableArray new];
    _detailarr = [NSMutableArray new];
    _kindArr = [NSMutableArray new];
    _kindArr1 = [NSMutableArray new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
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
    
   // NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表歌视图中的某个细胞
   // [self.SxTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
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
                FoundModel * foundModel = [[FoundModel alloc]initWithSxNSDictionary:dict];
                //   NSLog(@"foundModel = %@",foundModel);
                [_arr addObject:foundModel];
            }
            [_CollectionView reloadData];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        
    }];
}

//每组有多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arr.count;
    
}

//每个细胞长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    if(indexPath.section == 0){
    FoundCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foundCell" forIndexPath:indexPath];
    
    FoundModel *foundModel = _arr[indexPath.row];
    NSURL *url = [NSURL URLWithString:foundModel.clubImageUrl];
    [cell.logoImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    cell.nameLabel.text = foundModel.clubName;
    cell.ipLabel.text  = foundModel.clubAdd;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%ld米",(long)foundModel.clubDis];
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

- (void)setRefreshControl{
    
    UIRefreshControl *refresh = [UIRefreshControl new];
    [refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    refresh.tag = 10001;
    [_CollectionView addSubview:refresh];
    
}
//会所列表下拉刷新事件
- (void)refreshAction{
    pageNum = 1;
    if(flag == 1){
        if(_disStr == nil){
            [self disnetworkRequest];
        }else{
            [self rangenetworkRequest];
        }
        return;
    }
    if(flag == 2){
        if(_idStr == nil){
            [self disnetworkRequest];
        }else{
            [self kindnetworkRequest];
        }
        return;
    }
    if(flag == 3){
        if(isDis){
            [self disnetworkRequest];//默认
            return;
        }else{
            [self peoplenetworkRequest];
            return;
        }
    }
    else{
        [self disnetworkRequest];
    }
}



#pragma mark - tableViewCell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(flag == 1){
        return _cityArr.count;
    }
    if(flag == 2){
        return _kindArr.count;
    }
    if(flag == 3){
        return _disArr.count;
    }
    return 0;
}



//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

//样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    sxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foundCell" forIndexPath:indexPath];
    if(flag == 1){
        cell.sxLbl.text = _cityArr[indexPath.row];
    }
    if(flag == 2){
        cell.sxLbl.text = _kindArr[indexPath.row];
        
    }
    if(flag == 3){
        cell.sxLbl.text = _disArr[indexPath.row];
    }
    return cell;
}

//细胞被点击后要做的事情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_CollectionView deselectItemAtIndexPath:indexPath animated:YES];
    FoundModel * find = _arr[indexPath.row];
    NSString *clubId = find.clubID;
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:clubId];
    DetailViewController *issueVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"clubdetail"];
    
    [self.navigationController pushViewController:issueVC animated:YES];
 
}

//细胞将要出现时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _arr.count-1){
        if(pageNum != totalPage){
            pageNum ++;
            if(flag == 1){
                if(_disStr == nil){
                    [self disnetworkRequest];
                }else{
                    [self rangenetworkRequest];
                }
                return;
            }
            
            if(flag == 2){
                if(_idStr == nil){
                    [self disnetworkRequest];
                }else{
                    [self kindnetworkRequest];
                }
                return;
            }
            
            if(flag == 3){
                if(isDis){
                    [self disnetworkRequest];
                }else{
                    [self peoplenetworkRequest];
                }
                return;
            }
            else{
                [self disnetworkRequest];
                //  NSLog(@"不是最后一页");
            }
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    pageNum = 1;
    if(flag == 1){
        if(indexPath.row == 0){
            _disStr = @"1000";
            [self disnetworkRequest];//默认按距离请求
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 1){
            _disStr = @"2000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 2){
            _disStr = @"3000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 3){
            _disStr = @"4000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 4){
            _disStr = @"5000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        
        
    }
    if(flag == 2){
        
        if(indexPath.row == 0){
            [self disnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 1){
            _idStr = @"1";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 2){
            _idStr = @"2";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 3){
            _idStr = @"3";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 4){
            _idStr = @"4";
            [self kindnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        
    }
    if(flag == 3){
        if(indexPath.row == 0){
            isDis = YES;
            [self disnetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        
        [self peoplenetworkRequest];
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
    }
    
    
    
    
}



//距离排序请求
-(void)disnetworkRequest{
    //_aiv= [Utilities getCoverOnView:self.view];
    NSDictionary * para = @{@"city":@"无锡",@"page":@(page),@"perPage":@(perpage),@"jing":@(120.2672222),@"wei":@(31.47361111),@"type":@0};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_CollectionView viewWithTag:10001];
        [ref endRefreshing];
        NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            NSDictionary  * pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if(pageNum == 1){
                [_arr removeAllObjects];
            }
            
            for(NSDictionary * dict in models){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_arr addObject:find];
            }
            [_CollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此处执行
        NSLog(@"statusCode = %ld",(long)statusCode);
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//按人气
-(void)peoplenetworkRequest{
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary * para = @{@"city":@"无锡",@"jing":@"120.2672222",@"wei":@"31.47361111",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@1};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_aiv stopAnimating];
        NSLog(@"responseObject=%@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_CollectionView viewWithTag:10001];
        [ref endRefreshing];
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            for(NSDictionary * dict in models){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_arr addObject:find];
            }
            [_CollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此处执行
        NSLog(@"statusCode = %ld",(long)statusCode);
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//请求n千米范围内的会所
- (void)rangenetworkRequest{
    
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.2672222",@"wei":@"31.47361111",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_disStr};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_CollectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(pageNum == 1){
                [_arr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_arr addObject:find];
                // NSLog(@"数组里的是%@",model);
                
            }
            
            
            
            [_CollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_CollectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//按种类请求会所
- (void)kindnetworkRequest{
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.2672222",@"wei":@"31.47361111",@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_idStr};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_CollectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if(pageNum == 1){
                [_arr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_arr addObject:find];
                
                
            }
            [_CollectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_CollectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

//请求健身类型ID
- (void)TypeRequest{
    
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡"};
    [RequestAPI requestURL:@"/clubController/getNearInfos" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *features = responseObject[@"result"][@"features"];
            NSArray *featureForm = features[@"featureForm"];
            for(NSDictionary *dict in featureForm){
                FoundModel * find = [[FoundModel alloc]initWithSxNSDictionary:dict];
                [_kindArr1 addObject:find];
                //    NSLog(@"数组里的是：%@",model.fName);
            }
            if(pageNum == 1){
                [_kindArr removeAllObjects];
            }
            _kindArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类", nil];
            for(int i = 0;i < 4;i++){
                FoundModel * find = _kindArr1[i];
                [_kindArr addObject:find.fName];
            }
            
            //[_tableView reloadData];
            [self disnetworkRequest];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

-(void)initialization{
    isDis = NO;
    [self setRefreshControl];
    [self TypeRequest];
    //状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _cityArr = [NSArray new];
    _kindArr = [NSMutableArray new];
    _kindArr1 = [NSMutableArray new];
    _disArr = [NSArray new];
    _arr = [NSMutableArray new];
    //_kindArr = @[@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动"];
    //_kindArr = [[NSArray alloc]initWithObjects:@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动",nil];
    _cityArr = @[@"不限",@"距离我1KM以内",@"距离我2KM以内",@"距离我3KM以内",@"距离我5KM以内"];
    _disArr = @[@"按距离",@"按人气"];
    pageNum = 1;
    pageSize = 10;
    perpage = 10;
    
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }

//

- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    flag = 1;
    self.heightTableView.constant = _cityArr.count *40 ;
    _SxTableView.hidden = NO;
    _coverView.hidden = NO;
    [_SxTableView reloadData];
    
    
    
}
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
    self.heightTableView.constant = _kindArr.count *40 ;
    _SxTableView.hidden = NO;
    _coverView.hidden = NO;
    [_SxTableView reloadData];
}
- (IBAction)distance:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    self.heightTableView.constant = _disArr.count *40;
    _SxTableView.hidden = NO;
    _coverView.hidden = NO;
    [_SxTableView reloadData];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _SxTableView.hidden = YES;
    _coverView.hidden = YES;
}

@end
