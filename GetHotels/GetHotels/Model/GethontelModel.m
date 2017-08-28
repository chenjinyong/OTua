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
       _ad_img = [Utilities nullAndNilCheck:dict[@"ad_img"] replaceBy:@"0"];
        _ad_name = [Utilities nullAndNilCheck:dict[@"ad_name"] replaceBy:@"0"];
        _ad_url = [Utilities nullAndNilCheck:dict[@"ad_url"] replaceBy:@"0"];
        _id = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        _start_time = [Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@"0"];
    }
    return self;
}

@end
