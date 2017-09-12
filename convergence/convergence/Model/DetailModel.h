//
//  DetailModel.h
//  convergence
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property (strong,nonatomic) NSString *clubAddressB;//地址
@property (strong,nonatomic) NSString *fId;//
@property (strong,nonatomic) NSString *fImgUrl;//图片
@property (strong,nonatomic) NSString *fName;//名字
@property (strong,nonatomic) NSString *grayImgUrl;//图片
@property (strong,nonatomic) NSString *greenImgUrl;//图片

@property (strong,nonatomic) NSString *clubJing;//经度
@property (strong,nonatomic) NSString *clubLogo;//图片
@property (strong,nonatomic) NSString *clubMember;//会员
@property (strong,nonatomic) NSString *clubMoods;//
@property (strong,nonatomic) NSString *clubName;//俱乐部名字
@property (strong,nonatomic) NSString *clubPerson;//教练
@property (strong,nonatomic) NSString *clubIntroduce;//介绍
@property (strong,nonatomic) NSString *openTime;//经度
@property (strong,nonatomic) NSString *clubSite;//面积

@property (strong,nonatomic) NSString *storeNums;//拥有分店数量
@property (strong,nonatomic) NSString *name;//经度
//@property (strong,nonatomic) NSString *clubSite;//经度
//@property (strong,nonatomic) NSString *clubSite;//经度
//@property (strong,nonatomic) NSString *clubSite;//经度
//@property (strong,nonatomic) NSString *clubSite;//经度

-(instancetype)initWithDictionary:(NSDictionary *)dict;



@end
