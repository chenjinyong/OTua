//
//  VouchersModel.h
//  convergence
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VouchersModel : NSObject
@property (strong,nonatomic)NSString *eLogo;//图片
@property (strong,nonatomic)NSString *eName;//体验卡名字
@property (strong,nonatomic)NSString *currentPrice;//当前价格
@property (strong,nonatomic)NSString *orginPrice;//原价
@property (strong,nonatomic)NSString *endDate;//结束日期
@property (strong,nonatomic)NSString *beginDate;//起始日期
@property (strong,nonatomic)NSString *eAddress;//地址
@property (strong,nonatomic)NSString *eClubName;//俱乐部名字
@property (strong,nonatomic)NSString *clubTel;//俱乐部电话
@property (strong,nonatomic)NSString *saleCount;//已售
@property (strong,nonatomic)NSString *status;//温馨提示
@property (strong,nonatomic)NSString *useDate;//使用时间
@property (strong,nonatomic)NSString * rules;//使用规则
@property (strong,nonatomic)NSString * ePromot;//温馨提示
@property (strong,nonatomic)NSString *eFeature;//特色
@property (strong,nonatomic)NSString *experienceQuantity;//分店体验卷数量
@property (strong,nonatomic)NSString *longitude;//经度
@property (strong,nonatomic)NSString *latitude;//纬度



-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
