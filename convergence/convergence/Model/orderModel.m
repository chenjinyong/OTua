//
//  orderModel.m
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "orderModel.h"

@implementation orderModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self ==[super init]) {
    _productName = [Utilities nullAndNilCheck:dict[@"productName"] replaceBy:@""];
    _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
    _imgUrl = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
    _orderNum = [Utilities nullAndNilCheck:dict[@"orderNum"] replaceBy:@""];
    _cardcomment = [Utilities nullAndNilCheck:dict[@"cardcomment"] replaceBy:@""];
    _type = [Utilities nullAndNilCheck:dict[@"type"] replaceBy:@""];
    _donepay = [Utilities nullAndNilCheck:dict[@"donepay"] replaceBy:@""];
    }
    return self;
}

@end
