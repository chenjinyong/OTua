//
//  orderModel.h
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject
@property (weak,nonatomic)NSString * productName;
@property (weak,nonatomic)NSString * clubName;
@property (weak,nonatomic)NSString * imgUrl;
@property (weak,nonatomic)NSString * orderNum;
@property (weak,nonatomic)NSString * cardcomment;
@property (weak,nonatomic)NSString * type;
@property (weak,nonatomic)NSString * donepay;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
