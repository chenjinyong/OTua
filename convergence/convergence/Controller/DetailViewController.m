//
//  DetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
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
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;//场地数
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
//@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (strong,nonatomic) NSMutableArray *arr;
@property (strong,nonatomic) NSMutableArray *exparr;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self netRequest];
    _arr = [NSMutableArray new];
    _exparr = [NSMutableArray new];
    page = 1;
    perpage = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    
//    NSString *nextImageFilename = [self nextImageFilename];
//    
//    // 设置图片
//    
//    UIImage *nextImage = [UIImage imageWithContentsOfFile:nextImageFilename];
//    self.scrollImg = nextImage;
}

- (void)addZLImageViewDisPlayView:(NSArray *)imageArray{
    
//    //获取要显示的位置
//    CGRect screenFrame = [[UIScreen mainScreen] bounds];
//    
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_W, 200);
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = _arr;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.7;
    [self.imgView addSubview:imageViewDisplay];
    
    //    [imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
    //        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
    //        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alter show];
    //    }];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

//单击手势响应事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
}

//网络请求
-(void)netRequest{
    
    NSDictionary * para = @{@"clubKeyId":_fitness.detailid};
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
                NSLog(@"555878%@",detail.experienceInfos);
                [_exparr addObject:detail];
            }
            [_expTableView reloadData];
           // NSLog(@"图片网址：%@",_arr);
            [self addZLImageViewDisPlayView:_arr];
            // [_scrollImg sd_setImageWithURL:[NSURL URLWithString:_arr[0]] placeholderImage:[UIImage imageNamed:@""]];/Users/admin/Desktop/会聚/convergence/convergence
            
            DetailModel *model = [[DetailModel alloc]initWithDictionary:result];
            _ipLabel.text = model.clubAddressB;

            _namelabel.text = model.clubName;
            _detailLabel.text =model.clubIntroduce;
            _timeLabel.text = model.openTime;
            _vipLabel.text = model.clubMember;
            _teacherLabel.text = model.clubPerson;
            _siteLabel.text = model.storeNums;
//            [_cardImg sd_setImageWithURL:[NSURL URLWithString:model.clubLogo]];
            
            
           // _cardStyleLabel.text = model.eName;
            
            
//            
//            NSArray *exper = result[@"experienceInfos"];
//            for (NSDictionary *dict in exper) {
//                NSLog(@"体验卷 %@",exper);

//            }


            
        }else {
            [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:@"提示" onView:self];
        
        
        
    }
    }
     failure:^(NSInteger statusCode, NSError *error) {
         //失败以后要做的事情在此执行
         NSLog(@"statusCode=%ld",statusCode);

         [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
     }];

        
    
}

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_exparr = %@",_exparr);
    return _exparr.count;
    
}
//细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 120.0f;
}
//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
       VouchersViewController *Vouch = [Utilities getStoryboardInstance:@"Vouchers" byIdentity:@"cardDetail"];
    
        //体验劵详情页的跳转
    
            DetailModel * home = _exparr[indexPath.row];
        NSLog(@"数组值：%@",home.eId);

//           NSArray *array = home.eId;
//                NSDictionary *dict = array[indexPath.row];
//            NSString *eId =  dict[@"eId"];
            [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:home.eId];
    
    //[self presentViewController:Vouch animated:YES completion:nil];
    [self.navigationController pushViewController:Vouch animated:YES];
   
        
    
    
    
    

    
}

//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailModel * conver = _exparr[indexPath.row];
    NSLog(@"conver = %@",conver);
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

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ToVouchers"]) {
//        //当从列表也到详情页的这个跳转要发生的时候
//        //1 获取要传递到下一页去的数据
//        
//        
//    }
//    
//}


@end
