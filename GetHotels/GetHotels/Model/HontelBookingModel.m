//
//  HontelBookingModel.m
//  GetHotels
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HontelBookingModel.h"

@implementation HontelBookingModel
- (instancetype)initWithDic: (NSDictionary *)dic{
    self = [super init];
    if (self) {
        _price = [Utilities nullAndNilCheck:dic[@"price"] replaceBy:@"0"];
        _hotel_facility = [Utilities nullAndNilCheck:dic[@"hotel_facility"] replaceBy:@"0"];
        _hoteladdress = [Utilities nullAndNilCheck:dic[@"hotel_address"] replaceBy:@"0"];
        _in_time = [Utilities nullAndNilCheck:dic[@"in_time"] replaceBy:@"0"];
        _out_time = [Utilities nullAndNilCheck:dic[@"out_time"] replaceBy:@"0"];
        _is_pet = [Utilities nullAndNilCheck:dic[@"is_pet"] replaceBy:@"0"];
//        _remarks = [Utilities nullAndNilCheck:dic[@"remarks"] replaceBy:@"0"];
        _room_img = [Utilities nullAndNilCheck:dic[@"room_img"] replaceBy:@"0"];
        _hotel_types = [Utilities nullAndNilCheck:dic[@"hotel_type"] replaceBy:@"0"];
        _hotel_img=[Utilities nullAndNilCheck:dic[@"hotel_img"] replaceBy:@"0"];
        
    }
    return self;
}
@end
