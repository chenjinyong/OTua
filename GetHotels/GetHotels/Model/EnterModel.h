//
//  EnterModel.h
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterModel : NSObject

@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * grade;
@property (strong,nonatomic) NSString * head;
@property (strong,nonatomic) NSString * userId;
@property (strong,nonatomic) NSString * cardId;
@property (strong,nonatomic) NSString * nickname;
@property (strong,nonatomic) NSString * openid;
@property (strong,nonatomic) NSString * password;
@property (strong,nonatomic) NSString * realname;
@property (nonatomic) NSTimeInterval * startTime;
@property (nonatomic) NSTimeInterval * startTimeStr;
@property (strong,nonatomic) NSString * tel;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
