//
//  FoundModel.h
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoundModel : NSObject
@property (strong,nonatomic) NSString * clubID;
@property (strong,nonatomic) NSString * clubAdd;
@property (strong,nonatomic) NSString * clubImageUrl;
@property (strong,nonatomic) NSString *Image;
@property (strong,nonatomic) NSString * clubJing;
@property (strong,nonatomic) NSString * clubWei;
@property (strong,nonatomic) NSString * clubName;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * address;
@property (strong,nonatomic) NSString * distance;
@property (nonatomic) NSInteger  clubDis;


//筛选类型
@property(strong,nonatomic)NSString *fId;//健身类型id
@property(strong,nonatomic)NSString *fName;//健身类型名称
@property(strong,nonatomic)NSString *total;//包含该健身类型的健身会所数量
-(instancetype)initWithSxNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithFindNSDictionary:(NSDictionary *)dict;
-(instancetype)initWithdisNSDictionary:(NSDictionary *)dict;

@end
