//
//  EnterModel.h
//  GetHotels
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterModel : NSObject

@property (strong,nonatomic) NSString * gender;             //性别
@property (strong,nonatomic) NSString * grade;              //星级
@property (strong,nonatomic) NSString * head;               //头像
@property (strong,nonatomic) NSString * userId;             //用户ID
@property (strong,nonatomic) NSString * cardId;             //
@property (strong,nonatomic) NSString * nickname;           //昵称
@property (strong,nonatomic) NSString * openid;             //开放id
@property (strong,nonatomic) NSString * password;           //密码
@property (strong,nonatomic) NSString * realname;           //真实姓名
@property (nonatomic) NSTimeInterval * startTime;           //开始时间
@property (nonatomic) NSTimeInterval * startTimeStr;        //
@property (strong,nonatomic) NSString * tel;                //账号电话
//@property (strong,nonatomic) NSString * phone;              //电话

- (id)initWithDictionary:(NSDictionary *)dict;

@end
