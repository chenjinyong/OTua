//
//  FoundModel.m
//  convergence
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "FoundModel.h"

@implementation FoundModel

-(instancetype)initWithFindNSDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        
        _clubAdd = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@"未知"];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@"未知"];
        _clubDis = [[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"0"]integerValue ];
        self.clubImageUrl = [dict[@"clubLogo"]isKindOfClass:[NSNull class]]?@[@""]:dict[@"clubLogo"];
        _clubID = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        _Image = [Utilities nullAndNilCheck:dict[@"Image"] replaceBy:@""];
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        _distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];

        
    }
    return self;
}

-(instancetype)initWithdisNSDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if(self){
        
        _clubAdd = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@"未知"];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@"未知"];
        _clubDis = [[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"0"]integerValue ];
        self.clubImageUrl = [dict[@"clubLogo"]isKindOfClass:[NSNull class]]?@[@""]:dict[@"clubLogo"];
        _clubID = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        _distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
    }
    return self;
}
-(instancetype)initWithSxNSDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if(self){
        _name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        _fId = [Utilities nullAndNilCheck:dict[@"fId"] replaceBy:@""];
        _fName = [Utilities nullAndNilCheck:dict[@"fName"] replaceBy:@""];
        _total = [Utilities nullAndNilCheck:dict[@"total"] replaceBy:@""];
        _address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        _distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        
    }
    return self;
}

@end
