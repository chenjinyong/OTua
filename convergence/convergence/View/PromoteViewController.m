//
//  PromoteViewController.m
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "PromoteViewController.h"
#import <CoreImage/CoreImage.h>

@interface PromoteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ZH_QRimageView;

@property (strong,nonatomic) UIActivityIndicatorView * aiv;

@end

@implementation PromoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self QrCodeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
//-(void)QrCode {
    
//    // 1.实例化二维码滤镜
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    
//    // 2.恢复滤镜的默认属性
//    [filter setDefaults];
//    
//    // 3.二维码信息
//    NSString *str = @"http://dwz.cn/ETumE"; // 展示一串文字
//    //    NSString *str = @"http://www.baidu.com"; // 直接打开网页
//    
//    // 4.将字符串转成二进制数据
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // 5.通过KVC设置滤镜inputMessage数据
//    [filter setValue:data forKey:@"inputMessage"];
//    
//    // 6.获取滤镜输出的图像
//    CIImage *outputImage = [filter outputImage];
//    
//    // 7.将CIImage转成UIImage
//    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
//    
//    // 8.展示二维码
//    self.ZH_QRimageView.image = image;
//}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    //CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    CGFloat scale = MIN(10, 20);
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)QrCodeRequest{
    _aiv = [Utilities getCoverOnView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"]forKey:@"memberId"];
    [RequestAPI requestURL:@"/mySelfController/getInvitationCode" withParameters:parameters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"二维码：%@",responseObject);
        [_aiv stopAnimating];
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary * result= responseObject[@"result"];
            NSLog(@"result =%@",result);
            // 1.实例化二维码滤镜
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            
            // 2.恢复滤镜的默认属性
            [filter setDefaults];
            
            // 3.二维码信息
            NSString *str = @"http://dwz.cn/%@"; // 展示一串文字
            //    NSString *str = @"http://www.baidu.com"; // 直接打开网页
            
            // 4.将字符串转成二进制数据
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            // 5.通过KVC设置滤镜inputMessage数据
            [filter setValue:data forKey:@"inputMessage"];
            
            // 6.获取滤镜输出的图像
            CIImage *outputImage = [filter outputImage];
            
            // 7.将CIImage转成UIImage
            UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
            
            // 8.展示二维码
            self.ZH_QRimageView.image = image;
            
        }else{
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"statusCode = %ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接" andTitle:nil onView:self];
        
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
