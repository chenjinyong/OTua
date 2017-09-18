//
//  ActivityModel.m
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

- (id)initWithDictionary:(NSDictionary *)dict
{
    //    if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]) {
    //        _imgURL = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
    //    }
    //    else{
    //    _imgURL = dict[@"imgURL"];
    //}
    self = [super init];
    if (self) {
        _activityId  = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        self.imgURL = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"imgUrl"];
        self.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"活动": dict[@"name"];
        self.content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"活动内容" : dict[@"content"];
        self.like = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"reliableNumber"] integerValue];
        self.unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"unReliableNumber"] integerValue];
        self.isFavo = [dict[@"isFavo"]isKindOfClass:[NSNull class]]?   NO : [dict[@"isFavo"] boolValue ];
        
    }
    return self;
}

- (id)initWithDetailDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _activityId  = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        _imgURL = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"name"];
        _content = [Utilities nullAndNilCheck:dict[@"content"] replaceBy:@"content"];
        _like = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"reliableNumber"] integerValue];
        _unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"unReliableNumber"] integerValue];
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@"地址活动待定"];
        _applyFee = [Utilities nullAndNilCheck:dict[@"applicationFee"] replaceBy:@"0"];
        _attendence = [Utilities nullAndNilCheck:dict[@"participantsNumber" ] replaceBy:@"0"];
        _limitation = [Utilities nullAndNilCheck:dict[@"attendenceAmount" ] replaceBy:@"0"];
        _type = [Utilities nullAndNilCheck:dict[@"categoryName" ] replaceBy:@"普通活动"];
        _issuer = [Utilities nullAndNilCheck:dict[@"issuerName" ] replaceBy:@"未知发布者"];
        _phone = [Utilities nullAndNilCheck:dict[@"issuerPhone" ] replaceBy:@""];
        _dueTime = [dict[@"applicationExpirationDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"applicationExpirationDate"] integerValue];
        _startTime = [dict[@"startDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"startDate"] integerValue];
        _endTime = [dict[@"endDate"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"endDate"] integerValue];
        _status = [dict[@"applyStatus"] isKindOfClass:[NSNull class]] ? -1 : [dict[@"applyStatus"] integerValue];
    }
    return self;
}


@end
