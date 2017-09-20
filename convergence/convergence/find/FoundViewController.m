//
//  FindViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundTableViewCell.h"
#import "FoundCollectionViewCell.h"
#import "FoundModel.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"

@interface FoundViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSInteger page;
    NSInteger perPage;
    NSInteger totalPage;
    NSInteger pageNum;
    NSInteger pageSize;
    NSInteger flag;
    BOOL isDis;
}
- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event;//全城
@property (weak, nonatomic) IBOutlet UIButton *wholecityBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;//按距离
- (IBAction)distanceAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *FullfillBtn;//全部分类
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *SxTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableView;
- (IBAction)avaActon:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *avaImg;

@property (weak, nonatomic) IBOutlet UICollectionView *ContentCollectionView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@property (strong,nonatomic) NSArray * cityArr;
@property (strong,nonatomic) NSMutableArray * kindArr;
@property (strong,nonatomic) NSMutableArray * kindArr1;
@property (strong,nonatomic) NSArray * disArr;
@property (strong,nonatomic) NSString * disStr;
@property (strong,nonatomic) NSString * idStr;
@property (strong,nonatomic) NSMutableArray * contentArr;
@property (strong,nonatomic)UIImageView *imgview;

@property (strong,nonatomic) NSString *str;
@property (strong,nonatomic) NSString *str1;
@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_user"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_imgview];
    [self addtapgestureRecognizer:self.imgview];
    //接收侧滑按钮被按的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHeadImg) name:@"changeHeadImg" object:nil];
    
    
    _str  = [[StorageMgr singletonStorageMgr]objectForKey:@"jindu"];
    _str1 = [[StorageMgr singletonStorageMgr]objectForKey:@"weidu"];
    [self initialization];
    [self disnetworkRequest];
    //创建菊花膜
    _aiv = [Utilities getCoverOnView:self.view];

    //设置导航条的颜色(风格颜色)
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(37, 139, 254);
    //设置导航条标题的颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = NO;
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//每次将要来到这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _SxTableView.hidden = YES;
    _coverView.hidden = YES;
}

-(void)changeHeadImg{
    UserModel * user = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    if (![Utilities loginCheck]) {
        
        
        //[_avatarImg setImage:[UIImage imageNamed:@"Location"]];
        [_imgview setImage:[UIImage imageNamed:@"ic_user"]];
    }
    else{
//        NSLog(@"图片 %@",user.avatarUrl);
        //NSString *imgurl = [NSString stringWithFormat:@"%@",user.avatarUrl];
        [_imgview sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        
        // _imgview =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Mine"]]
    }
    
}
//添加单击手势
-(void)addtapgestureRecognizer:(id)any{
    //初始化一个单击手势，设置响应的事件为tapclick
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [any addGestureRecognizer:tap];
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateRecognized ) {
        //发送注册按钮被按的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
    }
}

#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return _contentArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    FoundCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    FoundModel * find = _contentArr[indexPath.row];
    NSURL * url = [NSURL URLWithString:find.clubImageUrl];
    [cell.contentImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdDefault"]];
    cell.shopLbl.text = find.clubName;
    cell.addressLbl.text = find.clubAdd;
    cell.disLbl.text = [NSString stringWithFormat:@"%ld米",(long)find.clubDis];
    
    return cell;
    }

//设置每一个collectionView的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_SCREEN_W/2-5, UI_SCREEN_W/2-5);
}
//设置左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     [_ContentCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    FoundModel * find = _contentArr[indexPath.row];
    NSString *clubId = find.clubID;
    [[StorageMgr singletonStorageMgr] addKey:@"clubId" andValue:clubId];
    DetailViewController *issueVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"clubdetail"];

    [self.navigationController pushViewController:issueVC animated:YES];
    
}
- (void)setRefreshControl{
    
    UIRefreshControl *refresh = [UIRefreshControl new];
    [refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    refresh.tag = 10001;
    [_ContentCollectionView addSubview:refresh];
    
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


-(void)checkCityState:(NSNotification *)note{
    NSString * cityStr = note.object;
    
    [Utilities removeUserDefaults:@"UserCity"];
    [Utilities setUserDefaults:@"UserCity" content:cityStr];
    //重新执行网络请求
    
}

//细胞将要出现时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _contentArr.count-1){
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

#pragma mark - tableview
//有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//一组有多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
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
//样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
     FoundTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sxCell" forIndexPath:indexPath];
    if(flag == 1){
        cell.kindLbl.text = _cityArr[indexPath.row];
    }
    if(flag == 2){
        cell.kindLbl.text = _kindArr[indexPath.row];
        
    }
    if(flag == 3){
        cell.kindLbl.text = _disArr[indexPath.row];
    }
    return cell;
    
  }
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    pageNum = 1;
    if(flag == 1){
        if(indexPath.row == 0){
        _disStr = @"0";
        [self disnetworkRequest];//默认按距离请求
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
        }
        if(indexPath.row == 1){
            _disStr = @"1000";
        [self rangenetworkRequest];
        _SxTableView.hidden = YES;
        _coverView.hidden = YES;
        }
        if(indexPath.row == 2){
            _disStr = @"2000";
            [self rangenetworkRequest];
            _SxTableView.hidden = YES;
            _coverView.hidden = YES;
        }
        if(indexPath.row == 3){
            _disStr = @"3000";
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


#pragma mark - networkRequest


//距离排序请求
-(void)disnetworkRequest{
    //_aiv= [Utilities getCoverOnView:self.view];
       NSDictionary * para = @{@"city":@"无锡",@"page":@(pageNum),@"perPage":@(pageSize),@"jing":_str,@"wei":_str1,@"type":@0};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        //NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            NSDictionary  * pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if(pageNum == 1){
                [_contentArr removeAllObjects];
            }

            for(NSDictionary * dict in models){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];
            }
            [_ContentCollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此处执行
//        NSLog(@"statusCode = %ld",(long)statusCode);
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//按人气
-(void)peoplenetworkRequest{
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary * para = @{@"city":@"无锡",@"jing":_str,@"wei":_str1,@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@1};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_aiv stopAnimating];
        //NSLog(@"responseObject=%@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary * result = responseObject[@"result"];
            NSArray * models = result[@"models"];
            for(NSDictionary * dict in models){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];
            }
            [_ContentCollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *orrorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:orrorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情在此处执行
//        NSLog(@"statusCode = %ld",(long)statusCode);
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];

}
//请求n千米范围内的会所
- (void)rangenetworkRequest{

    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":_str,@"wei":_str1,@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_disStr};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(pageNum == 1){
                [_contentArr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];
                // NSLog(@"数组里的是%@",model);
                
            }
            
            
            
            [_ContentCollectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//按种类请求会所
- (void)kindnetworkRequest{
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":_str,@"wei":_str1,@"page":@(pageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_idStr};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@", responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            if(pageNum == 1){
                [_contentArr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FoundModel * find = [[FoundModel alloc]initWithFindNSDictionary:dict];
                [_contentArr addObject:find];

                
            }
            [_ContentCollectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_ContentCollectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//请求健身类型ID
- (void)TypeRequest{
    
    //_aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡"};
    [RequestAPI requestURL:@"/clubController/getNearInfos" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@", responseObject);
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
    _contentArr = [NSMutableArray new];
    //_kindArr = @[@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动"];
    //_kindArr = [[NSArray alloc]initWithObjects:@"全部分类",@"动感单车",@"力量器械",@"瑜伽/普拉提",@"有氧运动",nil];
    _cityArr = @[@"不限",@"距离我1KM以内",@"距离我2KM以内",@"距离我3KM以内",@"距离我5KM以内"];
    _disArr = @[@"按距离",@"按人气"];
    pageNum = 1;
    pageSize = 10;
    perPage = 10;
    
}


#pragma mark - Action

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _SxTableView.hidden = YES;
    _coverView.hidden = YES;
}
//全城事件
- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    self.heightTableView.constant = _cityArr.count *40 ;
    _SxTableView.hidden = NO;
    _coverView.hidden = NO;
    [_SxTableView reloadData];
}
//按距离分类事件
- (IBAction)distanceAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    self.heightTableView.constant = _disArr.count *40;
    _SxTableView.hidden = NO;
    _coverView.hidden = NO;
    [_SxTableView reloadData];
}
//全部分类事件
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
    self.heightTableView.constant = _kindArr.count *40 ;
    _SxTableView.hidden = NO;
    _coverView.hidden = NO;
    [_SxTableView reloadData];

}
- (IBAction)avaActon:(UIBarButtonItem *)sender {
    //发送注册按钮被按的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LeftSwitch" object:nil];
}
@end
