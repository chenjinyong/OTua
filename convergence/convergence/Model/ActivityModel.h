//
//  ActivityModel.h
//  convergence
//
//  Created by admin on 2017/9/18.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (strong,nonatomic) NSString *activityId;
@property (strong,nonatomic) NSString * imgURL;     //活动图片URL字符串
@property (strong,nonatomic) NSString * name;       //活动名称
@property (strong,nonatomic) NSString * content;    //活动内容
@property (nonatomic) NSInteger like;               //活动点赞数量
@property (nonatomic) NSInteger unlike;             //活动被踩数
@property (nonatomic) BOOL      isFavo;             //活动是否可以被收藏
@property (strong,nonatomic) NSString * address;
@property (strong,nonatomic) NSString * applyFee;
@property (strong,nonatomic) NSString * attendence;
@property (strong,nonatomic) NSString * limitation;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * issuer;
@property (strong,nonatomic) NSString * phone;
@property (nonatomic) NSTimeInterval dueTime;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic) NSInteger status;


- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithDetailDictionary:(NSDictionary *)dict;
@end
