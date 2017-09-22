//
//  DetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
//#import "SDCycleScrollView.h"
#import "ZLImageViewDisplayView.h"
#import "DetailTableViewCell.h"
#import "VouchersViewController.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger page;
    NSInteger perpage;
    NSInteger i;
}

@property (weak, nonatomic) IBOutlet UITableView *expTableView;

@property (weak, nonatomic) IBOutlet UIView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;//场地数
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)mapimgAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)mapLabelAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong,nonatomic) NSMutableArray *arr;
@property (strong,nonatomic) NSMutableArray *exparr;
@property (strong,nonatomic)DetailModel *model;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _arr = [NSMutableArray new];
    _exparr = [NSMutableArray new];
    page = 1;
    perpage = 10;
    [self netRequest];
    [self Lateralspreads];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if(self.navigationController.childViewControllers.count == 1){
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

- (void)addZLImageViewDisPlayView:(NSArray *)imageArray{
    
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_W, 210);
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = _arr;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.7;
    [self.imgView addSubview:imageViewDisplay];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

//网络请求
-(void)netRequest{
    NSString *ClubId = [[StorageMgr singletonStorageMgr]objectForKey:@"clubId"];
    NSDictionary * para = @{@"clubKeyId":ClubId};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"会所详情 = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
           // NSLog(@"rrr = %@",result);
            NSArray *clubPic = result[@"clubPic"];
            //NSLog(@"mmm = %@",clubPic);
            for(NSDictionary *img in clubPic){
                _arr[i] = img[@"imgUrl"];
                i++;
            }
             NSArray *eArr = result[@"experienceInfos"];
            for(NSDictionary * dict in eArr){
                DetailModel * detail = [[DetailModel alloc]initWithDictionary:dict];
//                NSLog(@"555878%@",detail.experienceInfos);
                [_exparr addObject:detail];
            }
            [_expTableView reloadData];
           // NSLog(@"图片网址：%@",_arr);
            [self addZLImageViewDisPlayView:_arr];
 
          _model = [[DetailModel alloc]initWithDictionary:result];
            _ipLabel.text = _model.clubAddressB;

            _namelabel.text = _model.clubName;
            _detailLabel.text =_model.clubIntroduce;
            _timeLabel.text = _model.openTime;
            _vipLabel.text = _model.clubMember;
            _teacherLabel.text = _model.clubSite;
            _siteLabel.text = _model.clubPerson;
        
        }else {
            [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
        }
    }
     failure:^(NSInteger statusCode, NSError *error) {
         //失败以后要做的事情在此执行
//         NSLog(@"statusCode=%ld",statusCode);

         [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
     }];
 
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"_exparr = %@",_exparr);
    return _exparr.count;
    
}
//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 120.0f;
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VouchersViewController *Vouch = [Utilities getStoryboardInstance:@"Vouchers" byIdentity:@"cardDetail"];
    //体验劵详情页的跳转
    DetailModel * home = _exparr[indexPath.row];
//    NSLog(@"数组值：%@",home.eId);
    [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:home.eId];
    //[self presentViewController:Vouch animated:YES completion:nil];
    [self.navigationController pushViewController:Vouch animated:YES];
   
}

//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailModel * conver = _exparr[indexPath.row];
//    NSLog(@"conver = %@",conver);
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell" forIndexPath:indexPath];
    
    NSURL * url = [NSURL URLWithString:conver.eLogo];
    [cell.cardImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    cell.cardStyleLabel.text = conver.eName;
    cell.cardLabel.text = @"综合卷";
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld元",(long)conver.orginPrice];
    cell.numLabel.text = [NSString stringWithFormat:@"已售%ld",(long)conver.number];
    return cell;

}

#pragma mark - Navigation

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *string = _model.clubTel;
    _arr =  [string componentsSeparatedByString:@","];
    // NSLog(@"数组里的是：%@",_arr);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  NSLog(@"点了第一个");
        // NSLog(@"%@",_arr[0]);
        //配置电话APP的路径，并将要拨打的号码组合到路径中
        NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[0]];
        
        UIWebView *callWebview =[[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        
        
    }];
    [alertController addAction:callAction];
    // }
    if(_arr.count == 2)
    {
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // NSLog(@"点了第二个");
            // NSLog(@"%@",_arr[1]);
            //配置电话APP的路径，并将要拨打的号码组合到路径中
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[1]];
            
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
            
        }];
        [alertController addAction:callAction];
        
    }
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    //  [alertController addAction:callAction];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)mapimgAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Vouchers" byIdentity:@"map"];
    [self presentViewController:signNavi animated:YES completion:nil];

    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_model.clubJing];
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_model.clubWei];
    [[StorageMgr singletonStorageMgr] addKey:@"clubname" andValue:_model.clubName];
    [[StorageMgr singletonStorageMgr] addKey:@"clubaddress" andValue:_model.clubAddressB];
    NSLog(@"_model.clubAddressB = %@",_model.clubAddressB);

}

- (IBAction)mapLabelAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Vouchers" byIdentity:@"map"];
    [self presentViewController:signNavi animated:YES completion:nil];
    [[StorageMgr singletonStorageMgr] addKey:@"longitude" andValue:_model.clubJing];
    //    NSLog(@"%@",_voucher.longitude);
    [[StorageMgr singletonStorageMgr] addKey:@"latitude" andValue:_model.clubWei];
    [[StorageMgr singletonStorageMgr] addKey:@"clubname" andValue:_model.clubName];
    //    NSLog(@"%@",_voucher.longitude);
    [[StorageMgr singletonStorageMgr] addKey:@"clubaddress" andValue:_model.clubAddressB];

}
@end
