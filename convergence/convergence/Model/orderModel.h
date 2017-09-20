//
//  orderModel.h
//  convergence
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject
@property (strong, nonatomic) NSString * productName;
@property (strong, nonatomic) NSString * clubName;
@property (strong, nonatomic) NSString * imgUrl;
@property (strong, nonatomic) NSString * orderNum;
@property (strong, nonatomic) NSString * cardcomment;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * donepay;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
