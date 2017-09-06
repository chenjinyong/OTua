//
//  ConvergenceModel.m
//  convergence
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "ConvergenceModel.h"

@implementation ConvergenceModel
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        _address =[Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        _distance =[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        _orginPrice=[[Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""]integerValue];
        _categoryName = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        _id = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""];
        _Image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
        _logo = [Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        _categoryName = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
        _Price = [[Utilities nullAndNilCheck:dict[@"Price"] replaceBy:@""]integerValue];
    }
    return self;
}
@end
