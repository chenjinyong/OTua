//
//  UserModel.h
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong,nonatomic) NSString * memberId;    //用户ID
@property (strong,nonatomic) NSString * phone;       //手机号
@property (strong,nonatomic) NSString * nickname;    //昵称
@property (strong,nonatomic) NSString * age;         //年龄
@property (strong,nonatomic) NSString * dob;         //出身日期
@property (strong,nonatomic) NSString * idCardNo;    //身份证
@property (strong,nonatomic) NSString * gender;      //性别
@property (strong,nonatomic) NSString * credit;      //
@property (strong,nonatomic) NSString * avatarUrl;   //头像
@property (strong,nonatomic) NSString * tokenKey;    //

- (id)initWithDictionary:(NSDictionary *)dict;
@end
