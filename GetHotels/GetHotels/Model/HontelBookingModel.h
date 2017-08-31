//
//  HontelBookingModel.h
//  GetHotels
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HontelBookingModel : NSObject
@property (strong,nonatomic) NSString *contents;//
@property (strong,nonatomic) NSString *price;//价格
@property (strong,nonatomic) NSString *hotel_types;
@property (strong,nonatomic) NSString *hotel_facility;//设施
@property (strong,nonatomic) NSString *is_pet;//宠物
@property (strong,nonatomic) NSString *in_time;//出入时间
@property (strong,nonatomic) NSString *out_time;
@property (strong,nonatomic) NSString *hoteladdress;//酒店地址
@property (strong,nonatomic) NSString *hotel_img;//酒店图片
@property (strong,nonatomic) NSString *room_img;//房间图片
- (instancetype)initWithDic: (NSDictionary *)dic;

@end
