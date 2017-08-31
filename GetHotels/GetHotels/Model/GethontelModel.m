//
//  GethontelModel.m
//  GetHotels
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "GethontelModel.h"

@implementation GethontelModel
- (instancetype)initWithDict: (NSDictionary *)dict {
    self = [super init];
    if (self) {
       _distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"0"];
        _hotel_address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"0"];
        _hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"0"];
        _Price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"0"]integerValue];
        _latitude = [Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@"0"];
        _longitude = [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@"0"];
        _hotelId = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"] integerValue];
        
    }
    return self;
}

@end
