//
//  DetailViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"


@interface DetailViewController (){
    NSInteger page;
    NSInteger perpage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImg;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;//场地数
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *cardStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self netRequest];
    
    page = 1;
    perpage = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

//单击手势响应事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
}

//网络请求
-(void)netRequest{
    NSDictionary * para = @{@"clubKeyId":_fitness.id};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"会所详情 = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
           // NSLog(@"rrr = %@",result);
            NSArray *clubPic = result[@"clubPic"];
            NSLog(@"mmm = %@",clubPic);
            
            DetailModel *model = [[DetailModel alloc]initWithDictionary:result];
            _ipLabel.text = model.address;

            _namelabel.text = model.clubName;
            _detailLabel.text =model.clubIntroduce;
            _timeLabel.text = model.openTime;
            _vipLabel.text = model.clubMember;
            _teacherLabel.text = model.clubPerson;
            _siteLabel.text = model.storeNums;
            [_cardImg sd_setImageWithURL:[NSURL URLWithString:model.clubLogo ]];
            
           // _cardStyleLabel.text = model.eName;
            NSArray *exper = result[@"experienceInfos"];
            for (NSDictionary *dict in exper) {
                DetailModel *mod = [[DetailModel alloc]initWithDictionary:dict];
 //               [_cardImg sd_setImageWithURL:[NSURL URLWithString:mod.eLogo]];
                NSURL * url = [NSURL URLWithString:mod.eLogo];
                [_cardImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                _cardStyleLabel.text = mod.eName;
                _cardLabel.text = @"综合卷";
                _priceLabel.text = [NSString stringWithFormat:@"%ld元",(long)mod.price];
                _numLabel.text = [NSString stringWithFormat:@"已售%ld",(long)mod.number];
            }


            
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
