//
//  activityModel.m
//  ActivityList
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "activityModel.h"

@implementation activityModel
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
        _activityId  = [Utilities nullAndNilCheck:@"id" replaceBy:@"0"];
        self.imgURL = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"imgUrl"];
        self.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"活动": dict[@"name"];
        self.content = [dict[@"content"] isKindOfClass:[NSNull class]] ? @"活动内容" : dict[@"content"];
        self.like = [dict[@"reliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"reliableNumber"] integerValue];
        self.unlike = [dict[@"unReliableNumber"] isKindOfClass:[NSNull class]] ? 0 : [dict[@"unReliableNumber"] integerValue];
        self.isFavo = [dict[@"isFavo"]isKindOfClass:[NSNull class]]?   NO : [dict[@"isFavo"] boolValue ];

    }
       return self;
}
@end
