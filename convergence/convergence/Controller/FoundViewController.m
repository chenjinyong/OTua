//
//  FoundViewController.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundCollectionViewCell.h"

@interface FoundViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    BOOL flag;
    NSInteger index;
    
}
@property (weak, nonatomic) IBOutlet UIButton *wholecityBtn;//全城
- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *FullfillBtn;//全部分类

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;//距离
- (IBAction)distance:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

@property (strong,nonatomic)NSMutableArray *arr;
@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    flag = NO;
    index = 0;
    
    _arr = [NSMutableArray new];
    
    [self netRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
    
}
//每组有多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     FoundCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foundCell" forIndexPath:indexPath];
    
    return cell;
}


-(void)netRequest{
    NSDictionary *para = @{@"city":@"0510",@"jing":@1,@"wei":@1,@"page":@1,@"perPage":@6};
    [RequestAPI requestURL:@"/homepage/freeTrial" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
 //           NSLog(@"result = %@",result);
            NSArray *featureForm = result[@"featureForm"];
 //           NSLog(@"featureForm = %@",featureForm);
            for(NSDictionary *dict in result){
//                 *ConModel = [[ alloc]initWithDict:dict];
//                [_arr addObject:];
            }
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
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

- (IBAction)wholecityAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)FullfillAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)distance:(UIButton *)sender forEvent:(UIEvent *)event {
}


@end
