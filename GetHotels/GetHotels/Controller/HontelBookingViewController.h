//
//  HontelBookingHontelViewController.h
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GethontelModel.h"
#import "HontelBookingModel.h"
#import <MapKit/MapKit.h>

@interface HontelBookingViewController : UIViewController<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
//@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

//创建一个容器去接受别的页面传来的数据
@property (strong,nonatomic)HontelBookingModel *HontelBooking;
@property (strong,nonatomic)GethontelModel *mod;

@property (nonatomic)NSInteger hotelid;


@end
