//
//  PromoteViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "PromoteViewController.h"
#import "qrencode.h"

@interface PromoteViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *ZH_QRimageView;

@end

@implementation PromoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreateQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)CreateQRCode{
    _ZH_QRimageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 180, 250, 250)];
    
    [self.view addSubview:_ZH_QRimageView];
    
//    _ZH_QRimageView.image = [ qrImageForString:@"会聚" imageSize:_ZH_QRimageView.bounds.size.width];
}

@end
