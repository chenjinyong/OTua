//
//  FoundModel.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FoundModel.h"

@implementation FoundModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        _distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        _image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
        _logo = [Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        _orginPrice= [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""];
        self.models = [dict[@"models"]isKindOfClass:[NSNull class]]?@[@""]:dict[@"models"];
    }
    return self;
}

@end
